CREATE TABLE IF NOT EXISTS users
(
    id           BIGINT       NOT NULL AUTO_INCREMENT,
    email        VARCHAR(255) NOT NULL,
    login        VARCHAR(30)  NOT NULL,
    password     VARCHAR(255) NOT NULL,
    access_level VARCHAR(30)  NOT NULL DEFAULT 'user',

    CONSTRAINT pk_users PRIMARY KEY (id),
    CONSTRAINT uq_users_email UNIQUE (email),
    CONSTRAINT uq_users_login UNIQUE (login)
);

CREATE TABLE IF NOT EXISTS quizzes
(
    id         BIGINT      NOT NULL AUTO_INCREMENT,
    name       VARCHAR(30) NOT NULL,
    duration   INT         NOT NULL,
    difficulty VARCHAR(30) NOT NULL,
    subject    VARCHAR(30) NOT NULL,
    status     VARCHAR(30) NOT NULL DEFAULT 'NOT_PUBLISHED',

    CONSTRAINT pk_quizzes PRIMARY KEY (id),
    CONSTRAINT uq_quizzes_name UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS questions
(
    id      BIGINT       NOT NULL AUTO_INCREMENT,
    prompt  VARCHAR(200) NOT NULL,
    quiz_id BIGINT       NOT NULL,

    CONSTRAINT pk_questions PRIMARY KEY (id),
    CONSTRAINT fk_questions_quizzes FOREIGN KEY (quiz_id) REFERENCES quizzes (id)
);

CREATE TABLE IF NOT EXISTS answers
(
    id          BIGINT  NOT NULL AUTO_INCREMENT,
    value       CHAR(1) NOT NULL,
    question_id BIGINT  NOT NULL,

    CONSTRAINT pk_answers PRIMARY KEY (id),
    CONSTRAINT fk_answers_questions FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE,
    CONSTRAINT uq_answers_value_question_id UNIQUE (value, question_id)
);

CREATE TABLE IF NOT EXISTS variants
(
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    value       VARCHAR(255) NOT NULL,
    question_id BIGINT       NOT NULL,

    CONSTRAINT pk_variants PRIMARY KEY (id),
    CONSTRAINT fk_variants_questions FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE,
    CONSTRAINT uq_variants_value_question_id UNIQUE (value, question_id)
);

CREATE TABLE IF NOT EXISTS users_quizzes
(
    id      BIGINT NOT NULL AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    quiz_id BIGINT NOT NULL,
    score   INT    NOT NULL DEFAULT '0',

    CONSTRAINT pk_users_quizzes PRIMARY KEY (id),
    CONSTRAINT fk_users_quizzes_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
    CONSTRAINT fk_users_quizzes_quizzes FOREIGN KEY (quiz_id) REFERENCES quizzes (id) ON DELETE CASCADE,
    CONSTRAINT uq_users_quizzes_users_quizzes UNIQUE (user_id, quiz_id)
);