DROP USER IF EXISTS 'liquibase_dev'; 
CREATE USER 'liquibase_dev'@'%' IDENTIFIED BY 'liquibase_dev';

CREATE DATABASE IF NOT EXISTS liquibase_dev;
USE liquibase_dev;

CREATE TABLE IF NOT EXISTS users (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Authors VARCHAR (255)
);

INSERT INTO users VALUES (1,'user1');
INSERT INTO users VALUES (2,'user2');

GRANT ALL ON liquibase_dev.* TO 'liquibase_dev';

