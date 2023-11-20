package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.UserDAO;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class ShowUsersCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(ShowUsersCommand.class);

    private static final int NUMBER_USERS_ON_PAGE = 10;

    private final UserDAO userDAO;

    public ShowUsersCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        userDAO = irisDAOFactory.getUserDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            int page = getPage(request);
            int start = 0;
            if (page > 1) {
                start = (page - 1) * NUMBER_USERS_ON_PAGE + 1;
            }
            int end = start + NUMBER_USERS_ON_PAGE;
            int totalNumberOfUsers = userDAO.getNumber();
            int numberOfPages = getNumberOfPages(totalNumberOfUsers);
            List<User> users = userDAO.getByRange(start, end);
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("numberOfPages", numberOfPages);
            return new Page("/WEB-INF/jsp/admin/users.jsp", false);
        } catch (DbException e) {
            LOGGER.error(e);
            return new Page("/admin?error=true", true);
        }
    }

    private int getPage(HttpServletRequest request) {
        if (request.getParameter("page") == null) {
            return 1;
        }
        return Integer.parseInt(request.getParameter("page"));
    }

    private int getNumberOfPages(int totalNumberOfUsers) {
        if (totalNumberOfUsers == 0) {
            return 1;
        }
        if (totalNumberOfUsers % NUMBER_USERS_ON_PAGE == 0) {
            return totalNumberOfUsers / NUMBER_USERS_ON_PAGE;
        } else {
            return totalNumberOfUsers / NUMBER_USERS_ON_PAGE + 1;
        }
    }
}
