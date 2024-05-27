#!/usr/bin/env bash

KAFKA_CONNECT_HOST=${KAFKA_CONNECT_HOST:-localhost}
STREAM_ID=${1:?"Stream ID not given"}
YB_USER=${YB_USER:-yugabyte}
YB_PASSWORD=${YB_PASSWORD:-}
YB_DB=${YB_DB:-demo}
YB_HOST=${YB_HOST:-${NODE:-localhost}}
YB_PORT=${YB_PORT:-5433}

# Deploy connector 1
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "ybconnector1",
  "config": {
    "tasks.max":"2",
    "connector.class": "io.debezium.connector.yugabytedb.YugabyteDBConnector",
    "database.hostname":"'$NODE'",
    "database.master.addresses":"'$MASTERS'",
    "database.port":"'$YB_PORT'",
    "database.user": "'$YB_USER'",
    "database.password":"'$YB_PASSWORD'",
    "database.dbname":"'$YB_DB'",
    "database.server.name":"ybconnector1",
    "snapshot.mode":"initial",
    "database.streamid":"'$STREAM_ID'",
    "table.include.list":"public.orders[a-zA-Z0-9]*",
    "new.table.poll.interval.ms":"5000",
    "key.converter":"io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url":"http://schema-registry:8081",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url":"http://schema-registry:8081"
  }
}'

sleep 1;

# Deploy connector 2
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "ybconnector2",
  "config": {
    "tasks.max":"2",
    "connector.class": "io.debezium.connector.yugabytedb.YugabyteDBConnector",
    "database.hostname":"'$NODE'",
    "database.master.addresses":"'$MASTERS'",
    "database.port":"'$YB_PORT'",
    "database.user": "'$YB_USER'",
    "database.password":"'$YB_PASSWORD'",
    "database.dbname":"'$YB_DB'",
    "database.server.name":"ybconnector2",
    "snapshot.mode":"initial",
    "database.streamid":"'$STREAM_ID'",
    "table.include.list":"public.products",
    "key.converter":"io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url":"http://schema-registry:8081",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url":"http://schema-registry:8081"
  }
}'

sleep 1;

# Deploy connector 3
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "ybconnector3",
  "config": {
    "tasks.max":"2",
    "connector.class": "io.debezium.connector.yugabytedb.YugabyteDBConnector",
    "database.hostname":"'$NODE'",
    "database.master.addresses":"'$MASTERS'",
    "database.port":"'$YB_PORT'",
    "database.user": "'$YB_USER'",
    "database.password":"'$YB_PASSWORD'",
    "database.dbname":"'$YB_DB'",
    "database.server.name":"ybconnector3",
    "snapshot.mode":"initial",
    "database.streamid":"'$STREAM_ID'",
    "table.include.list":"public.users",
    "key.converter":"io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url":"http://schema-registry:8081",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url":"http://schema-registry:8081"
  }
}'

sleep 1;

# Deploy connector 4
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "ybconnector4",
  "config": {
    "tasks.max":"2",
    "connector.class": "io.debezium.connector.yugabytedb.YugabyteDBConnector",
    "database.hostname":"'$NODE'",
    "database.master.addresses":"'$MASTERS'",
    "database.port":"'$YB_PORT'",
    "database.user": "'$YB_USER'",
    "database.password":"'$YB_PASSWORD'",
    "database.dbname":"'$YB_DB'",
    "database.server.name":"ybconnector4",
    "snapshot.mode":"initial",
    "database.streamid":"'$STREAM_ID'",
    "table.include.list":"public.reviews",
    "key.converter":"io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url":"http://schema-registry:8081",
    "value.converter":"io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url":"http://schema-registry:8081"
  }
}'

sleep 1;
