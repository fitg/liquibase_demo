DROP USER IF EXISTS 'liquibase_qa'; 
CREATE USER 'liquibase_qa'@'%' IDENTIFIED BY 'liquibase_qa';

CREATE DATABASE IF NOT EXISTS liquibase_qa;
USE liquibase_qa;

CREATE TABLE IF NOT EXISTS users (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Authors VARCHAR (255)
);

INSERT INTO users VALUES (1, 'user1');
INSERT INTO users VALUES (2, 'user2');

GRANT ALL ON liquibase_qa.* TO 'liquibase_qa';