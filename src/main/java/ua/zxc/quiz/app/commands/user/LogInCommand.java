package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.UserDAO;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import ua.zxc.quiz.utils.PasswordEncryption;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class LogInCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(LogInCommand.class);

    private final UserDAO userDAO;

    public LogInCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        userDAO = irisDAOFactory.getUserDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        String login = request.getParameter("login");
        String password = PasswordEncryption.encrypt(request.getParameter("password"));
        try {
            User user = userDAO.getByLoginAndPassword(login, password);
            if (user != null) {
                if (!user.getAccessLevel().equals("banned")) {
                    request.getSession().setAttribute("user", user);
                    return new Page("/app/home", true);
                }
                return new Page("/login.jsp?state=banned", true);
            }
            return new Page("/login.jsp?error=true", true);
        } catch (DbException e) {
            LOGGER.error(e);
            return new Page("/login.jsp?error=true", true);
        }
    }

}
