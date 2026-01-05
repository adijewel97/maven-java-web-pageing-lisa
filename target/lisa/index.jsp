<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String currentPage = request.getParameter("page");
    String currentMenu = request.getParameter("menu");

    if (currentPage == null || currentPage.trim().isEmpty()) {
        currentPage = "/views/dashboard/dashboard.jsp";
    }

    if (currentMenu == null || currentMenu.trim().isEmpty()) {
        request.setAttribute("menu", "dashboard");
    } else {
        request.setAttribute("menu", currentMenu);
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>MIV Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />

    <!-- ✅ CSS -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/favicon.ico">

    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap-icons/bootstrap-icons.css"> -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/dist/css/adminlte.min.css">
    <!-- Coba pakai CDN dulu -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" 
       onerror="this.onerror=null;this.href='${pageContext.request.contextPath}/assets/bootstrap/css/6.5.0/all.min.css';">

    <!-- <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"> -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/dataTables/css/jquery.dataTables.min.css">

    <!-- <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"> -->
    <link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/css/font/bootstrap-icons.min.css">    -->

    <!-- Flatpickr CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/dist/plugins/flatpickr.min.css">
    <!-- Plugin Month Select CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/dist/plugins/style.css">

    <!-- Pastikan Bootstrap CSS & JS sudah disertakan -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/bootstrap/css/bootstrap.min.css">
    <!-- <script src="${pageContext.request.contextPath}/assets/bootstrap/js/jquery-3.5.1.slim.min.js"></script> -->
    <script src="${pageContext.request.contextPath}/assets/bootstrap/js/jquery-3.7.1.min.js"></script>


    
    <!-- ✅ SCRIPT: jQuery HARUS PALING ATAS -->
    <script src="${pageContext.request.contextPath}/assets/bootstrap/dist/js/jquery.min.js"></script>

    <style>
        .content-panel {
            background-color: white;
            border-radius: 6px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.1);
            padding: 20px;
        }
    </style>
</head>
<body class="hold-transition sidebar-mini layout-fixed">
<div class="wrapper">

    <!-- ✅ NAVBAR -->
    <jsp:include page="/views/templates/navbar.jsp" />

    <!-- ✅ SIDEBAR -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <jsp:include page="/views/templates/sidebar.jsp" />
    </aside>

    <!-- ✅ CONTENT WRAPPER -->
    <div class="content-wrapper">
        <div class="content-header">
            <div class="container-fluid">
                <!-- Optional breadcrumb -->
            </div>
        </div>

        <section class="content pt-3">
            <div class="container-fluid">
                <div class="row justify-content-center">
                    <div class="col-12">
                        <div class="content-panel">
                            <jsp:include page="<%= currentPage %>" />
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- ✅ FOOTER -->
    <jsp:include page="/views/templates/footer.jsp" />

</div>


<!-- WAJIB: Bootstrap 5 JS -->
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/js/bootstrap.bundle.min.js"></script>

<!-- ✅ AdminLTE -->
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/js/adminlte.min.js"></script>

<!-- ✅ Flatpickr & Month Plugin -->
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/plugins/flatpickr.js"></script>
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/plugins/index.js"></script>
<!-- ✅ Locale Bahasa Indonesia untuk Flatpickr -->
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/plugins/id.js"></script>


<!-- ✅ DataTables & Export -->
<script src="${pageContext.request.contextPath}/assets/dataTables/js/jquery.dataTables.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/dataTables/js/dataTables.buttons.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/dataTables/js/buttons.html5.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/dataTables/js/jszip.min.js"></script>

<!-- ✅ Export Excel via SheetJS -->
<!-- <script src="${pageContext.request.contextPath}/assets/bootstrap/dist/js/xlsx.full.min.js"></script> -->
<!-- <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script> --> 
<script src="${pageContext.request.contextPath}/assets/bootstrap/dist/js/xlsx.full.min.js"></script>
<script src="https://unpkg.com/xlsx-populate/browser/xlsx-populate.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/exceljs/dist/exceljs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.2/FileSaver.min.js"></script>



</body>
</html>
