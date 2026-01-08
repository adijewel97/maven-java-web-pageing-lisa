package com.example.service;


import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;
import javax.sql.DataSource;
import com.example.utils.LoggerUtil;

import oracle.jdbc.OracleTypes;

public class MonMaterialPerKontrakService {
    private DataSource dataSource;
    private static final Logger logger = LoggerUtil.getLogger(MonMaterialPerKontrakService.class);
    
    public MonMaterialPerKontrakService (DataSource dataSource){
        this.dataSource = dataSource;
    }

    public List<Map<String, Object>> GetRkpMaterialPerKontrak(
                    String vtahun_laporan,
                    String vkd_prov, 
                    String vkd_kab, 
                    String vkd_kec, 
                    String vkd_kel, 
                    List<String> pesanOutput){
        
        List<Map<String, Object>>  result = new ArrayList<>();

        String sql = "{call LISDES.PKG_MONLAP_LISDES.RKP_PENGERJAAN_LISDES_PROV_LOKASI( ?, ?, ?, ?, ?, ?, ?)}";

        logger.info("Memulai panggilan prosedur Oracle Rekap : "+ sql );
        logger.info("Parameter vtahun_laporan: "    + vtahun_laporan);
        logger.info("Parameter vkd_prov: "          + vkd_prov);
        logger.info("Parameter vkd_kab: "           + vkd_kab );
        logger.info("Parameter vkd_kec: "           + vkd_kec );
        logger.info("Parameter vkd_kel: "           + vkd_kel );

        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql) ){             
            stmt.setString(1, vtahun_laporan);
            stmt.setString(2, vkd_prov );
            stmt.setString(3, vkd_kab  );
            stmt.setString(4, vkd_kec  );
            stmt.setString(5, vkd_kel  );
            stmt.registerOutParameter(6, OracleTypes.CURSOR);
            stmt.registerOutParameter( 7, Types.VARCHAR);

            stmt.execute();
            logger.info("Prosedur Utama berhasil dieksekusi");

            try ( ResultSet rs = (ResultSet) stmt.getObject(6) ) {
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i< columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("TAHUN",rs.getString("TAHUN"));
                    row.put("NOMOR_KONTRAK_RINCI",rs.getString("NOMOR_KONTRAK_RINCI"));
                    row.put("KD_PROV",rs.getString("KD_PROV"));
                    row.put("PROVINSI",rs.getString("PROVINSI"));
                    row.put("KD_KAB",rs.getString("KD_KAB"));
                    row.put("KABUPATENKOTA",rs.getString("KABUPATENKOTA"));
                    row.put("KD_KEC",rs.getString("KD_KEC"));
                    row.put("KECAMATAN",rs.getString("KECAMATAN"));
                    row.put("KD_KEL",rs.getString("KD_KEL"));
                    row.put("DESAKELURAHAN",rs.getString("DESAKELURAHAN"));
                    row.put("ID_WO_PETUGAS",rs.getString("ID_WO_PETUGAS"));
                    row.put("LONGITUDE_LOKASI",rs.getString("LONGITUDE_LOKASI"));
                    row.put("LATITUDE_LOKASI",rs.getString("LATITUDE_LOKASI"));
                    row.put("TGL_SELESAI",rs.getString("TGL_SELESAI"));
                    row.put("STATUS",rs.getString("STATUS"));
                    row.put("PATH_FOTO1",rs.getString("PATH_FOTO1"));
                    row.put("PATH_FOTO2",rs.getString("PATH_FOTO2"));
                    row.put("PATH_FOTO3",rs.getString("PATH_FOTO3"));
                    row.put("PATH_FOTO4",rs.getString("PATH_FOTO4"));
                    row.put("PATH_FOTO5",rs.getString("PATH_FOTO5"));
                    row.put("PATH_FOTO6",rs.getString("PATH_FOTO6"));
                    row.put("PATH_FOTO7",rs.getString("PATH_FOTO7"));
                    row.put("KETERANGAN",rs.getString("KETERANGAN"));

                    result.add(row);
                }

                String pesan = stmt.getString(7);
                pesanOutput.add(pesan);
            }

        } catch (SQLException e) {
            logger.severe("Kesalahan database M_BPBLPRASURVEY_PROV: " +e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }

    public List<Map<String, Object>> GetDftMaterialPerKontrak(
                    String vtahun_laporan,
                    String vkd_prov, 
                    String vkd_kab, 
                    String vkd_kec, 
                    String vkd_kel,
                    String vnomor_kontrak_rinci,
                    List<String> pesanOutput){
        
        List<Map<String, Object>>  result = new ArrayList<>();

        String sql = "{call LISDES.PKG_MONLAP_LISDES.DFT_PENGERJAAN_LISDES_PROV_LOKASI( ?, ?, ?, ?, ?, ?, ?, ?)}";

        logger.info("Memulai panggilan prosedur Oracle Rekap : "+ sql );
        logger.info("Parameter vtahun_laporan: "    + vtahun_laporan);
        logger.info("Parameter vkd_prov: "          + vkd_prov);
        logger.info("Parameter vkd_kab: "           + vkd_kab );
        logger.info("Parameter vkd_kec: "           + vkd_kec );
        logger.info("Parameter vkd_kel: "           + vkd_kel );
        logger.info("Parameter vnomor_kontrak_rinci: "           + vnomor_kontrak_rinci );

        try (Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql) ){             
            stmt.setString(1, vtahun_laporan);
            stmt.setString(2, vkd_prov );
            stmt.setString(3, vkd_kab  );
            stmt.setString(4, vkd_kec  );
            stmt.setString(5, vkd_kel  );
            stmt.setString(6, vnomor_kontrak_rinci  );
            stmt.registerOutParameter(7, OracleTypes.CURSOR);
            stmt.registerOutParameter( 8, Types.VARCHAR);

            stmt.execute();
            logger.info("Prosedur Utama berhasil dieksekusi");

            try ( ResultSet rs = (ResultSet) stmt.getObject(7) ) {
                // ResultSetMetaData meta = rs.getMetaData();
                // int columnCount = meta.getColumnCount();
                // for (int i = 1; i< columnCount; i++) {
                //     System.out.println(meta.getColumnName(i));
                // }


                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("TAHUN",rs.getString("TAHUN"));
                    row.put("NOMOR_KONTRAK_RINCI",rs.getString("NOMOR_KONTRAK_RINCI"));
                    row.put("KATEGORI_PEMBANGUNAN",rs.getString("KATEGORI_PEMBANGUNAN"));
                    row.put("MATERIAL_GROUP",rs.getString("MATERIAL_GROUP"));
                    row.put("KODE_MATERIAL",rs.getString("KODE_MATERIAL"));
                    row.put("PENGGUNAAN",rs.getString("PENGGUNAAN"));
                    row.put("NAMA_MATERIAL",rs.getString("NAMA_MATERIAL"));
                    row.put("VOLUME_RENCANA",rs.getString("VOLUME_RENCANA"));
                    row.put("VOLUME_TERPASANG",rs.getString("VOLUME_TERPASANG"));
                    row.put("SATUAN",rs.getString("SATUAN"));

                    result.add(row);
                }

                String pesan = stmt.getString(8);
                pesanOutput.add(pesan);
            }

        } catch (SQLException e) {
            logger.severe("Kesalahan database M_BPBLPRASURVEY_PROV: " +e.getMessage());
            pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
        }

        return result;
    }
}
