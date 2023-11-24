--liquibase formatted sql

--changeset Andrii Mishchenko:1
CREATE TABLE users
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