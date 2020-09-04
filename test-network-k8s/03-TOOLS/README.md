## Fabric Tools (cli)

链部署在k8s集群网络内，为了方便和链交互，需要部署一个服务作为跳板机。

### 命令

启动
```
k apply -f ../template/testnet-cli.yaml
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
