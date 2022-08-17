PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
    id INTEGER PRIMARY KEY,
    follower_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (follower_id) REFERENCES users(id)
);

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,
    body TEXT NOT NULL,
    parent_reply_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (author_id) REFERENCES users(id)
);

INSERT INTO
    users (fname, lname)
VALUES
    ('Dan', 'Lay'),
    ('Ian', 'Verger');

INSERT INTO
    questions (title, body, author_id)
VALUES
    ('What even is SQL?', 'I have no idea what SQL is, can somebody help me?!!', 1),
    ('What is a query?', 'Truly don''t understand what this is?', 2);

INSERT INTO
    question_follows (follower_id, question_id)
VALUES
    (2, 1),
    (1, 2);

INSERT INTO
    replies (question_id, author_id, body, parent_reply_id)
VALUES
    (1, 2, 'SQL is a Standard Query Language!!', 1),
    (2, 1, 'Query this!', 2);

INSERT INTO
    question_likes (question_id, author_id)
VALUES
    (1, 1),
    (2, 2);