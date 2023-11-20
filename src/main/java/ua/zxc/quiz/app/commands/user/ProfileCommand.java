package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.entity.UserDAO;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProfileCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(ProfileCommand.class);

    private final QuizDAO quizDAO;

    private final UserDAO userDAO;

    public ProfileCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
        userDAO = irisDAOFactory.getUserDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        User user = (User) request.getSession().getAttribute("user");
        try {
            List<Quiz> userQuizzes = quizDAO.getQuizzesByUserId(user.getId());
            Map<Quiz, Integer> quizzesWithScore = new HashMap<>();
            for (Quiz quiz : userQuizzes) {
                quizzesWithScore.put(quiz, userDAO.getScore(user.getId(), quiz.getId()));
            }
            request.setAttribute("quizzesWithScore", quizzesWithScore);
            return new Page("/WEB-INF/jsp/app/profile.jsp", false);
        } catch (DbException e) {
            LOGGER.error(e);
            return new Page("/app/home", true);
        }
    }

}
