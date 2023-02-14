# oracle to mysql demo

## Getting started

```bash
# require logging into oracle.com
docker pull container-registry.oracle.com/database/enterprise:19.3.0.0
kind load docker-image container-registry.oracle.com/database/enterprise:19.3.0.0
helm install ora2my deploy/setup2_ora2my
```
