Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Mon, 31 Oct 2016 13:43:38 +0200
Message-Id: <1477914225-11298-7-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v3 PATCH 06/13] net: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dwindsor@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/ipvlan/ipvlan_core.c         |  2 +-
 drivers/net/macvlan.c                    |  2 +-
 include/linux/netdevice.h                |  8 +++----
 include/linux/sunrpc/svc_rdma.h          | 18 +++++++--------
 include/net/bonding.h                    |  2 +-
 include/net/caif/cfctrl.h                |  4 ++--
 include/net/flow.h                       |  2 +-
 include/net/gro_cells.h                  |  2 +-
 include/net/inetpeer.h                   |  3 ++-
 include/net/ip_fib.h                     |  2 +-
 include/net/ip_vs.h                      |  4 ++--
 include/net/iucv/af_iucv.h               |  2 +-
 include/net/net_namespace.h              | 12 +++++-----
 include/net/netns/ipv4.h                 |  4 ++--
 include/net/netns/ipv6.h                 |  4 ++--
 include/net/netns/xfrm.h                 |  2 +-
 include/net/sock.h                       |  8 +++----
 include/net/tcp.h                        |  2 +-
 include/net/xfrm.h                       |  2 +-
 net/batman-adv/bat_iv_ogm.c              |  8 +++----
 net/batman-adv/fragmentation.c           |  3 ++-
 net/batman-adv/soft-interface.c          |  6 ++---
 net/batman-adv/types.h                   |  6 ++---
 net/caif/cfctrl.c                        | 11 +++++----
 net/ceph/messenger.c                     |  4 ++--
 net/core/datagram.c                      |  2 +-
 net/core/dev.c                           | 18 +++++++--------
 net/core/flow.c                          |  9 ++++----
 net/core/net-sysfs.c                     |  2 +-
 net/core/netpoll.c                       |  4 ++--
 net/core/rtnetlink.c                     |  2 +-
 net/core/sock.c                          | 14 ++++++------
 net/core/sock_diag.c                     |  8 +++----
 net/ipv4/devinet.c                       |  4 ++--
 net/ipv4/fib_frontend.c                  |  6 ++---
 net/ipv4/fib_semantics.c                 |  2 +-
 net/ipv4/inet_connection_sock.c          |  4 ++--
 net/ipv4/inet_timewait_sock.c            |  3 ++-
 net/ipv4/inetpeer.c                      |  2 +-
 net/ipv4/ip_fragment.c                   |  2 +-
 net/ipv4/ping.c                          |  2 +-
 net/ipv4/raw.c                           |  5 +++--
 net/ipv4/route.c                         | 12 +++++-----
 net/ipv4/tcp_input.c                     |  2 +-
 net/ipv4/udp.c                           | 10 ++++-----
 net/ipv6/addrconf.c                      |  7 +++---
 net/ipv6/af_inet6.c                      |  2 +-
 net/ipv6/datagram.c                      |  2 +-
 net/ipv6/ip6_fib.c                       |  4 ++--
 net/ipv6/raw.c                           |  6 ++---
 net/ipv6/udp.c                           |  6 ++---
 net/iucv/af_iucv.c                       |  5 +++--
 net/key/af_key.c                         |  4 ++--
 net/l2tp/l2tp_eth.c                      | 38 ++++++++++++++++----------------
 net/netfilter/ipvs/ip_vs_conn.c          |  6 ++---
 net/netfilter/ipvs/ip_vs_core.c          |  8 +++----
 net/netfilter/ipvs/ip_vs_ctl.c           | 12 +++++-----
 net/netfilter/ipvs/ip_vs_sync.c          |  6 ++---
 net/netfilter/ipvs/ip_vs_xmit.c          |  4 ++--
 net/netfilter/nfnetlink_log.c            |  4 ++--
 net/netfilter/xt_statistic.c             |  9 ++++----
 net/netlink/af_netlink.c                 |  4 ++--
 net/packet/af_packet.c                   |  4 ++--
 net/phonet/pep.c                         |  6 ++---
 net/phonet/socket.c                      |  2 +-
 net/rds/cong.c                           |  6 ++---
 net/rds/ib.h                             |  2 +-
 net/rds/ib_cm.c                          |  2 +-
 net/rds/ib_recv.c                        |  4 ++--
 net/rxrpc/af_rxrpc.c                     |  2 +-
 net/rxrpc/ar-internal.h                  |  4 ++--
 net/rxrpc/call_object.c                  |  2 +-
 net/rxrpc/conn_event.c                   |  4 ++--
 net/rxrpc/conn_object.c                  |  2 +-
 net/rxrpc/local_object.c                 |  2 +-
 net/rxrpc/output.c                       |  6 ++---
 net/rxrpc/peer_object.c                  |  2 +-
 net/rxrpc/proc.c                         |  2 +-
 net/rxrpc/rxkad.c                        |  4 ++--
 net/sched/sch_generic.c                  |  4 ++--
 net/sctp/sctp_diag.c                     |  2 +-
 net/sunrpc/auth_gss/svcauth_gss.c        |  4 ++--
 net/sunrpc/sched.c                       |  4 ++--
 net/sunrpc/xprtrdma/svc_rdma.c           | 36 +++++++++++++++---------------
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  8 +++----
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  2 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  2 +-
 net/xfrm/xfrm_policy.c                   | 11 ++++-----
 net/xfrm/xfrm_state.c                    |  4 ++--
 security/selinux/include/xfrm.h          |  2 +-
 90 files changed, 254 insertions(+), 244 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index b4e9907..17712d4 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -484,7 +484,7 @@ static void ipvlan_multicast_enqueue(struct ipvl_port *port,
 		schedule_work(&port->wq);
 	} else {
 		spin_unlock(&port->backlog.lock);
-		atomic_long_inc(&skb->dev->rx_dropped);
+		atomic_long_inc_wrap(&skb->dev->rx_dropped);
 		kfree_skb(skb);
 	}
 }
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 3234fcd..9d5435f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -343,7 +343,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 free_nskb:
 	kfree_skb(nskb);
 err:
