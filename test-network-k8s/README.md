# Hyplerledger Fabric 测试网络到生产

在大多数情况我们可以使用Kubernetes在部署和运维Hyperledger Fabric。以便在生产环境下，利用kubernetes的各种管理好处：

- 事实上的应用运维标准
- 作为基础设施的抽象，可以方便适应各种部署方式
- 内建强大的自我修复
- 代码定义基础设施，版本化配置和部署
- 大量可用的应用和运维工具（参考helm hub)


下面讲解了一部分将[fisrt-network](../fisrt-network)部署到kubnetes上的步骤


- [可选：配置CA和中间证书](00-CA)
- [部署和配置Orderer](01-ORDERER)
- [部署和配置Peer](02-PEER)
- [调试工具](03-TOOLS)
