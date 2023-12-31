package ua.zxc.quiz.dao.entity;

import ua.zxc.quiz.dao.DbManager;
import ua.zxc.quiz.dao.model.User;
import ua.zxc.quiz.exception.DbException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO implements DAO<User> {

    private static final Logger LOGGER = LogManager.getLogger(UserDAO.class);

    private static final String INSERT_USER = "INSERT INTO users (email, login, password, access_level) VALUES (?, ?, ?, ?);";

    private static final String GET_USER_BY_LOGIN = "SELECT * FROM users WHERE login=(?);";

    private static final String GET_USER_BY_EMAIL = "SELECT * FROM users WHERE email=(?);";

    private static final String GET_USER_BY_ID = "SELECT * FROM users WHERE id=(?);";

    private static final String GET_USER_BY_LOGIN_AND_PASSWORD = "SELECT * FROM users WHERE login=(?) AND password=(?);";

    private static final String GET_USERS = "SELECT * FROM users ORDER BY id;";

    private static final String UPDATE_USER = "UPDATE users SET email=(?), login=(?), password=(?), access_level=(?)" +
            "WHERE id=(?);";

    private static final String DELETE_USER = "DELETE FROM users WHERE id=(?);";

    private static final String GET_QUIZ_FOR_USER = "SELECT * FROM users_quizzes WHERE user_id=(?) and quiz_id=(?);";

    private static final String GET_QUIZ_SCORE = "SELECT score FROM users_quizzes WHERE user_id=(?) and quiz_id=(?);";

    private static final String GET_USERS_BY_RANGE = "SELECT * FROM (SELECT * FROM users) WHERE %vid BETWEEN ? AND ?;";

    private static final String GET_NUMBER_OF_USERS = "SELECT COUNT(*) FROM users;";

    private final DbManager dbManager;

    public UserDAO() {
        dbManager = DbManager.getInstance();
    }

    @Override
    public User get(long id) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_USER_BY_ID)) {
            int k = 0;
            statement.setLong(++k, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get user by id", e);
        }
    }

    @Override
    public List<User> getAll() throws DbException {
        List<User> users = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_USERS)) {
            while (resultSet.next()) {
                users.add(mapUser(resultSet));
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get all users", e);
        }
        return users;
    }

    @Override
    public User insert(User user) throws DbException {
        Connection connection = null;
        try {
            connection = dbManager.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            user = insertUser(connection, user);
            connection.commit();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            rollback(connection);
            throw new DbException("Can not to insert user", e);
        } finally {
            close(connection);
        }
        return user;
    }

    @Override
    public void update(User user) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_USER)) {
            int k = 0;
            statement.setString(++k, user.getEmail());
            statement.setString(++k, user.getLogin());
            statement.setString(++k, user.getPassword());
            statement.setString(++k, user.getAccessLevel());
            statement.setLong(++k, user.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to update user", e);
        }
    }

    @Override
    public void delete(User user) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_USER)) {
            int k = 0;
            statement.setLong(++k, user.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to delete user", e);
        }
    }

    public User getByLoginAndPassword(String login, String password) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_USER_BY_LOGIN_AND_PASSWORD)) {
            int k = 0;
            statement.setString(++k, login);
            statement.setString(++k, password);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get user by login and password", e);
        }
    }

    public User getByLogin(String login) throws DbException {
        return getUser(login, GET_USER_BY_LOGIN);
    }

    public User getByEmail(String email) throws DbException {
        return getUser(email, GET_USER_BY_EMAIL);
    }

    public List<User> getByRange(long start, long end) throws DbException {
        List<User> users = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_USERS_BY_RANGE)) {
            int k = 0;
            statement.setLong(++k, start);
            statement.setLong(++k, end);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    users.add(mapUser(resultSet));
                }
            }
            return users;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get user by range", e);
        }
    }

    public int getNumber() throws DbException {
        try (Connection connection = dbManager.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_NUMBER_OF_USERS)) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get number of users", e);
        }
    }

    public boolean haveQuiz(long userId, long quizId) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZ_FOR_USER)) {
            int k = 0;
            statement.setLong(++k, userId);
            statement.setLong(++k, quizId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to verify that user has quiz", e);
        }
    }

    public int getScore(long userId, long quizId) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZ_SCORE)) {
            int k = 0;
            statement.setLong(++k, userId);
            statement.setLong(++k, quizId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get user score", e);
        }
    }

    private User getUser(String value, String query) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            int k = 0;
            statement.setString(++k, value);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapUser(resultSet);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get user", e);
        }
    }

    private User mapUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getLong("id"));
        user.setEmail(resultSet.getString("email"));
        user.setLogin(resultSet.getString("login"));
        user.setPassword(resultSet.getString("password"));
        user.setAccessLevel(resultSet.getString("access_level"));
        return user;
    }

    private User insertUser(Connection connection, User user) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_USER,
                Statement.RETURN_GENERATED_KEYS)) {
            int k = 0;
            statement.setString(++k, user.getEmail());
            statement.setString(++k, user.getLogin());
            statement.setString(++k, user.getPassword());
            statement.setString(++k, user.getAccessLevel());
            int count = statement.executeUpdate();
            if (count > 0) {
                try (ResultSet resultSet = statement.getGeneratedKeys()) {
                    if (resultSet.next()) {
                        user.setId(resultSet.getLong(1));
                        return user;
                    }
                }
            }
        }
        throw new SQLException("Can not to add a user");
    }

    private void rollback(Connection con) {
        try {
            if (con != null) {
                con.rollback();
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
        }
    }

    private void close(AutoCloseable stmt) {
        if (stmt != null) {
            try {
                stmt.close();
            } catch (Exception e) {
                LOGGER.error(e.getMessage());
            }
        }
    }

}