-	atomic_long_inc(&skb->dev->rx_dropped);
+	atomic_long_inc_wrap(&skb->dev->rx_dropped);
 }
 
 static void macvlan_flush_sources(struct macvlan_port *port,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 136ae6bb..21ad33b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1651,7 +1651,7 @@ struct net_device {
 	unsigned long		base_addr;
 	int			irq;
 
-	atomic_t		carrier_changes;
+	atomic_wrap_t		carrier_changes;
 
 	/*
 	 *	Some hardware also needs these fields (state,dev_list,
@@ -1691,9 +1691,9 @@ struct net_device {
 
 	struct net_device_stats	stats;
 
-	atomic_long_t		rx_dropped;
-	atomic_long_t		tx_dropped;
-	atomic_long_t		rx_nohandler;
+	atomic_long_wrap_t	rx_dropped;
+	atomic_long_wrap_t	tx_dropped;
+	atomic_long_wrap_t	rx_nohandler;
 
 #ifdef CONFIG_WIRELESS_EXT
 	const struct iw_handler_def *wireless_handlers;
diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index cc3ae16..b257f44 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -54,15 +54,15 @@ extern unsigned int svcrdma_max_requests;
 extern unsigned int svcrdma_max_bc_requests;
 extern unsigned int svcrdma_max_req_size;
 
-extern atomic_t rdma_stat_recv;
-extern atomic_t rdma_stat_read;
-extern atomic_t rdma_stat_write;
-extern atomic_t rdma_stat_sq_starve;
-extern atomic_t rdma_stat_rq_starve;
-extern atomic_t rdma_stat_rq_poll;
-extern atomic_t rdma_stat_rq_prod;
-extern atomic_t rdma_stat_sq_poll;
-extern atomic_t rdma_stat_sq_prod;
+extern atomic_wrap_t rdma_stat_recv;
+extern atomic_wrap_t rdma_stat_read;
+extern atomic_wrap_t rdma_stat_write;
+extern atomic_wrap_t rdma_stat_sq_starve;
+extern atomic_wrap_t rdma_stat_rq_starve;
+extern atomic_wrap_t rdma_stat_rq_poll;
+extern atomic_wrap_t rdma_stat_rq_prod;
+extern atomic_wrap_t rdma_stat_sq_poll;
+extern atomic_wrap_t rdma_stat_sq_prod;
 
 /*
  * Contexts are built when an RDMA request is created and are a
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f32f7ef..1de3052 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -695,7 +695,7 @@ extern struct rtnl_link_ops bond_link_ops;
 
 static inline void bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
-	atomic_long_inc(&dev->tx_dropped);
+	atomic_long_inc_wrap(&dev->tx_dropped);
 	dev_kfree_skb_any(skb);
 }
 
diff --git a/include/net/caif/cfctrl.h b/include/net/caif/cfctrl.h
index f2ae33d..1ef13f2 100644
--- a/include/net/caif/cfctrl.h
+++ b/include/net/caif/cfctrl.h
@@ -101,8 +101,8 @@ struct cfctrl_request_info {
 struct cfctrl {
 	struct cfsrvl serv;
 	struct cfctrl_rsp res;
-	atomic_t req_seq_no;
-	atomic_t rsp_seq_no;
+	atomic_wrap_t req_seq_no;
+	atomic_wrap_t rsp_seq_no;
 	struct list_head list;
 	/* Protects from simultaneous access to first_req list */
 	spinlock_t info_list_lock;
diff --git a/include/net/flow.h b/include/net/flow.h
index 035aa77..37f1358 100644
--- a/include/net/flow.h
+++ b/include/net/flow.h
@@ -242,7 +242,7 @@ void flow_cache_fini(struct net *net);
 
 void flow_cache_flush(struct net *net);
 void flow_cache_flush_deferred(struct net *net);
-extern atomic_t flow_cache_genid;
+extern atomic_wrap_t flow_cache_genid;
 
 __u32 __get_hash_from_flowi6(const struct flowi6 *fl6, struct flow_keys *keys);
 
diff --git a/include/net/gro_cells.h b/include/net/gro_cells.h
index d15214d..32a3166 100644
--- a/include/net/gro_cells.h
+++ b/include/net/gro_cells.h
@@ -25,7 +25,7 @@ static inline int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *sk
 	cell = this_cpu_ptr(gcells->cells);
 
 	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
-		atomic_long_inc(&dev->rx_dropped);
+		atomic_long_inc_wrap(&dev->rx_dropped);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 235c781..c81eb78 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -52,7 +52,8 @@ struct inet_peer {
 	 */
 	union {
 		struct {
-			atomic_t			rid;		/* Frag reception counter */
+			atomic_wrap_t		rid;
+					/* Frag reception counter */
 		};
 		struct rcu_head         rcu;
 		struct inet_peer	*gc_next;
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index b9314b4..a8c2b24 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -189,7 +189,7 @@ static inline void fib_info_offload_dec(struct fib_info *fi)
 
 #define FIB_RES_SADDR(net, res)				\
 	((FIB_RES_NH(res).nh_saddr_genid ==		\
-	  atomic_read(&(net)->ipv4.dev_addr_genid)) ?	\
+	  atomic_read_wrap(&(net)->ipv4.dev_addr_genid)) ?	\
 	 FIB_RES_NH(res).nh_saddr :			\
 	 fib_info_update_nh_saddr((net), &FIB_RES_NH(res)))
 #define FIB_RES_GW(res)			(FIB_RES_NH(res).nh_gw)
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index cd6018a..49835c6 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -543,7 +543,7 @@ struct ip_vs_conn {
 	struct ip_vs_conn       *control;       /* Master control connection */
 	atomic_t                n_control;      /* Number of controlled ones */
 	struct ip_vs_dest       *dest;          /* real server */
-	atomic_t                in_pkts;        /* incoming packet counter */
+	atomic_wrap_t           in_pkts;        /* incoming packet counter */
 
 	/* Packet transmitter for different forwarding methods.  If it
 	 * mangles the packet, it must return NF_DROP or better NF_STOLEN,
@@ -664,7 +664,7 @@ struct ip_vs_dest {
 	__be16			port;		/* port number of the server */
 	union nf_inet_addr	addr;		/* IP address of the server */
 	volatile unsigned int	flags;		/* dest status flags */
-	atomic_t		conn_flags;	/* flags to copy to conn */
+	atomic_wrap_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
 
 	atomic_t		refcnt;		/* reference counter */
diff --git a/include/net/iucv/af_iucv.h b/include/net/iucv/af_iucv.h
index 714cc9a..2401e9e 100644
--- a/include/net/iucv/af_iucv.h
+++ b/include/net/iucv/af_iucv.h
@@ -149,7 +149,7 @@ struct iucv_skb_cb {
 struct iucv_sock_list {
 	struct hlist_head head;
 	rwlock_t	  lock;
-	atomic_t	  autobind_name;
+	atomic_wrap_t	  autobind_name;
 };
 
 unsigned int iucv_sock_poll(struct file *file, struct socket *sock,
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index fc4f757..792c736 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -53,7 +53,7 @@ struct net {
 						 */
 	spinlock_t		rules_mod_lock;
 
-	atomic64_t		cookie_gen;
+	atomic64_wrap_t		cookie_gen;
 
 	struct list_head	list;		/* list of network namespaces */
 	struct list_head	cleanup_list;	/* namespaces on death row */
@@ -142,7 +142,7 @@ struct net {
 	struct netns_mpls	mpls;
 #endif
 	struct sock		*diag_nlsk;
-	atomic_t		fnhe_genid;
+	atomic_wrap_t		fnhe_genid;
 };
 
 #include <linux/seq_file_net.h>
@@ -341,12 +341,12 @@ static inline void unregister_net_sysctl_table(struct ctl_table_header *header)
 
 static inline int rt_genid_ipv4(struct net *net)
 {
-	return atomic_read(&net->ipv4.rt_genid);
+	return atomic_read_wrap(&net->ipv4.rt_genid);
 }
 
 static inline void rt_genid_bump_ipv4(struct net *net)
 {
-	atomic_inc(&net->ipv4.rt_genid);
+	atomic_inc_wrap(&net->ipv4.rt_genid);
 }
 
 extern void (*__fib6_flush_trees)(struct net *net);
@@ -373,12 +373,12 @@ static inline void rt_genid_bump_all(struct net *net)
 
 static inline int fnhe_genid(struct net *net)
 {
-	return atomic_read(&net->fnhe_genid);
+	return atomic_read_wrap(&net->fnhe_genid);
 }
 
 static inline void fnhe_genid_bump(struct net *net)
 {
-	atomic_inc(&net->fnhe_genid);
+	atomic_inc_wrap(&net->fnhe_genid);
 }
 
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 7adf438..33130b6 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -118,7 +118,7 @@ struct netns_ipv4 {
 
 	struct ping_group_range ping_group_range;
 
-	atomic_t dev_addr_genid;
+	atomic_wrap_t dev_addr_genid;
 
 #ifdef CONFIG_SYSCTL
 	unsigned long *sysctl_local_reserved_ports;
@@ -135,6 +135,6 @@ struct netns_ipv4 {
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 	int sysctl_fib_multipath_use_neigh;
 #endif
-	atomic_t	rt_genid;
+	atomic_wrap_t	rt_genid;
 };
 #endif
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 10d0848..a0eb0a9 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -83,8 +83,8 @@ struct netns_ipv6 {
 	struct fib_rules_ops	*mr6_rules_ops;
 #endif
 #endif
-	atomic_t		dev_addr_genid;
-	atomic_t		fib6_sernum;
+	atomic_wrap_t		dev_addr_genid;
+	atomic_wrap_t		fib6_sernum;
 };
 
 #if IS_ENABLED(CONFIG_NF_DEFRAG_IPV6)
diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index 27bb963..a39e73e 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -76,7 +76,7 @@ struct netns_xfrm {
 
 	/* flow cache part */
 	struct flow_cache	flow_cache_global;
-	atomic_t		flow_cache_genid;
+	atomic_wrap_t		flow_cache_genid;
 	struct list_head	flow_cache_gc_list;
 	atomic_t		flow_cache_gc_count;
 	spinlock_t		flow_cache_gc_lock;
diff --git a/include/net/sock.h b/include/net/sock.h
index ebf75db..7253c97 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -188,7 +188,7 @@ struct sock_common {
 	struct in6_addr		skc_v6_rcv_saddr;
 #endif
 
-	atomic64_t		skc_cookie;
+	atomic64_wrap_t		skc_cookie;
 
 	/* following fields are padding to force
 	 * offset(struct sock, sk_refcnt) == 128 on 64bit arches
@@ -364,7 +364,7 @@ struct sock {
 	unsigned int		sk_napi_id;
 	unsigned int		sk_ll_usec;
 #endif
-	atomic_t		sk_drops;
+	atomic_wrap_t		sk_drops;
 	int			sk_rcvbuf;
 
 	struct sk_filter __rcu	*sk_filter;
@@ -2106,14 +2106,14 @@ struct sock_skb_cb {
 static inline void
 sock_skb_set_dropcount(const struct sock *sk, struct sk_buff *skb)
 {
-	SOCK_SKB_CB(skb)->dropcount = atomic_read(&sk->sk_drops);
+	SOCK_SKB_CB(skb)->dropcount = atomic_read_wrap(&sk->sk_drops);
 }
 
 static inline void sk_drops_add(struct sock *sk, const struct sk_buff *skb)
 {
 	int segs = max_t(u16, 1, skb_shinfo(skb)->gso_segs);
 
-	atomic_add(segs, &sk->sk_drops);
+	atomic_add_wrap(segs, &sk->sk_drops);
 }
 
 void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
diff --git a/include/net/tcp.h b/include/net/tcp.h
index f83b7f2..64a2571 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1919,7 +1919,7 @@ static inline void tcp_segs_in(struct tcp_sock *tp, const struct sk_buff *skb)
  */
 static inline void tcp_listendrop(const struct sock *sk)
 {
-	atomic_inc(&((struct sock *)sk)->sk_drops);
+	atomic_inc_wrap(&((struct sock *)sk)->sk_drops);
 	__NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENDROPS);
 }
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 31947b9..d24fca3 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -528,7 +528,7 @@ struct xfrm_policy {
 	struct timer_list	timer;
 
 	struct flow_cache_object flo;
-	atomic_t		genid;
+	atomic_wrap_t		genid;
 	u32			priority;
 	u32			index;
 	struct xfrm_mark	mark;
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index e2d18d0..445263c7 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -368,7 +368,7 @@ static int batadv_iv_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
 
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
-	atomic_set(&hard_iface->bat_iv.ogm_seqno, random_seqno);
+	atomic_set_wrap(&hard_iface->bat_iv.ogm_seqno, random_seqno);
 
 	hard_iface->bat_iv.ogm_buff_len = BATADV_OGM_HLEN;
 	ogm_buff = kmalloc(hard_iface->bat_iv.ogm_buff_len, GFP_ATOMIC);
@@ -953,9 +953,9 @@ static void batadv_iv_ogm_schedule(struct batadv_hard_iface *hard_iface)
 	batadv_ogm_packet->tvlv_len = htons(tvlv_len);
 
 	/* change sequence number to network order */
-	seqno = (u32)atomic_read(&hard_iface->bat_iv.ogm_seqno);
+	seqno = (u32)atomic_read_wrap(&hard_iface->bat_iv.ogm_seqno);
 	batadv_ogm_packet->seqno = htonl(seqno);
-	atomic_inc(&hard_iface->bat_iv.ogm_seqno);
+	atomic_inc_wrap(&hard_iface->bat_iv.ogm_seqno);
 
 	batadv_iv_ogm_slide_own_bcast_window(hard_iface);
 
@@ -1653,7 +1653,7 @@ static void batadv_iv_ogm_process(const struct sk_buff *skb, int ogm_offset,
 		return;
 
 	/* could be changed by schedule_own_packet() */
-	if_incoming_seqno = atomic_read(&if_incoming->bat_iv.ogm_seqno);
+	if_incoming_seqno = atomic_read_wrap(&if_incoming->bat_iv.ogm_seqno);
 
 	if (ogm_packet->flags & BATADV_DIRECTLINK)
 		has_directlink_flag = true;
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 0934730..0f45636 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -469,7 +469,8 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 	frag_header.packet_type = BATADV_UNICAST_FRAG;
 	frag_header.version = BATADV_COMPAT_VERSION;
 	frag_header.ttl = BATADV_TTL;
-	frag_header.seqno = htons(atomic_inc_return(&bat_priv->frag_seqno));
+	frag_header.seqno = htons(atomic_inc_return_wrap(
+				&bat_priv->frag_seqno));
 	frag_header.reserved = 0;
 	frag_header.no = 0;
 	frag_header.total_size = htons(skb->len);
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 49e16b6..1716004 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -333,7 +333,7 @@ static int batadv_interface_tx(struct sk_buff *skb,
 				primary_if->net_dev->dev_addr);
 
 		/* set broadcast sequence number */
-		seqno = atomic_inc_return(&bat_priv->bcast_seqno);
+		seqno = atomic_inc_return_wrap(&bat_priv->bcast_seqno);
 		bcast_packet->seqno = htonl(seqno);
 
 		batadv_add_bcast_packet_to_list(bat_priv, skb, brd_delay);
@@ -813,7 +813,7 @@ static int batadv_softif_init_late(struct net_device *dev)
 	atomic_set(&bat_priv->batman_queue_left, BATADV_BATMAN_QUEUE_LEN);
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_INACTIVE);
-	atomic_set(&bat_priv->bcast_seqno, 1);
+	atomic_set_wrap(&bat_priv->bcast_seqno, 1);
 	atomic_set(&bat_priv->tt.vn, 0);
 	atomic_set(&bat_priv->tt.local_changes, 0);
 	atomic_set(&bat_priv->tt.ogm_append_cnt, 0);
@@ -829,7 +829,7 @@ static int batadv_softif_init_late(struct net_device *dev)
 
 	/* randomize initial seqno to avoid collision */
 	get_random_bytes(&random_seqno, sizeof(random_seqno));
-	atomic_set(&bat_priv->frag_seqno, random_seqno);
+	atomic_set_wrap(&bat_priv->frag_seqno, random_seqno);
 
 	bat_priv->primary_if = NULL;
 	bat_priv->num_ifaces = 0;
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index b3dd1a3..e7debc5 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -85,7 +85,7 @@ enum batadv_dhcp_recipient {
 struct batadv_hard_iface_bat_iv {
 	unsigned char *ogm_buff;
 	int ogm_buff_len;
-	atomic_t ogm_seqno;
+	atomic_wrap_t ogm_seqno;
 };
 
 /**
@@ -1040,7 +1040,7 @@ struct batadv_priv {
 	atomic_t bonding;
 	atomic_t fragmentation;
 	atomic_t packet_size_max;
-	atomic_t frag_seqno;
+	atomic_wrap_t frag_seqno;
 #ifdef CONFIG_BATMAN_ADV_BLA
 	atomic_t bridge_loop_avoidance;
 #endif
@@ -1057,7 +1057,7 @@ struct batadv_priv {
 #endif
 	u32 isolation_mark;
 	u32 isolation_mark_mask;
-	atomic_t bcast_seqno;
+	atomic_wrap_t bcast_seqno;
 	atomic_t bcast_queue_left;
 	atomic_t batman_queue_left;
 	char num_ifaces;
diff --git a/net/caif/cfctrl.c b/net/caif/cfctrl.c
index f5afda1..d40394a 100644
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -43,8 +43,8 @@ struct cflayer *cfctrl_create(void)
 	memset(&dev_info, 0, sizeof(dev_info));
 	dev_info.id = 0xff;
 	cfsrvl_init(&this->serv, 0, &dev_info, false);
-	atomic_set(&this->req_seq_no, 1);
-	atomic_set(&this->rsp_seq_no, 1);
+	atomic_set_wrap(&this->req_seq_no, 1);
+	atomic_set_wrap(&this->rsp_seq_no, 1);
 	this->serv.layer.receive = cfctrl_recv;
 	sprintf(this->serv.layer.name, "ctrl");
 	this->serv.layer.ctrlcmd = cfctrl_ctrlcmd;
@@ -130,8 +130,8 @@ static void cfctrl_insert_req(struct cfctrl *ctrl,
 			      struct cfctrl_request_info *req)
 {
 	spin_lock_bh(&ctrl->info_list_lock);
-	atomic_inc(&ctrl->req_seq_no);
-	req->sequence_no = atomic_read(&ctrl->req_seq_no);
+	atomic_inc_wrap(&ctrl->req_seq_no);
+	req->sequence_no = atomic_read_wrap(&ctrl->req_seq_no);
 	list_add_tail(&req->list, &ctrl->list);
 	spin_unlock_bh(&ctrl->info_list_lock);
 }
@@ -149,8 +149,7 @@ static struct cfctrl_request_info *cfctrl_remove_req(struct cfctrl *ctrl,
 			if (p != first)
 				pr_warn("Requests are not received in order\n");
 
-			atomic_set(&ctrl->rsp_seq_no,
-					 p->sequence_no);
+			atomic_set_wrap(&ctrl->rsp_seq_no, p->sequence_no);
 			list_del(&p->list);
 			goto out;
 		}
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index a550289..9e0a0dd 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -187,7 +187,7 @@ static void con_fault(struct ceph_connection *con);
 #define MAX_ADDR_STR_LEN	64	/* 54 is enough */
 
 static char addr_str[ADDR_STR_COUNT][MAX_ADDR_STR_LEN];
-static atomic_t addr_str_seq = ATOMIC_INIT(0);
+static atomic_wrap_t addr_str_seq = ATOMIC_INIT(0);
 
 static struct page *zero_page;		/* used in certain error cases */
 
@@ -198,7 +198,7 @@ const char *ceph_pr_addr(const struct sockaddr_storage *ss)
 	struct sockaddr_in *in4 = (struct sockaddr_in *) ss;
 	struct sockaddr_in6 *in6 = (struct sockaddr_in6 *) ss;
 
-	i = atomic_inc_return(&addr_str_seq) & ADDR_STR_COUNT_MASK;
+	i = atomic_inc_return_wrap(&addr_str_seq) & ADDR_STR_COUNT_MASK;
 	s = addr_str[i];
 
 	switch (ss->ss_family) {
diff --git a/net/core/datagram.c b/net/core/datagram.c
index b7de71f..4fef0c8 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -360,7 +360,7 @@ int skb_kill_datagram(struct sock *sk, struct sk_buff *skb, unsigned int flags)
 	}
 
 	kfree_skb(skb);
-	atomic_inc(&sk->sk_drops);
+	atomic_inc_wrap(&sk->sk_drops);
 	sk_mem_reclaim_partial(sk);
 
 	return err;
diff --git a/net/core/dev.c b/net/core/dev.c
index 4bc19a1..3465949 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1768,7 +1768,7 @@ int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
 	    unlikely(!is_skb_forwardable(dev, skb))) {
-		atomic_long_inc(&dev->rx_dropped);
+		atomic_long_inc_wrap(&dev->rx_dropped);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
@@ -3005,7 +3005,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 out_kfree_skb:
 	kfree_skb(skb);
 out_null:
-	atomic_long_inc(&dev->tx_dropped);
+	atomic_long_inc_wrap(&dev->tx_dropped);
 	return NULL;
 }
 
@@ -3415,7 +3415,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, void *accel_priv)
 	rc = -ENETDOWN;
 	rcu_read_unlock_bh();
 
-	atomic_long_inc(&dev->tx_dropped);
+	atomic_long_inc_wrap(&dev->tx_dropped);
 	kfree_skb_list(skb);
 	return rc;
 out:
@@ -3768,7 +3768,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 
 	local_irq_restore(flags);
 
-	atomic_long_inc(&skb->dev->rx_dropped);
+	atomic_long_inc_wrap(&skb->dev->rx_dropped);
 	kfree_skb(skb);
 	return NET_RX_DROP;
 }
@@ -4212,9 +4212,9 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc)
 	} else {
 drop:
 		if (!deliver_exact)
-			atomic_long_inc(&skb->dev->rx_dropped);
+			atomic_long_inc_wrap(&skb->dev->rx_dropped);
 		else
-			atomic_long_inc(&skb->dev->rx_nohandler);
+			atomic_long_inc_wrap(&skb->dev->rx_nohandler);
 		kfree_skb(skb);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
@@ -7537,9 +7537,9 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 	} else {
 		netdev_stats_to_stats64(storage, &dev->stats);
 	}
-	storage->rx_dropped += atomic_long_read(&dev->rx_dropped);
-	storage->tx_dropped += atomic_long_read(&dev->tx_dropped);
-	storage->rx_nohandler += atomic_long_read(&dev->rx_nohandler);
+	storage->rx_dropped += atomic_long_read_wrap(&dev->rx_dropped);
+	storage->tx_dropped += atomic_long_read_wrap(&dev->tx_dropped);
+	storage->rx_nohandler += atomic_long_read_wrap(&dev->rx_nohandler);
 	return storage;
 }
 EXPORT_SYMBOL(dev_get_stats);
diff --git a/net/core/flow.c b/net/core/flow.c
index 3937b1b..ee91374 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -65,7 +65,7 @@ static void flow_cache_new_hashrnd(unsigned long arg)
 static int flow_entry_valid(struct flow_cache_entry *fle,
 				struct netns_xfrm *xfrm)
 {
-	if (atomic_read(&xfrm->flow_cache_genid) != fle->genid)
+	if (atomic_read_wrap(&xfrm->flow_cache_genid) != fle->genid)
 		return 0;
 	if (fle->object && !fle->object->ops->check(fle->object))
 		return 0;
@@ -238,7 +238,7 @@ flow_cache_lookup(struct net *net, const struct flowi *key, u16 family, u8 dir,
 
 		if (fcp->hash_count > 2 * fc->high_watermark ||
 		    atomic_read(&net->xfrm.flow_cache_gc_count) > fc->high_watermark) {
-			atomic_inc(&net->xfrm.flow_cache_genid);
+			atomic_inc_wrap(&net->xfrm.flow_cache_genid);
 			flo = ERR_PTR(-ENOBUFS);
 			goto ret_object;
 		}
@@ -253,7 +253,8 @@ flow_cache_lookup(struct net *net, const struct flowi *key, u16 family, u8 dir,
 			hlist_add_head(&fle->u.hlist, &fcp->hash_table[hash]);
 			fcp->hash_count++;
 		}
-	} else if (likely(fle->genid == atomic_read(&net->xfrm.flow_cache_genid))) {
+	} else if (likely(fle->genid == atomic_read_wrap(
+					&net->xfrm.flow_cache_genid))) {
 		flo = fle->object;
 		if (!flo)
 			goto ret_object;
@@ -274,7 +275,7 @@ flow_cache_lookup(struct net *net, const struct flowi *key, u16 family, u8 dir,
 	}
 	flo = resolver(net, key, family, dir, flo, ctx);
 	if (fle) {
-		fle->genid = atomic_read(&net->xfrm.flow_cache_genid);
+		fle->genid = atomic_read_wrap(&net->xfrm.flow_cache_genid);
 		if (!IS_ERR(flo))
 			fle->object = flo;
 		else
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 6e4f347..c1a9bfc 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -290,7 +290,7 @@ static ssize_t carrier_changes_show(struct device *dev,
 {
 	struct net_device *netdev = to_net_dev(dev);
 	return sprintf(buf, fmt_dec,
-		       atomic_read(&netdev->carrier_changes));
+		       atomic_read_wrap(&netdev->carrier_changes));
 }
 static DEVICE_ATTR_RO(carrier_changes);
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 53599bd..dab9d4d 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -382,7 +382,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 	struct udphdr *udph;
 	struct iphdr *iph;
 	struct ethhdr *eth;
-	static atomic_t ip_ident;
+	static atomic_wrap_t ip_ident;
 	struct ipv6hdr *ip6h;
 
 	WARN_ON_ONCE(!irqs_disabled());
@@ -455,7 +455,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 		put_unaligned(0x45, (unsigned char *)iph);
 		iph->tos      = 0;
 		put_unaligned(htons(ip_len), &(iph->tot_len));
-		iph->id       = htons(atomic_inc_return(&ip_ident));
+		iph->id       = htons(atomic_inc_return_wrap(&ip_ident));
 		iph->frag_off = 0;
 		iph->ttl      = 64;
 		iph->protocol = IPPROTO_UDP;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index fb7348f..0f04cd5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1322,7 +1322,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 	    (dev->ifalias &&
 	     nla_put_string(skb, IFLA_IFALIAS, dev->ifalias)) ||
 	    nla_put_u32(skb, IFLA_CARRIER_CHANGES,
-			atomic_read(&dev->carrier_changes)) ||
+			atomic_read_wrap(&dev->carrier_changes)) ||
 	    nla_put_u8(skb, IFLA_PROTO_DOWN, dev->proto_down))
 		goto nla_put_failure;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index c73e28f..10cf15b 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -411,13 +411,13 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	struct sk_buff_head *list = &sk->sk_receive_queue;
 
 	if (atomic_read(&sk->sk_rmem_alloc) >= sk->sk_rcvbuf) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		trace_sock_rcvqueue_full(sk, skb);
 		return -ENOMEM;
 	}
 
 	if (!sk_rmem_schedule(sk, skb, skb->truesize)) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		return -ENOBUFS;
 	}
 
@@ -463,7 +463,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 	skb->dev = NULL;
 
 	if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		goto discard_and_relse;
 	}
 	if (nested)
@@ -481,7 +481,7 @@ int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 		mutex_release(&sk->sk_lock.dep_map, 1, _RET_IP_);
 	} else if (sk_add_backlog(sk, skb, sk->sk_rcvbuf)) {
 		bh_unlock_sock(sk);
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		goto discard_and_relse;
 	}
 
@@ -1516,7 +1516,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		newsk->sk_dst_cache	= NULL;
 		newsk->sk_wmem_queued	= 0;
 		newsk->sk_forward_alloc = 0;
-		atomic_set(&newsk->sk_drops, 0);
+		atomic_set_wrap(&newsk->sk_drops, 0);
 		newsk->sk_send_head	= NULL;
 		newsk->sk_userlocks	= sk->sk_userlocks & ~SOCK_BINDPORT_LOCK;
 
@@ -1545,7 +1545,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		newsk->sk_err	   = 0;
 		newsk->sk_priority = 0;
 		newsk->sk_incoming_cpu = raw_smp_processor_id();
-		atomic64_set(&newsk->sk_cookie, 0);
+		atomic64_set_wrap(&newsk->sk_cookie, 0);
 
 		mem_cgroup_sk_alloc(newsk);
 		cgroup_sk_alloc(&newsk->sk_cgrp_data);
@@ -2475,7 +2475,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	 */
 	smp_wmb();
 	atomic_set(&sk->sk_refcnt, 1);
-	atomic_set(&sk->sk_drops, 0);
+	atomic_set_wrap(&sk->sk_drops, 0);
 }
 EXPORT_SYMBOL(sock_init_data);
 
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 6b10573..b726bcb 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -22,12 +22,12 @@ static struct workqueue_struct *broadcast_wq;
 static u64 sock_gen_cookie(struct sock *sk)
 {
 	while (1) {
-		u64 res = atomic64_read(&sk->sk_cookie);
+		u64 res = atomic64_read_wrap(&sk->sk_cookie);
 
 		if (res)
 			return res;
-		res = atomic64_inc_return(&sock_net(sk)->cookie_gen);
-		atomic64_cmpxchg(&sk->sk_cookie, 0, res);
+		res = atomic64_inc_return_wrap(&sock_net(sk)->cookie_gen);
+		atomic64_cmpxchg_wrap(&sk->sk_cookie, 0, res);
 	}
 }
 
@@ -67,7 +67,7 @@ int sock_diag_put_meminfo(struct sock *sk, struct sk_buff *skb, int attrtype)
 	mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
 	mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
 	mem[SK_MEMINFO_BACKLOG] = sk->sk_backlog.len;
-	mem[SK_MEMINFO_DROPS] = atomic_read(&sk->sk_drops);
+	mem[SK_MEMINFO_DROPS] = atomic_read_wrap(&sk->sk_drops);
 
 	return nla_put(skb, attrtype, sizeof(mem), &mem);
 }
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 062a67c..19201f0 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1605,7 +1605,7 @@ static int inet_dump_ifaddr(struct sk_buff *skb, struct netlink_callback *cb)
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
+		cb->seq = atomic_read_wrap(&net->ipv4.dev_addr_genid) ^
 			  net->dev_base_seq;
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
@@ -1939,7 +1939,7 @@ static int inet_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv4.dev_addr_genid) ^
+		cb->seq = atomic_read_wrap(&net->ipv4.dev_addr_genid) ^
 			  net->dev_base_seq;
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index c3b8047..f3b24aa 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1122,12 +1122,12 @@ static int fib_inetaddr_event(struct notifier_block *this, unsigned long event,
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 		fib_sync_up(dev, RTNH_F_DEAD);
 #endif
-		atomic_inc(&net->ipv4.dev_addr_genid);
+		atomic_inc_wrap(&net->ipv4.dev_addr_genid);
 		rt_cache_flush(dev_net(dev));
 		break;
 	case NETDEV_DOWN:
 		fib_del_ifaddr(ifa, NULL);
-		atomic_inc(&net->ipv4.dev_addr_genid);
+		atomic_inc_wrap(&net->ipv4.dev_addr_genid);
 		if (!ifa->ifa_dev->ifa_list) {
 			/* Last address was deleted from this interface.
 			 * Disable IP.
@@ -1167,7 +1167,7 @@ static int fib_netdev_event(struct notifier_block *this, unsigned long event, vo
 #ifdef CONFIG_IP_ROUTE_MULTIPATH
 		fib_sync_up(dev, RTNH_F_DEAD);
 #endif
-		atomic_inc(&net->ipv4.dev_addr_genid);
+		atomic_inc_wrap(&net->ipv4.dev_addr_genid);
 		rt_cache_flush(net);
 		break;
 	case NETDEV_DOWN:
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 388d3e2..ab24e60 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -916,7 +916,7 @@ __be32 fib_info_update_nh_saddr(struct net *net, struct fib_nh *nh)
 	nh->nh_saddr = inet_select_addr(nh->nh_dev,
 					nh->nh_gw,
 					nh->nh_parent->fib_scope);
-	nh->nh_saddr_genid = atomic_read(&net->ipv4.dev_addr_genid);
+	nh->nh_saddr_genid = atomic_read_wrap(&net->ipv4.dev_addr_genid);
 
 	return nh->nh_saddr;
 }
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 61a9dee..2d327aa 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -666,8 +666,8 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 		sock_reset_flag(newsk, SOCK_RCU_FREE);
 
 		newsk->sk_mark = inet_rsk(req)->ir_mark;
-		atomic64_set(&newsk->sk_cookie,
-			     atomic64_read(&inet_rsk(req)->ir_cookie));
+		atomic64_set_wrap(&newsk->sk_cookie, atomic64_read_wrap(
+					&inet_rsk(req)->ir_cookie));
 
 		newicsk->icsk_retransmits = 0;
 		newicsk->icsk_backoff	  = 0;
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index ddcd56c..e36fd88 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -186,7 +186,8 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 		tw->tw_ipv6only	    = 0;
 		tw->tw_transparent  = inet->transparent;
 		tw->tw_prot	    = sk->sk_prot_creator;
-		atomic64_set(&tw->tw_cookie, atomic64_read(&sk->sk_cookie));
+		atomic64_set_wrap(&tw->tw_cookie, atomic64_read_wrap(
+					&sk->sk_cookie));
 		twsk_net_set(tw, sock_net(sk));
 		setup_pinned_timer(&tw->tw_timer, tw_timer_handler,
 				   (unsigned long)tw);
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 86fa458..1bd7d85 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -445,7 +445,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 	if (p) {
 		p->daddr = *daddr;
 		atomic_set(&p->refcnt, 1);
-		atomic_set(&p->rid, 0);
+		atomic_set_wrap(&p->rid, 0);
 		p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 		p->rate_tokens = 0;
 		/* 60*HZ is arbitrary, but chosen enough high so that the first
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index bbe7f72..2d58187 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -282,7 +282,7 @@ static int ip_frag_too_far(struct ipq *qp)
 		return 0;
 
 	start = qp->rid;
-	end = atomic_inc_return(&peer->rid);
+	end = atomic_inc_return_wrap(&peer->rid);
 	qp->rid = end;
 
 	rc = qp->q.fragments && (end - start) > max;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 7cf7d6e..5c0a197 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -1119,7 +1119,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
-		atomic_read(&sp->sk_drops));
+		atomic_read_wrap(&sp->sk_drops));
 }
 
 static int ping_v4_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 90a85c9..691dbd3 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -325,7 +325,7 @@ static int raw_rcv_skb(struct sock *sk, struct sk_buff *skb)
 int raw_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
@@ -1029,7 +1029,8 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
-		atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
+		atomic_read(&sp->sk_refcnt), sp,
+			    atomic_read_wrap(&sp->sk_drops));
 }
 
 static int raw_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 62d4d90..099bd83 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -463,7 +463,7 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 
 #define IP_IDENTS_SZ 2048u
 
-static atomic_t *ip_idents __read_mostly;
+static atomic_wrap_t *ip_idents __read_mostly;
 static u32 *ip_tstamps __read_mostly;
 
 /* In order to protect privacy, we add a perturbation to identifiers
@@ -473,7 +473,7 @@ static u32 *ip_tstamps __read_mostly;
 u32 ip_idents_reserve(u32 hash, int segs)
 {
 	u32 *p_tstamp = ip_tstamps + hash % IP_IDENTS_SZ;
-	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
+	atomic_wrap_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
 	u32 old = ACCESS_ONCE(*p_tstamp);
 	u32 now = (u32)jiffies;
 	u32 new, delta = 0;
@@ -483,9 +483,9 @@ u32 ip_idents_reserve(u32 hash, int segs)
 
 	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
 	do {
-		old = (u32)atomic_read(p_id);
+		old = (u32)atomic_read_wrap(p_id);
 		new = old + delta + segs;
-	} while (atomic_cmpxchg(p_id, old, new) != old);
+	} while (atomic_cmpxchg_wrap(p_id, old, new) != old);
 
 	return new - segs;
 }
@@ -2824,8 +2824,8 @@ static __net_initdata struct pernet_operations sysctl_route_ops = {
 
 static __net_init int rt_genid_init(struct net *net)
 {
-	atomic_set(&net->ipv4.rt_genid, 0);
-	atomic_set(&net->fnhe_genid, 0);
+	atomic_set_wrap(&net->ipv4.rt_genid, 0);
+	atomic_set_wrap(&net->fnhe_genid, 0);
 	get_random_bytes(&net->ipv4.dev_addr_genid,
 			 sizeof(net->ipv4.dev_addr_genid));
 	return 0;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index a27b9c0..287f8d1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6215,7 +6215,7 @@ struct request_sock *inet_reqsk_alloc(const struct request_sock_ops *ops,
 #if IS_ENABLED(CONFIG_IPV6)
 		ireq->pktopts = NULL;
 #endif
-		atomic64_set(&ireq->ir_cookie, 0);
+		atomic64_set_wrap(&ireq->ir_cookie, 0);
 		ireq->ireq_state = TCP_NEW_SYN_RECV;
 		write_pnet(&ireq->ireq_net, sock_net(sk_listener));
 		ireq->ireq_family = sk_listener->sk_family;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 7d96dc2..145846f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1194,7 +1194,7 @@ static int first_packet_length(struct sock *sk)
 				IS_UDPLITE(sk));
 		__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
 				IS_UDPLITE(sk));
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		__skb_unlink(skb, rcvq);
 		__skb_queue_tail(&list_kill, skb);
 	}
@@ -1299,7 +1299,7 @@ int udp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 	if (unlikely(err)) {
 		trace_kfree_skb(skb, udp_recvmsg);
 		if (!peeked) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			UDP_INC_STATS(sock_net(sk),
 				      UDP_MIB_INERRORS, is_udplite);
 		}
@@ -1604,7 +1604,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
-	atomic_inc(&sk->sk_drops);
+	atomic_inc_wrap(&sk->sk_drops);
 	kfree_skb(skb);
 	return -1;
 }
@@ -1662,7 +1662,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		nskb = skb_clone(skb, GFP_ATOMIC);
 
 		if (unlikely(!nskb)) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			__UDP_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
 					IS_UDPLITE(sk));
 			__UDP_INC_STATS(net, UDP_MIB_INERRORS,
@@ -2381,7 +2381,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
 		atomic_read(&sp->sk_refcnt), sp,
-		atomic_read(&sp->sk_drops));
+		atomic_read_wrap(&sp->sk_drops));
 }
 
 int udp4_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index d8983e1..1084a86 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -673,7 +673,7 @@ static int inet6_netconf_dump_devconf(struct sk_buff *skb,
 		idx = 0;
 		head = &net->dev_index_head[h];
 		rcu_read_lock();
-		cb->seq = atomic_read(&net->ipv6.dev_addr_genid) ^
+		cb->seq = atomic_read_wrap(&net->ipv6.dev_addr_genid) ^
 			  net->dev_base_seq;
 		hlist_for_each_entry_rcu(dev, head, index_hlist) {
 			if (idx < s_idx)
@@ -4773,7 +4773,8 @@ static int inet6_dump_addr(struct sk_buff *skb, struct netlink_callback *cb,
 	s_ip_idx = ip_idx = cb->args[2];
 
 	rcu_read_lock();
-	cb->seq = atomic_read(&net->ipv6.dev_addr_genid) ^ net->dev_base_seq;
+	cb->seq = atomic_read_wrap(
+			&net->ipv6.dev_addr_genid) ^ net->dev_base_seq;
 	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
 		idx = 0;
 		head = &net->dev_index_head[h];
@@ -5457,7 +5458,7 @@ static void __ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
 		rt_genid_bump_ipv6(net);
 		break;
 	}
-	atomic_inc(&net->ipv6.dev_addr_genid);
+	atomic_inc_wrap(&net->ipv6.dev_addr_genid);
 }
 
 static void ipv6_ifa_notify(int event, struct inet6_ifaddr *ifp)
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 46ad699..635b455 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -796,7 +796,7 @@ static int __net_init inet6_net_init(struct net *net)
 	net->ipv6.sysctl.idgen_retries = 3;
 	net->ipv6.sysctl.idgen_delay = 1 * HZ;
 	net->ipv6.sysctl.flowlabel_state_ranges = 0;
-	atomic_set(&net->ipv6.fib6_sernum, 1);
+	atomic_set_wrap(&net->ipv6.fib6_sernum, 1);
 
 	err = ipv6_init_mibs(net);
 	if (err)
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index 37874e2..05a0e03 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1032,5 +1032,5 @@ void ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
 		   0,
 		   sock_i_ino(sp),
 		   atomic_read(&sp->sk_refcnt), sp,
-		   atomic_read(&sp->sk_drops));
+		   atomic_read_wrap(&sp->sk_drops));
 }
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ef54852..5932a9a 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -98,9 +98,9 @@ static int fib6_new_sernum(struct net *net)
 	int new, old;
 
 	do {
-		old = atomic_read(&net->ipv6.fib6_sernum);
+		old = atomic_read_wrap(&net->ipv6.fib6_sernum);
 		new = old < INT_MAX ? old + 1 : 1;
-	} while (atomic_cmpxchg(&net->ipv6.fib6_sernum,
+	} while (atomic_cmpxchg_wrap(&net->ipv6.fib6_sernum,
 				old, new) != old);
 	return new;
 }
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 54404f0..0fcc926 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -389,7 +389,7 @@ static inline int rawv6_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
 	if ((raw6_sk(sk)->checksum || rcu_access_pointer(sk->sk_filter)) &&
 	    skb_checksum_complete(skb)) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
@@ -417,7 +417,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 	struct raw6_sock *rp = raw6_sk(sk);
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
-		atomic_inc(&sk->sk_drops);
+		atomic_inc_wrap(&sk->sk_drops);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
@@ -441,7 +441,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 
 	if (inet->hdrincl) {
 		if (skb_checksum_complete(skb)) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			kfree_skb(skb);
 			return NET_RX_DROP;
 		}
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 9aa7c1c..45c01a8 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -380,7 +380,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (unlikely(err)) {
 		trace_kfree_skb(skb, udpv6_recvmsg);
 		if (!peeked) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			if (is_udp4)
 				UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
 					      is_udplite);
@@ -646,7 +646,7 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
-	atomic_inc(&sk->sk_drops);
+	atomic_inc_wrap(&sk->sk_drops);
 	kfree_skb(skb);
 	return -1;
 }
@@ -727,7 +727,7 @@ static int __udp6_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
 		}
 		nskb = skb_clone(skb, GFP_ATOMIC);
 		if (unlikely(!nskb)) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			__UDP6_INC_STATS(net, UDP_MIB_RCVBUFERRORS,
 					 IS_UDPLITE(sk));
 			__UDP6_INC_STATS(net, UDP_MIB_INERRORS,
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 02b45a8..16f0511 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -688,10 +688,11 @@ static void __iucv_auto_name(struct iucv_sock *iucv)
 {
 	char name[12];
 
-	sprintf(name, "%08x", atomic_inc_return(&iucv_sk_list.autobind_name));
+	sprintf(name, "%08x", atomic_inc_return_wrap(
+				&iucv_sk_list.autobind_name));
 	while (__iucv_get_sock_by_name(name)) {
 		sprintf(name, "%08x",
-			atomic_inc_return(&iucv_sk_list.autobind_name));
+			atomic_inc_return_wrap(&iucv_sk_list.autobind_name));
 	}
 	memcpy(iucv->src_name, name, 8);
 }
diff --git a/net/key/af_key.c b/net/key/af_key.c
index f9c9ecb..039a50f 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3050,10 +3050,10 @@ static int pfkey_send_policy_notify(struct xfrm_policy *xp, int dir, const struc
 static u32 get_acqseq(void)
 {
 	u32 res;
-	static atomic_t acqseq;
+	static atomic_wrap_t acqseq;
 
 	do {
-		res = atomic_inc_return(&acqseq);
+		res = atomic_inc_return_wrap(&acqseq);
 	} while (!res);
 	return res;
 }
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 965f7e3..aaea87f 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -42,12 +42,12 @@ struct l2tp_eth {
 	struct sock		*tunnel_sock;
 	struct l2tp_session	*session;
 	struct list_head	list;
-	atomic_long_t		tx_bytes;
-	atomic_long_t		tx_packets;
-	atomic_long_t		tx_dropped;
-	atomic_long_t		rx_bytes;
-	atomic_long_t		rx_packets;
-	atomic_long_t		rx_errors;
+	atomic_long_wrap_t	tx_bytes;
+	atomic_long_wrap_t	tx_packets;
+	atomic_long_wrap_t	tx_dropped;
+	atomic_long_wrap_t	rx_bytes;
+	atomic_long_wrap_t	rx_packets;
+	atomic_long_wrap_t	rx_errors;
 };
 
 /* via l2tp_session_priv() */
@@ -98,10 +98,10 @@ static int l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	int ret = l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		atomic_long_add(len, &priv->tx_bytes);
-		atomic_long_inc(&priv->tx_packets);
+		atomic_long_add_wrap(len, &priv->tx_bytes);
+		atomic_long_inc_wrap(&priv->tx_packets);
 	} else {
-		atomic_long_inc(&priv->tx_dropped);
+		atomic_long_inc_wrap(&priv->tx_dropped);
 	}
 	return NETDEV_TX_OK;
 }
