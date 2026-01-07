package com.example.service;

import oracle.jdbc.OracleTypes;
import java.sql.*;
import java.util.*;
import javax.sql.DataSource;

public class MstGlobalService {
    private final DataSource dataSource;

    public MstGlobalService(DataSource dataSource) {
         this.dataSource = dataSource;
    }

    public List<Map<String, Object>> getDataUnitUPI(String kd_dist) throws SQLException {
        List<Map<String, Object>> resultList = new ArrayList<>();

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall("{call OPHARTDE.VER_MON_LAP.GET_combo_UNITUPI(?, ?, ?)}")
        ) {
            // Jika ALL/null → ambil semua distribusi
            if (kd_dist == null || kd_dist.trim().isEmpty() || "ALL".equalsIgnoreCase(kd_dist)) {
                stmt.setNull(1, Types.VARCHAR);
            } else {
                stmt.setString(1, kd_dist);
            }

            stmt.registerOutParameter(2, OracleTypes.CURSOR);
            stmt.registerOutParameter(3, Types.VARCHAR);
            stmt.execute();

            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("KD_DIST", rs.getString("KD_DIST"));
                    row.put("NAMA_DIST", rs.getString("NAMA_DIST"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }

    public List<Map<String, Object>> getDataAreaUP3(String kd_dist) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall("{call OPHARTDE.VER_MON_LAP.GET_combo_UNITAP(?, ?, ?)}")
        ) {

            // Parameter 1: IN
            if (kd_dist == null || kd_dist.trim().isEmpty() || "ALL".equalsIgnoreCase(kd_dist)) {
                stmt.setNull(1, Types.VARCHAR);
            } else {
                stmt.setString(1, kd_dist);
            }

            // Parameter 2: OUT cursor
            stmt.registerOutParameter(2, OracleTypes.CURSOR);

            // Parameter 3: OUT pesan (VARCHAR)
            stmt.registerOutParameter(3, Types.VARCHAR);

            stmt.execute();

            // Ambil cursor
            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("UNITAP", rs.getString("UNITAP"));
                    row.put("NAMA_AREA", rs.getString("NAMA_AREA"));
                    list.add(row);
                }
            }

