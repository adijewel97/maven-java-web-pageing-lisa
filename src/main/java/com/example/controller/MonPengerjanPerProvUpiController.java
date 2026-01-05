package com.example.controller;

import com.example.service.DbService;
import com.example.service.MonPengerjaanPerProvUpiService;
import com.example.utils.LoggerUtil;
import com.example.dto.DataTableDetailPgsResult;

import com.google.gson.Gson;

import javax.servlet.ServletException;
// import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;


// @WebServlet(name = "MonPengerjanPerProvUpiController", urlPatterns = {"/mon-pengerjaan-perprovupi"})
public class MonPengerjanPerProvUpiController extends HttpServlet {
    private MonPengerjaanPerProvUpiService service;
    private static final Logger logger = LoggerUtil.getLogger(MonPengerjanPerProvUpiController.class);
    private final Gson gson = new Gson();

    // private static final String ACT_JENIS_LAPORAN = "handleGetJenisLaporan";
    // private static final String ACT_SUMBER_DATA = "handleGetsumberdata";

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            DbService dbService = new DbService();
            service = new MonPengerjaanPerProvUpiService(dbService.getDataSource());
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal inisialisasi koneksi DB di init()", e);
            throw new ServletException("Gagal inisialisasi koneksi DB", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String act = req.getParameter("act");

        if ("detailData".equalsIgnoreCase(act)) {
            handleGetDetailData(req, resp);
            return;
        }

        if ("detailDatav3".equalsIgnoreCase(act)) {
            handleGetDetailDatav3(req, resp);
            return;
        }   

        // if ("getNamaBank".equalsIgnoreCase(act)) {
        //     handleGetNamaBank(req, resp);
        //     return;
        // }

        if ("getNamaUnitUPI".equalsIgnoreCase(act)) {
            handleGetNamaUnitUPI(req, resp);
            return;
        }     

        // Default
        prosesMonRkpPerProvUpi(req, resp);
    }

    private void prosesMonRkpPerProvUpi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String vtahun_laporan = req.getParameter("vtahun_laporan");
        int vkode;

        // WAJIB untuk DataTables server-side
        int draw = Integer.parseInt(req.getParameter("draw") != null ? req.getParameter("draw") : "1");

        logger.info("vtahun_laporan: " + vtahun_laporan);
        // logger.info("vtahun: " + vtahun);

        List<Map<String, Object>> data = Collections.emptyList();
        int totalCount = 0;
        String pesan;

