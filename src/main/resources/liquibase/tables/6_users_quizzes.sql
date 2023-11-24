--liquibase formatted sql

--changeset Andrii Mishchenko:6
CREATE TABLE users_quizzes
(
    id      BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    quiz_id BIGINT NOT NULL,
    score   INT    NOT NULL DEFAULT '0'
);

ALTER TABLE users_quizzes
    ADD CONSTRAINT pk_users_quizzes PRIMARY KEY (id);
ALTER TABLE users_quizzes
    ADD CONSTRAINT fk_users_quizzes_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE;
ALTER TABLE users_quizzes
    ADD CONSTRAINT fk_users_quizzes_quizzes FOREIGN KEY (quiz_id) REFERENCES quizzes (id) ON DELETE CASCADE;
ALTER TABLE users_quizzes
    ADD CONSTRAINT uq_users_quizzes_users_quizzes UNIQUE (user_id, quiz_id);