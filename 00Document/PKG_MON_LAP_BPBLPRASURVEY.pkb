CREATE OR REPLACE PACKAGE BODY BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY AS

--1a1) Monitoring Per-Provinsi Pra-Survey    
    PROCEDURE M_BPBLPRASURVEY_PROV(vkd_sumberdata varchar2, vtahun varchar2, out_data out sys_refcursor, pesan out varchar2) as
    BEGIN
                
        OPEN out_data FOR 
        ---1a) perprovinsi BPBL PRASURVEY
        with 
              mst_provinsi  as
                 -- distinct kd prov diambil master kelurahan New
                 (select distinct KD_PROV, trim(NAMA_PROV) as PROVINSI from BPBL_SURVEY.REFF_KELURAHAN_NEW),
              tahun_laporan as
                 (select vtahun as tahun from dual),
              bpbl_prasurvey_laporan as
                 (
                   select * 
                   from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_PROV_UPI 
                   where decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1', SUMBER_DATA)  =  decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1',vkd_sumberdata)
                 )
        select *
        from 
        (
            select x.URUT, x.KODE, x.NAMA , x.TAHUN
                , decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','DAPIL/PEMDA', SUMBER_DATA) SUMBER_DATA
                , 0 TARGET 
                , sum(x.TOTAL_SUMBER) TOTAL_SUMBER, sum(x.NIK_BLM_VALID) NIK_BLM_VALID
                , sum(x.NIK_VALID) NIK_VALID, sum(x.NIK_VALID_KOREKSI)NIK_VALID_KOREKSI, sum(TOTAL_NIK_VALID) TOTAL_NIK_VALID
                , sum(x.BLM_VERIFIKASI_DJK) BLM_VERIFIKASI_DJK, sum(x.VERIFIKASI_DJK) VERIFIKASI_DJK
                ,sum(case  
                    WHEN NVL(x.VERIFIKASI_DJK,0) = 0 
                    THEN  0
                    ELSE round( (nvl(VERIFIKASI_DJK,0) / (nvl(x.NIK_VALID,0)+nvl(x.NIK_VALID_KOREKSI,0)))*100, 1) 
                    end) persen_dataverifikasi
                , 0 persen_target
            from
            (
                select 1 urut, a.KD_PROV kode, a.PROVINSI as nama, b.tahun 
                    , SUMBER_DATA
                    , sum(nvl(TOTAL_SUMBER,0)) TOTAL_SUMBER
                    , sum(nvl(NIK_BLM_VALID,0)) NIK_BLM_VALID
                    , sum(nvl(NIK_VALID,0)) NIK_VALID, sum(nvl(NIK_VALID_KOREKSI,0)) NIK_VALID_KOREKSI
                    , sum(nvl(TOTAL_NIK_VALID,0)) TOTAL_NIK_VALID
                    , sum(nvl(BLM_VERIFIKASI_DJK,0)) BLM_VERIFIKASI_DJK, sum(nvl(VERIFIKASI_DJK,0)) VERIFIKASI_DJK
                from mst_provinsi a, tahun_laporan b, bpbl_prasurvey_laporan c
                where b.tahun = c.tahun(+)
                and  a.KD_PROV = c.KD_PROV(+)
                group by a.KD_PROV, a.PROVINSI, b.tahun, c.SUMBER_DATA
            ) x
            group by x.URUT, x.KODE, x.NAMA , x.TAHUN
                     , decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','DAPIL/PEMDA', SUMBER_DATA)
            union
            select y.URUT, null KODE, null NAMA , null TAHUN
                , 'TOTAL' SUMBER_DATA
                , 0 TARGET 
                , y.TOTAL_SUMBER, y.NIK_BLM_VALID
                , y.NIK_VALID, y.NIK_VALID_KOREKSI, TOTAL_NIK_VALID
                , y.BLM_VERIFIKASI_DJK, y.VERIFIKASI_DJK
                ,case  
                    WHEN NVL(y.VERIFIKASI_DJK,0) = 0 
                    THEN  0
                    ELSE round( (nvl(VERIFIKASI_DJK,0) / (nvl(y.NIK_VALID,0)+nvl(y.NIK_VALID_KOREKSI,0)))*100, 1) 
                    end persen_dataverifikasi
                , 0 persen_target
            from
            (
                select 2 urut, null kode, null as nama, null tahun 
                    , null SUMBER_DATA
                    , sum(nvl(TOTAL_SUMBER,0)) TOTAL_SUMBER
                    , sum(nvl(NIK_BLM_VALID,0)) NIK_BLM_VALID
                    , sum(nvl(NIK_VALID,0)) NIK_VALID
                    , sum(nvl(TOTAL_NIK_VALID,0)) TOTAL_NIK_VALID
                    , sum(nvl(NIK_VALID_KOREKSI,0)) NIK_VALID_KOREKSI
                    , sum(nvl(BLM_VERIFIKASI_DJK,0)) BLM_VERIFIKASI_DJK, sum(nvl(VERIFIKASI_DJK,0)) VERIFIKASI_DJK
                from mst_provinsi a, tahun_laporan b, bpbl_prasurvey_laporan c
                where b.tahun = c.tahun(+)
                and  a.KD_PROV = c.KD_PROV(+)
            ) y  
        ) z
        order by urut, kode;  
            
        pesan:='Sukses  Tampilkan Data Tidak Ada ';
            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           pesan:='Gagal  Tampilkan Data Tidak Ada '||SQLERRM;
    END;
    
