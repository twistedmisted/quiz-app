<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
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
    <head>
        <title><fmt:message key="list-questions"/></title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
    <div class="container mt-5">
        <h2><fmt:message key="list-questions"/></h2>
        <table class="table table-striped">
            <thead>
            <tr>
                <th id="prompt"><fmt:message key="prompt"/></th>
                <th id="answers"><fmt:message key="answers"/></th>
                <th id="variants"><fmt:message key="variants"/></th>
                <th id="actions"><fmt:message key="actions"/></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="question" items="${questions}">
                <tr>
                    <td><c:out value="${question.getPrompt()}"/></td>
                    <td><c:out value="${question.getAnswers()}"/></td>
                    <td><c:out value="${question.showVariants()}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/delete-question?id=${question.id}&quiz_id=<%=request.getParameter("id")%>&page=<%=request.getParameter("page")%>" class="btn btn-danger ml-2"><fmt:message key="delete"/></a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/add-question?id=<%=request.getParameter("id")%>" class="btn btn-primary mr-2"><fmt:message key="add-question"/></a>
            <a href="${pageContext.request.contextPath}/admin/quizzes" class="btn btn-secondary"><fmt:message key="back"/></a>
        </div>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>