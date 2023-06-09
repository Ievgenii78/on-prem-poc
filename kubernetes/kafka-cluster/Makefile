# Deploy:
# kafka-zookepeer
# Change KAFKA_CFG_ZOOKEEPER_CONNECT according to your DNS name
kubectl apply -f services.yml -n kafka
kubectl create -f zookeeper-kafka-cluster.yml -n kafka

# Install Kafka With helm:
helm install my-release oci://registry-1.docker.io/bitnamicharts/kafka -n kafka \
-f ./values.yaml

# Uninstall:
helm uninstall my-release -n kafka

# kafka connect:
https://strimzi.io/blog/2020/01/27/deploying-debezium-with-kafkaconnector-resource/
https://docs.confluent.io/kafka-connectors/debezium-mysql-source/current/mysql_source_connector_config.html
# To use config.providers: file we need to follow the first link. By default we can use the secret but we need to gran access for the custom role, see:
https://debezium.io/documentation/reference/stable/operations/kubernetes.html
Add the secret:
cat <<EOF > debezium-mysql-credentials.properties
mysql_username: sccrpocmysql
mysql_password: D4_RR_DQUoE1ir
EOF
kubectl -n kafka create secret generic my-sql-credentials \
  --from-file=debezium-mysql-credentials.properties
rm debezium-mysql-credentials.properties

# For the new AKS install strimzi operator before:
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.20.0/install.sh | bash -s v0.20.0
kubectl create -f https://operatorhub.io/install/strimzi-kafka-operator.yaml
# Create the connector:
kubectl create -f kafka-connect.yml -n kafka
kubectl create -f kafka-connect-mysql.yml -n kafka

kubectl delete -f kafka-connect.yml -n kafka
kubectl delete -f kafka-connect-mysql.yml -n kafka

# To check staus of the connector
kubectl -n kafka get kctr debezium-connector-mysql -o yaml

# To start working with kafka sh files we have to find location of them:
kubectl -n kafka exec crs-kafka-0 -c kafka -i -t -- find -iname "kafka-console-consumer.sh"
output: ./opt/bitnami/kafka/bin/kafka-console-consumer.sh

# Check list of topics:
kubectl -n kafka exec my-release-kafka-0 -c kafka -i -t -- opt/bitnami/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list
# From remote:
bin/kafka-topics.sh --bootstrap-server 20.124.164.137:9094 --list

# Check topic:
kubectl -n kafka exec my-release-kafka-0 -c kafka -i -t -- opt/bitnami/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic dbserver1 --from-beginning