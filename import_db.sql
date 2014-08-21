CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(100) NOT NULL,
  lname VARCHAR(100) NOT NULL
);

CREATE TABLE questions  (
  id INTEGER PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  body VARCHAR(200) NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id), 
  FOREIGN KEY (question_id) REFERENCES questions(id) 
  
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(200) NOT NULL
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id), 
  FOREIGN KEY (question_id) REFERENCES questions(id) 
);

INSERT INTO
  users (id, fname, lname)
VALUES
  (1,'Jack', 'Einstein'), (2, 'Andy', 'Godel'), (3, 'John', 'Ramsey'), (4, 'Lily', 'Davis');
  
INSERT INTO
  questions (id, title, body, author_id)
VALUES
  (1, 'What is the question for final', 'Give me the answers', 3),
  (2, 'where is my classroom', 'Give me the room num', 2),
  (3, 'how to get a A', 'Do I need to study?', 1);
  
INSERT INTO
  question_followers(id, user_id, question_id)
VALUES
  (1, 1, 2), (2, 1, 3), (3, 2, 3);
  
INSERT INTO
  replies(id, question_id, parent_id, user_id, body)
VALUES
  (1, 1, NULL, 1, "OK"),(2, 2, NULL, 3, "ROOM502"),(3, 2, 2, 3, "Bullshit");
  
  
INSERT INTO
question_likes(id, user_id, question_id)
VALUES
(1, 1, 1), (2, 3, 2), (3, 2, 3), (4, 2, 1);
  


  