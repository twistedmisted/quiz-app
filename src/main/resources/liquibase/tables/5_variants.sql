--liquibase formatted sql

--changeset Andrii Mishchenko:5
CREATE TABLE variants
(
    id          BIGINT       NOT NULL AUTO_INCREMENT,
    value       VARCHAR(255) NOT NULL,
    question_id BIGINT       NOT NULL
);

ALTER TABLE variants
    ADD CONSTRAINT pk_variants PRIMARY KEY (id);
ALTER TABLE variants
    ADD CONSTRAINT fk_variants_questions FOREIGN KEY (question_id) REFERENCES questions (id) ON DELETE CASCADE;
ALTER TABLE variants
    ADD CONSTRAINT uq_variants_value_question_id UNIQUE (value, question_id);