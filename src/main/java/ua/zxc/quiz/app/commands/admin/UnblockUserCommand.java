package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.UserDAO;
import ua.zxc.quiz.dao.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class UnblockUserCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(UnblockUserCommand.class);

    private final UserDAO userDAO;

    public UnblockUserCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        userDAO = irisDAOFactory.getUserDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        long id = Long.parseLong(request.getParameter("id"));
        try {
            User user = userDAO.get(id);
            user.setAccessLevel("user");
            userDAO.update(user);
            return new Page("/admin/users?page=" + request.getParameter("page"), true);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            return new Page("/admin/users?error=true", true);
        }
    }
}