@@ -111,12 +111,12 @@ static struct rtnl_link_stats64 *l2tp_eth_get_stats64(struct net_device *dev,
 {
 	struct l2tp_eth *priv = netdev_priv(dev);
 
-	stats->tx_bytes   = atomic_long_read(&priv->tx_bytes);
-	stats->tx_packets = atomic_long_read(&priv->tx_packets);
-	stats->tx_dropped = atomic_long_read(&priv->tx_dropped);
-	stats->rx_bytes   = atomic_long_read(&priv->rx_bytes);
-	stats->rx_packets = atomic_long_read(&priv->rx_packets);
-	stats->rx_errors  = atomic_long_read(&priv->rx_errors);
+	stats->tx_bytes   = atomic_long_read_wrap(&priv->tx_bytes);
+	stats->tx_packets = atomic_long_read_wrap(&priv->tx_packets);
+	stats->tx_dropped = atomic_long_read_wrap(&priv->tx_dropped);
+	stats->rx_bytes   = atomic_long_read_wrap(&priv->rx_bytes);
+	stats->rx_packets = atomic_long_read_wrap(&priv->rx_packets);
+	stats->rx_errors  = atomic_long_read_wrap(&priv->rx_errors);
 	return stats;
 }
 
@@ -167,15 +167,15 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	nf_reset(skb);
 
 	if (dev_forward_skb(dev, skb) == NET_RX_SUCCESS) {
-		atomic_long_inc(&priv->rx_packets);
-		atomic_long_add(data_len, &priv->rx_bytes);
+		atomic_long_inc_wrap(&priv->rx_packets);
+		atomic_long_add_wrap(data_len, &priv->rx_bytes);
 	} else {
-		atomic_long_inc(&priv->rx_errors);
+		atomic_long_inc_wrap(&priv->rx_errors);
 	}
 	return;
 
 error:
-	atomic_long_inc(&priv->rx_errors);
+	atomic_long_inc_wrap(&priv->rx_errors);
 	kfree_skb(skb);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 096a451..8da8794 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -591,7 +591,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	/* Increase the refcnt counter of the dest */
 	ip_vs_dest_hold(dest);
 
-	conn_flags = atomic_read(&dest->conn_flags);
+	conn_flags = atomic_read_wrap(&dest->conn_flags);
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
@@ -945,7 +945,7 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 
 	cp->control = NULL;
 	atomic_set(&cp->n_control, 0);
-	atomic_set(&cp->in_pkts, 0);
+	atomic_set_wrap(&cp->in_pkts, 0);
 
 	cp->packet_xmit = NULL;
 	cp->app = NULL;
@@ -1252,7 +1252,7 @@ static inline int todrop_entry(struct ip_vs_conn *cp)
 
 	/* Don't drop the entry if its number of incoming packets is not
 	   located in [0, 8] */
-	i = atomic_read(&cp->in_pkts);
+	i = atomic_read_wrap(&cp->in_pkts);
 	if (i > 8 || i < 0) return 0;
 
 	if (!todrop_rate[i]) return 0;
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index 2c1b498..a1fdff2 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -613,9 +613,9 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 		/* do not touch skb anymore */
 
 		if ((cp->flags & IP_VS_CONN_F_ONE_PACKET) && cp->control)
-			atomic_inc(&cp->control->in_pkts);
+			atomic_inc_wrap(&cp->control->in_pkts);
 		else
-			atomic_inc(&cp->in_pkts);
+			atomic_inc_wrap(&cp->in_pkts);
 		ip_vs_conn_put(cp);
 		return ret;
 	}
