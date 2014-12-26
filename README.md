hive_training
=============

1. hiveuserになる。
   $ su - hiveuser

2. homeディレクトリ直下にhive_trainingを配置する
   /home/hiveuser/hive_training

3. hive_trainingディレクトリに移動する
   $ cd /home/hiveuser/hive_training

4. sampledb_init.sqlを実行しサンプルデータを登録する。
   $ hive -f ./sampledb_init.sql
