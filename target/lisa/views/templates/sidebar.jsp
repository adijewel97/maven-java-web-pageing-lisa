<style>
    /* Menu sidebar aktif - tanpa background */
    .sidebar-dark-primary .nav-sidebar .nav-link.active {
        background-color: transparent !important;
        color: #ffffff !important;
        font-weight: bold;
        border-left: 4px solid transparent;
    }

    .sidebar-dark-primary .nav-sidebar .nav-link.active i {
        color: #ffffff !important;
    }

    /* Ukuran font label sidebar */
    .sidebar .nav-sidebar .nav-link p {
        font-size: 0.8rem; /* atau 12px */
    }

    /* Indentasi teks submenu (nav-treeview) */
    .sidebar .nav-treeview .nav-link {
        padding-left: 3rem; /* Tambah dari default 1rem → lebih menjorok */
        font-size: 0.8rem; /* Ukuran kecil jika diinginkan */
    }
</style>

<!-- Sidebar -->
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
    <a href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard" class="brand-link">
        <img src="${pageContext.request.contextPath}/assets/images/logo-mivPLNBANK.png" alt="Logo" class="brand-image img-circle">
        <span class="brand-text font-weight-light">LISA-ListrikMasukDesa</span>
    </a>

    <!-- Sidebar Menu -->
    <div class="sidebar">
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column"
                data-widget="treeview"
                role="menu"
                data-accordion="false">

                <!-- Dashboard -->
                <li class="nav-item">
                    <a href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard"
                       class="nav-link <%= "dashboard".equals(request.getAttribute("menu")) ? "active" : "" %>">
                        <i class="nav-icon fas fa-tachometer-alt"></i>
                        <p>Dashboard</p>
                    </a>
                </li>

                <!-- Monitoring Menu -->
                <%
                    String menuAttr = (String) request.getAttribute("menu");
                    boolean monitoringActive =
                        "monitoring-penerjaan-pemasangan-provupi".equals(menuAttr) ||
                        "Daftar-prov-upi".equals(menuAttr) ||
                        "monitoring-rekon-upi".equals(menuAttr)||
                        "monitoring-material-perkontrak-provupi".equals(menuAttr); // <-- DITAMBAHKAN
                %>
                <li class="nav-item has-treeview <%= monitoringActive ? "menu-open" : "" %>">
                    <a href="#" class="nav-link <%= monitoringActive ? "active" : "" %>">
                        <i class="nav-icon fas fa-tasks"></i>
                        <p>
                            Monitoring - LISA
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                        <!-- Submenu Monitoring Rekon UPI -->
                        <li class="nav-item">
                            <a href="index.jsp?page=/views/monitoring/v1a_mon_perprovupi.jsp&menu=monitoring-penerjaan-pemasangan-provupi"
                               class="nav-link <%= "monitoring-penerjaan-pemasangan-provupi".equals(menuAttr) ? "active" : "" %>">
                                <p>Mon Pengerjaan Pemasangan LISA</p>
                            </a>
                        </li>
                    </ul>
                    <ul class="nav nav-treeview">
                        <!-- Submenu Monitoring Rekon UPI -->
                        <li class="nav-item">
                            <a href="index.jsp?page=/views/monitoring/v2a_mon_materialperkontrak.jsp&menu=monitoring-material-perkontrak-provupi"
                               class="nav-link <%= "monitoring-material-perkontrak-provupi".equals(menuAttr) ? "active" : "" %>">
                                <p>Mon Material PerKontrak LISA</p>
                            </a>
                        </li>
                    </ul>
                </li>

            </ul>
        </nav>
    </div>
</aside>

<script>
  // Peta menu -> Judul
  const pageTitleMap = {
    'dashboard': 'Dashboard',
    'monitoring-penerjaan-pemasangan-provupi': 'Monitoring - Pengerjaan Pemasangan LISA',
    'Daftar-prov-upi': 'Daftar Provinsi / UPI',
    'monitoring-rekon-upi': 'Monitoring Rekon per UPI',
    // Tambahkan sesuai kebutuhan
  };

  // Ambil parameter `menu` dari URL
  const params = new URLSearchParams(window.location.search);
  const menu = params.get('menu');

  // Ubah judul navbar jika `menu` ditemukan dalam peta
  if (menu && pageTitleMap[menu]) {
    document.getElementById('pageTitle').textContent = pageTitleMap[menu];
  }
</script>

