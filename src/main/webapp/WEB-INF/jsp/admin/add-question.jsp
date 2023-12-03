<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="ua.zxc.quiz.dao.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="add-question"/></title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

        <style>
            .navbar-nav .dropdown-menu {
                right: 0;
                left: auto;
            }
        </style>
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
    <div>
        <div class="container mt-5">
            <form name="add-question"
                  action="${pageContext.request.contextPath}/admin/add-question?id=<%=request.getParameter("id")%>"
                  method="post">
                <div class="form-group">
                    <label for="prompt"><fmt:message key="prompt"/>:</label>
                    <input type="text" class="form-control" name="prompt" id="prompt" value="${question}" placeholder="Enter your question here">
                </div>
                <div class="form-group" id="answerFields">
                    <label for="answers">Answers:</label>
                    <c:choose>
                        <c:when test="${answers != null}">
                            <c:forEach items="${answers}" var="entry">
                                <div class="input-group" id="answer_a_group">
                                    <div class="input-group-prepend">
                                        <div class="input-group-text">
                                            <c:choose>
                                                <c:when test="${entry.key == answer}">
                                                    <input type="checkbox" id="${entry.key}" name="${entry.key}" checked aria-label="Checkbox for answer">
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="checkbox" id="${entry.key}" name="${entry.key}" aria-label="Checkbox for answer">
                                                </c:otherwise>
                                            </c:choose>

                                        </div>
                                    </div>
                                    <input type="text" class="form-control" id="${entry.key}-input" name="${entry.key}-input" value="${entry.value}" required>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="input-group" id="answer_a_group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="a" name="a" aria-label="Checkbox for answer">
                                    </div>
                                </div>
                                <input type="text" class="form-control" id="a-input" name="a-input" required>
                            </div>
                            <div class="input-group mt-2" id="answer_b_group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="b" name="b" aria-label="Checkbox for answer">
                                    </div>
                                </div>
                                <input type="text" class="form-control" id="b-input" name="b-input" required>
                            </div>
                            <div class="input-group mt-2" id="answer_b_group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="c" name="c" aria-label="Checkbox for answer">
                                    </div>
                                </div>
                                <input type="text" class="form-control" id="c-input" name="c-input" required>
                            </div>
                            <div class="input-group mt-2" id="answer_b_group">
                                <div class="input-group-prepend">
                                    <div class="input-group-text">
                                        <input type="checkbox" id="d" name="d" value="" aria-label="Checkbox for answer">
                                    </div>
                                </div>
                                <input type="text" class="form-control" id="d-input" name="d-input" required>
                            </div>
                        </c:otherwise>
                    </c:choose>

                </div>
                <button class="btn btn-info mt-3" onclick="useGPT()"><fmt:message key="chat-gpt"/></button>
                <button type="submit" class="btn btn-success mt-3"><fmt:message key="confirm"/></button>
                <a href="${pageContext.request.contextPath}/admin/quizzes/questions?id=<%=request.getParameter("id")%>" class="btn btn-secondary mt-3"><fmt:message key="back"/></a>
            </form>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        function useGPT() {
            let id = '<%=request.getParameter("id")%>'
            window.location = "/admin/add-question?id=" + id + "&gpt=true";
        }
    </script>
    </body>
    </html>
</fmt:bundle>