            // Kalau butuh pesan
            String pesan = stmt.getString(3);
            System.out.println("Pesan OUT: " + pesan+"-"+kd_dist);

        }

        return list;
    }

    public List<Map<String, Object>> getMasterBank(String kdbank) throws SQLException {
        List<Map<String, Object>> resultList = new ArrayList<>();

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall("{call OPHARTDE.VER_MON_LAP.GET_combo_BANK_MIV(?, ?, ?)}")
        ) {
            // Jika parameter null, kosong, atau 'SEMUA' → ambil semua data
            if (kdbank == null || kdbank.trim().isEmpty() || "SEMUA".equalsIgnoreCase(kdbank)) {
                stmt.setNull(1, Types.VARCHAR);
            } else {
                stmt.setString(1, kdbank);
            }

            stmt.registerOutParameter(2, OracleTypes.CURSOR);
            stmt.registerOutParameter(3, Types.VARCHAR);
            stmt.execute();

            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    // gunakan kode ERP sebagai ID bank
                    row.put("KODE_ERP", rs.getString("KODE_ERP"));
                    row.put("KODE_BANK", rs.getString("KODE_BANK"));
                    row.put("NAMA_BANK", rs.getString("NAMA_BANK"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }

    // B) Master - MASTER
    // B.1) Master PROVINSI Service
    // ----------------------------------------------------------------------------------
    public List<Map<String, Object>> getMstProvinsi() throws SQLException {

        List<Map<String, Object>> resultList = new ArrayList<>();

        String sql = "{ ? = call LISDES.PKG_DROP_DOWN_LISDES.PILIH_PROVINSI(?, ?) }";

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)
        ) {
            // 1️⃣ RETURN VALUE (INT)
            stmt.registerOutParameter(1, Types.INTEGER);

            // 2️⃣ OUT SYS_REFCURSOR
            stmt.registerOutParameter(2, OracleTypes.CURSOR);

            // 3️⃣ OUT PESAN
            stmt.registerOutParameter(3, Types.VARCHAR);

            stmt.execute();

            // Ambil return value
            int retVal = stmt.getInt(1);
            String pesan = stmt.getString(3);

            if (retVal != 1) {
                throw new SQLException("Gagal ambil data provinsi: " + pesan);
            }

            // Ambil cursor
            try (ResultSet rs = (ResultSet) stmt.getObject(2)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("KODE", rs.getString("KODE"));
                    row.put("PROVINSI", rs.getString("PROVINSI"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }


    // B.2) Master KABUPATEN Service
    // ----------------------------------------------------------------------------------
    public List<Map<String, Object>> getMstKabupaten(String vkdprov) throws SQLException {

        List<Map<String, Object>> resultList = new ArrayList<>();

        String sql = "{ ? = call LISDES.PKG_DROP_DOWN_LISDES.PILIH_KABUPATENKOTA(?, ?, ?) }";

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)
        ) {
            // 1️⃣ RETURN VALUE
            stmt.registerOutParameter(1, Types.INTEGER);

            // 2️⃣ IN KD_PROVINSI
            stmt.setString(2, vkdprov);

            // 3️⃣ OUT CURSOR
            stmt.registerOutParameter(3, OracleTypes.CURSOR);

            // 4️⃣ OUT PESAN
            stmt.registerOutParameter(4, Types.VARCHAR);

            stmt.execute();

            int retVal = stmt.getInt(1);
            String pesan = stmt.getString(4);

            if (retVal != 1) {
                throw new SQLException("Gagal ambil data kabupaten: " + pesan);
            }

            try (ResultSet rs = (ResultSet) stmt.getObject(3)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("KODE", rs.getString("KODE"));
                    row.put("KABUPATEN", rs.getString("KABUPATEN"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }

    // B.3) Master KECAMATAN Service
    // ----------------------------------------------------------------------------------
    public List<Map<String, Object>> getMstKecamatan(String vkdprov, String vkdkab) throws SQLException {

        List<Map<String, Object>> resultList = new ArrayList<>();

        String sql = "{ ? = call LISDES.PKG_DROP_DOWN_LISDES.PILIH_KECAMATAN(?, ?, ?, ?) }";

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)
        ) {
            // 1️⃣ RETURN VALUE
            stmt.registerOutParameter(1, Types.INTEGER);

            // 2️⃣ IN KD_PROVINSI
            stmt.setString(2, vkdprov);

            // 2️⃣ IN vkdkab
            stmt.setString(3, vkdkab);

            // 3️⃣ OUT CURSOR
            stmt.registerOutParameter(4, OracleTypes.CURSOR);

            // 4️⃣ OUT PESAN
            stmt.registerOutParameter(5, Types.VARCHAR);

            stmt.execute();

            int retVal = stmt.getInt(1);
            String pesan = stmt.getString(5);

            if (retVal != 1) {
                throw new SQLException("Gagal ambil data kabupaten: " + pesan);
            }

            try (ResultSet rs = (ResultSet) stmt.getObject(4)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("KODE", rs.getString("KODE"));
                    row.put("KECAMATAN", rs.getString("KECAMATAN"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }

    // B.3) Master KECAMATAN Service
    // ----------------------------------------------------------------------------------
    public List<Map<String, Object>> getMstDesaKelurahan(String vkdprov, String vkdkab, String vkdkec) throws SQLException {

        List<Map<String, Object>> resultList = new ArrayList<>();

        String sql = "{ ? = call LISDES.PKG_DROP_DOWN_LISDES.PILIH_KELURAHAN(?, ?, ?, ?, ?) }";

        try (
            Connection conn = dataSource.getConnection();
            CallableStatement stmt = conn.prepareCall(sql)
        ) {
            // 1️⃣ RETURN VALUE
            stmt.registerOutParameter(1, Types.INTEGER);

            // 2️⃣ IN KD_PROVINSI
            stmt.setString(2, vkdprov);

            // 2️⃣ IN vkdkab
            stmt.setString(3, vkdkab);
           
            // 2️⃣ IN vkdkec
            stmt.setString(4, vkdkec);

            // 3️⃣ OUT CURSOR
            stmt.registerOutParameter(5, OracleTypes.CURSOR);

            // 4️⃣ OUT PESAN
            stmt.registerOutParameter(6, Types.VARCHAR);

            stmt.execute();

            int retVal = stmt.getInt(1);
            String pesan = stmt.getString(6);

            if (retVal != 1) {
                throw new SQLException("Gagal ambil data kabupaten: " + pesan);
            }

            try (ResultSet rs = (ResultSet) stmt.getObject(5)) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("KODE", rs.getString("KODE"));
                    row.put("KELURAHAN", rs.getString("KELURAHAN"));
                    resultList.add(row);
                }
            }
        }

        return resultList;
    }


}
