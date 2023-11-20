package ua.zxc.quiz.app.commands.user;

import ua.zxc.quiz.app.commands.Command;
import ua.zxc.quiz.app.web.Page;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.dao.entity.QuestionDAO;
import ua.zxc.quiz.dao.entity.QuizDAO;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import ua.zxc.quiz.utils.Constants;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class DoQuizCommand implements Command {

    private static final Logger LOGGER = LogManager.getLogger(DoQuizCommand.class);

    private User user;

    private Quiz quiz;

    private List<Question> questions;

    private final QuizDAO quizDAO;

    private final QuestionDAO questionDAO;

    public DoQuizCommand() {
        IrisDaoFactory irisDAOFactory = new IrisDaoFactory();
        quizDAO = irisDAOFactory.getQuizDAO();
        questionDAO = irisDAOFactory.getQuestionDAO();
    }

    @Override
    public Page execute(HttpServletRequest request, HttpServletResponse response) {
        long quizId = Long.parseLong(request.getParameter(Constants.QUIZ_ID));
        try {
            if (request.getSession().getAttribute(Constants.QUESTIONS) == null) {
                initParams(request, quizId);
            }
            return getQuestion(request, quizId);
        } catch (Exception e) {
            return new Page("/app/quiz?id=" + quizId, true);
        }
    }

    private Page getQuestion(HttpServletRequest request, long quizId) throws DbException {
        int index = Integer.parseInt(request.getParameter(Constants.QUESTION)) - 1;
        if (index > 0) {
            checkAnswerAndUpdateScore(request);
        }
        if (checkTime(request) || checkIndex(questions.size(), index)) {
            updateScore(request);
            clearSession(request);
            return new Page("/app/quiz?id=" + quizId, true);
        }
        Question question = questions.get(index);
        request.getSession().setAttribute(Constants.QUESTION, question);
        return new Page("/app/question?quiz_id=" + quizId + "&question=" + (index + 1), true);
    }

    private void updateScore(HttpServletRequest request) throws DbException {
        int score;
        if (request.getSession().getAttribute(Constants.SCORE) != null) {
            score = (int) request.getSession().getAttribute(Constants.SCORE);
            score = score * 100 / questions.size();
            quizDAO.updateScore(user.getId(), quiz.getId(), score);
        }
    }

    private void checkAnswerAndUpdateScore(HttpServletRequest request) {
        List<Character> userAnswers = new ArrayList<>();
        List<Character> answers = ((Question) request.getSession().getAttribute(Constants.QUESTION)).getAnswers();
        int score = (int) request.getSession().getAttribute(Constants.SCORE);
        for (int i = 0; i < 4; i++) {
            char letter = (char) ('a' + i);
            String answer = request.getParameter(String.valueOf(letter));
            if (answer != null) {
                userAnswers.add(answer.charAt(0));
            }
        }

        Collections.sort(userAnswers);
        Collections.sort(answers);

        if (userAnswers.equals(answers)) {
            score++;
        }
        request.getSession().setAttribute(Constants.SCORE, score);
    }

    private void initParams(HttpServletRequest request, long quizId) throws DbException {
        user = (User) request.getSession().getAttribute("user");
        try {
            quiz = quizDAO.get(quizId);
            quizDAO.setUserForQuiz(user.getId(), quizId);
            questions = questionDAO.getAllByQuizId(quizId);
            setOptionsToSession(request);
        } catch (DbException e) {
            LOGGER.error(e);
            throw new DbException("Error set questions", e);
        }
    }

    private boolean checkIndex(int size, int index) {
        return index >= size;
    }

    private boolean checkTime(HttpServletRequest request) {
        Date timeNow = new Date();
        Date quizEndTime = (Date) request.getSession().getAttribute(Constants.QUIZ_FINISH);
        return timeNow.compareTo(quizEndTime) > -1;
    }

    private void setOptionsToSession(HttpServletRequest request) {
        request.getSession().setAttribute(Constants.QUIZ_ID, quiz.getId());
        request.getSession().setAttribute(Constants.QUESTIONS, questions);
        request.getSession().setAttribute(Constants.SCORE, 0);
        int timeForQuiz = quiz.getDuration();
        long quizFinishAt = System.currentTimeMillis() + (long) timeForQuiz * 60 * 1000;
        request.getSession().setAttribute(Constants.QUIZ_FINISH, new Date(quizFinishAt));
    }

    private void clearSession(HttpServletRequest request) {
        request.getSession().removeAttribute(Constants.QUIZ_ID);
        request.getSession().removeAttribute(Constants.QUESTION);
        request.getSession().removeAttribute(Constants.QUESTIONS);
        request.getSession().removeAttribute(Constants.SCORE);
        request.getSession().removeAttribute(Constants.QUIZ_FINISH);
    }
}
