--liquibase formatted sql

--changeset Andrii Mishchenko:4
CREATE TABLE answers
(
    id          BIGINT  NOT NULL AUTO_INCREMENT,
    value       CHAR(1) NOT NULL,
    question_id BIGINT  NOT NULL
);

ALTER TABLE answers
    ADD CONSTRAINT pk_answers PRIMARY KEY (id);
ALTER TABLE answers
    ADD CONSTRAINT fk_answers_questions FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE;
ALTER TABLE answers
    ADD CONSTRAINT uq_answers_value_question_id UNIQUE (value, question_id);
