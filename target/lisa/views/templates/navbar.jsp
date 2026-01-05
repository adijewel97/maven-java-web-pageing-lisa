<!-- Navbar -->
<nav class="main-header navbar navbar-expand navbar-white navbar-light">
  <!-- Left navbar links -->
  <ul class="navbar-nav">
    <li class="nav-item">
      <a class="nav-link" data-widget="pushmenu" href="#"><i class="fas fa-bars"></i></a>
    </li>
    <li class="nav-item d-none d-sm-inline-block">
      <a href="index.jsp?page=/views/dashboard/dashboard.jsp&menu=dashboard" class="nav-link"><h5 id="pageTitle">Dashboard</h5></a>
    </li>
  </ul>

  <!-- Right navbar links -->
  <ul class="navbar-nav ml-auto">
    <!-- Notifikasi -->
    <li class="nav-item">
      <a class="nav-link" href="#"><i class="far fa-bell"></i></a>
    </li>

    <!-- Dropdown Admin -->
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" id="adminDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="fas fa-user"></i> admin
      </a>
      <div class="dropdown-menu dropdown-menu-right" aria-labelledby="adminDropdown">
        <a class="dropdown-item" href="/useradmin">User Admin</a>
        <!-- <div class="dropdown-divider"></div> -->
        <a class="dropdown-item" href="/logout">Logout</a>
      </div>
    </li>
  </ul>
</nav>
