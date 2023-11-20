CREATE TABLE SQLUser.users
(
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    email        VARCHAR(255) NOT NULL,
    login        VARCHAR(30)  NOT NULL,
    password     VARCHAR(255) NOT NULL,
    access_level VARCHAR(30)  NOT NULL DEFAULT 'user'
);

ALTER TABLE users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);
ALTER TABLE users
    ADD CONSTRAINT uq_users_email UNIQUE (email);
ALTER TABLE users
    ADD CONSTRAINT uq_users_login UNIQUE (login);

CREATE TABLE quizzes
(
    id         BIGINT      NOT NULL AUTO_INCREMENT,
    name       VARCHAR(30) NOT NULL,
    duration   INT         NOT NULL,
    difficulty VARCHAR(30) NOT NULL,
    subject    VARCHAR(30) NOT NULL
);

ALTER TABLE quizzes
    ADD CONSTRAINT pk_quizzes PRIMARY KEY (id);
ALTER TABLE quizzes
    ADD CONSTRAINT uq_quizzes_name UNIQUE (name);

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

CREATE TABLE answers
(
    id          BIGINT  NOT NULL AUTO_INCREMENT,
    value       CHAR(1) NOT NULL,
    question_id BIGINT  NOT NULL
);

ALTER TABLE answers
    ADD CONSTRAINT pk_answers PRIMARY KEY (id);
ALTER TABLE answers
    ADD CONSTRAINT fk_answers_questions FOREIGN KEY (question_id) REFERENCES questions (id);
ALTER TABLE answers
    ADD CONSTRAINT uq_answers_value_question_id UNIQUE (value, question_id);

CREATE TABLE variants
(
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    value       VARCHAR(255) NOT NULL,
    question_id BIGINT       NOT NULL
);

ALTER TABLE variants
    ADD CONSTRAINT pk_variants PRIMARY KEY (id);
ALTER TABLE variants
    ADD CONSTRAINT fk_variants_questions FOREIGN KEY (question_id) REFERENCES questions (id);
ALTER TABLE variants
    ADD CONSTRAINT uq_variants_value_question_id UNIQUE (value, question_id);

CREATE TABLE users_quizzes
(
    id      BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    quiz_id BIGINT NOT NULL,
    score   INT    NOT NULL DEFAULT '0'
);

ALTER TABlE users_quizzes
    ADD CONSTRAINT pk_users_quizzes PRIMARY KEY (id);
ALTER TABlE users_quizzes
    ADD CONSTRAINT fk_users_quizzes_users FOREIGN KEY (user_id) REFERENCES users (id);
ALTER TABlE users_quizzes
    ADD CONSTRAINT fk_users_quizzes_quizzes FOREIGN KEY (quiz_id) REFERENCES quizzes (id);
ALTER TABLE users_quizzes
    ADD CONSTRAINT uq_users_quizzes_users_quizzes UNIQUE (user_id, quiz_id);


INSERT INTO users (email, login, password, access_level)
VALUES ('gmowl@gmail.com', 'admin', 'admin', 'admin');