package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.exception.DbException;
import ua.zxc.quiz.exception.NoSuchArgumentException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;

public class ShowQuestionsCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(ShowQuestionsCommand.class);

    private final QuestionDAO questionDAO;

    public ShowQuestionsCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        questionDAO = irisDAOFactory.getQuestionDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            long quizId = getId(request);
            List<Question> questions = questionDAO.getAllByQuizId(quizId);
            request.setAttribute("questions", questions);
            return new Page("/WEB-INF/jsp/admin/questions.jsp", false);
        } catch (DbException | NoSuchArgumentException e) {
            LOGGER.error(e);
            return new Page("/admin/quizzes?error=true", true);
        }
    }

    private long getId(HttpServletRequest request) throws NoSuchArgumentException {
        try {
            return Long.parseLong(request.getParameter("id"));
        } catch (NumberFormatException e) {
            LOGGER.error(e.getMessage());
            throw new NoSuchArgumentException("Error parse request parameter to long", e);
        }
    }

}
