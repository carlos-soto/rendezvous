CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Pa$$4admin';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;