## Order


### 准备工作

工作路径为当前README所在路径(hyperledger-workshop/test-network-k8s/01-ORDERER), 运行下面的代码设置环境变量和命令行缩写

```
source ../envVars.sh
```

默认会设置命令k='kubectl -n testnet '，以确保资源会创建在同一个namespaces.
> 可以通过向‘../.env’文件添加NS变量以覆盖默认的namespace.

### 上传资源

**创世块**

```
cd channel-artifacts
% k create secret generic channel-artifacts --from-file=genesis.block
secret/channel-artifacts created
% k describe secrets channel-artifacts
Name:         channel-artifacts
Namespace:    testnet
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
genesis.block:  17517 bytes
```

**MSP**

```
POD=$(k get pods -l app=orderer -o=jsonpath='{.items[0].metadata.name}')
echo POD

k cp crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp $NS/$POD:/var/hyperledger/orderer/msp
k cp crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ $NS/$POD:/var/hyperledger/orderer/tls
```

