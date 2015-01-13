set hive.exec.dynamic.partition.mode=nonstrict;

DROP DATABASE IF EXISTS financials CASCADE;

CREATE DATABASE IF NOT EXISTS financials COMMENT 'Holds all financial tables';

use financials;

CREATE TABLE IF NOT EXISTS employees (
  name STRING COMMENT 'Employee name',
  salary FLOAT COMMENT 'Employee salary',
  subordinates ARRAY<STRING> COMMENT 'Names of subordinates',
  deductions MAP<STRING, FLOAT>
             COMMENT 'Keys are deductions names, values are percentages',
  address STRUCT<street:STRING, city:STRING, state:STRING, zip:INT>
  COMMENT 'Home address'
  )
COMMENT 'Description of the table'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '#'
MAP KEYS TERMINATED BY ':'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/hidepin/employee'
;

CREATE INDEX employees_index
ON TABLE employees (name)
AS 'org.apache.hadoop.hive.ql.index.compact.CompactIndexHandler'
WITH DEFERRED REBUILD
;

CREATE EXTERNAL TABLE IF NOT EXISTS stocks (
  code STRING,
  exchanges STRING,
  symbol STRING,
  ymd STRING,
  price_open FLOAT,
  price_high FLOAT,
  price_low FLOAT,
  price_close FLOAT,
  volume INT,
  price_adj_close FLOAT
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/hidepin/data'
;

CREATE EXTERNAL TABLE IF NOT EXISTS staged_user (
  name STRING,
  phonetic STRING,
  mail STRING,
  gender STRING,
  age INT,
  birthday STRING,
  marriage STRING,
  blood_type STRING,
  prefectures STRING,
  prefectures_code INT,
  tel_number STRING,
  mobile_tel_number STRING,
  carrier STRING,
  eatting STRING
  )
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/hidepin/user'
;


CREATE TABLE IF NOT EXISTS user (
  name STRING,
  phonetic STRING,
  mail STRING,
  gender STRING,
  age INT,
  birthday STRING,
  marriage STRING,
  blood_type STRING,
  prefectures STRING,
  prefectures_code INT,
  tel_number STRING,
  mobile_tel_number STRING,
  carrier STRING,
  eatting STRING
  )
PARTITIONED BY (p_code INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
;

--INSERT OVERWRITE TABLE user
--PARTITION (p_code)
--SELECT name, phonetic, mail, gender, age, birthday, marriage, blood_type, prefectures, prefectures_code, tel_number, mobile_tel_number, carrier, eatting, prefectures_code FROM staged_user; 

INSERT OVERWRITE TABLE user
PARTITION (p_code)
SELECT *, prefectures_code FROM staged_user; 

CREATE VIEW user_view AS
  SELECT name, mail, age, birthday, prefectures, prefectures_code FROM user WHERE prefectures = '広島';

CREATE EXTERNAL TABLE dynamictable(cols map<string,string>)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY ',' 
  COLLECTION ITEMS TERMINATED BY '#'
  MAP KEYS TERMINATED BY ':'
STORED AS TEXTFILE
LOCATION '/user/hidepin/dynamic'
;

CREATE VIEW orders(state, city, part) AS
  SELECT cols["state"], cols["city"], cols["part"]
  FROM dynamictable
  WHERE cols["type"] = "request"
;

CREATE VIEW shipments(time, part) AS
  SELECT cols["time"], cols["part"]
  FROM dynamictable
  WHERE cols["type"] = "response"
;