@@ -1991,13 +1991,13 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 	if (cp->flags & IP_VS_CONN_F_ONE_PACKET)
 		pkts = sysctl_sync_threshold(ipvs);
 	else
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_add_return_wrap(1, &cp->in_pkts);
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
 		ip_vs_sync_conn(ipvs, cp, pkts);
 	else if ((cp->flags & IP_VS_CONN_F_ONE_PACKET) && cp->control)
 		/* increment is done inside ip_vs_sync_conn too */
-		atomic_inc(&cp->control->in_pkts);
+		atomic_inc_wrap(&cp->control->in_pkts);
 
 	ip_vs_conn_put(cp);
 	return ret;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index c3c809b..534e6a1 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -841,7 +841,7 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
 		 */
 		ip_vs_rs_hash(ipvs, dest);
 	}
-	atomic_set(&dest->conn_flags, conn_flags);
+	atomic_set_wrap(&dest->conn_flags, conn_flags);
 
 	/* bind the service */
 	old_svc = rcu_dereference_protected(dest->svc, 1);
@@ -2083,7 +2083,8 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 					   "      %-7s %-6d %-10d %-10d\n",
 					   &dest->addr.in6,
 					   ntohs(dest->port),
-					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
+					   ip_vs_fwd_name(atomic_read_wrap(
+							   &dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
 					   atomic_read(&dest->inactconns));
@@ -2094,7 +2095,8 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 					   "%-7s %-6d %-10d %-10d\n",
 					   ntohl(dest->addr.ip),
 					   ntohs(dest->port),
-					   ip_vs_fwd_name(atomic_read(&dest->conn_flags)),
+					   ip_vs_fwd_name(atomic_read_wrap(
+							   &dest->conn_flags)),
 					   atomic_read(&dest->weight),
 					   atomic_read(&dest->activeconns),
 					   atomic_read(&dest->inactconns));
