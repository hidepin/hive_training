CREATE DATABASE SALES_SAMPLE COMMENT 'サンプルデータ格納DB';

use SALES_SAMPLE;

CREATE TABLE SALES
(
  SALES_ID INT COMMENT '注文番号',
  SHOP_CODE STRING COMMENT '店舗コード',
  SALES_DATE STRING COMMENT '売上日'
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
;

CREATE TABLE SALES_DETAIL
(
  SALES_ID INT COMMENT '注文番号',
  DETAIL_ID INT COMMENT '明細番号',
  ITEM_CODE STRING COMMENT '商品コード',
  UNIT_PRICE INT COMMENT '単価',
  QUANTITY INT COMMENT '個数'
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
;

CREATE TABLE ITEM_MASTER
(
  ITEM_CODE STRING COMMENT '商品コード',
  ITEM_NAME STRING COMMENT '商品名',
  UNIT_PRICE INT COMMENT '単価'
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
;

CREATE TABLE SHOP_MASTER
(
  SHOP_CODE STRING COMMENT '店舗コード',
  REGION STRING COMMENT '地域'
)
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
  LINES TERMINATED BY '\n'
;

LOAD DATA LOCAL INPATH '~/hive_training/sales_sample/sales.tsv' INTO TABLE SALES;
LOAD DATA LOCAL INPATH '~/hive_training/sales_sample/sales_detail.tsv' INTO TABLE SALES_DETAIL;
LOAD DATA LOCAL INPATH '~/hive_training/sales_sample/itemlist.tsv' INTO TABLE ITEM_MASTER;
LOAD DATA LOCAL INPATH '~/hive_training/sales_sample/shoplist.tsv' INTO TABLE SHOP_MASTER;
