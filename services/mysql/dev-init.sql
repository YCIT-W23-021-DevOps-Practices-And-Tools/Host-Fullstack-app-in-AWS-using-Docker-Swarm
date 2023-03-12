CREATE DATABASE IF NOT EXISTS ycit021;

CREATE USER IF NOT EXISTS 'dev'@'%' IDENTIFIED WITH mysql_native_password BY '';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'%';

USE ycit021;

CREATE TABLE if not exists users(
    id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    cell_phone VARCHAR(15),
    age INT DEFAULT NULL,
    PRIMARY KEY (id)
);