@@ -2603,7 +2605,7 @@ __ip_vs_get_dest_entries(struct netns_ipvs *ipvs, const struct ip_vs_get_dests *
 
 			entry.addr = dest->addr.ip;
 			entry.port = dest->port;
-			entry.conn_flags = atomic_read(&dest->conn_flags);
+			entry.conn_flags = atomic_read_wrap(&dest->conn_flags);
 			entry.weight = atomic_read(&dest->weight);
 			entry.u_threshold = dest->u_threshold;
 			entry.l_threshold = dest->l_threshold;
@@ -3196,7 +3198,7 @@ static int ip_vs_genl_fill_dest(struct sk_buff *skb, struct ip_vs_dest *dest)
 	if (nla_put(skb, IPVS_DEST_ATTR_ADDR, sizeof(dest->addr), &dest->addr) ||
 	    nla_put_be16(skb, IPVS_DEST_ATTR_PORT, dest->port) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_FWD_METHOD,
-			(atomic_read(&dest->conn_flags) &
+			(atomic_read_wrap(&dest->conn_flags) &
 			 IP_VS_CONN_F_FWD_MASK)) ||
 	    nla_put_u32(skb, IPVS_DEST_ATTR_WEIGHT,
 			atomic_read(&dest->weight)) ||
diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 1b07578..c469cad 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -611,7 +611,7 @@ static void ip_vs_sync_conn_v0(struct netns_ipvs *ipvs, struct ip_vs_conn *cp,
 	cp = cp->control;
 	if (cp) {
 		if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-			pkts = atomic_add_return(1, &cp->in_pkts);
+			pkts = atomic_add_return_wrap(1, &cp->in_pkts);
 		else
 			pkts = sysctl_sync_threshold(ipvs);
 		ip_vs_sync_conn(ipvs, cp, pkts);
@@ -772,7 +772,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
 	if (!cp)
 		return;
 	if (cp->flags & IP_VS_CONN_F_TEMPLATE)
-		pkts = atomic_add_return(1, &cp->in_pkts);
+		pkts = atomic_add_return_wrap(1, &cp->in_pkts);
 	else
 		pkts = sysctl_sync_threshold(ipvs);
 	goto sloop;
@@ -919,7 +919,7 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 
 	if (opt)
 		memcpy(&cp->in_seq, opt, sizeof(*opt));
-	atomic_set(&cp->in_pkts, sysctl_sync_threshold(ipvs));
+	atomic_set_wrap(&cp->in_pkts, sysctl_sync_threshold(ipvs));
 	cp->state = state;
 	cp->old_state = cp->state;
 	/*
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 01d3d89..91d3157 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -1255,7 +1255,7 @@ ip_vs_icmp_xmit(struct sk_buff *skb, struct ip_vs_conn *cp,
 		else
 			rc = NF_ACCEPT;
 		/* do not touch skb anymore */
-		atomic_inc(&cp->in_pkts);
+		atomic_inc_wrap(&cp->in_pkts);
 		goto out;
 	}
 
@@ -1348,7 +1348,7 @@ ip_vs_icmp_xmit_v6(struct sk_buff *skb, struct ip_vs_conn *cp,
 		else
 			rc = NF_ACCEPT;
 		/* do not touch skb anymore */
-		atomic_inc(&cp->in_pkts);
+		atomic_inc_wrap(&cp->in_pkts);
 		goto out;
 	}
 
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index eb086a1..5d38f7c 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -85,7 +85,7 @@ static int nfnl_log_net_id __read_mostly;
 struct nfnl_log_net {
 	spinlock_t instances_lock;
 	struct hlist_head instance_table[INSTANCE_BUCKETS];
-	atomic_t global_seq;
+	atomic_wrap_t global_seq;
 };
 
 static struct nfnl_log_net *nfnl_log_pernet(struct net *net)
@@ -574,7 +574,7 @@ __build_packet_message(struct nfnl_log_net *log,
 	/* global sequence number */
 	if ((inst->flags & NFULNL_CFG_F_SEQ_GLOBAL) &&
 	    nla_put_be32(inst->skb, NFULA_SEQ_GLOBAL,
-			 htonl(atomic_inc_return(&log->global_seq))))
+			 htonl(atomic_inc_return_wrap(&log->global_seq))))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(inst->skb, ct, ctinfo,
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 11de55e..03793c1 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -19,7 +19,7 @@
 #include <linux/module.h>
 
 struct xt_statistic_priv {
-	atomic_t count;
+	atomic_wrap_t count;
 } ____cacheline_aligned_in_smp;
 
 MODULE_LICENSE("GPL");
@@ -42,9 +42,10 @@ statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		break;
 	case XT_STATISTIC_MODE_NTH:
 		do {
-			oval = atomic_read(&info->master->count);
+			oval = atomic_read_wrap(&info->master->count);
 			nval = (oval == info->u.nth.every) ? 0 : oval + 1;
-		} while (atomic_cmpxchg(&info->master->count, oval, nval) != oval);
+		} while (atomic_cmpxchg_wrap(&info->master->count, oval, nval)
+				!= oval);
 		if (nval == 0)
 			ret = !ret;
 		break;
@@ -64,7 +65,7 @@ static int statistic_mt_check(const struct xt_mtchk_param *par)
 	info->master = kzalloc(sizeof(*info->master), GFP_KERNEL);
 	if (info->master == NULL)
 		return -ENOMEM;
-	atomic_set(&info->master->count, info->u.nth.count);
+	atomic_set_wrap(&info->master->count, info->u.nth.count);
 
 	return 0;
 }
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 62bea45..6be0c73 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -287,7 +287,7 @@ static void netlink_overrun(struct sock *sk)
 			sk->sk_error_report(sk);
 		}
 	}
