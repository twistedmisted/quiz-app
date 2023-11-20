<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="edit-user"/></title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-between" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link font-weight-bold" href="${pageContext.request.contextPath}/app/home"><fmt:message key="home"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link font-weight-bold" href="${pageContext.request.contextPath}/admin/users"><fmt:message key="list-users"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link font-weight-bold" href="${pageContext.request.contextPath}/admin/quizzes"><fmt:message key="list-quizzes"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link font-weight-bold" href="${pageContext.request.contextPath}/app/logout"><fmt:message key="log-out"/></a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}?lang=en"><fmt:message key="language.en"/></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}?lang=ua"><fmt:message key="language.ua"/></a>
                </li>
            </ul>
        </div>
    </nav>
    <div class="container mt-5">
        <h2>Edit User</h2>
        <c:if test="${param.error == 'true'}">
            <p class="incr"><fmt:message key="error.register.input"/></p>
        </c:if>
        <form name="edit-user" action="${pageContext.request.contextPath}/admin/edit-user?id=${id}&page=<%=request.getParameter("page")%>" method="post">
            <div class="form-group">
                <label for="email"><fmt:message key="email"/></label>
                <input type="email" class="form-control" id="email" name="email" value="${user.email}" placeholder="Enter email">
            </div>
            <div class="form-group">
                <label for="login"><fmt:message key="login"/></label>
                <input type="text" class="form-control" id="login" name="login" value="${user.login}" placeholder="Enter login">
            </div>
            <div class="form-group">
                <label for="access-level"><fmt:message key="access-level"/></label>
                <select class="form-control" id="access-level" name="access-level">
                    <c:choose>
                        <c:when test="${user.accessLevel == 'user'}">
                            <option value="user" selected><fmt:message key="access-level.user"/></option>
                            <option value="admin"><fmt:message key="access-level.admin"/></option>
                            <option value="banned"><fmt:message key="access-level.banned"/></option>
                        </c:when>
                        <c:when test="${user.accessLevel == 'admin'}">
                            <option value="user"><fmt:message key="access-level.user"/></option>
                            <option value="admin" selected><fmt:message key="access-level.admin"/></option>
                            <option value="banned"><fmt:message key="access-level.banned"/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="user"><fmt:message key="access-level.user"/></option>
                            <option value="admin"><fmt:message key="access-level.admin"/></option>
                            <option value="banned" selected><fmt:message key="access-level.banned"/></option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </div>
            <button type="submit" class="btn btn-primary"><fmt:message key="confirm"/></button>
        </form>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary mr-2"><fmt:message key="back"/></a>
        </div>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>