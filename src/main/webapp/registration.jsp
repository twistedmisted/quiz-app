<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <!DOCTYPE html>
    <html>
    <head>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><fmt:message key="sign-up"/></title>

        <style>
            .register-box {
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

            .required-info {
                color: #999;
                font-size: 12px;
            }
        </style>

        <script>
            function validPass() {
                if (document.getElementById("p1").value.length !== 0 && document.getElementById("p2").value.length !== 0
                    && document.getElementById("p1").value !== document.getElementById("p2").value) {
                    document.getElementById("passHint1").innerHTML = "Passwords do not match";
                    document.getElementById("passHint2").innerHTML = "Passwords do not match";
                    document.getElementById("btn").disabled = true;
                } else if (document.getElementById("p1").value === document.getElementById("p2").value) {
                    document.getElementById("passHint1").innerHTML = "";
                    document.getElementById("passHint2").innerHTML = "";
                    document.getElementById("btn").disabled = false;
                }
            }

            function validLogin(str) {
                if (str.length < 2 || str.length > 30) {
                    document.getElementById("logHint").innerHTML = "Login must be from 2 to 30 characters";
                    document.getElementById("btn").disabled = true;
                } else {
                    document.getElementById("logHint").innerHTML = "";
                    document.getElementById("btn").disabled = false;
                }
            }
        </script>
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
        <div class="register-box">
            <h3><fmt:message key="sign-up"/></h3>
            <form name="form1" class="form1" action="${pageContext.request.contextPath}/registration" method="POST">
                <c:if test="${not empty param.error}">
                    <p class="required-info"><fmt:message key="error.register.input"/></p>
                </c:if>
                <div class="form-group">
                    <p><span class="required-info" id="logHint"></span></p>
                    <input class="form-control" type="text" placeholder="Username" name="login" id="login"
                           onkeyup="validLogin(this.value)" required>
                </div>
                <div class="form-group">
                    <p><span class="required-info" id="emailHint"></span></p>
                    <input class="form-control" type="email" placeholder="Email" name="email" id="email" required>
                </div>
                <div class="form-group">
                    <p><span id="passHint1" class="required-info"></span></p>
                    <input id="p1" class="form-control" type="password" placeholder="Password" name="password"
                           onkeyup="validPass()" required>
                </div>
                <div class="form-group">
                    <p><span id="passHint2" class="required-info"></span></p>
                    <input id="p2" class="form-control" type="password" placeholder="Password" name="password_confirm"
                           onkeyup="validPass()" required>
                </div>
                <button type="submit" class="btn btn-primary btn-block"><fmt:message key="sign-up"/></button>
            </form>
            <p class="mt-3"><fmt:message key="have-account"/> <a href="${pageContext.request.contextPath}/login.jsp"><fmt:message key="sign-in"/></a></p>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>