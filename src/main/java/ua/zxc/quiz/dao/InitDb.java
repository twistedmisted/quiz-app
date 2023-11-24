package ua.zxc.quiz.dao;

import com.caretdev.liquibase.database.core.IRISDatabase;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import liquibase.Scope;
import liquibase.command.CommandScope;
import liquibase.command.core.UpdateCommandStep;
import liquibase.command.core.helpers.DbUrlConnectionCommandStep;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.resource.ClassLoaderResourceAccessor;

import java.sql.Connection;

public class InitDb implements ServletContextListener {


    private static final String CHANGE_LOG_FILE_PATH = "/liquibase/db.changelog-root.xml";

    @Override
    public void contextInitialized(ServletContextEvent contextEvent) {
        try {
            Connection connection = DbManager.getInstance().getConnection();
            IRISDatabase database = (IRISDatabase) DatabaseFactory.getInstance()
                    .findCorrectDatabaseImplementation(new JdbcConnection(connection));
            Scope.child(Scope.Attr.resourceAccessor, new ClassLoaderResourceAccessor(), () ->
                    new CommandScope(UpdateCommandStep.COMMAND_NAME)
                            .addArgumentValue(UpdateCommandStep.CHANGELOG_FILE_ARG, CHANGE_LOG_FILE_PATH)
                            .addArgumentValue(DbUrlConnectionCommandStep.DATABASE_ARG, database)
                            .execute());
        } catch (Exception e) {
            throw new RuntimeException("Can't init db", e);
        }
    }
}
