CREATE DATABASE IF NOT EXISTS ycit021;

CREATE USER IF NOT EXISTS 'dev'@'%' IDENTIFIED WITH mysql_native_password BY '';
GRANT ALL PRIVILEGES ON *.* TO 'dev'@'%';