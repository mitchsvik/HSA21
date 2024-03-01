use hsa21;
CHANGE MASTER TO MASTER_HOST='mysql-m', MASTER_USER='slave', MASTER_PASSWORD='password',
MASTER_LOG_FILE = 'mysql-bin.000003', MASTER_LOG_POS = 874;
START SLAVE;
-- After 2 inserts of data
SHOW TABLES;
SELECT * FROM `user`;
-- Drop columns and check
ALTER TABLE `user` DROP COLUMN `col_3`;
SELECT * FROM `user` LIMIT 10;