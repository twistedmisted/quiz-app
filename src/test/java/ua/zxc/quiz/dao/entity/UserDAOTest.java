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

public class UserDAOTest {

    @Mock
    DbManager dbManager;

    @Mock
    IrisDaoFactory irisDAOFactory;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void getByLoginAndPasswordTest() throws SQLException {
        Connection connection = mock(Connection.class);
        UserDAO userDAO = mock(UserDAO.class);
        when(dbManager.getConnection()).thenReturn(connection);
        when(irisDAOFactory.getUserDAO()).thenReturn(userDAO);
        try {
            when(userDAO.getByLoginAndPassword("incorrect","incorrect")).thenThrow(DbException.class);
        } catch (DbException e) {
            e.printStackTrace();
        }
        try {
            assertNull(userDAO.getByLoginAndPassword("incorrect", "incorrect"));
        } catch (DbException e) {
            e.printStackTrace();
        }

    }

}
