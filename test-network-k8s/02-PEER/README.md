## 部署Peer

### 部署服务

部署通用变量

```
k apply -f peer-base-env-cm.yaml
```

部署org1
```
cd org1
k apply -f .
```

部署org2
```
cd org2
k apply -f .
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

