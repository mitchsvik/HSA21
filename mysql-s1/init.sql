use hsa21;
CHANGE MASTER TO MASTER_HOST='mysql-m', MASTER_USER='slave', MASTER_PASSWORD='password',
MASTER_LOG_FILE = 'mysql-bin.000003', MASTER_LOG_POS = 874;