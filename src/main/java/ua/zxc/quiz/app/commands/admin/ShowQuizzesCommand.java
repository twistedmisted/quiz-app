package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class ShowQuizzesCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(ShowQuizzesCommand.class);

    private static final int NUMBER_QUESTIONS_ON_PAGE = 10;

    private final QuizDAO quizDAO;

    public ShowQuizzesCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            int page = getPage(request);
            int start = 0;
            if (page > 1) {
                start = (page - 1) * NUMBER_QUESTIONS_ON_PAGE + 1;
            }
            int end = start + NUMBER_QUESTIONS_ON_PAGE;
            int totalNumberOfQuizzes = quizDAO.getNumber();
            int numberOfPages = getNumberOfPages(totalNumberOfQuizzes);
            List<Quiz> quizzes = quizDAO.getByRange(start, end);
            request.setAttribute("quizzes", quizzes);
            request.setAttribute("currentPage", page);
            request.setAttribute("numberOfPages", numberOfPages);
            return new Page("/WEB-INF/jsp/admin/quizzes.jsp", false);
        } catch (DbException e) {
            LOGGER.error(e.getMessage());
            return new Page("/admin?error=true", true);
        }
    }

    private int getPage(HttpServletRequest request) {
        if (request.getParameter("page") == null) {
            return 1;
        }
        return Integer.parseInt(request.getParameter("page"));
    }

    private int getNumberOfPages(int totalNumberOfQuizzes) {
        if (totalNumberOfQuizzes == 0) {
            return 1;
        }
        if (totalNumberOfQuizzes % NUMBER_QUESTIONS_ON_PAGE == 0) {
            return totalNumberOfQuizzes / NUMBER_QUESTIONS_ON_PAGE;
        } else {
            return totalNumberOfQuizzes / NUMBER_QUESTIONS_ON_PAGE + 1;
        }
    }
}
