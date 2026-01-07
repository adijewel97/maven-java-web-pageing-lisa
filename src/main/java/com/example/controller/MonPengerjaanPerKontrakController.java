package com.example.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.example.service.DbService;
import com.example.service.MonMaterialPerKontrakService;
import com.example.utils.LoggerUtil;
import com.google.gson.Gson;

@WebServlet(name="MonPengerjaanPerKontrakController", urlPatterns = {"/mon-pengerjaan-perkontrak"})
public class MonPengerjaanPerKontrakController extends HttpServlet {
    private MonMaterialPerKontrakService service;
    private static final Logger logger = LoggerUtil.getLogger(MonPengerjaanPerKontrakController.class);
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException{
        super.init();
        try{
            DbService dbservice = new DbService();
            service = new MonMaterialPerKontrakService(dbservice.getDataSource());
        } catch (Exception e){
            logger.log(Level.SEVERE, "Gagal inisilisasi koneksi Db di init()", e);
            throw new ServletException("Gagal inisislisasi koneksi DB ", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp ) throws ServletException, IOException {
         prosesMonRKPPerKontrak(req, resp);
    }

    private void prosesMonRKPPerKontrak(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String vtahun_laporan = req.getParameter("vtahun_laporan");
        String vkd_prov       = req.getParameter("vkd_prov");
        String vkd_kab        = req.getParameter("vkd_kab");
        String vkd_kec        = req.getParameter("vkd_kec");
        String vkd_kel        = req.getParameter("vkd_kel");

        int vkode;

        // WAJIB untuk DataTables server-side
        int draw = Integer.parseInt(req.getParameter("draw") != null ? req.getParameter("draw") : "1");
        
        logger.info("vtahun_laporan" + vtahun_laporan);

        List<Map<String, Object>> data = Collections.emptyList();
        int totalCount = 0;
        String pesan;
       
        try {
            List<String> pesanOutput = new ArrayList<>();
            data = service.GetRkpMaterialPerKontrak(vtahun_laporan, 
                vkd_prov, vkd_kab, vkd_kec, vkd_kel, pesanOutput);
            logger.info("Jumalah data yg dikembalikan "+data.size());  
            String pesanRaw = pesanOutput.isEmpty() ? "" : pesanOutput.get(0).toLowerCase().trim();
            if (pesanRaw.contains("kesalahan")) {
                vkode = 402;
                pesan = "Error:"+pesanOutput.get(0);
                data = new ArrayList<>();
            } else {
                totalCount = data.size();
                vkode = 200;
                pesan = "Sukses: Tampikan data";
            }
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error: Gagal mendapatkan data: " + e.getMessage(), e);
            vkode = 402;
            pesan = "Error: Terjadi kesalahan: " + e.getMessage();
        }

        // Format JSON sesuai DataTables server-side
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw); // WAJIB
        jsonResponse.put("recordsTotal", totalCount); // WAJIB
        jsonResponse.put("recordsFiltered", totalCount); // WAJIB
        jsonResponse.put("data", data); // WAJIB
        jsonResponse.put("status", "success");
        jsonResponse.put("kode", vkode);
        jsonResponse.put("pesan", pesan);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }

    }

}
