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
│       │   ├── certs                                  ---+
│       │   │   ├── ca-chain.cert.pem      -> 证书链      |后
│       │   │   └── intermediate.cert.pem  -> 中间证书    |面
│       │   ├── private                                   |使
│       │   │   └── intermediate.key.pem   -> 中间证书私钥|用
│       └── root                                       ---+
│           ├── certs
│           │   └── ca.cert.pem            -> 根证书
│           ├── private
│           │   └── ca.key.pem             -> 根证书私钥


```

