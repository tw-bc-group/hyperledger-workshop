# hyperledger-workshop

## 环境需求

- wget
- curl
- make
- docker & docker-compose
- go

## 准备环境

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

## 参考

- [编写你的第一个应用 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/write_first_app.html)
- [安装示例、二进制和 Docker 镜像 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/install.html)
- [先决条件 — hyperledger-fabricdocs master 文档](https://hyperledger-fabric.readthedocs.io/zh_CN/latest/prereqs.html)
- [Getting Started - The Go Programming Language](https://golang.org/doc/install)
- [trade-finance-logistics/network at master · HyperledgerHandsOn/trade-finance-logistics](https://github.com/HyperledgerHandsOn/trade-finance-logistics/tree/master/network#prerequisites-to-configure-and-launch-the-network)

