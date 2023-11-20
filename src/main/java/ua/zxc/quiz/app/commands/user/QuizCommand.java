package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.entity.UserDAO;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class QuizCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(QuizCommand.class);

    private final QuizDAO quizDAO;

    private final UserDAO userDAO;

    private final QuestionDAO questionDAO;

    public QuizCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
        userDAO = irisDAOFactory.getUserDAO();
        questionDAO = irisDAOFactory.getQuestionDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        User user = (User) request.getSession().getAttribute("user");
        long quizId = Long.parseLong(request.getParameter("id"));
        try {
            Quiz quiz = quizDAO.get(quizId);
            if (userDAO.haveQuiz(user.getId(), quiz.getId())) {
                int score = userDAO.getScore(user.getId(), quiz.getId());
                request.setAttribute("score", score);
            }
            request.setAttribute("quiz", quiz);
            if (questionDAO.getNumberQuestionsByQuiz(quizId) == 0) {
                request.setAttribute("isEmpty", true);
                request.setAttribute("score", -1);
            }
            return new Page("/WEB-INF/jsp/app/quiz.jsp", false);
        } catch (DbException e) {
            LOGGER.error(e);
            return new Page("/WEB-INF/jsp/app/home.jsp", true);
        }
    }

}
