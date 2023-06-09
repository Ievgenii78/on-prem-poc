https://trinodb.github.io/charts/charts/trino/
https://github.com/trinodb/charts
# local Helm for Trino
helm install example-trino-cluster ./charts/trino -f ./trino-values.yaml -n trino


kubectl exec -it example-trino-cluster-coordinator-9fcbbbb45-69znw -n trino -- trino
show catalogs;
show schemas in delta_lake;
show tables in delta_lake.default;