--1a2) Monitoring Per-UPI Pra-Survey     
    PROCEDURE M_BPBLPRASURVEY_UPI(vkd_sumberdata varchar2, vtahun varchar2, out_data out sys_refcursor, pesan out varchar2) as
    BEGIN
                
        OPEN out_data FOR 
            ---1b) PerUPI BPBL PRASURVEY
            with 
                  mst_provinsi  as
                     -- distinct kd prov diambil master kelurahan New
                     (select * from BPBL_SURVEY.unitupi),
                  tahun_laporan as
                     (select vtahun as tahun from dual),
                  bpbl_prasurvey_laporan as
                     (
                       select * 
                       from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_PROV_UPI 
                       where decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1', SUMBER_DATA)  =  decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1',vkd_sumberdata)
                     )
            select *
            from 
            (
                select x.URUT, x.KODE, x.NAMA , x.TAHUN
                    , decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','DAPIL/PEMDA', SUMBER_DATA) SUMBER_DATA
                    , 0 TARGET 
                    , sum(x.TOTAL_SUMBER) TOTAL_SUMBER, sum(x.NIK_BLM_VALID) NIK_BLM_VALID
                    , sum(x.NIK_VALID) NIK_VALID, sum(x.NIK_VALID_KOREKSI)NIK_VALID_KOREKSI, sum(TOTAL_NIK_VALID) TOTAL_NIK_VALID
                    , sum(x.BLM_VERIFIKASI_DJK) BLM_VERIFIKASI_DJK, sum(x.VERIFIKASI_DJK) VERIFIKASI_DJK
                    ,sum(case  
                        WHEN NVL(x.VERIFIKASI_DJK,0) = 0 
                        THEN  0
                        ELSE round( (nvl(VERIFIKASI_DJK,0) / (nvl(x.NIK_VALID,0)+nvl(x.NIK_VALID_KOREKSI,0)))*100, 1) 
                        end) persen_dataverifikasi
                    , 0 persen_target
                from
                (
                    select 1 urut, a.UNITUPI kode, a.SATUAN||' '||a.NAMA as nama, b.tahun 
                        , SUMBER_DATA
                        , sum(nvl(TOTAL_SUMBER,0)) TOTAL_SUMBER
                        , sum(nvl(NIK_BLM_VALID,0)) NIK_BLM_VALID
                        , sum(nvl(NIK_VALID,0)) NIK_VALID, sum(nvl(NIK_VALID_KOREKSI,0)) NIK_VALID_KOREKSI
                        , sum(nvl(TOTAL_NIK_VALID,0)) TOTAL_NIK_VALID
                        , sum(nvl(BLM_VERIFIKASI_DJK,0)) BLM_VERIFIKASI_DJK, sum(nvl(VERIFIKASI_DJK,0)) VERIFIKASI_DJK
                    from mst_provinsi a, tahun_laporan b, bpbl_prasurvey_laporan c
                    where b.tahun = c.tahun(+)
                    and  a.UNITUPI = c.UNITUPI(+)
                    group by a.UNITUPI, a.SATUAN||' '||a.NAMA, b.tahun, c.SUMBER_DATA
                ) x
                group by x.URUT, x.KODE, x.NAMA , x.TAHUN, 
                         decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','DAPIL/PEMDA', SUMBER_DATA)
                union
                select y.URUT, null KODE, null NAMA , null TAHUN
                    , 'TOTAL' SUMBER_DATA
                    , 0 TARGET 
                    , y.TOTAL_SUMBER, y.NIK_BLM_VALID
                    , y.NIK_VALID, y.NIK_VALID_KOREKSI, TOTAL_NIK_VALID
                    , y.BLM_VERIFIKASI_DJK, y.VERIFIKASI_DJK
                    ,case  
                        WHEN NVL(y.VERIFIKASI_DJK,0) = 0 
                        THEN  0
                        ELSE round( (nvl(VERIFIKASI_DJK,0) / (nvl(y.NIK_VALID,0)+nvl(y.NIK_VALID_KOREKSI,0)))*100, 1) 
                        end persen_dataverifikasi
                    , 0 persen_target
                from
                (
                    select 2 urut, null kode, null as nama, null tahun 
                        , null SUMBER_DATA
                        , sum(nvl(TOTAL_SUMBER,0)) TOTAL_SUMBER
                        , sum(nvl(NIK_BLM_VALID,0)) NIK_BLM_VALID
                        , sum(nvl(NIK_VALID,0)) NIK_VALID
                        , sum(nvl(TOTAL_NIK_VALID,0)) TOTAL_NIK_VALID
                        , sum(nvl(NIK_VALID_KOREKSI,0)) NIK_VALID_KOREKSI
                        , sum(nvl(BLM_VERIFIKASI_DJK,0)) BLM_VERIFIKASI_DJK, sum(nvl(VERIFIKASI_DJK,0)) VERIFIKASI_DJK
                    from mst_provinsi a, tahun_laporan b, bpbl_prasurvey_laporan c
                    where b.tahun = c.tahun(+)
                    and  a.UNITUPI = c.UNITUPI(+)
                ) y  
            ) z
            order by urut, kode;    
            
        pesan:='Sukses  Tampilkan Data Tidak Ada ';
            
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           pesan:='Gagal  Tampilkan Data Tidak Ada '||SQLERRM;
    END;
    
