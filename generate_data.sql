-- Switch to designed database
USE hsa21;

-- Create table for users
CREATE TABLE `user` 
(
    `id` bigint(20) NOT NULL AUTO_INCREMENT,
    `given_name` CHAR(8) NOT NULL,
    `date_of_birth` DATE NULL,
    `col_1` CHAR(8) NULL DEFAULT 'col_1',
    `col_2` CHAR(8) NULL DEFAULT 'col_2',
    `col_3` CHAR(8) NULL DEFAULT 'col_3',

    PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- Insert 500 random users in the database
INSERT INTO `user` (`given_name`, `date_of_birth`)
SELECT 
    `gen`.`given_name` as `given_name`,
    `gen`.`date_of_birth` as `date_of_birth`
FROM (
    WITH RECURSIVE sequence (n) AS
    (
    SELECT 0
    UNION ALL
    SELECT n + 1 FROM sequence WHERE n + 1 <= 500
    )
    SELECT 
        SUBSTRING(MD5(RAND()), 1, 8) AS `given_name`,
        (CURRENT_DATE - INTERVAL FLOOR(RAND() * 100 * 365) DAY) AS `date_of_birth`
    FROM sequence
) `gen`;

-- Create indexes on data
CREATE INDEX `date_of_birth` ON `user` (`date_of_birth`) USING HASH;
