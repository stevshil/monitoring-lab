CREATE DATABASE moodle;
CREATE USER 'moodle'@'%' IDENTIFIED BY 'moodle123';
CREATE USER 'moodle'@'localhost' IDENTIFIED BY 'moddle123';
-- GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'dbmon';
GRANT ALL PRIVILEGES ON *.* TO 'moodle'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'moodle'@'localhost';
flush privileges;
-- GRANT SELECT ON performance_schema.* TO 'exporter'@'dbmon';
-- Set moodle attributes
SET GLOBAL innodb_compression_default=ON;
SET GLOBAL innodb_file_per_table=ON;
SET GLOBAL innodb_file_format='Barracuda';
SET GLOBAL innodb_default_row_format='dynamic';
SET SESSION  innodb_compression_default=ON;
