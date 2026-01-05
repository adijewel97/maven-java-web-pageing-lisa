// package com.example.service;


// import java.sql.CallableStatement;
// import java.sql.Connection;
// import java.sql.ResultSet;
// import java.sql.SQLException;
// import java.sql.Types;
// import java.util.ArrayList;
// import java.util.List;
// import java.util.Map;
// import java.util.logging.Logger;
// import javax.sql.DataSource;
// import com.example.utils.LoggerUtil;

// import oracle.jdbc.OracleTypes;

// public class MonMaterialPerKontrakService {
//     private DataSource dataSource;
//     private static final Logger logger = LoggerUtil.getLogger(MonMaterialPerKontrakService.class);
    
//     public MonMaterialPerKontrakService (DataSource dataSource){
//         this.dataSource = dataSource;
//     }

//     public List<Map<String, Object>> GetRkpMaterialPerKontrak(String vtahun_laporan, List<String> pesanOutput){
        
//         List<Map<String, Object>>  result = new ArrayList<>();

//         String sql = "{call LISDES.PKG_MONLAP_LISDES.RKP_PENGERJAAN_LISDES_PROV( ?, ?, ?)}";

//         logger.info("Memulai panggilan prosedur Oracle Rekap : "+ sql );
//         logger.info("Parameter vtahun_laporan: " + vtahun_laporan);

//         try{ Connection conn = dataSource.getConnection();
//              CallableStatement stmt = conn.prepareCall(sql);
             
//              stmt.setString(1, vtahun_laporan);
//              stmt.registerOutParameter(2, OracleTypes.CURSOR);
//              stmt.registerOutParameter( 3, Types.VARCHAR);

//              stmt.execute();
//              logger.info("Prosedur Utama berhasil dieksekusi");

//              try{ResultSet rs = (ResultSet) stmt.getObject(2){
//                 ResultSet = 
//              }

//              }

//         } catch (SQLException e) {
//             logger.severe("Kesalahan database M_BPBLPRASURVEY_PROV: " +e.getMessage());
//             pesanOutput.add("Terjadi kesalahan koneksi ke database: " + e.getMessage());
//         }
//     }
// }
