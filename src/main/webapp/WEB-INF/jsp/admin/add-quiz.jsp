<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="add-quiz"/></title>
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
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}?lang=en" class="btn btn-outline-primary mr-2"><fmt:message key="language.en"/></a>
            <a href="${pageContext.request.contextPath}?lang=ua" class="btn btn-outline-primary"><fmt:message key="language.ua"/></a>
        </div>
        <h2>Create Quiz</h2>
        <c:if test="${param.error == 'true'}">
            <p class="incr"><fmt:message key="error.validation.quiz"/></p>
        </c:if>
        <form name="add-quiz" action="${pageContext.request.contextPath}/admin/add-quiz" method="post">
            <div class="form-group">
                <label for="name"><fmt:message key="name"/></label>
                <input type="text" class="form-control" id="name" name="name" placeholder="Enter quiz name">
            </div>
            <div class="form-group">
                <label for="subject"><fmt:message key="subject"/></label>
                <input type="text" class="form-control" id="subject" name="subject" value="${quiz.subject}" placeholder="Enter quiz subject">
            </div>
            <div class="form-group">
                <label for="difficulty"><fmt:message key="difficulty"/></label>
                <select class="form-control" id="difficulty" name="difficulty">
                    <option value="easy"><fmt:message key="easy"/></option>
                    <option value="medium"><fmt:message key="normal"/></option>
                    <option value="hard"><fmt:message key="hard"/></option>
                </select>
            </div>
            <div class="form-group">
                <label for="time"><fmt:message key="time"/> (<fmt:message key="time.min"/>)</label>
                <input type="text" class="form-control" id="time" name="time" placeholder="Enter duration">
            </div>
            <button type="submit" class="btn btn-primary mr-2"><fmt:message key="confirm"/></button>
            <a type="submit" href="${pageContext.request.contextPath}/admin/quizzes" class="btn btn-secondary"><fmt:message key="back"/></a>
        </form>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>