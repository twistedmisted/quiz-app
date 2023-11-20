package ua.zxc.quiz.dao.entity;

import ua.zxc.quiz.dao.DbManager;
import ua.zxc.quiz.dao.model.Question;
import ua.zxc.quiz.dao.model.Quiz;
import ua.zxc.quiz.dao.utils.QuizStatus;
import ua.zxc.quiz.exception.DbException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.List;

public class QuizDAO implements DAO<Quiz> {

    private static final Logger LOGGER = LogManager.getLogger(QuizDAO.class);

    private static final String GET_QUIZ_BY_ID = "SELECT * FROM quizzes WHERE id=(?);";

    private static final String GET_QUIZ_BY_NAME = "SELECT * FROM quizzes WHERE name=(?);";

    private static final String GET_QUIZ_BY_SUBJECT = "SELECT * FROM quizzes WHERE subject=(?);";

    private static final String DELETE_QUIZ = "DELETE FROM quizzes WHERE id=(?);";

    private static final String UPDATE_QUIZ = "UPDATE quizzes SET name=(?), duration=(?), difficulty=(?), subject=(?), status=(?) WHERE id=(?);";

    private static final String INSERT_QUIZ = "INSERT INTO quizzes (name, duration, difficulty, subject) VALUES (?, ?, ?, ?);";

    private static final String SET_QUESTION_FOR_QUIZ = "INSERT INTO questions (prompt, quiz_id) VALUES (?, ?);";

    private static final String GET_LAST_FOUR_QUIZZES = "SELECT TOP 4 * FROM quizzes WHERE status = 'PUBLISHED' ORDER BY id DESC;";
//    private static final String GET_LAST_FOUR_QUIZZES =
//            "SELECT quiz.* FROM quiz, questions_quiz " +
//                    "WHERE quiz.id=questions_quiz.quiz_id " +
//                    "GROUP BY quiz_id ORDER BY quiz.id DESC LIMIT 4;";

    private static final String GET_ALL_SORT_BY_NAME = "SELECT * FROM quizzes WHERE status = 'PUBLISHED' ORDER BY NAME;";
//            "SELECT quiz.* FROM quiz, questions_quiz " +
//                    "WHERE quiz.id=questions_quiz.quiz_id GROUP BY name ORDER BY name;";

    private static final String GET_ALL_SORT_BY_NUMBER_OF_QUESTIONS =
            "SELECT quizzes.* FROM quizzes, questions " +
                    "WHERE quizzes.id=questions.quiz_id AND quizzes.status = 'PUBLISHED' GROUP BY questions.quiz_id ORDER BY COUNT(questions.quiz_id);";
//            "SELECT quiz.* FROM quiz, questions_quiz " +
//                    "WHERE quiz.id=questions_quiz.quiz_id " +
//                    "GROUP BY questions_quiz.quiz_id " +
//                    "ORDER BY COUNT(questions_quiz.quiz_id);";

    private static final String GET_ALL_QUIZ = "SELECT * FROM quizzes WHERE status = 'PUBLISHED' ORDER BY id;";
//            "SELECT quiz.* FROM quiz, questions_quiz " +
//                    "WHERE quiz.id=questions_quiz.quiz_id GROUP BY quiz_id ORDER BY quiz_id;";

    private static final String INSERT_USER_FOR_QUIZ = "INSERT INTO users_quizzes (user_id, quiz_id) VALUES (?, ?);";

    private static final String GET_FOUR_USER_QUIZZES =
            "SELECT TOP 4 quizzes.* FROM users_quizzes, quizzes " +
                    "WHERE users_quizzes.user_id=(?) and users_quizzes.quiz_id=quizzes.id " +
                    "ORDER BY id DESC;";

    private static final String UPDATE_SCORE = "UPDATE users_quizzes SET score=? WHERE user_id=? AND quiz_id=?;";

    private static final String GET_QUIZZES_BY_RANGE = "SELECT * FROM (SELECT * FROM quizzes) WHERE %vid BETWEEN ? AND ?;";

    private static final String GET_NUMBER_OF_QUIZZES = "SELECT COUNT(*) FROM quizzes;";

    private static final String GET_SUBJECTS = "SELECT DISTINCT subject FROM quizzes;";

    private final DbManager dbManager;

    public QuizDAO() {
        dbManager = DbManager.getInstance();
    }

