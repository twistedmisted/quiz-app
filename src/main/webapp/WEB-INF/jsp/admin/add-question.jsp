<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="ua.zxc.quiz.dao.model.User" %>
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
                    <input type="text" class="form-control" name="prompt" id="prompt" placeholder="Enter your question here">
                </div>
                <div class="form-group" id="answerFields">
                    <label for="answers">Answers:</label>
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
                                <input type="checkbox" id="b" name="a" aria-label="Checkbox for answer">
                            </div>
                        </div>
                        <input type="text" class="form-control" id="b-input" name="b-input" required>
                    </div>
                </div>
                <button class="btn btn-primary mt-3" id="addAnswer">Add Answer</button>
                <button type="submit" class="btn btn-success mt-3"><fmt:message key="confirm"/></button>
                <a href="${pageContext.request.contextPath}/admin/quizzes/questions?id=<%=request.getParameter("id")%>" class="btn btn-secondary mt-3"><fmt:message key="back"/></a>
            </form>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script>
        $(document).ready(function() {
            const maxAnswers = 4; // Maximum number of answer fields allowed
            let currentLetter = 'c'; // Starting letter for additional answers

            // Function to add answer field
            $('#addAnswer').click(function() {
                const answerFields = $('#answerFields');
                const answerCount = answerFields.find('.input-group').length;

                if (answerCount < maxAnswers && currentLetter <= 'd') {
                    const newAnswerField =
                        '<div class="input-group mt-2" id="answer_' +
                        currentLetter +
                        '_group">' +
                        '<div class="input-group-prepend">' +
                        '<div class="input-group-text">' +
                        '<input type="checkbox" id="' +
                        currentLetter +
                        '" name="' +
                        currentLetter +
                        '" aria-label="Checkbox for answer">' +
                        '</div>' +
                        '</div>' +
                        '<input type="text" class="form-control" id="' +
                        currentLetter +
                        '-input" name="'+
                        currentLetter +
                        '-input" required>' +
                        '<div class="input-group-append">' +
                        '<button class="btn btn-outline-secondary remove-answer" type="button" data-answer="answer_' +
                        currentLetter +
                        '">-</button>' +
                        '</div>' +
                        '</div>';
                    answerFields.append(newAnswerField);
                    currentLetter = String.fromCharCode(currentLetter.charCodeAt(0) + 1);
                }
            });

            function removeAnswerById(answerId) {
                $('#' + answerId + '_group').remove();
                $('.input-group').each(function(index) {
                    const letter = String.fromCharCode(97 + index);
                    $(this).attr('id', 'answer_' + letter + '_group');
                    $(this).find('.remove-answer').attr('data-answer', 'answer_' + letter);
                    $(this).find('.form-control').attr('id', letter + '-input').attr('name', letter + '-input');
                    $(this).find('.input-group-text input').attr('id', letter);
                });
                currentLetter = String.fromCharCode(currentLetter.charCodeAt(0) - 1);
            }

            $('#answerFields').on('click', '.remove-answer', function() {
                const answerId = $(this).data('answer');
                removeAnswerById(answerId);
            });
        });
    </script>
    </body>
    </html>
</fmt:bundle>