-	atomic_inc(&sk->sk_drops);
+	atomic_inc_wrap(&sk->sk_drops);
 }
 
 static void netlink_rcv_wake(struct sock *sk)
@@ -2453,7 +2453,7 @@ static int netlink_seq_show(struct seq_file *seq, void *v)
 			   sk_wmem_alloc_get(s),
 			   nlk->cb_running,
 			   atomic_read(&s->sk_refcnt),
-			   atomic_read(&s->sk_drops),
+			   atomic_read_wrap(&s->sk_drops),
 			   sock_i_ino(s)
 			);
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 11db0d6..c54c6a2 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -279,7 +279,7 @@ static int packet_direct_xmit(struct sk_buff *skb)
 
 	return ret;
 drop:
-	atomic_long_inc(&dev->tx_dropped);
+	atomic_long_inc_wrap(&dev->tx_dropped);
 	kfree_skb(skb);
 	return NET_XMIT_DROP;
 }
@@ -2107,7 +2107,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 	is_drop_n_account = true;
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.stats1.tp_drops++;
-	atomic_inc(&sk->sk_drops);
+	atomic_inc_wrap(&sk->sk_drops);
 	spin_unlock(&sk->sk_receive_queue.lock);
 
 drop_n_restore:
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 850a86c..88fda61 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -388,7 +388,7 @@ static int pipe_do_rcv(struct sock *sk, struct sk_buff *skb)
 
 	case PNS_PEP_CTRL_REQ:
 		if (skb_queue_len(&pn->ctrlreq_queue) >= PNPIPE_CTRLREQ_MAX) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			break;
 		}
 		__skb_pull(skb, 4);
@@ -409,7 +409,7 @@ static int pipe_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 
 		if (pn->rx_credits == 0) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			err = -ENOBUFS;
 			break;
 		}
@@ -579,7 +579,7 @@ static int pipe_handler_do_rcv(struct sock *sk, struct sk_buff *skb)
 		}
 
 		if (pn->rx_credits == 0) {
-			atomic_inc(&sk->sk_drops);
+			atomic_inc_wrap(&sk->sk_drops);
 			err = NET_RX_DROP;
 			break;
 		}
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index ffd5f22..1d29fab 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -613,7 +613,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 			from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			sock_i_ino(sk),
 			atomic_read(&sk->sk_refcnt), sk,
-			atomic_read(&sk->sk_drops));
+			atomic_read_wrap(&sk->sk_drops));
 	}
 	seq_pad(seq, '\n');
 	return 0;
diff --git a/net/rds/cong.c b/net/rds/cong.c
index 8398fee..1dcd60a 100644
--- a/net/rds/cong.c
+++ b/net/rds/cong.c
@@ -78,7 +78,7 @@
  * finds that the saved generation number is smaller than the global generation
  * number, it wakes up the process.
  */
