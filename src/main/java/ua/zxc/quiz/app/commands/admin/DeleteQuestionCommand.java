package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.AnswersDAO;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.entity.VariantsDAO;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.exception.DbException;
import ua.zxc.quiz.exception.NoSuchArgumentException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DeleteQuestionCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(DeleteQuestionCommand.class);

    private final QuestionDAO questionDAO;

    private final VariantsDAO variantsDAO;

    private final AnswersDAO answersDAO;

    public DeleteQuestionCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        questionDAO = irisDAOFactory.getQuestionDAO();
        variantsDAO = irisDAOFactory.getVariantsDAO();
        answersDAO = irisDAOFactory.getAnswersDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            long questionId = getQuestionId(request);
            long quizId = getQuizId(request);
            Question question = questionDAO.get(questionId);
            answersDAO.delete(question.getId());
            variantsDAO.delete(question.getId());
            questionDAO.delete(question);
            return new Page("/admin/quizzes/questions?id=" + quizId +
                    "&page=" + request.getParameter("page"), true);
        } catch (NoSuchArgumentException | DbException e) {
            LOGGER.error(e);
            return new Page("/admin/quizzes?error=true", true);
        }
    }

    private long getQuizId(HttpServletRequest request) throws NoSuchArgumentException {
        return getId(request, "quiz_id");
    }

    private long getQuestionId(HttpServletRequest request) throws NoSuchArgumentException {
        return getId(request, "id");
    }

    private long getId(HttpServletRequest request, String parameter) throws NoSuchArgumentException {
        try {
            return Long.parseLong(request.getParameter(parameter));
        } catch (NumberFormatException e) {
            LOGGER.error(e.getMessage());
            throw new NoSuchArgumentException("Error parse request parameter to long", e);
        }
    }

}
