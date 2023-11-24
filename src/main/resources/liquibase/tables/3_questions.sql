--liquibase formatted sql

--changeset Andrii Mishchenko:3
CREATE TABLE questions
(
    id      BIGINT       NOT NULL AUTO_INCREMENT,
    prompt  VARCHAR(200) NOT NULL,
    quiz_id BIGINT       NOT NULL
);

ALTER TABLE questions
    ADD CONSTRAINT pk_questions PRIMARY KEY (id);
ALTER TABLE questions
    ADD CONSTRAINT fk_questions_quizzes FOREIGN KEY (quiz_id) REFERENCES quizzes (id);