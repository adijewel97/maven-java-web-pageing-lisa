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
                    <th>TAHUN</th>
                    <th>KD_PROV</th>
                    <th>PROVINSI</th>
                    <th>ID_PERENCANAAN</th>
                    <th>NOMOR_KONTRAK</th>
                    <th>NOMOR_KONTRAK_RINCI</th>
                    <th>KODE_PEMBANGUNAN</th>
                    <th>KATEGORI_PEMBANGUNAN</th>
                    <th>TRANSMISI</th>
                    <th>MATERIAL_GROUP_ID</th>
                    <th>MATERIAL_GROUP</th>
                    <th>KODE_MATERIAL</th>
                    <th>NAMA_MATERIAL</th>
                    <th>JUMLAH_PERENCANAAN</th>
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
        Monitoring - Pengerjaan Pemasangan LISA
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
                        <thead>
                            <tr>
                                <th>NO</th>
                                <th>TAHUN</th>
                                <th>KD_PROV</th>
                                <th>PROVINSI</th>
                                <th>JTR_RENCANA</th>
                                <th>JTM_RENCANA</th>
                                <th>GRD_RENCANA</th>
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
                { data: 'JTR_RENCANA', render: data => formatNumber(data, 0) },
                { data: 'JTM_RENCANA', render: data => formatNumber(data, 0) },
                { data: 'GRD_RENCANA', render: data => formatNumber(data, 0) },
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
            ],
            createdRow: function (row, data, dataIndex) {
            //    if (data.URUT == 5) {
            //         $('td', row).css({
            //             'font-weight': 'bold',
            //             // 'background-color': 'black',
            //             // 'color': 'white'
            //         });
            //     }

                $('td', row).each(function (colIndex) {

                    const columnDef = table.settings()[0].aoColumns[colIndex];
                    const columnName = columnDef.data;
                    if (!columnName) return;

                    const cellValue = data[columnName];
                    const allowedColumns = ['JTR_RENCANA', 'JTM_RENCANA', 'GRD_RENCANA'];

                    if (
                        allowedColumns.includes(columnName) &&
                        typeof cellValue === 'string' &&
                        cellValue.trim() !== '' &&
                        (data.URUT == 1)
                    ) {

                        // ==============================
                        // Ambil nilai T, K, A dari string
                        // ==============================
                        const t = cellValue.match(/T=\s*(\d+)/);
                        const k = cellValue.match(/K=\s*(\d+)/);
                        const a = cellValue.match(/A=\s*(\d+)/);

                        const valT = t ? parseInt(t[1]) : 0;
                        const valK = k ? parseInt(k[1]) : 0;
                        const valA = a ? parseInt(a[1]) : 0;

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
                            color: 'blue'
                        }).off('click').on('click', function () {

                            $('#xtahun_laporan').val(data.TAHUN);
                            $('#xkd_dist').val(data.KD_DIST);

                            detailFilterParams = {
                                vtahun_laporan: data.TAHUN,
                                vkd_prov: data.KD_PROV,
                                vinfolabel: columnName   // ← nama kolom yang diklik 
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
                    "GRD_RENCANA"
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
                        item.GRD_RENCANA || ""
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
                    'REKAP_PENGERJAAN_PEMASANGAN_' + vtahun_laporan + '.xlsx';

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
                                horizontalAlignment: "center",
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
        // let lastPageBeforeSearchDetail = 0;

        $('#dataModal').on('shown.bs.modal', function () {
            $('#dataModalLabel').text('Detail Data : '+detailFilterParams.vinfolabel);

            if ($.fn.DataTable.isDataTable('#table_mondaf_provupi')) {
                $('#table_mondaf_provupi').DataTable().clear().destroy();
            }

            const detailTable = $('#table_mondaf_provupi').DataTable({
                processing: true,
                serverSide: true,
                scrollX: true,
                ajax: {
                    url: getContextPath() + '/mon-pengerjaan-perprovupi',
                    type: 'POST',
                    data: function (d) {
                        d.act         = 'detailData';
                        d.vtahun_laporan = detailFilterParams.vtahun_laporan;
                        d.vkd_prov       = detailFilterParams.vkd_prov;
                        d.vinfolabel     = detailFilterParams.vinfolabel;
                        console.log('Kirim data ke server:', d);
                    },
                    dataSrc: function (json) {
                        console.log('Response dari server:', json);
                        return json.data || [];
                    }
                },
                columns: [
                    {
                        data: null,
                        render: function (data, type, row, meta) {
                            return meta.row + meta.settings._iDisplayStart + 1;
                        },
                        className: 'text-center',
                        orderable: false
                    },
                    // {data:'TOTAL_COUNT'},
                    {data:'INFOLABEL'},
                    {data:'TAHUN'},
                    {data:'KD_PROV'},
                    {data:'PROVINSI'},
                    {data:'ID_PERENCANAAN'},
                    {data:'NOMOR_KONTRAK'},
                    {data:'NOMOR_KONTRAK_RINCI'},
                    {data:'KODE_PEMBANGUNAN'},
                    {data:'KATEGORI_PEMBANGUNAN'},
                    {data:'TRANSMISI'},
                    {data:'MATERIAL_GROUP_ID'},
                    {data:'MATERIAL_GROUP'},
                    {data:'KODE_MATERIAL'},
                    {data:'NAMA_MATERIAL'},
                    {data:'JUMLAH_PERENCANAAN'},
                    // {data:'ROW_NUMBER'}
                ],
                // columnDefs: [
                //     { targets: [10, 11, 20, 21, 26, 27], className: 'dt-body-right', orderable: false }
                // ],
                lengthMenu: [[10, 100, 1000], [10, 100, 1000]]
            });

            // Simpan halaman terakhir saat berpindah halaman (jika tidak sedang search)
            detailTable.on('page.dt', function () {
                if (!detailTable.search()) {
                    lastPageBeforeSearchDetail = detailTable.page();
                    console.log('Halaman disimpan sebelum search:', lastPageBeforeSearchDetail);
                }
            });

            // Force ke halaman 0 saat search aktif
            detailTable.on('preXhr.dt', function (e, settings, data) {
                const keyword = detailTable.search();
                if (keyword && keyword.length > 0) {
                    console.log('preXhr: sedang search, paksa ke page 0');
                    settings._iDisplayStart = 0;
                    data.start = 0;
                }
            });

            // Kembali ke halaman sebelumnya saat pencarian dikosongkan
            detailTable.on('search.dt', function () {
                const keyword = detailTable.search();
                if (keyword.length === 0) {
                    console.log('Search dikosongkan, kembali ke halaman:', lastPageBeforeSearchDetail);
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

        $('#btnExportMonDftAllExcelOneSheet').on('click', async function () {
            const btn = $(this);
            let totalLoaded = 0;

            $('#spinnerOverlay').show();
            await new Promise(resolve => setTimeout(resolve, 30));

            btn.prop('disabled', true).text("Memuat... (" + formatRibuan(totalLoaded) + " data)");

            const vtahun_laporan = detailFilterParams.vtahun_laporan;
            const vkd_prov = detailFilterParams.vkd_prov;
            const vinfolabel = detailFilterParams.vinfolabel;

            if (!vtahun_laporan || !vinfolabel || !vkd_prov) {
                alert('Silakan lengkapi filter terlebih dahulu!');
                btn.prop('disabled', false).text('Export Excel Per-UID/UIW/Per-Provinsi');
                return;
            }

            let namaUPI  = '';
            try {
                const pageSize = 1000;
                let start = 0;
                let allData = [];
                let drawCounter = 1;

                const headers = {
                    TOTAL_COUNT          : '',
                    INFOLABEL            : '',
                    TAHUN                : '',
                    KD_PROV              : '',
                    PROVINSI             : '',
                    ID_PERENCANAAN       : '',
                    NOMOR_KONTRAK        : '',
                    NOMOR_KONTRAK_RINCI  : '',
                    KODE_PEMBANGUNAN     : '',
                    KATEGORI_PEMBANGUNAN : '',
                    TRANSMISI            : '',
                    MATERIAL_GROUP_ID    : '',
                    MATERIAL_GROUP       : '',
                    KODE_MATERIAL        : '',
                    NAMA_MATERIAL        : '',
                    JUMLAH_PERENCANAAN   : '',
                    ROW_NUMBER           : ''
                }; 

                while (true) {
                    const params = new URLSearchParams();
                    params.append('act', 'detailData');
                    params.append('vtahun_laporan', vtahun_laporan);
                    params.append('vkd_prov', vkd_prov);
                    params.append('vinfolabel', vinfolabel);
                    params.append('start', start);
                    params.append('length', pageSize);
                    params.append('draw', drawCounter++);
                    params.append('order[0][column]', '0');
                    params.append('order[0][dir]', 'asc');
                    params.append('columns[0][data]', 'KD_DIST');
                    params.append('search[value]', '');

                    const response = await fetch(getContextPath() + '/mon-pengerjaan-perprovupi', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: params.toString()
                    });

                    if (!response.ok) {
                        const errorText = await response.text();
                        throw new Error('Status: ' + response.status + '\n' + errorText);
                    }

                    const json = await response.json();
                    const data = json.data;
                    if (!data || data.length === 0) break;

                    const formatted = data.map((item, index) => {
                        const row = { NO: start + index + 1 };
                        Object.keys(headers).forEach(key => {
                            row[key] = item[key] || '';
                        });
                        return row;
                    });

                    allData = allData.concat(formatted);
                    totalLoaded += data.length;
                    btn.text("Memuat... (" + formatRibuan(totalLoaded) + " data)");
                    await new Promise(resolve => setTimeout(resolve, 10));
                    if (data.length < pageSize) break;

                    start += pageSize;
                }

                if (allData.length === 0) {
                    alert('Tidak ada data untuk diekspor!');
                    return;
                }

                // Buat timestamp dan judul
                const now = new Date();
                const dd = String(now.getDate()).padStart(2, '0');
                const mm = String(now.getMonth() + 1).padStart(2, '0');
                const yyyy = now.getFullYear();
                const hh = String(now.getHours()).padStart(2, '0');
                const mi = String(now.getMinutes()).padStart(2, '0');
                const ss = String(now.getSeconds()).padStart(2, '0');
                const timestamp = dd + "/" + mm + "/" + yyyy + " " + hh + ":" + mi + ":" + ss;
                const judul1 = " REKON DETAIL";

                // Susun data untuk Excel
                const rows = [];
                rows.push([{ v: judul1, s: { font: { bold: true } } }]); // Tetap satu sel di A1
                rows.push([
                    { v: "BULAN", s: { font: { bold: true } } },
                    { v: ": "+ vtahun_laporan.substring(4, 6) + '/' + vtahun_laporan.substring(0, 4)  }
                ]);
                rows.push([
                    { v: "POVINSI", s: { font: { bold: true } } },
                    { v: ": "+ vkd_prov }
                ]);
                rows.push([
                    { v: "KETERANGAN ", s: { font: { bold: true } } },
                    { v: ": " + vinfolabel }
                ]);
                rows.push([
                    { v: "TANGGAL DOWNLOAD", s: { font: { bold: true } } },
                    { v: ": "+ timestamp}
                ]); // Tetap satu sel
                rows.push([]); // baris kosong biasa
                rows.push(['NO', ...Object.keys(headers)]); // header kolom biasa

                allData.forEach(row => {
                    const dataRow = ["" + row.NO]; // NO sebagai string
                    Object.keys(headers).forEach(key => {
                        dataRow.push(row[key] || '');
                    });
                    rows.push(dataRow);
                });

                // Buat worksheet dan workbook
                const ws = XLSX.utils.aoa_to_sheet(rows);

                // Merge A1 sampai kolom akhir (A1-Z1 misal)
                // ws['!merges'] = [{ s: { r: 0, c: 0 }, e: { r: 0, c: Object.keys(headers).length } }];

                // Lebar kolom
                ws['!cols'] = Array(Object.keys(headers).length + 1).fill({ wch: 20 });

                // Simpan file
                const wb = XLSX.utils.book_new();
                XLSX.utils.book_append_sheet(wb, ws, 'REKON_PLNvsBANK');
                const filename = "_REKON_DETAIL_" + vtahun_laporan + "_" + vkd_prov + "_" + vinfolabel + ".xlsx";
                XLSX.writeFile(wb, filename);

            } catch (err) {
                alert('Terjadi error: ' + err.message);
                namaBank = '';
                console.error(err);
            } finally {
                btn.prop('disabled', false).text('Export Excel Per-UID/UIW');
                $('#spinnerOverlay').hide();
            }
        });

    });
</script>