--1b1) Daftar Per-Provinsi/UPI/UP3/ULP Pra-Survey    
    PROCEDURE S_BPBLPRASURVEY_PROV_DAFTAR(vkd_sumberdata varchar2,  vtahun varchar2, vdata varchar2, voption varchar2, vid_option varchar2, out_data out sys_refcursor, pesan out varchar2) as
         pesan2            varchar2(1000); 
    BEGIN            
        OPEN out_data FOR 
            select /* +PARALLEL */  *
            from 
            (
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_01D_TOTAL_SUMBER
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_02D_NIK_BLM_VALID       
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D1_NIK_VALID   
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D2_NIK_VALID_KOREKSI   
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D3_TOTAL_NIK_VALID  
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_04D_BLM_VERIFIKASI_DJK 
                union
                select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_05D_VERIFIKASI_DJK         
            ) x   
            where trim(x.tahun)                         = vtahun
            and   x.data                                = vdata
            and   decode(voption,'PROVINSI', decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.KD_PROV),
                                  'UPI',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITUPI),
                                  'UP3',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITAP),
                                  'ULP',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITUP)
                        )   = decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1',vid_option)
            and  decode(
                        nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1', SUMBER_DATA
                       )    =  decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1',vkd_sumberdata);
                      
        IF voption is null THEN 
            pesan2 := 'Gagal Pilih Laporan PROVINSI/UPI/UP3/ULP';
        ELSIF vid_option is null THEN
            pesan2 := 'Gagal Kosong Kode '||voption;
        ELSE 
           pesan2 := 'Sukses Tampilkan Data Daftar Per'||voption;
        END IF;
         

        pesan := pesan2;
--        pesan := 'Sukses Tampilkan Data Per'||voption;                        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           pesan:='Gagal  Tampilkan Data Tidak Ada '||SQLERRM;
    END;
    
