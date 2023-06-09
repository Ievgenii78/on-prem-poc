https://docs.starburst.io/latest/k8s/requirements.html#k8s-helm-repository
https://docs.starburst.io/starburst-enterprise/k8s/index.html

# Create a secret with the license
kubectl create secret generic mylicense --from-file=starburstdata.license -n starburst

# Add the Helm repo
helm repo add -n starburst \
  --username cust-sphera \
  --password e13o11q1mSeEq1Om \
  --pass-credentials \
  starburstdata \
  https://harbor.starburstdata.net/chartrepo/starburstdata

helm repo update -n starburst
helm search repo


helm upgrade my-sep-test-cluster starburstdata/starburst-enterprise -n starburst \
    --install \
    --version 413.0.0 \
    --values ./registry-access.yaml \
    --values ./sep-test-setup.yaml \
    --values ./sep-test-catalogs.yaml

# Hive metastore:
helm upgrade hive-metastore starburstdata/starburst-hive -n trino \
  --install \
  --version 410.0.0 \
  --values ./registry-access.yaml \
  --values ./hive-metastore-values.yaml

# Trino:
helm repo add trino https://trinodb.github.io/charts -n trino

helm install example-trino-cluster trino/trino -n trino \
  --values ./trino-values.yaml

# local Helm for Trino
helm install example-trino-cluster ../trinodb/charts/trino -f ./trino-values.yaml -n trino




show catalogs;