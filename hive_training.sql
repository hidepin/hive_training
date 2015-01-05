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
PARTITIONED BY (country STRING, state STRING)
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
