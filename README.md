# HSA21
Set up MySQL Cluster

This examples contains 3 MySQL servers (`mysql-m`, `mysql-s1`, `mysql-s2`) with master-slave replication relations
(Master: `mysql-m`, Slave: `mysql-s1`, `mysql-s2`)

### Init

To init eache database - run `init.sql` in the order `mysq-m`, `mysql-s1`, `mysql-s2`

### Replication checks

Run `generate_data.sql` on `mysql-m` to create a table and fill it with random data

Replication in logs:
```
2024-03-01T11:48:40.608218Z 5 [System] [MY-014001] [Repl] Replica receiver thread for channel '': connected to source 'slave@mysql-m:3306' with server_uuid=6005e2a4-d7bf-11ee-85f9-0242ac180002, server_id=1. Starting replication from file 'mysql-bin.000003', position '874'.
```

### Stop replication

After calling `STOP SLAVE;` on `mysql-s1` it will stop syncing with `mysql-m` while `mysql-s2` will continue

### Modify slave database

1. Try to modify the slave 2 `user` by removing the last column of the table: 

```
ALTER TABLE `user` DROP COLUMN `col_3`;
```

On master:

```
SELECT * FROM `user` LIMIT 1;
+------+------------+---------------+-------+-------+-------+
| id   | given_name | date_of_birth | col_1 | col_2 | col_3 |
+------+------------+---------------+-------+-------+-------+
|    1 | 36014916   | 1946-02-28    | col_1 | col_2 | col_3 |
+------+------------+---------------+-------+-------+-------+
```

On slave 2:

```
 SELECT * FROM `user` LIMIT 1;
+----+------------+---------------+-------+-------+
| id | given_name | date_of_birth | col_1 | col_2 |
+----+------------+---------------+-------+-------+
|  1 | 36014916   | 1946-02-28    | col_1 | col_2 |
+----+------------+---------------+-------+-------+

SELECT count(id) from `user`;
+-----------+
| count(id) |
+-----------+
|      1503 |
+-----------+
```

After such modification both database still show the same amout of records.


2.  Try to modify the slave 2 `user` by removing the column `col_1` in the of the table: 

```
ALTER TABLE `user` DROP COLUMN `col_1`;
```

On master:

```
mysql> SELECT * FROM `user` LIMIT 1;
+----+------------+---------------+-------+-------+-------+
| id | given_name | date_of_birth | col_1 | col_2 | col_3 |
+----+------------+---------------+-------+-------+-------+
|  1 | 36014916   | 1946-02-28    | col_1 | col_2 | col_3 |
+----+------------+---------------+-------+-------+-------+
1 row in set (0.00 sec)

mysql> SELECT count(id) FROM `user`;
+-----------+
| count(id) |
+-----------+
|      2004 |
+-----------+
1 row in set (0.00 sec)
```

On slave 2:
```
mysql> SELECT * FROM `user` LIMIT 1;
+----+------------+---------------+-------+
| id | given_name | date_of_birth | col_2 |
+----+------------+---------------+-------+
|  1 | 36014916   | 1946-02-28    | col_2 |
+----+------------+---------------+-------+
1 row in set (0.01 sec)

mysql> SELECT count(id) from `user`;
+-----------+
| count(id) |
+-----------+
|      2004 |
+-----------+
1 row in set (0.00 sec)
```

After modification in the middle - both instances stay in sync

On slave 1:

```
mysql> SELECT count(id) FROM `user`;
+-----------+
| count(id) |
+-----------+
|       501 |
+-----------+
1 row in set (0.00 sec)
```

Slave 1 is not synced as replocation is disabled
