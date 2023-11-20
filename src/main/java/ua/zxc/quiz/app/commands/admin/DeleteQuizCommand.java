package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.AnswersDAO;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.entity.VariantsDAO;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.dao.model.Quiz;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class DeleteQuizCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(DeleteQuizCommand.class);

    private final QuizDAO quizDAO;

    private final QuestionDAO questionDAO;

    private final AnswersDAO answersDAO;

    private final VariantsDAO variantsDAO;

    public DeleteQuizCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        questionDAO = irisDAOFactory.getQuestionDAO();
        quizDAO = irisDAOFactory.getQuizDAO();
        answersDAO = irisDAOFactory.getAnswersDAO();
        variantsDAO = irisDAOFactory.getVariantsDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        long id = Long.parseLong(request.getParameter("id"));
        try {
            Quiz quiz = quizDAO.get(id);
            for (Question question : questionDAO.getAllByQuizId(quiz.getId())) {
                answersDAO.delete(question.getId());
                variantsDAO.delete(question.getId());
                questionDAO.delete(question);
            }
            quizDAO.delete(quiz);
            return new Page("/admin/quizzes?page=" + request.getParameter("page"), true);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            return new Page("/admin/quizzes?error=true", true);
        }
    }
}
