# Install SEP
helm upgrade sep-test-cluster starburstdata/starburst-enterprise -n starburst \
    --install \
    --values ./sbe-01-registry.yaml \
    --values ./sbe-02-setup.yaml \
    --values ./sbe-03-catalog.yaml \
	--version 413.0.0

# Install Hive
helm upgrade hive-metastore starburstdata/starburst-hive -n starburst \
  --install \
  --version 413.0.0 \
  --values ./sbe-01-registry.yaml \
  --values ./sbe-hive.yaml

# Checking from the Jumphost
1. ./trino --server http://10.136.86.92:8080 --user starburst_service
2. set role sysadmin;

3. show catalogs;
4. show tables from query_logger."sqdb-trino-eus-sccspoc-dev";  # check connection with a Database
5. 
  #to check status of register: 
    call delta.system.register_table('default', 'customers','abfs://miniobuckerwarehouse@miniobucketsphera.dfs.core.windows.net/delta/inventory');
  #to enable registration of tables manually:
    set session delta.legacy_create_table_with_existing_location_enabled=true;
6.
#create table:
  delta.default.customers(dummy bigint) with(location='abfs://miniobuckerwarehouse@miniobucketsphera.dfs.core.windows.net/delta/inventory/customer');

7. use delta.default;
8. select * from customers limit 10;

9. to delete: drop table delta.default.customers;
