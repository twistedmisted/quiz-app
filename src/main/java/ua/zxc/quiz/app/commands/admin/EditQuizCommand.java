package ua.zxc.quiz.app.commands.admin;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.utils.QuizStatus;
import ua.zxc.quiz.exception.DbException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.Arrays;

public class EditQuizCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(EditQuizCommand.class);

    private final QuizDAO quizDAO;

    public EditQuizCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        long id = Long.parseLong(request.getParameter("id"));
        try {
            Quiz quiz = quizDAO.get(id);
            if (quiz == null) {
                return new Page("/admin/quizzes", true);
            }
            if (request.getMethod().equalsIgnoreCase("get")) {
                return setAttributes(request, id, quiz);
            }
            if (!validation(request, quizDAO)) {
                return new Page("/admin/edit-quiz?id=" + id + "&error=true", true);
            }
            quizDAO.update(createNewQuiz(request, quiz));
            return new Page("/admin/quizzes", true);
        } catch (Exception e) {
            LOGGER.error(e.getMessage());
            return new Page("/admin/quizzes?error=true", true);
        }
    }

    private Page setAttributes(HttpServletRequest request, long id, Quiz quiz) {
        request.setAttribute("quiz", quiz);
        request.setAttribute("id", id);
        request.setAttribute("statuses", Arrays.asList(QuizStatus.values()));
        return new Page("/WEB-INF/jsp/admin/edit-quiz.jsp", false);
    }

    private boolean validation(HttpServletRequest request, QuizDAO quizDAO) throws DbException {
        String name = request.getParameter("name");
        int time = Integer.parseInt(request.getParameter("time"));
        String difficulty = request.getParameter("difficulty");
        String subject = request.getParameter("subject");
        String status = request.getParameter("status");
        if (name.isEmpty() || quizDAO.get(name) == null) {
            return false;
        }
        if (subject.isEmpty()) {
            return false;
        }
        if (difficulty.isEmpty()) {
            return false;
        }
        if (status.isEmpty() || !Arrays.asList(QuizStatus.values()).contains(QuizStatus.valueOf(status))) {
            return false;
        }
        return time > 0;
    }

    private Quiz createNewQuiz(HttpServletRequest request, Quiz quiz) {
        quiz.setName(request.getParameter("name"));
        quiz.setDifficulty(request.getParameter("difficulty"));
        quiz.setDuration(Integer.parseInt(request.getParameter("time")));
        quiz.setSubject(request.getParameter("subject"));
        quiz.setStatus(QuizStatus.valueOf(request.getParameter("status")));
        return quiz;
    }

}
