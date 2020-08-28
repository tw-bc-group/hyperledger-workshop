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
