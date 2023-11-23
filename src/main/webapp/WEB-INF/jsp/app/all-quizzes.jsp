<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>GmOwl</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $('#sort-select').change(function () {
                var sortBy = $('#sort-select').val();
                window.location = "/app/all-quizzes?sortBy=" + sortBy;
            });
        });
    </script>

    <style type="text/css">
        .quiz-block {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 15px;
            text-decoration: none; /* Remove underlines from quiz-block */
            color: inherit; /* Inherit text color */
        }

        .quiz-block:hover {
            background-color: #f5f5f5; /* Change background color on hover */
        }

        .navbar-nav .dropdown-menu {
            right: 0;
            left: auto;
        }
    </style>
</head>

<body>
<fmt:bundle basename="application_lang">
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <p class="navbar-brand">GmOwl</p>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/home"><fmt:message key="home"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/all-quizzes"><fmt:message
                        key="all-quizzes"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/my-quizzes"><fmt:message
                        key="my-quizzes"/></a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/app/about"><fmt:message key="about"/></a>
            </li>
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
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown"
                   aria-haspopup="true" aria-expanded="false">
                    <i class="fas fa-user-circle"></i>
                </a>
                <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    <c:if test="${user.accessLevel == 'admin'}">
                        <a class="dropdown-item" href="${pageContext.request.contextPath}/admin"><fmt:message
                                key="admin"/></a>
                    </c:if>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/app/profile"><fmt:message
                            key="results"/></a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="${pageContext.request.contextPath}/app/logout"><fmt:message
                            key="log-out"/></a>
                </div>
            </li>
        </ul>
    </div>
</nav>
<div class="container mt-4">
    <div class="row">
        <div class="col-md-8">
            <h2 class="float-md-left"><fmt:message key="list-quizzes"/></h2>
        </div>
        <div class="col-md-4">
            <div class="form-inline float-md-rigth">
                <label class="mr-2"><fmt:message key="sort-by"/>:</label>
                <select class="form-control" id="sort-select">
                    <c:choose>
                        <c:when test="${sortBy == 'name'}">
                            <option value="name" selected><fmt:message key="name"/></option>
                            <option value="difficulty"><fmt:message key="difficulty"/></option>
                            <option value="questions"><fmt:message key="questions"/></option>
                        </c:when>
                        <c:when test="${sortBy == 'difficulty'}">
                            <option value="name"><fmt:message key="name"/></option>
                            <option value="difficulty" selected><fmt:message key="difficulty"/></option>
                            <option value="questions"><fmt:message key="questions"/></option>
                        </c:when>
                        <c:when test="${sortBy == 'questions'}">
                            <option value="name"><fmt:message key="name"/></option>
                            <option value="difficulty"><fmt:message key="difficulty"/></option>
                            <option value="questions" selected><fmt:message key="questions"/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="name"><fmt:message key="name"/></option>
                            <option value="difficulty"><fmt:message key="difficulty"/></option>
                            <option value="questions"><fmt:message key="questions"/></option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </div>
        </div>
    </div>
    <div class="row">
        <c:if test="${quizzes.size() == 0}">
            <p style="font-size: 25px; color: gray; font-style: italic;"><fmt:message key="zero-quizzes"/></p>
        </c:if>
        <c:forEach var="quiz" items="${quizzes}">
            <div class="col-md-3 mb-3">
                    <a class="quiz-block d-block" style="text-decoration: none"
                       href="${pageContext.request.contextPath}/app/quiz?id=${quiz.getId()}">
                        <div>
                            <h4><c:out value="${quiz.getName()}"/></h4>
                            <p>Difficulty: <c:out value="${quiz.getDifficulty()}"/></p>
                            <p>Duration: ${quiz.getDuration()} <fmt:message key="time.min"/></p>
                        </div>
                    </a>
            </div>
        </c:forEach>
    </div>
    </fmt:bundle>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