--1b2) Daftar Per-Provinsi Pra-Survey  PAGING  
    PROCEDURE S_BPBLPRASURVEY_PROV_DAFTAR_PGS(
                    in_start         in number,
                    in_lenght        in number,
                    in_sort_by       in varchar2,
                    in_sort_dir      in varchar2,
                    in_search        in varchar2,
                    vkd_sumberdata varchar2,  vtahun varchar2, vdata varchar2, voption varchar2, vid_option varchar2, out_data out sys_refcursor, pesan out varchar2) as
        pesan2            varchar2(1000); 
    BEGIN
        OPEN out_data FOR 
            select *
            from 
            (
                select inner_result.*, rownum row_number
                from 
                (
                    select count (x.KD_PROV) over () total_count, 
                        ID_KOLEKTIF, IDURUT_BPBL, TANGGAL_USULAN, KODE_PENGUSUL, NAMA_PELANGGAN, 
                        NIK, ALAMAT, KD_PROV, KD_PROV_USULAN, PROVINSI, PROVINSI_USULAN, KD_KAB, 
                        KD_KAB_USULAN, KABUPATENKOTA, KABUPATENKOTA_USULAN, KD_KEC, KD_KEC_USULAN, 
                        KECAMATAN, KECAMATAN_USULAN, KD_KEL, KD_KEL_USULAN, DESAKELURAHAN, 
                        DESAKELURAHAN_USULAN, UNITUPI, NAMA_UNITUPI, UNITAP, NAMA_UNITAP, UNITUP, 
                        NAMA_UNITUP, STATUS, USER_ID, TGL_UPLOAD, NAMA_FILE_UPLOAD, PATH_FILE, 
                        DOKUMEN_UPLOAD, PATH_DOKUMEN, SURAT_VALDES, PRIORITAS, VERIFIKASI_DJK, 
                        SUMBER_DATA, KETERANGAN, TAHUN, TGL_KOREKSI, USERID_KOREKSI, 
                        NAMA_FILE_KOREKSI, PATH_FILE_KOREKSI
                    from 
                    (
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_01D_TOTAL_SUMBER
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_02D_NIK_BLM_VALID       
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D1_NIK_VALID   
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D2_NIK_VALID_KOREKSI   
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_03D3_TOTAL_NIK_VALID  
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_04D_BLM_VERIFIKASI_DJK 
                        union
                        select * from BPBL_SURVEY.VW_MON_BPBLPRASURVEY_05D_VERIFIKASI_DJK         
                    ) x   
                    where trim(x.tahun)                         = vtahun
                    and   x.data                                = vdata
                    and   decode(voption,'PROVINSI', decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.KD_PROV),
                                          'UPI',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITUPI),
                                          'UP3',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITAP),
                                          'ULP',      decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1', x.UNITUP)
                                )   = decode(nvl(upper(vid_option),'SEMUA'),'SEMUA','1',vid_option)
                    and  decode(
                                nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1', SUMBER_DATA
                               )    =  decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1',vkd_sumberdata)   
            --        AND (LOWER (x.KD_PROV) LIKE '%' || LOWER (:in_search) || '%') 
                    order by 
                          case
                             when in_sort_dir = 'ASC'
                             and in_sort_by = 'UNITUPI'
                                then x.UNITUPI
                          end asc,
                          case
                             when in_sort_dir = 'DESC'
                             and  in_sort_by = 'UNITUPI'
                                then x.UNITUPI
                          end desc,
                          case
                             when trim (in_sort_by) is null
                              or trim (in_sort_by) = ''
                                then x.KD_PROV
                          end
                ) inner_result
                where rownum <= in_start * in_lenght
            )
            where row_number > ((in_start - 1) * in_lenght);
                      
        IF voption is null THEN 
            pesan2 := 'Gagal Pilih Laporan PROVINSI/UPI/UP3/ULP';
        ELSIF vid_option is null THEN
            pesan2 := 'Gagal Kosong Kode '||voption;
        ELSE 
           pesan2 := 'Sukses Tampilkan Data Daftar Per'||voption;
        END IF;         

        pesan := pesan2;
    --        pesan := 'Sukses Tampilkan Data Per'||voption;                        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           pesan:='Gagal  Tampilkan Data Tidak Ada '||SQLERRM;
    END;
                    
                    
