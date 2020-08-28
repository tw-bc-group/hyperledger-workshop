## 配置CA和中间证书


### 准备自签名根证书和中间证书

依次为各组织创建根证书和中间证书，下面以org1为例：

创建自签名根证书
```
./00-create-root-CA.sh org1
```

创建中间证书
```
01-create-intermediate-CA.sh org1
```

创建后产出的如下：
```
├── ca
│   └── org1
│       ├── intermediate
│       │   ├── certs
│       │   │   ├── ca-chain.cert.pem      -> 证书链
│       │   │   └── intermediate.cert.pem  -> 中间证书
│       │   ├── private
│       │   │   └── intermediate.key.pem   -> 中间证书私钥
│       └── root
│           ├── certs
│           │   └── ca.cert.pem            -> 根证书
│           ├── private
│           │   └── ca.key.pem             -> 根证书私钥


```

其中以下文件会作为org1的CA文件:

- ca-chain.cert.pem
- intermediate.cert.pem
- intermediate.key.pem

### 创建namespaces

创建一个namespace用于安装testnet。

> 这里假定namespace为testnet

```
$ kubectl create namespace testnet
namespace/testnet created
```

查看创建的namespaces
```
$ kubectl get namespace testnet
NAME      STATUS   AGE
testnet   Active   116s
```

### 上传证书

从文件上传CA证书和证书链

```
$ kubectl -n testnet create secret generic ca-org1-cert --from-file=./ca/org1/intermediate/certs
secret/ca-org1-cert created
$ kubectl -n testnet describe secret ca-org1-cert
Name:         ca-org1-cert
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
ca-chain.cert.pem:      1576 bytes
intermediate.cert.pem:  778 bytes
```

从文件上传CA私钥
```
$ kubectl -n testnet create secret generic ca-org1-key --from-file=./ca/org1/intermediate/private
secret/ca-org1-key created
$ kubectl -n testnet describe secret ca-org1-key
Name:         ca-org1-key
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  Opaque

Data
====
intermediate.key.pem:  227 bytes
```

依次完成org1, org2, orderer的CA证书上传。

### 创建CA服务

从`template/ca-template.yaml`拷贝模版，替换`{{org}}`为实际组织后保存为`ca-{{org}}.yaml`, 应用该文件完成部署。

以org1为例：

```
$ cat template/ca-template.yaml | sed 's/{{org}}/org1/' > ca-org1.yaml
$ kubectl -n testnet apply -f ca-org1.yaml
service/ca-org1 created
persistentvolumeclaim/ca-org1 created
deployment.apps/ca-org1 created
$ kubectl -n testnet get all -l app=ca-org1
NAME                           READY   STATUS    RESTARTS   AGE
pod/ca-org1-587b957867-mjj8k   1/1     Running   0          2m36s

NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/ca-org1   1/1     1            1           2m36s

NAME                                 DESIRED   CURRENT   READY   AGE
replicaset.apps/ca-org1-587b957867   1         1         1       2m36s
```

依次完成其他组织的CA创建
