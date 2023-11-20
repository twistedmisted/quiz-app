<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<html>
<head>
    <title>${quiz.name}</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .quiz-box {
            border: 1px solid #ccc;
            padding: 20px;
            text-align: center;
            margin-top: 100px;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
        }
    </style>
</head>
<body>
<fmt:bundle basename="application_lang">
    <div class="container">
        <div class="quiz-box">
            <h3><c:out value="${quiz.name}"/></h3>
            <c:choose>
                <c:when test="${score >= 0}">
                    <p><strong><fmt:message key="your-score"/>:</strong> <c:out value="${score}"/>%</p>
                    <a href="${pageContext.request.contextPath}/app/home" class="btn btn-secondary"><fmt:message key="back"/></a>
                </c:when>
                <c:when test="${isEmpty == true}">
                    <p><fmt:message key="quiz-empty"/></p>
                    <a href="${pageContext.request.contextPath}/app/home" class="btn btn-secondary"><fmt:message key="back"/></a>
                </c:when>
                <c:otherwise>
                    <p><strong><fmt:message key="difficulty"/>:</strong> <c:out value="${quiz.difficulty}"/></p>
                    <p><strong><fmt:message key="time"/>:</strong> <c:out value="${quiz.duration}"/> <fmt:message key="time.min"/></p>
                    <a href="${pageContext.request.contextPath}/app/start?quiz_id=${quiz.id}&question=1" class="btn btn-primary mr-2"><fmt:message key="start"/></a>
                    <a href="${pageContext.request.contextPath}/app/home" class="btn btn-secondary"><fmt:message key="back"/></a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</fmt:bundle>
</body>
</html>
