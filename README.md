# dbrs

## Pre-requisites

1. [docker desktop](https://www.docker.com/products/docker-desktop/)
2. [kind](https://kind.sigs.k8s.io/), a k8s cluster inside docker.
3. [kubefwd](https://github.com/txn2/kubefwd), a CLI for batch `kubectl port-forward`.
4. [insomnia](https://github.com/Kong/insomnia), a API client for operating dbrs.

## Getting started

First, run up dbrs:

```bash
> cd dbrs

# build container
> cd container-images
> docker-compose build
> kind load container-image debezium-connect:2.2-1
> kind load container-image hammerdb:4.6
> cd ..

# run dbrs
> kind create namespace dbrs
> kind config set-context --current --namespace=dbrs
> cd dbrs
> helm dependency build
> helm install dbrs .
# wait for pods to be "running"
> kubectl get pods -w

# kubefwd all services to local
> kubefwd svc -n dbrs
```

Once everything is up and running, try to see if API works:

1. Launch insomnia client
2. Import `apis/dbrs.yaml`
3. Run `DBRS/cluster/List connector-plugins`.

## Demo Scenario

dbrs has 3 sets of mysql: `mysql-src` => `mysql-dwh` => `mysql-dst`

1. Run hammerdb to create baseline for 3 databases (details TBD)
2. In insomnia, run `DBRS/connectors/Create src-src-topic`
3. Then, run `DBRS/connectors/Create sink-tpcc.stock-dwh`
4. `kubectl logs -f deployments/dbrs-cp-kafka-connect` to verify no errors for both connectors.
5. Use hammerdb to generate data to `mysql-src` (details TBD), observe that the same sets of data are replicated to `mysql-dst`


## Future tasks

1. Define the tasks to "start" over on either pipeline.
2. Add oracledb to src-dhw-dst combinations.