-static atomic_t		rds_cong_generation = ATOMIC_INIT(0);
+static atomic_wrap_t		rds_cong_generation = ATOMIC_INIT(0);
 
 /*
  * Congestion monitoring
@@ -248,7 +248,7 @@ void rds_cong_map_updated(struct rds_cong_map *map, uint64_t portmask)
 	rdsdebug("waking map %p for %pI4\n",
 	  map, &map->m_addr);
 	rds_stats_inc(s_cong_update_received);
-	atomic_inc(&rds_cong_generation);
+	atomic_inc_wrap(&rds_cong_generation);
 	if (waitqueue_active(&map->m_waitq))
 		wake_up(&map->m_waitq);
 	if (waitqueue_active(&rds_poll_waitq))
@@ -274,7 +274,7 @@ EXPORT_SYMBOL_GPL(rds_cong_map_updated);
 
 int rds_cong_updated_since(unsigned long *recent)
 {
-	unsigned long gen = atomic_read(&rds_cong_generation);
+	unsigned long gen = atomic_read_wrap(&rds_cong_generation);
 
 	if (likely(*recent == gen))
 		return 0;
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 45ac8e8..bddbee2 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -153,7 +153,7 @@ struct rds_ib_connection {
 	/* sending acks */
 	unsigned long		i_ack_flags;
 #ifdef KERNEL_HAS_ATOMIC64
-	atomic64_t		i_ack_next;	/* next ACK to send */
+	atomic64_wrap_t		i_ack_next;	/* next ACK to send */
 #else
 	spinlock_t		i_ack_lock;	/* protect i_ack_next */
 	u64			i_ack_next;	/* next ACK to send */
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 5b2ab95..afad870 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -833,7 +833,7 @@ void rds_ib_conn_path_shutdown(struct rds_conn_path *cp)
 	/* Clear the ACK state */
 	clear_bit(IB_ACK_IN_FLIGHT, &ic->i_ack_flags);
 #ifdef KERNEL_HAS_ATOMIC64
-	atomic64_set(&ic->i_ack_next, 0);
+	atomic64_set_wrap(&ic->i_ack_next, 0);
 #else
 	ic->i_ack_next = 0;
 #endif
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 606a11f..402212a 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -624,7 +624,7 @@ static u64 rds_ib_get_ack(struct rds_ib_connection *ic)
 #else
 void rds_ib_set_ack(struct rds_ib_connection *ic, u64 seq, int ack_required)
 {
-	atomic64_set(&ic->i_ack_next, seq);
+	atomic64_set_wrap(&ic->i_ack_next, seq);
 	if (ack_required) {
 		smp_mb__before_atomic();
 		set_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
@@ -636,7 +636,7 @@ static u64 rds_ib_get_ack(struct rds_ib_connection *ic)
 	clear_bit(IB_ACK_REQUESTED, &ic->i_ack_flags);
 	smp_mb__after_atomic();
 
-	return atomic64_read(&ic->i_ack_next);
+	return atomic64_read_wrap(&ic->i_ack_next);
 }
 #endif
 
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 2d59c9b..1e71e8c 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -42,7 +42,7 @@ static const struct proto_ops rxrpc_rpc_ops;
 u32 rxrpc_epoch;
 
 /* current debugging ID */
-atomic_t rxrpc_debug_id;
+atomic_wrap_t rxrpc_debug_id;
 
 /* count of skbs currently in use */
 atomic_t rxrpc_n_tx_skbs, rxrpc_n_rx_skbs;
diff --git a/net/rxrpc/ar-internal.h b/net/rxrpc/ar-internal.h
index f60e355..1167749 100644
--- a/net/rxrpc/ar-internal.h
+++ b/net/rxrpc/ar-internal.h
@@ -379,7 +379,7 @@ struct rxrpc_connection {
 	u32			local_abort;	/* local abort code */
 	u32			remote_abort;	/* remote abort code */
 	int			debug_id;	/* debug ID for printks */
-	atomic_t		serial;		/* packet serial number counter */
+	atomic_wrap_t		serial;		/* packet serial number counter */
 	unsigned int		hi_serial;	/* highest serial number received */
 	u32			security_nonce;	/* response re-use preventer */
 	u8			size_align;	/* data size alignment (for security) */
@@ -794,7 +794,7 @@ extern const char rxrpc_ack_names[RXRPC_ACK__INVALID + 1][4];
  */
 extern atomic_t rxrpc_n_tx_skbs, rxrpc_n_rx_skbs;
 extern u32 rxrpc_epoch;
-extern atomic_t rxrpc_debug_id;
+extern atomic_wrap_t rxrpc_debug_id;
 extern struct workqueue_struct *rxrpc_workqueue;
 
 /*
diff --git a/net/rxrpc/call_object.c b/net/rxrpc/call_object.c
index 4353a29..3a0573d 100644
--- a/net/rxrpc/call_object.c
+++ b/net/rxrpc/call_object.c
@@ -145,7 +145,7 @@ struct rxrpc_call *rxrpc_alloc_call(gfp_t gfp)
 	spin_lock_init(&call->lock);
 	rwlock_init(&call->state_lock);
 	atomic_set(&call->usage, 1);
-	call->debug_id = atomic_inc_return(&rxrpc_debug_id);
+	call->debug_id = atomic_inc_return_wrap(&rxrpc_debug_id);
 
 	memset(&call->sock_node, 0xed, sizeof(call->sock_node));
 
diff --git a/net/rxrpc/conn_event.c b/net/rxrpc/conn_event.c
index 3f9d8d7..53bc973 100644
--- a/net/rxrpc/conn_event.c
+++ b/net/rxrpc/conn_event.c
@@ -112,7 +112,7 @@ static void rxrpc_conn_retransmit_call(struct rxrpc_connection *conn,
 	iov.iov_base	= &pkt;
 	iov.iov_len	= len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	pkt.whdr.serial = htonl(serial);
 
 	switch (chan->last_type) {
@@ -219,7 +219,7 @@ static int rxrpc_abort_connection(struct rxrpc_connection *conn,
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	whdr.serial = htonl(serial);
 	_proto("Tx CONN ABORT %%%u { %d }", serial, conn->local_abort);
 
diff --git a/net/rxrpc/conn_object.c b/net/rxrpc/conn_object.c
index e1e83af..728d25f 100644
--- a/net/rxrpc/conn_object.c
+++ b/net/rxrpc/conn_object.c
@@ -51,7 +51,7 @@ struct rxrpc_connection *rxrpc_alloc_connection(gfp_t gfp)
 		skb_queue_head_init(&conn->rx_queue);
 		conn->security = &rxrpc_no_security;
 		spin_lock_init(&conn->state_lock);
-		conn->debug_id = atomic_inc_return(&rxrpc_debug_id);
+		conn->debug_id = atomic_inc_return_wrap(&rxrpc_debug_id);
 		conn->size_align = 4;
 		conn->idle_timestamp = jiffies;
 	}
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ff4864d..49556dc 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -93,7 +93,7 @@ static struct rxrpc_local *rxrpc_alloc_local(const struct sockaddr_rxrpc *srx)
 		spin_lock_init(&local->client_conns_lock);
 		spin_lock_init(&local->lock);
 		rwlock_init(&local->services_lock);
-		local->debug_id = atomic_inc_return(&rxrpc_debug_id);
+		local->debug_id = atomic_inc_return_wrap(&rxrpc_debug_id);
 		memcpy(&local->srx, srx, sizeof(*srx));
 	}
 
diff --git a/net/rxrpc/output.c b/net/rxrpc/output.c
index 5dab1ff..77481b9 100644
--- a/net/rxrpc/output.c
+++ b/net/rxrpc/output.c
@@ -158,7 +158,7 @@ int rxrpc_send_ack_packet(struct rxrpc_call *call, bool ping)
 	iov[1].iov_len	= sizeof(pkt->ackinfo);
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	pkt->whdr.serial = htonl(serial);
 	trace_rxrpc_tx_ack(call, serial,
 			   ntohl(pkt->ack.firstPacket),
@@ -249,7 +249,7 @@ int rxrpc_send_abort_packet(struct rxrpc_call *call)
 	iov[0].iov_base	= &pkt;
 	iov[0].iov_len	= sizeof(pkt);
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	pkt.whdr.serial = htonl(serial);
 
 	ret = kernel_sendmsg(conn->params.local->socket,
@@ -278,7 +278,7 @@ int rxrpc_send_data_packet(struct rxrpc_call *call, struct sk_buff *skb,
 	_enter(",{%d}", skb->len);
 
 	/* Each transmission of a Tx packet needs a new serial number */
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 
 	whdr.epoch	= htonl(conn->proto.epoch);
 	whdr.cid	= htonl(call->cid);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 941b724..58cee86 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -229,7 +229,7 @@ struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
 		peer->service_conns = RB_ROOT;
 		seqlock_init(&peer->service_conn_lock);
 		spin_lock_init(&peer->lock);
-		peer->debug_id = atomic_inc_return(&rxrpc_debug_id);
+		peer->debug_id = atomic_inc_return_wrap(&rxrpc_debug_id);
 	}
 
 	_leave(" = %p", peer);
diff --git a/net/rxrpc/proc.c b/net/rxrpc/proc.c
index 65cd980..72e34c3 100644
--- a/net/rxrpc/proc.c
+++ b/net/rxrpc/proc.c
@@ -176,7 +176,7 @@ static int rxrpc_connection_seq_show(struct seq_file *seq, void *v)
 		   atomic_read(&conn->usage),
 		   rxrpc_conn_states[conn->state],
 		   key_serial(conn->params.key),
-		   atomic_read(&conn->serial),
+		   atomic_read_wrap(&conn->serial),
 		   conn->hi_serial);
 
 	return 0;
diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 4374e7b..6b28698 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -636,7 +636,7 @@ static int rxkad_issue_challenge(struct rxrpc_connection *conn)
 
 	len = iov[0].iov_len + iov[1].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	whdr.serial = htonl(serial);
 	_proto("Tx CHALLENGE %%%u", serial);
 
