package ua.zxc.quiz.dao;

import ua.zxc.quiz.dao.entity.*;

public interface DAOFactory {
    UserDAO getUserDAO();
    QuestionDAO getQuestionDAO();
    QuizDAO getQuizDAO();
    VariantsDAO getVariantsDAO();
    AnswersDAO getAnswersDAO();
}
