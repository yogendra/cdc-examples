#!/usr/bin/env bash
KAFKA_CONNECT_HOST=${KAFKA_CONNECT_HOST:-localhost}
SCHEMA_REGISTRY_HOST_NAME=${SCHEMA_REGISTRY_HOST_NAME:-localhost}
PG_HOST=${PG_HOST:-localhost}
PG_USER=${PG_USER:-postgres}
PG_PASSWORD=${PG_PASSWORD:-postgres}
PG_DB=${PG_DB:-postgres}

PG_CONNECTION_URL="jdbc:postgresql://$PG_HOST:5432/$PG_DB?user=$PG_USER&password=$PG_PASSWORD&sslMode=require"
SCHEMA_REGISTRY_URL="http://$SCHEMA_REGISTRY_HOST_NAME:8081",

echo "Deploy PG sink connector: orders"
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "jdbc-sink-1",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
     "tasks.max": "1",
      "topics": "ybconnector1.public.orders",
      "dialect.name": "PostgreSqlDatabaseDialect",
      "table.name.format": "orders",
      "connection.url": "'$PG_CONNECTION_URL'",
      "auto.create": "true",
      "auto.evolve":"true",
      "insert.mode": "upsert",
      "pk.fields": "id",
      "pk.mode": "record_key",
      "delete.enabled":"true",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.connector.yugabytedb.transforms.YBExtractNewRecordState",
      "transforms.unwrap.drop.tombstones": "false",
      "key.converter":"io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'",
      "value.converter":"io.confluent.connect.avro.AvroConverter",
      "value.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'"
   }
}'

sleep 5;
echo "Deploy PG sink connector: products"
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "jdbc-sink-2",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
     "tasks.max": "1",
      "topics": "ybconnector2.public.products",
      "dialect.name": "PostgreSqlDatabaseDialect",
      "table.name.format": "products",
      "connection.url": "'$PG_CONNECTION_URL'",
      "auto.create": "true",
      "auto.evolve":"true",
      "insert.mode": "upsert",
      "pk.fields": "id",
      "pk.mode": "record_key",
      "delete.enabled":"true",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.connector.yugabytedb.transforms.YBExtractNewRecordState",
      "transforms.unwrap.drop.tombstones": "false",
      "key.converter":"io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'",
      "value.converter":"io.confluent.connect.avro.AvroConverter",
      "value.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'"
   }
}'

sleep 5;
echo "Deploy PG sink connector: users"
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "jdbc-sink-3",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
     "tasks.max": "1",
      "topics": "ybconnector3.public.users",
      "dialect.name": "PostgreSqlDatabaseDialect",
      "table.name.format": "users",
      "connection.url": "'$PG_CONNECTION_URL'",
      "auto.create": "true",
      "auto.evolve":"true",
      "insert.mode": "upsert",
      "pk.fields": "id",
      "pk.mode": "record_key",
      "delete.enabled":"true",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.connector.yugabytedb.transforms.YBExtractNewRecordState",
      "transforms.unwrap.drop.tombstones": "false",
      "key.converter":"io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'",
      "value.converter":"io.confluent.connect.avro.AvroConverter",
      "value.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'"
   }
}'

sleep 5;
echo "Deploy PG sink connector: reviews"
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" $KAFKA_CONNECT_HOST:8083/connectors/ -d '{
  "name": "jdbc-sink-4",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
     "tasks.max": "1",
      "topics": "ybconnector4.public.reviews",
      "dialect.name": "PostgreSqlDatabaseDialect",
      "table.name.format": "reviews",
      "connection.url": "'$PG_CONNECTION_URL'",
      "auto.create": "true",
      "auto.evolve":"true",
      "insert.mode": "upsert",
      "pk.fields": "id",
      "pk.mode": "record_key",
      "delete.enabled":"true",
      "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.connector.yugabytedb.transforms.YBExtractNewRecordState",
      "transforms.unwrap.drop.tombstones": "false",
      "key.converter":"io.confluent.connect.avro.AvroConverter",
      "key.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'",
      "value.converter":"io.confluent.connect.avro.AvroConverter",
      "value.converter.schema.registry.url":"'$SCHEMA_REGISTRY_URL'"
   }
}'
