<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Error</title>
    <meta charset="utf-8">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .error-box {
            text-align: center;
            margin-top: 100px;
        }
        .error-code {
            font-size: 6em;
            margin-bottom: 20px;
        }
        .error-message {
            font-size: 1.5em;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="error-box">
        <div class="error-code">${pageContext.errorData.statusCode}</div>
        <div class="error-message">Oops! Something went wrong.</div>
        <p><button onclick="history.back()" class="btn btn-link">Back to Previous Page</button></p>
    </div>
</div>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>