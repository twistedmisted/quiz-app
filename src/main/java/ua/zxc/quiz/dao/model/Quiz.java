package ua.zxc.quiz.dao.model;

import ua.zxc.quiz.dao.utils.QuizStatus;

public class Quiz {

    private long id;

    private String name;

    private int duration;

    private String difficulty;

    private String subject;

    private QuizStatus status;

    public static Quiz createQuiz(String name, int time, String difficulty, String subject) {
        Quiz quiz = new Quiz();
        quiz.setName(name);
        quiz.setDuration(time);
        quiz.setDifficulty(difficulty);
        quiz.setSubject(subject);
        return quiz;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public void setDifficulty(String difficulty) {
        this.difficulty = difficulty;
    }

    public String getSubject() {
        return subject;
    }

    public void setSubject(String subject) {
        this.subject = subject;
    }

    public QuizStatus getStatus() {
        return status;
    }

    public void setStatus(QuizStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Test: " + name + " " + duration + " " + difficulty + " " + subject + " " + status;
    }
}