       try {
            List<String> pesanOutput = new ArrayList<>();
            data = service.getRkpPengerjaanPerUpi(vtahun_laporan, pesanOutput);
            logger.info("Jumlah data dikembalikan: " + data.size());

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

    private void handleGetDetailData(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int draw = 1;
        try {
            draw = Integer.parseInt(req.getParameter("draw"));
        } catch (NumberFormatException e) {
            logger.info("Parameter 'draw' tidak ditemukan atau tidak valid. Default: 1");
        }

        int startIndex = Integer.parseInt(req.getParameter("start")); // 0, 10, ...
        int length = Integer.parseInt(req.getParameter("length"));
        int start = (startIndex / length) + 1;

        String sortColumnIndex = req.getParameter("order[0][column]");
        String sortDir = req.getParameter("order[0][dir]");
        String searchValue = req.getParameter("search[value]");

        String sortBy = req.getParameter("columns[" + sortColumnIndex + "][data]");
        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy = "MATERIAL_GROUP_ID";
            sortDir = "ASC";
        }

        String vtahun_laporan = req.getParameter("vtahun_laporan");
        String vkd_prov       = req.getParameter("vkd_prov");
        String vinfolabel     = req.getParameter("vinfolabel");

        logger.info("draw = " + draw);
        logger.info("offset (startIndex) = " + startIndex);
        logger.info("limit (length) = " + length);
        logger.info("sortBy = " + sortBy + " " + sortDir);
        logger.info("searchValue = " + searchValue);
        logger.info("vtahun_laporan = " + vtahun_laporan);
        logger.info("vkd_prov = " + vkd_prov);
        logger.info("vinfolabel = " + vinfolabel);

        List<String> pesanOutput = new ArrayList<>();

        List<Map<String, Object>> data = service.getDataMDftPerUpi(
            start, length, sortBy, sortDir, searchValue, vtahun_laporan, vkd_prov, vinfolabel, pesanOutput
        );

        System.out.println("Jumlah data yang dikembalikan untuk ekspor: " + data.size());

        int totalRecords = 0;
        if (!data.isEmpty() && data.get(0).get("TOTAL_COUNT") != null) {
            totalRecords = Integer.parseInt(data.get(0).get("TOTAL_COUNT").toString());
        }

        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw);
        jsonResponse.put("recordsTotal", totalRecords);
        jsonResponse.put("recordsFiltered", totalRecords);
        jsonResponse.put("data", data);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }
    }

    // -- v3 (SUDAH SESUAI DataTableResult)
    private void handleGetDetailDatav3(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        int draw = 1;
        try {
            draw = Integer.parseInt(req.getParameter("draw"));
        } catch (Exception e) {
            logger.info("Parameter draw tidak valid, default = 1");
        }

        int startIndex = Integer.parseInt(req.getParameter("start"));   // 0,10,20
        int length     = Integer.parseInt(req.getParameter("length"));  // 10
        int start      = (startIndex / length) + 1;                     // page Oracle

        /* ================= SORT ================= */
        String sortColumnIndex = req.getParameter("order[0][column]");
        String sortDir         = req.getParameter("order[0][dir]");
        String sortBy          = req.getParameter("columns[" + sortColumnIndex + "][data]");

        if (sortBy == null || sortBy.trim().isEmpty()) {
            sortBy  = "NOMOR_KONTRAK_RINCI";
            sortDir = "ASC";
        }

        /* ================= SEARCH ================= */
        String searchValue = req.getParameter("search[value]");

        /* ================= FILTER ================= */
        String vtahun_laporan = req.getParameter("vtahun_laporan");
        String vkd_prov       = req.getParameter("vkd_prov");
        String vinfolabel     = req.getParameter("vinfolabel");

        logger.info("draw=" + draw);
        logger.info("start=" + start + ", length=" + length);
        logger.info("sort=" + sortBy + " " + sortDir);
        logger.info("search=" + searchValue);

        List<String> pesanOutput = new ArrayList<>();

        /* ================= CALL SERVICE ================= */
        DataTableDetailPgsResult result = service.getDataMDftPerUpiv3(
                start,
                length,
                sortBy,
                sortDir,
                searchValue,
                vtahun_laporan,
                vkd_prov,
                vinfolabel,
                pesanOutput
        );

        /* ================= RESPONSE DATATABLES ================= */
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("draw", draw);
        jsonResponse.put("recordsTotal", result.getTotalItems());
        jsonResponse.put("recordsFiltered", result.getTotalItems());
        jsonResponse.put("data", result.getData());

        // (opsional) debugging
        jsonResponse.put("meta", result.getMeta());
        jsonResponse.put("message", pesanOutput);

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(jsonResponse));
        }
    }

    // private void handleGetNamaBank(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    //     String kdbank = req.getParameter("kdbank");
    //     Map<String, Object> result = new HashMap<>();

    //     resp.setContentType("application/json");
    //     resp.setCharacterEncoding("UTF-8");

    //     try (PrintWriter out = resp.getWriter()) {
    //         Map<String, Object> UnitUPIData = service.getDataBank(kdbank); // Panggil ke service
    //         result.put("status", "success");
    //         result.put("data", UnitUPIData);
    //         out.print(gson.toJson(result));
    //     } catch (Exception e) {
    //         logger.log(Level.SEVERE, "Gagal ambil nama bank", e);
    //         result.put("status", "error");
    //         result.put("message", "Gagal mengambil data bank");
    //         try (PrintWriter out = resp.getWriter()) {
    //             out.print(gson.toJson(result));
    //         }
    //     }
    // }

    private void handleGetNamaUnitUPI(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String kd_dist = req.getParameter("kd_dist");
        Map<String, Object> result = new HashMap<>();

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try (PrintWriter out = resp.getWriter()) {
            Map<String, Object> UnitUPIData = service.getDataUnitUPI(kd_dist); // Panggil ke service
            result.put("status", "success");
            result.put("data", UnitUPIData);
            out.print(gson.toJson(result));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Gagal ambil nama bank", e);
            result.put("status", "error");
            result.put("message", "Gagal mengambil data bank");
            try (PrintWriter out = resp.getWriter()) {
                out.print(gson.toJson(result));
            }
        }
    }
       
    // public static void main(String[] args) {
    //     try {
    //         // Setup
    //         DbService dbService = new DbService();
    //         MonPengerjaanPerProvUpiService service = new MonPengerjaanPerProvUpiService(dbService.getDataSource());

    //         // Cek mode run: "rekap" atau "detail"
    //         String mode = "detail"; //(args.length > 0) ? args[0] : "rekap";

    //         List<String> pesanOutput = new ArrayList<>();

    //         if ("detail".equalsIgnoreCase(mode)) {
    //             System.out.println("== TEST MODE: DETAIL ==");

    //             // Parameter detail
    //             int start = 1;
    //             int length = 10;
    //             String sortBy = "KD_DIST";
    //             String sortDir = "ASC";
    //             String search = "";
    //             String vtahun_laporan = "202505";
    //             String vinfolabel = "XXXXX";

    //             List<Map<String, Object>> detail = service.getDataMDftPerUpi(
    //                     start, length, sortBy, sortDir, search,
    //                     vtahun_laporan, vinfolabel, pesanOutput
    //             );

    //             System.out.println("Jumlah data detail: " + detail.size());

    //             for (Map<String, Object> row : detail) {
    //                 System.out.println(row);
    //             }

    //         } else {
    //             System.out.println("== TEST MODE: REKAP ==");

    //             String vtahun_laporan = "202505";
    //             List<Map<String, Object>> rekap = service.getRkpPengerjaanPerUpi(vtahun_laporan, pesanOutput);

    //             for (Map<String, Object> row : rekap) {
    //                 System.out.println(row);
    //             }
    //         }

    //         System.out.println("Pesan Output: " + (pesanOutput.isEmpty() ? "Tidak ada pesan" : pesanOutput.get(0)));

    //     } catch (Exception e) {
    //         System.err.println("Error saat testing: " + e.getMessage());
    //         e.printStackTrace();
    //     }
    // }
}
