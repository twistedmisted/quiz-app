package ua.zxc.quiz.dao.entity;

import ua.zxc.quiz.dao.DbManager;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.exception.DbException;
import ua.zxc.quiz.exception.NotSupportedActionException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VariantsDAO implements DAO<String> {

    private static final Logger LOGGER = LogManager.getLogger(VariantsDAO.class);

    private static final String GET_VARIANTS = "SELECT value FROM variants WHERE question_id=(?);";

    private static final String INSERT_VARIANTS = "INSERT INTO variants (value, question_id) VALUES (?, ?);";

    private static final String DELETE_BY_QUESTION_ID = "DELETE FROM variants WHERE question_id=(?);";

    private static final String NOT_SUPPORTED_ACTION_EXCEPTION = "This is not supported action";

    private final DbManager dbManager;

    public VariantsDAO() {
        dbManager = DbManager.getInstance();
    }

    public List<String> getAllById(long id) throws DbException {
        List<String> variants = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_VARIANTS)) {
            int k = 0;
            statement.setLong(++k, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    variants.add(resultSet.getString("value"));
                }
                return variants;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get variants by id", e);
        }
    }

    public void insert(Question question) throws DbException {
        Connection connection = null;
        try {
            connection = dbManager.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            addVariants(connection, question);
            connection.commit();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            rollback(connection);
            throw new DbException("Can not to insert variants for question", e);
        } finally {
            close(connection);
        }
    }

    private void addVariants(Connection connection, Question question) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_VARIANTS,
                Statement.RETURN_GENERATED_KEYS)) {
            for (int i = 0; i < question.getVariants().size(); i++) {
                int k = 0;
                statement.setString(++k, question.getVariants().get(i));
                statement.setLong(++k, question.getId());
                statement.executeUpdate();
            }
        }
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

    @Override
    public String get(long id) throws DbException {
        throw new NotSupportedActionException(NOT_SUPPORTED_ACTION_EXCEPTION);
    }

    @Override
    public List<String> getAll() throws DbException {
        throw new NotSupportedActionException(NOT_SUPPORTED_ACTION_EXCEPTION);
    }

    @Override
    public String insert(String s) throws DbException {
        throw new NotSupportedActionException(NOT_SUPPORTED_ACTION_EXCEPTION);
    }

    @Override
    public void update(String s) throws DbException {
        throw new NotSupportedActionException(NOT_SUPPORTED_ACTION_EXCEPTION);
    }

    @Override
    public void delete(String s) throws DbException {
        throw new NotSupportedActionException(NOT_SUPPORTED_ACTION_EXCEPTION);
    }

    public void delete(long id) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_BY_QUESTION_ID)) {
            int k = 0;
            statement.setLong(++k, id);
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to delete answers", e);
        }
    }
}