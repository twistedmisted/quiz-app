<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="list-quizzes"/></title>
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
        <h2><fmt:message key="list-quizzes"/></h2>
        <table class="table table-striped">
            <thead>
            <tr>
                <th id="name"><fmt:message key="name"/></th>
                <th id="subject"><fmt:message key="subject"/></th>
                <th id="difficulty"><fmt:message key="difficulty"/></th>
                <th id="time"><fmt:message key="time"/></th>
                <th id="status"><fmt:message key="status"/></th>
                <th id="questions"><fmt:message key="questions"/></th>
                <th id="actions" colspan="2"><fmt:message key="actions"/></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="quiz" items="${quizzes}">
                <tr>
                    <td><c:out value="${quiz.name}"/></td>
                    <td><c:out value="${quiz.subject}"/></td>
                    <td><c:out value="${quiz.difficulty}"/></td>
                    <td>${quiz.duration} <fmt:message key="time.min"/></td>
                    <td><c:out value="${quiz.status}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/quizzes/questions?id=${quiz.id}&page=${currentPage}"><fmt:message key="list-questions"/></a>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/edit-quiz?id=${quiz.id}&page=${currentPage}" class="btn btn-info"><fmt:message key="edit"/></a>
                        <a href="${pageContext.request.contextPath}/admin/delete-quiz?id=${quiz.id}&page=${currentPage}" class="btn btn-danger ml-2"><fmt:message key="delete"/></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/add-quiz" class="btn btn-primary mr-2"><fmt:message key="add-quiz"/></a>
        </div>
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
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/quizzes?page=${currentPage - 1}">Previous</a></li>
                    </c:when>
                    <c:otherwise>
                        <li class="page-item disabled"><a class="page-link" href="#">Previous</a></li>
                    </c:otherwise>
                </c:choose>
                <c:forEach begin="${startPage}" end="${requestScope.endPage}" var="i">
                    <c:choose>
                        <c:when test="${currentPage == i}">
                            <li class="page-item active"><a class="page-link" href="${pageContext.request.contextPath}/admin/quizzes?page=${i}">${i}</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/quizzes?page=${i}">${i}</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:choose>
                    <c:when test="${currentPage != numberOfPages}">
                        <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/quizzes?page=${currentPage + 1}">Next</a></li>
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