package com.example.service;

import java.sql.*;
import java.util.*;
import java.util.logging.Logger; 
import javax.sql.DataSource;

import com.example.dto.DataTableDetailPgsResult;
import com.example.utils.LoggerUtil;
import oracle.jdbc.OracleTypes;

public class MonPengerjaanPerProvUpiService {
    private DataSource dataSource;
    private static final Logger logger = LoggerUtil.getLogger(MonPengerjaanPerProvUpiService.class);

    public MonPengerjaanPerProvUpiService(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    
    public List<Map<String, Object>> getRkpPengerjaanPerUpi(String vtahun_laporan,  List<String> pesanOutput) {

        List<Map<String, Object>> result = new ArrayList<>();

        String sql = "{call LISDES.PKG_MONLAP_LISDES.RKP_PENGERJAAN_LISDES_PROV( ?, ?, ?)}";
       
        logger.info("Memulai panggilan prosedur Oracle Rekap : "+ sql );
        logger.info("Parameter vtahun_laporan: " + vtahun_laporan);
        
        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)) {
            
            stmt.setString(1, vtahun_laporan);
            stmt.registerOutParameter(2, OracleTypes.CURSOR); // out_data
            stmt.registerOutParameter(3, Types.VARCHAR);      // pesan

            stmt.execute();
            logger.info("Prosedur Utama berhasil dieksekusi");


            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                // Chek filed yg di tkirim dari backend
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i <= columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("URUT",rs.getString("URUT"));
                    row.put("TAHUN",rs.getString("TAHUN"));
                    row.put("KD_PROV",rs.getString("KD_PROV"));
                    row.put("PROVINSI",rs.getString("PROVINSI"));
                    row.put("JTR_RENCANA",rs.getString("JTR_RENCANA"));
                    row.put("JTM_RENCANA",rs.getString("JTM_RENCANA"));
                    row.put("GRD_RENCANA",rs.getString("GRD_RENCANA"));
                    row.put("JTR_WO",rs.getString("JTR_WO"));
                    row.put("JTM_WO",rs.getString("JTM_WO"));
                    row.put("GRD_WO",rs.getString("GRD_WO"));
                    row.put("JTR_PROGRES",rs.getString("JTR_PROGRES"));
                    row.put("JTM_PROGRES",rs.getString("JTM_PROGRES"));
                    row.put("GRD_PROGRES",rs.getString("GRD_PROGRES"));
                    row.put("JTR_KOREKSI",rs.getString("JTR_KOREKSI"));
                    row.put("JTM_KOREKSI",rs.getString("JTM_KOREKSI"));
                    row.put("GRD_KOREKSI",rs.getString("GRD_KOREKSI"));
                    row.put("JTR_PASANG",rs.getString("JTR_PASANG"));
                    row.put("JTM_PASANG",rs.getString("JTM_PASANG"));
                    row.put("GRD_PASANG",rs.getString("GRD_PASANG"));
                    row.put("JTR_PROSEN",rs.getString("JTR_PROSEN"));
                    row.put("JTM_PROSEN",rs.getString("JTM_PROSEN"));
                    row.put("GRD_PROSEN",rs.getString("GRD_PROSEN"));
                    // Tambahkan kolom lain jika diperlukan
                    result.add(row);
                }
            }

            String pesan = stmt.getString(3);
            pesanOutput.add(pesan);

        } catch (SQLException e) {
            logger.severe("Kesalahan database M_BPBLPRASURVEY_PROV: " + e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }

    public List<Map<String, Object>> getDataMDftPerUpi(int start, int length, String sortBy, String sortDir, String search,
                                                 String vtahun_laporan, String vkd_prov, String vinfolabel,  List<String> pesanOutput) {

        logger.info("Memulai panggilan prosedur monlap_mivfalg_plnvsbank_uiw_pgs Oracle dengan parameter TH BLN: " + vtahun_laporan);
        List<Map<String, Object>> result = new ArrayList<>();
       
        String sql = "{call LISDES.PKG_MONLAP_LISDES.DFT_PENGERJAAN_LISDES_PROV_PGS(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        // String sql = "{call LISDES.PKG_MONLAP_LISDES.DFT_PENGERJAAN_LISDES_PROV_PGS(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";
       
        logger.info("Memulai panggilan prosedur Oracle Daftar : "+ sql );
        logger.info("Parameter vtahun_laporan: " + vtahun_laporan);
        logger.info("Parameter vkd_prov: " + vkd_prov);
        logger.info("Parameter vinfolabel: " + vinfolabel);

        try (Connection conn = dataSource.getConnection();
             CallableStatement stmt = conn.prepareCall(sql)) {
             
            stmt.setInt(1, start);
            stmt.setInt(2, length);
            stmt.setString(3, sortDir); // DESC
            stmt.setString(4, sortBy);  // UNITUP
            stmt.setString(5, search);
            stmt.setString(6, vtahun_laporan);
            stmt.setString(7, vkd_prov);
            stmt.setString(8, vinfolabel);
            stmt.registerOutParameter(9, OracleTypes.CURSOR); // out_data
            stmt.registerOutParameter(10, Types.VARCHAR);      // pesan

            stmt.execute();
            logger.info("Prosedur Utama berhasil dieksekusi");


            try (ResultSet rs = (ResultSet) stmt.getObject(9)) {
                // Chek filed yg di tkirim dari backend
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i <= columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }
                // int rowNumber = 1;
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("TOTAL_COUNT",rs.getString("TOTAL_COUNT")==null?"":rs.getString("TOTAL_COUNT"));
                    row.put("INFOLABEL",rs.getString("INFOLABEL")==null?"":rs.getString("INFOLABEL"));
                    row.put("KATEGORI_PEMBANGUNAN",rs.getString("KATEGORI_PEMBANGUNAN")==null?"":rs.getString("KATEGORI_PEMBANGUNAN"));
                    row.put("TRANSMISI",rs.getString("TRANSMISI")==null?"":rs.getString("TRANSMISI"));
                    row.put("MATERIAL_GROUP_ID",rs.getString("MATERIAL_GROUP_ID")==null?"":rs.getString("MATERIAL_GROUP_ID"));
                    row.put("MATERIAL_GROUP",rs.getString("MATERIAL_GROUP")==null?"":rs.getString("MATERIAL_GROUP"));
                    row.put("KODE_MATERIAL",rs.getString("KODE_MATERIAL")==null?"":rs.getString("KODE_MATERIAL"));
                    row.put("NAMA_MATERIAL",rs.getString("NAMA_MATERIAL")==null?"":rs.getString("NAMA_MATERIAL"));
                    row.put("JUMLAH_MDU",rs.getString("JUMLAH_MDU")==null?"":rs.getString("JUMLAH_MDU"));
                    row.put("SATUAN",rs.getString("SATUAN")==null?"":rs.getString("SATUAN"));
                    row.put("TAHUN",rs.getString("TAHUN")==null?"":rs.getString("TAHUN"));
                    row.put("KD_PROV",rs.getString("KD_PROV")==null?"":rs.getString("KD_PROV"));
                    row.put("PROVINSI",rs.getString("PROVINSI")==null?"":rs.getString("PROVINSI"));
                    row.put("KD_KAB",rs.getString("KD_KAB")==null?"":rs.getString("KD_KAB"));
                    row.put("KABUPATENKOTA",rs.getString("KABUPATENKOTA")==null?"":rs.getString("KABUPATENKOTA"));
                    row.put("KD_KEC",rs.getString("KD_KEC")==null?"":rs.getString("KD_KEC"));
                    row.put("KECAMATAN",rs.getString("KECAMATAN")==null?"":rs.getString("KECAMATAN"));
                    row.put("KD_KEL",rs.getString("KD_KEL")==null?"":rs.getString("KD_KEL"));
                    row.put("DESAKELURAHAN",rs.getString("DESAKELURAHAN")==null?"":rs.getString("DESAKELURAHAN"));
                    row.put("UNITUPI",rs.getString("UNITUPI")==null?"":rs.getString("UNITUPI"));
                    row.put("NAMA_UNITUPI",rs.getString("NAMA_UNITUPI")==null?"":rs.getString("NAMA_UNITUPI"));
                    row.put("UNITAP",rs.getString("UNITAP")==null?"":rs.getString("UNITAP"));
                    row.put("NAMA_UNITAP",rs.getString("NAMA_UNITAP")==null?"":rs.getString("NAMA_UNITAP"));
                    row.put("UNITUP",rs.getString("UNITUP")==null?"":rs.getString("UNITUP"));
                    row.put("NAMA_UNITUP",rs.getString("NAMA_UNITUP")==null?"":rs.getString("NAMA_UNITUP"));
                    row.put("ID_PERENCANAAN",rs.getString("ID_PERENCANAAN")==null?"":rs.getString("ID_PERENCANAAN"));
                    row.put("NOMOR_KONTRAK",rs.getString("NOMOR_KONTRAK")==null?"":rs.getString("NOMOR_KONTRAK"));
                    row.put("NOMOR_KONTRAK_RINCI",rs.getString("NOMOR_KONTRAK_RINCI")==null?"":rs.getString("NOMOR_KONTRAK_RINCI"));
                    row.put("KODE_PEMBANGUNAN",rs.getString("KODE_PEMBANGUNAN")==null?"":rs.getString("KODE_PEMBANGUNAN"));
                    row.put("ROW_NUMBER",rs.getString("ROW_NUMBER")==null?"":rs.getString("ROW_NUMBER"));
                    // System.out.println("Row ke-" + rowNumber + ": " + row);
                    // rowNumber++;
                    result.add(row);
                }
            }

            String pesan = stmt.getString(10);
            pesanOutput.add(pesan);

        } catch (SQLException e) {
            logger.severe("Kesalahan database: " + e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }

    public DataTableDetailPgsResult getDataMDftPerUpiv3(
            int start,
            int length,
            String sortBy,
            String sortDir,
            String search,
            String vtahun_laporan,
            String vkd_prov,
            String vinfolabel,
            List<String> pesanOutput
    ) {

        logger.info("Memulai panggilan prosedur V3 DFT_PENGERJAAN_LISDES_PROV_PGSV3");

        List<Map<String, Object>> dataList = new ArrayList<>();
        List<Map<String, Object>> metaList = new ArrayList<>();
        int totalItems = 0;

        String sql = "{call LISDES.PKG_MONLAP_LISDES.DFT_PENGERJAAN_LISDES_PROV_PGSV3(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)) {

            /* ================= INPUT ================= */
            stmt.setInt(1, start);
            stmt.setInt(2, length);
            stmt.setString(3, sortBy);
            stmt.setString(4, sortDir);
            stmt.setString(5, search);
            stmt.setString(6, vtahun_laporan);
            stmt.setString(7, vkd_prov);
            stmt.setString(8, vinfolabel);

            /* ================= OUTPUT ================= */
            stmt.registerOutParameter(9, OracleTypes.CURSOR);   // DATA
            stmt.registerOutParameter(10, OracleTypes.CURSOR); // META
            stmt.registerOutParameter(11, Types.VARCHAR);      // PESAN

            stmt.execute();

            /* ================= DATA ================= */
            try (ResultSet rs = (ResultSet) stmt.getObject(9)) {
                // --Chek filed yg di tkirim dari backend
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i <= columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    row.put("INFOLABEL",rs.getString("INFOLABEL")==null?"":rs.getString("INFOLABEL"));
                    row.put("NOMOR_KONTRAK_RINCI",rs.getString("NOMOR_KONTRAK_RINCI")==null?"":rs.getString("NOMOR_KONTRAK_RINCI"));
                    row.put("KATEGORI_PEMBANGUNAN",rs.getString("KATEGORI_PEMBANGUNAN")==null?"":rs.getString("KATEGORI_PEMBANGUNAN"));
                    row.put("TRANSMISI",rs.getString("TRANSMISI")==null?"":rs.getString("TRANSMISI"));
                    row.put("MATERIAL_GROUP",rs.getString("MATERIAL_GROUP")==null?"":rs.getString("MATERIAL_GROUP"));
                    row.put("KODE_MATERIAL",rs.getString("KODE_MATERIAL")==null?"":rs.getString("KODE_MATERIAL"));
                    row.put("NAMA_MATERIAL",rs.getString("NAMA_MATERIAL")==null?"":rs.getString("NAMA_MATERIAL"));
                    row.put("JUMLAH_MDU",rs.getString("JUMLAH_MDU")==null?"":rs.getString("JUMLAH_MDU"));
                    row.put("SATUAN",rs.getString("SATUAN")==null?"":rs.getString("SATUAN"));
                    row.put("ID_TIANG",rs.getString("ID_TIANG")==null?"":rs.getString("ID_TIANG"));
                    row.put("STATUS",rs.getString("STATUS")==null?"":rs.getString("STATUS"));
                    row.put("TAHUN",rs.getString("TAHUN")==null?"":rs.getString("TAHUN"));
                    row.put("KD_PROV",rs.getString("KD_PROV")==null?"":rs.getString("KD_PROV"));
                    row.put("PROVINSI",rs.getString("PROVINSI")==null?"":rs.getString("PROVINSI"));
                    row.put("KD_KAB",rs.getString("KD_KAB")==null?"":rs.getString("KD_KAB"));
                    row.put("KABUPATENKOTA",rs.getString("KABUPATENKOTA")==null?"":rs.getString("KABUPATENKOTA"));
                    row.put("KD_KEC",rs.getString("KD_KEC")==null?"":rs.getString("KD_KEC"));
                    row.put("KECAMATAN",rs.getString("KECAMATAN")==null?"":rs.getString("KECAMATAN"));
                    row.put("KD_KEL",rs.getString("KD_KEL")==null?"":rs.getString("KD_KEL"));
                    row.put("DESAKELURAHAN",rs.getString("DESAKELURAHAN")==null?"":rs.getString("DESAKELURAHAN"));
                    row.put("UNITUPI",rs.getString("UNITUPI")==null?"":rs.getString("UNITUPI"));
                    row.put("UNITAP",rs.getString("UNITAP")==null?"":rs.getString("UNITAP"));
                    row.put("UNITUP",rs.getString("UNITUP")==null?"":rs.getString("UNITUP"));
                    row.put("ID_PERENCANAAN",rs.getString("ID_PERENCANAAN")==null?"":rs.getString("ID_PERENCANAAN"));
                    row.put("NOMOR_KONTRAK",rs.getString("NOMOR_KONTRAK")==null?"":rs.getString("NOMOR_KONTRAK"));
                    row.put("KODE_PEMBANGUNAN",rs.getString("KODE_PEMBANGUNAN")==null?"":rs.getString("KODE_PEMBANGUNAN"));
                    row.put("MATERIAL_GROUP_ID",rs.getString("MATERIAL_GROUP_ID")==null?"":rs.getString("MATERIAL_GROUP_ID"));
                    row.put("ROW_ITEMS",rs.getString("ROW_ITEMS")==null?"":rs.getString("ROW_ITEMS"));
                    row.put("TOTAL_ITEMS",rs.getString("TOTAL_ITEMS")==null?"":rs.getString("TOTAL_ITEMS"));

                    dataList.add(row);
                }
            }

            /* ================= META ================= */
            try (ResultSet rsMeta = (ResultSet) stmt.getObject(10)) {
                if (rsMeta.next()) {
                    Map<String, Object> meta = new HashMap<>();
                    meta.put("page", rsMeta.getInt("PAGE"));
                    meta.put("size", rsMeta.getInt("SIZE"));
                    meta.put("total_items", rsMeta.getInt("TOTAL_ITEMS"));
                    meta.put("total_pages", rsMeta.getInt("TOTAL_PAGES"));

                    totalItems = rsMeta.getInt("TOTAL_ITEMS");
                    metaList.add(meta);
                }
            }

            pesanOutput.add(stmt.getString(11));

        } catch (SQLException e) {
            logger.severe("Kesalahan database: " + e.getMessage());
            pesanOutput.add("Error DB: " + e.getMessage());
        }

        DataTableDetailPgsResult result = new DataTableDetailPgsResult();
        result.setData(dataList);
        result.setMeta(metaList);
        result.setTotalItems(totalItems);

        return result;
    }

    // public Map<String, Object> getDataBank(String kdbank) throws SQLException {
    //     Map<String, Object> result = new HashMap<>();

    //     try (
    //         Connection conn = dataSource.getConnection();
    //         CallableStatement stmt = conn.prepareCall("{call OPHARTDE.VER_MON_LAP.GET_combo_BANK_MIV(?, ?, ?)}")
    //     ) {
    //         stmt.setString(1, kdbank);
    //         stmt.registerOutParameter(2, OracleTypes.CURSOR);
    //         stmt.registerOutParameter(3, Types.VARCHAR);
    //         stmt.execute();

    //         try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
    //             if (rs.next()) {
    //                 result.put("KODE_ERP", rs.getString("KODE_ERP"));
    //                 result.put("KODE_BANK", rs.getString("KODE_BANK"));
    //                 result.put("NAMA_BANK", rs.getString("NAMA_BANK"));
    //                 result.put("STATUS", rs.getString("STATUS"));
    //             }
    //         }
    //     }

    //     return result;
    // }

    public Map<String, Object> getDataUnitUPI(String kd_dist) throws SQLException {
        Map<String, Object> result = new HashMap<>();

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall("{call OPHARTDE.VER_MON_LAP.GET_combo_UNITUPI(?, ?, ?)}")
        ) {
            stmt.setString(1, kd_dist);
            stmt.registerOutParameter(2, OracleTypes.CURSOR);
            stmt.registerOutParameter(3, Types.VARCHAR);
            stmt.execute();

            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                if (rs.next()) {
                    result.put("KD_DIST", rs.getString("KD_DIST"));
                    result.put("NAMA_DIST", rs.getString("NAMA_DIST"));
                }
            }
        }

        return result;
    }

}
