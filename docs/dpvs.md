# DPVS 

DATA PLANE VIRTUAL SERVER

基于[dpdk][dpdk_org]开发的类[lvs][lvs]负载均衡软件

![][dpvs_img]

## 支持的功能

* synproxy
* fullnat(tcp/udp)
* persistent


## 特点

* non-blocking concurrent
* memory pool
* dpdk
  - multicore framework
  - huge page memory
  - ring buffers
  - poll-mode drivers


## install DPDK
* [dpdk.org][dpdk_org] 官网
* [guide][grog_guide]
* [samples][samples]
* source
  - [git://dpdk.org/dpdk](http://dpdk.org/browse/dpdk)
  - [git://dpdk.org/apps/pktgen-dpdk](http://dpdk.org/browse/apps/pktgen-dpdk/)

[lvs]:http://www.linuxvirtualserver.org/
[dpdk_org]:http://dpdk.org
[grog_guide]:http://dpdk.org/doc/guides/prog_guide
[samples]:http://dpdk.org/doc/guides/sample_app_ug/index.html
[dpvs_img]:https://cdn.rawgit.com/yubo/doc/master/docs/img/dpvs.svg
