package ua.zxc.quiz.dao;

import org.junit.Before;
import org.junit.Test;
import ua.zxc.quiz.dao.entity.*;

import static org.junit.Assert.assertNotNull;

public class IrisDaoFactoryTest {

    IrisDaoFactory irisDAOFactory;

    @Before
    public void setUp() {
        irisDAOFactory = new IrisDaoFactory();
    }

    @Test
    public void getUserDAOTest() {
        UserDAO userDAO = irisDAOFactory.getUserDAO();
        assertNotNull(userDAO);
    }

    @Test
    public void getQuestionDAOTest() {
        QuestionDAO questionDAO = irisDAOFactory.getQuestionDAO();
        assertNotNull(questionDAO);
    }

    @Test
    public void getQuizDAOTest() {
        QuizDAO quizDAO = irisDAOFactory.getQuizDAO();
        assertNotNull(quizDAO);
    }

    @Test
    public void getVariantsDAOTest() {
        VariantsDAO variantsDAO = irisDAOFactory.getVariantsDAO();
        assertNotNull(variantsDAO);
    }

    @Test
    public void getAnswerDAOTest() {
        AnswersDAO answersDAO = irisDAOFactory.getAnswersDAO();
        assertNotNull(answersDAO);
    }

}