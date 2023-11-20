package ua.zxc.quiz.exception;

public class NotFoundCommandException extends RuntimeException {

    public NotFoundCommandException(String message) {
        super(message);
    }

    public NotFoundCommandException(String message, Throwable throwable) {
        super(message, throwable);
    }

}
