package ua.zxc.quiz.dao;

import ua.zxc.quiz.dao.entity.*;

public class IrisDaoFactory implements DAOFactory {

    @Override
    public UserDAO getUserDAO() {
        return new UserDAO();
    }

    @Override
    public QuestionDAO getQuestionDAO() {
        return new QuestionDAO();
    }

    @Override
    public QuizDAO getQuizDAO() {
        return new QuizDAO();
    }

    @Override
    public VariantsDAO getVariantsDAO() {
        return new VariantsDAO();
    }

    @Override
    public AnswersDAO getAnswersDAO() {
        return new AnswersDAO();
    }

}
