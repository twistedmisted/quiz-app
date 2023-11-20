package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.app.commands.Command;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LogOutCommand implements Command {

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        request.getSession().invalidate();
        return new Page("/login.jsp", true);
    }
}
