## 部署Peer

### 部署服务

部署通用变量

```
k apply -f ../template/testnet-peer-common-env-configmap.yaml
```

部署org1
```
k apply -f ../template/testnet-org1-*.yaml
```

部署org2
```
k apply -f ../template/testnet-org2-*.yaml
```

### 同步MSP


使用同步脚本
```
./sync.sh 
Usage:
  ./sync.sh <org> <peer>
Example:
  ./sync.sh org1 peer1
```

```
./sync.sh org1 peer0
./sync.sh org1 peer1
./sync.sh org2 peer0
./sync.sh org2 peer1
```