@@ -690,7 +690,7 @@ static int rxkad_send_response(struct rxrpc_connection *conn,
 
 	len = iov[0].iov_len + iov[1].iov_len + iov[2].iov_len;
 
-	serial = atomic_inc_return(&conn->serial);
+	serial = atomic_inc_return_wrap(&conn->serial);
 	whdr.serial = htonl(serial);
 	_proto("Tx RESPONSE %%%u", serial);
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6cfb6e9..0977283 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -362,7 +362,7 @@ void netif_carrier_on(struct net_device *dev)
 	if (test_and_clear_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
 		if (dev->reg_state == NETREG_UNINITIALIZED)
 			return;
-		atomic_inc(&dev->carrier_changes);
+		atomic_inc_wrap(&dev->carrier_changes);
 		linkwatch_fire_event(dev);
 		if (netif_running(dev))
 			__netdev_watchdog_up(dev);
@@ -381,7 +381,7 @@ void netif_carrier_off(struct net_device *dev)
 	if (!test_and_set_bit(__LINK_STATE_NOCARRIER, &dev->state)) {
 		if (dev->reg_state == NETREG_UNINITIALIZED)
 			return;
-		atomic_inc(&dev->carrier_changes);
+		atomic_inc_wrap(&dev->carrier_changes);
 		linkwatch_fire_event(dev);
 	}
 }
diff --git a/net/sctp/sctp_diag.c b/net/sctp/sctp_diag.c
index 048954e..2c61be1 100644
--- a/net/sctp/sctp_diag.c
+++ b/net/sctp/sctp_diag.c
@@ -157,7 +157,7 @@ static int inet_sctp_diag_fill(struct sock *sk, struct sctp_association *asoc,
 		mem[SK_MEMINFO_WMEM_QUEUED] = sk->sk_wmem_queued;
 		mem[SK_MEMINFO_OPTMEM] = atomic_read(&sk->sk_omem_alloc);
 		mem[SK_MEMINFO_BACKLOG] = sk->sk_backlog.len;
-		mem[SK_MEMINFO_DROPS] = atomic_read(&sk->sk_drops);
+		mem[SK_MEMINFO_DROPS] = atomic_read_wrap(&sk->sk_drops);
 
 		if (nla_put(skb, INET_DIAG_SKMEMINFO, sizeof(mem), &mem) < 0)
 			goto errout;
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index d67f7e1..a2f90b0 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1142,7 +1142,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 				uint64_t *handle)
 {
 	struct rsc rsci, *rscp = NULL;
-	static atomic64_t ctxhctr;
+	static atomic64_wrap_t ctxhctr = ATOMIC64_INIT(0);
 	long long ctxh;
 	struct gss_api_mech *gm = NULL;
 	time_t expiry;
@@ -1153,7 +1153,7 @@ static int gss_proxy_save_rsc(struct cache_detail *cd,
 	status = -ENOMEM;
 	/* the handle needs to be just a unique id,
 	 * use a static counter */
-	ctxh = atomic64_inc_return(&ctxhctr);
+	ctxh = atomic64_inc_return_wrap(&ctxhctr);
 
 	/* make a copy for the caller */
 	*handle = ctxh;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 5db68b3..3dc6567 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -262,9 +262,9 @@ static int rpc_wait_bit_killable(struct wait_bit_key *key, int mode)
 #if IS_ENABLED(CONFIG_SUNRPC_DEBUG) || IS_ENABLED(CONFIG_TRACEPOINTS)
 static void rpc_task_set_debuginfo(struct rpc_task *task)
 {
-	static atomic_t rpc_pid;
+	static atomic_wrap_t rpc_pid;
 
-	task->tk_pid = atomic_inc_return(&rpc_pid);
+	task->tk_pid = atomic_inc_return_wrap(&rpc_pid);
 }
 #else
 static inline void rpc_task_set_debuginfo(struct rpc_task *task)
diff --git a/net/sunrpc/xprtrdma/svc_rdma.c b/net/sunrpc/xprtrdma/svc_rdma.c
index c846ca9..211919a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma.c
+++ b/net/sunrpc/xprtrdma/svc_rdma.c
@@ -62,15 +62,15 @@ unsigned int svcrdma_max_req_size = RPCRDMA_MAX_REQ_SIZE;
 static unsigned int min_max_inline = 4096;
 static unsigned int max_max_inline = 65536;
 
-atomic_t rdma_stat_recv;
-atomic_t rdma_stat_read;
-atomic_t rdma_stat_write;
-atomic_t rdma_stat_sq_starve;
-atomic_t rdma_stat_rq_starve;
-atomic_t rdma_stat_rq_poll;
-atomic_t rdma_stat_rq_prod;
-atomic_t rdma_stat_sq_poll;
-atomic_t rdma_stat_sq_prod;
+atomic_wrap_t rdma_stat_recv;
+atomic_wrap_t rdma_stat_read;
+atomic_wrap_t rdma_stat_write;
+atomic_wrap_t rdma_stat_sq_starve;
+atomic_wrap_t rdma_stat_rq_starve;
+atomic_wrap_t rdma_stat_rq_poll;
+atomic_wrap_t rdma_stat_rq_prod;
+atomic_wrap_t rdma_stat_sq_poll;
+atomic_wrap_t rdma_stat_sq_prod;
 
 struct workqueue_struct *svc_rdma_wq;
 
@@ -147,63 +147,63 @@ static struct ctl_table svcrdma_parm_table[] = {
 	{
 		.procname	= "rdma_stat_read",
 		.data		= &rdma_stat_read,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_recv",
 		.data		= &rdma_stat_recv,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_write",
 		.data		= &rdma_stat_write,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_starve",
 		.data		= &rdma_stat_sq_starve,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_starve",
 		.data		= &rdma_stat_rq_starve,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_poll",
 		.data		= &rdma_stat_rq_poll,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_rq_prod",
 		.data		= &rdma_stat_rq_prod,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_poll",
 		.data		= &rdma_stat_sq_poll,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
 	{
 		.procname	= "rdma_stat_sq_prod",
 		.data		= &rdma_stat_sq_prod,
-		.maxlen		= sizeof(atomic_t),
+		.maxlen		= sizeof(atomic_wrap_t),
 		.mode		= 0644,
 		.proc_handler	= read_reset_stat,
 	},
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index ad1df97..cfba859 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -200,7 +200,7 @@ int rdma_read_chunk_lcl(struct svcxprt_rdma *xprt,
 	*page_no = pg_no;
 	*page_offset = pg_off;
 	ret = read;
-	atomic_inc(&rdma_stat_read);
+	atomic_inc_wrap(&rdma_stat_read);
 	return ret;
  err:
 	svc_rdma_unmap_dma(ctxt);
@@ -345,7 +345,7 @@ int rdma_read_chunk_frmr(struct svcxprt_rdma *xprt,
 	*page_no = pg_no;
 	*page_offset = pg_off;
 	ret = read;
-	atomic_inc(&rdma_stat_read);
+	atomic_inc_wrap(&rdma_stat_read);
 	return ret;
  err:
 	ib_dma_unmap_sg(xprt->sc_cm_id->device,
@@ -612,7 +612,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 				  dto_q);
 		list_del_init(&ctxt->dto_q);
 	} else {
-		atomic_inc(&rdma_stat_rq_starve);
+		atomic_inc_wrap(&rdma_stat_rq_starve);
 		clear_bit(XPT_DATA, &xprt->xpt_flags);
 		ctxt = NULL;
 	}
@@ -629,7 +629,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 	}
 	dprintk("svcrdma: processing ctxt=%p on xprt=%p, rqstp=%p, status=%d\n",
 		ctxt, rdma_xprt, rqstp, ctxt->wc_status);
-	atomic_inc(&rdma_stat_recv);
+	atomic_inc_wrap(&rdma_stat_recv);
 
 	/* Build up the XDR from the receive buffers. */
 	rdma_build_arg_xdr(rqstp, ctxt, ctxt->byte_len);
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index f5a91ed..4612251 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -349,7 +349,7 @@ static int send_write(struct svcxprt_rdma *xprt, struct svc_rqst *rqstp,
 	write_wr.remote_addr = to;
 
 	/* Post It */
-	atomic_inc(&rdma_stat_write);
+	atomic_inc_wrap(&rdma_stat_write);
 	if (svc_rdma_send(xprt, &write_wr.wr))
 		goto err;
 	return write_len - bc;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 6864fb9..7457aae 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -1336,7 +1336,7 @@ int svc_rdma_send(struct svcxprt_rdma *xprt, struct ib_send_wr *wr)
 		spin_lock_bh(&xprt->sc_lock);
 		if (xprt->sc_sq_depth < atomic_read(&xprt->sc_sq_count) + wr_count) {
 			spin_unlock_bh(&xprt->sc_lock);
-			atomic_inc(&rdma_stat_sq_starve);
+			atomic_inc_wrap(&rdma_stat_sq_starve);
 
 			/* Wait until SQ WR available if SQ still full */
 			wait_event(xprt->sc_send_wait,
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index fd69866..c8d30df 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -338,7 +338,7 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)
 {
 	policy->walk.dead = 1;
 
-	atomic_inc(&policy->genid);
+	atomic_inc_wrap(&policy->genid);
 
 	if (del_timer(&policy->polq.hold_timer))
 		xfrm_pol_put(policy);
@@ -803,7 +803,7 @@ int xfrm_policy_insert(int dir, struct xfrm_policy *policy, int excl)
 	else
 		hlist_add_head(&policy->bydst, chain);
 	__xfrm_policy_link(policy, dir);
-	atomic_inc(&net->xfrm.flow_cache_genid);
+	atomic_inc_wrap(&net->xfrm.flow_cache_genid);
 
 	/* After previous checking, family can either be AF_INET or AF_INET6 */
 	if (policy->family == AF_INET)
@@ -1926,7 +1926,7 @@ xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 
 	xdst->num_pols = num_pols;
 	memcpy(xdst->pols, pols, sizeof(struct xfrm_policy *) * num_pols);
-	xdst->policy_genid = atomic_read(&pols[0]->genid);
+	xdst->policy_genid = atomic_read_wrap(&pols[0]->genid);
 
 	return xdst;
 }
@@ -2793,7 +2793,8 @@ static int xfrm_bundle_ok(struct xfrm_dst *first)
 		if (xdst->xfrm_genid != dst->xfrm->genid)
 			return 0;
 		if (xdst->num_pols > 0 &&
-		    xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
+		    xdst->policy_genid !=
+				atomic_read_wrap(&xdst->pols[0]->genid))
 			return 0;
 
 		mtu = dst_mtu(dst->child);
@@ -3297,7 +3298,7 @@ static int xfrm_policy_migrate(struct xfrm_policy *pol,
 			       sizeof(pol->xfrm_vec[i].saddr));
 			pol->xfrm_vec[i].encap_family = mp->new_family;
 			/* flush bundles */
-			atomic_inc(&pol->genid);
+			atomic_inc_wrap(&pol->genid);
 		}
 	}
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 419bf5d..46d5ef2 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1543,10 +1543,10 @@ EXPORT_SYMBOL(xfrm_find_acq_byseq);
 u32 xfrm_get_acqseq(void)
 {
 	u32 res;
-	static atomic_t acqseq;
+	static atomic_wrap_t acqseq;
 
 	do {
-		res = atomic_inc_return(&acqseq);
+		res = atomic_inc_return_wrap(&acqseq);
 	} while (!res);
 
 	return res;
diff --git a/security/selinux/include/xfrm.h b/security/selinux/include/xfrm.h
index 1450f85..056dfe8 100644
--- a/security/selinux/include/xfrm.h
+++ b/security/selinux/include/xfrm.h
@@ -48,7 +48,7 @@ static inline void selinux_xfrm_notify_policyload(void)
 
 	rtnl_lock();
 	for_each_net(net) {
-		atomic_inc(&net->xfrm.flow_cache_genid);
+		atomic_inc_wrap(&net->xfrm.flow_cache_genid);
 		rt_genid_bump_all(net);
 	}
 	rtnl_unlock();
-- 
2.7.4
