pktgen.set("all","rate",100);
--pktgen.set("all","count",100);
pktgen.set("all","size",1024);
pktgen.set("all", "sport", 80);
pktgen.set("all", "dport", 80);
pktgen.set_ipaddr("0","src","1.1.1.100/24");
pktgen.set_ipaddr("0","dst","1.1.1.102");
pktgen.set_mac("0","90:e2:ba:76:85:18");
pktgen.set_proto("all", "udp");
pktgen.set_type("all", "ipv4");

--"--[[" "]]"

pktgen.dst_mac("0","start","90:e2:ba:76:85:18");

pktgen.dst_ip("0","start","1.1.1.101");
pktgen.dst_ip("0","inc","0.0.0.0");
pktgen.dst_ip("0","min","1.1.1.101");
pktgen.dst_ip("0","max","1.1.1.101");

pktgen.src_ip("0", "start", "1.1.1.100");
pktgen.src_ip("0", "inc", "0.0.0.0");
pktgen.src_ip("0", "min", "1.1.1.100");
pktgen.src_ip("0", "max", "1.1.1.100");

pktgen.dst_port("0", "start", 80);
pktgen.dst_port("0", "inc", 0);
pktgen.dst_port("0", "min", 80);
pktgen.dst_port("0", "max", 80);

pktgen.src_port("0", "start", 60000);
pktgen.src_port("0", "inc", 1);
pktgen.src_port("0", "min", 60000);
pktgen.src_port("0", "max", 61000);

pktgen.pkt_size("0", "start",1024);
pktgen.pkt_size("0", "inc", 0);
pktgen.pkt_size("0", "min", 1024);
pktgen.pkt_size("0", "max", 1024);

pktgen.ip_proto("0","udp");

pktgen.set_range("0", "on");

--pktgen.start("0");
--pktgen.delay(60000);
--pktgen.stop("0");
