<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.time.ZoneId" %>
<%@ page import="java.time.Duration" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<fmt:setLocale value="${sessionScope.lang}"/>
<fmt:bundle basename="application_lang">
    <html>
    <head>
        <title><fmt:message key="question"/> <%=request.getParameter("question")%>
        </title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            .quiz-box {
                border: 1px solid #ccc;
                padding: 20px;
                text-align: center;
                margin-top: 100px;
                max-width: 600px;
                margin-left: auto;
                margin-right: auto;
            }
        </style>

        <script>
            <%
                LocalDateTime now = LocalDateTime.now();
                LocalDateTime end = ((Date) session.getAttribute("quiz_finish"))
                                                                                .toInstant()
                                                                                .atZone(ZoneId.systemDefault())
                                                                                .toLocalDateTime();
                long seconds = Duration.between(now, end).getSeconds();
                int minutes = (int) (seconds / 60);
                seconds = seconds % 60;
            %>

            var min = <%=minutes%>;
            var sec = <%=seconds%>;
            var timeoutID;

            function timer() {
                sec--;
                // document.timer.value = min + ':' + sec;
                document.getElementById('timer').textContent = min + ':' + sec;

                if (sec === -1) {
                    sec = 59;
                    min--;
                    document.question_form.timer.value = min + ':' + sec;
                }
                timeoutID = window.setTimeout("timer()", 1000);

                if (sec === 0 && min === 0) {
                    document.question_form.timer.value = "0:0";
                    window.clearTimeout(timeoutID);
                }
            }
        </script>
    </head>
    <body>
    <div class="container">
        <div class="quiz-box">
            <h3><fmt:message key="question"/> <%=request.getParameter("question")%>
            </h3>
            <p><strong>Time Left:</strong> <span id="timer">30:00</span></p>
            <hr>
            <form name="question_form"
                  action="${pageContext.request.contextPath}/app/start?quiz_id=${quiz_id}&question=<%=Integer.parseInt(request.getParameter("question")) + 1%>"
                  method="post">
                <p><c:out value="${question.prompt}"/></p>
                <div class="form-group text-left">
                    <%int i = 0;%>
                    <c:forEach var="variant" items="${question.variants}">
                        <%char letter = (char) ('a' + i++);%>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" name="<%=letter%>" value="<%=letter%>">
                            <label for="<%=letter%>" class="form-check-label"><c:out value="${variant}"/></label>
                        </div>
                    </c:forEach>
                </div>
                <button class="btn btn-primary"><fmt:message key="next"/></button>
            </form>
        </div>
    </div>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        timer();
    </script>
    </body>
    </html>
</fmt:bundle>