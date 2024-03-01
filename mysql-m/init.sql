use hsa21;
CREATE USER 'slave'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;

-- After insert 3 times
SELECT * FROM `user` LIMIT 10;