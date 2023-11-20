package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class UserQuizzesCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(UserQuizzesCommand.class);

    private final QuizDAO quizDAO;

    public UserQuizzesCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        User user = (User) request.getSession().getAttribute("user");
        try {
            List<Quiz> userQuizzes = quizDAO.getQuizzesByUserId(user.getId());
            request.setAttribute("userQuizzes", userQuizzes);
            return new Page("/WEB-INF/jsp/app/user-quizzes.jsp", false);
        } catch (DbException e) {
            LOGGER.error(e.getMessage());
            return new Page("/app/home", true);
        }
    }

}
