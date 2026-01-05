<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>
   /* CSS TABLE REKAP - SAMAKAN DENGAN TABEL Detail */
    #tablemon_upi {
        table-layout: auto; /* Sama seperti #dataModal table */
        font-size: 0.75rem; /* Sama dengan modal-body */
        width: 100%;
    }

    #tablemon_upi th,
    #tablemon_upi td {
        font-size: 0.7rem;      /* Sama seperti table detail */
        padding: 4px 6px;       /* Sama seperti table detail */
        white-space: nowrap;    /* Hindari wrap */
        overflow: hidden;
        text-overflow: ellipsis;
    }

    #tablemon_upi th.sorting::after,
    #tablemon_upi th.sorting_asc::after,
    #tablemon_upi th.sorting_desc::after {
        display: none !important;
    }

    /* Target wrapper DataTables untuk memastikan lebar 100% tidak terlampaui */
    #tablemon_upi_wrapper {
        width: 100%;
        max-width: 100%;
    }

    /* Tambahan jika mau batas tinggi + scroll seperti modal */
    #tablemon_upi_wrapper .dataTables_scrollBody {
        max-height: 65vh;       /* Sesuaikan tinggi maksimal seperti modal */
        overflow-y: auto;
    }

    /* CSS MODAL SHOW TABLE MONITORING Detail */
    #dataModal .modal-body {
        font-size: 0.75rem; /* Ukuran teks diperkecil */
    }

    #dataModal table th,
    #dataModal table td {
        font-size: 0.7rem;   /* Ukuran teks header dan isi tabel */
        padding: 4px 6px;    /* Padding dikurangi agar tidak terlalu lebar */
        white-space: nowrap; /* Hindari pemisahan baris */
    }

    #dataModal table {
        table-layout: auto; /* Gunakan auto agar kolom menyesuaikan konten */
    }

    #dataModal .datatable-container {
        max-height: 65vh;    /* Batasi tinggi agar bisa scroll */
        overflow-y: auto;
    }

    /* Pastikan form-container relatif */
    .form-monitoring {
        position: relative;
    }

    .datatable-container {
        overflow-x: auto;
        width: 100%;
    }

    /* Buat spinner tetap di tengah form tapi transparan */
    .loading-overlay {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 1050;
        text-align: center;
        font-size: 0.95rem;
        /* Tidak ada background, padding, atau box */
    }

    /* tambah lebar large modal */
    .modal-xxl {
        max-width: 98% !important; /* Atur sesuai kebutuhan */
    }

    /* legenda tulisan hedar dan kotak  */
    .form-box {
        border: 1px solid #ddd;
        border-radius: 4px;
        padding: 20px;
        margin: 20px 0;
    }

    .form-box legend {
        font-weight: bold;
        font-size: 1rem;
    }

    .form-box fieldset {
        border: none;
        padding: 0;
        margin: 0;
    }

    #tahun_laporan {
        text-transform: uppercase;
    }

    /* ----------
       Spiner css
       ----------
    */
    #loadingSpinner {
        display: none;
        position: fixed;
        top: 20%;
        left: 50%;
        transform: translate(-50%, 0);
        z-index: 9999;
        /* background-color: rgba(255, 255, 255, 0.7); */
        padding: 20px 30px;
        border-radius: 6px;
        /* box-shadow: 0 0 10px rgba(0,0,0,0.2); */
        text-align: center;
    }


    #loadingSpinner .spinner-content {
        text-align: center;
        font-size: 1.2rem;
        color: #333;
    }

    .overlay-spinner {
        position: absolute;
        top: 40%;
        left: 45%;
        z-index: 1060;
    }

    /* Semua header */
    #tablemon_upi thead th {
        text-align: center;
        vertical-align: middle;
        font-weight: 600;
        color: #ffffff;            /* teks putih */
        border-color: #7d7c7a;
    }

    /* Warna dasar kuning */
    #tablemon_upi thead.hdr-yellow th {
        background-color: #6390cb;
    }

    /* Optional: hover sorting DataTables tetap kontras */
    #tablemon_upi thead th.sorting,
    #tablemon_upi thead th.sorting_asc,
    #tablemon_upi thead th.sorting_desc {
        color: #ffffff !important;
    }

    /* ===== SUBTOTAL ROW ===== */
    table.dataTable tbody tr.subtotal-row td {
        background-color: #fff7e6 !important;
        font-weight: 700;
        border-top: 2px solid #f0ad4e !important;
        border-bottom: 2px solid #f0ad4e !important;
    }

    /* jaga garis vertikal */
    table.dataTable tbody tr.subtotal-row td:not(:last-child) {
        border-right: 1px solid #dee2e6 !important;
    }

    /* 👉 indent tulisan TOTAL (± 5 spasi) */
    table.dataTable tbody tr.subtotal-row td:first-child {
        padding-left: 40px !important; /* ≈ 5 spasi */
    }

    /* CSS khusus untuk kolom subtotal angka */
    .subtotal-row td.stynumeric {
        text-align: right;
        padding-right: 8px; /* optional, supaya rapi */
    }

    /* 🔵 garis penutup per NOMOR_KONTRAK_RINCI */
    /* 🔵 START KONTRAK RINCI */
    tr.start-kontrak-row td {
        border-top: 2px dashed #43a047;
        padding: 10px 0;
        background: #f1f8e9;
    }

    .start-kontrak-text {
        text-align: left;
        font-weight: bold;
        color: #2e7d32;
        letter-spacing: 1px;
    }

    /* 🔴 END KONTRAK RINCI (SATU GARIS PENUTUP SAJA) */
    tr.end-kontrak-row td {
        border-top: 2px dashed #e53935;   /* merah */
        padding: 10px 0;
        background: #fdecea;
    }

    .end-kontrak-text {
        text-align: left;
        font-weight: bold;
        color: #b71c1c;
        letter-spacing: 1px;
    }


</style>

<!-- ✅ Spinner Global untuk semua loading -->
<div id="spinnerOverlay" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%,-50%); z-index:9999;">
    <div class="spinner-border text-primary" role="status"></div>
