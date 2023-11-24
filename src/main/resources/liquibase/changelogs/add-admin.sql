--liquibase formatted sql

--changeset Andrii Mishchenko:7
INSERT INTO users (email, login, password, access_level)
VALUES ('gmowl@gmail.com', 'admin', 'ISMvKXpXpadDiUoOSoAfww==', 'admin');
