<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="ua.zxc.quiz.dao.model.User" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <!DOCTYPE html>
    <html>
    <%
        User user = (User) session.getAttribute("user");

        if (user != null) {
            response.sendRedirect("/app/home");
        }
    %>
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><fmt:message key="sign-in"/></title>
        <style>
            .signin-box {
                border: 1px solid #ccc;
                padding: 20px;
                text-align: center;
                margin-top: 100px;
                max-width: 400px;
                margin-left: auto;
                margin-right: auto;
            }

            .navbar-nav .dropdown-menu {
                right: 0;
                left: auto;
            }
        </style>
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <p class="navbar-brand">GmOwl</p>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownLanguage" role="button"
                       data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                        <fmt:message key="language"/>
                    </a>
                    <div class="dropdown-menu" aria-labelledby="navbarDropdownLanguage">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}?lang=en"><fmt:message
                                key="language.en"/></a>
                        <a class="dropdown-item" href="${pageContext.request.contextPath}?lang=ua"><fmt:message
                                key="language.ua"/></a>
                    </div>
                </li>
            </ul>
        </div>
    </nav>

    <div class="container">
        <div class="signin-box">
            <h3><fmt:message key="sign-in"/></h3>
            <form class="form1" action="${pageContext.request.contextPath}/login" method="POST">
                <c:if test="${not empty param.error}">
                    <p class="incr"><fmt:message key="error.login.input"/></p>
                </c:if>
                <c:if test="${not empty param.state}">
                    <p class="incr"><fmt:message key="error.login.state"/></p>
                </c:if>
                <p class="btn-auth">
                    <a></a>
                </p>
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="Username" name="login" required>
                </div>
                <div class="form-group">
                    <input type="password" class="form-control" placeholder="Password" name="password" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block"><fmt:message key="sign-in"/></button>
            </form>
            <p class="mt-3"><fmt:message key="dont-have-account"/> <a
                    href="${pageContext.request.contextPath}/registration.jsp"><fmt:message key="sign-up"/></a></p>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>