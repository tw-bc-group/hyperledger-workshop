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
$ cd ../../first-network/channel-artifacts
$ k create secret generic channel-artifacts --from-file=genesis.block
secret/channel-artifacts created
$ k describe secrets channel-artifacts
Name:         channel-artifacts
Namespace:    testnet
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
genesis.block:  17517 bytes
```

### 启动Order


```
$ k apply -f ../template/testnet-order.yaml
$ k get po -l app=orderer -w
NAME                       READY   STATUS    RESTARTS   AGE
orderer-7d8f964dfd-bffpl   0/1     Pending       0          0s
orderer-7d8f964dfd-bffpl   0/1     Pending       0          0s
orderer-7d8f964dfd-bffpl   0/1     ContainerCreating   0          0s
orderer-7d8f964dfd-bffpl   0/1     ContainerCreating   0          1s
orderer-7d8f964dfd-bffpl   1/1     Running             0          1s
```


### 同步MSP

打开一个窗口监控orderer日志
```
k logs -f --tail=20 deploy/orderer
```

通过`sync.sh`，同步first-network中创建的msp到orderer
```
$ ./sync.sh
++ kubectl -n testnet get pods -l app=orderer '-o=jsonpath={.items[0].metadata.name}'
+ POD=orderer-7d8f964dfd-bffpl
+ + set +x
+ Sync crypto config to orderer-7d8f964dfd-bffpl
+ + kubectl -n testnet cp ../../first-network/crypto-config/ordererOrganizations/testnet.svc.cluster.local/orderers/orderer.testnet.svc.cluster.local/msp testnet/orderer-7d8f964dfd-bffpl:/var/hyperledger/orderer/
+ + kubectl -n testnet exec orderer-7d8f964dfd-bffpl -- ls -l /var/hyperledger/orderer/msp
+ total 28
+ drwxr-xr-x 2  501 staff 4096 Sep  2 14:48 admincerts
+ drwxr-xr-x 2 root root  4096 Sep  3 07:08 cacerts
+ -rw-r--r-- 1  501 staff  524 Sep  2 14:48 config.yaml
+ drwxr-xr-x 2 root root  4096 Sep  3 07:08 keystore
+ drwxr-xr-x 7 root root  4096 Sep  2 15:11 msp
+ drwxr-xr-x 2 root root  4096 Sep  3 07:08 signcerts
+ drwxr-xr-x 2 root root  4096 Sep  3 07:08 tlscacerts
+ + kubectl -n testnet cp ../../first-network/crypto-config/ordererOrganizations/testnet.svc.cluster.local/orderers/orderer.testnet.svc.cluster.local/tls testnet/orderer-7d8f964dfd-bffpl:/var/hyperledger/orderer/
+ + kubectl -n testnet exec orderer-7d8f964dfd-bffpl -- ls -l /var/hyperledger/orderer/tls
+ total 12
+ -rw-r--r-- 1 501 staff 924 Sep  2 14:48 ca.crt
+ -rw-r--r-- 1 501 staff 952 Sep  2 14:48 server.crt
+ -rw------- 1 501 staff 241 Sep  2 14:48 server.key
+ + set +x
```

观察日志输出，等待最多60秒，orderer便会使用该MSP启动.

### 工具

启动
```
k apply -f template/testnet-cli.yaml
```

进入fabric tools
```
k exec -it deploy/cli -c tools -- bash
```

进入fabric ca client
```
k exec -it deploy/cli -c ca -- bash
```

调试网络
```
k exec -it deploy/cli -c dnsutils -- bash
```