--2a) Monitoring Per-Pengsusul Pra-Survey   
    PROCEDURE M_BPBLPRASURVEY_PERPENGUSUL(vtahun in varchar2, vkd_sumberdata in varchar2, vkd_pengusul in varchar2, out_data out sys_refcursor, pesan out varchar2, p_log in varchar2) as
        p_query_string varchar2(5000);
        p_userid       varchar2(100);
        p_groupid      varchar2(25);
        p_nama         varchar2(100);
        p_tanggal      varchar2(20);
        p_upi          varchar2(20);
        p_up3          varchar2(20);
        p_ulp          varchar2(20);
        vrkd_pengusul   varchar2(20);
    BEGIN                                        
        p_userid:= bpbl_survey.fget_substring_index (p_log,'|',1);
        p_groupid:= bpbl_survey.fget_substring_index (p_log,'|',2);
        p_nama:=bpbl_survey.fget_substring_index (p_log,'|',3);
        p_tanggal:=bpbl_survey.fget_substring_index (p_log,'|',4);
        p_upi:=bpbl_survey.fget_substring_index (p_log,'|',5);
        p_up3:=bpbl_survey.fget_substring_index (p_log,'|',6);
        p_ulp:=bpbl_survey.fget_substring_index (p_log,'|',7);
        vrkd_pengusul:=bpbl_survey.fget_substring_index (p_log,'|',8);
        
        IF ((vkd_pengusul = vrkd_pengusul) or (nvl(vkd_pengusul,'SEMUA') = 'SEMUA') ) 
           and (p_groupid = 'OPT')  THEN
            vrkd_pengusul:=bpbl_survey.fget_substring_index (p_log,'|',8);
        ELSIF (p_groupid in ('DJK','PLN')) THEN
            vrkd_pengusul := nvl(vkd_pengusul,'SEMUA');
        ELSE
            vrkd_pengusul   := 'X';
        END IF;
        
        OPEN out_data FOR 
            -- role --DJK, OPT, ADM, PLN
            -- 'ulp.13104|ULP|ULP 13104|datetime|13|13100|13104|'
            -- 'ADM.DJK|DJK||datetime| | | |'
            -- 'OPT.ACH01|OPT||datetime| | |ACH01|'
            select  a.KD_PROV, a.PROVINSI, a.KODE_PENGUSUL, a.NAMA_FILE_UPLOAD,
                            ( select KODE_PENGUSUL||' - '||NAMA_ANGGOTA from BPBL_SURVEY.MASTER_DAPIL   
                              where KODE_PENGUSUL = a.KODE_PENGUSUL and rownum = 1
                            ) as NAMA_ANGGOTA,
                            DECODE (NVL (SUBSTR (ID_KOLEKTIF, 1, 3), 'IND'),
                                             'KOL', 'KOLEKTIF',
                                             'INDIVIDU') as SUMBER_PROSES,
                            SUMBER_DATA,
                            COUNT(*)   TOTAL_SUMBER,
                            sum(
                                CASE 
                                    WHEN (STATUS = '0') and (upper(trim(KETERANGAN)) <> 'NIK VALID') THEN
                                      1
                                    ELSE 0
                                END
                                )  as  NIK_BLM_VALID,
                            sum(
                                CASE 
                                    WHEN (STATUS = '0') and (upper(trim(KETERANGAN)) = 'NIK VALID') THEN
                                      1
                                    ELSE 0
                                END
                                )  as  NIK_VALID,
                            sum(
                                CASE 
                                    WHEN (STATUS = '1') and (upper(trim(KETERANGAN)) = 'NIK VALID') THEN
                                      1
                                    ELSE 0
                                END
                                )  as  NIK_VALID_KOREKSI,
                            sum(
                                CASE 
                                    WHEN (VERIFIKASI_DJK = '0') THEN
                                      1
                                    ELSE 0
                                END
                                ) as BLM_VERIFIKASI_DJK,
                            sum(
                                CASE 
                                    WHEN (VERIFIKASI_DJK = '1') THEN
                                      1
                                    ELSE 0
                                END
                                ) as VERIFIKASI_DJK
            from BPBL_SURVEY.DATA_UPLOAD_PRASURVEY a
            where   a.TAHUN         = vtahun
            and decode(nvl(upper(vrkd_pengusul),'SEMUA'),'SEMUA','1', a.KODE_PENGUSUL)  =  decode(nvl(upper(vrkd_pengusul),'SEMUA'),'SEMUA','1',vrkd_pengusul)
            and decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1', a.SUMBER_DATA)  =  decode(nvl(upper(vkd_sumberdata),'SEMUA'),'SEMUA','1',vkd_sumberdata)
            group by  a.KD_PROV, a.PROVINSI, a.KODE_PENGUSUL, a.NAMA_FILE_UPLOAD,
                      DECODE (NVL (SUBSTR (ID_KOLEKTIF, 1, 3), 'IND'),
                                             'KOL', 'KOLEKTIF',
                                             'INDIVIDU'), SUMBER_DATA
            order by    a.KODE_PENGUSUL, a.KD_PROV, a.SUMBER_DATA;                       
                                                          
        pesan := 'Sukses Tampilkan Data PerPengusul (KHUSUS : OPRATOR DJK/DJK/PLN PUSAT)';      
                    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           pesan:='Gagal  Tampilkan Data Tidak Ada '||SQLERRM;
    END;
    
END PKG_MON_LAP_BPBLPRASURVEY;
/