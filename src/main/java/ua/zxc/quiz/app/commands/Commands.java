package ua.zxc.quiz.app.commands;

import ua.zxc.quiz.app.commands.admin.*;
import ua.zxc.quiz.app.commands.user.*;

public enum Commands {

    LOGIN("/login", new LogInCommand()),
    REGISTRATION("/registration", new RegistrationCommand()),
    HOME("/app/home", new HomeCommand()),
    ALL_QUIZZES("/app/all-quizzes", new AllQuizzesCommand()),
    USER_QUIZZES("/app/my-quizzes", new UserQuizzesCommand()),
    ABOUT("/app/about", new AboutCommand()),
    PROFILE("/app/profile", new ProfileCommand()),
    LOG_OUT("/app/logout", new LogOutCommand()),
    QUIZ("/app/quiz", new QuizCommand()),
    START_QUIZ("/app/start", new DoQuizCommand()),
    SHOW_QUESTION("/app/question", new ShowQuestionCommand()),
    ADMIN("/admin", new AdminCommand()),
    USERS("/admin/users", new ShowUsersCommand()),
    QUIZZES("/admin/quizzes", new ShowQuizzesCommand()),
    QUESTIONS("/admin/quizzes/questions", new ShowQuestionsCommand()),
    EDIT_USER("/admin/edit-user", new EditUserCommand()),
    EDIT_QUIZ("/admin/edit-quiz", new EditQuizCommand()),
    BLOCK_USER("/admin/block-user", new BlockUserCommand()),
    UNBLOCK_USER("/admin/unblock-user", new UnblockUserCommand()),
    DELETE_USER("/admin/delete-user", new DeleteUserCommand()),
    DELETE_QUIZ("/admin/delete-quiz", new DeleteQuizCommand()),
    ADD_QUIZ("/admin/add-quiz", new AddQuizCommand()),
    ADD_QUESTION("/admin/add-question", new AddQuestionCommand()),
    DELETE_QUESTION("/admin/delete-question", new DeleteQuestionCommand());

    Command command;

    private final String path;

    Commands(String path, Command command) {
        this.path = path;
        this.command = command;
    }

    public String getPath() {
        return path;
    }

    public Command getCommand() {
        return command;
    }
}
