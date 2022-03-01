# hyperledger-workshop

## 环境需求

- wget
- curl
- make
- docker v19.03.12
- docker-compose v1.26.2
- jdk 11
- go v1.12.x (可选）
- Ubuntu 18.04 LTS (建议)

## 准备环境

### 方法一：使用脚本 (推荐）

进入项目目录
执行`make prepare`, 会自动下载工具和文件

> 工具会被安装到`bin`目录下，使用时候需要添加到PATH

### 方法二：从源代码构建
设置Go项目的环境变量
  ```
  export GOPATH=$HOME/go
  ```
下载和构建Fabric
  ```
  mkdir -p $GOPATH/src/github.com/hyperledger
  cd $GOPATH/src/github.com/hyperledger
  git clone https://github.com/hyperledger/fabric/
  cd fabric

  # 选择源版本
  git checkout release-2.1

  # 构建工具
  make configtxgen cryptogen configtxlator

  # 构建镜像
  make docker
  ```
添加环境变量
  ```
  export PATH=$PATH:$GOPATH/src/github.com/hyperledger/fabric/build/bin
  ```
下载和构建Fabric-CA
  ```
  cd $GOPATH/src/github.com/hyperledger
  git clone https://github.com/hyperledger/fabric-ca
  cd fabric-ca
  make docker
  ```

## 启动测试网络

开发和测试的网络位于`test-network`目录下，该网络默认包含

- 两个组织 org1, org2
- 每个组织包含一个 Peer 节点
- 一个的排序服务

### 网络启动脚本

在`test-network`目录下包含启动网络的脚本`network.sh`

```
network.sh
Usage:
  network.sh <Mode> [Flags]
    <Mode>
      - 'up' - bring up fabric orderer and peer nodes. No channel is created
      - 'up createChannel' - bring up fabric network with one channel
      - 'createChannel' - create and join a channel after the network is created
      - 'deployCC' - deploy the fabcar chaincode on the channel
      - 'down' - clear the network with docker-compose down
      - 'restart' - restart the network
```

> 更多查看 ./network.sh -h


### 启动网络

我们可以通过脚本启动一个内置CA的网络。

```
$ cd test-network
$ ./network.sh up -ca
```

### 创建通道

网络启动之后便可以创建通道。

```
$ ./network.sh createChannel
```

这里使用了默认名词`mychannel`，后面的步骤中也默认使用该名称。但你也可以使用其他名称，使用参数`-c <channel_name>`指定，更多参数查看`network.sh -h`。

### 部署chaincode

```
./network.sh deployCC -l java
```

> 示例代码默认部署fabcar，详细可以查看`test-network/scripts/deployCC.sh`。

### 通过命令行访问链

设置访问的环境变量，可以使用如下模版

```
# PROJECT_ROOT 为这个代码库根路径
export PROJECT_ROOT=${PWD}
# 设置工具和配置路径
export PATH=$PROJECT_ROOT/bin:$PATH
export FABRIC_CFG_PATH=$PROJECT_ROOT/config/
# 设置Org1的环境变量
PEER_ORG1_PATH=${PROJECT_ROOT}/test-network/organizations/peerOrganizations/org1.example.com
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=${PEER_ORG1_PATH}/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PEER_ORG1_PATH}/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=localhost:7051
```

调用查询
```
peer chaincode query -C mychannel -n fabcar -c '{"Args":["queryAllCars"]}'
->
[
    {
        "Key": "CAR0",
        "Record": {
            "make": "Toyota",
            "model": "Prius",
            "colour": "blue",
            "owner": "Tomoko"
        }
    }...
]
```

### 关闭网络

```
./network.sh down
```

## 参考

- [编写你的第一个应用 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/write_first_app.html)
- [安装示例、二进制和 Docker 镜像 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/install.html)
- [先决条件 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/prereqs.html)
- [Getting Started - The Go Programming Language](https://golang.org/doc/install)
- [trade-finance-logistics/network at master · HyperledgerHandsOn/trade-finance-logistics](https://github.com/HyperledgerHandsOn/trade-finance-logistics/tree/master/network#prerequisites-to-configure-and-launch-the-network)

