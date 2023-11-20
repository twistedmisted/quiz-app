<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <title>GmOwl</title>
    <style type="text/css">
        .navbar-nav .dropdown-menu {
            right: 0;
            left: auto;
        }
    </style>
</head>

<body>
<fmt:setBundle basename="application_lang" var="app"/>
<fmt:setBundle basename="about" var="about"/>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <p class="navbar-brand">GmOwl</p>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/home"><fmt:message key="home" bundle="${app}"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/all-quizzes"><fmt:message key="all-quizzes" bundle="${app}"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/my-quizzes"><fmt:message key="my-quizzes" bundle="${app}"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/about"><fmt:message key="about" bundle="${app}"/></a>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownLanguage" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <fmt:message key="language" bundle="${app}"/>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdownLanguage">
                    <a class="dropdown-item" href="${pageContext.request.contextPath}?lang=en"><fmt:message key="language.en" bundle="${app}"/></a>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}?lang=ua"><fmt:message key="language.ua" bundle="${app}"/></a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-user-circle"></i>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <c:if test="${user.accessLevel == 'admin'}">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin"><fmt:message key="admin" bundle="${app}"/></a>
                    </c:if>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/app/profile"><fmt:message key="results" bundle="${app}"/></a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/app/logout"><fmt:message key="log-out" bundle="${app}"/></a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<div class="container mt-4">
    <h2><fmt:message key="about" bundle="${app}"/></h2>
    <p>
        <fmt:message key="about" bundle="${about}"/>
    </p>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
