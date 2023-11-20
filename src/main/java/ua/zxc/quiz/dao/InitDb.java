package ua.zxc.quiz.dao;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.stream.Collectors;

public class InitDb implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent contextEvent) {
        ClassLoader classloader = Thread.currentThread().getContextClassLoader();
        InputStream is = classloader.getResourceAsStream("/db/script.sql");
        String script = new BufferedReader(
                new InputStreamReader(is, StandardCharsets.UTF_8))
                .lines()
                .collect(Collectors.joining("\n"));
        try (Connection connection = DbManager.getInstance().getConnection();
             Statement statement = connection.createStatement()) {
            String[] commands = script.split(";");
            for (String  command : commands) {
                statement.execute(command.trim());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Can't init db", e);
        }
    }
}
