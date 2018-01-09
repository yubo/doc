
# 测试环境
## 硬件
- CPU：Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz，24 个逻辑核
- 内存：128G
- 网卡：Intel Corporation 82599ES 10-Gigabit SFI/SFP+ Network Connection 


## 软件
- 操作系统：Ubuntu 16.04.1
- 内核版本：4.4.0-92-generic 
- dpvs 版本：v0.4

## 网络拓扑
sq-op-dev-dpdk01.bj：客户端
sq-op-dev-dpdk02.bj：服务端
sq-op-dev-dpdk03.bj：dpvs 

三台测试机，dpdk03 模拟 lvs 服务器，运行 dpvs；dpdk01 模拟客户端，运行 dpdk-pktgen，往 lvs 服务器发送数据包；dpdk02 模拟 real server，运行 dpdk-pktgen，从 lvs 服务器接收数据包。所有的网卡都接在同一台交换机上

dpvs 上配置 1 个 vip，10 个 real server IP，10 个 local address，LVS 连接数为 1000

- - - - -
# 测试标准
## 性能指标
- 丢包率：负载为 10000Mbit/s 的情况下，60s 内没有转发的包占收到的包的百分比
- 吞吐量：不丢包的情况下，每秒转发包的数量（单位Mpps）

## 测试方法
- 测试包大小为 64、128、256、512、1024 字节
- 测试包为 UDP 包

- - - - -
# dpvs 配置
使用 16 个逻辑核作为 worker，对应 16 个网卡队列，2 个逻辑核作为发送 IO 核，3 个逻辑核作为接收 IO 核，根据 vip、local address、real server 数量及连接数，dpvs 配置如下：
- 内存池大小：
    - mbuf 2560000
    - svc 1024
    - rs 1024
    - laddr 1024
    - conn 2048
- 哈希表大小：
    - conn 2^11
    - svc 2^8
    - rs 2^4
- worker CPU 数量：16
- tx CPU 数量：2
- rx CPU 数量：3
- ring_sizes：1024, 1024, 1024, 1024
- burst_sizes：(144,144),(144,144),(144,144)


- - - - -
# 测试流程
- 在 dpdk03  上启动 dpvs，按照上述配置要求，准备测试环境
- 在 dpdk02 上启动 dpdk-pktgen，监控网卡，准备收包
- 在 client 上启动 dpdk-pktgen，按要求设置，准备发包
- 开始发包，收集测试结果

- - - - -
# 测试结果
## 丢包率
发包速率为 10000Mbit/s 时，60s 内发送包数量、数据量与接受包数量、数据量：
 
| PktSize/byte(-)  	 |   64  	 |   128  	 |   256  	 |   512  	 |   1024	 |   
|----|----|----|----|----|----|
| TX/Pkts		 | 887910912	 | 503910784	 | 270213888	 | 140186880	 | 71427456	 |
| TX/MBs		 | 596676	 | 596630	 | 596632	 | 596635	 | 596562	 |
| RX/Pkts		 | 559643328	 | 503796316	 | 270148572	 | 140165996	 | 71417132	 |
| RX/MBs		 | 376082	 | 596494	 | 596486	 | 596542	 | 596468	 |

发包速率为 10000Mbit/s 时，丢包率与包大小的关系：

| PktSize/byte	 |   64	  |   128	 |   256	 |   512	 |   1024	 |
|----|----|----|----|----|----|
| Loss Rate/%  	 | 36.971 | 0.023	 | 0.0242	 | 0.0149	 | 0.0145	 |


## 吞吐量
万兆网卡上，不同大小的数据包吞吐量的理论值与实际值

| PktSize/byte		 |   64  	 |   128	 |   256	 |   512	 |   1024	 |
|----|----|----|----|----|----|
| Theoretical value/Mpps | 14.88	 | 8.45		 | 4.53		 | 2.35		 | 1.20		 |
| Actual value/Mpps	 | 9.38		 | 8.45		 | 4.53		 | 2.35		 | 1.20		 |

![](Throughput.svg)
