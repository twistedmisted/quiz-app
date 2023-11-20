package ua.zxc.quiz.app.commands;

import ua.zxc.quiz.app.web.Page;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface Command {

    Page execute(HttpServletRequest request, HttpServletResponse response);
}
