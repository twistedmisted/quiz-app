--liquibase formatted sql

--changeset Andrii Mishchenko:2
CREATE TABLE quizzes
(
    id         BIGINT      NOT NULL AUTO_INCREMENT,
    name       VARCHAR(30) NOT NULL,
    duration   INT         NOT NULL,
    difficulty VARCHAR(30) NOT NULL,
    subject    VARCHAR(30) NOT NULL,
    status     VARCHAR(30) NOT NULL DEFAULT 'NOT_PUBLISHED'
);

ALTER TABLE quizzes
    ADD CONSTRAINT pk_quizzes PRIMARY KEY (id);
ALTER TABLE quizzes
    ADD CONSTRAINT uq_quizzes_name UNIQUE (name);