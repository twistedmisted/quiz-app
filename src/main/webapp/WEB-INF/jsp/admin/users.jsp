<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="list-users"/></title>
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
        <h2><fmt:message key="list-users"/></h2>
        <table class="table table-striped">
            <thead>
            <tr>
                <th id="login"><fmt:message key="login"/></th>
                <th id="email"><fmt:message key="email"/></th>
                <th id="access-level"><fmt:message key="access-level"/></th>
                <th id="actions" colspan="3"><fmt:message key="actions"/></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td><c:out value="${user.login}"/></td>
                    <td><c:out value="${user.email}"/></td>
                    <td><c:out value="${user.accessLevel}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/edit-user?id=${user.id}&page=${currentPage}" class="btn btn-info"><fmt:message
                                key="edit"/></a>
                    <c:choose>
                        <c:when test="${user.accessLevel == 'banned'}">
                            <a href="${pageContext.request.contextPath}/admin/unblock-user?id=${user.id}&page=${currentPage}" class="btn btn-warning"><fmt:message
                                    key="unblock"/></a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/admin/block-user?id=${user.id}&page=${currentPage}" class="btn btn-warning"><fmt:message
                                    key="block"/></a>
                        </c:otherwise>
                    </c:choose>
                            <a href="${pageContext.request.contextPath}/admin/delete-user?id=${user.id}&page=${currentPage}" class="btn btn-danger"><fmt:message
                                    key="delete"/></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:choose>
            <c:when test="${currentPage gt 1}">
                <c:set var="startPage" scope="request" value="${currentPage -1}"/>
            </c:when>
            <c:otherwise>
                <c:set var="startPage" scope="request" value="${1}"/>
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${numberOfPages gt currentPage+1}">
                <c:set var="endPage" scope="request" value="${currentPage +2}"/>
            </c:when>
            <c:otherwise>
                <c:set var="endPage" scope="request" value="${numberOfPages}"/>
            </c:otherwise>
        </c:choose>
        <nav>
            <ul class="pagination">
                <c:choose>
                    <c:when test="${currentPage != 1}">
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage - 1}">Previous</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                    </c:otherwise>
                </c:choose>
                <c:forEach begin="${startPage}" end="${requestScope.endPage}" var="i">
                    <c:choose>
                        <c:when test="${currentPage == i}">
                            <li class="page-item active"><a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}">${i}</a></li>
                        </c:when>
                        <c:otherwise>
                            <a >${i}</a>
                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${i}">${i}</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${currentPage != numberOfPages}">
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/users?page=${currentPage + 1}">Next</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link" href="#">Next</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </nav>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>