<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="edit-quiz"/></title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    </head>
    <body>
    <div class="container mt-5">
        <h2>Edit User</h2>
        <c:if test="${param.error == 'true'}">
            <p class="incr"><fmt:message key="error.validation.quiz"/></p>
        </c:if>
        <form name="edit-quiz" action="${pageContext.request.contextPath}/admin/edit-quiz?id=${id}&page=<%=request.getParameter("page")%>"
              method="post">
            <div class="form-group">
                <label for="name"><fmt:message key="name"/></label>
                <input type="text" class="form-control" id="name" name="name" value="${quiz.name}" placeholder="Enter name">
            </div>
            <div class="form-group">
                <label for="subject"><fmt:message key="subject"/></label>
                <input type="text" class="form-control" id="subject" name="subject" value="${quiz.subject}" placeholder="Enter subject">
            </div>
            <div class="form-group">
                <label for="difficulty"><fmt:message key="difficulty"/></label>
                <select class="form-control" id="difficulty" name="difficulty">
                    <c:choose>
                        <c:when test="${quiz.difficulty == 'easy'}">
                            <option value="easy" selected><fmt:message key="easy"/></option>
                            <option value="normal"><fmt:message key="normal"/></option>
                            <option value="hard"><fmt:message key="hard"/></option>
                        </c:when>
                        <c:when test="${quiz.difficulty == 'normal'}">
                            <option value="easy"><fmt:message key="easy"/></option>
                            <option value="normal" selected><fmt:message key="normal"/></option>
                            <option value="hard"><fmt:message key="hard"/></option>
                        </c:when>
                        <c:otherwise>
                            <option value="easy"><fmt:message key="easy"/></option>
                            <option value="normal"><fmt:message key="normal"/></option>
                            <option value="hard" selected><fmt:message key="hard"/></option>
                        </c:otherwise>
                    </c:choose>
                </select>
            </div>
            <div class="form-group">
                <label for="time"><fmt:message key="time"/></label>
                <input type="text" class="form-control" id="time" name="time" value="${quiz.duration}" placeholder="Enter duration">
            </div>
            <div class="form-group">
                <label for="difficulty"><fmt:message key="status"/></label>
                <select class="form-control" id="status" name="status">
                    <c:forEach var="status" items="${statuses}">
                        <c:choose>
                            <c:when test="${status == quiz.status}">
                                <option value="${status}" selected><fmt:message key="${status}"/></option>
                            </c:when>
                            <c:otherwise>
                                <option value="${status}"><fmt:message key="${status}"/></option>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </select>
            </div>
            <button type="submit" class="btn btn-primary"><fmt:message key="confirm"/></button>
        </form>
        <div class="mb-3">
            <a href="${pageContext.request.contextPath}/admin/quizzes" class="btn btn-secondary mr-2"><fmt:message key="back"/></a>
        </div>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    </body>
    </html>
</fmt:bundle>