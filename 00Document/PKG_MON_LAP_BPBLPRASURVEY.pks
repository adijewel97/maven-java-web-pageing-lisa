CREATE OR REPLACE PACKAGE BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY AS

--1a1) Monitoring Per-Provinsi Pra-Survey    
    PROCEDURE M_BPBLPRASURVEY_PROV(vkd_sumberdata varchar2, vtahun varchar2, out_data out sys_refcursor, pesan out varchar2);
--1a2) Monitoring Per-UPI Pra-Survey    
    PROCEDURE M_BPBLPRASURVEY_UPI(vkd_sumberdata varchar2, vtahun varchar2, out_data out sys_refcursor, pesan out varchar2);
--1b) Daftar Per-Provinsi Pra-Survey    
    PROCEDURE S_BPBLPRASURVEY_PROV_DAFTAR(vkd_sumberdata varchar2,  vtahun varchar2, vdata varchar2, voption varchar2, vid_option varchar2, out_data out sys_refcursor, pesan out varchar2);
 
--2a) Monitoring Per-Pengsusul Pra-Survey   
    PROCEDURE M_BPBLPRASURVEY_PERPENGUSUL(vtahun in varchar2, vkd_sumberdata in varchar2, vkd_pengusul in varchar2, out_data out sys_refcursor, pesan out varchar2, p_log in varchar2);  
    
END PKG_MON_LAP_BPBLPRASURVEY;
/