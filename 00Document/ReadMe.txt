Prototive untuk memanggil daftar monitoring Per-Prov/PerUPI
Menggunakan Pageing

isue
1. jika tanpa peging data dari Back end jika data >5.000 akan lambat dan bahkan tidak muncul langsung hank web nya
2. walau ada loding dan akan tetap tampil walau data banyak misal 50.000 sekaligus perpaging

3. contoh test pcke daftar saat kilk di record sesuai keteranganfiled Data dan bisa juga jika total di bawah 
   di klik muncul daptar seluruh Prov/seluruh PerUPI

   VARIABLE TMPCUR_OUT REFCURSOR;
    DECLARE
    pesan varchar2(1000);
    kdrespon varchar2(1000);
    BEGIN 
    --  in_start :1, in_lenght :5, in_sort_by :'DESC', in_sort_dir :'UNITUP', in_search        in varchar2,
    -- vkd_sumberdata :SEMUA/DAPIL/PEMDA,  vtahun :2025, vdata TOTAL_SUMBER/NIK_VALID?..., voption PROVINSI/UPI/UP3?ULP, vid_option : 11/12/...
    BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.S_BPBLPRASURVEY_PROV_DAFTAR_PGS('1', '5', 'DESC', 'UNITUP', '', 'SEMUA', '2025','TOTAL_SUMBER', 'PROVINSI', '',  :TMPCUR_OUT, pesan);
    --   BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.S_BPBLPRASURVEY_PROV_DAFTAR_PGS('SEMUA', '2025','NIK_VALID', 'PROVINSI', '11',  :TMPCUR_OUT, pesan);
    --   BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.S_BPBLPRASURVEY_PROV_DAFTAR_PGS('SEMUA', '2025','NIK_BLM_VALID', 'PROVINSI', '32',  :TMPCUR_OUT, pesan);
    --    BPBL_SURVEY.PKG_MON_LAP_BPBLPRASURVEY.S_BPBLPRASURVEY_PROV_DAFTAR_PGS('SEMUA', '2025','BLM_VERIFIKASI_DJK', 'PROVINSI', '',  :TMPCUR_OUT, pesan);
    DBMS_OUTPUT.PUT_LINE(pesan);
    END;
    PRINT TMPCUR_OUT;

    contoh sudah ada di java script agar seluruh page tampil/ dan package hanya mengirimkan perhalaman


    TEST POST METHOD DI cmd

    curl -X POST http://localhost:8080/monperprovperupi -d "act=testPost" -d "bln_usulan=202505"