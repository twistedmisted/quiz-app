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

public class RegistrationCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(RegistrationCommand.class);

    private final UserDAO userDAO;

    public RegistrationCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        userDAO = irisDAOFactory.getUserDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        String email = request.getParameter("email");
        String login = request.getParameter("login");
        String password = request.getParameter("password");
        String passwordConfirm = request.getParameter("password_confirm");
        try {
            if (isDataCorrect(email, login, password, passwordConfirm)) {
                userDAO.insert(User.createUser(email, login, PasswordEncryption.encrypt(password), "user"));
                return new Page("/login.jsp", true);
            }
            return new Page("/registration.jsp?error=true", true);
        } catch (DbException e) {
            LOGGER.error(e.getMessage());
            return new Page("/registration.jsp?error=true", true);
        }
    }

    private boolean isDataCorrect(String email, String login, String password, String passwordConfirm) throws DbException {
        if (password.isEmpty()) {
            return false;
        }
        if (passwordConfirm.isEmpty()) {
            return false;
        }
        if (!password.equals(passwordConfirm)) {
            return false;
        }
        if (userDAO.getByLogin(login) != null) {
            return false;
        }
        return userDAO.getByEmail(email) == null;
    }

}