</div>


<!-- Modal Large -->
<div class="modal fade" id="dataModal" tabindex="-1" aria-labelledby="dataModalLabel" aria-hidden="true">
  <!-- <div class="modal-dialog modal-dialog-scrollable modal-xl"> -->
  <div class="modal-dialog modal-dialog-scrollable modal-xl modal-xxl">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="dataModalLabel">Detail Data</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
        </div>
        <div class="modal-body" id="modalBody">
            <!-- Tombol Export -->
            <div class="mb-2">
                <button id="btnExportMonDftAllExcelOneSheet" class="btn btn-success btn-export">
                    <i class="fa fa-file-excel-o"></i> Export Detail Per-UPI
                </button>
            </div>
        <div class="datatable-container" style="overflow-x: auto;">
        <table id="table_mondaf_provupi" class="table table-bordered table-striped w-100" width="100%">
                <thead>
                <tr>
                    <th>NO</th>
                    <!-- <th>TOTAL_COUNT</th> -->
                    <th>INFOLABEL</th>                    
                    <th>NOMOR_KONTRAK_RINCI</th>
                    <th>TRANSMISI</th>
                    <th>MATERIAL_GROUP_ID</th>
                    <th>MATERIAL_GROUP</th>
                    <th>KODE_MATERIAL</th>
                    <th>NAMA_MATERIAL</th>
                    <th>JUMLAH_MDU</th>
                    <th>SATUAN</th>
                    <th>TAHUN</th>
                    <th>KD_PROV</th>
                    <th>PROVINSI</th>
                    <th>KD_KAB</th>
                    <th>KABUPATENKOTA</th>
                    <th>KD_KEC</th>
                    <th>KECAMATAN</th>
                    <th>KD_KEL</th>
                    <th>DESAKELURAHAN</th>
                    <th>UNITUPI</th>
                    <th>NAMA_UNITUPI</th>
                    <th>UNITAP</th>
                    <th>NAMA_UNITAP</th>
                    <th>UNITUP</th>
                    <th>NAMA_UNITUP</th>
                    <th>ID_PERENCANAAN</th>
                    <th>NOMOR_KONTRAK</th>
                    <th>KATEGORI_PEMBANGUNAN</th>
                    <th>KODE_PEMBANGUNAN</th>
                    <!-- <th>ROW_NUMBER</th> -->
                </tr>
                </thead>
            <tbody>
            </tbody>
          </table>
        </div>          
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
      </div>
    </div>
  </div>
</div>

<fieldset style="border: 1px solid #ccc; border-radius: 4px; padding: 1.25rem;">
    <legend style="font-size: 0.95rem; font-weight: bold; padding: 0 0.75rem; width: auto;">
        Monitoring - Pengerjaan Progress Bangsang LISA
    </legend>

    <div class="container mt-1">
        <div class="form-monitoring">
            <form id="form-monitoring">
                <div class="row align-items-end g-3 mb-2">
                    <!-- Input Bulan Laporan -->
                    <div class="col-md-4 col-lg-3">
                        <label for="tahun_laporan" class="form-label">Tahun Laporan :</label>
                        <select id="tahun_laporan" class="form-control"></select>
                    </div>
                    <div class="col-md-4 col-lg-4">
                        <label for="jenis_laporan" class="form-label">Jenis Laporan :</label>
                        <select id="jenis_laporan" class="form-control"> 
                            <option value="provinsi">PROVINSI</option>
                            <option value="upi">UPI</option>
                        </select>
                    </div>
                </div>
                <div class="row align-items-end g-3 mb-2"></div>
                <!-- Tombol Tampilkan -->
                    <div class="col-md-2">
                        <label class="form-label d-none d-md-block">&nbsp;</label> <!-- Spacer agar sejajar -->
                        <button id="btnTampil" type="button" class="btn btn-primary w-100">
                            <i class="bi bi-search"></i> Tampilkan
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="mt-4">
           <!-- Tombol export buatan sendiri -->
            <div class="mb-2">
                <button id="btnExportMonRkpAllExcel" class="btn btn-success btn-export" style="display: none;">
                    <i class="fa fa-file-excel-o"></i> Download Excel
                </button>
                <button id="btnExportMonRkpAllExcel2" class="btn btn-success btn-export" >
                    <i class="fa fa-file-excel-o"></i> Download Excel Rekap
                </button>
            </div>


            <div class="datatable-container">
                <div class="datatable-scroll-wrapper" style="overflow-x: auto;">
                    <table id="tablemon_upi" class="datatable-main table table-bordered table-striped">
                        <!-- <thead>
                            <tr>
                                <th>NO</th>
                                <th>TAHUN</th>
                                <th>KD_PROV</th>
                                <th>PROVINSI</th>
                                <th>JTR_RENCANA</th>
                                <th>JTM_RENCANA</th>
                                <th>GRD_RENCANA</th>
                                <th>JTR_WO</th>
                                <th>JTM_WO</th>
                                <th>GRD_WO</th>
                            </tr>
                        </thead> -->
                        <thead class="hdr-yellow">
                            <tr>
                                <th rowspan="2" class="hdr-main">NO</th>
                                <th rowspan="2" class="hdr-main">TAHUN</th>
                                <th rowspan="2" class="hdr-main">KD_PROV</th>
                                <th rowspan="2" class="hdr-main">PROVINSI</th>

                                <th colspan="3" class="hdr-rencana">RENCANA</th>
                                <th colspan="3" class="hdr-wo">WORK ORDER</th>
                                <th colspan="3" class="hdr-wo">PROSES BANGSANG</th>
                                <th colspan="3" class="hdr-wo">TERPASANG BANGSANG</th>
                                <th colspan="3" class="hdr-wo">PORSENTASE (%)</th>
                            </tr>
                            <tr>
                                <th class="hdr-rencana-sub">JTR</th>
                                <th class="hdr-rencana-sub">JTM</th>
                                <th class="hdr-rencana-sub">GRD</th>

                                <th class="hdr-wo-sub">JTR</th>
                                <th class="hdr-wo-sub">JTM</th>
                                <th class="hdr-wo-sub">GRD</th>

                                <th class="hdr-wo-sub">JTR</th>
                                <th class="hdr-wo-sub">JTM</th>
                                <th class="hdr-wo-sub">GRD</th>

                                <th class="hdr-wo-sub">JTR</th>
                                <th class="hdr-wo-sub">JTM</th>
                                <th class="hdr-wo-sub">GRD</th>

                                <th class="hdr-wo-sub">JTR</th>
                                <th class="hdr-wo-sub">JTM</th>
                                <th class="hdr-wo-sub">GRD</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</fieldset>

