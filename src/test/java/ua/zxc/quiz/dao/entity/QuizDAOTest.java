package ua.zxc.quiz.dao.entity;

import ua.zxc.quiz.dao.DbManager;
import ua.zxc.quiz.dao.IrisDaoFactory;
import ua.zxc.quiz.exception.DbException;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Connection;
import java.sql.SQLException;

import static org.junit.Assert.assertNull;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class QuizDAOTest {

    @Mock
    DbManager dbManager;

    @Mock
    IrisDaoFactory irisDAOFactory;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void getQuizTest() throws SQLException {
        Connection connection = mock(Connection.class);
        QuizDAO quizDAO = mock(QuizDAO.class);
        when(dbManager.getConnection()).thenReturn(connection);
        when(irisDAOFactory.getQuizDAO()).thenReturn(quizDAO);
        try {
            when(quizDAO.get("Incorrect Quiz Name")).thenThrow(DbException.class);
        } catch (DbException e) {
            e.printStackTrace();
        }
        try {
            assertNull(quizDAO.get("Incorrect Quiz Name"));
        } catch (DbException e) {
            e.printStackTrace();
        }
    }

}