    @Override
    public Quiz get(long id) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZ_BY_ID)) {
            int k = 0;
            statement.setLong(++k, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapQuiz(resultSet);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get quiz", e);
        }
    }

    @Override
    public List<Quiz> getAll() throws DbException {
        return getQuizzes(GET_ALL_QUIZ);
    }

    @Override
    public Quiz insert(Quiz quiz) throws DbException {
        Connection connection = null;
        try {
            connection = dbManager.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            quiz = addQuiz(connection, quiz);
            connection.commit();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            rollback(connection);
            throw new DbException("Can not to insert quiz", e);
        } finally {
            close(connection);
        }
        return quiz;
    }

    @Override
    public void update(Quiz quiz) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_QUIZ)) {
            int k = 0;
            statement.setString(++k, quiz.getName());
            statement.setInt(++k, quiz.getDuration());
            statement.setString(++k, quiz.getDifficulty());
            statement.setString(++k, quiz.getSubject());
            statement.setString(++k, String.valueOf(quiz.getStatus()));
            statement.setLong(++k, quiz.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to update quiz", e);
        }
    }

    @Override
    public void delete(Quiz quiz) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(DELETE_QUIZ)) {
            int k = 0;
            statement.setLong(++k, quiz.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to delete quiz", e);
        }
    }

    public Quiz get(String name) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZ_BY_NAME)) {
            int k = 0;
            statement.setString(++k, name);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapQuiz(resultSet);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get quiz", e);
        }
    }

    public List<Quiz> getAllSortedByName() throws DbException {
        return getQuizzes(GET_ALL_SORT_BY_NAME);
    }

    public List<Quiz> getAllBySubject(String name) throws DbException {
        List<Quiz> quizzes = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZ_BY_SUBJECT)) {
            int k = 0;
            statement.setString(++k, name);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    quizzes.add(mapQuiz(resultSet));
                }
                return quizzes;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get all quizzes by subject", e);
        }
    }

    public List<Quiz> getAllSortedByDifficulty() throws DbException {
        List<Quiz> quizzes = getAll();
        List<String> difficultyOrder = Arrays.asList("easy", "normal", "hard");
        Comparator<Quiz> quizComparator = Comparator.comparing(q -> difficultyOrder.indexOf(q.getDifficulty()));
        quizzes.sort(quizComparator);
        return quizzes;
    }

    public List<Quiz> getAllSortedByNumberOfQuestions() throws DbException {
        return getQuizzes(GET_ALL_SORT_BY_NUMBER_OF_QUESTIONS);
    }

    public List<Quiz> getLastFour() throws DbException {
        return getQuizzes(GET_LAST_FOUR_QUIZZES);
    }

    public List<Quiz> getQuizzesByUserId(long id) throws DbException {
        List<Quiz> quizzes = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_FOUR_USER_QUIZZES)) {
            int k = 0;
            statement.setLong(++k, id);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    quizzes.add(mapQuiz(resultSet));
                }
                return quizzes;
            }
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get quizzes", e);
        }
    }

    public List<Quiz> getByRange(long start, long end) throws DbException {
        List<Quiz> quizzes = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(GET_QUIZZES_BY_RANGE)) {
            int k = 0;
            statement.setLong(++k, start);
            statement.setLong(++k, end);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    quizzes.add(mapQuiz(resultSet));
                }
            }
            return quizzes;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get quizzes by range", e);
        }
    }

    public int getNumber() throws DbException {
        try (Connection connection = dbManager.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_NUMBER_OF_QUIZZES)) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to number of quizzes", e);
        }
    }

    public List<String> getSubjects() throws DbException {
        List<String> subjects = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(GET_SUBJECTS)) {
            while (resultSet.next()) {
                subjects.add(resultSet.getString(1));
            }
            return subjects;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get subjects", e);
        }
    }

    private List<Quiz> getQuizzes(String query) throws DbException {
        List<Quiz> quizzes = new ArrayList<>();
        try (Connection connection = dbManager.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {
            while (resultSet.next()) {
                quizzes.add(mapQuiz(resultSet));
            }
            return quizzes;
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to get quizzes", e);
        }
    }

    private Quiz mapQuiz(ResultSet resultSet) throws SQLException {
        Quiz quiz = new Quiz();
        quiz.setId(resultSet.getLong("id"));
        quiz.setName(resultSet.getString("name"));
        quiz.setDuration(resultSet.getInt("duration"));
        quiz.setDifficulty(resultSet.getString("difficulty"));
        quiz.setSubject(resultSet.getString("subject"));
        quiz.setStatus(QuizStatus.valueOf(resultSet.getString("status")));
        return quiz;
    }

    private Quiz addQuiz(Connection connection, Quiz quiz) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(INSERT_QUIZ,
                Statement.RETURN_GENERATED_KEYS)) {
            int k = 0;
            statement.setString(++k, quiz.getName());
            statement.setInt(++k, quiz.getDuration());
            statement.setString(++k, quiz.getDifficulty());
            statement.setString(++k, quiz.getSubject());
            int count = statement.executeUpdate();
            if (count != 0) {
                try (ResultSet resultSet = statement.getGeneratedKeys()) {
                    if (resultSet.next()) {
                        quiz.setId(resultSet.getLong(1));
                        return quiz;
                    }
                }
            }
        }
        throw new SQLException("Can not to add a quiz");
    }

    public void setQuestionForQuiz(Quiz quiz, Question question) throws DbException {
        Connection connection = null;
        try {
            connection = dbManager.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            addQuestionForQuiz(connection, quiz, question);
            connection.commit();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            rollback(connection);
            throw new DbException("Can not to set question for quiz", e);
        } finally {
            close(connection);
        }
    }

    public void setUserForQuiz(long userId, long quizId) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(INSERT_USER_FOR_QUIZ)) {
            int k = 0;
            statement.setLong(++k, userId);
            statement.setLong(++k, quizId);
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to set user for quiz", e);
        }
    }

    private void addQuestionForQuiz(Connection connection, Quiz quiz, Question question) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(SET_QUESTION_FOR_QUIZ)) {
            int k = 0;
            statement.setLong(++k, quiz.getId());
            statement.setLong(++k, question.getId());
            statement.executeUpdate();
        }
    }

    public void updateScore(long userId, long quizId, int score) throws DbException {
        try (Connection connection = dbManager.getConnection();
             PreparedStatement statement = connection.prepareStatement(UPDATE_SCORE)) {
            int k = 0;
            statement.setInt(++k, score);
            statement.setLong(++k, userId);
            statement.setLong(++k, quizId);
            statement.executeUpdate();
        } catch (SQLException e) {
            LOGGER.error(e.getMessage());
            throw new DbException("Can not to update score", e);
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

}