<script>
    $(document).ready(function () {
        function getContextPath() {
            return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2));
        }       

        // Ambil tahun sekarang
        const currentYear = new Date().getFullYear();

        // Hitung range
        const startYear = currentYear - 5;
        const endYear = currentYear + 5;

        const select = document.getElementById("tahun_laporan");

        // Generate dropdown tahun
        for (let y = startYear; y <= endYear; y++) {
            const opt = document.createElement("option");
            opt.value = y;
            opt.textContent = y;

            // Set default tahun sekarang
            if (y === currentYear) {
                opt.selected = true;
            }

            select.appendChild(opt);
        }

        let detailFilterParams = {};

        // memembat format number digit
        function formatNumber(value, fractionDigits = 2) {
            if (value == null || value === '') return '';
            const number = parseFloat(value);
            if (isNaN(number)) return value;
            return number.toLocaleString('id-ID', {
                minimumFractionDigits: fractionDigits,
                maximumFractionDigits: fractionDigits
            });
        }

        // ---------------------------------------------------------------------------------------------
        // 1A-1) Tampilkan monitoring Rekap
        // ---------------------------------------------------------------------------------------------
        var table = $('#tablemon_upi').DataTable({
            processing: false,
            serverSide: true,
            scrollX: false,
            paging: false, // MATIKAN PAGING
            stripeClasses: [], // Nonaktifkan efek baris selang-seling
            searching: false, 
            autoWidth: false,
            ajax: {
                url:  getContextPath() + '/mon-pengerjaan-perprovupi',
                type: 'POST',
                data: function (d) {
                    d.vtahun_laporan = $('#tahun_laporan').val();// pastikan pakai '#'!
                }
            },
            columns: [
                {
                    data: null,
                    render: function (data, type, row, meta) {
                        if (row.KD_PROV !== null && row.KD_PROV !== undefined) {
                            return meta.row + 1 + meta.settings._iDisplayStart;
                        } else {
                            return ''; // atau bisa juga 'N/A' atau '-'
                        }
                    }
                },
                { data: 'TAHUN',  defaultContent: '' },
                { data: 'KD_PROV',  defaultContent: '' },
                { data: 'PROVINSI',  defaultContent: '' },
                // kolom numeric diformat pakai formatNumber
                { data: 'JTR_RENCANA', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTM_RENCANA', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'GRD_RENCANA', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTR_WO', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTM_WO', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'GRD_WO', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTR_PROGRES', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTM_PROGRES', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'GRD_PROGRES', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTR_PASANG', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTM_PASANG', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'GRD_PASANG', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTR_PROSEN', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'JTM_PROSEN', defaultContent: '', render: d => formatNumber(d, 0) },
                { data: 'GRD_PROSEN', defaultContent: '', render: d => formatNumber(d, 0) }
            ],

            drawCallback: function () {
                $('#tablemon_upi thead th').addClass('text-center');
            },
           columnDefs: [
                { targets: '_all', className: 'dt-center' },
                { targets: 0, className: 'dt-body-right', orderable: false, width: '5px' },      
                { targets: 1, className: 'dt-body-center', width: '5px' },                         
                { targets: 2, className: 'dt-body-center', width: '5px' },                       
                { targets: 3, className: 'dt-body-center', width: '50px' },                         
                { targets: 4, className: 'dt-body-center', width: '50px' },                        
                { targets: 5, className: 'dt-body-center', width: '50px' },                        
                { targets: 6, className: 'dt-body-center', width: '50px' },   
                { targets: 7, className: 'dt-body-center', width: '50px' },                        
                { targets: 8, className: 'dt-body-center', width: '50px' },                        
                { targets: 9, className: 'dt-body-center', width: '50px' },                         
            ],
            createdRow: function (row, data, dataIndex) {
                $('td', row).each(function (colIndex) {

                    const columnDef = table.settings()[0].aoColumns[colIndex];
                    const columnName = columnDef.data;
                    if (!columnName) return;

                    const cellValue = data[columnName];
                    const allowedColumns = ['JTR_RENCANA', 'JTM_RENCANA', 'GRD_RENCANA',
                                            'JTR_WO', 'JTM_WO', 'GRD_WO',
                                            'JTR_PROGRES', 'JTM_PROGRES', 'GRD_PROGRES',            
                                            'JTR_PASANG', 'JTM_PASANG', 'GRD_PASANG',            
                                           ];

                    if (
                        allowedColumns.includes(columnName) &&
                        typeof cellValue === 'string' &&
                        cellValue.trim() !== '' &&
                        (data.URUT == 1)
                    ) {
                        // ===== RESET STYLE & CLICK (WAJIB) =====
                        $(this)
                            .removeClass('dt-clickable-bold')
                            .css({
                                cursor: 'default',
                                'text-decoration': 'none',
                                color: '',
                                'font-weight': 'bold',
                            })
                            .off('click');

                        // ==============================
                        // Normalisasi nilai kolom
                        // ==============================
                        let valT = 0, valK = 0, valA = 0;

                        // Versi 1: T=..|K=..|A=..
                        if (cellValue.includes('T=')) {
                            const t = cellValue.match(/T=\s*(\d+)/);
                            const k = cellValue.match(/K=\s*(\d+)/);
                            const a = cellValue.match(/A=\s*(\d+)/);

                            valT = t ? parseInt(t[1], 10) : 0;
                            valK = k ? parseInt(k[1], 10) : 0;
                            valA = a ? parseInt(a[1], 10) : 0;
                        }
                        // Versi 2: hanya angka → Tiang
                        else if (!isNaN(cellValue)) {
                            valT = parseInt(cellValue, 10);
                        }

                        // ==============================
                        // Reset style & click (WAJIB)
                        // ==============================
                        $(this)
                            .css({
                                cursor: 'default',
                                'text-decoration': 'none',
                                'font-weight': 'normal',
                                color: ''
                            })
                            .off('click');

                        // ==============================
                        // Jika SEMUA 0 → STOP
                        // ==============================
                        if (valT === 0 && valK === 0 && valA === 0) {
                            return;
                        }

                        // ==============================
                        // Aktifkan underline & modal
                        // ==============================
                        $(this).css({
                            cursor: 'pointer',
                            'text-decoration': 'underline',
                            'font-weight': 'bold',
                            color: 'blue'
                        }).on('click', function () {

                            $('#xtahun_laporan').val(data.TAHUN);
                            $('#xkd_dist').val(data.KD_DIST);

                            detailFilterParams = {
                                vtahun_laporan: data.TAHUN,
                                vkd_prov: data.KD_PROV,
                                vnama_prov: data.PROVINSI,
                                vinfolabel: columnName
                            };

                            console.log('Updated filter params:', detailFilterParams);
                            $('#dataModal').modal('show');
                        });

                    }
                });
            },
            // dom: 'lfrtip'
            dom: 'Bfrtip',
            buttons: [
                    {
                        extend: 'excelHtml5',
                        title: 'REKAP_PENGERJAAN_PEMASANGAN_' + $('#tahun_laporan').val(),
                        className: 'd-none',
                        exportOptions: {
                            format: {
                                body: function (data, row, column, node) {
                                    // Ambil semua kolom yang menggunakan formatNumber
                                    // const columnsRaw = [5,6,7,8,9,10,11]; // indeks kolom sesuai urutan kolom PLN_IDPEL - SELISIH_RPTAG

                                    // Jika kolom termasuk dalam Detail, hilangkan format ribuan (misal: "1.000.000" jadi "1000000")
                                    if (columnsRaw.includes(column)) {
                                        if (typeof data === 'string') {
                                            // Hilangkan titik ribuan dan koma desimal jika perlu
                                            return data.replace(/\./g, '').replace(/,/g, '');
                                        }
                                        return data;
                                    }
                                    return data;
                                }
                            }
                        },
                        customize: function (xlsx) {
                            const sheet = xlsx.xl.worksheets['sheet1.xml'];
                            const sheetData = $('sheetData', sheet);

                            const now = new Date();
                            const dd = String(now.getDate()).padStart(2, '0');
                            const mm = String(now.getMonth() + 1).padStart(2, '0');
                            const yyyy = now.getFullYear();
                            const hh = String(now.getHours()).padStart(2, '0');
                            const mi = String(now.getMinutes()).padStart(2, '0');
                            const ss = String(now.getSeconds()).padStart(2, '0');
                            const timestamp = dd+"/"+mm+"/"+yyyy+" "+hh+":"+mi+":"+ss;
                            const judul = "_REKAP_" + $('#tahun_laporan').val();

                            // Tambahkan judul dan timestamp jika dibutuhkan
                            // ...
                        }
                    }
                ]            
        });

        // Tampilkan spinnerOverlay saat DataTables mulai load data
        table.on('preXhr.dt', function () {
           $('#spinnerOverlay').show();  
        });

        // Sembunyikan spinnerOverlay setelah DataTables selesai load data
        table.on('xhr.dt', function () {
            $('#spinnerOverlay').hide();    // Saat selesai
        });

        $('#btnTampil').on('click', function () {
            if (!$('#tahun_laporan').val()) {
                alert("Silakan pilih Tahun Laporan terlebih dahulu!");
                return;
            }

            $('#spinnerOverlay').show();   // hanya tampilkan overlay modal
            table.ajax.reload();
        });
         
        // ---------------------------------------------------------------------------------------------
        // 1A-2) Ekspor halaman Monitoring Rekap ke Excel
        // ---------------------------------------------------------------------------------------------
        // $('#btnExportMonRkpAllExcel').on('click', function () {
        //     table.button('.buttons-excel').trigger();
        // });

        async function exportRekapPengerjaanExcel(vtahun_laporan) {

            if (!vtahun_laporan) {
                alert("Silakan isi Tahun Laporan terlebih dahulu.");
                return;
            }

            const btn = $('#btnExportMonRkpAllExcel2');
            $('#spinnerOverlay').show();
            btn.prop('disabled', true).text("Memuat... (0 data)");

            try {

                // ============================================================
                // 1. LOAD DATA
                // ============================================================
                let allData = [];

                const headers = [
                    "NO",
                    "TAHUN",
                    "KD_PROV",
                    "PROVINSI",
                    "JTR_RENCANA", 
                    "JTM_RENCANA",
                    "GRD_RENCANA",
                    "JTR_WO", 
                    "JTM_WO", 
                    "GRD_WO",
                    "JTR_PROGRES", 
                    "JTM_PROGRES", 
                    "GRD_PROGRES", 
                    "JTR_FINAL", 
                    "JTM_FINAL", 
                    "GRD_FINAL", 
                    "JTR_PROSEN", 
                    "JTM_PROSEN", 
                    "GRD_PROSEN"
                ];

                const params = new URLSearchParams();
                params.append("vtahun_laporan", vtahun_laporan);

                const response = await fetch(
                    getContextPath() + '/mon-pengerjaan-perprovupi',
                    {
                        method: "POST",
                        headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        body: params
                    }
                );

                if (!response.ok) {
                    throw new Error("HTTP Error " + response.status);
                }

                const json = await response.json();
                const data = json.data || [];

                if (data.length === 0) {
                    alert("Tidak ada data untuk diekspor.");
                    return;
                }

                data.forEach(function (item, idx) {
                    allData.push([
                        item.URUT != 5 ? (idx + 1) : "",
                        item.TAHUN || "",
                        item.KD_PROV || "",
                        item.PROVINSI || "",
                        item.JTR_RENCANA || "",
                        item.JTM_RENCANA || "",
                        item.GRD_RENCANA || "",
                        item.JTR_WO || "",
                        item.JTM_WO || "",
                        item.GRD_WO || "",
                        item.JTR_PROGRES || "",
                        item.JTM_PROGRES || "",
                        item.GRD_PROGRES || "",
                        item.JTR_FINAL   || "",
                        item.JTM_FINAL   || "",
                        item.GRD_FINAL   || "",
                        item.JTR_PROSEN  || "",
                        item.JTM_PROSEN  || "",
                        item.GRD_PROSEN  || ""
                    ]);
                });

                // ============================================================
                // 2. AOA (Array of Array)
                // ============================================================
                const timestamp = new Date().toLocaleString("id-ID");

                const rows = [
                    ["LISA - REKAP PENGERJAAN PEKERJAAN"],
                    ["TAHUN", ": " + vtahun_laporan],
                    ["TANGGAL DOWNLOAD", ": " + timestamp],
                    [],
                    headers
                ].concat(allData);

                // ============================================================
                // 3. SHEETJS
                // ============================================================
                const ws = XLSX.utils.aoa_to_sheet(rows);
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, "REKAP");

                const wbout = XLSX.write(wb, {
                    bookType: "xlsx",
                    type: "array"
                });

                // ============================================================
                // 4. XLSXPOPULATE STYLING
                // ============================================================
                const filename =
                    'REKAP_PENGERJAAN_PEMASANGAN_PROV_' + vtahun_laporan + '.xlsx';

                await XlsxPopulate.fromDataAsync(wbout)
                    .then(function (workbook) {

                        const sheet = workbook.sheet(0);
                        const totalCols = headers.length;
                        const lastCol = String.fromCharCode(64 + totalCols);
                        const lastRow = rows.length;

                        // Judul
                        sheet.range("A1:" + lastCol + "1")
                            .merged(true)
                            .style({
                                bold: true,
                                horizontalAlignment: "left",
                                fontSize: 14
                            });
                        
                        // 👉 TAMBAHKAN DI SINI
                        sheet.range("A2:B2").style({ bold: true }); // TAHUN
                        sheet.range("A3:B3").style({ bold: true }); // TANGGAL DOWNLOAD


                        // Header
                        sheet.range("A5:" + lastCol + "5")
                            .style({
                                bold: true,
                                fill: "CCCCCC",
                                border: true,
                                horizontalAlignment: "center",
                                verticalAlignment: "center"
                            });

                        // Border data
                        sheet.range("A5:" + lastCol + lastRow)
                            .style({ border: true });

                        // Lebar kolom
                        for (var c = 1; c <= totalCols; c++) {
                            sheet.column(c).width(22);
                        }

                        return workbook.outputAsync();
                    })
                    .then(function (blob) {
                        saveAs(blob, filename);
                    });

            } catch (e) {
                console.error(e);
                alert("Terjadi error: " + e.message);
            } finally {
                btn.prop('disabled', false).text("Export Excel Rekap");
                $('#spinnerOverlay').hide();
            }
        }
    
        $('#btnExportMonRkpAllExcel2').on('click', async function () {
            exportRekapPengerjaanExcel($('#tahun_laporan').val());
        });

        // ---------------------------------------------------------------------------------------------
        // 1B-1) show Data Monitoring Detail/Detail PerUpi Modal Large 
        // ---------------------------------------------------------------------------------------------
        let lastPageBeforeSearchDetail = 0;
        let detailTable = null;

        $('#dataModal').on('shown.bs.modal', function () {

            $('#dataModalLabel').text('Detail Data : ' + detailFilterParams.vinfolabel);

            // 🔥 Jika tabel sudah ada → reload saja
            if (detailTable) {
                detailTable.ajax.reload(null, true);
                return;
            }

            // 🔥 Inisialisasi DataTable
            detailTable = $('#table_mondaf_provupi').DataTable({
                processing: true,
                serverSide: true,
                scrollX: true,
                ajax: {
                    url: getContextPath() + '/mon-pengerjaan-perprovupi',
                    type: 'POST',
                    data: function (d) {
                        d.act = 'detailData';
                        d.vtahun_laporan = detailFilterParams.vtahun_laporan;
                        d.vkd_prov = detailFilterParams.vkd_prov;
                        d.vinfolabel = detailFilterParams.vinfolabel;
                        console.log('Kirim data ke server:', d);
                    },
                    dataSrc: function (json) {
                        console.log('Response dari server:', json);
                        return json.data || [];
                    }
                },
                columns: [
                    { data: null, orderable: false, className: 'text-center', render: (data, type, row, meta) => meta.row + meta.settings._iDisplayStart + 1 },
                    { data: 'INFOLABEL' },
                    { data: 'NOMOR_KONTRAK_RINCI' },
                    { data: 'KATEGORI_PEMBANGUNAN' },
                    { data: 'TRANSMISI' },
                    { data: 'MATERIAL_GROUP' },
                    { data: 'KODE_MATERIAL' },
                    { data: 'NAMA_MATERIAL' },
                    { data: 'JUMLAH_MDU', defaultContent: '', render: d => formatNumber(d, 0) },
                    { data: 'SATUAN' },
                    { data: 'TAHUN' },
                    { data: 'KD_PROV' },
                    { data: 'PROVINSI' },
                    { data: 'KD_KAB' },
                    { data: 'KABUPATENKOTA' },
                    { data: 'KD_KEC' },
                    { data: 'KECAMATAN' },
                    { data: 'KD_KEL' },
                    { data: 'DESAKELURAHAN' },
                    { data: 'UNITUPI' },
                    { data: 'NAMA_UNITUPI' },
                    { data: 'UNITAP' },
                    { data: 'NAMA_UNITAP' },
                    { data: 'UNITUP' },
                    { data: 'NAMA_UNITUP' },
                    { data: 'ID_PERENCANAAN' },
                    { data: 'NOMOR_KONTRAK' },
                    { data: 'KODE_PEMBANGUNAN' },
                    { data: 'MATERIAL_GROUP_ID' }
                ],

                // 🔥 Format cell
                createdRow: function (row, data) {
                    const api = this.api();
                    const allowedColumns = [
                        'KATEGORI_PEMBANGUNAN',
                        'MATERIAL_GROUP',
                        'KODE_MATERIAL',
                        'NAMA_MATERIAL',
                        'JUMLAH_MDU',
                        'SATUAN',
                        'NOMOR_KONTRAK_RINCI'
                    ];

                    $('td', row).each(function (colIndex) {
                        const columnDef = api.settings()[0].aoColumns[colIndex];
                        const columnName = columnDef.data;
                        if (!columnName || !allowedColumns.includes(columnName)) return;

                        const cellValue = data[columnName];
                        const formattedValue = columnName === 'JUMLAH_MDU' ? formatNumber(cellValue, 0) : cellValue;

                        $(this)
                            .text(formattedValue)
                            .addClass('dt-clickable-bold')
                            .css({
                                cursor: 'pointer',
                                'font-weight': 'bold',
                                'text-align': columnName === 'JUMLAH_MDU' ? 'right' : 'left'
                            });
                    });
                },

                // 🔥 Subtotal + garis akhir NOMOR_KONTRAK_RINCI
                drawCallback: function () {

                    const api = this.api();
                    const rowsData  = api.rows({ page: 'current' }).data();
                    const rowsNodes = api.rows({ page: 'current' }).nodes();
                    if (!rowsData.length) return;

                    const $tbody = $(rowsNodes).closest('tbody');

                    // reset redraw
                    $tbody.find(
                        'tr.subtotal-row, tr.end-kontrak-row, tr.start-kontrak-row'
                    ).remove();

                    const colQtyIndex = api.settings()[0].aoColumns.findIndex(
                        c => c.data === 'JUMLAH_MDU'
                    );
                    if (colQtyIndex === -1) return;

                    let lastGroup   = null;
                    let lastKontrak = null;
                    let subtotal    = 0;

                    const groupColors = {
                        'TIANG': '#e0f7fa',
                        'KABEL': '#fff3e0',
                        'AKSESORIS': '#e8f5e9'
                    };

                    rowsData.each(function (rowData, i) {

                        const group   = (rowData.MATERIAL_GROUP || '(TANPA GROUP)').trim();
                        const kontrak = (rowData.NOMOR_KONTRAK_RINCI || '').trim();
                        const qty     = Number(rowData.JUMLAH_MDU) || 0;

                        /* ==========================
                        * START KONTRAK RINCI
                        * ========================== */
                        if (i === 0 || kontrak !== lastKontrak) {
                            insertStartOfKontrak(rowsNodes[i], kontrak);
                        }

                        /* ==========================
                        * GANTI KONTRAK RINCI
                        * ========================== */
                        if (lastKontrak !== null && kontrak !== lastKontrak) {

                            // tutup subtotal group terakhir kontrak lama
                            insertSubtotal(
                                rowsNodes[i],
                                lastGroup,
                                subtotal,
                                colQtyIndex,
                                groupColors[lastGroup] || '#f5f5f5'
                            );

                            // END OF KONTRAK RINCI
                            insertEndOfKontrak(rowsNodes[i], lastKontrak);

                            subtotal  = 0;
                            lastGroup = null;
                        }

                        /* ==========================
                        * GANTI MATERIAL GROUP
                        * ========================== */
                        if (lastGroup !== null && group !== lastGroup) {
                            insertSubtotal(
                                rowsNodes[i],
                                lastGroup,
                                subtotal,
                                colQtyIndex,
                                groupColors[lastGroup] || '#f5f5f5'
                            );
                            subtotal = 0;
                        }

                        subtotal   += qty;
                        lastGroup   = group;
                        lastKontrak = kontrak;
                    });

                    /* ==========================
                    * TUTUP KONTRAK TERAKHIR
                    * ========================== */
                    insertSubtotal(
                        null,
                        lastGroup,
                        subtotal,
                        colQtyIndex,
                        groupColors[lastGroup] || '#f5f5f5'
                    );

                    insertEndOfKontrak(null, lastKontrak);

                    /* =================================================
                    * FUNGSI START OF KONTRAK
                    * ================================================= */
                    function insertStartOfKontrak(refNode, nomorKontrak) {

                        if (!nomorKontrak) return;

                        const totalCols = api.columns().count();

                        let html =
                            '<tr class="start-kontrak-row">' +
                                '<td colspan="' + totalCols + '" class="start-kontrak-text">' +
                                    'START OF KONTRAK RINCI : ' + nomorKontrak +
                                '</td>' +
                            '</tr>';

                        $(refNode).before(html);
                    }

                    /* =================================================
                    * FUNGSI SUBTOTAL
                    * ================================================= */
                    function insertSubtotal(refNode, group, value, colIndex, bgColor) {

                        if (!group) return;

                        const totalCols = api.columns().count();
                        let html =
                            '<tr class="subtotal-row fw-bold" style="background-color:' + bgColor + '">';

                        for (let i = 0; i < totalCols; i++) {
                            if (i === 0) {
                                html += '<td>TOTAL ' + group + '</td>';
                            } else if (i === colIndex) {
                                html += '<td class="stynumeric">' +
                                        formatNumber(value, 0) +
                                        '</td>';
                            } else {
                                html += '<td></td>';
                            }
                        }

                        html += '</tr>';

                        if (refNode) {
                            $(refNode).before(html);
                        } else {
                            $tbody.append(html);
                        }
                    }

                    /* =================================================
                    * FUNGSI END OF KONTRAK
                    * ================================================= */
                    function insertEndOfKontrak(refNode, nomorKontrak) {

                        if (!nomorKontrak) return;

                        const totalCols = api.columns().count();

                        let html =
                            '<tr class="end-kontrak-row">' +
                                '<td colspan="' + totalCols + '" class="end-kontrak-text">' +
                                    'END OF KONTRAK RINCI : ' + nomorKontrak +
                                '</td>' +
                            '</tr>';

                        if (refNode) {
                            $(refNode).before(html);
                        } else {
                            $tbody.append(html);
                        }
                    }
                },

                lengthMenu: [[10, 100, 1000], [10, 100, 1000]]
            });

            // Simpan page sebelum search
            detailTable.on('page.dt', () => {
                if (!detailTable.search()) lastPageBeforeSearchDetail = detailTable.page();
            });

            // Force ke page 0 saat search
            detailTable.on('preXhr.dt', (e, settings, data) => {
                if (detailTable.search()) {
                    settings._iDisplayStart = 0;
                    data.start = 0;
                }
            });

            // Kembali ke page sebelum search
            detailTable.on('search.dt', () => {
                if (!detailTable.search()) {
                    setTimeout(() => {
                        detailTable.page(lastPageBeforeSearchDetail).draw('page');
                    }, 300);
                }
            });

        });
       
        // ----------------------------------------------------------------------------
        // 1B-2) Export ke exel semua data MON Detail
        // ----------------------------------------------------------------------------
        // Fungsi format angka ribuan (lokal Indonesia)
        const formatRibuan = (angka) => new Intl.NumberFormat('id-ID').format(angka);

        // Ambil nama UID/UIW PLN  dari DB
        async function fetchNamaUnitUPI(kd_dist) {
            const params = new URLSearchParams();
            params.append('act', 'getNamaUnitUPI');
            params.append('kd_dist', kd_dist);

            const response = await fetch(getContextPath() + '/mon-pengerjaan-perprovupi', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });

            if (!response.ok) throw new Error("Gagal mengambil data UNITUPI");

            const json = await response.json();
            if (json.status !== 'success') throw new Error("Data UNITUPI tidak ditemukan");

            return json.data.NAMA_DIST || '';
        }

        /* =========================================================
        * HELPER
        * ========================================================= */
        function safeName(str) {
            return String(str || '')
                .replace(/[\\\/:*?"<>|]/g, '')
                .replace(/\s+/g, '_')
                .toUpperCase();
        }

        function styleRow(row, fromCol, toCol, opt = {}) {
            for (let c = fromCol; c <= toCol; c++) {
                const cell = row.getCell(c);

                cell.border = {
                    top: { style: 'thin' },
                    left: { style: 'thin' },
                    bottom: { style: 'thin' },
                    right: { style: 'thin' }
                };

                if (opt.bold) {
                    cell.font = Object.assign({}, cell.font, { bold: true });
                }

                if (opt.fill) {
                    cell.fill = {
                        type: 'pattern',
                        pattern: 'solid',
                        fgColor: { argb: opt.fill }
                    };
                }
            }
        }

        /* =========================================================
        * EXPORT EXCEL
        * ========================================================= */
        $('#btnExportMonDftAllExcelOneSheet').on('click', async function () {

            const btn = $(this);
            $('#spinnerOverlay').show();
            btn.prop('disabled', true).text('Memuat...');

            try {

                /* ================= PARAM ================= */
                const {
                    vtahun_laporan,
                    vinfolabel
                } = detailFilterParams;

                if (!vtahun_laporan || !vinfolabel) {
                    alert('Filter belum lengkap');
                    return;
                }

                /* ================= AMBIL DATA ================= */
                const pageSize = 1000;
                let start = 0;
                let draw = 1;
                let dataAll = [];

                while (true) {
                    const params = new URLSearchParams({
                        act: 'detailData',
                        vtahun_laporan,
                        vinfolabel,
                        start,
                        length: pageSize,
                        draw: draw++
                    });

                    const res = await fetch(getContextPath() + '/mon-pengerjaan-perprovupi', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    });

                    const json = await res.json();
                    if (!json.data || !json.data.length) break;

                    dataAll.push(...json.data);
                    if (json.data.length < pageSize) break;
                    start += pageSize;
                }

                if (!dataAll.length) {
                    alert('Data kosong');
                    return;
                }

                /* ================= SORT DATA ================= */
                const groupOrder = ['TIANG', 'KABEL', 'AKSESORIS'];

                dataAll.sort((a, b) => {
                    const ga = a.MATERIAL_GROUP || '';
                    const gb = b.MATERIAL_GROUP || '';

                    const indexA = groupOrder.indexOf(ga) !== -1 ? groupOrder.indexOf(ga) : groupOrder.length;
                    const indexB = groupOrder.indexOf(gb) !== -1 ? groupOrder.indexOf(gb) : groupOrder.length;

                    if (indexA !== indexB) return indexA - indexB;

                    return (a.NOMOR_KONTRAK_RINCI || '').localeCompare(b.NOMOR_KONTRAK_RINCI || '') ||
                        (a.NAMA_MATERIAL || '').localeCompare(b.NAMA_MATERIAL || '');
                });

                /* ================= WORKBOOK ================= */
                const workbook = new ExcelJS.Workbook();
                workbook.creator = 'Monitoring PLN';
                workbook.created = new Date();

                const ws = workbook.addWorksheet('DETAIL', { properties: { outlineLevelRow: true } });

                ws.views = [{
                    showOutlineSymbols: true,
                    state: 'frozen',
                    ySplit: 7
                }];

                /* ================= STYLE HELPER ================= */
                function styleRow(row, startCol, endCol, opt = {}) {
                    for (let c = startCol; c <= endCol; c++) {
                        const cell = row.getCell(c);
                        cell.border = {
                            top: { style: 'thin' },
                            left: { style: 'thin' },
                            bottom: { style: 'thin' },
                            right: { style: 'thin' }
                        };
                        if (opt.bold) cell.font = { bold: true };
                        if (opt.fill) {
                            cell.fill = {
                                type: 'pattern',
                                pattern: 'solid',
                                fgColor: { argb: opt.fill }
                            };
                        }
                    }
                }

                /* ================= HEADER ATAS ================= */
                const title = ws.addRow(['REKAP DETAIL PENGERJAAN']);
                ws.mergeCells(title.number, 1, title.number, 29);
                styleRow(title, 1, 29, { bold: true });

                ws.addRows([
                    ['TAHUN', vtahun_laporan],
                    ['KETERANGAN', vinfolabel],
                    ['TANGGAL DOWNLOAD', new Date().toLocaleString('id-ID')],
                    []
                ]);

                /* ================= HEADER TABEL ================= */
                const header = ws.addRow([
                    'NO','INFOLABEL','KATEGORI','TRANSMISI',
                    'MATERIAL_GROUP_ID','MATERIAL_GROUP','KODE_MATERIAL','NAMA_MATERIAL',
                    'JUMLAH_MDU','SATUAN','TAHUN','KD_PROV','PROVINSI',
                    'KD_KAB','KABUPATEN','KD_KEC','KECAMATAN',
                    'KD_KEL','DESA','UNITUPI','NAMA_UNITUPI',
                    'UNITAP','NAMA_UNITAP','UNITUP','NAMA_UNITUP',
                    'ID_PERENCANAAN','NOMOR_KONTRAK','NOMOR_KONTRAK_RINCI','KODE_PEMBANGUNAN'
                ]);
                styleRow(header, 1, 29, { bold: true, fill: 'E0E0E0' });

                /* ================= DATA LOOP ================= */
                let no = 1;
                let lastKontrak = null;
                let lastGroup = null;
                let subtotalGroup = 0;

                for (const d of dataAll) {
                    const kontrak = d.NOMOR_KONTRAK_RINCI || '';
                    const group = d.MATERIAL_GROUP || '';
                    const qty = Number(d.JUMLAH_MDU) || 0;

                    /* === GANTI KONTRAK === */
                    if (lastKontrak && kontrak !== lastKontrak) {
                        /* SUBTOTAL GROUP SEBELUM KONTRAK BERUBAH */
                        if (lastGroup) {
                            const rSub = ws.addRow([
                                'SUBTOTAL ' + lastGroup, '', '', '', '', '', '', '', subtotalGroup
                            ]);
                            for (let c = 2; c <= 29; c++) if (c !== 9) rSub.getCell(c).value = '';
                            styleRow(rSub, 1, 29, { bold: true, fill: 'FFF7CC' });
                            subtotalGroup = 0;
                        }

                        /* END KONTRAK */
                        const rEnd = ws.addRow(['END KONTRAK RINCI : ' + lastKontrak]);
                        ws.mergeCells(rEnd.number, 1, rEnd.number, 29);
                        styleRow(rEnd, 1, 29, { bold: true, fill: 'FFE0B2' });
                        rEnd.outlineLevel = 0;

                        lastGroup = null;
                    }

                    /* START KONTRAK */
                    if (kontrak !== lastKontrak) {
                        const rStart = ws.addRow(['START KONTRAK RINCI : ' + kontrak]);
                        ws.mergeCells(rStart.number, 1, rStart.number, 29);
                        styleRow(rStart, 1, 29, { bold: true, fill: 'E3F2FD' });
                        rStart.outlineLevel = 0;
                    }

                    /* GANTI GROUP */
                    if (lastGroup && group !== lastGroup) {
                        const rSub = ws.addRow([
                            'SUBTOTAL ' + lastGroup, '', '', '', '', '', '', '', subtotalGroup
                        ]);
                        for (let c = 2; c <= 29; c++) if (c !== 9) rSub.getCell(c).value = '';
                        styleRow(rSub, 1, 29, { bold: true, fill: 'FFF7CC' });
                        subtotalGroup = 0;
                    }

                    /* DETAIL ROW */
                    const r = ws.addRow([
                        no++, d.INFOLABEL, d.KATEGORI_PEMBANGUNAN, d.TRANSMISI,
                        d.MATERIAL_GROUP_ID, d.MATERIAL_GROUP, d.KODE_MATERIAL, d.NAMA_MATERIAL,
                        qty, d.SATUAN, d.TAHUN, d.KD_PROV, d.PROVINSI,
                        d.KD_KAB, d.KABUPATENKOTA, d.KD_KEC, d.KECAMATAN,
                        d.KD_KEL, d.DESAKELURAHAN, d.UNITUPI, d.NAMA_UNITUPI,
                        d.UNITAP, d.NAMA_UNITAP, d.UNITUP, d.NAMA_UNITUP,
                        d.ID_PERENCANAAN, d.NOMOR_KONTRAK, d.NOMOR_KONTRAK_RINCI, d.KODE_PEMBANGUNAN
                    ]);
                    styleRow(r, 1, 29);
                    r.outlineLevel = 1;
                    r.hidden = true;

                    subtotalGroup += qty;
                    lastGroup = group;
                    lastKontrak = kontrak;
                }

                /* SUBTOTAL TERAKHIR */
                if (lastGroup) {
                    const rSub = ws.addRow([
                        'SUBTOTAL ' + lastGroup, '', '', '', '', '', '', '', subtotalGroup
                    ]);
                    for (let c = 2; c <= 29; c++) if (c !== 9) rSub.getCell(c).value = '';
                    styleRow(rSub, 1, 29, { bold: true, fill: 'FFF7CC' });
                }

                /* END KONTRAK TERAKHIR */
                if (lastKontrak) {
                    const rEnd = ws.addRow(['END KONTRAK RINCI : ' + lastKontrak]);
                    ws.mergeCells(rEnd.number, 1, rEnd.number, 29);
                    styleRow(rEnd, 1, 29, { bold: true, fill: 'FFE0B2' });
                    rEnd.outlineLevel = 0;
                }

                /* ================= SAVE ================= */
                const buffer = await workbook.xlsx.writeBuffer();
                saveAs(
                    new Blob([buffer]),
                    'DETAIL_' + vtahun_laporan + '_' + vinfolabel + '.xlsx'
                );

            } catch (e) {
                console.error(e);
                alert('Gagal export: ' + e.message);
            } finally {
                btn.prop('disabled', false).text('Export Excel');
                $('#spinnerOverlay').hide();
            }
        });

    });
</script>
