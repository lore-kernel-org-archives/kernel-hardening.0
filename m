Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:38 +0200
Message-Id: <1484730707-29313-10-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 09/18] net: convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/algif_aead.c                                |  2 +-
 drivers/atm/fore200e.c                             | 13 +++------
 drivers/atm/he.c                                   |  2 +-
 drivers/atm/idt77252.c                             |  4 +--
 drivers/infiniband/hw/nes/nes_cm.c                 |  4 +--
 drivers/isdn/mISDN/socket.c                        |  2 +-
 drivers/net/rionet.c                               |  2 +-
 drivers/net/vxlan.c                                | 10 +++----
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |  8 ++---
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |  4 +--
 .../net/wireless/intersil/hostap/hostap_80211_rx.c |  8 ++---
 .../net/wireless/intersil/hostap/hostap_80211_tx.c |  4 +--
 drivers/s390/net/ctcm_main.c                       | 26 ++++++++---------
 drivers/s390/net/netiucv.c                         | 10 +++----
 drivers/s390/net/qeth_core_main.c                  |  4 +--
 drivers/scsi/cxgbi/libcxgbi.h                      |  2 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |  8 ++---
 drivers/staging/rtl8192e/rtllib_tx.c               |  4 +--
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.c   |  2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_crypt.h   |  3 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  8 ++---
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |  4 +--
 include/linux/atmdev.h                             |  9 +++---
 include/linux/ceph/libceph.h                       |  3 +-
 include/linux/ceph/osd_client.h                    |  3 +-
 include/linux/ceph/pagelist.h                      |  6 ++--
 include/linux/filter.h                             |  3 +-
 include/linux/igmp.h                               |  3 +-
 include/linux/inetdevice.h                         | 11 +++----
 include/linux/netpoll.h                            |  3 +-
 include/linux/skbuff.h                             | 23 ++++++++-------
 include/linux/sunrpc/auth.h                        |  8 ++---
 include/linux/sunrpc/auth_gss.h                    |  3 +-
 include/net/addrconf.h                             | 14 ++++-----
 include/net/af_unix.h                              |  3 +-
 include/net/arp.h                                  |  2 +-
 include/net/ax25.h                                 | 20 ++++++-------
 include/net/bluetooth/hci_core.h                   | 10 +++----
 include/net/bluetooth/rfcomm.h                     |  8 +++--
 include/net/calipso.h                              |  4 +--
 include/net/cipso_ipv4.h                           |  3 +-
 include/net/dn_fib.h                               |  5 ++--
 include/net/fib_rules.h                            |  7 +++--
 include/net/if_inet6.h                             |  9 +++---
 include/net/inet_frag.h                            |  4 +--
 include/net/inet_hashtables.h                      |  4 +--
 include/net/inetpeer.h                             |  4 +--
 include/net/ip_fib.h                               |  7 +++--
 include/net/ip_vs.h                                | 24 ++++++++-------
 include/net/ipv6.h                                 |  7 +++--
 include/net/ipx.h                                  | 13 +++++----
 include/net/lapb.h                                 |  3 +-
 include/net/lib80211.h                             |  2 +-
 include/net/llc.h                                  |  6 ++--
 include/net/lwtunnel.h                             |  7 +++--
 include/net/ndisc.h                                |  2 +-
 include/net/neighbour.h                            | 15 +++++-----
 include/net/net_namespace.h                        |  3 +-
 include/net/netfilter/br_netfilter.h               |  2 +-
 include/net/netfilter/nf_conntrack_expect.h        |  4 ++-
 include/net/netfilter/nf_conntrack_timeout.h       |  3 +-
 include/net/netlabel.h                             |  8 ++---
 include/net/netrom.h                               | 13 +++++----
 include/net/request_sock.h                         |  9 +++---
 include/net/sch_generic.h                          |  3 +-
 include/net/sctp/auth.h                            |  5 ++--
 include/net/sctp/structs.h                         |  8 ++---
 include/net/sock.h                                 | 25 ++++++++--------
 include/net/vxlan.h                                |  2 +-
 include/net/x25.h                                  | 15 +++++-----
 include/net/xfrm.h                                 | 21 ++++++-------
 net/atm/br2684.c                                   |  2 +-
 net/atm/clip.c                                     |  8 ++---
 net/atm/common.c                                   | 10 +++----
 net/atm/lec.c                                      | 11 +++----
 net/atm/lec_arpc.h                                 |  2 +-
 net/atm/mpc.c                                      |  4 +--
 net/atm/mpoa_caches.c                              | 26 ++++++++---------
 net/atm/mpoa_caches.h                              |  5 ++--
 net/atm/pppoatm.c                                  |  2 +-
 net/atm/proc.c                                     |  4 +--
 net/atm/raw.c                                      |  2 +-
 net/atm/resources.c                                |  2 +-
 net/atm/signaling.c                                |  2 +-
 net/ax25/af_ax25.c                                 |  2 +-
 net/ax25/ax25_route.c                              |  2 +-
 net/ax25/ax25_uid.c                                |  2 +-
 net/bluetooth/a2mp.c                               |  4 +--
 net/bluetooth/af_bluetooth.c                       |  2 +-
 net/bluetooth/hci_conn.c                           |  4 +--
 net/bluetooth/rfcomm/core.c                        |  4 +--
 net/bluetooth/rfcomm/sock.c                        |  2 +-
 net/bridge/br_netfilter_hooks.c                    |  4 +--
 net/bridge/br_private.h                            |  3 +-
 net/bridge/br_vlan.c                               |  8 ++---
 net/caif/caif_socket.c                             |  2 +-
 net/ceph/osd_client.c                              | 16 +++++-----
 net/ceph/pagelist.c                                |  2 +-
 net/ceph/snapshot.c                                |  6 ++--
 net/core/datagram.c                                | 10 +++----
 net/core/dev.c                                     | 10 +++----
 net/core/dst.c                                     |  7 +----
 net/core/fib_rules.c                               |  4 +--
 net/core/filter.c                                  |  6 ++--
 net/core/neighbour.c                               | 22 +++++++-------
 net/core/net-sysfs.c                               |  2 +-
 net/core/net_namespace.c                           |  4 +--
 net/core/netpoll.c                                 | 10 +++----
 net/core/pktgen.c                                  | 16 +++++-----
 net/core/rtnetlink.c                               |  2 +-
 net/core/skbuff.c                                  | 34 +++++++++++-----------
 net/core/sock.c                                    | 30 +++++++++----------
 net/dccp/ipv6.c                                    |  2 +-
 net/decnet/dn_fib.c                                |  6 ++--
 net/decnet/dn_neigh.c                              |  2 +-
 net/ipv4/af_inet.c                                 |  2 +-
 net/ipv4/cipso_ipv4.c                              | 16 +++++-----
 net/ipv4/devinet.c                                 |  2 +-
 net/ipv4/fib_semantics.c                           |  2 +-
 net/ipv4/fib_trie.c                                |  2 +-
 net/ipv4/igmp.c                                    | 10 +++----
 net/ipv4/inet_connection_sock.c                    |  2 +-
 net/ipv4/inet_fragment.c                           | 14 ++++-----
 net/ipv4/inet_hashtables.c                         |  4 +--
 net/ipv4/inet_timewait_sock.c                      |  8 ++---
 net/ipv4/inetpeer.c                                | 18 ++++++------
 net/ipv4/ip_fragment.c                             |  2 +-
 net/ipv4/ip_output.c                               |  6 ++--
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 | 19 ++++++------
 net/ipv4/ping.c                                    |  4 +--
 net/ipv4/raw.c                                     |  2 +-
 net/ipv4/syncookies.c                              |  2 +-
 net/ipv4/tcp.c                                     |  4 +--
 net/ipv4/tcp_fastopen.c                            |  2 +-
 net/ipv4/tcp_ipv4.c                                |  4 +--
 net/ipv4/tcp_offload.c                             |  2 +-
 net/ipv4/tcp_output.c                              | 13 ++++-----
 net/ipv4/udp.c                                     |  6 ++--
 net/ipv4/udp_diag.c                                |  4 +--
 net/ipv6/addrconf.c                                |  4 +--
 net/ipv6/addrlabel.c                               |  9 +++---
 net/ipv6/anycast.c                                 |  6 ++--
 net/ipv6/calipso.c                                 | 16 +++++-----
 net/ipv6/datagram.c                                |  2 +-
 net/ipv6/exthdrs.c                                 |  4 +--
 net/ipv6/inet6_hashtables.c                        |  4 +--
 net/ipv6/ip6_output.c                              |  4 +--
 net/ipv6/ipv6_sockglue.c                           |  2 +-
 net/ipv6/mcast.c                                   | 18 ++++++------
 net/ipv6/syncookies.c                              |  2 +-
 net/ipv6/tcp_ipv6.c                                |  6 ++--
 net/ipv6/udp.c                                     |  2 +-
 net/ipv6/xfrm6_input.c                             |  2 +-
 net/ipv6/xfrm6_tunnel.c                            |  8 ++---
 net/ipx/af_ipx.c                                   |  6 ++--
 net/ipx/ipx_proc.c                                 |  2 +-
 net/ipx/ipx_route.c                                |  2 +-
 net/kcm/kcmproc.c                                  |  2 +-
 net/key/af_key.c                                   | 10 +++----
 net/l2tp/l2tp_core.c                               | 12 ++++----
 net/l2tp/l2tp_core.h                               | 13 +++++----
 net/l2tp/l2tp_debugfs.c                            |  6 ++--
 net/l2tp/l2tp_ppp.c                                |  2 +-
 net/lapb/lapb_iface.c                              |  6 ++--
 net/llc/llc_conn.c                                 |  8 ++---
 net/llc/llc_core.c                                 |  2 +-
 net/llc/llc_sap.c                                  |  2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              | 19 ++++++------
 net/netfilter/ipvs/ip_vs_conn.c                    | 24 +++++++--------
 net/netfilter/ipvs/ip_vs_core.c                    |  4 +--
 net/netfilter/ipvs/ip_vs_ctl.c                     | 24 +++++++--------
 net/netfilter/ipvs/ip_vs_dh.c                      |  2 +-
 net/netfilter/ipvs/ip_vs_fo.c                      |  2 +-
 net/netfilter/ipvs/ip_vs_lblc.c                    |  4 +--
 net/netfilter/ipvs/ip_vs_lblcr.c                   |  8 ++---
 net/netfilter/ipvs/ip_vs_lc.c                      |  2 +-
 net/netfilter/ipvs/ip_vs_nq.c                      |  4 +--
 net/netfilter/ipvs/ip_vs_ovf.c                     |  2 +-
 net/netfilter/ipvs/ip_vs_pe_sip.c                  |  2 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c              |  2 +-
 net/netfilter/ipvs/ip_vs_proto_tcp.c               |  2 +-
 net/netfilter/ipvs/ip_vs_rr.c                      |  4 +--
 net/netfilter/ipvs/ip_vs_sed.c                     |  4 +--
 net/netfilter/ipvs/ip_vs_sh.c                      |  2 +-
 net/netfilter/ipvs/ip_vs_wlc.c                     |  4 +--
 net/netfilter/ipvs/ip_vs_wrr.c                     |  4 +--
 net/netfilter/nf_conntrack_core.c                  | 26 ++++++++---------
 net/netfilter/nf_conntrack_expect.c                | 12 ++++----
 net/netfilter/nf_conntrack_netlink.c               | 10 +++----
 net/netfilter/nf_conntrack_standalone.c            |  4 +--
 net/netfilter/nfnetlink_acct.c                     | 16 +++++-----
 net/netfilter/nfnetlink_cttimeout.c                | 12 ++++----
 net/netfilter/nfnetlink_log.c                      | 14 +++++----
 net/netfilter/nft_ct.c                             |  2 +-
 net/netfilter/xt_CT.c                              |  2 +-
 net/netfilter/xt_TPROXY.c                          |  4 +--
 net/netlink/af_netlink.c                           | 14 ++++-----
 net/netrom/nr_route.c                              |  6 ++--
 net/packet/af_packet.c                             | 14 ++++-----
 net/packet/internal.h                              |  4 ++-
 net/phonet/socket.c                                |  4 +--
 net/rds/ib.c                                       | 12 ++++----
 net/rds/ib.h                                       |  2 +-
 net/rds/ib_rdma.c                                  |  4 +--
 net/rds/message.c                                  | 12 ++++----
 net/rds/rdma.c                                     | 10 +++----
 net/rds/rds.h                                      |  9 +++---
 net/rds/recv.c                                     | 12 ++++----
 net/rds/tcp_send.c                                 |  2 +-
 net/rxrpc/af_rxrpc.c                               |  6 ++--
 net/rxrpc/skbuff.c                                 | 12 ++++----
 net/sched/em_meta.c                                |  2 +-
 net/sched/sch_api.c                                |  8 ++---
 net/sched/sch_atm.c                                |  2 +-
 net/sched/sch_generic.c                            |  8 ++---
 net/sctp/associola.c                               |  6 ++--
 net/sctp/auth.c                                    |  4 +--
 net/sctp/chunk.c                                   |  6 ++--
 net/sctp/endpointola.c                             |  6 ++--
 net/sctp/output.c                                  |  2 +-
 net/sctp/outqueue.c                                |  2 +-
 net/sctp/proc.c                                    |  2 +-
 net/sctp/sm_make_chunk.c                           |  6 ++--
 net/sctp/socket.c                                  |  6 ++--
 net/sctp/transport.c                               |  8 ++---
 net/sunrpc/auth.c                                  | 12 ++++----
 net/sunrpc/auth_gss/auth_gss.c                     | 29 +++++++++---------
 net/tipc/socket.c                                  |  2 +-
 net/unix/af_unix.c                                 | 16 +++++-----
 net/wireless/lib80211.c                            |  2 +-
 net/x25/x25_link.c                                 |  2 +-
 net/x25/x25_route.c                                |  2 +-
 net/xfrm/xfrm_input.c                              |  4 +--
 net/xfrm/xfrm_policy.c                             |  4 +--
 net/xfrm/xfrm_state.c                              |  4 +--
 235 files changed, 833 insertions(+), 791 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index f849311..cd37cc0 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -749,7 +749,7 @@ static void aead_sock_destruct(struct sock *sk)
 	unsigned int ivlen = crypto_aead_ivsize(
 				crypto_aead_reqtfm(&ctx->aead_req));
 
-	WARN_ON(atomic_read(&sk->sk_refcnt) != 0);
+	WARN_ON(refcount_read(&sk->sk_refcnt) != 0);
 	aead_put_sgl(sk);
 	sock_kzfree_s(sk, ctx->iv, ivlen);
 	sock_kfree_s(sk, ctx, ctx->len);
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 637c3e6..cd39f6f 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -924,12 +924,7 @@ fore200e_tx_irq(struct fore200e* fore200e)
 		else {
 		    dev_kfree_skb_any(entry->skb);
 		}
-#if 1
-		/* race fixed by the above incarnation mechanism, but... */
-		if (atomic_read(&sk_atm(vcc)->sk_wmem_alloc) < 0) {
-		    atomic_set(&sk_atm(vcc)->sk_wmem_alloc, 0);
-		}
-#endif
+
 		/* check error condition */
 		if (*entry->status & STATUS_ERROR)
 		    atomic_inc(&vcc->stats->tx_err);
@@ -1130,12 +1125,12 @@ fore200e_push_rpd(struct fore200e* fore200e, struct atm_vcc* vcc, struct rpd* rp
 	return -ENOMEM;
     }
 
-    ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
+    ASSERT(refcount_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
     vcc->push(vcc, skb);
     atomic_inc(&vcc->stats->rx);
 
-    ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
+    ASSERT(refcount_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
     return 0;
 }
@@ -1572,7 +1567,7 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
     unsigned long           flags;
 
     ASSERT(vcc);
-    ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
+    ASSERT(refcount_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
     ASSERT(fore200e);
     ASSERT(fore200e_vcc);
 
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 3617659..fc1bbdb 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -2395,7 +2395,7 @@ he_close(struct atm_vcc *vcc)
 		 * TBRQ, the host issues the close command to the adapter.
 		 */
 
-		while (((tx_inuse = atomic_read(&sk_atm(vcc)->sk_wmem_alloc)) > 1) &&
+		while (((tx_inuse = refcount_read(&sk_atm(vcc)->sk_wmem_alloc)) > 1) &&
 		       (retry < MAX_RETRY)) {
 			msleep(sleep);
 			if (sleep < 250)
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 471ddfd..fffdc49 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -724,7 +724,7 @@ push_on_scq(struct idt77252_dev *card, struct vc_map *vc, struct sk_buff *skb)
 		struct sock *sk = sk_atm(vcc);
 
 		vc->estimator->cells += (skb->len + 47) / 48;
-		if (atomic_read(&sk->sk_wmem_alloc) >
+		if (refcount_read(&sk->sk_wmem_alloc) >
 		    (sk->sk_sndbuf >> 1)) {
 			u32 cps = vc->estimator->maxcps;
 
@@ -2012,7 +2012,7 @@ idt77252_send_oam(struct atm_vcc *vcc, void *cell, int flags)
 		atomic_inc(&vcc->stats->tx_err);
 		return -ENOMEM;
 	}
-	atomic_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
 
 	memcpy(skb_put(skb, 52), cell, 52);
 
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 8e70347..53eb47b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -743,7 +743,7 @@ int schedule_nes_timer(struct nes_cm_node *cm_node, struct sk_buff *skb,
 
 	if (type == NES_TIMER_TYPE_SEND) {
 		new_send->seq_num = ntohl(tcp_hdr(skb)->seq);
-		atomic_inc(&new_send->skb->users);
+		refcount_inc(&new_send->skb->users);
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
 		cm_node->send_entry = new_send;
 		add_ref_cm_node(cm_node);
@@ -925,7 +925,7 @@ static void nes_cm_timer_tick(unsigned long pass)
 						  flags);
 				break;
 			}
-			atomic_inc(&send_entry->skb->users);
+			refcount_inc(&send_entry->skb->users);
 			cm_packets_retrans++;
 			nes_debug(NES_DBG_CM, "Retransmitting send_entry %p "
 				  "for node %p, jiffies = %lu, time to send = "
diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 99e5f97..c5603d1 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -155,7 +155,7 @@ mISDN_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	copied = skb->len + MISDN_HEADER_LEN;
 	if (len < copied) {
 		if (flags & MSG_PEEK)
-			atomic_dec(&skb->users);
+			refcount_dec(&skb->users);
 		else
 			skb_queue_head(&sk->sk_receive_queue, skb);
 		return -ENOSPC;
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 300bb14..e9f101c 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -201,7 +201,7 @@ static int rionet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 				rionet_queue_tx_msg(skb, ndev,
 					nets[rnet->mport->id].active[i]);
 				if (count)
-					atomic_inc(&skb->users);
+					refcount_inc(&skb->users);
 				count++;
 			}
 	} else if (RIONET_MAC_MATCH(eth->h_dest)) {
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index bb70dd5..50d9ad8 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -958,11 +958,11 @@ static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev)
 	/* The vxlan_sock is only used by dev, leaving group has
 	 * no effect on other vxlan devices.
 	 */
-	if (family == AF_INET && sock4 && atomic_read(&sock4->refcnt) == 1)
+	if (family == AF_INET && sock4 && refcount_read(&sock4->refcnt) == 1)
 		return false;
 #if IS_ENABLED(CONFIG_IPV6)
 	sock6 = rtnl_dereference(dev->vn6_sock);
-	if (family == AF_INET6 && sock6 && atomic_read(&sock6->refcnt) == 1)
+	if (family == AF_INET6 && sock6 && refcount_read(&sock6->refcnt) == 1)
 		return false;
 #endif
 
@@ -999,7 +999,7 @@ static bool __vxlan_sock_release_prep(struct vxlan_sock *vs)
 
 	if (!vs)
 		return false;
-	if (!atomic_dec_and_test(&vs->refcnt))
+	if (!refcount_dec_and_test(&vs->refcnt))
 		return false;
 
 	vn = net_generic(sock_net(vs->sock->sk), vxlan_net_id);
@@ -2699,7 +2699,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, bool ipv6,
 	}
 
 	vs->sock = sock;
-	atomic_set(&vs->refcnt, 1);
+	refcount_set(&vs->refcnt, 1);
 	vs->flags = (flags & VXLAN_F_RCV_FLAGS);
 
 	spin_lock(&vn->sock_lock);
@@ -2733,7 +2733,7 @@ static int __vxlan_sock_add(struct vxlan_dev *vxlan, bool ipv6)
 		spin_lock(&vn->sock_lock);
 		vs = vxlan_find_sock(vxlan->net, ipv6 ? AF_INET6 : AF_INET,
 				     vxlan->cfg.dst_port, vxlan->flags);
-		if (vs && !atomic_add_unless(&vs->refcnt, 1, 0)) {
+		if (vs && !refcount_inc_not_zero(&vs->refcnt)) {
 			spin_unlock(&vn->sock_lock);
 			return -EBUSY;
 		}
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
index 6df19f0..61a5b19 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_rx.c
@@ -281,9 +281,9 @@ libipw_rx_frame_decrypt(struct libipw_device *ieee, struct sk_buff *skb,
 	hdr = (struct libipw_hdr_3addr *)skb->data;
 	hdrlen = libipw_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		LIBIPW_DEBUG_DROP("decryption failed (SA=%pM) res=%d\n",
 				     hdr->addr2, res);
@@ -313,9 +313,9 @@ libipw_rx_frame_decrypt_msdu(struct libipw_device *ieee,
 	hdr = (struct libipw_hdr_3addr *)skb->data;
 	hdrlen = libipw_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: MSDU decryption/MIC verification failed"
 		       " (SA=%pM keyidx=%d)\n", ieee->dev->name, hdr->addr2,
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
index 048f1e3..c616089 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_tx.c
@@ -161,12 +161,12 @@ static int libipw_encrypt_fragment(struct libipw_device *ieee,
 
 	/* To encrypt, frame format is:
 	 * IV (4 bytes), clear payload (including SNAP), ICV (4 bytes) */
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = 0;
 	if (crypt->ops && crypt->ops->encrypt_mpdu)
 		res = crypt->ops->encrypt_mpdu(frag, hdr_len, crypt->priv);
 
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_INFO "%s: Encryption failed: len=%d.\n",
 		       ieee->dev->name, frag->len);
diff --git a/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c b/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
index 34dbddb..9c5cadf 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_80211_rx.c
@@ -669,9 +669,9 @@ hostap_rx_frame_decrypt(local_info_t *local, struct sk_buff *skb,
 		return -1;
 	}
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: decryption failed (SA=%pM) res=%d\n",
 		       local->dev->name, hdr->addr2, res);
@@ -697,9 +697,9 @@ hostap_rx_frame_decrypt_msdu(local_info_t *local, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = hostap_80211_get_hdrlen(hdr->frame_control);
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: MSDU decryption/MIC verification failed"
 		       " (SA=%pM keyidx=%d)\n",
diff --git a/drivers/net/wireless/intersil/hostap/hostap_80211_tx.c b/drivers/net/wireless/intersil/hostap/hostap_80211_tx.c
index 055e11d..810e9ba 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_80211_tx.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_80211_tx.c
@@ -359,13 +359,13 @@ static struct sk_buff * hostap_tx_encrypt(struct sk_buff *skb,
 
 	/* Host-based IEEE 802.11 fragmentation for TX is not yet supported, so
 	 * call both MSDU and MPDU encryption functions from here. */
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = 0;
 	if (crypt->ops->encrypt_msdu)
 		res = crypt->ops->encrypt_msdu(skb, hdr_len, crypt->priv);
 	if (res == 0 && crypt->ops->encrypt_mpdu)
 		res = crypt->ops->encrypt_mpdu(skb, hdr_len, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		kfree_skb(skb);
 		return NULL;
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index ac65f12..d079d02 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -483,7 +483,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 			spin_unlock_irqrestore(&ch->collect_lock, saveflags);
 			return -EBUSY;
 		} else {
-			atomic_inc(&skb->users);
+			refcount_inc(&skb->users);
 			header.length = l;
 			header.type = skb->protocol;
 			header.unused = 0;
@@ -500,7 +500,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	 * Protect skb against beeing free'd by upper
 	 * layers.
 	 */
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 	ch->prof.txlen += skb->len;
 	header.length = skb->len + LL_HEADER_LENGTH;
 	header.type = skb->protocol;
@@ -517,14 +517,14 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	if (hi) {
 		nskb = alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!nskb) {
-			atomic_dec(&skb->users);
+			refcount_dec(&skb->users);
 			skb_pull(skb, LL_HEADER_LENGTH + 2);
 			ctcm_clear_busy(ch->netdev);
 			return -ENOMEM;
 		} else {
 			memcpy(skb_put(nskb, skb->len), skb->data, skb->len);
-			atomic_inc(&nskb->users);
-			atomic_dec(&skb->users);
+			refcount_inc(&nskb->users);
+			refcount_dec(&skb->users);
 			dev_kfree_skb_irq(skb);
 			skb = nskb;
 		}
@@ -542,7 +542,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 			 * Remove our header. It gets added
 			 * again on retransmit.
 			 */
-			atomic_dec(&skb->users);
+			refcount_dec(&skb->users);
 			skb_pull(skb, LL_HEADER_LENGTH + 2);
 			ctcm_clear_busy(ch->netdev);
 			return -ENOMEM;
@@ -553,7 +553,7 @@ static int ctcm_transmit_skb(struct channel *ch, struct sk_buff *skb)
 		ch->ccw[1].count = skb->len;
 		skb_copy_from_linear_data(skb,
 				skb_put(ch->trans_skb, skb->len), skb->len);
-		atomic_dec(&skb->users);
+		refcount_dec(&skb->users);
 		dev_kfree_skb_irq(skb);
 		ccw_idx = 0;
 	} else {
@@ -679,7 +679,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 
 	if ((fsm_getstate(ch->fsm) != CTC_STATE_TXIDLE) || grp->in_sweep) {
 		spin_lock_irqsave(&ch->collect_lock, saveflags);
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 		p_header = kmalloc(PDU_HEADER_LENGTH, gfp_type());
 
 		if (!p_header) {
@@ -716,7 +716,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 	 * Protect skb against beeing free'd by upper
 	 * layers.
 	 */
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 
 	/*
 	 * IDAL support in CTCM is broken, so we have to
@@ -729,8 +729,8 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 			goto nomem_exit;
 		} else {
 			memcpy(skb_put(nskb, skb->len), skb->data, skb->len);
-			atomic_inc(&nskb->users);
-			atomic_dec(&skb->users);
+			refcount_inc(&nskb->users);
+			refcount_dec(&skb->users);
 			dev_kfree_skb_irq(skb);
 			skb = nskb;
 		}
@@ -810,7 +810,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 		ch->trans_skb->len = 0;
 		ch->ccw[1].count = skb->len;
 		memcpy(skb_put(ch->trans_skb, skb->len), skb->data, skb->len);
-		atomic_dec(&skb->users);
+		refcount_dec(&skb->users);
 		dev_kfree_skb_irq(skb);
 		ccw_idx = 0;
 		CTCM_PR_DBGDATA("%s(%s): trans_skb len: %04x\n"
@@ -855,7 +855,7 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 			"%s(%s): MEMORY allocation ERROR\n",
 			CTCM_FUNTAIL, ch->id);
 	rc = -ENOMEM;
-	atomic_dec(&skb->users);
+	refcount_dec(&skb->users);
 	dev_kfree_skb_any(skb);
 	fsm_event(priv->mpcg->fsm, MPCG_EVENT_INOP, dev);
 done:
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 3f85b97..44fd71c 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -743,7 +743,7 @@ static void conn_action_txdone(fsm_instance *fi, int event, void *arg)
 	conn->prof.tx_pending--;
 	if (single_flag) {
 		if ((skb = skb_dequeue(&conn->commit_queue))) {
-			atomic_dec(&skb->users);
+			refcount_dec(&skb->users);
 			if (privptr) {
 				privptr->stats.tx_packets++;
 				privptr->stats.tx_bytes +=
@@ -767,7 +767,7 @@ static void conn_action_txdone(fsm_instance *fi, int event, void *arg)
 		txbytes += skb->len;
 		txpackets++;
 		stat_maxcq++;
-		atomic_dec(&skb->users);
+		refcount_dec(&skb->users);
 		dev_kfree_skb_any(skb);
 	}
 	if (conn->collect_len > conn->prof.maxmulti)
@@ -959,7 +959,7 @@ static void netiucv_purge_skb_queue(struct sk_buff_head *q)
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(q))) {
-		atomic_dec(&skb->users);
+		refcount_dec(&skb->users);
 		dev_kfree_skb_any(skb);
 	}
 }
@@ -1177,7 +1177,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 			IUCV_DBF_TEXT(data, 2,
 				      "EBUSY from netiucv_transmit_skb\n");
 		} else {
-			atomic_inc(&skb->users);
+			refcount_inc(&skb->users);
 			skb_queue_tail(&conn->collect_queue, skb);
 			conn->collect_len += l;
 			rc = 0;
@@ -1247,7 +1247,7 @@ static int netiucv_transmit_skb(struct iucv_connection *conn,
 		} else {
 			if (copied)
 				dev_kfree_skb(skb);
-			atomic_inc(&nskb->users);
+			refcount_inc(&nskb->users);
 			skb_queue_tail(&conn->commit_queue, nskb);
 		}
 	}
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e335583..e6ebcd7 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -1239,7 +1239,7 @@ static void qeth_release_skbs(struct qeth_qdio_out_buffer *buf)
 				iucv->sk_txnotify(skb, TX_NOTIFY_GENERALERROR);
 			}
 		}
-		atomic_dec(&skb->users);
+		refcount_dec(&skb->users);
 		dev_kfree_skb_any(skb);
 		skb = skb_dequeue(&buf->skb_list);
 	}
@@ -3970,7 +3970,7 @@ static inline int qeth_fill_buffer(struct qeth_qdio_out_q *queue,
 	int flush_cnt = 0, hdr_len, large_send = 0;
 
 	buffer = buf->buffer;
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 	skb_queue_tail(&buf->skb_list, skb);
 
 	/*check first on TSO ....*/
diff --git a/drivers/scsi/cxgbi/libcxgbi.h b/drivers/scsi/cxgbi/libcxgbi.h
index 18e0ea8..9584b062 100644
--- a/drivers/scsi/cxgbi/libcxgbi.h
+++ b/drivers/scsi/cxgbi/libcxgbi.h
@@ -378,7 +378,7 @@ static inline void cxgbi_sock_enqueue_wr(struct cxgbi_sock *csk,
 	 * just one user currently so we use atomic_set rather than skb_get
 	 * to avoid the atomic op.
 	 */
-	atomic_set(&skb->users, 2);
+	refcount_set(&skb->users, 2);
 
 	if (!csk->wr_pending_head)
 		csk->wr_pending_head = skb;
diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index e5ba7d1..2f72ee5 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -310,9 +310,9 @@ rtllib_rx_frame_decrypt(struct rtllib_device *ieee, struct sk_buff *skb,
 	hdr = (struct rtllib_hdr_4addr *) skb->data;
 	hdrlen = rtllib_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		netdev_dbg(ieee->dev, "decryption failed (SA= %pM) res=%d\n",
 			   hdr->addr2, res);
@@ -350,9 +350,9 @@ rtllib_rx_frame_decrypt_msdu(struct rtllib_device *ieee, struct sk_buff *skb,
 	hdr = (struct rtllib_hdr_4addr *) skb->data;
 	hdrlen = rtllib_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		netdev_dbg(ieee->dev,
 			   "MSDU decryption/MIC verification failed (SA= %pM keyidx=%d)\n",
diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index 78a3ad5..796580a 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -190,14 +190,14 @@ int rtllib_encrypt_fragment(struct rtllib_device *ieee, struct sk_buff *frag,
 	/* Host-based IEEE 802.11 fragmentation for TX is not yet supported, so
 	 * call both MSDU and MPDU encryption functions from here.
 	 */
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = 0;
 	if (crypt->ops->encrypt_msdu)
 		res = crypt->ops->encrypt_msdu(frag, hdr_len, crypt->priv);
 	if (res == 0 && crypt->ops->encrypt_mpdu)
 		res = crypt->ops->encrypt_mpdu(frag, hdr_len, crypt->priv);
 
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		netdev_info(ieee->dev, "%s: Encryption failed: len=%d.\n",
 			    ieee->dev->name, frag->len);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
index 9cf90d0..b6d5673 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
@@ -46,7 +46,7 @@ void ieee80211_crypt_deinit_entries(struct ieee80211_device *ieee,
 	     ptr != &ieee->crypt_deinit_list; ptr = n, n = ptr->next) {
 		entry = list_entry(ptr, struct ieee80211_crypt_data, list);
 
-		if (atomic_read(&entry->refcnt) != 0 && !force)
+		if (refcount_read(&entry->refcnt) != 0 && !force)
 			continue;
 
 		list_del(ptr);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.h b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.h
index 0b4ea43..01718c1 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.h
@@ -23,6 +23,7 @@
 #ifndef IEEE80211_CRYPT_H
 #define IEEE80211_CRYPT_H
 
+#include <linux/refcount.h>
 #include <linux/skbuff.h>
 
 struct ieee80211_crypto_ops {
@@ -72,7 +73,7 @@ struct ieee80211_crypt_data {
 	struct list_head list; /* delayed deletion list */
 	struct ieee80211_crypto_ops *ops;
 	void *priv;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 int ieee80211_register_crypto_ops(struct ieee80211_crypto_ops *ops);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 82f6543..1157a72 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -361,9 +361,9 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 		return -1;
 	}
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		IEEE80211_DEBUG_DROP(
 			"decryption failed (SA=%pM"
@@ -399,9 +399,9 @@ ieee80211_rx_frame_decrypt_msdu(struct ieee80211_device *ieee, struct sk_buff *s
 	hdr = (struct rtl_80211_hdr_4addr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_msdu(skb, keyidx, hdrlen, crypt->priv);
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: MSDU decryption/MIC verification failed"
 		       " (SA=%pM keyidx=%d)\n",
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 1ab0aea..014e53f 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -210,14 +210,14 @@ int ieee80211_encrypt_fragment(
 	// PR: FIXME: Copied from hostap. Check fragmentation/MSDU/MPDU encryption.
 	/* Host-based IEEE 802.11 fragmentation for TX is not yet supported, so
 	 * call both MSDU and MPDU encryption functions from here. */
-	atomic_inc(&crypt->refcnt);
+	refcount_inc(&crypt->refcnt);
 	res = 0;
 	if (crypt->ops->encrypt_msdu)
 		res = crypt->ops->encrypt_msdu(frag, hdr_len, crypt->priv);
 	if (res == 0 && crypt->ops->encrypt_mpdu)
 		res = crypt->ops->encrypt_mpdu(frag, hdr_len, crypt->priv);
 
-	atomic_dec(&crypt->refcnt);
+	refcount_dec(&crypt->refcnt);
 	if (res < 0) {
 		printk(KERN_INFO "%s: Encryption failed: len=%d.\n",
 		       ieee->dev->name, frag->len);
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index c1da539..0ec9bdb 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -11,6 +11,7 @@
 #include <linux/uio.h>
 #include <net/sock.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <uapi/linux/atmdev.h>
 
 #ifdef CONFIG_PROC_FS
@@ -158,7 +159,7 @@ struct atm_dev {
 	struct k_atm_dev_stats stats;	/* statistics */
 	char		signal;		/* signal status (ATM_PHY_SIG_*) */
 	int		link_rate;	/* link rate (default: OC3) */
-	atomic_t	refcnt;		/* reference count */
+	refcount_t	refcnt;		/* reference count */
 	spinlock_t	lock;		/* protect internal members */
 #ifdef CONFIG_PROC_FS
 	struct proc_dir_entry *proc_entry; /* proc entry */
@@ -254,20 +255,20 @@ static inline void atm_return(struct atm_vcc *vcc,int truesize)
 
 static inline int atm_may_send(struct atm_vcc *vcc,unsigned int size)
 {
-	return (size + atomic_read(&sk_atm(vcc)->sk_wmem_alloc)) <
+	return (size + refcount_read(&sk_atm(vcc)->sk_wmem_alloc)) <
 	       sk_atm(vcc)->sk_sndbuf;
 }
 
 
 static inline void atm_dev_hold(struct atm_dev *dev)
 {
-	atomic_inc(&dev->refcnt);
+	refcount_inc(&dev->refcnt);
 }
 
 
 static inline void atm_dev_put(struct atm_dev *dev)
 {
-	if (atomic_dec_and_test(&dev->refcnt)) {
+	if (refcount_dec_and_test(&dev->refcnt)) {
 		BUG_ON(!test_bit(ATM_DF_REMOVED, &dev->flags));
 		if (dev->ops->dev_close)
 			dev->ops->dev_close(dev);
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 1816c5e..26dc674 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -14,6 +14,7 @@
 #include <linux/wait.h>
 #include <linux/writeback.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 #include <linux/ceph/types.h>
 #include <linux/ceph/messenger.h>
@@ -159,7 +160,7 @@ struct ceph_client {
  * dirtied.
  */
 struct ceph_snap_context {
-	atomic_t nref;
+	refcount_t nref;
 	u64 seq;
 	u32 num_snaps;
 	u64 snaps[];
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index 03a6653..bd0db58 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -5,6 +5,7 @@
 #include <linux/kref.h>
 #include <linux/mempool.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 
 #include <linux/ceph/types.h>
 #include <linux/ceph/osdmap.h>
@@ -28,7 +29,7 @@ typedef void (*ceph_osdc_unsafe_callback_t)(struct ceph_osd_request *, bool);
 
 /* a given osd we're communicating with */
 struct ceph_osd {
-	atomic_t o_ref;
+	refcount_t o_ref;
 	struct ceph_osd_client *o_osdc;
 	int o_osd;
 	int o_incarnation;
diff --git a/include/linux/ceph/pagelist.h b/include/linux/ceph/pagelist.h
index 13d71fe..75a7db2 100644
--- a/include/linux/ceph/pagelist.h
+++ b/include/linux/ceph/pagelist.h
@@ -2,7 +2,7 @@
 #define __FS_CEPH_PAGELIST_H
 
 #include <asm/byteorder.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/list.h>
 #include <linux/types.h>
 
@@ -13,7 +13,7 @@ struct ceph_pagelist {
 	size_t room;
 	struct list_head free_list;
 	size_t num_pages_free;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 struct ceph_pagelist_cursor {
@@ -30,7 +30,7 @@ static inline void ceph_pagelist_init(struct ceph_pagelist *pl)
 	pl->room = 0;
 	INIT_LIST_HEAD(&pl->free_list);
 	pl->num_pages_free = 0;
-	atomic_set(&pl->refcnt, 1);
+	refcount_set(&pl->refcnt, 1);
 }
 
 extern void ceph_pagelist_release(struct ceph_pagelist *pl);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index a0934e6..f994406 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -7,6 +7,7 @@
 #include <stdarg.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/compat.h>
 #include <linux/skbuff.h>
 #include <linux/linkage.h>
@@ -421,7 +422,7 @@ struct bpf_prog {
 };
 
 struct sk_filter {
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	struct rcu_head	rcu;
 	struct bpf_prog	*prog;
 };
diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 12f6fba..97caf18 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -18,6 +18,7 @@
 #include <linux/skbuff.h>
 #include <linux/timer.h>
 #include <linux/in.h>
+#include <linux/refcount.h>
 #include <uapi/linux/igmp.h>
 
 static inline struct igmphdr *igmp_hdr(const struct sk_buff *skb)
@@ -84,7 +85,7 @@ struct ip_mc_list {
 	struct ip_mc_list __rcu *next_hash;
 	struct timer_list	timer;
 	int			users;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	spinlock_t		lock;
 	char			tm_running;
 	char			reporter;
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ee971f3..5cd9671 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -11,6 +11,7 @@
 #include <linux/timer.h>
 #include <linux/sysctl.h>
 #include <linux/rtnetlink.h>
+#include <linux/refcount.h>
 
 struct ipv4_devconf {
 	void	*sysctl;
@@ -22,7 +23,7 @@ struct ipv4_devconf {
 
 struct in_device {
 	struct net_device	*dev;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	int			dead;
 	struct in_ifaddr	*ifa_list;	/* IP ifaddr chain		*/
 
@@ -212,7 +213,7 @@ static inline struct in_device *in_dev_get(const struct net_device *dev)
 	rcu_read_lock();
 	in_dev = __in_dev_get_rcu(dev);
 	if (in_dev)
-		atomic_inc(&in_dev->refcnt);
+		refcount_inc(&in_dev->refcnt);
 	rcu_read_unlock();
 	return in_dev;
 }
@@ -233,12 +234,12 @@ void in_dev_finish_destroy(struct in_device *idev);
 
 static inline void in_dev_put(struct in_device *idev)
 {
-	if (atomic_dec_and_test(&idev->refcnt))
+	if (refcount_dec_and_test(&idev->refcnt))
 		in_dev_finish_destroy(idev);
 }
 
-#define __in_dev_put(idev)  atomic_dec(&(idev)->refcnt)
-#define in_dev_hold(idev)   atomic_inc(&(idev)->refcnt)
+#define __in_dev_put(idev)  refcount_dec(&(idev)->refcnt)
+#define in_dev_hold(idev)   refcount_inc(&(idev)->refcnt)
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index 1828900..27c0aaa 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -11,6 +11,7 @@
 #include <linux/interrupt.h>
 #include <linux/rcupdate.h>
 #include <linux/list.h>
+#include <linux/refcount.h>
 
 union inet_addr {
 	__u32		all[4];
@@ -34,7 +35,7 @@ struct netpoll {
 };
 
 struct netpoll_info {
-	atomic_t refcnt;
+	refcount_t refcnt;
 
 	struct semaphore dev_lock;
 
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index b53c0cf..12b8444 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -24,6 +24,7 @@
 #include <linux/socket.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/types.h>
 #include <linux/spinlock.h>
 #include <linux/net.h>
@@ -243,13 +244,13 @@ struct napi_struct;
 
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 struct nf_conntrack {
-	atomic_t use;
+	refcount_t use;
 };
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 struct nf_bridge_info {
-	atomic_t		use;
+	refcount_t		use;
 	enum {
 		BRNF_PROTO_UNCHANGED,
 		BRNF_PROTO_8021Q,
@@ -809,7 +810,7 @@ struct sk_buff {
 	unsigned char		*head,
 				*data;
 	unsigned int		truesize;
-	atomic_t		users;
+	refcount_t		users;
 };
 
 #ifdef __KERNEL__
@@ -938,7 +939,7 @@ struct sk_buff_fclones {
 
 	struct sk_buff	skb2;
 
-	atomic_t	fclone_ref;
+	refcount_t	fclone_ref;
 };
 
 /**
@@ -958,7 +959,7 @@ static inline bool skb_fclone_busy(const struct sock *sk,
 	fclones = container_of(skb, struct sk_buff_fclones, skb1);
 
 	return skb->fclone == SKB_FCLONE_ORIG &&
-	       atomic_read(&fclones->fclone_ref) > 1 &&
+	       refcount_read(&fclones->fclone_ref) > 1 &&
 	       fclones->skb2.sk == sk;
 }
 
@@ -1306,7 +1307,7 @@ static inline struct sk_buff *skb_queue_prev(const struct sk_buff_head *list,
  */
 static inline struct sk_buff *skb_get(struct sk_buff *skb)
 {
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 	return skb;
 }
 
@@ -1407,7 +1408,7 @@ static inline void __skb_header_release(struct sk_buff *skb)
  */
 static inline int skb_shared(const struct sk_buff *skb)
 {
-	return atomic_read(&skb->users) != 1;
+	return refcount_read(&skb->users) != 1;
 }
 
 /**
@@ -3557,25 +3558,25 @@ static inline void skb_remcsum_process(struct sk_buff *skb, void *ptr,
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
+	if (nfct && refcount_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->use);
+		refcount_inc(&nfct->use);
 }
 #endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
 {
-	if (nf_bridge && atomic_dec_and_test(&nf_bridge->use))
+	if (nf_bridge && refcount_dec_and_test(&nf_bridge->use))
 		kfree(nf_bridge);
 }
 static inline void nf_bridge_get(struct nf_bridge_info *nf_bridge)
 {
 	if (nf_bridge)
-		atomic_inc(&nf_bridge->use);
+		refcount_inc(&nf_bridge->use);
 }
 #endif /* CONFIG_BRIDGE_NETFILTER */
 static inline void nf_reset(struct sk_buff *skb)
diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index b1bc62b..bd36e0b 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -15,7 +15,7 @@
 #include <linux/sunrpc/msg_prot.h>
 #include <linux/sunrpc/xdr.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/rcupdate.h>
 #include <linux/uidgid.h>
 #include <linux/utsname.h>
@@ -68,7 +68,7 @@ struct rpc_cred {
 #endif
 	unsigned long		cr_expire;	/* when to gc */
 	unsigned long		cr_flags;	/* various flags */
-	atomic_t		cr_count;	/* ref count */
+	refcount_t		cr_count;	/* ref count */
 
 	kuid_t			cr_uid;
 
@@ -209,7 +209,7 @@ static inline
 struct rpc_cred *	get_rpccred(struct rpc_cred *cred)
 {
 	if (cred != NULL)
-		atomic_inc(&cred->cr_count);
+		refcount_inc(&cred->cr_count);
 	return cred;
 }
 
@@ -226,7 +226,7 @@ struct rpc_cred *	get_rpccred(struct rpc_cred *cred)
 static inline struct rpc_cred *
 get_rpccred_rcu(struct rpc_cred *cred)
 {
-	if (atomic_inc_not_zero(&cred->cr_count))
+	if (refcount_inc_not_zero(&cred->cr_count))
 		return cred;
 	return NULL;
 }
diff --git a/include/linux/sunrpc/auth_gss.h b/include/linux/sunrpc/auth_gss.h
index 36eebc4..cebdf87 100644
--- a/include/linux/sunrpc/auth_gss.h
+++ b/include/linux/sunrpc/auth_gss.h
@@ -13,6 +13,7 @@
 #define _LINUX_SUNRPC_AUTH_GSS_H
 
 #ifdef __KERNEL__
+#include <linux/refcount.h>
 #include <linux/sunrpc/auth.h>
 #include <linux/sunrpc/svc.h>
 #include <linux/sunrpc/gss_api.h>
@@ -65,7 +66,7 @@ struct rpc_gss_init_res {
  * the wire when communicating with a server. */
 
 struct gss_cl_ctx {
-	atomic_t		count;
+	refcount_t		count;
 	enum rpc_gss_proc	gc_proc;
 	u32			gc_seq;
 	spinlock_t		gc_seq_lock;
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 8f998af..7caa848 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -294,7 +294,7 @@ static inline struct inet6_dev *in6_dev_get(const struct net_device *dev)
 	rcu_read_lock();
 	idev = rcu_dereference(dev->ip6_ptr);
 	if (idev)
-		atomic_inc(&idev->refcnt);
+		refcount_inc(&idev->refcnt);
 	rcu_read_unlock();
 	return idev;
 }
@@ -310,36 +310,36 @@ void in6_dev_finish_destroy(struct inet6_dev *idev);
 
 static inline void in6_dev_put(struct inet6_dev *idev)
 {
-	if (atomic_dec_and_test(&idev->refcnt))
+	if (refcount_dec_and_test(&idev->refcnt))
 		in6_dev_finish_destroy(idev);
 }
 
 static inline void __in6_dev_put(struct inet6_dev *idev)
 {
-	atomic_dec(&idev->refcnt);
+	refcount_dec(&idev->refcnt);
 }
 
 static inline void in6_dev_hold(struct inet6_dev *idev)
 {
-	atomic_inc(&idev->refcnt);
+	refcount_inc(&idev->refcnt);
 }
 
 void inet6_ifa_finish_destroy(struct inet6_ifaddr *ifp);
 
 static inline void in6_ifa_put(struct inet6_ifaddr *ifp)
 {
-	if (atomic_dec_and_test(&ifp->refcnt))
+	if (refcount_dec_and_test(&ifp->refcnt))
 		inet6_ifa_finish_destroy(ifp);
 }
 
 static inline void __in6_ifa_put(struct inet6_ifaddr *ifp)
 {
-	atomic_dec(&ifp->refcnt);
+	refcount_dec(&ifp->refcnt);
 }
 
 static inline void in6_ifa_hold(struct inet6_ifaddr *ifp)
 {
-	atomic_inc(&ifp->refcnt);
+	refcount_inc(&ifp->refcnt);
 }
 
 
diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index fd60ecc..3a385e4 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -4,6 +4,7 @@
 #include <linux/socket.h>
 #include <linux/un.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <net/sock.h>
 
 void unix_inflight(struct user_struct *user, struct file *fp);
@@ -21,7 +22,7 @@ extern spinlock_t unix_table_lock;
 extern struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 
 struct unix_address {
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	int		len;
 	unsigned int	hash;
 	struct sockaddr_un name[0];
diff --git a/include/net/arp.h b/include/net/arp.h
index 5e0f891..95cfce4 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -28,7 +28,7 @@ static inline struct neighbour *__ipv4_neigh_lookup(struct net_device *dev, u32
 
 	rcu_read_lock_bh();
 	n = __ipv4_neigh_lookup_noref(dev, key);
-	if (n && !atomic_inc_not_zero(&n->refcnt))
+	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 	rcu_read_unlock_bh();
 
diff --git a/include/net/ax25.h b/include/net/ax25.h
index e602f81..c4a0cf6 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -11,7 +11,7 @@
 #include <linux/timer.h>
 #include <linux/list.h>
 #include <linux/slab.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <net/neighbour.h>
 #include <net/sock.h>
 
@@ -158,7 +158,7 @@ enum {
 
 typedef struct ax25_uid_assoc {
 	struct hlist_node	uid_node;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	kuid_t			uid;
 	ax25_address		call;
 } ax25_uid_assoc;
@@ -167,11 +167,11 @@ typedef struct ax25_uid_assoc {
 	hlist_for_each_entry(__ax25, list, uid_node)
 
 #define ax25_uid_hold(ax25) \
-	atomic_inc(&((ax25)->refcount))
+	refcount_inc(&((ax25)->refcount))
 
 static inline void ax25_uid_put(ax25_uid_assoc *assoc)
 {
-	if (atomic_dec_and_test(&assoc->refcount)) {
+	if (refcount_dec_and_test(&assoc->refcount)) {
 		kfree(assoc);
 	}
 }
@@ -185,7 +185,7 @@ typedef struct {
 
 typedef struct ax25_route {
 	struct ax25_route	*next;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	ax25_address		callsign;
 	struct net_device	*dev;
 	ax25_digi		*digipeat;
@@ -194,14 +194,14 @@ typedef struct ax25_route {
 
 static inline void ax25_hold_route(ax25_route *ax25_rt)
 {
-	atomic_inc(&ax25_rt->refcount);
+	refcount_inc(&ax25_rt->refcount);
 }
 
 void __ax25_put_route(ax25_route *ax25_rt);
 
 static inline void ax25_put_route(ax25_route *ax25_rt)
 {
-	if (atomic_dec_and_test(&ax25_rt->refcount))
+	if (refcount_dec_and_test(&ax25_rt->refcount))
 		__ax25_put_route(ax25_rt);
 }
 
@@ -244,7 +244,7 @@ typedef struct ax25_cb {
 	unsigned char		window;
 	struct timer_list	timer, dtimer;
 	struct sock		*sk;		/* Backlink to socket */
-	atomic_t		refcount;
+	refcount_t		refcount;
 } ax25_cb;
 
 struct ax25_sock {
@@ -266,11 +266,11 @@ static inline struct ax25_cb *sk_to_ax25(const struct sock *sk)
 	hlist_for_each_entry(__ax25, list, ax25_node)
 
 #define ax25_cb_hold(__ax25) \
-	atomic_inc(&((__ax25)->refcount))
+	refcount_inc(&((__ax25)->refcount))
 
 static __inline__ void ax25_cb_put(ax25_cb *ax25)
 {
-	if (atomic_dec_and_test(&ax25->refcount)) {
+	if (refcount_dec_and_test(&ax25->refcount)) {
 		kfree(ax25->digipeat);
 		kfree(ax25);
 	}
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 90708f6..3c228fa 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -422,7 +422,7 @@ struct hci_dev {
 struct hci_conn {
 	struct list_head list;
 
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 
 	bdaddr_t	dst;
 	__u8		dst_type;
@@ -942,17 +942,17 @@ static inline void hci_conn_put(struct hci_conn *conn)
 
 static inline void hci_conn_hold(struct hci_conn *conn)
 {
-	BT_DBG("hcon %p orig refcnt %d", conn, atomic_read(&conn->refcnt));
+	BT_DBG("hcon %p orig refcnt %d", conn, refcount_read(&conn->refcnt));
 
-	atomic_inc(&conn->refcnt);
+	refcount_inc(&conn->refcnt);
 	cancel_delayed_work(&conn->disc_work);
 }
 
 static inline void hci_conn_drop(struct hci_conn *conn)
 {
-	BT_DBG("hcon %p orig refcnt %d", conn, atomic_read(&conn->refcnt));
+	BT_DBG("hcon %p orig refcnt %d", conn, refcount_read(&conn->refcnt));
 
-	if (atomic_dec_and_test(&conn->refcnt)) {
+	if (refcount_dec_and_test(&conn->refcnt)) {
 		unsigned long timeo;
 
 		switch (conn->type) {
diff --git a/include/net/bluetooth/rfcomm.h b/include/net/bluetooth/rfcomm.h
index 4190af5..da4acef 100644
--- a/include/net/bluetooth/rfcomm.h
+++ b/include/net/bluetooth/rfcomm.h
@@ -21,6 +21,8 @@
    SOFTWARE IS DISCLAIMED.
 */
 
+#include <linux/refcount.h>
+
 #ifndef __RFCOMM_H
 #define __RFCOMM_H
 
@@ -174,7 +176,7 @@ struct rfcomm_dlc {
 	struct mutex  lock;
 	unsigned long state;
 	unsigned long flags;
-	atomic_t      refcnt;
+	refcount_t    refcnt;
 	u8            dlci;
 	u8            addr;
 	u8            priority;
@@ -247,12 +249,12 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel);
 
 static inline void rfcomm_dlc_hold(struct rfcomm_dlc *d)
 {
-	atomic_inc(&d->refcnt);
+	refcount_inc(&d->refcnt);
 }
 
 static inline void rfcomm_dlc_put(struct rfcomm_dlc *d)
 {
-	if (atomic_dec_and_test(&d->refcnt))
+	if (refcount_dec_and_test(&d->refcnt))
 		rfcomm_dlc_free(d);
 }
 
diff --git a/include/net/calipso.h b/include/net/calipso.h
index b1b30cd..5f95b11 100644
--- a/include/net/calipso.h
+++ b/include/net/calipso.h
@@ -38,7 +38,7 @@
 #include <linux/skbuff.h>
 #include <net/netlabel.h>
 #include <net/request_sock.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/unaligned.h>
 
 /* known doi values */
@@ -57,7 +57,7 @@ struct calipso_doi {
 	u32 doi;
 	u32 type;
 
-	atomic_t refcount;
+	refcount_t refcount;
 	struct list_head list;
 	struct rcu_head rcu;
 };
diff --git a/include/net/cipso_ipv4.h b/include/net/cipso_ipv4.h
index 3ebb168..026c7a3 100644
--- a/include/net/cipso_ipv4.h
+++ b/include/net/cipso_ipv4.h
@@ -41,6 +41,7 @@
 #include <net/netlabel.h>
 #include <net/request_sock.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/unaligned.h>
 
 /* known doi values */
@@ -85,7 +86,7 @@ struct cipso_v4_doi {
 	} map;
 	u8 tags[CIPSO_V4_TAG_MAXCNT];
 
-	atomic_t refcount;
+	refcount_t refcount;
 	struct list_head list;
 	struct rcu_head rcu;
 };
diff --git a/include/net/dn_fib.h b/include/net/dn_fib.h
index f2ca135..81210a8 100644
--- a/include/net/dn_fib.h
+++ b/include/net/dn_fib.h
@@ -2,6 +2,7 @@
 #define _NET_DN_FIB_H
 
 #include <linux/netlink.h>
+#include <linux/refcount.h>
 
 extern const struct nla_policy rtm_dn_policy[];
 
@@ -28,7 +29,7 @@ struct dn_fib_info {
 	struct dn_fib_info	*fib_next;
 	struct dn_fib_info	*fib_prev;
 	int 			fib_treeref;
-	atomic_t		fib_clntref;
+	refcount_t		fib_clntref;
 	int			fib_dead;
 	unsigned int		fib_flags;
 	int			fib_protocol;
@@ -130,7 +131,7 @@ void dn_fib_free_info(struct dn_fib_info *fi);
 
 static inline void dn_fib_info_put(struct dn_fib_info *fi)
 {
-	if (atomic_dec_and_test(&fi->fib_clntref))
+	if (refcount_dec_and_test(&fi->fib_clntref))
 		dn_fib_free_info(fi);
 }
 
diff --git a/include/net/fib_rules.h b/include/net/fib_rules.h
index 8dbfdf7..26ae0ad 100644
--- a/include/net/fib_rules.h
+++ b/include/net/fib_rules.h
@@ -5,6 +5,7 @@
 #include <linux/slab.h>
 #include <linux/netdevice.h>
 #include <linux/fib_rules.h>
+#include <linux/refcount.h>
 #include <net/flow.h>
 #include <net/rtnetlink.h>
 
@@ -29,7 +30,7 @@ struct fib_rule {
 	struct fib_rule __rcu	*ctarget;
 	struct net		*fr_net;
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	u32			pref;
 	int			suppress_ifgroup;
 	int			suppress_prefixlen;
@@ -103,12 +104,12 @@ struct fib_rules_ops {
 
 static inline void fib_rule_get(struct fib_rule *rule)
 {
-	atomic_inc(&rule->refcnt);
+	refcount_inc(&rule->refcnt);
 }
 
 static inline void fib_rule_put(struct fib_rule *rule)
 {
-	if (atomic_dec_and_test(&rule->refcnt))
+	if (refcount_dec_and_test(&rule->refcnt))
 		kfree_rcu(rule, rcu);
 }
 
diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 0fa4c32..96a0e6e 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -17,6 +17,7 @@
 
 #include <net/snmp.h>
 #include <linux/ipv6.h>
+#include <linux/refcount.h>
 
 /* inet6_dev.if_flags */
 
@@ -45,7 +46,7 @@ struct inet6_ifaddr {
 	/* In seconds, relative to tstamp. Expiry is at tstamp + HZ * lft. */
 	__u32			valid_lft;
 	__u32			prefered_lft;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	spinlock_t		lock;
 
 	int			state;
@@ -126,7 +127,7 @@ struct ifmcaddr6 {
 	struct timer_list	mca_timer;
 	unsigned int		mca_flags;
 	int			mca_users;
-	atomic_t		mca_refcnt;
+	refcount_t		mca_refcnt;
 	spinlock_t		mca_lock;
 	unsigned long		mca_cstamp;
 	unsigned long		mca_tstamp;
@@ -146,7 +147,7 @@ struct ifacaddr6 {
 	struct rt6_info		*aca_rt;
 	struct ifacaddr6	*aca_next;
 	int			aca_users;
-	atomic_t		aca_refcnt;
+	refcount_t		aca_refcnt;
 	unsigned long		aca_cstamp;
 	unsigned long		aca_tstamp;
 };
@@ -187,7 +188,7 @@ struct inet6_dev {
 
 	struct ifacaddr6	*ac_list;
 	rwlock_t		lock;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	__u32			if_flags;
 	int			dead;
 
diff --git a/include/net/inet_frag.h b/include/net/inet_frag.h
index 909972a..ed5cbba 100644
--- a/include/net/inet_frag.h
+++ b/include/net/inet_frag.h
@@ -50,7 +50,7 @@ struct inet_frag_queue {
 	spinlock_t		lock;
 	struct timer_list	timer;
 	struct hlist_node	list;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct sk_buff		*fragments;
 	struct sk_buff		*fragments_tail;
 	ktime_t			stamp;
@@ -129,7 +129,7 @@ void inet_frag_maybe_warn_overflow(struct inet_frag_queue *q,
 
 static inline void inet_frag_put(struct inet_frag_queue *q, struct inet_frags *f)
 {
-	if (atomic_dec_and_test(&q->refcnt))
+	if (refcount_dec_and_test(&q->refcnt))
 		inet_frag_destroy(q, f);
 }
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 0574493..08d0d57 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -32,7 +32,7 @@
 #include <net/tcp_states.h>
 #include <net/netns/hash.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <asm/byteorder.h>
 
 /* This is for all connections with a full identity, no wildcards.
@@ -329,7 +329,7 @@ static inline struct sock *inet_lookup(struct net *net,
 	sk = __inet_lookup(net, hashinfo, skb, doff, saddr, sport, daddr,
 			   dport, dif, &refcounted);
 
-	if (sk && !refcounted && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcounted && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
 }
diff --git a/include/net/inetpeer.h b/include/net/inetpeer.h
index 235c781..f2a215f 100644
--- a/include/net/inetpeer.h
+++ b/include/net/inetpeer.h
@@ -46,7 +46,7 @@ struct inet_peer {
 		struct rcu_head     gc_rcu;
 	};
 	/*
-	 * Once inet_peer is queued for deletion (refcnt == -1), following field
+	 * Once inet_peer is queued for deletion (refcnt == 0), following field
 	 * is not available: rid
 	 * We can share memory with rcu_head to help keep inet_peer small.
 	 */
@@ -60,7 +60,7 @@ struct inet_peer {
 
 	/* following fields might be frequently dirtied */
 	__u32			dtime;	/* the time of last use of not referenced entries */
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct inet_peer_base {
diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 5f376af..cdf077b 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -23,6 +23,7 @@
 #include <net/inetpeer.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/refcount.h>
 
 struct fib_config {
 	u8			fc_dst_len;
@@ -105,7 +106,7 @@ struct fib_info {
 	struct hlist_node	fib_lhash;
 	struct net		*fib_net;
 	int			fib_treeref;
-	atomic_t		fib_clntref;
+	refcount_t		fib_clntref;
 	unsigned int		fib_flags;
 	unsigned char		fib_dead;
 	unsigned char		fib_protocol;
@@ -400,12 +401,12 @@ void free_fib_info(struct fib_info *fi);
 
 static inline void fib_info_hold(struct fib_info *fi)
 {
-	atomic_inc(&fi->fib_clntref);
+	refcount_inc(&fi->fib_clntref);
 }
 
 static inline void fib_info_put(struct fib_info *fi)
 {
-	if (atomic_dec_and_test(&fi->fib_clntref))
+	if (refcount_dec_and_test(&fi->fib_clntref))
 		free_fib_info(fi);
 }
 
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index cd6018a..95e1c5d 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -12,6 +12,8 @@
 #include <linux/list.h>                 /* for struct list_head */
 #include <linux/spinlock.h>             /* for struct rwlock_t */
 #include <linux/atomic.h>               /* for struct atomic_t */
+#include <linux/refcount.h>             /* for struct refcount_t */
+
 #include <linux/compiler.h>
 #include <linux/timer.h>
 #include <linux/bug.h>
@@ -525,7 +527,7 @@ struct ip_vs_conn {
 	struct netns_ipvs	*ipvs;
 
 	/* counter and timer */
-	atomic_t		refcnt;		/* reference count */
+	refcount_t		refcnt;		/* reference count */
 	struct timer_list	timer;		/* Expiration timer */
 	volatile unsigned long	timeout;	/* timeout */
 
@@ -618,7 +620,7 @@ struct ip_vs_dest_user_kern {
 struct ip_vs_service {
 	struct hlist_node	s_list;   /* for normal service table */
 	struct hlist_node	f_list;   /* for fwmark-based service table */
-	atomic_t		refcnt;   /* reference counter */
+	refcount_t		refcnt;   /* reference counter */
 
 	u16			af;       /* address family */
 	__u16			protocol; /* which protocol (TCP/UDP) */
@@ -667,7 +669,7 @@ struct ip_vs_dest {
 	atomic_t		conn_flags;	/* flags to copy to conn */
 	atomic_t		weight;		/* server weight */
 
-	atomic_t		refcnt;		/* reference counter */
+	refcount_t		refcnt;		/* reference counter */
 	struct ip_vs_stats      stats;          /* statistics */
 	unsigned long		idle_start;	/* start time, jiffies */
 
@@ -697,7 +699,7 @@ struct ip_vs_dest {
 struct ip_vs_scheduler {
 	struct list_head	n_list;		/* d-linked list head */
 	char			*name;		/* scheduler name */
-	atomic_t		refcnt;		/* reference counter */
+	refcount_t		refcnt;		/* reference counter */
 	struct module		*module;	/* THIS_MODULE/NULL */
 
 	/* scheduler initializing service */
@@ -721,7 +723,7 @@ struct ip_vs_scheduler {
 struct ip_vs_pe {
 	struct list_head	n_list;		/* d-linked list head */
 	char			*name;		/* scheduler name */
-	atomic_t		refcnt;		/* reference counter */
+	refcount_t		refcnt;		/* reference counter */
 	struct module		*module;	/* THIS_MODULE/NULL */
 
 	/* get the connection template, if any */
@@ -1211,14 +1213,14 @@ struct ip_vs_conn * ip_vs_conn_out_get_proto(struct netns_ipvs *ipvs, int af,
  */
 static inline bool __ip_vs_conn_get(struct ip_vs_conn *cp)
 {
-	return atomic_inc_not_zero(&cp->refcnt);
+	return refcount_inc_not_zero(&cp->refcnt);
 }
 
 /* put back the conn without restarting its timer */
 static inline void __ip_vs_conn_put(struct ip_vs_conn *cp)
 {
 	smp_mb__before_atomic();
-	atomic_dec(&cp->refcnt);
+	refcount_dec(&cp->refcnt);
 }
 void ip_vs_conn_put(struct ip_vs_conn *cp);
 void ip_vs_conn_fill_cport(struct ip_vs_conn *cp, __be16 cport);
@@ -1410,19 +1412,21 @@ void ip_vs_try_bind_dest(struct ip_vs_conn *cp);
 
 static inline void ip_vs_dest_hold(struct ip_vs_dest *dest)
 {
-	atomic_inc(&dest->refcnt);
+	refcount_inc(&dest->refcnt);
 }
 
 static inline void ip_vs_dest_put(struct ip_vs_dest *dest)
 {
 	smp_mb__before_atomic();
-	atomic_dec(&dest->refcnt);
+	refcount_dec(&dest->refcnt);
 }
 
 static inline void ip_vs_dest_put_and_free(struct ip_vs_dest *dest)
 {
-	if (atomic_dec_return(&dest->refcnt) < 0)
+	if (refcount_read(&dest->refcnt) == 0)
 		kfree(dest);
+	else
+		refcount_dec(&dest->refcnt);
 }
 
 /* IPVS sync daemon data and function prototypes
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 487e573..f23dc0b 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -16,6 +16,7 @@
 #include <linux/ipv6.h>
 #include <linux/hardirq.h>
 #include <linux/jhash.h>
+#include <linux/refcount.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -203,7 +204,7 @@ extern rwlock_t ip6_ra_lock;
  */
 
 struct ipv6_txoptions {
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	/* Length of this structure */
 	int			tot_len;
 
@@ -265,7 +266,7 @@ static inline struct ipv6_txoptions *txopt_get(const struct ipv6_pinfo *np)
 	rcu_read_lock();
 	opt = rcu_dereference(np->opt);
 	if (opt) {
-		if (!atomic_inc_not_zero(&opt->refcnt))
+		if (!refcount_inc_not_zero(&opt->refcnt))
 			opt = NULL;
 		else
 			opt = rcu_pointer_handoff(opt);
@@ -276,7 +277,7 @@ static inline struct ipv6_txoptions *txopt_get(const struct ipv6_pinfo *np)
 
 static inline void txopt_put(struct ipv6_txoptions *opt)
 {
-	if (opt && atomic_dec_and_test(&opt->refcnt))
+	if (opt && refcount_dec_and_test(&opt->refcnt))
 		kfree_rcu(opt, rcu);
 }
 
diff --git a/include/net/ipx.h b/include/net/ipx.h
index e5cff68..af32b97 100644
--- a/include/net/ipx.h
+++ b/include/net/ipx.h
@@ -14,6 +14,7 @@
 #include <linux/ipx.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 struct ipx_address {
 	__be32  net;
@@ -54,7 +55,7 @@ struct ipx_interface {
 	/* IPX address */
 	__be32			if_netnum;
 	unsigned char		if_node[IPX_NODE_LEN];
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 
 	/* physical device info */
 	struct net_device	*if_dev;
@@ -80,7 +81,7 @@ struct ipx_route {
 	unsigned char		ir_routed;
 	unsigned char		ir_router_node[IPX_NODE_LEN];
 	struct list_head	node; /* node in ipx_routes list */
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct ipx_cb {
@@ -139,7 +140,7 @@ const char *ipx_device_name(struct ipx_interface *intrfc);
 
 static __inline__ void ipxitf_hold(struct ipx_interface *intrfc)
 {
-	atomic_inc(&intrfc->refcnt);
+	refcount_inc(&intrfc->refcnt);
 }
 
 void ipxitf_down(struct ipx_interface *intrfc);
@@ -157,18 +158,18 @@ int ipxrtr_ioctl(unsigned int cmd, void __user *arg);
 
 static __inline__ void ipxitf_put(struct ipx_interface *intrfc)
 {
-	if (atomic_dec_and_test(&intrfc->refcnt))
+	if (refcount_dec_and_test(&intrfc->refcnt))
 		ipxitf_down(intrfc);
 }
 
 static __inline__ void ipxrtr_hold(struct ipx_route *rt)
 {
-	        atomic_inc(&rt->refcnt);
+	        refcount_inc(&rt->refcnt);
 }
 
 static __inline__ void ipxrtr_put(struct ipx_route *rt)
 {
-	        if (atomic_dec_and_test(&rt->refcnt))
+	        if (refcount_dec_and_test(&rt->refcnt))
 			                kfree(rt);
 }
 #endif /* _NET_INET_IPX_H_ */
diff --git a/include/net/lapb.h b/include/net/lapb.h
index 9510f87..85e7737 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -1,6 +1,7 @@
 #ifndef _LAPB_H
 #define _LAPB_H 
 #include <linux/lapb.h>
+#include <linux/refcount.h>
 
 #define	LAPB_HEADER_LEN	20		/* LAPB over Ethernet + a bit more */
 
@@ -101,7 +102,7 @@ struct lapb_cb {
 	struct lapb_frame	frmr_data;
 	unsigned char		frmr_type;
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 /* lapb_iface.c */
diff --git a/include/net/lib80211.h b/include/net/lib80211.h
index aab0f42..9fd9042 100644
--- a/include/net/lib80211.h
+++ b/include/net/lib80211.h
@@ -93,7 +93,7 @@ struct lib80211_crypt_data {
 	struct list_head list;	/* delayed deletion list */
 	struct lib80211_crypto_ops *ops;
 	void *priv;
-	atomic_t refcnt;
+	refcount_t refcnt;
 };
 
 struct lib80211_crypt_info {
diff --git a/include/net/llc.h b/include/net/llc.h
index e8e61d4..dc35f25 100644
--- a/include/net/llc.h
+++ b/include/net/llc.h
@@ -55,7 +55,7 @@ struct llc_sap {
 	unsigned char	 state;
 	unsigned char	 p_bit;
 	unsigned char	 f_bit;
-	atomic_t         refcnt;
+	refcount_t		 refcnt;
 	int		 (*rcv_func)(struct sk_buff *skb,
 				     struct net_device *dev,
 				     struct packet_type *pt,
@@ -113,14 +113,14 @@ struct llc_sap *llc_sap_open(unsigned char lsap,
 					struct net_device *orig_dev));
 static inline void llc_sap_hold(struct llc_sap *sap)
 {
-	atomic_inc(&sap->refcnt);
+	refcount_inc(&sap->refcnt);
 }
 
 void llc_sap_close(struct llc_sap *sap);
 
 static inline void llc_sap_put(struct llc_sap *sap)
 {
-	if (atomic_dec_and_test(&sap->refcnt))
+	if (refcount_dec_and_test(&sap->refcnt))
 		llc_sap_close(sap);
 }
 
diff --git a/include/net/lwtunnel.h b/include/net/lwtunnel.h
index d4c1c75..932ff0c 100644
--- a/include/net/lwtunnel.h
+++ b/include/net/lwtunnel.h
@@ -5,6 +5,7 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/types.h>
+#include <linux/refcount.h>
 #include <net/route.h>
 
 #define LWTUNNEL_HASH_BITS   7
@@ -25,7 +26,7 @@ struct lwtunnel_state {
 	__u16		type;
 	__u16		flags;
 	__u16		headroom;
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	int		(*orig_output)(struct net *net, struct sock *sk, struct sk_buff *skb);
 	int		(*orig_input)(struct sk_buff *);
 	struct		rcu_head rcu;
@@ -53,7 +54,7 @@ static inline struct lwtunnel_state *
 lwtstate_get(struct lwtunnel_state *lws)
 {
 	if (lws)
-		atomic_inc(&lws->refcnt);
+		refcount_inc(&lws->refcnt);
 
 	return lws;
 }
@@ -63,7 +64,7 @@ static inline void lwtstate_put(struct lwtunnel_state *lws)
 	if (!lws)
 		return;
 
-	if (atomic_dec_and_test(&lws->refcnt))
+	if (refcount_dec_and_test(&lws->refcnt))
 		lwtstate_free(lws);
 }
 
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index d562a2f..0224bce 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -384,7 +384,7 @@ static inline struct neighbour *__ipv6_neigh_lookup(struct net_device *dev, cons
 
 	rcu_read_lock_bh();
 	n = __ipv6_neigh_lookup_noref(dev, pkey);
-	if (n && !atomic_inc_not_zero(&n->refcnt))
+	if (n && !refcount_inc_not_zero(&n->refcnt))
 		n = NULL;
 	rcu_read_unlock_bh();
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 8b68384..33e534a 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -17,6 +17,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <linux/rcupdate.h>
@@ -76,7 +77,7 @@ struct neigh_parms {
 	void	*sysctl_table;
 
 	int dead;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct rcu_head rcu_head;
 
 	int	reachable_time;
@@ -137,7 +138,7 @@ struct neighbour {
 	unsigned long		confirmed;
 	unsigned long		updated;
 	rwlock_t		lock;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct sk_buff_head	arp_queue;
 	unsigned int		arp_queue_len_bytes;
 	struct timer_list	timer;
@@ -393,12 +394,12 @@ void neigh_sysctl_unregister(struct neigh_parms *p);
 
 static inline void __neigh_parms_put(struct neigh_parms *parms)
 {
-	atomic_dec(&parms->refcnt);
+	refcount_dec(&parms->refcnt);
 }
 
 static inline struct neigh_parms *neigh_parms_clone(struct neigh_parms *parms)
 {
-	atomic_inc(&parms->refcnt);
+	refcount_inc(&parms->refcnt);
 	return parms;
 }
 
@@ -408,18 +409,18 @@ static inline struct neigh_parms *neigh_parms_clone(struct neigh_parms *parms)
 
 static inline void neigh_release(struct neighbour *neigh)
 {
-	if (atomic_dec_and_test(&neigh->refcnt))
+	if (refcount_dec_and_test(&neigh->refcnt))
 		neigh_destroy(neigh);
 }
 
 static inline struct neighbour * neigh_clone(struct neighbour *neigh)
 {
 	if (neigh)
-		atomic_inc(&neigh->refcnt);
+		refcount_inc(&neigh->refcnt);
 	return neigh;
 }
 
-#define neigh_hold(n)	atomic_inc(&(n)->refcnt)
+#define neigh_hold(n)	refcount_inc(&(n)->refcnt)
 
 static inline int neigh_event_send(struct neighbour *neigh, struct sk_buff *skb)
 {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index af8fe8a..ec6dcaf 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -5,6 +5,7 @@
 #define __NET_NET_NAMESPACE_H
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
 #include <linux/sysctl.h>
@@ -45,7 +46,7 @@ struct netns_ipvs;
 #define NETDEV_HASHENTRIES (1 << NETDEV_HASHBITS)
 
 struct net {
-	atomic_t		passive;	/* To decided when the network
+	refcount_t		passive;	/* To decided when the network
 						 * namespace should be freed.
 						 */
 	atomic_t		count;		/* To decided when the network
diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index 0b0c35c..925524e 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -8,7 +8,7 @@ static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
 	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
 
 	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
+		refcount_set(&(skb->nf_bridge->use), 1);
 
 	return skb->nf_bridge;
 }
diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 5ed33ea..65cc2cb 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -5,6 +5,8 @@
 #ifndef _NF_CONNTRACK_EXPECT_H
 #define _NF_CONNTRACK_EXPECT_H
 
+#include <linux/refcount.h>
+
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_zones.h>
 
@@ -37,7 +39,7 @@ struct nf_conntrack_expect {
 	struct timer_list timeout;
 
 	/* Usage count. */
-	atomic_t use;
+	refcount_t use;
 
 	/* Flags */
 	unsigned int flags;
diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 5cc5e9e..d40b893 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -4,6 +4,7 @@
 #include <net/net_namespace.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/nf_conntrack_tuple_common.h>
+#include <linux/refcount.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
@@ -12,7 +13,7 @@
 struct ctnl_timeout {
 	struct list_head	head;
 	struct rcu_head		rcu_head;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	char			name[CTNL_TIMEOUT_NAME_MAX];
 	__u16			l3num;
 	struct nf_conntrack_l4proto *l4proto;
diff --git a/include/net/netlabel.h b/include/net/netlabel.h
index efe9806..72d6435 100644
--- a/include/net/netlabel.h
+++ b/include/net/netlabel.h
@@ -37,7 +37,7 @@
 #include <linux/in6.h>
 #include <net/netlink.h>
 #include <net/request_sock.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 struct cipso_v4_doi;
 struct calipso_doi;
@@ -136,7 +136,7 @@ struct netlbl_audit {
  *
  */
 struct netlbl_lsm_cache {
-	atomic_t refcount;
+	refcount_t refcount;
 	void (*free) (const void *data);
 	void *data;
 };
@@ -295,7 +295,7 @@ static inline struct netlbl_lsm_cache *netlbl_secattr_cache_alloc(gfp_t flags)
 
 	cache = kzalloc(sizeof(*cache), flags);
 	if (cache)
-		atomic_set(&cache->refcount, 1);
+		refcount_set(&cache->refcount, 1);
 	return cache;
 }
 
@@ -309,7 +309,7 @@ static inline struct netlbl_lsm_cache *netlbl_secattr_cache_alloc(gfp_t flags)
  */
 static inline void netlbl_secattr_cache_free(struct netlbl_lsm_cache *cache)
 {
-	if (!atomic_dec_and_test(&cache->refcount))
+	if (!refcount_dec_and_test(&cache->refcount))
 		return;
 
 	if (cache->free)
diff --git a/include/net/netrom.h b/include/net/netrom.h
index 110350a..443a4ff 100644
--- a/include/net/netrom.h
+++ b/include/net/netrom.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <net/sock.h>
+#include <linux/refcount.h>
 
 #define	NR_NETWORK_LEN			15
 #define	NR_TRANSPORT_LEN		5
@@ -93,7 +94,7 @@ struct nr_neigh {
 	unsigned short		count;
 	unsigned int		number;
 	unsigned char		failed;
-	atomic_t		refcount;
+	refcount_t		refcount;
 };
 
 struct nr_route {
@@ -109,7 +110,7 @@ struct nr_node {
 	unsigned char		which;
 	unsigned char		count;
 	struct nr_route		routes[3];
-	atomic_t		refcount;
+	refcount_t		refcount;
 	spinlock_t		node_lock;
 };
 
@@ -118,21 +119,21 @@ struct nr_node {
  *********************************************************************/
 
 #define nr_node_hold(__nr_node) \
-	atomic_inc(&((__nr_node)->refcount))
+	refcount_inc(&((__nr_node)->refcount))
 
 static __inline__ void nr_node_put(struct nr_node *nr_node)
 {
-	if (atomic_dec_and_test(&nr_node->refcount)) {
+	if (refcount_dec_and_test(&nr_node->refcount)) {
 		kfree(nr_node);
 	}
 }
 
 #define nr_neigh_hold(__nr_neigh) \
-	atomic_inc(&((__nr_neigh)->refcount))
+	refcount_inc(&((__nr_neigh)->refcount))
 
 static __inline__ void nr_neigh_put(struct nr_neigh *nr_neigh)
 {
-	if (atomic_dec_and_test(&nr_neigh->refcount)) {
+	if (refcount_dec_and_test(&nr_neigh->refcount)) {
 		if (nr_neigh->ax25)
 			ax25_cb_put(nr_neigh->ax25);
 		kfree(nr_neigh->digipeat);
diff --git a/include/net/request_sock.h b/include/net/request_sock.h
index 6ebe13e..696a53d 100644
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -19,6 +19,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/bug.h>
+#include <linux/refcount.h>
 
 #include <net/sock.h>
 
@@ -89,7 +90,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 		return NULL;
 	req->rsk_listener = NULL;
 	if (attach_listener) {
-		if (unlikely(!atomic_inc_not_zero(&sk_listener->sk_refcnt))) {
+		if (unlikely(!refcount_inc_not_zero(&sk_listener->sk_refcnt))) {
 			kmem_cache_free(ops->slab, req);
 			return NULL;
 		}
@@ -100,7 +101,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 	sk_node_init(&req_to_sk(req)->sk_node);
 	sk_tx_queue_clear(req_to_sk(req));
 	req->saved_syn = NULL;
-	atomic_set(&req->rsk_refcnt, 0);
+	refcount_set(&req->rsk_refcnt, 0);
 
 	return req;
 }
@@ -108,7 +109,7 @@ reqsk_alloc(const struct request_sock_ops *ops, struct sock *sk_listener,
 static inline void reqsk_free(struct request_sock *req)
 {
 	/* temporary debugging */
-	WARN_ON_ONCE(atomic_read(&req->rsk_refcnt) != 0);
+	WARN_ON_ONCE(refcount_read(&req->rsk_refcnt) != 0);
 
 	req->rsk_ops->destructor(req);
 	if (req->rsk_listener)
@@ -119,7 +120,7 @@ static inline void reqsk_free(struct request_sock *req)
 
 static inline void reqsk_put(struct request_sock *req)
 {
-	if (atomic_dec_and_test(&req->rsk_refcnt))
+	if (refcount_dec_and_test(&req->rsk_refcnt))
 		reqsk_free(req);
 }
 
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 498f81b..fbcdd64 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -8,6 +8,7 @@
 #include <linux/pkt_cls.h>
 #include <linux/percpu.h>
 #include <linux/dynamic_queue_limits.h>
+#include <linux/refcount.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
 
@@ -93,7 +94,7 @@ struct Qdisc {
 	struct sk_buff		*skb_bad_txq;
 	struct rcu_head		rcu_head;
 	int			padded;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 
 	spinlock_t		busylock ____cacheline_aligned_in_smp;
 };
diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index 9b9fb12..328fccc 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -31,6 +31,7 @@
 #define __sctp_auth_h__
 
 #include <linux/list.h>
+#include <linux/refcount.h>
 
 struct sctp_endpoint;
 struct sctp_association;
@@ -53,7 +54,7 @@ struct sctp_hmac {
  * over SCTP-AUTH
  */
 struct sctp_auth_bytes {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	__u32 len;
 	__u8  data[];
 };
@@ -76,7 +77,7 @@ static inline void sctp_auth_key_hold(struct sctp_auth_bytes *key)
 	if (!key)
 		return;
 
-	atomic_inc(&key->refcnt);
+	refcount_inc(&key->refcnt);
 }
 
 void sctp_auth_key_put(struct sctp_auth_bytes *key);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 92daabd..07d514d 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -524,7 +524,7 @@ struct sctp_datamsg {
 	/* Chunks waiting to be submitted to lower layer. */
 	struct list_head chunks;
 	/* Reference counting. */
-	atomic_t refcnt;
+	refcount_t refcnt;
 	/* When is this message no longer interesting to the peer? */
 	unsigned long expires_at;
 	/* Did the messenge fail to send? */
@@ -552,7 +552,7 @@ int sctp_chunk_abandoned(struct sctp_chunk *);
 struct sctp_chunk {
 	struct list_head list;
 
-	atomic_t refcnt;
+	refcount_t refcnt;
 
 	/* How many times this chunk have been sent, for prsctp RTX policy */
 	int sent_count;
@@ -764,7 +764,7 @@ struct sctp_transport {
 	struct rhlist_head node;
 
 	/* Reference counting. */
-	atomic_t refcnt;
+	refcount_t refcnt;
 		/* RTO-Pending : A flag used to track if one of the DATA
 		 *		chunks sent to this address is currently being
 		 *		used to compute a RTT. If this flag is 0,
@@ -1195,7 +1195,7 @@ struct sctp_ep_common {
 	 *   refcnt   - Reference count access to this object.
 	 *   dead     - Do not attempt to use this object.
 	 */
-	atomic_t    refcnt;
+	refcount_t    refcnt;
 	bool	    dead;
 
 	/* What socket does this endpoint belong to?  */
diff --git a/include/net/sock.h b/include/net/sock.h
index f0e867f..3b646eb 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -66,6 +66,7 @@
 #include <linux/poll.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <net/dst.h>
 #include <net/checksum.h>
 #include <net/tcp_states.h>
@@ -218,7 +219,7 @@ struct sock_common {
 		u32		skc_tw_rcv_nxt; /* struct tcp_timewait_sock  */
 	};
 
-	atomic_t		skc_refcnt;
+	refcount_t		skc_refcnt;
 	/* private: */
 	int                     skc_dontcopy_end[0];
 	union {
@@ -386,7 +387,7 @@ struct sock {
 
 	/* ===== cache line for TX ===== */
 	int			sk_wmem_queued;
-	atomic_t		sk_wmem_alloc;
+	refcount_t		sk_wmem_alloc;
 	unsigned long		sk_tsq_flags;
 	struct sk_buff		*sk_send_head;
 	struct sk_buff_head	sk_write_queue;
@@ -599,7 +600,7 @@ static inline bool __sk_del_node_init(struct sock *sk)
 
 static __always_inline void sock_hold(struct sock *sk)
 {
-	atomic_inc(&sk->sk_refcnt);
+	refcount_inc(&sk->sk_refcnt);
 }
 
 /* Ungrab socket in the context, which assumes that socket refcnt
@@ -607,7 +608,7 @@ static __always_inline void sock_hold(struct sock *sk)
  */
 static __always_inline void __sock_put(struct sock *sk)
 {
-	atomic_dec(&sk->sk_refcnt);
+	refcount_dec(&sk->sk_refcnt);
 }
 
 static inline bool sk_del_node_init(struct sock *sk)
@@ -616,7 +617,7 @@ static inline bool sk_del_node_init(struct sock *sk)
 
 	if (rc) {
 		/* paranoid for a while -acme */
-		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
+		WARN_ON(refcount_read(&sk->sk_refcnt) == 1);
 		__sock_put(sk);
 	}
 	return rc;
@@ -638,7 +639,7 @@ static inline bool sk_nulls_del_node_init_rcu(struct sock *sk)
 
 	if (rc) {
 		/* paranoid for a while -acme */
-		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
+		WARN_ON(refcount_read(&sk->sk_refcnt) == 1);
 		__sock_put(sk);
 	}
 	return rc;
@@ -1124,9 +1125,9 @@ static inline void sk_refcnt_debug_dec(struct sock *sk)
 
 static inline void sk_refcnt_debug_release(const struct sock *sk)
 {
-	if (atomic_read(&sk->sk_refcnt) != 1)
+	if (refcount_read(&sk->sk_refcnt) != 1)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
-		       sk->sk_prot->name, sk, atomic_read(&sk->sk_refcnt));
+		       sk->sk_prot->name, sk, refcount_read(&sk->sk_refcnt));
 }
 #else /* SOCK_REFCNT_DEBUG */
 #define sk_refcnt_debug_inc(sk) do { } while (0)
@@ -1634,7 +1635,7 @@ void sock_init_data(struct socket *sock, struct sock *sk);
 /* Ungrab socket and destroy it, if it was the last reference. */
 static inline void sock_put(struct sock *sk)
 {
-	if (atomic_dec_and_test(&sk->sk_refcnt))
+	if (refcount_dec_and_test(&sk->sk_refcnt))
 		sk_free(sk);
 }
 /* Generic version of sock_put(), dealing with all sockets
@@ -1889,7 +1890,7 @@ static inline int skb_copy_to_page_nocache(struct sock *sk, struct iov_iter *fro
  */
 static inline int sk_wmem_alloc_get(const struct sock *sk)
 {
-	return atomic_read(&sk->sk_wmem_alloc) - 1;
+	return refcount_read(&sk->sk_wmem_alloc) - 1;
 }
 
 /**
@@ -2031,7 +2032,7 @@ static inline unsigned long sock_wspace(struct sock *sk)
 	int amt = 0;
 
 	if (!(sk->sk_shutdown & SEND_SHUTDOWN)) {
-		amt = sk->sk_sndbuf - atomic_read(&sk->sk_wmem_alloc);
+		amt = sk->sk_sndbuf - refcount_read(&sk->sk_wmem_alloc);
 		if (amt < 0)
 			amt = 0;
 	}
@@ -2112,7 +2113,7 @@ bool sk_page_frag_refill(struct sock *sk, struct page_frag *pfrag);
  */
 static inline bool sock_writeable(const struct sock *sk)
 {
-	return atomic_read(&sk->sk_wmem_alloc) < (sk->sk_sndbuf >> 1);
+	return refcount_read(&sk->sk_wmem_alloc) < (sk->sk_sndbuf >> 1);
 }
 
 static inline gfp_t gfp_any(void)
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 49a5920..5c117b4 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -183,7 +183,7 @@ struct vxlan_sock {
 	struct hlist_node hlist;
 	struct socket	 *sock;
 	struct hlist_head vni_list[VNI_HASH_SIZE];
-	atomic_t	  refcnt;
+	refcount_t	  refcnt;
 	u32		  flags;
 };
 
diff --git a/include/net/x25.h b/include/net/x25.h
index c383aa4..6219daf 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -11,6 +11,7 @@
 #define _X25_H 
 #include <linux/x25.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 #include <net/sock.h>
 
 #define	X25_ADDR_LEN			16
@@ -129,7 +130,7 @@ struct x25_route {
 	struct x25_address	address;
 	unsigned int		sigdigits;
 	struct net_device	*dev;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct x25_neigh {
@@ -141,7 +142,7 @@ struct x25_neigh {
 	unsigned long		t20;
 	struct timer_list	t20timer;
 	unsigned long		global_facil_mask;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct x25_sock {
@@ -171,7 +172,7 @@ struct x25_forward {
 	unsigned int		lci;
 	struct net_device	*dev1;
 	struct net_device	*dev2;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 static inline struct x25_sock *x25_sk(const struct sock *sk)
@@ -242,12 +243,12 @@ void x25_link_free(void);
 /* x25_neigh.c */
 static __inline__ void x25_neigh_hold(struct x25_neigh *nb)
 {
-	atomic_inc(&nb->refcnt);
+	refcount_inc(&nb->refcnt);
 }
 
 static __inline__ void x25_neigh_put(struct x25_neigh *nb)
 {
-	if (atomic_dec_and_test(&nb->refcnt))
+	if (refcount_dec_and_test(&nb->refcnt))
 		kfree(nb);
 }
 
@@ -265,12 +266,12 @@ void x25_route_free(void);
 
 static __inline__ void x25_route_hold(struct x25_route *rt)
 {
-	atomic_inc(&rt->refcnt);
+	refcount_inc(&rt->refcnt);
 }
 
 static __inline__ void x25_route_put(struct x25_route *rt)
 {
-	if (atomic_dec_and_test(&rt->refcnt))
+	if (refcount_dec_and_test(&rt->refcnt))
 		kfree(rt);
 }
 
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 31947b9..54a8967 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -13,6 +13,7 @@
 #include <linux/mutex.h>
 #include <linux/audit.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 #include <net/sock.h>
 #include <net/dst.h>
@@ -130,7 +131,7 @@ struct xfrm_state {
 	struct hlist_node	bysrc;
 	struct hlist_node	byspi;
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	spinlock_t		lock;
 
 	struct xfrm_id		id;
@@ -524,7 +525,7 @@ struct xfrm_policy {
 
 	/* This lock only affects elements except for entry. */
 	rwlock_t		lock;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct timer_list	timer;
 
 	struct flow_cache_object flo;
@@ -779,14 +780,14 @@ static inline void xfrm_audit_state_icvfail(struct xfrm_state *x,
 static inline void xfrm_pol_hold(struct xfrm_policy *policy)
 {
 	if (likely(policy != NULL))
-		atomic_inc(&policy->refcnt);
+		refcount_inc(&policy->refcnt);
 }
 
 void xfrm_policy_destroy(struct xfrm_policy *policy);
 
 static inline void xfrm_pol_put(struct xfrm_policy *policy)
 {
-	if (atomic_dec_and_test(&policy->refcnt))
+	if (refcount_dec_and_test(&policy->refcnt))
 		xfrm_policy_destroy(policy);
 }
 
@@ -801,18 +802,18 @@ void __xfrm_state_destroy(struct xfrm_state *);
 
 static inline void __xfrm_state_put(struct xfrm_state *x)
 {
-	atomic_dec(&x->refcnt);
+	refcount_dec(&x->refcnt);
 }
 
 static inline void xfrm_state_put(struct xfrm_state *x)
 {
-	if (atomic_dec_and_test(&x->refcnt))
+	if (refcount_dec_and_test(&x->refcnt))
 		__xfrm_state_destroy(x);
 }
 
 static inline void xfrm_state_hold(struct xfrm_state *x)
 {
-	atomic_inc(&x->refcnt);
+	refcount_inc(&x->refcnt);
 }
 
 static inline bool addr_match(const void *token1, const void *token2,
@@ -975,7 +976,7 @@ static inline void xfrm_dst_destroy(struct xfrm_dst *xdst)
 void xfrm_dst_ifdown(struct dst_entry *dst, struct net_device *dev);
 
 struct sec_path {
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	int			len;
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 };
@@ -993,7 +994,7 @@ static inline struct sec_path *
 secpath_get(struct sec_path *sp)
 {
 	if (sp)
-		atomic_inc(&sp->refcnt);
+		refcount_inc(&sp->refcnt);
 	return sp;
 }
 
@@ -1002,7 +1003,7 @@ void __secpath_destroy(struct sec_path *sp);
 static inline void
 secpath_put(struct sec_path *sp)
 {
-	if (sp && atomic_dec_and_test(&sp->refcnt))
+	if (sp && refcount_dec_and_test(&sp->refcnt))
 		__secpath_destroy(sp);
 }
 
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index fca84e1..4e11119 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -252,7 +252,7 @@ static int br2684_xmit_vcc(struct sk_buff *skb, struct net_device *dev,
 
 	ATM_SKB(skb)->vcc = atmvcc = brvcc->atmvcc;
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n", skb, atmvcc, atmvcc->dev);
-	atomic_add(skb->truesize, &sk_atm(atmvcc)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(atmvcc)->sk_wmem_alloc);
 	ATM_SKB(skb)->atm_options = atmvcc->atm_options;
 	dev->stats.tx_packets++;
 	dev->stats.tx_bytes += skb->len;
diff --git a/net/atm/clip.c b/net/atm/clip.c
index 53b4ac0..e2e1318 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -137,11 +137,11 @@ static int neigh_check_cb(struct neighbour *n)
 	if (entry->vccs || time_before(jiffies, entry->expires))
 		return 0;
 
-	if (atomic_read(&n->refcnt) > 1) {
+	if (refcount_read(&n->refcnt) > 1) {
 		struct sk_buff *skb;
 
 		pr_debug("destruction postponed with ref %d\n",
-			 atomic_read(&n->refcnt));
+			 refcount_read(&n->refcnt));
 
 		while ((skb = skb_dequeue(&n->arp_queue)) != NULL)
 			dev_kfree_skb(skb);
@@ -381,7 +381,7 @@ static netdev_tx_t clip_start_xmit(struct sk_buff *skb,
 		memcpy(here, llc_oui, sizeof(llc_oui));
 		((__be16 *) here)[3] = skb->protocol;
 	}
-	atomic_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
 	ATM_SKB(skb)->atm_options = vcc->atm_options;
 	entry->vccs->last_use = jiffies;
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n", skb, vcc, vcc->dev);
@@ -767,7 +767,7 @@ static void atmarp_info(struct seq_file *seq, struct neighbour *n,
 			seq_printf(seq, "(resolving)\n");
 		else
 			seq_printf(seq, "(expired, ref %d)\n",
-				   atomic_read(&entry->neigh->refcnt));
+				   refcount_read(&entry->neigh->refcnt));
 	} else if (!svc) {
 		seq_printf(seq, "%d.%d.%d\n",
 			   clip_vcc->vcc->dev->number,
diff --git a/net/atm/common.c b/net/atm/common.c
index a3ca922..16b2c25 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -75,7 +75,7 @@ static struct sk_buff *alloc_tx(struct atm_vcc *vcc, unsigned int size)
 	while (!(skb = alloc_skb(size, GFP_KERNEL)))
 		schedule();
 	pr_debug("%d += %d\n", sk_wmem_alloc_get(sk), skb->truesize);
-	atomic_add(skb->truesize, &sk->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 	return skb;
 }
 
@@ -85,9 +85,9 @@ static void vcc_sock_destruct(struct sock *sk)
 		printk(KERN_DEBUG "%s: rmem leakage (%d bytes) detected.\n",
 		       __func__, atomic_read(&sk->sk_rmem_alloc));
 
-	if (atomic_read(&sk->sk_wmem_alloc))
+	if (refcount_read(&sk->sk_wmem_alloc))
 		printk(KERN_DEBUG "%s: wmem leakage (%d bytes) detected.\n",
-		       __func__, atomic_read(&sk->sk_wmem_alloc));
+		       __func__, refcount_read(&sk->sk_wmem_alloc));
 }
 
 static void vcc_def_wakeup(struct sock *sk)
@@ -106,7 +106,7 @@ static inline int vcc_writable(struct sock *sk)
 	struct atm_vcc *vcc = atm_sk(sk);
 
 	return (vcc->qos.txtp.max_sdu +
-		atomic_read(&sk->sk_wmem_alloc)) <= sk->sk_sndbuf;
+		refcount_read(&sk->sk_wmem_alloc)) <= sk->sk_sndbuf;
 }
 
 static void vcc_write_space(struct sock *sk)
@@ -161,7 +161,7 @@ int vcc_create(struct net *net, struct socket *sock, int protocol, int family, i
 	memset(&vcc->local, 0, sizeof(struct sockaddr_atmsvc));
 	memset(&vcc->remote, 0, sizeof(struct sockaddr_atmsvc));
 	vcc->qos.txtp.max_sdu = 1 << 16; /* for meta VCs */
-	atomic_set(&sk->sk_wmem_alloc, 1);
+	refcount_set(&sk->sk_wmem_alloc, 1);
 	atomic_set(&sk->sk_rmem_alloc, 0);
 	vcc->push = NULL;
 	vcc->pop = NULL;
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 019557d..1bc6722 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -101,12 +101,12 @@ static void lec_vcc_close(struct lec_priv *priv, struct atm_vcc *vcc);
 /* must be done under lec_arp_lock */
 static inline void lec_arp_hold(struct lec_arp_table *entry)
 {
-	atomic_inc(&entry->usage);
+	refcount_inc(&entry->usage);
 }
 
 static inline void lec_arp_put(struct lec_arp_table *entry)
 {
-	if (atomic_dec_and_test(&entry->usage))
+	if (refcount_dec_and_test(&entry->usage))
 		kfree(entry);
 }
 
@@ -181,7 +181,7 @@ lec_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	ATM_SKB(skb)->vcc = vcc;
 	ATM_SKB(skb)->atm_options = vcc->atm_options;
 
-	atomic_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
 	if (vcc->send(vcc, skb) < 0) {
 		dev->stats.tx_dropped++;
 		return;
@@ -345,7 +345,7 @@ static int lec_atm_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	int i;
 	char *tmp;		/* FIXME */
 
-	atomic_sub(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc));
 	mesg = (struct atmlec_msg *)skb->data;
 	tmp = skb->data;
 	tmp += sizeof(struct atmlec_msg);
@@ -1216,6 +1216,7 @@ static void lane2_associate_ind(struct net_device *dev, const u8 *mac_addr,
 #include <linux/timer.h>
 #include <linux/param.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/inetdevice.h>
 #include <net/route.h>
 
@@ -1562,7 +1563,7 @@ static struct lec_arp_table *make_entry(struct lec_priv *priv,
 	to_return->last_used = jiffies;
 	to_return->priv = priv;
 	skb_queue_head_init(&to_return->tx_wait);
-	atomic_set(&to_return->usage, 1);
+	refcount_set(&to_return->usage, 1);
 	return to_return;
 }
 
diff --git a/net/atm/lec_arpc.h b/net/atm/lec_arpc.h
index ec67435..7ff4e7c 100644
--- a/net/atm/lec_arpc.h
+++ b/net/atm/lec_arpc.h
@@ -47,7 +47,7 @@ struct lec_arp_table {
 					 * the length of the tlvs array
 					 */
 	struct sk_buff_head tx_wait;	/* wait queue for outgoing packets */
-	atomic_t usage;			/* usage count */
+	refcount_t usage;				/* usage count */
 };
 
 /*
diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 3b3b1a2..5741820 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -555,7 +555,7 @@ static int send_via_shortcut(struct sk_buff *skb, struct mpoa_client *mpc)
 					sizeof(struct llc_snap_hdr));
 	}
 
-	atomic_add(skb->truesize, &sk_atm(entry->shortcut)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(entry->shortcut)->sk_wmem_alloc);
 	ATM_SKB(skb)->atm_options = entry->shortcut->atm_options;
 	entry->shortcut->send(entry->shortcut, skb);
 	entry->packets_fwded++;
@@ -911,7 +911,7 @@ static int msg_from_mpoad(struct atm_vcc *vcc, struct sk_buff *skb)
 
 	struct mpoa_client *mpc = find_mpc_by_vcc(vcc);
 	struct k_message *mesg = (struct k_message *)skb->data;
-	atomic_sub(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc));
 
 	if (mpc == NULL) {
 		pr_info("no mpc found\n");
diff --git a/net/atm/mpoa_caches.c b/net/atm/mpoa_caches.c
index a89fdeb..4ccaa16 100644
--- a/net/atm/mpoa_caches.c
+++ b/net/atm/mpoa_caches.c
@@ -40,7 +40,7 @@ static in_cache_entry *in_cache_get(__be32 dst_ip,
 	entry = client->in_cache;
 	while (entry != NULL) {
 		if (entry->ctrl_info.in_dst_ip == dst_ip) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_bh(&client->ingress_lock);
 			return entry;
 		}
@@ -61,7 +61,7 @@ static in_cache_entry *in_cache_get_with_mask(__be32 dst_ip,
 	entry = client->in_cache;
 	while (entry != NULL) {
 		if ((entry->ctrl_info.in_dst_ip & mask) == (dst_ip & mask)) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_bh(&client->ingress_lock);
 			return entry;
 		}
@@ -82,7 +82,7 @@ static in_cache_entry *in_cache_get_by_vcc(struct atm_vcc *vcc,
 	entry = client->in_cache;
 	while (entry != NULL) {
 		if (entry->shortcut == vcc) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_bh(&client->ingress_lock);
 			return entry;
 		}
@@ -105,7 +105,7 @@ static in_cache_entry *in_cache_add_entry(__be32 dst_ip,
 
 	dprintk("adding an ingress entry, ip = %pI4\n", &dst_ip);
 
-	atomic_set(&entry->use, 1);
+	refcount_set(&entry->use, 1);
 	dprintk("new_in_cache_entry: about to lock\n");
 	write_lock_bh(&client->ingress_lock);
 	entry->next = client->in_cache;
@@ -121,7 +121,7 @@ static in_cache_entry *in_cache_add_entry(__be32 dst_ip,
 	entry->count = 1;
 	entry->entry_state = INGRESS_INVALID;
 	entry->ctrl_info.holding_time = HOLDING_TIME_DEFAULT;
-	atomic_inc(&entry->use);
+	refcount_inc(&entry->use);
 
 	write_unlock_bh(&client->ingress_lock);
 	dprintk("new_in_cache_entry: unlocked\n");
@@ -178,7 +178,7 @@ static int cache_hit(in_cache_entry *entry, struct mpoa_client *mpc)
 
 static void in_cache_put(in_cache_entry *entry)
 {
-	if (atomic_dec_and_test(&entry->use)) {
+	if (refcount_dec_and_test(&entry->use)) {
 		memset(entry, 0, sizeof(in_cache_entry));
 		kfree(entry);
 	}
@@ -339,7 +339,7 @@ static eg_cache_entry *eg_cache_get_by_cache_id(__be32 cache_id,
 	entry = mpc->eg_cache;
 	while (entry != NULL) {
 		if (entry->ctrl_info.cache_id == cache_id) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_irq(&mpc->egress_lock);
 			return entry;
 		}
@@ -360,7 +360,7 @@ static eg_cache_entry *eg_cache_get_by_tag(__be32 tag, struct mpoa_client *mpc)
 	entry = mpc->eg_cache;
 	while (entry != NULL) {
 		if (entry->ctrl_info.tag == tag) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_irqrestore(&mpc->egress_lock, flags);
 			return entry;
 		}
@@ -382,7 +382,7 @@ static eg_cache_entry *eg_cache_get_by_vcc(struct atm_vcc *vcc,
 	entry = mpc->eg_cache;
 	while (entry != NULL) {
 		if (entry->shortcut == vcc) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_irqrestore(&mpc->egress_lock, flags);
 			return entry;
 		}
@@ -402,7 +402,7 @@ static eg_cache_entry *eg_cache_get_by_src_ip(__be32 ipaddr,
 	entry = mpc->eg_cache;
 	while (entry != NULL) {
 		if (entry->latest_ip_addr == ipaddr) {
-			atomic_inc(&entry->use);
+			refcount_inc(&entry->use);
 			read_unlock_irq(&mpc->egress_lock);
 			return entry;
 		}
@@ -415,7 +415,7 @@ static eg_cache_entry *eg_cache_get_by_src_ip(__be32 ipaddr,
 
 static void eg_cache_put(eg_cache_entry *entry)
 {
-	if (atomic_dec_and_test(&entry->use)) {
+	if (refcount_dec_and_test(&entry->use)) {
 		memset(entry, 0, sizeof(eg_cache_entry));
 		kfree(entry);
 	}
@@ -468,7 +468,7 @@ static eg_cache_entry *eg_cache_add_entry(struct k_message *msg,
 	dprintk("adding an egress entry, ip = %pI4, this should be our IP\n",
 		&msg->content.eg_info.eg_dst_ip);
 
-	atomic_set(&entry->use, 1);
+	refcount_set(&entry->use, 1);
 	dprintk("new_eg_cache_entry: about to lock\n");
 	write_lock_irq(&client->egress_lock);
 	entry->next = client->eg_cache;
@@ -484,7 +484,7 @@ static eg_cache_entry *eg_cache_add_entry(struct k_message *msg,
 	dprintk("new_eg_cache_entry cache_id %u\n",
 		ntohl(entry->ctrl_info.cache_id));
 	dprintk("mps_ip = %pI4\n", &entry->ctrl_info.mps_ip);
-	atomic_inc(&entry->use);
+	refcount_inc(&entry->use);
 
 	write_unlock_irq(&client->egress_lock);
 	dprintk("new_eg_cache_entry: unlocked\n");
diff --git a/net/atm/mpoa_caches.h b/net/atm/mpoa_caches.h
index 8e5f78c..30fe348 100644
--- a/net/atm/mpoa_caches.h
+++ b/net/atm/mpoa_caches.h
@@ -6,6 +6,7 @@
 #include <linux/atm.h>
 #include <linux/atmdev.h>
 #include <linux/atmmpc.h>
+#include <linux/refcount.h>
 
 struct mpoa_client;
 
@@ -25,7 +26,7 @@ typedef struct in_cache_entry {
 	struct   atm_vcc *shortcut;
 	uint8_t  MPS_ctrl_ATM_addr[ATM_ESA_LEN];
 	struct   in_ctrl_info ctrl_info;
-	atomic_t use;
+	refcount_t use;
 } in_cache_entry;
 
 struct in_cache_ops{
@@ -58,7 +59,7 @@ typedef struct eg_cache_entry{
 	uint16_t             entry_state;
 	__be32             latest_ip_addr;    /* The src IP address of the last packet */
 	struct eg_ctrl_info  ctrl_info;
-	atomic_t             use;
+	refcount_t             use;
 } eg_cache_entry;
 
 struct eg_cache_ops{
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index c4e0984..21d9d34 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -350,7 +350,7 @@ static int pppoatm_send(struct ppp_channel *chan, struct sk_buff *skb)
 		return 1;
 	}
 
-	atomic_add(skb->truesize, &sk_atm(ATM_SKB(skb)->vcc)->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk_atm(ATM_SKB(skb)->vcc)->sk_wmem_alloc);
 	ATM_SKB(skb)->atm_options = ATM_SKB(skb)->vcc->atm_options;
 	pr_debug("atm_skb(%p)->vcc(%p)->dev(%p)\n",
 		 skb, ATM_SKB(skb)->vcc, ATM_SKB(skb)->vcc->dev);
diff --git a/net/atm/proc.c b/net/atm/proc.c
index bbb6461..4caca2a 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -61,7 +61,7 @@ static void atm_dev_info(struct seq_file *seq, const struct atm_dev *dev)
 	add_stats(seq, "0", &dev->stats.aal0);
 	seq_puts(seq, "  ");
 	add_stats(seq, "5", &dev->stats.aal5);
-	seq_printf(seq, "\t[%d]", atomic_read(&dev->refcnt));
+	seq_printf(seq, "\t[%d]", refcount_read(&dev->refcnt));
 	seq_putc(seq, '\n');
 }
 
@@ -211,7 +211,7 @@ static void vcc_info(struct seq_file *seq, struct atm_vcc *vcc)
 		   vcc->flags, sk->sk_err,
 		   sk_wmem_alloc_get(sk), sk->sk_sndbuf,
 		   sk_rmem_alloc_get(sk), sk->sk_rcvbuf,
-		   atomic_read(&sk->sk_refcnt));
+		   refcount_read(&sk->sk_refcnt));
 }
 
 static void svc_info(struct seq_file *seq, struct atm_vcc *vcc)
diff --git a/net/atm/raw.c b/net/atm/raw.c
index 2e17e97..821c079 100644
--- a/net/atm/raw.c
+++ b/net/atm/raw.c
@@ -35,7 +35,7 @@ static void atm_pop_raw(struct atm_vcc *vcc, struct sk_buff *skb)
 
 	pr_debug("(%d) %d -= %d\n",
 		 vcc->vci, sk_wmem_alloc_get(sk), skb->truesize);
-	atomic_sub(skb->truesize, &sk->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc));
 	dev_kfree_skb_any(skb);
 	sk->sk_write_space(sk);
 }
diff --git a/net/atm/resources.c b/net/atm/resources.c
index 0447d5d..9182447 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -109,7 +109,7 @@ struct atm_dev *atm_dev_register(const char *type, struct device *parent,
 	else
 		memset(&dev->flags, 0, sizeof(dev->flags));
 	memset(&dev->stats, 0, sizeof(dev->stats));
-	atomic_set(&dev->refcnt, 1);
+	refcount_set(&dev->refcnt, 1);
 
 	if (atm_proc_dev_register(dev) < 0) {
 		pr_err("atm_proc_dev_register failed for dev %s\n", type);
diff --git a/net/atm/signaling.c b/net/atm/signaling.c
index adb6e3d..ca59496 100644
--- a/net/atm/signaling.c
+++ b/net/atm/signaling.c
@@ -67,7 +67,7 @@ static int sigd_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	struct sock *sk;
 
 	msg = (struct atmsvc_msg *) skb->data;
-	atomic_sub(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc));
 	vcc = *(struct atm_vcc **) &msg->vcc;
 	pr_debug("%d (0x%lx)\n", (int)msg->type, (unsigned long)vcc);
 	sk = sk_atm(vcc);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 90fcf5f..163e81f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -510,7 +510,7 @@ ax25_cb *ax25_create_cb(void)
 	if ((ax25 = kzalloc(sizeof(*ax25), GFP_ATOMIC)) == NULL)
 		return NULL;
 
-	atomic_set(&ax25->refcount, 1);
+	refcount_set(&ax25->refcount, 1);
 
 	skb_queue_head_init(&ax25->write_queue);
 	skb_queue_head_init(&ax25->frag_queue);
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index e1fda27..0446b89 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -114,7 +114,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		return -ENOMEM;
 	}
 
-	atomic_set(&ax25_rt->refcount, 1);
+	refcount_set(&ax25_rt->refcount, 1);
 	ax25_rt->callsign     = route->dest_addr;
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index 0403b0d..83b035f 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -107,7 +107,7 @@ int ax25_uid_ioctl(int cmd, struct sockaddr_ax25 *sax)
 		if ((ax25_uid = kmalloc(sizeof(*ax25_uid), GFP_KERNEL)) == NULL)
 			return -ENOMEM;
 
-		atomic_set(&ax25_uid->refcount, 1);
+		refcount_set(&ax25_uid->refcount, 1);
 		ax25_uid->uid  = sax25_kuid;
 		ax25_uid->call = sax->sax25_call;
 
diff --git a/net/bluetooth/a2mp.c b/net/bluetooth/a2mp.c
index 5f123c3..d6c68c2 100644
--- a/net/bluetooth/a2mp.c
+++ b/net/bluetooth/a2mp.c
@@ -810,7 +810,7 @@ static struct l2cap_chan *a2mp_chan_open(struct l2cap_conn *conn, bool locked)
 /* AMP Manager functions */
 struct amp_mgr *amp_mgr_get(struct amp_mgr *mgr)
 {
-	BT_DBG("mgr %p orig refcnt %d", mgr, atomic_read(&mgr->kref.refcount));
+	BT_DBG("mgr %p orig refcnt %d", mgr, refcount_read(&mgr->kref.refcount));
 
 	kref_get(&mgr->kref);
 
@@ -833,7 +833,7 @@ static void amp_mgr_destroy(struct kref *kref)
 
 int amp_mgr_put(struct amp_mgr *mgr)
 {
-	BT_DBG("mgr %p orig refcnt %d", mgr, atomic_read(&mgr->kref.refcount));
+	BT_DBG("mgr %p orig refcnt %d", mgr, refcount_read(&mgr->kref.refcount));
 
 	return kref_put(&mgr->kref, &amp_mgr_destroy);
 }
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 1aff2da..8196f6f 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -629,7 +629,7 @@ static int bt_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq,
 			   "%pK %-6d %-6u %-6u %-6u %-6lu %-6lu",
 			   sk,
-			   atomic_read(&sk->sk_refcnt),
+			   refcount_read(&sk->sk_refcnt),
 			   sk_rmem_alloc_get(sk),
 			   sk_wmem_alloc_get(sk),
 			   from_kuid(seq_user_ns(seq), sock_i_uid(sk)),
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index dc59eae..1102858 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -397,7 +397,7 @@ static void hci_conn_timeout(struct work_struct *work)
 {
 	struct hci_conn *conn = container_of(work, struct hci_conn,
 					     disc_work.work);
-	int refcnt = atomic_read(&conn->refcnt);
+	int refcnt = refcount_read(&conn->refcnt);
 
 	BT_DBG("hcon %p state %s", conn, state_to_string(conn->state));
 
@@ -553,7 +553,7 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	INIT_DELAYED_WORK(&conn->le_conn_timeout, le_conn_timeout);
 	INIT_WORK(&conn->le_scan_cleanup, le_scan_cleanup);
 
-	atomic_set(&conn->refcnt, 0);
+	refcount_set(&conn->refcnt, 0);
 
 	hci_dev_hold(hdev);
 
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index f7eb02f..8ebca90 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -311,7 +311,7 @@ struct rfcomm_dlc *rfcomm_dlc_alloc(gfp_t prio)
 
 	skb_queue_head_init(&d->tx_queue);
 	mutex_init(&d->lock);
-	atomic_set(&d->refcnt, 1);
+	refcount_set(&d->refcnt, 1);
 
 	rfcomm_dlc_clear_state(d);
 
@@ -342,7 +342,7 @@ static void rfcomm_dlc_unlink(struct rfcomm_dlc *d)
 {
 	struct rfcomm_session *s = d->session;
 
-	BT_DBG("dlc %p refcnt %d session %p", d, atomic_read(&d->refcnt), s);
+	BT_DBG("dlc %p refcnt %d session %p", d, refcount_read(&d->refcnt), s);
 
 	list_del(&d->list);
 	d->session = NULL;
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 7511df7..55d07a9 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -196,7 +196,7 @@ static void rfcomm_sock_kill(struct sock *sk)
 	if (!sock_flag(sk, SOCK_ZAPPED) || sk->sk_socket)
 		return;
 
-	BT_DBG("sk %p state %d refcnt %d", sk, sk->sk_state, atomic_read(&sk->sk_refcnt));
+	BT_DBG("sk %p state %d refcnt %d", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
 	/* Kill poor orphan */
 	bt_sock_unlink(&rfcomm_sk_list, sk);
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 8ca6a92..89a857c 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -149,12 +149,12 @@ static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
 
-	if (atomic_read(&nf_bridge->use) > 1) {
+	if (refcount_read(&nf_bridge->use) > 1) {
 		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
 
 		if (tmp) {
 			memcpy(tmp, nf_bridge, sizeof(struct nf_bridge_info));
-			atomic_set(&tmp->use, 1);
+			refcount_set(&tmp->use, 1);
 		}
 		nf_bridge_put(nf_bridge);
 		nf_bridge = tmp;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 8ce621e..050ce1d 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -21,6 +21,7 @@
 #include <net/ip6_fib.h>
 #include <linux/if_vlan.h>
 #include <linux/rhashtable.h>
+#include <linux/refcount.h>
 
 #define BR_HASH_BITS 8
 #define BR_HASH_SIZE (1 << BR_HASH_BITS)
@@ -121,7 +122,7 @@ struct net_bridge_vlan {
 		struct net_bridge_port	*port;
 	};
 	union {
-		atomic_t		refcnt;
+		refcount_t		refcnt;
 		struct net_bridge_vlan	*brvlan;
 	};
 	struct list_head		vlist;
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index b6de4f4..0a0ef24 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -157,7 +157,7 @@ static struct net_bridge_vlan *br_vlan_get_master(struct net_bridge *br, u16 vid
 		if (WARN_ON(!masterv))
 			return NULL;
 	}
-	atomic_inc(&masterv->refcnt);
+	refcount_inc(&masterv->refcnt);
 
 	return masterv;
 }
@@ -181,7 +181,7 @@ static void br_vlan_put_master(struct net_bridge_vlan *masterv)
 		return;
 
 	vg = br_vlan_group(masterv->br);
-	if (atomic_dec_and_test(&masterv->refcnt)) {
+	if (refcount_dec_and_test(&masterv->refcnt)) {
 		rhashtable_remove_fast(&vg->vlan_hash,
 				       &masterv->vnode, br_vlan_rht_params);
 		__vlan_del_list(masterv);
@@ -563,7 +563,7 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags)
 				br_err(br, "failed insert local address into bridge forwarding table\n");
 				return ret;
 			}
-			atomic_inc(&vlan->refcnt);
+			refcount_inc(&vlan->refcnt);
 			vlan->flags |= BRIDGE_VLAN_INFO_BRENTRY;
 			vg->num_vlans++;
 		}
@@ -585,7 +585,7 @@ int br_vlan_add(struct net_bridge *br, u16 vid, u16 flags)
 	vlan->flags &= ~BRIDGE_VLAN_INFO_PVID;
 	vlan->br = br;
 	if (flags & BRIDGE_VLAN_INFO_BRENTRY)
-		atomic_set(&vlan->refcnt, 1);
+		refcount_set(&vlan->refcnt, 1);
 	ret = __vlan_add(vlan, flags);
 	if (ret) {
 		free_percpu(vlan->stats);
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 92cbbd2..a21eea9 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1009,7 +1009,7 @@ static const struct proto_ops caif_stream_ops = {
 static void caif_sock_destructor(struct sock *sk)
 {
 	struct caifsock *cf_sk = container_of(sk, struct caifsock, sk);
-	caif_assert(!atomic_read(&sk->sk_wmem_alloc));
+	caif_assert(!refcount_read(&sk->sk_wmem_alloc));
 	caif_assert(sk_unhashed(sk));
 	caif_assert(!sk->sk_socket);
 	if (!sock_flag(sk, SOCK_DEAD)) {
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index b490e74..88a324e 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1005,7 +1005,7 @@ static bool osd_registered(struct ceph_osd *osd)
  */
 static void osd_init(struct ceph_osd *osd)
 {
-	atomic_set(&osd->o_ref, 1);
+	refcount_set(&osd->o_ref, 1);
 	RB_CLEAR_NODE(&osd->o_node);
 	osd->o_requests = RB_ROOT;
 	osd->o_linger_requests = RB_ROOT;
@@ -1050,9 +1050,9 @@ static struct ceph_osd *create_osd(struct ceph_osd_client *osdc, int onum)
 
 static struct ceph_osd *get_osd(struct ceph_osd *osd)
 {
-	if (atomic_inc_not_zero(&osd->o_ref)) {
-		dout("get_osd %p %d -> %d\n", osd, atomic_read(&osd->o_ref)-1,
-		     atomic_read(&osd->o_ref));
+	if (refcount_inc_not_zero(&osd->o_ref)) {
+		dout("get_osd %p %d -> %d\n", osd, refcount_read(&osd->o_ref)-1,
+		     refcount_read(&osd->o_ref));
 		return osd;
 	} else {
 		dout("get_osd %p FAIL\n", osd);
@@ -1062,9 +1062,9 @@ static struct ceph_osd *get_osd(struct ceph_osd *osd)
 
 static void put_osd(struct ceph_osd *osd)
 {
-	dout("put_osd %p %d -> %d\n", osd, atomic_read(&osd->o_ref),
-	     atomic_read(&osd->o_ref) - 1);
-	if (atomic_dec_and_test(&osd->o_ref)) {
+	dout("put_osd %p %d -> %d\n", osd, refcount_read(&osd->o_ref),
+	     refcount_read(&osd->o_ref) - 1);
+	if (refcount_dec_and_test(&osd->o_ref)) {
 		osd_cleanup(osd);
 		kfree(osd);
 	}
@@ -4149,7 +4149,7 @@ void ceph_osdc_stop(struct ceph_osd_client *osdc)
 		close_osd(osd);
 	}
 	up_write(&osdc->lock);
-	WARN_ON(atomic_read(&osdc->homeless_osd.o_ref) != 1);
+	WARN_ON(refcount_read(&osdc->homeless_osd.o_ref) != 1);
 	osd_cleanup(&osdc->homeless_osd);
 
 	WARN_ON(!list_empty(&osdc->osd_lru));
diff --git a/net/ceph/pagelist.c b/net/ceph/pagelist.c
index 6864007..ce09f73 100644
--- a/net/ceph/pagelist.c
+++ b/net/ceph/pagelist.c
@@ -16,7 +16,7 @@ static void ceph_pagelist_unmap_tail(struct ceph_pagelist *pl)
 
 void ceph_pagelist_release(struct ceph_pagelist *pl)
 {
-	if (!atomic_dec_and_test(&pl->refcnt))
+	if (!refcount_dec_and_test(&pl->refcnt))
 		return;
 	ceph_pagelist_unmap_tail(pl);
 	while (!list_empty(&pl->head)) {
diff --git a/net/ceph/snapshot.c b/net/ceph/snapshot.c
index 154683f..46db6f7 100644
--- a/net/ceph/snapshot.c
+++ b/net/ceph/snapshot.c
@@ -51,7 +51,7 @@ struct ceph_snap_context *ceph_create_snap_context(u32 snap_count,
 	if (!snapc)
 		return NULL;
 
-	atomic_set(&snapc->nref, 1);
+	refcount_set(&snapc->nref, 1);
 	snapc->num_snaps = snap_count;
 
 	return snapc;
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(ceph_create_snap_context);
 struct ceph_snap_context *ceph_get_snap_context(struct ceph_snap_context *sc)
 {
 	if (sc)
-		atomic_inc(&sc->nref);
+		refcount_inc(&sc->nref);
 	return sc;
 }
 EXPORT_SYMBOL(ceph_get_snap_context);
@@ -70,7 +70,7 @@ void ceph_put_snap_context(struct ceph_snap_context *sc)
 {
 	if (!sc)
 		return;
-	if (atomic_dec_and_test(&sc->nref)) {
+	if (refcount_dec_and_test(&sc->nref)) {
 		/*printk(" deleting snap_context %p\n", sc);*/
 		kfree(sc);
 	}
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 662bea5..0595e9b 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -244,7 +244,7 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk, unsigned int flags,
 					}
 				}
 				*peeked = 1;
-				atomic_inc(&skb->users);
+				refcount_inc(&skb->users);
 			} else {
 				__skb_unlink(skb, queue);
 				if (destructor)
@@ -313,9 +313,9 @@ void __skb_free_datagram_locked(struct sock *sk, struct sk_buff *skb, int len)
 {
 	bool slow;
 
-	if (likely(atomic_read(&skb->users) == 1))
+	if (likely(refcount_read(&skb->users) == 1))
 		smp_rmb();
-	else if (likely(!atomic_dec_and_test(&skb->users))) {
+	else if (likely(!refcount_dec_and_test(&skb->users))) {
 		sk_peek_offset_bwd(sk, len);
 		return;
 	}
@@ -341,7 +341,7 @@ int __sk_queue_drop_skb(struct sock *sk, struct sk_buff *skb,
 		spin_lock_bh(&sk->sk_receive_queue.lock);
 		if (skb == skb_peek(&sk->sk_receive_queue)) {
 			__skb_unlink(skb, &sk->sk_receive_queue);
-			atomic_dec(&skb->users);
+			refcount_dec(&skb->users);
 			err = 0;
 		}
 		spin_unlock_bh(&sk->sk_receive_queue.lock);
@@ -591,7 +591,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
 		skb->data_len += copied;
 		skb->len += copied;
 		skb->truesize += truesize;
-		atomic_add(truesize, &skb->sk->sk_wmem_alloc);
+		refcount_add(truesize, &skb->sk->sk_wmem_alloc);
 		while (copied) {
 			int size = min_t(int, copied, PAGE_SIZE - start);
 			skb_fill_page_desc(skb, frag++, pages[n], start, size);
diff --git a/net/core/dev.c b/net/core/dev.c
index 8db5a0b..2661354 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1806,7 +1806,7 @@ static inline int deliver_skb(struct sk_buff *skb,
 {
 	if (unlikely(skb_orphan_frags(skb, GFP_ATOMIC)))
 		return -ENOMEM;
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 	return pt_prev->func(skb, skb->dev, pt_prev, orig_dev);
 }
 
@@ -2447,10 +2447,10 @@ void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	unsigned long flags;
 
-	if (likely(atomic_read(&skb->users) == 1)) {
+	if (likely(refcount_read(&skb->users) == 1)) {
 		smp_rmb();
-		atomic_set(&skb->users, 0);
-	} else if (likely(!atomic_dec_and_test(&skb->users))) {
+		refcount_set(&skb->users, 0);
+	} else if (likely(!refcount_dec_and_test(&skb->users))) {
 		return;
 	}
 	get_kfree_skb_cb(skb)->reason = reason;
@@ -3845,7 +3845,7 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			struct sk_buff *skb = clist;
 			clist = clist->next;
 
-			WARN_ON(atomic_read(&skb->users));
+			WARN_ON(refcount_read(&skb->users));
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
 				trace_consume_skb(skb);
 			else
diff --git a/net/core/dst.c b/net/core/dst.c
index b5cbbe0..6d11cbe 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -300,14 +300,9 @@ static void dst_destroy_rcu(struct rcu_head *head)
 void dst_release(struct dst_entry *dst)
 {
 	if (dst) {
-		int newrefcnt;
 		unsigned short nocache = dst->flags & DST_NOCACHE;
 
-		newrefcnt = atomic_dec_return(&dst->__refcnt);
-		if (unlikely(newrefcnt < 0))
-			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
-					     __func__, dst, newrefcnt);
-		if (!newrefcnt && unlikely(nocache))
+		if (!atomic_dec_and_test(&dst->__refcnt) && unlikely(nocache))
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index b6791d9..53d55d5 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -32,7 +32,7 @@ int fib_default_rule_add(struct fib_rules_ops *ops,
 	if (r == NULL)
 		return -ENOMEM;
 
-	atomic_set(&r->refcnt, 1);
+	refcount_set(&r->refcnt, 1);
 	r->action = FR_ACT_TO_TBL;
 	r->pref = pref;
 	r->table = table;
@@ -269,7 +269,7 @@ int fib_rules_lookup(struct fib_rules_ops *ops, struct flowi *fl,
 
 		if (err != -EAGAIN) {
 			if ((arg->flags & FIB_LOOKUP_NOREF) ||
-			    likely(atomic_inc_not_zero(&rule->refcnt))) {
+			    likely(refcount_inc_not_zero(&rule->refcnt))) {
 				arg->rule = rule;
 				goto out;
 			}
diff --git a/net/core/filter.c b/net/core/filter.c
index 1969b3f..fce4f06 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -927,7 +927,7 @@ static void sk_filter_release_rcu(struct rcu_head *rcu)
  */
 static void sk_filter_release(struct sk_filter *fp)
 {
-	if (atomic_dec_and_test(&fp->refcnt))
+	if (refcount_dec_and_test(&fp->refcnt))
 		call_rcu(&fp->rcu, sk_filter_release_rcu);
 }
 
@@ -949,7 +949,7 @@ bool sk_filter_charge(struct sock *sk, struct sk_filter *fp)
 	/* same check as in sock_kmalloc() */
 	if (filter_size <= sysctl_optmem_max &&
 	    atomic_read(&sk->sk_omem_alloc) + filter_size < sysctl_optmem_max) {
-		atomic_inc(&fp->refcnt);
+		refcount_set(&fp->refcnt, 1);
 		atomic_add(filter_size, &sk->sk_omem_alloc);
 		return true;
 	}
@@ -1178,7 +1178,7 @@ static int __sk_attach_prog(struct bpf_prog *prog, struct sock *sk)
 		return -ENOMEM;
 
 	fp->prog = prog;
-	atomic_set(&fp->refcnt, 0);
+	refcount_set(&fp->refcnt, 0);
 
 	if (!sk_filter_charge(sk, fp)) {
 		kfree(fp);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 7bb12e0..dee2486 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -140,7 +140,7 @@ static int neigh_forced_gc(struct neigh_table *tbl)
 			 * - it is not permanent
 			 */
 			write_lock(&n->lock);
-			if (atomic_read(&n->refcnt) == 1 &&
+			if (refcount_read(&n->refcnt) == 1 &&
 			    !(n->nud_state & NUD_PERMANENT)) {
 				rcu_assign_pointer(*np,
 					rcu_dereference_protected(n->next,
@@ -218,7 +218,7 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev)
 			neigh_del_timer(n);
 			n->dead = 1;
 
-			if (atomic_read(&n->refcnt) != 1) {
+			if (refcount_read(&n->refcnt) != 1) {
 				/* The most unpleasant situation.
 				   We must destroy neighbour entry,
 				   but someone still uses it.
@@ -299,7 +299,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl, struct net_device
 
 	NEIGH_CACHE_STAT_INC(tbl, allocs);
 	n->tbl		  = tbl;
-	atomic_set(&n->refcnt, 1);
+	refcount_set(&n->refcnt, 1);
 	n->dead		  = 1;
 out:
 	return n;
@@ -408,7 +408,7 @@ struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 	rcu_read_lock_bh();
 	n = __neigh_lookup_noref(tbl, pkey, dev);
 	if (n) {
-		if (!atomic_inc_not_zero(&n->refcnt))
+		if (!refcount_inc_not_zero(&n->refcnt))
 			n = NULL;
 		NEIGH_CACHE_STAT_INC(tbl, hits);
 	}
@@ -437,7 +437,7 @@ struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
 	     n = rcu_dereference_bh(n->next)) {
 		if (!memcmp(n->primary_key, pkey, key_len) &&
 		    net_eq(dev_net(n->dev), net)) {
-			if (!atomic_inc_not_zero(&n->refcnt))
+			if (!refcount_inc_not_zero(&n->refcnt))
 				n = NULL;
 			NEIGH_CACHE_STAT_INC(tbl, hits);
 			break;
@@ -673,7 +673,7 @@ static void neigh_parms_destroy(struct neigh_parms *parms);
 
 static inline void neigh_parms_put(struct neigh_parms *parms)
 {
-	if (atomic_dec_and_test(&parms->refcnt))
+	if (refcount_dec_and_test(&parms->refcnt))
 		neigh_parms_destroy(parms);
 }
 
@@ -785,7 +785,7 @@ static void neigh_periodic_work(struct work_struct *work)
 			if (time_before(n->used, n->confirmed))
 				n->used = n->confirmed;
 
-			if (atomic_read(&n->refcnt) == 1 &&
+			if (refcount_read(&n->refcnt) == 1 &&
 			    (state == NUD_FAILED ||
 			     time_after(jiffies, n->used + NEIGH_VAR(n->parms, GC_STALETIME)))) {
 				*np = n->next;
@@ -1436,7 +1436,7 @@ struct neigh_parms *neigh_parms_alloc(struct net_device *dev,
 	p = kmemdup(&tbl->parms, sizeof(*p), GFP_KERNEL);
 	if (p) {
 		p->tbl		  = tbl;
-		atomic_set(&p->refcnt, 1);
+		refcount_set(&p->refcnt, 1);
 		p->reachable_time =
 				neigh_rand_reach_time(NEIGH_VAR(p, BASE_REACHABLE_TIME));
 		dev_hold(dev);
@@ -1499,7 +1499,7 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	INIT_LIST_HEAD(&tbl->parms_list);
 	list_add(&tbl->parms.list, &tbl->parms_list);
 	write_pnet(&tbl->parms.net, &init_net);
-	atomic_set(&tbl->parms.refcnt, 1);
+	refcount_set(&tbl->parms.refcnt, 1);
 	tbl->parms.reachable_time =
 			  neigh_rand_reach_time(NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME));
 
@@ -1746,7 +1746,7 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 
 	if ((parms->dev &&
 	     nla_put_u32(skb, NDTPA_IFINDEX, parms->dev->ifindex)) ||
-	    nla_put_u32(skb, NDTPA_REFCNT, atomic_read(&parms->refcnt)) ||
+	    nla_put_u32(skb, NDTPA_REFCNT, refcount_read(&parms->refcnt)) ||
 	    nla_put_u32(skb, NDTPA_QUEUE_LENBYTES,
 			NEIGH_VAR(parms, QUEUE_LEN_BYTES)) ||
 	    /* approximative value for deprecated QUEUE_LEN (in packets) */
@@ -2183,7 +2183,7 @@ static int neigh_fill_info(struct sk_buff *skb, struct neighbour *neigh,
 	ci.ndm_used	 = jiffies_to_clock_t(now - neigh->used);
 	ci.ndm_confirmed = jiffies_to_clock_t(now - neigh->confirmed);
 	ci.ndm_updated	 = jiffies_to_clock_t(now - neigh->updated);
-	ci.ndm_refcnt	 = atomic_read(&neigh->refcnt) - 1;
+	ci.ndm_refcnt	 = refcount_read(&neigh->refcnt) - 1;
 	read_unlock_bh(&neigh->lock);
 
 	if (nla_put_u32(skb, NDA_PROBES, atomic_read(&neigh->probes)) ||
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index b0c04cf..cc3c21a 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1443,7 +1443,7 @@ static void *net_grab_current_ns(void)
 	struct net *ns = current->nsproxy->net_ns;
 #ifdef CONFIG_NET_NS
 	if (ns)
-		atomic_inc(&ns->passive);
+		refcount_inc(&ns->passive);
 #endif
 	return ns;
 }
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 3c4bbec..a0eb969 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -281,7 +281,7 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	LIST_HEAD(net_exit_list);
 
 	atomic_set(&net->count, 1);
-	atomic_set(&net->passive, 1);
+	refcount_set(&net->passive, 1);
 	net->dev_base_seq = 1;
 	net->user_ns = user_ns;
 	idr_init(&net->netns_ids);
@@ -358,7 +358,7 @@ static void net_free(struct net *net)
 void net_drop_ns(void *p)
 {
 	struct net *ns = p;
-	if (ns && atomic_dec_and_test(&ns->passive))
+	if (ns && refcount_dec_and_test(&ns->passive))
 		net_free(ns);
 }
 
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9424673..8b9083d 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -271,7 +271,7 @@ static void zap_completion_queue(void)
 			struct sk_buff *skb = clist;
 			clist = clist->next;
 			if (!skb_irq_freeable(skb)) {
-				atomic_inc(&skb->users);
+				refcount_inc(&skb->users);
 				dev_kfree_skb_any(skb); /* put this one back */
 			} else {
 				__kfree_skb(skb);
@@ -303,7 +303,7 @@ static struct sk_buff *find_skb(struct netpoll *np, int len, int reserve)
 		return NULL;
 	}
 
-	atomic_set(&skb->users, 1);
+	refcount_set(&skb->users, 1);
 	skb_reserve(skb, reserve);
 	return skb;
 }
@@ -626,7 +626,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		skb_queue_head_init(&npinfo->txq);
 		INIT_DELAYED_WORK(&npinfo->tx_work, queue_process);
 
-		atomic_set(&npinfo->refcnt, 1);
+		refcount_set(&npinfo->refcnt, 1);
 
 		ops = np->dev->netdev_ops;
 		if (ops->ndo_netpoll_setup) {
@@ -636,7 +636,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		}
 	} else {
 		npinfo = rtnl_dereference(ndev->npinfo);
-		atomic_inc(&npinfo->refcnt);
+		refcount_inc(&npinfo->refcnt);
 	}
 
 	npinfo->netpoll = np;
@@ -815,7 +815,7 @@ void __netpoll_cleanup(struct netpoll *np)
 
 	synchronize_srcu(&netpoll_srcu);
 
-	if (atomic_dec_and_test(&npinfo->refcnt)) {
+	if (refcount_dec_and_test(&npinfo->refcnt)) {
 		const struct net_device_ops *ops;
 
 		ops = np->dev->netdev_ops;
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 8e69ce4..787d624 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3361,7 +3361,7 @@ static void pktgen_wait_for_skb(struct pktgen_dev *pkt_dev)
 {
 	ktime_t idle_start = ktime_get();
 
-	while (atomic_read(&(pkt_dev->skb->users)) != 1) {
+	while (refcount_read(&(pkt_dev->skb->users)) != 1) {
 		if (signal_pending(current))
 			break;
 
@@ -3418,7 +3418,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 	if (pkt_dev->xmit_mode == M_NETIF_RECEIVE) {
 		skb = pkt_dev->skb;
 		skb->protocol = eth_type_trans(skb, skb->dev);
-		atomic_add(burst, &skb->users);
+		refcount_add(burst, &skb->users);
 		local_bh_disable();
 		do {
 			ret = netif_receive_skb(skb);
@@ -3426,11 +3426,11 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 				pkt_dev->errors++;
 			pkt_dev->sofar++;
 			pkt_dev->seq_num++;
-			if (atomic_read(&skb->users) != burst) {
+			if (refcount_read(&skb->users) != burst) {
 				/* skb was queued by rps/rfs or taps,
 				 * so cannot reuse this skb
 				 */
-				atomic_sub(burst - 1, &skb->users);
+				WARN_ON(refcount_sub_and_test(burst - 1, &skb->users));
 				/* get out of the loop and wait
 				 * until skb is consumed
 				 */
@@ -3446,7 +3446,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 		goto out; /* Skips xmit_mode M_START_XMIT */
 	} else if (pkt_dev->xmit_mode == M_QUEUE_XMIT) {
 		local_bh_disable();
-		atomic_inc(&pkt_dev->skb->users);
+		refcount_inc(&pkt_dev->skb->users);
 
 		ret = dev_queue_xmit(pkt_dev->skb);
 		switch (ret) {
@@ -3487,7 +3487,7 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 		pkt_dev->last_ok = 0;
 		goto unlock;
 	}
-	atomic_add(burst, &pkt_dev->skb->users);
+	refcount_add(burst, &pkt_dev->skb->users);
 
 xmit_more:
 	ret = netdev_start_xmit(pkt_dev->skb, odev, txq, --burst > 0);
@@ -3513,11 +3513,11 @@ static void pktgen_xmit(struct pktgen_dev *pkt_dev)
 		/* fallthru */
 	case NETDEV_TX_BUSY:
 		/* Retry it next time */
-		atomic_dec(&(pkt_dev->skb->users));
+		refcount_dec(&(pkt_dev->skb->users));
 		pkt_dev->last_ok = 0;
 	}
 	if (unlikely(burst))
-		atomic_sub(burst, &pkt_dev->skb->users);
+		WARN_ON(refcount_sub_and_test(burst, &pkt_dev->skb->users));
 unlock:
 	HARD_TX_UNLOCK(odev, txq);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 18b5aae..b2d9035 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -647,7 +647,7 @@ int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, unsigned int g
 
 	NETLINK_CB(skb).dst_group = group;
 	if (echo)
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 	netlink_broadcast(rtnl, skb, pid, group, GFP_KERNEL);
 	if (echo)
 		err = netlink_unicast(rtnl, skb, pid, MSG_DONTWAIT);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5a03730..ac86c66 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -176,7 +176,7 @@ struct sk_buff *__alloc_skb_head(gfp_t gfp_mask, int node)
 	memset(skb, 0, offsetof(struct sk_buff, tail));
 	skb->head = NULL;
 	skb->truesize = sizeof(struct sk_buff);
-	atomic_set(&skb->users, 1);
+	refcount_set(&skb->users, 1);
 
 	skb->mac_header = (typeof(skb->mac_header))~0U;
 out:
@@ -247,7 +247,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 	/* Account for allocated memory : skb + skb->head */
 	skb->truesize = SKB_TRUESIZE(size);
 	skb->pfmemalloc = pfmemalloc;
-	atomic_set(&skb->users, 1);
+	refcount_set(&skb->users, 1);
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
@@ -268,7 +268,7 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 		kmemcheck_annotate_bitfield(&fclones->skb2, flags1);
 		skb->fclone = SKB_FCLONE_ORIG;
-		atomic_set(&fclones->fclone_ref, 1);
+		refcount_set(&fclones->fclone_ref, 1);
 
 		fclones->skb2.fclone = SKB_FCLONE_CLONE;
 		fclones->skb2.pfmemalloc = pfmemalloc;
@@ -315,7 +315,7 @@ struct sk_buff *__build_skb(void *data, unsigned int frag_size)
 
 	memset(skb, 0, offsetof(struct sk_buff, tail));
 	skb->truesize = SKB_TRUESIZE(size);
-	atomic_set(&skb->users, 1);
+	refcount_set(&skb->users, 1);
 	skb->head = data;
 	skb->data = data;
 	skb_reset_tail_pointer(skb);
@@ -630,7 +630,7 @@ static void kfree_skbmem(struct sk_buff *skb)
 		 * This test would have no chance to be true for the clone,
 		 * while here, branch prediction will be good.
 		 */
-		if (atomic_read(&fclones->fclone_ref) == 1)
+		if (refcount_read(&fclones->fclone_ref) == 1)
 			goto fastpath;
 		break;
 
@@ -638,7 +638,7 @@ static void kfree_skbmem(struct sk_buff *skb)
 		fclones = container_of(skb, struct sk_buff_fclones, skb2);
 		break;
 	}
-	if (!atomic_dec_and_test(&fclones->fclone_ref))
+	if (!refcount_dec_and_test(&fclones->fclone_ref))
 		return;
 fastpath:
 	kmem_cache_free(skbuff_fclone_cache, fclones);
@@ -697,9 +697,9 @@ void kfree_skb(struct sk_buff *skb)
 {
 	if (unlikely(!skb))
 		return;
-	if (likely(atomic_read(&skb->users) == 1))
+	if (likely(refcount_read(&skb->users) == 1))
 		smp_rmb();
-	else if (likely(!atomic_dec_and_test(&skb->users)))
+	else if (likely(!refcount_dec_and_test(&skb->users)))
 		return;
 	trace_kfree_skb(skb, __builtin_return_address(0));
 	__kfree_skb(skb);
@@ -749,9 +749,9 @@ void consume_skb(struct sk_buff *skb)
 {
 	if (unlikely(!skb))
 		return;
-	if (likely(atomic_read(&skb->users) == 1))
+	if (likely(refcount_read(&skb->users) == 1))
 		smp_rmb();
-	else if (likely(!atomic_dec_and_test(&skb->users)))
+	else if (likely(!refcount_dec_and_test(&skb->users)))
 		return;
 	trace_consume_skb(skb);
 	__kfree_skb(skb);
@@ -808,9 +808,9 @@ void napi_consume_skb(struct sk_buff *skb, int budget)
 		return;
 	}
 
-	if (likely(atomic_read(&skb->users) == 1))
+	if (likely(refcount_read(&skb->users) == 1))
 		smp_rmb();
-	else if (likely(!atomic_dec_and_test(&skb->users)))
+	else if (likely(!refcount_dec_and_test(&skb->users)))
 		return;
 	/* if reaching here SKB is ready to free */
 	trace_consume_skb(skb);
@@ -910,7 +910,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	C(head_frag);
 	C(data);
 	C(truesize);
-	atomic_set(&n->users, 1);
+	refcount_set(&n->users, 1);
 
 	atomic_inc(&(skb_shinfo(skb)->dataref));
 	skb->cloned = 1;
@@ -1022,9 +1022,9 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 		return NULL;
 
 	if (skb->fclone == SKB_FCLONE_ORIG &&
-	    atomic_read(&fclones->fclone_ref) == 1) {
+	    refcount_read(&fclones->fclone_ref) == 1) {
 		n = &fclones->skb2;
-		atomic_set(&fclones->fclone_ref, 2);
+		refcount_set(&fclones->fclone_ref, 2);
 	} else {
 		if (skb_pfmemalloc(skb))
 			gfp_mask |= __GFP_MEMALLOC;
@@ -2983,7 +2983,7 @@ int skb_append_datato_frags(struct sock *sk, struct sk_buff *skb,
 		get_page(pfrag->page);
 
 		skb->truesize += copy;
-		atomic_add(copy, &sk->sk_wmem_alloc);
+		refcount_add(copy, &sk->sk_wmem_alloc);
 		skb->len += copy;
 		skb->data_len += copy;
 		offset += copy;
@@ -3761,7 +3761,7 @@ struct sk_buff *skb_clone_sk(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	struct sk_buff *clone;
 
-	if (!sk || !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (!sk || !refcount_inc_not_zero(&sk->sk_refcnt))
 		return NULL;
 
 	clone = skb_clone(skb, GFP_ATOMIC);
diff --git a/net/core/sock.c b/net/core/sock.c
index f560e08..b11edc1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1406,7 +1406,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
 		if (likely(sk->sk_net_refcnt))
 			get_net(net);
 		sock_net_set(sk, net);
-		atomic_set(&sk->sk_wmem_alloc, 1);
+		refcount_set(&sk->sk_wmem_alloc, 1);
 
 		mem_cgroup_sk_alloc(sk);
 		cgroup_sk_alloc(&sk->sk_cgrp_data);
@@ -1430,7 +1430,7 @@ static void __sk_destruct(struct rcu_head *head)
 		sk->sk_destruct(sk);
 
 	filter = rcu_dereference_check(sk->sk_filter,
-				       atomic_read(&sk->sk_wmem_alloc) == 0);
+				       refcount_read(&sk->sk_wmem_alloc) == 0);
 	if (filter) {
 		sk_filter_uncharge(sk, filter);
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
@@ -1475,7 +1475,7 @@ void sk_free(struct sock *sk)
 	 * some packets are still in some tx queue.
 	 * If not null, sock_wfree() will call __sk_free(sk) later
 	 */
-	if (atomic_dec_and_test(&sk->sk_wmem_alloc))
+	if (refcount_dec_and_test(&sk->sk_wmem_alloc))
 		__sk_free(sk);
 }
 EXPORT_SYMBOL(sk_free);
@@ -1511,7 +1511,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		/*
 		 * sk_wmem_alloc set to one (see sk_free() and sock_wfree())
 		 */
-		atomic_set(&newsk->sk_wmem_alloc, 1);
+		refcount_set(&newsk->sk_wmem_alloc, 1);
 		atomic_set(&newsk->sk_omem_alloc, 0);
 		skb_queue_head_init(&newsk->sk_receive_queue);
 		skb_queue_head_init(&newsk->sk_write_queue);
@@ -1564,7 +1564,7 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 		 * (Documentation/RCU/rculist_nulls.txt for details)
 		 */
 		smp_wmb();
-		atomic_set(&newsk->sk_refcnt, 2);
+		refcount_set(&newsk->sk_refcnt, 2);
 
 		/*
 		 * Increment the counter in the same struct proto as the master
@@ -1633,7 +1633,7 @@ void sock_wfree(struct sk_buff *skb)
 		 * Keep a reference on sk_wmem_alloc, this will be released
 		 * after sk_write_space() call
 		 */
-		atomic_sub(len - 1, &sk->sk_wmem_alloc);
+		WARN_ON(refcount_sub_and_test(len - 1, &sk->sk_wmem_alloc));
 		sk->sk_write_space(sk);
 		len = 1;
 	}
@@ -1641,7 +1641,7 @@ void sock_wfree(struct sk_buff *skb)
 	 * if sk_wmem_alloc reaches 0, we must finish what sk_free()
 	 * could not do because of in-flight packets
 	 */
-	if (atomic_sub_and_test(len, &sk->sk_wmem_alloc))
+	if (refcount_sub_and_test(len, &sk->sk_wmem_alloc))
 		__sk_free(sk);
 }
 EXPORT_SYMBOL(sock_wfree);
@@ -1653,7 +1653,7 @@ void __sock_wfree(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
 
-	if (atomic_sub_and_test(skb->truesize, &sk->sk_wmem_alloc))
+	if (refcount_sub_and_test(skb->truesize, &sk->sk_wmem_alloc))
 		__sk_free(sk);
 }
 
@@ -1675,7 +1675,7 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
 	 * is enough to guarantee sk_free() wont free this sock until
 	 * all in-flight packets are completed
 	 */
-	atomic_add(skb->truesize, &sk->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 }
 EXPORT_SYMBOL(skb_set_owner_w);
 
@@ -1703,7 +1703,7 @@ void skb_orphan_partial(struct sk_buff *skb)
 	    || skb->destructor == tcp_wfree
 #endif
 		) {
-		atomic_sub(skb->truesize - 1, &skb->sk->sk_wmem_alloc);
+		WARN_ON(refcount_sub_and_test(skb->truesize - 1, &skb->sk->sk_wmem_alloc));
 		skb->truesize = 1;
 	} else {
 		skb_orphan(skb);
@@ -1762,7 +1762,7 @@ EXPORT_SYMBOL(sock_i_ino);
 struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
 			     gfp_t priority)
 {
-	if (force || atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
+	if (force || refcount_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf) {
 		struct sk_buff *skb = alloc_skb(size, priority);
 		if (skb) {
 			skb_set_owner_w(skb, sk);
@@ -1837,7 +1837,7 @@ static long sock_wait_for_wmem(struct sock *sk, long timeo)
 			break;
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		if (atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf)
+		if (refcount_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf)
 			break;
 		if (sk->sk_shutdown & SEND_SHUTDOWN)
 			break;
@@ -2140,7 +2140,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		if (sk->sk_type == SOCK_STREAM) {
 			if (sk->sk_wmem_queued < prot->sysctl_wmem[0])
 				return 1;
-		} else if (atomic_read(&sk->sk_wmem_alloc) <
+		} else if (refcount_read(&sk->sk_wmem_alloc) <
 			   prot->sysctl_wmem[0])
 				return 1;
 	}
@@ -2406,7 +2406,7 @@ static void sock_def_write_space(struct sock *sk)
 	/* Do not wake up a writer until he can make "significant"
 	 * progress.  --DaveM
 	 */
-	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
+	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf) {
 		wq = rcu_dereference(sk->sk_wq);
 		if (skwq_has_sleeper(wq))
 			wake_up_interruptible_sync_poll(&wq->wait, POLLOUT |
@@ -2512,7 +2512,7 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	 * (Documentation/RCU/rculist_nulls.txt for details)
 	 */
 	smp_wmb();
-	atomic_set(&sk->sk_refcnt, 1);
+	refcount_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }
 EXPORT_SYMBOL(sock_init_data);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index adfc790..616bd53 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -351,7 +351,7 @@ static int dccp_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (ipv6_opt_accepted(sk, skb, IP6CB(skb)) ||
 	    np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo ||
 	    np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim) {
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 		ireq->pktopts = skb;
 	}
 	ireq->ir_iif = sk->sk_bound_dev_if;
diff --git a/net/decnet/dn_fib.c b/net/decnet/dn_fib.c
index 7af0ba61..2e22484 100644
--- a/net/decnet/dn_fib.c
+++ b/net/decnet/dn_fib.c
@@ -389,7 +389,7 @@ struct dn_fib_info *dn_fib_create_info(const struct rtmsg *r, struct nlattr *att
 	}
 
 	fi->fib_treeref++;
-	atomic_inc(&fi->fib_clntref);
+	refcount_inc(&fi->fib_clntref);
 	spin_lock(&dn_fib_info_lock);
 	fi->fib_next = dn_fib_info_list;
 	fi->fib_prev = NULL;
@@ -425,7 +425,7 @@ int dn_fib_semantic_match(int type, struct dn_fib_info *fi, const struct flowidn
 		switch (type) {
 		case RTN_NAT:
 			DN_FIB_RES_RESET(*res);
-			atomic_inc(&fi->fib_clntref);
+			refcount_inc(&fi->fib_clntref);
 			return 0;
 		case RTN_UNICAST:
 		case RTN_LOCAL:
@@ -438,7 +438,7 @@ int dn_fib_semantic_match(int type, struct dn_fib_info *fi, const struct flowidn
 			}
 			if (nhsel < fi->fib_nhs) {
 				res->nh_sel = nhsel;
-				atomic_inc(&fi->fib_clntref);
+				refcount_inc(&fi->fib_clntref);
 				return 0;
 			}
 			endfor_nexthops(fi);
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 482730c..d8f7b6d 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -559,7 +559,7 @@ static inline void dn_neigh_format_entry(struct seq_file *seq,
 		   (dn->flags&DN_NDFLAG_R2) ? "2" : "-",
 		   (dn->flags&DN_NDFLAG_P3) ? "3" : "-",
 		   dn->n.nud_state,
-		   atomic_read(&dn->n.refcnt),
+		   refcount_read(&dn->n.refcnt),
 		   dn->blksize,
 		   (dn->n.dev) ? dn->n.dev->name : "?");
 	read_unlock(&n->lock);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f750698..e771346 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -150,7 +150,7 @@ void inet_sock_destruct(struct sock *sk)
 	}
 
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(sk->sk_wmem_queued);
 	WARN_ON(sk->sk_forward_alloc);
 
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 72d6f05..55b5300 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -265,7 +265,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 		    entry->key_len == key_len &&
 		    memcmp(entry->key, key, key_len) == 0) {
 			entry->activity += 1;
-			atomic_inc(&entry->lsm_data->refcount);
+			refcount_inc(&entry->lsm_data->refcount);
 			secattr->cache = entry->lsm_data;
 			secattr->flags |= NETLBL_SECATTR_CACHE;
 			secattr->type = NETLBL_NLTYPE_CIPSOV4;
@@ -332,7 +332,7 @@ int cipso_v4_cache_add(const unsigned char *cipso_ptr,
 	}
 	entry->key_len = cipso_ptr_len;
 	entry->hash = cipso_v4_map_cache_hash(cipso_ptr, cipso_ptr_len);
-	atomic_inc(&secattr->cache->refcount);
+	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
 	bkt = entry->hash & (CIPSO_V4_CACHE_BUCKETS - 1);
@@ -375,7 +375,7 @@ static struct cipso_v4_doi *cipso_v4_doi_search(u32 doi)
 	struct cipso_v4_doi *iter;
 
 	list_for_each_entry_rcu(iter, &cipso_v4_doi_list, list)
-		if (iter->doi == doi && atomic_read(&iter->refcount))
+		if (iter->doi == doi && refcount_read(&iter->refcount))
 			return iter;
 	return NULL;
 }
@@ -429,7 +429,7 @@ int cipso_v4_doi_add(struct cipso_v4_doi *doi_def,
 		}
 	}
 
-	atomic_set(&doi_def->refcount, 1);
+	refcount_set(&doi_def->refcount, 1);
 
 	spin_lock(&cipso_v4_doi_list_lock);
 	if (cipso_v4_doi_search(doi_def->doi)) {
@@ -533,7 +533,7 @@ int cipso_v4_doi_remove(u32 doi, struct netlbl_audit *audit_info)
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
+	if (!refcount_dec_and_test(&doi_def->refcount)) {
 		spin_unlock(&cipso_v4_doi_list_lock);
 		ret_val = -EBUSY;
 		goto doi_remove_return;
@@ -576,7 +576,7 @@ struct cipso_v4_doi *cipso_v4_doi_getdef(u32 doi)
 	doi_def = cipso_v4_doi_search(doi);
 	if (!doi_def)
 		goto doi_getdef_return;
-	if (!atomic_inc_not_zero(&doi_def->refcount))
+	if (!refcount_inc_not_zero(&doi_def->refcount))
 		doi_def = NULL;
 
 doi_getdef_return:
@@ -597,7 +597,7 @@ void cipso_v4_doi_putdef(struct cipso_v4_doi *doi_def)
 	if (!doi_def)
 		return;
 
-	if (!atomic_dec_and_test(&doi_def->refcount))
+	if (!refcount_dec_and_test(&doi_def->refcount))
 		return;
 	spin_lock(&cipso_v4_doi_list_lock);
 	list_del_rcu(&doi_def->list);
@@ -630,7 +630,7 @@ int cipso_v4_doi_walk(u32 *skip_cnt,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(iter_doi, &cipso_v4_doi_list, list)
-		if (atomic_read(&iter_doi->refcount) > 0) {
+		if (refcount_read(&iter_doi->refcount) > 0) {
 			if (doi_cnt++ < *skip_cnt)
 				continue;
 			ret_val = callback(iter_doi, cb_arg);
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 4cd2ee8..db5ba13 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -252,7 +252,7 @@ static struct in_device *inetdev_init(struct net_device *dev)
 	/* Reference in_dev->dev */
 	dev_hold(dev);
 	/* Account for reference dev->ip_ptr (below) */
-	in_dev_hold(in_dev);
+	refcount_set(&in_dev->refcnt, 1);
 
 	err = devinet_sysctl_register(in_dev);
 	if (err) {
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 7a5b4c7..49ce888 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1185,7 +1185,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg)
 	}
 
 	fi->fib_treeref++;
-	atomic_inc(&fi->fib_clntref);
+	refcount_set(&fi->fib_clntref, 1);
 	spin_lock_bh(&fib_info_lock);
 	hlist_add_head(&fi->fib_hash,
 		       &fib_info_hash[fib_info_hashfn(fi)]);
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2919d1a..77e51ca 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1542,7 +1542,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 			}
 
 			if (!(fib_flags & FIB_LOOKUP_NOREF))
-				atomic_inc(&fi->fib_clntref);
+				refcount_inc(&fi->fib_clntref);
 
 			res->prefixlen = KEYLENGTH - fa->fa_slen;
 			res->nh_sel = nhsel;
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 68d6221..3c675e3 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -173,7 +173,7 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 
 static void ip_ma_put(struct ip_mc_list *im)
 {
-	if (atomic_dec_and_test(&im->refcnt)) {
+	if (refcount_dec_and_test(&im->refcnt)) {
 		in_dev_put(im->interface);
 		kfree_rcu(im, rcu);
 	}
@@ -199,7 +199,7 @@ static void igmp_stop_timer(struct ip_mc_list *im)
 {
 	spin_lock_bh(&im->lock);
 	if (del_timer(&im->timer))
-		atomic_dec(&im->refcnt);
+		refcount_dec(&im->refcnt);
 	im->tm_running = 0;
 	im->reporter = 0;
 	im->unsolicit_count = 0;
@@ -213,7 +213,7 @@ static void igmp_start_timer(struct ip_mc_list *im, int max_delay)
 
 	im->tm_running = 1;
 	if (!mod_timer(&im->timer, jiffies+tv+2))
-		atomic_inc(&im->refcnt);
+		refcount_inc(&im->refcnt);
 }
 
 static void igmp_gq_start_timer(struct in_device *in_dev)
@@ -244,7 +244,7 @@ static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
 			spin_unlock_bh(&im->lock);
 			return;
 		}
-		atomic_dec(&im->refcnt);
+		refcount_dec(&im->refcnt);
 	}
 	igmp_start_timer(im, max_delay);
 	spin_unlock_bh(&im->lock);
@@ -1367,7 +1367,7 @@ void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 	/* initial mode is (EX, empty) */
 	im->sfmode = MCAST_EXCLUDE;
 	im->sfcount[MCAST_EXCLUDE] = 1;
-	atomic_set(&im->refcnt, 1);
+	refcount_set(&im->refcnt, 1);
 	spin_lock_init(&im->lock);
 #ifdef CONFIG_IP_MULTICAST
 	setup_timer(&im->timer, igmp_timer_expire, (unsigned long)im);
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 19ea045..edf004d 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -630,7 +630,7 @@ static void reqsk_queue_hash_req(struct request_sock *req,
 	 * are committed to memory and refcnt initialized.
 	 */
 	smp_wmb();
-	atomic_set(&req->rsk_refcnt, 2 + 1);
+	refcount_set(&req->rsk_refcnt, 2 + 1);
 }
 
 void inet_csk_reqsk_queue_hash_add(struct sock *sk, struct request_sock *req,
diff --git a/net/ipv4/inet_fragment.c b/net/ipv4/inet_fragment.c
index b5e9317..96e95e8 100644
--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -276,11 +276,11 @@ static inline void fq_unlink(struct inet_frag_queue *fq, struct inet_frags *f)
 void inet_frag_kill(struct inet_frag_queue *fq, struct inet_frags *f)
 {
 	if (del_timer(&fq->timer))
-		atomic_dec(&fq->refcnt);
+		refcount_dec(&fq->refcnt);
 
 	if (!(fq->flags & INET_FRAG_COMPLETE)) {
 		fq_unlink(fq, f);
-		atomic_dec(&fq->refcnt);
+		refcount_dec(&fq->refcnt);
 	}
 }
 EXPORT_SYMBOL(inet_frag_kill);
@@ -329,7 +329,7 @@ static struct inet_frag_queue *inet_frag_intern(struct netns_frags *nf,
 	 */
 	hlist_for_each_entry(qp, &hb->chain, list) {
 		if (qp->net == nf && f->match(qp, arg)) {
-			atomic_inc(&qp->refcnt);
+			refcount_inc(&qp->refcnt);
 			spin_unlock(&hb->chain_lock);
 			qp_in->flags |= INET_FRAG_COMPLETE;
 			inet_frag_put(qp_in, f);
@@ -339,9 +339,9 @@ static struct inet_frag_queue *inet_frag_intern(struct netns_frags *nf,
 #endif
 	qp = qp_in;
 	if (!mod_timer(&qp->timer, jiffies + nf->timeout))
-		atomic_inc(&qp->refcnt);
+		refcount_inc(&qp->refcnt);
 
-	atomic_inc(&qp->refcnt);
+	refcount_inc(&qp->refcnt);
 	hlist_add_head(&qp->list, &hb->chain);
 
 	spin_unlock(&hb->chain_lock);
@@ -370,7 +370,7 @@ static struct inet_frag_queue *inet_frag_alloc(struct netns_frags *nf,
 
 	setup_timer(&q->timer, f->frag_expire, (unsigned long)q);
 	spin_lock_init(&q->lock);
-	atomic_set(&q->refcnt, 1);
+	refcount_set(&q->refcnt, 1);
 
 	return q;
 }
@@ -405,7 +405,7 @@ struct inet_frag_queue *inet_frag_find(struct netns_frags *nf,
 	spin_lock(&hb->chain_lock);
 	hlist_for_each_entry(q, &hb->chain, list) {
 		if (q->net == nf && f->match(q, key)) {
-			atomic_inc(&q->refcnt);
+			refcount_inc(&q->refcnt);
 			spin_unlock(&hb->chain_lock);
 			return q;
 		}
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ca97835..e34f3bd 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -249,7 +249,7 @@ EXPORT_SYMBOL_GPL(__inet_lookup_listener);
 /* All sockets share common refcount, but have different destructors */
 void sock_gen_put(struct sock *sk)
 {
-	if (!atomic_dec_and_test(&sk->sk_refcnt))
+	if (!refcount_dec_and_test(&sk->sk_refcnt))
 		return;
 
 	if (sk->sk_state == TCP_TIME_WAIT)
@@ -290,7 +290,7 @@ struct sock *__inet_lookup_established(struct net *net,
 			continue;
 		if (likely(INET_MATCH(sk, net, acookie,
 				      saddr, daddr, ports, dif))) {
-			if (unlikely(!atomic_inc_not_zero(&sk->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				goto out;
 			if (unlikely(!INET_MATCH(sk, net, acookie,
 						 saddr, daddr, ports, dif))) {
diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
index ddcd56c..e0b6cc5 100644
--- a/net/ipv4/inet_timewait_sock.c
+++ b/net/ipv4/inet_timewait_sock.c
@@ -76,7 +76,7 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
 
 void inet_twsk_put(struct inet_timewait_sock *tw)
 {
-	if (atomic_dec_and_test(&tw->tw_refcnt))
+	if (refcount_dec_and_test(&tw->tw_refcnt))
 		inet_twsk_free(tw);
 }
 EXPORT_SYMBOL_GPL(inet_twsk_put);
@@ -131,7 +131,7 @@ void __inet_twsk_hashdance(struct inet_timewait_sock *tw, struct sock *sk,
 	 * We can use atomic_set() because prior spin_lock()/spin_unlock()
 	 * committed into memory all tw fields.
 	 */
-	atomic_set(&tw->tw_refcnt, 4);
+	refcount_set(&tw->tw_refcnt, 4);
 	inet_twsk_add_node_rcu(tw, &ehead->chain);
 
 	/* Step 3: Remove SK from hash chain */
@@ -195,7 +195,7 @@ struct inet_timewait_sock *inet_twsk_alloc(const struct sock *sk,
 		 * to a non null value before everything is setup for this
 		 * timewait socket.
 		 */
-		atomic_set(&tw->tw_refcnt, 0);
+		refcount_set(&tw->tw_refcnt, 0);
 
 		__module_get(tw->tw_prot->owner);
 	}
@@ -279,7 +279,7 @@ void inet_twsk_purge(struct inet_hashinfo *hashinfo,
 				atomic_read(&twsk_net(tw)->count))
 				continue;
 
-			if (unlikely(!atomic_inc_not_zero(&tw->tw_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&tw->tw_refcnt)))
 				continue;
 
 			if (unlikely((tw->tw_family != family) ||
diff --git a/net/ipv4/inetpeer.c b/net/ipv4/inetpeer.c
index 86fa458..c5a117c 100644
--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -115,7 +115,7 @@ static void inetpeer_gc_worker(struct work_struct *work)
 
 		n = list_entry(p->gc_list.next, struct inet_peer, gc_list);
 
-		if (!atomic_read(&p->refcnt)) {
+		if (refcount_read(&p->refcnt) == 1) {
 			list_del(&p->gc_list);
 			kmem_cache_free(peer_cachep, p);
 		}
@@ -202,10 +202,11 @@ static struct inet_peer *lookup_rcu(const struct inetpeer_addr *daddr,
 		int cmp = inetpeer_addr_cmp(daddr, &u->daddr);
 		if (cmp == 0) {
 			/* Before taking a reference, check if this entry was
-			 * deleted (refcnt=-1)
+			 * deleted (refcnt=0)
 			 */
-			if (!atomic_add_unless(&u->refcnt, 1, -1))
+			if (!refcount_inc_not_zero(&u->refcnt)) {
 				u = NULL;
+			}
 			return u;
 		}
 		if (cmp == -1)
@@ -382,11 +383,10 @@ static int inet_peer_gc(struct inet_peer_base *base,
 	while (stackptr > stack) {
 		stackptr--;
 		p = rcu_deref_locked(**stackptr, base);
-		if (atomic_read(&p->refcnt) == 0) {
+		if (refcount_read(&p->refcnt) == 1) {
 			smp_rmb();
 			delta = (__u32)jiffies - p->dtime;
-			if (delta >= ttl &&
-			    atomic_cmpxchg(&p->refcnt, 0, -1) == 0) {
+			if (delta >= ttl && refcount_dec_if_one(&p->refcnt)) {
 				p->gc_next = gchead;
 				gchead = p;
 			}
@@ -432,7 +432,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 relookup:
 	p = lookup(daddr, stack, base);
 	if (p != peer_avl_empty) {
-		atomic_inc(&p->refcnt);
+		refcount_inc(&p->refcnt);
 		write_sequnlock_bh(&base->lock);
 		return p;
 	}
@@ -444,7 +444,7 @@ struct inet_peer *inet_getpeer(struct inet_peer_base *base,
 	p = create ? kmem_cache_alloc(peer_cachep, GFP_ATOMIC) : NULL;
 	if (p) {
 		p->daddr = *daddr;
-		atomic_set(&p->refcnt, 1);
+		refcount_set(&p->refcnt, 2);
 		atomic_set(&p->rid, 0);
 		p->metrics[RTAX_LOCK-1] = INETPEER_METRICS_NEW;
 		p->rate_tokens = 0;
@@ -468,7 +468,7 @@ void inet_putpeer(struct inet_peer *p)
 {
 	p->dtime = (__u32)jiffies;
 	smp_mb__before_atomic();
-	atomic_dec(&p->refcnt);
+	refcount_dec(&p->refcnt);
 }
 EXPORT_SYMBOL_GPL(inet_putpeer);
 
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index bbe7f72..4fed6f6 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -303,7 +303,7 @@ static int ip_frag_reinit(struct ipq *qp)
 	unsigned int sum_truesize = 0;
 
 	if (!mod_timer(&qp->q.timer, jiffies + qp->q.net->timeout)) {
-		atomic_inc(&qp->q.refcnt);
+		refcount_inc(&qp->q.refcnt);
 		return -ETIMEDOUT;
 	}
 
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index fac275c4..4c611f2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1030,7 +1030,7 @@ static int __ip_append_data(struct sock *sk,
 						(flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
-				if (atomic_read(&sk->sk_wmem_alloc) <=
+				if (refcount_read(&sk->sk_wmem_alloc) <=
 				    2 * sk->sk_sndbuf)
 					skb = sock_wmalloc(sk,
 							   alloclen + hh_len + 15, 1,
@@ -1135,7 +1135,7 @@ static int __ip_append_data(struct sock *sk,
 			skb->len += copy;
 			skb->data_len += copy;
 			skb->truesize += copy;
-			atomic_add(copy, &sk->sk_wmem_alloc);
+			refcount_add(copy, &sk->sk_wmem_alloc);
 		}
 		offset += copy;
 		length -= copy;
@@ -1359,7 +1359,7 @@ ssize_t	ip_append_page(struct sock *sk, struct flowi4 *fl4, struct page *page,
 		skb->len += len;
 		skb->data_len += len;
 		skb->truesize += len;
-		atomic_add(len, &sk->sk_wmem_alloc);
+		refcount_add(len, &sk->sk_wmem_alloc);
 		offset += len;
 		size -= len;
 	}
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 21db00d..9b8bb40 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -22,6 +22,7 @@
 #include <linux/icmp.h>
 #include <linux/if_arp.h>
 #include <linux/seq_file.h>
+#include <linux/refcount.h>
 #include <linux/netfilter_arp.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -40,8 +41,8 @@ MODULE_DESCRIPTION("Xtables: CLUSTERIP target");
 
 struct clusterip_config {
 	struct list_head list;			/* list of all configs */
-	atomic_t refcount;			/* reference count */
-	atomic_t entries;			/* number of entries/rules
+	refcount_t refcount;			/* reference count */
+	refcount_t entries;			/* number of entries/rules
 						 * referencing us */
 
 	__be32 clusterip;			/* the IP address */
@@ -77,7 +78,7 @@ struct clusterip_net {
 static inline void
 clusterip_config_get(struct clusterip_config *c)
 {
-	atomic_inc(&c->refcount);
+	refcount_inc(&c->refcount);
 }
 
 
@@ -89,7 +90,7 @@ static void clusterip_config_rcu_free(struct rcu_head *head)
 static inline void
 clusterip_config_put(struct clusterip_config *c)
 {
-	if (atomic_dec_and_test(&c->refcount))
+	if (refcount_dec_and_test(&c->refcount))
 		call_rcu_bh(&c->rcu, clusterip_config_rcu_free);
 }
 
@@ -103,7 +104,7 @@ clusterip_config_entry_put(struct clusterip_config *c)
 	struct clusterip_net *cn = net_generic(net, clusterip_net_id);
 
 	local_bh_disable();
-	if (atomic_dec_and_lock(&c->entries, &cn->lock)) {
+	if (refcount_dec_and_lock(&c->entries, &cn->lock)) {
 		list_del_rcu(&c->list);
 		spin_unlock(&cn->lock);
 		local_bh_enable();
@@ -144,10 +145,10 @@ clusterip_config_find_get(struct net *net, __be32 clusterip, int entry)
 	rcu_read_lock_bh();
 	c = __clusterip_config_find(net, clusterip);
 	if (c) {
-		if (unlikely(!atomic_inc_not_zero(&c->refcount)))
+		if (unlikely(!refcount_inc_not_zero(&c->refcount)))
 			c = NULL;
 		else if (entry)
-			atomic_inc(&c->entries);
+			refcount_inc(&c->entries);
 	}
 	rcu_read_unlock_bh();
 
@@ -182,8 +183,8 @@ clusterip_config_init(const struct ipt_clusterip_tgt_info *i, __be32 ip,
 	clusterip_config_init_nodelist(c, i);
 	c->hash_mode = i->hash_mode;
 	c->hash_initval = i->hash_initval;
-	atomic_set(&c->refcount, 1);
-	atomic_set(&c->entries, 1);
+	refcount_set(&c->refcount, 1);
+	refcount_set(&c->entries, 1);
 
 #ifdef CONFIG_PROC_FS
 	{
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 86cca61..4ecef05 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -289,7 +289,7 @@ void ping_close(struct sock *sk, long timeout)
 {
 	pr_debug("ping_close(sk=%p,sk->num=%u)\n",
 		 inet_sk(sk), inet_sk(sk)->inet_num);
-	pr_debug("isk->refcnt = %d\n", sk->sk_refcnt.counter);
+	pr_debug("isk->refcnt = %d\n", refcount_read(&sk->sk_refcnt));
 
 	sk_common_release(sk);
 }
@@ -1123,7 +1123,7 @@ static void ping_v4_format_sock(struct sock *sp, struct seq_file *f,
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
-		atomic_read(&sp->sk_refcnt), sp,
+		refcount_read(&sp->sk_refcnt), sp,
 		atomic_read(&sp->sk_drops));
 }
 
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 4e49e5c..c772a96 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -1054,7 +1054,7 @@ static void raw_sock_seq_show(struct seq_file *seq, struct sock *sp, int i)
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
-		atomic_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
+		refcount_read(&sp->sk_refcnt), sp, atomic_read(&sp->sk_drops));
 }
 
 static int raw_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 3e88467..1f7b47e 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -223,7 +223,7 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 	child = icsk->icsk_af_ops->syn_recv_sock(sk, skb, req, dst,
 						 NULL, &own_req);
 	if (child) {
-		atomic_set(&req->rsk_refcnt, 1);
+		refcount_set(&req->rsk_refcnt, 1);
 		sock_rps_save_rxhash(child, skb);
 		inet_csk_reqsk_queue_add(sk, req, child);
 	} else {
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4a04496..bb42a42 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -642,7 +642,7 @@ static bool tcp_should_autocork(struct sock *sk, struct sk_buff *skb,
 	return skb->len < size_goal &&
 	       sysctl_tcp_autocorking &&
 	       skb != tcp_write_queue_head(sk) &&
-	       atomic_read(&sk->sk_wmem_alloc) > skb->truesize;
+	       refcount_read(&sk->sk_wmem_alloc) > skb->truesize;
 }
 
 static void tcp_push(struct sock *sk, int flags, int mss_now,
@@ -670,7 +670,7 @@ static void tcp_push(struct sock *sk, int flags, int mss_now,
 		/* It is possible TX completion already happened
 		 * before we set TSQ_THROTTLED.
 		 */
-		if (atomic_read(&sk->sk_wmem_alloc) > skb->truesize)
+		if (refcount_read(&sk->sk_wmem_alloc) > skb->truesize)
 			return;
 	}
 
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 4e777a3..ca4a679 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -213,7 +213,7 @@ static struct sock *tcp_fastopen_create_child(struct sock *sk,
 	inet_csk_reset_xmit_timer(child, ICSK_TIME_RETRANS,
 				  TCP_TIMEOUT_INIT, TCP_RTO_MAX);
 
-	atomic_set(&req->rsk_refcnt, 2);
+	refcount_set(&req->rsk_refcnt, 2);
 
 	/* Now finish processing the fastopen child socket. */
 	inet_csk(child)->icsk_af_ops->rebuild_header(child);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fe9da4f..adcdcef 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2263,7 +2263,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sk)),
 		icsk->icsk_probes_out,
 		sock_i_ino(sk),
-		atomic_read(&sk->sk_refcnt), sk,
+		refcount_read(&sk->sk_refcnt), sk,
 		jiffies_to_clock_t(icsk->icsk_rto),
 		jiffies_to_clock_t(icsk->icsk_ack.ato),
 		(icsk->icsk_ack.quick << 1) | icsk->icsk_ack.pingpong,
@@ -2289,7 +2289,7 @@ static void get_timewait4_sock(const struct inet_timewait_sock *tw,
 		" %02X %08X:%08X %02X:%08lX %08X %5d %8d %d %d %pK",
 		i, src, srcp, dest, destp, tw->tw_substate, 0, 0,
 		3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
-		atomic_read(&tw->tw_refcnt), tw);
+		refcount_read(&tw->tw_refcnt), tw);
 }
 
 #define TMPSZ 150
diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index bc68da3..11f69bb 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -152,7 +152,7 @@ struct sk_buff *tcp_gso_segment(struct sk_buff *skb,
 		swap(gso_skb->sk, skb->sk);
 		swap(gso_skb->destructor, skb->destructor);
 		sum_truesize += skb->truesize;
-		atomic_add(sum_truesize - gso_skb->truesize,
+		refcount_add(sum_truesize - gso_skb->truesize,
 			   &skb->sk->sk_wmem_alloc);
 	}
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 1d5331a..91cdf1c 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -862,12 +862,11 @@ void tcp_wfree(struct sk_buff *skb)
 	struct sock *sk = skb->sk;
 	struct tcp_sock *tp = tcp_sk(sk);
 	unsigned long flags, nval, oval;
-	int wmem;
 
 	/* Keep one reference on sk_wmem_alloc.
 	 * Will be released by sk_free() from here or tcp_tasklet_func()
 	 */
-	wmem = atomic_sub_return(skb->truesize - 1, &sk->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(skb->truesize - 1, &sk->sk_wmem_alloc));
 
 	/* If this softirq is serviced by ksoftirqd, we are likely under stress.
 	 * Wait until our queues (qdisc + devices) are drained.
@@ -876,7 +875,7 @@ void tcp_wfree(struct sk_buff *skb)
 	 * - chance for incoming ACK (processed by another cpu maybe)
 	 *   to migrate this flow (skb->ooo_okay will be eventually set)
 	 */
-	if (wmem >= SKB_TRUESIZE(1) && this_cpu_ksoftirqd() == current)
+	if (refcount_read(&sk->sk_wmem_alloc) >= SKB_TRUESIZE(1) && this_cpu_ksoftirqd() == current)
 		goto out;
 
 	for (oval = READ_ONCE(sk->sk_tsq_flags);; oval = nval) {
@@ -973,7 +972,7 @@ static int tcp_transmit_skb(struct sock *sk, struct sk_buff *skb, int clone_it,
 	skb->sk = sk;
 	skb->destructor = skb_is_tcp_pure_ack(skb) ? __sock_wfree : tcp_wfree;
 	skb_set_hash_from_sk(skb, sk);
-	atomic_add(skb->truesize, &sk->sk_wmem_alloc);
+	refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 
 	/* Build TCP header and checksum it. */
 	th = (struct tcphdr *)skb->data;
@@ -2091,7 +2090,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 	limit = min_t(u32, limit, sysctl_tcp_limit_output_bytes);
 	limit <<= factor;
 
-	if (atomic_read(&sk->sk_wmem_alloc) > limit) {
+	if (refcount_read(&sk->sk_wmem_alloc) > limit) {
 		/* Always send the 1st or 2nd skb in write queue.
 		 * No need to wait for TX completion to call us back,
 		 * after softirq/tasklet schedule.
@@ -2107,7 +2106,7 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		 * test again the condition.
 		 */
 		smp_mb__after_atomic();
-		if (atomic_read(&sk->sk_wmem_alloc) > limit)
+		if (refcount_read(&sk->sk_wmem_alloc) > limit)
 			return true;
 	}
 	return false;
@@ -2724,7 +2723,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 	/* Do not sent more than we queued. 1/4 is reserved for possible
 	 * copying overhead: fragmentation, tunneling, mangling etc.
 	 */
-	if (atomic_read(&sk->sk_wmem_alloc) >
+	if (refcount_read(&sk->sk_wmem_alloc) >
 	    min_t(u32, sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2),
 		  sk->sk_sndbuf))
 		return -EAGAIN;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 1307a7c..9cf2697 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -589,7 +589,7 @@ struct sock *udp4_lib_lookup(struct net *net, __be32 saddr, __be16 sport,
 
 	sk = __udp4_lib_lookup(net, saddr, sport, daddr, dport,
 			       dif, &udp_table, NULL);
-	if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
 }
@@ -2093,7 +2093,7 @@ void udp_v4_early_demux(struct sk_buff *skb)
 					     uh->source, iph->saddr, dif);
 	}
 
-	if (!sk || !atomic_inc_not_zero_hint(&sk->sk_refcnt, 2))
+	if (!sk || !refcount_inc_not_zero(&sk->sk_refcnt))
 		return;
 
 	skb->sk = sk;
@@ -2541,7 +2541,7 @@ static void udp4_format_sock(struct sock *sp, struct seq_file *f,
 		0, 0L, 0,
 		from_kuid_munged(seq_user_ns(f), sock_i_uid(sp)),
 		0, sock_i_ino(sp),
-		atomic_read(&sp->sk_refcnt), sp,
+		refcount_read(&sp->sk_refcnt), sp,
 		atomic_read(&sp->sk_drops));
 }
 
diff --git a/net/ipv4/udp_diag.c b/net/ipv4/udp_diag.c
index 9a89c10..4515836 100644
--- a/net/ipv4/udp_diag.c
+++ b/net/ipv4/udp_diag.c
@@ -55,7 +55,7 @@ static int udp_dump_one(struct udp_table *tbl, struct sk_buff *in_skb,
 				req->id.idiag_dport,
 				req->id.idiag_if, tbl, NULL);
 #endif
-	if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	rcu_read_unlock();
 	err = -ENOENT;
@@ -206,7 +206,7 @@ static int __udp_diag_destroy(struct sk_buff *in_skb,
 		return -EINVAL;
 	}
 
-	if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 
 	rcu_read_unlock();
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index c1e124b..9db691e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -419,7 +419,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	}
 
 	/* One reference from device. */
-	in6_dev_hold(ndev);
+	refcount_set(&ndev->refcnt, 1);
 
 	if (dev->flags & (IFF_NOARP | IFF_LOOPBACK))
 		ndev->cnf.accept_dad = -1;
@@ -1009,7 +1009,7 @@ ipv6_add_addr(struct inet6_dev *idev, const struct in6_addr *addr,
 	ifa->idev = idev;
 	in6_dev_hold(idev);
 	/* For caller */
-	in6_ifa_hold(ifa);
+	refcount_set(&ifa->refcnt, 1);
 
 	/* Add to big hash table */
 	hash = inet6_addr_hash(addr);
diff --git a/net/ipv6/addrlabel.c b/net/ipv6/addrlabel.c
index a8f6986..9340804 100644
--- a/net/ipv6/addrlabel.c
+++ b/net/ipv6/addrlabel.c
@@ -18,6 +18,7 @@
 #include <linux/if_addrlabel.h>
 #include <linux/netlink.h>
 #include <linux/rtnetlink.h>
+#include <linux/refcount.h>
 
 #if 0
 #define ADDRLABEL(x...) printk(x)
@@ -36,7 +37,7 @@ struct ip6addrlbl_entry {
 	int addrtype;
 	u32 label;
 	struct hlist_node list;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct rcu_head rcu;
 };
 
@@ -137,12 +138,12 @@ static void ip6addrlbl_free_rcu(struct rcu_head *h)
 
 static bool ip6addrlbl_hold(struct ip6addrlbl_entry *p)
 {
-	return atomic_inc_not_zero(&p->refcnt);
+	return refcount_inc_not_zero(&p->refcnt);
 }
 
 static inline void ip6addrlbl_put(struct ip6addrlbl_entry *p)
 {
-	if (atomic_dec_and_test(&p->refcnt))
+	if (refcount_dec_and_test(&p->refcnt))
 		call_rcu(&p->rcu, ip6addrlbl_free_rcu);
 }
 
@@ -236,7 +237,7 @@ static struct ip6addrlbl_entry *ip6addrlbl_alloc(struct net *net,
 	newp->label = label;
 	INIT_HLIST_NODE(&newp->list);
 	write_pnet(&newp->lbl_net, net);
-	atomic_set(&newp->refcnt, 1);
+	refcount_set(&newp->refcnt, 1);
 	return newp;
 }
 
diff --git a/net/ipv6/anycast.c b/net/ipv6/anycast.c
index 514ac25..0bbab8a 100644
--- a/net/ipv6/anycast.c
+++ b/net/ipv6/anycast.c
@@ -203,12 +203,12 @@ void ipv6_sock_ac_close(struct sock *sk)
 
 static void aca_get(struct ifacaddr6 *aca)
 {
-	atomic_inc(&aca->aca_refcnt);
+	refcount_inc(&aca->aca_refcnt);
 }
 
 static void aca_put(struct ifacaddr6 *ac)
 {
-	if (atomic_dec_and_test(&ac->aca_refcnt)) {
+	if (refcount_dec_and_test(&ac->aca_refcnt)) {
 		in6_dev_put(ac->aca_idev);
 		dst_release(&ac->aca_rt->dst);
 		kfree(ac);
@@ -232,7 +232,7 @@ static struct ifacaddr6 *aca_alloc(struct rt6_info *rt,
 	aca->aca_users = 1;
 	/* aca_tstamp should be updated upon changes */
 	aca->aca_cstamp = aca->aca_tstamp = jiffies;
-	atomic_set(&aca->aca_refcnt, 1);
+	refcount_set(&aca->aca_refcnt, 1);
 
 	return aca;
 }
diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 37ac9de..a475564 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -227,7 +227,7 @@ static int calipso_cache_check(const unsigned char *key,
 		    entry->key_len == key_len &&
 		    memcmp(entry->key, key, key_len) == 0) {
 			entry->activity += 1;
-			atomic_inc(&entry->lsm_data->refcount);
+			refcount_inc(&entry->lsm_data->refcount);
 			secattr->cache = entry->lsm_data;
 			secattr->flags |= NETLBL_SECATTR_CACHE;
 			secattr->type = NETLBL_NLTYPE_CALIPSO;
@@ -296,7 +296,7 @@ static int calipso_cache_add(const unsigned char *calipso_ptr,
 	}
 	entry->key_len = calipso_ptr_len;
 	entry->hash = calipso_map_cache_hash(calipso_ptr, calipso_ptr_len);
-	atomic_inc(&secattr->cache->refcount);
+	refcount_inc(&secattr->cache->refcount);
 	entry->lsm_data = secattr->cache;
 
 	bkt = entry->hash & (CALIPSO_CACHE_BUCKETS - 1);
@@ -338,7 +338,7 @@ static struct calipso_doi *calipso_doi_search(u32 doi)
 	struct calipso_doi *iter;
 
 	list_for_each_entry_rcu(iter, &calipso_doi_list, list)
-		if (iter->doi == doi && atomic_read(&iter->refcount))
+		if (iter->doi == doi && refcount_read(&iter->refcount))
 			return iter;
 	return NULL;
 }
@@ -370,7 +370,7 @@ static int calipso_doi_add(struct calipso_doi *doi_def,
 	if (doi_def->doi == CALIPSO_DOI_UNKNOWN)
 		goto doi_add_return;
 
-	atomic_set(&doi_def->refcount, 1);
+	refcount_set(&doi_def->refcount, 1);
 
 	spin_lock(&calipso_doi_list_lock);
 	if (calipso_doi_search(doi_def->doi)) {
@@ -458,7 +458,7 @@ static int calipso_doi_remove(u32 doi, struct netlbl_audit *audit_info)
 		ret_val = -ENOENT;
 		goto doi_remove_return;
 	}
-	if (!atomic_dec_and_test(&doi_def->refcount)) {
+	if (!refcount_dec_and_test(&doi_def->refcount)) {
 		spin_unlock(&calipso_doi_list_lock);
 		ret_val = -EBUSY;
 		goto doi_remove_return;
@@ -499,7 +499,7 @@ static struct calipso_doi *calipso_doi_getdef(u32 doi)
 	doi_def = calipso_doi_search(doi);
 	if (!doi_def)
 		goto doi_getdef_return;
-	if (!atomic_inc_not_zero(&doi_def->refcount))
+	if (!refcount_inc_not_zero(&doi_def->refcount))
 		doi_def = NULL;
 
 doi_getdef_return:
@@ -520,7 +520,7 @@ static void calipso_doi_putdef(struct calipso_doi *doi_def)
 	if (!doi_def)
 		return;
 
-	if (!atomic_dec_and_test(&doi_def->refcount))
+	if (!refcount_dec_and_test(&doi_def->refcount))
 		return;
 	spin_lock(&calipso_doi_list_lock);
 	list_del_rcu(&doi_def->list);
@@ -553,7 +553,7 @@ static int calipso_doi_walk(u32 *skip_cnt,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(iter_doi, &calipso_doi_list, list)
-		if (atomic_read(&iter_doi->refcount) > 0) {
+		if (refcount_read(&iter_doi->refcount) > 0) {
 			if (doi_cnt++ < *skip_cnt)
 				continue;
 			ret_val = callback(iter_doi, cb_arg);
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index a3eaafd..0470d88 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -1039,6 +1039,6 @@ void ip6_dgram_sock_seq_show(struct seq_file *seq, struct sock *sp,
 		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
 		   0,
 		   sock_i_ino(sp),
-		   atomic_read(&sp->sk_refcnt), sp,
+		   refcount_read(&sp->sk_refcnt), sp,
 		   atomic_read(&sp->sk_drops));
 }
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index e419850..51e04e6 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -995,7 +995,7 @@ ipv6_dup_options(struct sock *sk, struct ipv6_txoptions *opt)
 			*((char **)&opt2->dst1opt) += dif;
 		if (opt2->srcrt)
 			*((char **)&opt2->srcrt) += dif;
-		atomic_set(&opt2->refcnt, 1);
+		refcount_set(&opt2->refcnt, 1);
 	}
 	return opt2;
 }
@@ -1080,7 +1080,7 @@ ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
 		return ERR_PTR(-ENOBUFS);
 
 	memset(opt2, 0, tot_len);
-	atomic_set(&opt2->refcnt, 1);
+	refcount_set(&opt2->refcnt, 1);
 	opt2->tot_len = tot_len;
 	p = (char *)(opt2 + 1);
 
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 02761c9..e707108 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -75,7 +75,7 @@ struct sock *__inet6_lookup_established(struct net *net,
 			continue;
 		if (!INET6_MATCH(sk, net, saddr, daddr, ports, dif))
 			continue;
-		if (unlikely(!atomic_inc_not_zero(&sk->sk_refcnt)))
+		if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 			goto out;
 
 		if (unlikely(!INET6_MATCH(sk, net, saddr, daddr, ports, dif))) {
@@ -172,7 +172,7 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 
 	sk = __inet6_lookup(net, hashinfo, skb, doff, saddr, sport, daddr,
 			    ntohs(dport), dif, &refcounted);
-	if (sk && !refcounted && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcounted && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
 }
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 70d0de40..cf36fc2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1455,7 +1455,7 @@ static int __ip6_append_data(struct sock *sk,
 						(flags & MSG_DONTWAIT), &err);
 			} else {
 				skb = NULL;
-				if (atomic_read(&sk->sk_wmem_alloc) <=
+				if (refcount_read(&sk->sk_wmem_alloc) <=
 				    2 * sk->sk_sndbuf)
 					skb = sock_wmalloc(sk,
 							   alloclen + hh_len, 1,
@@ -1565,7 +1565,7 @@ static int __ip6_append_data(struct sock *sk,
 			skb->len += copy;
 			skb->data_len += copy;
 			skb->truesize += copy;
-			atomic_add(copy, &sk->sk_wmem_alloc);
+			refcount_add(copy, &sk->sk_wmem_alloc);
 		}
 		offset += copy;
 		length -= copy;
diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index ee97c44..9c39746 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -505,7 +505,7 @@ static int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
 			break;
 
 		memset(opt, 0, sizeof(*opt));
-		atomic_set(&opt->refcnt, 1);
+		refcount_set(&opt->refcnt, 1);
 		opt->tot_len = sizeof(*opt) + optlen;
 		retv = -EFAULT;
 		if (copy_from_user(opt+1, optval, optlen))
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 14a3903..4ae7a0b 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -701,7 +701,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 
 	spin_lock_bh(&mc->mca_lock);
 	if (del_timer(&mc->mca_timer))
-		atomic_dec(&mc->mca_refcnt);
+		refcount_dec(&mc->mca_refcnt);
 done:
 	ip6_mc_clear_src(mc);
 	spin_unlock_bh(&mc->mca_lock);
@@ -813,12 +813,12 @@ static void mld_clear_delrec(struct inet6_dev *idev)
 
 static void mca_get(struct ifmcaddr6 *mc)
 {
-	atomic_inc(&mc->mca_refcnt);
+	refcount_inc(&mc->mca_refcnt);
 }
 
 static void ma_put(struct ifmcaddr6 *mc)
 {
-	if (atomic_dec_and_test(&mc->mca_refcnt)) {
+	if (refcount_dec_and_test(&mc->mca_refcnt)) {
 		in6_dev_put(mc->idev);
 		kfree(mc);
 	}
@@ -840,7 +840,7 @@ static struct ifmcaddr6 *mca_alloc(struct inet6_dev *idev,
 	mc->mca_users = 1;
 	/* mca_stamp should be updated upon changes */
 	mc->mca_cstamp = mc->mca_tstamp = jiffies;
-	atomic_set(&mc->mca_refcnt, 1);
+	refcount_set(&mc->mca_refcnt, 1);
 	spin_lock_init(&mc->mca_lock);
 
 	/* initial mode is (EX, empty) */
@@ -1058,7 +1058,7 @@ static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 		return;
 
 	if (del_timer(&ma->mca_timer)) {
-		atomic_dec(&ma->mca_refcnt);
+		refcount_dec(&ma->mca_refcnt);
 		delay = ma->mca_timer.expires - jiffies;
 	}
 
@@ -1067,7 +1067,7 @@ static void igmp6_group_queried(struct ifmcaddr6 *ma, unsigned long resptime)
 
 	ma->mca_timer.expires = jiffies + delay;
 	if (!mod_timer(&ma->mca_timer, jiffies + delay))
-		atomic_inc(&ma->mca_refcnt);
+		refcount_inc(&ma->mca_refcnt);
 	ma->mca_flags |= MAF_TIMER_RUNNING;
 }
 
@@ -1462,7 +1462,7 @@ int igmp6_event_report(struct sk_buff *skb)
 		if (ipv6_addr_equal(&ma->mca_addr, &mld->mld_mca)) {
 			spin_lock(&ma->mca_lock);
 			if (del_timer(&ma->mca_timer))
-				atomic_dec(&ma->mca_refcnt);
+				refcount_dec(&ma->mca_refcnt);
 			ma->mca_flags &= ~(MAF_LAST_REPORTER|MAF_TIMER_RUNNING);
 			spin_unlock(&ma->mca_lock);
 			break;
@@ -2385,12 +2385,12 @@ static void igmp6_join_group(struct ifmcaddr6 *ma)
 
 	spin_lock_bh(&ma->mca_lock);
 	if (del_timer(&ma->mca_timer)) {
-		atomic_dec(&ma->mca_refcnt);
+		refcount_dec(&ma->mca_refcnt);
 		delay = ma->mca_timer.expires - jiffies;
 	}
 
 	if (!mod_timer(&ma->mca_timer, jiffies + delay))
-		atomic_inc(&ma->mca_refcnt);
+		refcount_inc(&ma->mca_refcnt);
 	ma->mca_flags |= MAF_TIMER_RUNNING | MAF_LAST_REPORTER;
 	spin_unlock_bh(&ma->mca_lock);
 }
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index a4d4976..8681837 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -188,7 +188,7 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	if (ipv6_opt_accepted(sk, skb, &TCP_SKB_CB(skb)->header.h6) ||
 	    np->rxopt.bits.rxinfo || np->rxopt.bits.rxoinfo ||
 	    np->rxopt.bits.rxhlim || np->rxopt.bits.rxohlim) {
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 		ireq->pktopts = skb;
 	}
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 73bc8fc6..c88b5c9 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -704,7 +704,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	     np->rxopt.bits.rxinfo ||
 	     np->rxopt.bits.rxoinfo || np->rxopt.bits.rxhlim ||
 	     np->rxopt.bits.rxohlim || np->repflow)) {
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 		ireq->pktopts = skb;
 	}
 }
@@ -1785,7 +1785,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sp)),
 		   icsk->icsk_probes_out,
 		   sock_i_ino(sp),
-		   atomic_read(&sp->sk_refcnt), sp,
+		   refcount_read(&sp->sk_refcnt), sp,
 		   jiffies_to_clock_t(icsk->icsk_rto),
 		   jiffies_to_clock_t(icsk->icsk_ack.ato),
 		   (icsk->icsk_ack.quick << 1) | icsk->icsk_ack.pingpong,
@@ -1818,7 +1818,7 @@ static void get_timewait6_sock(struct seq_file *seq,
 		   dest->s6_addr32[2], dest->s6_addr32[3], destp,
 		   tw->tw_substate, 0, 0,
 		   3, jiffies_delta_to_clock_t(delta), 0, 0, 0, 0,
-		   atomic_read(&tw->tw_refcnt), tw);
+		   refcount_read(&tw->tw_refcnt), tw);
 }
 
 static int tcp6_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 4d5c4ee..d2f5307 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -311,7 +311,7 @@ struct sock *udp6_lib_lookup(struct net *net, const struct in6_addr *saddr, __be
 
 	sk =  __udp6_lib_lookup(net, saddr, sport, daddr, dport,
 				dif, &udp_table, NULL);
-	if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+	if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 		sk = NULL;
 	return sk;
 }
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index b578956..c8594de 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -70,7 +70,7 @@ int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 	int i = 0;
 
 	/* Allocate new secpath or COW existing one. */
-	if (!skb->sp || atomic_read(&skb->sp->refcnt) != 1) {
+	if (!skb->sp || refcount_read(&skb->sp->refcnt) != 1) {
 		struct sec_path *sp;
 
 		sp = secpath_dup(skb->sp);
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index d7b731a..4e438bc 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -59,7 +59,7 @@ struct xfrm6_tunnel_spi {
 	struct hlist_node	list_byspi;
 	xfrm_address_t		addr;
 	u32			spi;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct rcu_head		rcu_head;
 };
 
@@ -160,7 +160,7 @@ static u32 __xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr)
 
 	memcpy(&x6spi->addr, saddr, sizeof(x6spi->addr));
 	x6spi->spi = spi;
-	atomic_set(&x6spi->refcnt, 1);
+	refcount_set(&x6spi->refcnt, 1);
 
 	hlist_add_head_rcu(&x6spi->list_byspi, &xfrm6_tn->spi_byspi[index]);
 
@@ -178,7 +178,7 @@ __be32 xfrm6_tunnel_alloc_spi(struct net *net, xfrm_address_t *saddr)
 	spin_lock_bh(&xfrm6_tunnel_spi_lock);
 	x6spi = __xfrm6_tunnel_spi_lookup(net, saddr);
 	if (x6spi) {
-		atomic_inc(&x6spi->refcnt);
+		refcount_inc(&x6spi->refcnt);
 		spi = x6spi->spi;
 	} else
 		spi = __xfrm6_tunnel_alloc_spi(net, saddr);
@@ -207,7 +207,7 @@ static void xfrm6_tunnel_free_spi(struct net *net, xfrm_address_t *saddr)
 				  list_byaddr)
 	{
 		if (xfrm6_addr_equal(&x6spi->addr, saddr)) {
-			if (atomic_dec_and_test(&x6spi->refcnt)) {
+			if (refcount_dec_and_test(&x6spi->refcnt)) {
 				hlist_del_rcu(&x6spi->list_byaddr);
 				hlist_del_rcu(&x6spi->list_byspi);
 				call_rcu(&x6spi->rcu_head, x6spi_destroy_rcu);
diff --git a/net/ipx/af_ipx.c b/net/ipx/af_ipx.c
index 8a9219f..0675b4a 100644
--- a/net/ipx/af_ipx.c
+++ b/net/ipx/af_ipx.c
@@ -308,7 +308,7 @@ void ipxitf_down(struct ipx_interface *intrfc)
 
 static void __ipxitf_put(struct ipx_interface *intrfc)
 {
-	if (atomic_dec_and_test(&intrfc->refcnt))
+	if (refcount_dec_and_test(&intrfc->refcnt))
 		__ipxitf_down(intrfc);
 }
 
@@ -876,7 +876,7 @@ static struct ipx_interface *ipxitf_alloc(struct net_device *dev, __be32 netnum,
 		intrfc->if_ipx_offset 	= ipx_offset;
 		intrfc->if_sknum 	= IPX_MIN_EPHEMERAL_SOCKET;
 		INIT_HLIST_HEAD(&intrfc->if_sklist);
-		atomic_set(&intrfc->refcnt, 1);
+		refcount_set(&intrfc->refcnt, 1);
 		spin_lock_init(&intrfc->if_sklist_lock);
 	}
 
@@ -1105,7 +1105,7 @@ static struct ipx_interface *ipxitf_auto_create(struct net_device *dev,
 		memcpy((char *)&(intrfc->if_node[IPX_NODE_LEN-dev->addr_len]),
 			dev->dev_addr, dev->addr_len);
 		spin_lock_init(&intrfc->if_sklist_lock);
-		atomic_set(&intrfc->refcnt, 1);
+		refcount_set(&intrfc->refcnt, 1);
 		ipxitf_insert(intrfc);
 		dev_hold(dev);
 	}
diff --git a/net/ipx/ipx_proc.c b/net/ipx/ipx_proc.c
index c1d247e..7d75e4c 100644
--- a/net/ipx/ipx_proc.c
+++ b/net/ipx/ipx_proc.c
@@ -53,7 +53,7 @@ static int ipx_seq_interface_show(struct seq_file *seq, void *v)
 	seq_printf(seq, "%-11s", ipx_device_name(i));
 	seq_printf(seq, "%-9s", ipx_frame_name(i->if_dlink_type));
 #ifdef IPX_REFCNT_DEBUG
-	seq_printf(seq, "%6d", atomic_read(&i->refcnt));
+	seq_printf(seq, "%6d", refcount_read(&i->refcnt));
 #endif
 	seq_puts(seq, "\n");
 out:
diff --git a/net/ipx/ipx_route.c b/net/ipx/ipx_route.c
index 3e2a32a..b5d9144 100644
--- a/net/ipx/ipx_route.c
+++ b/net/ipx/ipx_route.c
@@ -59,7 +59,7 @@ int ipxrtr_add_route(__be32 network, struct ipx_interface *intrfc,
 		if (!rt)
 			goto out;
 
-		atomic_set(&rt->refcnt, 1);
+		refcount_set(&rt->refcnt, 1);
 		ipxrtr_hold(rt);
 		write_lock_bh(&ipx_routes_lock);
 		list_add(&rt->node, &ipx_routes);
diff --git a/net/kcm/kcmproc.c b/net/kcm/kcmproc.c
index bf75c92..c343ac6 100644
--- a/net/kcm/kcmproc.c
+++ b/net/kcm/kcmproc.c
@@ -162,7 +162,7 @@ static void kcm_format_psock(struct kcm_psock *psock, struct seq_file *seq,
 		   psock->sk->sk_receive_queue.qlen,
 		   atomic_read(&psock->sk->sk_rmem_alloc),
 		   psock->sk->sk_write_queue.qlen,
-		   atomic_read(&psock->sk->sk_wmem_alloc));
+		   refcount_read(&psock->sk->sk_wmem_alloc));
 
 	if (psock->done)
 		seq_puts(seq, "Done ");
diff --git a/net/key/af_key.c b/net/key/af_key.c
index c6252ed..b7b0d36 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -104,7 +104,7 @@ static void pfkey_sock_destruct(struct sock *sk)
 	}
 
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 
 	atomic_dec(&net_pfkey->socks_nr);
 }
@@ -194,11 +194,11 @@ static int pfkey_broadcast_one(struct sk_buff *skb, struct sk_buff **skb2,
 
 	sock_hold(sk);
 	if (*skb2 == NULL) {
-		if (atomic_read(&skb->users) != 1) {
+		if (refcount_read(&skb->users) != 1) {
 			*skb2 = skb_clone(skb, allocation);
 		} else {
 			*skb2 = skb;
-			atomic_inc(&skb->users);
+			refcount_inc(&skb->users);
 		}
 	}
 	if (*skb2 != NULL) {
@@ -2152,7 +2152,7 @@ static int pfkey_xfrm_policy2msg(struct sk_buff *skb, const struct xfrm_policy *
 	}
 
 	hdr->sadb_msg_len = size / sizeof(uint64_t);
-	hdr->sadb_msg_reserved = atomic_read(&xp->refcnt);
+	hdr->sadb_msg_reserved = refcount_read(&xp->refcnt);
 
 	return 0;
 }
@@ -3711,7 +3711,7 @@ static int pfkey_seq_show(struct seq_file *f, void *v)
 	else
 		seq_printf(f, "%pK %-6d %-6u %-6u %-6u %-6lu\n",
 			       s,
-			       atomic_read(&s->sk_refcnt),
+			       refcount_read(&s->sk_refcnt),
 			       sk_rmem_alloc_get(s),
 			       sk_wmem_alloc_get(s),
 			       from_kuid_munged(seq_user_ns(f), sock_i_uid(s)),
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 85948c6..e273741 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -132,12 +132,12 @@ static inline struct l2tp_net *l2tp_pernet(struct net *net)
  */
 static inline void l2tp_tunnel_inc_refcount_1(struct l2tp_tunnel *tunnel)
 {
-	atomic_inc(&tunnel->ref_count);
+	refcount_inc(&tunnel->ref_count);
 }
 
 static inline void l2tp_tunnel_dec_refcount_1(struct l2tp_tunnel *tunnel)
 {
-	if (atomic_dec_and_test(&tunnel->ref_count))
+	if (refcount_dec_and_test(&tunnel->ref_count))
 		l2tp_tunnel_free(tunnel);
 }
 #ifdef L2TP_REFCNT_DEBUG
@@ -145,14 +145,14 @@ static inline void l2tp_tunnel_dec_refcount_1(struct l2tp_tunnel *tunnel)
 do {									\
 	pr_debug("l2tp_tunnel_inc_refcount: %s:%d %s: cnt=%d\n",	\
 		 __func__, __LINE__, (_t)->name,			\
-		 atomic_read(&_t->ref_count));				\
+		 refcount_read(&_t->ref_count));			\
 	l2tp_tunnel_inc_refcount_1(_t);					\
 } while (0)
 #define l2tp_tunnel_dec_refcount(_t)					\
 do {									\
 	pr_debug("l2tp_tunnel_dec_refcount: %s:%d %s: cnt=%d\n",	\
 		 __func__, __LINE__, (_t)->name,			\
-		 atomic_read(&_t->ref_count));				\
+		 refcount_read(&_t->ref_count));			\
 	l2tp_tunnel_dec_refcount_1(_t);					\
 } while (0)
 #else
@@ -1303,7 +1303,7 @@ static void l2tp_udp_encap_destroy(struct sock *sk)
  */
 static void l2tp_tunnel_free(struct l2tp_tunnel *tunnel)
 {
-	BUG_ON(atomic_read(&tunnel->ref_count) != 0);
+	BUG_ON(refcount_read(&tunnel->ref_count) != 0);
 	BUG_ON(tunnel->sock != NULL);
 	l2tp_info(tunnel, L2TP_MSG_CONTROL, "%s: free...\n", tunnel->name);
 	kfree_rcu(tunnel, rcu);
@@ -1654,7 +1654,7 @@ void l2tp_session_free(struct l2tp_session *session)
 {
 	struct l2tp_tunnel *tunnel = session->tunnel;
 
-	BUG_ON(atomic_read(&session->ref_count) != 0);
+	BUG_ON(refcount_read(&session->ref_count) != 0);
 
 	if (tunnel) {
 		BUG_ON(tunnel->magic != L2TP_TUNNEL_MAGIC);
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index 8f560f7..f170e97 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -7,6 +7,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/refcount.h>
 
 #ifndef _L2TP_CORE_H_
 #define _L2TP_CORE_H_
@@ -98,7 +99,7 @@ struct l2tp_session {
 	int			nr_oos_count;	/* For OOS recovery */
 	int			nr_oos_count_max;
 	struct hlist_node	hlist;		/* Hash list node */
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 
 	char			name[32];	/* for logging */
 	char			ifname[IFNAMSIZ];
@@ -177,7 +178,7 @@ struct l2tp_tunnel {
 	struct list_head	list;		/* Keep a list of all tunnels */
 	struct net		*l2tp_net;	/* the net we belong to */
 
-	atomic_t		ref_count;
+	refcount_t		ref_count;
 #ifdef CONFIG_DEBUG_FS
 	void (*show)(struct seq_file *m, void *arg);
 #endif
@@ -269,12 +270,12 @@ void l2tp_nl_unregister_ops(enum l2tp_pwtype pw_type);
  */
 static inline void l2tp_session_inc_refcount_1(struct l2tp_session *session)
 {
-	atomic_inc(&session->ref_count);
+	refcount_inc(&session->ref_count);
 }
 
 static inline void l2tp_session_dec_refcount_1(struct l2tp_session *session)
 {
-	if (atomic_dec_and_test(&session->ref_count))
+	if (refcount_dec_and_test(&session->ref_count))
 		l2tp_session_free(session);
 }
 
@@ -283,14 +284,14 @@ static inline void l2tp_session_dec_refcount_1(struct l2tp_session *session)
 do {									\
 	pr_debug("l2tp_session_inc_refcount: %s:%d %s: cnt=%d\n",	\
 		 __func__, __LINE__, (_s)->name,			\
-		 atomic_read(&_s->ref_count));				\
+		 refcount_read(&_s->ref_count));			\
 	l2tp_session_inc_refcount_1(_s);				\
 } while (0)
 #define l2tp_session_dec_refcount(_s)					\
 do {									\
 	pr_debug("l2tp_session_dec_refcount: %s:%d %s: cnt=%d\n",	\
 		 __func__, __LINE__, (_s)->name,			\
-		 atomic_read(&_s->ref_count));				\
+		 refcount_read(&_s->ref_count));			\
 	l2tp_session_dec_refcount_1(_s);				\
 } while (0)
 #else
diff --git a/net/l2tp/l2tp_debugfs.c b/net/l2tp/l2tp_debugfs.c
index 2d6760a..812ae61 100644
--- a/net/l2tp/l2tp_debugfs.c
+++ b/net/l2tp/l2tp_debugfs.c
@@ -144,8 +144,8 @@ static void l2tp_dfs_seq_tunnel_show(struct seq_file *m, void *v)
 		   tunnel->encap == L2TP_ENCAPTYPE_IP ? "IP" :
 		   "");
 	seq_printf(m, " %d sessions, refcnt %d/%d\n", session_count,
-		   tunnel->sock ? atomic_read(&tunnel->sock->sk_refcnt) : 0,
-		   atomic_read(&tunnel->ref_count));
+		   tunnel->sock ? refcount_read(&tunnel->sock->sk_refcnt) : 0,
+		   refcount_read(&tunnel->ref_count));
 
 	seq_printf(m, " %08x rx %ld/%ld/%ld rx %ld/%ld/%ld\n",
 		   tunnel->debug,
@@ -171,7 +171,7 @@ static void l2tp_dfs_seq_session_show(struct seq_file *m, void *v)
 		   "");
 	if (session->send_seq || session->recv_seq)
 		seq_printf(m, "   nr %hu, ns %hu\n", session->nr, session->ns);
-	seq_printf(m, "   refcnt %d\n", atomic_read(&session->ref_count));
+	seq_printf(m, "   refcnt %d\n", refcount_read(&session->ref_count));
 	seq_printf(m, "   config %d/%d/%c/%c/%s/%s %08x %u\n",
 		   session->mtu, session->mru,
 		   session->recv_seq ? 'R' : '-',
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 36cc56f..eb1a85a 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1607,7 +1607,7 @@ static void pppol2tp_seq_tunnel_show(struct seq_file *m, void *v)
 	seq_printf(m, "\nTUNNEL '%s', %c %d\n",
 		   tunnel->name,
 		   (tunnel == tunnel->sock->sk_user_data) ? 'Y' : 'N',
-		   atomic_read(&tunnel->ref_count) - 1);
+		   refcount_read(&tunnel->ref_count) - 1);
 	seq_printf(m, " %08x %ld/%ld/%ld %ld/%ld/%ld\n",
 		   tunnel->debug,
 		   atomic_long_read(&tunnel->stats.tx_packets),
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index b50b64a..e15314e 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -54,12 +54,12 @@ static void lapb_free_cb(struct lapb_cb *lapb)
 
 static __inline__ void lapb_hold(struct lapb_cb *lapb)
 {
-	atomic_inc(&lapb->refcnt);
+	refcount_inc(&lapb->refcnt);
 }
 
 static __inline__ void lapb_put(struct lapb_cb *lapb)
 {
-	if (atomic_dec_and_test(&lapb->refcnt))
+	if (refcount_dec_and_test(&lapb->refcnt))
 		lapb_free_cb(lapb);
 }
 
@@ -136,7 +136,7 @@ static struct lapb_cb *lapb_create_cb(void)
 	lapb->mode    = LAPB_DEFAULT_MODE;
 	lapb->window  = LAPB_DEFAULT_WINDOW;
 	lapb->state   = LAPB_STATE_0;
-	atomic_set(&lapb->refcnt, 1);
+	refcount_set(&lapb->refcnt, 1);
 out:
 	return lapb;
 }
diff --git a/net/llc/llc_conn.c b/net/llc/llc_conn.c
index 3e821da..9227bdf 100644
--- a/net/llc/llc_conn.c
+++ b/net/llc/llc_conn.c
@@ -507,7 +507,7 @@ static struct sock *__llc_lookup_established(struct llc_sap *sap,
 	sk_nulls_for_each_rcu(rc, node, laddr_hb) {
 		if (llc_estab_match(sap, daddr, laddr, rc)) {
 			/* Extra checks required by SLAB_DESTROY_BY_RCU */
-			if (unlikely(!atomic_inc_not_zero(&rc->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&rc->sk_refcnt)))
 				goto again;
 			if (unlikely(llc_sk(rc)->sap != sap ||
 				     !llc_estab_match(sap, daddr, laddr, rc))) {
@@ -566,7 +566,7 @@ static struct sock *__llc_lookup_listener(struct llc_sap *sap,
 	sk_nulls_for_each_rcu(rc, node, laddr_hb) {
 		if (llc_listener_match(sap, laddr, rc)) {
 			/* Extra checks required by SLAB_DESTROY_BY_RCU */
-			if (unlikely(!atomic_inc_not_zero(&rc->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&rc->sk_refcnt)))
 				goto again;
 			if (unlikely(llc_sk(rc)->sap != sap ||
 				     !llc_listener_match(sap, laddr, rc))) {
@@ -970,9 +970,9 @@ void llc_sk_free(struct sock *sk)
 	skb_queue_purge(&sk->sk_write_queue);
 	skb_queue_purge(&llc->pdu_unack_q);
 #ifdef LLC_REFCNT_DEBUG
-	if (atomic_read(&sk->sk_refcnt) != 1) {
+	if (refcount_read(&sk->sk_refcnt) != 1) {
 		printk(KERN_DEBUG "Destruction of LLC sock %p delayed in %s, cnt=%d\n",
-			sk, __func__, atomic_read(&sk->sk_refcnt));
+			sk, __func__, refcount_read(&sk->sk_refcnt));
 		printk(KERN_DEBUG "%d LLC sockets are still alive\n",
 			atomic_read(&llc_sock_nr));
 	} else {
diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index 842851c..8904126 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -41,7 +41,7 @@ static struct llc_sap *llc_sap_alloc(void)
 		spin_lock_init(&sap->sk_lock);
 		for (i = 0; i < LLC_SK_LADDR_HASH_ENTRIES; i++)
 			INIT_HLIST_NULLS_HEAD(&sap->sk_laddr_hash[i], i);
-		atomic_set(&sap->refcnt, 1);
+		refcount_set(&sap->refcnt, 1);
 	}
 	return sap;
 }
diff --git a/net/llc/llc_sap.c b/net/llc/llc_sap.c
index d0e1e80..0471114 100644
--- a/net/llc/llc_sap.c
+++ b/net/llc/llc_sap.c
@@ -326,7 +326,7 @@ static struct sock *llc_lookup_dgram(struct llc_sap *sap,
 	sk_nulls_for_each_rcu(rc, node, laddr_hb) {
 		if (llc_dgram_match(sap, laddr, rc)) {
 			/* Extra checks required by SLAB_DESTROY_BY_RCU */
-			if (unlikely(!atomic_inc_not_zero(&rc->sk_refcnt)))
+			if (unlikely(!refcount_inc_not_zero(&rc->sk_refcnt)))
 				goto again;
 			if (unlikely(llc_sk(rc)->sap != sap ||
 				     !llc_dgram_match(sap, laddr, rc))) {
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 1b05d4a..b4af509 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -11,6 +11,7 @@
 #include <linux/rcupdate.h>
 #include <linux/jhash.h>
 #include <linux/types.h>
+#include <linux/refcount.h>
 #include <linux/netfilter/ipset/ip_set_timeout.h>
 
 #define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
@@ -78,8 +79,8 @@ struct hbucket {
 
 /* The hash table: the table size stored here in order to make resizing easy */
 struct htable {
-	atomic_t ref;		/* References for resizing */
-	atomic_t uref;		/* References for dumping */
+	refcount_t ref;		/* References for resizing */
+	refcount_t uref;		/* References for dumping */
 	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	struct hbucket __rcu *bucket[0]; /* hashtable buckets */
 };
@@ -591,8 +592,8 @@ mtype_resize(struct ip_set *set, bool retried)
 	spin_lock_bh(&set->lock);
 	orig = __ipset_dereference_protected(h->table, 1);
 	/* There can't be another parallel resizing, but dumping is possible */
-	atomic_set(&orig->ref, 1);
-	atomic_inc(&orig->uref);
+	refcount_set(&orig->ref, 1);
+	refcount_inc(&orig->uref);
 	extsize = 0;
 	pr_debug("attempt to resize set %s from %u to %u, t %p\n",
 		 set->name, orig->htable_bits, htable_bits, orig);
@@ -668,7 +669,7 @@ mtype_resize(struct ip_set *set, bool retried)
 	pr_debug("set %s resized from %u (%p) to %u (%p)\n", set->name,
 		 orig->htable_bits, orig, t->htable_bits, t);
 	/* If there's nobody else dumping the table, destroy it */
-	if (atomic_dec_and_test(&orig->uref)) {
+	if (refcount_dec_and_test(&orig->uref)) {
 		pr_debug("Table destroy by resize %p\n", orig);
 		mtype_ahash_destroy(set, orig, false);
 	}
@@ -680,8 +681,8 @@ mtype_resize(struct ip_set *set, bool retried)
 	return ret;
 
 cleanup:
-	atomic_set(&orig->ref, 0);
-	atomic_dec(&orig->uref);
+	refcount_set(&orig->ref, 0);
+	refcount_dec(&orig->uref);
 	spin_unlock_bh(&set->lock);
 	mtype_ahash_destroy(set, t, false);
 	if (ret == -EAGAIN)
@@ -1092,12 +1093,12 @@ mtype_uref(struct ip_set *set, struct netlink_callback *cb, bool start)
 	if (start) {
 		rcu_read_lock_bh();
 		t = rcu_dereference_bh_nfnl(h->table);
-		atomic_inc(&t->uref);
+		refcount_inc(&t->uref);
 		cb->args[IPSET_CB_PRIVATE] = (unsigned long)t;
 		rcu_read_unlock_bh();
 	} else if (cb->args[IPSET_CB_PRIVATE]) {
 		t = (struct htable *)cb->args[IPSET_CB_PRIVATE];
-		if (atomic_dec_and_test(&t->uref) && atomic_read(&t->ref)) {
+		if (refcount_dec_and_test(&t->uref) && refcount_read(&t->ref)) {
 			/* Resizing didn't destroy the hash table */
 			pr_debug("Table destroy by dump: %p\n", t);
 			mtype_ahash_destroy(set, t, false);
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 096a451..04e78d4 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -181,7 +181,7 @@ static inline int ip_vs_conn_hash(struct ip_vs_conn *cp)
 
 	if (!(cp->flags & IP_VS_CONN_F_HASHED)) {
 		cp->flags |= IP_VS_CONN_F_HASHED;
-		atomic_inc(&cp->refcnt);
+		refcount_inc(&cp->refcnt);
 		hlist_add_head_rcu(&cp->c_list, &ip_vs_conn_tab[hash]);
 		ret = 1;
 	} else {
@@ -215,7 +215,7 @@ static inline int ip_vs_conn_unhash(struct ip_vs_conn *cp)
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
 		hlist_del_rcu(&cp->c_list);
 		cp->flags &= ~IP_VS_CONN_F_HASHED;
-		atomic_dec(&cp->refcnt);
+		refcount_dec(&cp->refcnt);
 		ret = 1;
 	} else
 		ret = 0;
@@ -242,13 +242,13 @@ static inline bool ip_vs_conn_unlink(struct ip_vs_conn *cp)
 	if (cp->flags & IP_VS_CONN_F_HASHED) {
 		ret = false;
 		/* Decrease refcnt and unlink conn only if we are last user */
-		if (atomic_cmpxchg(&cp->refcnt, 1, 0) == 1) {
+		if (refcount_dec_if_one(&cp->refcnt)) {
 			hlist_del_rcu(&cp->c_list);
 			cp->flags &= ~IP_VS_CONN_F_HASHED;
 			ret = true;
 		}
 	} else
-		ret = atomic_read(&cp->refcnt) ? false : true;
+		ret = refcount_read(&cp->refcnt) ? false : true;
 
 	spin_unlock(&cp->lock);
 	ct_write_unlock_bh(hash);
@@ -475,7 +475,7 @@ static void __ip_vs_conn_put_timer(struct ip_vs_conn *cp)
 void ip_vs_conn_put(struct ip_vs_conn *cp)
 {
 	if ((cp->flags & IP_VS_CONN_F_ONE_PACKET) &&
-	    (atomic_read(&cp->refcnt) == 1) &&
+	    (refcount_read(&cp->refcnt) == 1) &&
 	    !timer_pending(&cp->timer))
 		/* expire connection immediately */
 		__ip_vs_conn_put_notimer(cp);
@@ -617,8 +617,8 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
 		      ip_vs_fwd_tag(cp), cp->state,
-		      cp->flags, atomic_read(&cp->refcnt),
-		      atomic_read(&dest->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt),
+		      refcount_read(&dest->refcnt));
 
 	/* Update the connection counters */
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
@@ -714,8 +714,8 @@ static inline void ip_vs_unbind_dest(struct ip_vs_conn *cp)
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
 		      ip_vs_fwd_tag(cp), cp->state,
-		      cp->flags, atomic_read(&cp->refcnt),
-		      atomic_read(&dest->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt),
+		      refcount_read(&dest->refcnt));
 
 	/* Update the connection counters */
 	if (!(cp->flags & IP_VS_CONN_F_TEMPLATE)) {
@@ -863,10 +863,10 @@ static void ip_vs_conn_expire(unsigned long data)
 
   expire_later:
 	IP_VS_DBG(7, "delayed: conn->refcnt=%d conn->n_control=%d\n",
-		  atomic_read(&cp->refcnt),
+		  refcount_read(&cp->refcnt),
 		  atomic_read(&cp->n_control));
 
-	atomic_inc(&cp->refcnt);
+	refcount_inc(&cp->refcnt);
 	cp->timeout = 60*HZ;
 
 	if (ipvs->sync_state & IP_VS_STATE_MASTER)
@@ -941,7 +941,7 @@ ip_vs_conn_new(const struct ip_vs_conn_param *p, int dest_af,
 	 * it in the table, so that other thread run ip_vs_random_dropentry
 	 * but cannot drop this entry.
 	 */
-	atomic_set(&cp->refcnt, 1);
+	refcount_set(&cp->refcnt, 1);
 
 	cp->control = NULL;
 	atomic_set(&cp->n_control, 0);
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index db40050..a3e1b9c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -542,7 +542,7 @@ ip_vs_schedule(struct ip_vs_service *svc, struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->daf, &cp->daddr), ntohs(cp->dport),
-		      cp->flags, atomic_read(&cp->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt));
 
 	ip_vs_conn_stats(cp, svc);
 	return cp;
@@ -1193,7 +1193,7 @@ struct ip_vs_conn *ip_vs_new_conn_out(struct ip_vs_service *svc,
 		      IP_VS_DBG_ADDR(cp->af, &cp->caddr), ntohs(cp->cport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->vaddr), ntohs(cp->vport),
 		      IP_VS_DBG_ADDR(cp->af, &cp->daddr), ntohs(cp->dport),
-		      cp->flags, atomic_read(&cp->refcnt));
+		      cp->flags, refcount_read(&cp->refcnt));
 	LeaveFunction(12);
 	return cp;
 }
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 55e0169..3e6bb33 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -322,7 +322,7 @@ static int ip_vs_svc_hash(struct ip_vs_service *svc)
 
 	svc->flags |= IP_VS_SVC_F_HASHED;
 	/* increase its refcnt because it is referenced by the svc table */
-	atomic_inc(&svc->refcnt);
+	refcount_inc(&svc->refcnt);
 	return 1;
 }
 
@@ -348,7 +348,7 @@ static int ip_vs_svc_unhash(struct ip_vs_service *svc)
 	}
 
 	svc->flags &= ~IP_VS_SVC_F_HASHED;
-	atomic_dec(&svc->refcnt);
+	refcount_dec(&svc->refcnt);
 	return 1;
 }
 
@@ -458,7 +458,7 @@ ip_vs_service_find(struct netns_ipvs *ipvs, int af, __u32 fwmark, __u16 protocol
 static inline void
 __ip_vs_bind_svc(struct ip_vs_dest *dest, struct ip_vs_service *svc)
 {
-	atomic_inc(&svc->refcnt);
+	refcount_inc(&svc->refcnt);
 	rcu_assign_pointer(dest->svc, svc);
 }
 
@@ -478,7 +478,7 @@ static void ip_vs_service_rcu_free(struct rcu_head *head)
 
 static void __ip_vs_svc_put(struct ip_vs_service *svc, bool do_delay)
 {
-	if (atomic_dec_and_test(&svc->refcnt)) {
+	if (refcount_dec_and_test(&svc->refcnt)) {
 		IP_VS_DBG_BUF(3, "Removing service %u/%s:%u\n",
 			      svc->fwmark,
 			      IP_VS_DBG_ADDR(svc->af, &svc->addr),
@@ -700,7 +700,7 @@ ip_vs_trash_get_dest(struct ip_vs_service *svc, int dest_af,
 			      dest->vfwmark,
 			      IP_VS_DBG_ADDR(dest->af, &dest->addr),
 			      ntohs(dest->port),
-			      atomic_read(&dest->refcnt));
+			      refcount_read(&dest->refcnt));
 		if (dest->af == dest_af &&
 		    ip_vs_addr_equal(dest_af, &dest->addr, daddr) &&
 		    dest->port == dport &&
@@ -936,7 +936,7 @@ ip_vs_new_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest,
 	atomic_set(&dest->activeconns, 0);
 	atomic_set(&dest->inactconns, 0);
 	atomic_set(&dest->persistconns, 0);
-	atomic_set(&dest->refcnt, 1);
+	refcount_set(&dest->refcnt, 1);
 
 	INIT_HLIST_NODE(&dest->d_list);
 	spin_lock_init(&dest->dst_lock);
@@ -1000,7 +1000,7 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 		IP_VS_DBG_BUF(3, "Get destination %s:%u from trash, "
 			      "dest->refcnt=%d, service %u/%s:%u\n",
 			      IP_VS_DBG_ADDR(udest->af, &daddr), ntohs(dport),
-			      atomic_read(&dest->refcnt),
+			      refcount_read(&dest->refcnt),
 			      dest->vfwmark,
 			      IP_VS_DBG_ADDR(svc->af, &dest->vaddr),
 			      ntohs(dest->vport));
@@ -1076,7 +1076,7 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	spin_lock_bh(&ipvs->dest_trash_lock);
 	IP_VS_DBG_BUF(3, "Moving dest %s:%u into trash, dest->refcnt=%d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
-		      atomic_read(&dest->refcnt));
+		      refcount_read(&dest->refcnt));
 	if (list_empty(&ipvs->dest_trash) && !cleanup)
 		mod_timer(&ipvs->dest_trash_timer,
 			  jiffies + (IP_VS_DEST_TRASH_PERIOD >> 1));
@@ -1160,7 +1160,7 @@ static void ip_vs_dest_trash_expire(unsigned long data)
 
 	spin_lock(&ipvs->dest_trash_lock);
 	list_for_each_entry_safe(dest, next, &ipvs->dest_trash, t_list) {
-		if (atomic_read(&dest->refcnt) > 0)
+		if (refcount_read(&dest->refcnt) > 0)
 			continue;
 		if (dest->idle_start) {
 			if (time_before(now, dest->idle_start +
@@ -1250,7 +1250,7 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 
 
 	/* I'm the first user of the service */
-	atomic_set(&svc->refcnt, 0);
+	refcount_set(&svc->refcnt, 0);
 
 	svc->af = u->af;
 	svc->protocol = u->protocol;
@@ -1465,7 +1465,7 @@ static void __ip_vs_del_service(struct ip_vs_service *svc, bool cleanup)
 static void ip_vs_unlink_service(struct ip_vs_service *svc, bool cleanup)
 {
 	/* Hold svc to avoid double release from dest_trash */
-	atomic_inc(&svc->refcnt);
+	refcount_inc(&svc->refcnt);
 	/*
 	 * Unhash it from the service table
 	 */
@@ -1548,7 +1548,7 @@ ip_vs_forget_dev(struct ip_vs_dest *dest, struct net_device *dev)
 			      dev->name,
 			      IP_VS_DBG_ADDR(dest->af, &dest->addr),
 			      ntohs(dest->port),
-			      atomic_read(&dest->refcnt));
+			      refcount_read(&dest->refcnt));
 		__ip_vs_dst_cache_reset(dest);
 	}
 	spin_unlock_bh(&dest->dst_lock);
diff --git a/net/netfilter/ipvs/ip_vs_dh.c b/net/netfilter/ipvs/ip_vs_dh.c
index 6be5c53..6e31531 100644
--- a/net/netfilter/ipvs/ip_vs_dh.c
+++ b/net/netfilter/ipvs/ip_vs_dh.c
@@ -247,7 +247,7 @@ ip_vs_dh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_dh_scheduler =
 {
 	.name =			"dh",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_dh_scheduler.n_list),
 	.init_service =		ip_vs_dh_init_svc,
diff --git a/net/netfilter/ipvs/ip_vs_fo.c b/net/netfilter/ipvs/ip_vs_fo.c
index e09874d..211078e 100644
--- a/net/netfilter/ipvs/ip_vs_fo.c
+++ b/net/netfilter/ipvs/ip_vs_fo.c
@@ -57,7 +57,7 @@ ip_vs_fo_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 static struct ip_vs_scheduler ip_vs_fo_scheduler = {
 	.name =			"fo",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_fo_scheduler.n_list),
 	.schedule =		ip_vs_fo_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index cccf4d6..71898d8 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -448,7 +448,7 @@ __ip_vs_lblc_schedule(struct ip_vs_service *svc)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
@@ -537,7 +537,7 @@ ip_vs_lblc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
  */
 static struct ip_vs_scheduler ip_vs_lblc_scheduler = {
 	.name =			"lblc",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_lblc_scheduler.n_list),
 	.init_service =		ip_vs_lblc_init_svc,
diff --git a/net/netfilter/ipvs/ip_vs_lblcr.c b/net/netfilter/ipvs/ip_vs_lblcr.c
index 796d70e..64fb222 100644
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -204,7 +204,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 	return least;
 }
@@ -249,7 +249,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_max(struct ip_vs_dest_set *set)
 		      __func__,
 		      IP_VS_DBG_ADDR(most->af, &most->addr), ntohs(most->port),
 		      atomic_read(&most->activeconns),
-		      atomic_read(&most->refcnt),
+		      refcount_read(&most->refcnt),
 		      atomic_read(&most->weight), moh);
 	return most;
 }
@@ -612,7 +612,7 @@ __ip_vs_lblcr_schedule(struct ip_vs_service *svc)
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
@@ -723,7 +723,7 @@ ip_vs_lblcr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_lblcr_scheduler =
 {
 	.name =			"lblcr",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_lblcr_scheduler.n_list),
 	.init_service =		ip_vs_lblcr_init_svc,
diff --git a/net/netfilter/ipvs/ip_vs_lc.c b/net/netfilter/ipvs/ip_vs_lc.c
index 19a0769..5fb3bb9 100644
--- a/net/netfilter/ipvs/ip_vs_lc.c
+++ b/net/netfilter/ipvs/ip_vs_lc.c
@@ -70,7 +70,7 @@ ip_vs_lc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 static struct ip_vs_scheduler ip_vs_lc_scheduler = {
 	.name =			"lc",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_lc_scheduler.n_list),
 	.schedule =		ip_vs_lc_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_nq.c b/net/netfilter/ipvs/ip_vs_nq.c
index a8b6340..9ec9cd0 100644
--- a/net/netfilter/ipvs/ip_vs_nq.c
+++ b/net/netfilter/ipvs/ip_vs_nq.c
@@ -110,7 +110,7 @@ ip_vs_nq_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
@@ -120,7 +120,7 @@ ip_vs_nq_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_nq_scheduler =
 {
 	.name =			"nq",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_nq_scheduler.n_list),
 	.schedule =		ip_vs_nq_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_ovf.c b/net/netfilter/ipvs/ip_vs_ovf.c
index f7d62c3..fbcd826 100644
--- a/net/netfilter/ipvs/ip_vs_ovf.c
+++ b/net/netfilter/ipvs/ip_vs_ovf.c
@@ -64,7 +64,7 @@ ip_vs_ovf_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 static struct ip_vs_scheduler ip_vs_ovf_scheduler = {
 	.name =			"ovf",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_ovf_scheduler.n_list),
 	.schedule =		ip_vs_ovf_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_pe_sip.c b/net/netfilter/ipvs/ip_vs_pe_sip.c
index d07ef9e..364156b 100644
--- a/net/netfilter/ipvs/ip_vs_pe_sip.c
+++ b/net/netfilter/ipvs/ip_vs_pe_sip.c
@@ -160,7 +160,7 @@ ip_vs_sip_conn_out(struct ip_vs_service *svc,
 static struct ip_vs_pe ip_vs_sip_pe =
 {
 	.name =			"sip",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_sip_pe.n_list),
 	.fill_param =		ip_vs_sip_fill_param,
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index d952d67..56f8e4b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -447,7 +447,7 @@ set_sctp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 				ntohs(cp->cport),
 				sctp_state_name(cp->state),
 				sctp_state_name(next_state),
-				atomic_read(&cp->refcnt));
+				refcount_read(&cp->refcnt));
 		if (dest) {
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
 				(next_state != IP_VS_SCTP_S_ESTABLISHED)) {
diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index 5117bcb..12dc8d5 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -557,7 +557,7 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 			      ntohs(cp->cport),
 			      tcp_state_name(cp->state),
 			      tcp_state_name(new_state),
-			      atomic_read(&cp->refcnt));
+			      refcount_read(&cp->refcnt));
 
 		if (dest) {
 			if (!(cp->flags & IP_VS_CONN_F_INACTIVE) &&
diff --git a/net/netfilter/ipvs/ip_vs_rr.c b/net/netfilter/ipvs/ip_vs_rr.c
index 58bacfc..7d8f6cb 100644
--- a/net/netfilter/ipvs/ip_vs_rr.c
+++ b/net/netfilter/ipvs/ip_vs_rr.c
@@ -97,7 +97,7 @@ ip_vs_rr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      "activeconns %d refcnt %d weight %d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
 		      atomic_read(&dest->activeconns),
-		      atomic_read(&dest->refcnt), atomic_read(&dest->weight));
+		      refcount_read(&dest->refcnt), atomic_read(&dest->weight));
 
 	return dest;
 }
@@ -105,7 +105,7 @@ ip_vs_rr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 static struct ip_vs_scheduler ip_vs_rr_scheduler = {
 	.name =			"rr",			/* name */
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_rr_scheduler.n_list),
 	.init_service =		ip_vs_rr_init_svc,
diff --git a/net/netfilter/ipvs/ip_vs_sed.c b/net/netfilter/ipvs/ip_vs_sed.c
index f8e2d00..9a1bdc0 100644
--- a/net/netfilter/ipvs/ip_vs_sed.c
+++ b/net/netfilter/ipvs/ip_vs_sed.c
@@ -111,7 +111,7 @@ ip_vs_sed_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
@@ -121,7 +121,7 @@ ip_vs_sed_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_sed_scheduler =
 {
 	.name =			"sed",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_sed_scheduler.n_list),
 	.schedule =		ip_vs_sed_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_sh.c b/net/netfilter/ipvs/ip_vs_sh.c
index 1e373a5..b7330cf 100644
--- a/net/netfilter/ipvs/ip_vs_sh.c
+++ b/net/netfilter/ipvs/ip_vs_sh.c
@@ -352,7 +352,7 @@ ip_vs_sh_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_sh_scheduler =
 {
 	.name =			"sh",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list	 =		LIST_HEAD_INIT(ip_vs_sh_scheduler.n_list),
 	.init_service =		ip_vs_sh_init_svc,
diff --git a/net/netfilter/ipvs/ip_vs_wlc.c b/net/netfilter/ipvs/ip_vs_wlc.c
index 6b366fd..3c19dac 100644
--- a/net/netfilter/ipvs/ip_vs_wlc.c
+++ b/net/netfilter/ipvs/ip_vs_wlc.c
@@ -83,7 +83,7 @@ ip_vs_wlc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      IP_VS_DBG_ADDR(least->af, &least->addr),
 		      ntohs(least->port),
 		      atomic_read(&least->activeconns),
-		      atomic_read(&least->refcnt),
+		      refcount_read(&least->refcnt),
 		      atomic_read(&least->weight), loh);
 
 	return least;
@@ -93,7 +93,7 @@ ip_vs_wlc_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 static struct ip_vs_scheduler ip_vs_wlc_scheduler =
 {
 	.name =			"wlc",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_wlc_scheduler.n_list),
 	.schedule =		ip_vs_wlc_schedule,
diff --git a/net/netfilter/ipvs/ip_vs_wrr.c b/net/netfilter/ipvs/ip_vs_wrr.c
index 17e6d44..0704af3 100644
--- a/net/netfilter/ipvs/ip_vs_wrr.c
+++ b/net/netfilter/ipvs/ip_vs_wrr.c
@@ -218,7 +218,7 @@ ip_vs_wrr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 		      "activeconns %d refcnt %d weight %d\n",
 		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port),
 		      atomic_read(&dest->activeconns),
-		      atomic_read(&dest->refcnt),
+		      refcount_read(&dest->refcnt),
 		      atomic_read(&dest->weight));
 	mark->cl = dest;
 
@@ -243,7 +243,7 @@ ip_vs_wrr_schedule(struct ip_vs_service *svc, const struct sk_buff *skb,
 
 static struct ip_vs_scheduler ip_vs_wrr_scheduler = {
 	.name =			"wrr",
-	.refcnt =		ATOMIC_INIT(0),
+	.refcnt =		REFCOUNT_INIT(0),
 	.module =		THIS_MODULE,
 	.n_list =		LIST_HEAD_INIT(ip_vs_wrr_scheduler.n_list),
 	.init_service =		ip_vs_wrr_init_svc,
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 3a073cd..04d5c7ec 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -364,7 +364,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	atomic_set(&tmpl->ct_general.use, 0);
+	refcount_set(&tmpl->ct_general.use, 0);
 
 	return tmpl;
 }
@@ -385,7 +385,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	struct nf_conntrack_l4proto *l4proto;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
-	NF_CT_ASSERT(atomic_read(&nfct->use) == 0);
+	NF_CT_ASSERT(refcount_read(&nfct->use) == 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -490,7 +490,7 @@ nf_ct_key_equal(struct nf_conntrack_tuple_hash *h,
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -559,7 +559,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 	if (h) {
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (unlikely(nf_ct_is_dying(ct) ||
-			     !atomic_inc_not_zero(&ct->ct_general.use)))
+			     !refcount_inc_not_zero(&ct->ct_general.use)))
 			h = NULL;
 		else {
 			if (unlikely(!nf_ct_key_equal(h, tuple, zone, net))) {
@@ -626,7 +626,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	atomic_set(&ct->ct_general.use, 2);
+	refcount_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -685,7 +685,7 @@ static int nf_ct_resolve_clash(struct net *net, struct sk_buff *skb,
 	if (l4proto->allow_clash &&
 	    !nfct_nat(ct) &&
 	    !nf_ct_is_dying(ct) &&
-	    atomic_inc_not_zero(&ct->ct_general.use)) {
+	    refcount_inc_not_zero(&ct->ct_general.use)) {
 		nf_ct_acct_merge(ct, ctinfo, (struct nf_conn *)skb->nfct);
 		nf_conntrack_put(skb->nfct);
 		/* Assign conntrack already in hashes to this skbuff. Don't
@@ -777,7 +777,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	   setting time, otherwise we'd get timer wrap in
 	   weird delay cases. */
 	ct->timeout += nfct_time_stamp;
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
@@ -891,7 +891,7 @@ static unsigned int early_drop_list(struct net *net,
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!atomic_inc_not_zero(&tmp->ct_general.use))
+		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1075,7 +1075,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	atomic_set(&ct->ct_general.use, 0);
+	refcount_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&net->ct.count);
@@ -1099,7 +1099,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_DESTROY_BY_RCU
 	 */
-	NF_CT_ASSERT(atomic_read(&ct->ct_general.use) == 0);
+	NF_CT_ASSERT(refcount_read(&ct->ct_general.use) == 0);
 
 	nf_ct_ext_destroy(ct);
 	nf_ct_ext_free(ct);
@@ -1573,7 +1573,7 @@ get_next_corpse(struct net *net, int (*iter)(struct nf_conn *i, void *data),
 	}
 	return NULL;
 found:
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
@@ -1623,7 +1623,7 @@ static int untrack_refs(void)
 	for_each_possible_cpu(cpu) {
 		struct nf_conn *ct = &per_cpu(nf_conntrack_untracked, cpu);
 
-		cnt += atomic_read(&ct->ct_general.use) - 1;
+		cnt += refcount_read(&ct->ct_general.use) - 1;
 	}
 	return cnt;
 }
@@ -1911,7 +1911,7 @@ int nf_conntrack_init_start(void)
 	for_each_possible_cpu(cpu) {
 		struct nf_conn *ct = &per_cpu(nf_conntrack_untracked, cpu);
 		write_pnet(&ct->ct_net, &init_net);
-		atomic_set(&ct->ct_general.use, 1);
+		refcount_set(&ct->ct_general.use, 1);
 	}
 	/*  - and look it like as a confirmed connection */
 	nf_ct_untracked_status_or(IPS_CONFIRMED | IPS_UNTRACKED);
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index f8dbacf..5b2448f 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -133,7 +133,7 @@ nf_ct_expect_find_get(struct net *net,
 
 	rcu_read_lock();
 	i = __nf_ct_expect_find(net, zone, tuple);
-	if (i && !atomic_inc_not_zero(&i->use))
+	if (i && !refcount_inc_not_zero(&i->use))
 		i = NULL;
 	rcu_read_unlock();
 
@@ -182,11 +182,11 @@ nf_ct_find_expectation(struct net *net,
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
+		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
-		atomic_inc(&exp->use);
+		refcount_inc(&exp->use);
 		return exp;
 	} else if (del_timer(&exp->timeout)) {
 		nf_ct_unlink_expect(exp);
@@ -275,7 +275,7 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 		return NULL;
 
 	new->master = me;
-	atomic_set(&new->use, 1);
+	refcount_set(&new->use, 1);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
@@ -348,7 +348,7 @@ static void nf_ct_expect_free_rcu(struct rcu_head *head)
 
 void nf_ct_expect_put(struct nf_conntrack_expect *exp)
 {
-	if (atomic_dec_and_test(&exp->use))
+	if (refcount_dec_and_test(&exp->use))
 		call_rcu(&exp->rcu, nf_ct_expect_free_rcu);
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_put);
@@ -361,7 +361,7 @@ static int nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	unsigned int h = nf_ct_expect_dst_hash(net, &exp->tuple);
 
 	/* two references : one for hash insert, one for the timer */
-	atomic_add(2, &exp->use);
+	refcount_add(2, &exp->use);
 
 	hlist_add_head(&exp->lnode, &master_help->expectations);
 	master_help->expecting[exp->class]++;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2754045..7a7012a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -449,7 +449,7 @@ static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -845,7 +845,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    atomic_inc_not_zero(&ct->ct_general.use))
+				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1306,7 +1306,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 						  ct);
 			rcu_read_unlock();
 			if (res < 0) {
-				if (!atomic_inc_not_zero(&ct->ct_general.use))
+				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
@@ -2660,7 +2660,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 						    cb->nlh->nlmsg_seq,
 						    IPCTNL_MSG_EXP_NEW,
 						    exp) < 0) {
-				if (!atomic_inc_not_zero(&exp->use))
+				if (!refcount_inc_not_zero(&exp->use))
 					continue;
 				cb->args[1] = (unsigned long)exp;
 				goto out;
@@ -2706,7 +2706,7 @@ ctnetlink_exp_ct_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					    cb->nlh->nlmsg_seq,
 					    IPCTNL_MSG_EXP_NEW,
 					    exp) < 0) {
-			if (!atomic_inc_not_zero(&exp->use))
+			if (!refcount_inc_not_zero(&exp->use))
 				continue;
 			cb->args[1] = (unsigned long)exp;
 			goto out;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d009ae6..c0a278f 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -209,7 +209,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	int ret = 0;
 
 	NF_CT_ASSERT(ct);
-	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -274,7 +274,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index d44d89b..f44cbd3 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/skbuff.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/netlink.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
@@ -32,7 +33,7 @@ struct nf_acct {
 	atomic64_t		bytes;
 	unsigned long		flags;
 	struct list_head	head;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	char			name[NFACCT_NAME_MAX];
 	struct rcu_head		rcu_head;
 	char			data[0];
@@ -123,7 +124,7 @@ static int nfnl_acct_new(struct net *net, struct sock *nfnl,
 		atomic64_set(&nfacct->pkts,
 			     be64_to_cpu(nla_get_be64(tb[NFACCT_PKTS])));
 	}
-	atomic_set(&nfacct->refcnt, 1);
+	refcount_set(&nfacct->refcnt, 1);
 	list_add_tail_rcu(&nfacct->head, &net->nfnl_acct_list);
 	return 0;
 }
@@ -166,7 +167,7 @@ nfnl_acct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			 NFACCT_PAD) ||
 	    nla_put_be64(skb, NFACCT_BYTES, cpu_to_be64(bytes),
 			 NFACCT_PAD) ||
-	    nla_put_be32(skb, NFACCT_USE, htonl(atomic_read(&acct->refcnt))))
+	    nla_put_be32(skb, NFACCT_USE, htonl(refcount_read(&acct->refcnt))))
 		goto nla_put_failure;
 	if (acct->flags & NFACCT_F_QUOTA) {
 		u64 *quota = (u64 *)acct->data;
@@ -325,11 +326,12 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
+	unsigned int refcount;
 
 	/* We want to avoid races with nfnl_acct_put. So only when the current
 	 * refcnt is 1, we decrease it to 0.
 	 */
-	if (atomic_cmpxchg(&cur->refcnt, 1, 0) == 1) {
+	if (refcount_dec_if_one(&cur->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&cur->head);
 		kfree_rcu(cur, rcu_head);
@@ -413,7 +415,7 @@ struct nf_acct *nfnl_acct_find_get(struct net *net, const char *acct_name)
 		if (!try_module_get(THIS_MODULE))
 			goto err;
 
-		if (!atomic_inc_not_zero(&cur->refcnt)) {
+		if (!refcount_inc_not_zero(&cur->refcnt)) {
 			module_put(THIS_MODULE);
 			goto err;
 		}
@@ -429,7 +431,7 @@ EXPORT_SYMBOL_GPL(nfnl_acct_find_get);
 
 void nfnl_acct_put(struct nf_acct *acct)
 {
-	if (atomic_dec_and_test(&acct->refcnt))
+	if (refcount_dec_and_test(&acct->refcnt))
 		kfree_rcu(acct, rcu_head);
 
 	module_put(THIS_MODULE);
@@ -502,7 +504,7 @@ static void __net_exit nfnl_acct_net_exit(struct net *net)
 	list_for_each_entry_safe(cur, tmp, &net->nfnl_acct_list, head) {
 		list_del_rcu(&cur->head);
 
-		if (atomic_dec_and_test(&cur->refcnt))
+		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
 	}
 }
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index 139e086..baa75f3 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -138,7 +138,7 @@ static int cttimeout_new_timeout(struct net *net, struct sock *ctnl,
 	strcpy(timeout->name, nla_data(cda[CTA_TIMEOUT_NAME]));
 	timeout->l3num = l3num;
 	timeout->l4proto = l4proto;
-	atomic_set(&timeout->refcnt, 1);
+	refcount_set(&timeout->refcnt, 1);
 	list_add_tail_rcu(&timeout->head, &net->nfct_timeout_list);
 
 	return 0;
@@ -172,7 +172,7 @@ ctnl_timeout_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	    nla_put_be16(skb, CTA_TIMEOUT_L3PROTO, htons(timeout->l3num)) ||
 	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, timeout->l4proto->l4proto) ||
 	    nla_put_be32(skb, CTA_TIMEOUT_USE,
-			 htonl(atomic_read(&timeout->refcnt))))
+			 htonl(refcount_read(&timeout->refcnt))))
 		goto nla_put_failure;
 
 	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
@@ -339,7 +339,7 @@ static int ctnl_timeout_try_del(struct net *net, struct ctnl_timeout *timeout)
 	/* We want to avoid races with ctnl_timeout_put. So only when the
 	 * current refcnt is 1, we decrease it to 0.
 	 */
-	if (atomic_cmpxchg(&timeout->refcnt, 1, 0) == 1) {
+	if (refcount_dec_if_one(&timeout->refcnt)) {
 		/* We are protected by nfnl mutex. */
 		list_del_rcu(&timeout->head);
 		nf_ct_l4proto_put(timeout->l4proto);
@@ -536,7 +536,7 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 		if (!try_module_get(THIS_MODULE))
 			goto err;
 
-		if (!atomic_inc_not_zero(&timeout->refcnt)) {
+		if (!refcount_inc_not_zero(&timeout->refcnt)) {
 			module_put(THIS_MODULE);
 			goto err;
 		}
@@ -550,7 +550,7 @@ ctnl_timeout_find_get(struct net *net, const char *name)
 
 static void ctnl_timeout_put(struct ctnl_timeout *timeout)
 {
-	if (atomic_dec_and_test(&timeout->refcnt))
+	if (refcount_dec_and_test(&timeout->refcnt))
 		kfree_rcu(timeout, rcu_head);
 
 	module_put(THIS_MODULE);
@@ -601,7 +601,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 		list_del_rcu(&cur->head);
 		nf_ct_l4proto_put(cur->l4proto);
 
-		if (atomic_dec_and_test(&cur->refcnt))
+		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
 	}
 }
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 08247bf..ecd857b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -40,6 +40,8 @@
 #include <net/netfilter/nfnetlink_log.h>
 
 #include <linux/atomic.h>
+#include <linux/refcount.h>
+
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 #include "../bridge/br_private.h"
@@ -57,7 +59,7 @@
 struct nfulnl_instance {
 	struct hlist_node hlist;	/* global list of instances */
 	spinlock_t lock;
-	atomic_t use;			/* use count */
+	refcount_t use;			/* use count */
 
 	unsigned int qlen;		/* number of nlmsgs in skb */
 	struct sk_buff *skb;		/* pre-allocatd skb */
@@ -115,7 +117,7 @@ __instance_lookup(struct nfnl_log_net *log, u_int16_t group_num)
 static inline void
 instance_get(struct nfulnl_instance *inst)
 {
-	atomic_inc(&inst->use);
+	refcount_inc(&inst->use);
 }
 
 static struct nfulnl_instance *
@@ -125,7 +127,7 @@ instance_lookup_get(struct nfnl_log_net *log, u_int16_t group_num)
 
 	rcu_read_lock_bh();
 	inst = __instance_lookup(log, group_num);
-	if (inst && !atomic_inc_not_zero(&inst->use))
+	if (inst && !refcount_inc_not_zero(&inst->use))
 		inst = NULL;
 	rcu_read_unlock_bh();
 
@@ -145,7 +147,7 @@ static void nfulnl_instance_free_rcu(struct rcu_head *head)
 static void
 instance_put(struct nfulnl_instance *inst)
 {
-	if (inst && atomic_dec_and_test(&inst->use))
+	if (inst && refcount_dec_and_test(&inst->use))
 		call_rcu_bh(&inst->rcu, nfulnl_instance_free_rcu);
 }
 
@@ -180,7 +182,7 @@ instance_create(struct net *net, u_int16_t group_num,
 	INIT_HLIST_NODE(&inst->hlist);
 	spin_lock_init(&inst->lock);
 	/* needs to be two, since we _put() after creation */
-	atomic_set(&inst->use, 2);
+	refcount_set(&inst->use, 2);
 
 	setup_timer(&inst->timer, nfulnl_timer, (unsigned long)inst);
 
@@ -1031,7 +1033,7 @@ static int seq_show(struct seq_file *s, void *v)
 		   inst->group_num,
 		   inst->peer_portid, inst->qlen,
 		   inst->copy_mode, inst->copy_range,
-		   inst->flushtimeout, atomic_read(&inst->use));
+		   inst->flushtimeout, refcount_read(&inst->use));
 
 	return 0;
 }
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index e6baeae..07ab24d 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -533,7 +533,7 @@ static void nft_notrack_eval(const struct nft_expr *expr,
 		return;
 
 	ct = nf_ct_untracked_get();
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	skb->nfct = &ct->ct_general;
 	skb->nfctinfo = IP_CT_NEW;
 }
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 95c7503..cc4a08f 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -29,7 +29,7 @@ static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 	/* special case the untracked ct : we want the percpu object */
 	if (!ct)
 		ct = nf_ct_untracked_get();
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	skb->nfct = &ct->ct_general;
 	skb->nfctinfo = IP_CT_NEW;
 
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 80cb7ba..d51f1e8 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -127,7 +127,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb, void *hp,
 						    daddr, dport,
 						    in->ifindex);
 
-			if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 				sk = NULL;
 			/* NOTE: we return listeners even if bound to
 			 * 0.0.0.0, those are filtered out in
@@ -197,7 +197,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff, void *hp,
 						   daddr, ntohs(dport),
 						   in->ifindex);
 
-			if (sk && !atomic_inc_not_zero(&sk->sk_refcnt))
+			if (sk && !refcount_inc_not_zero(&sk->sk_refcnt))
 				sk = NULL;
 			/* NOTE: we return listeners even if bound to
 			 * 0.0.0.0, those are filtered out in
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 161b628..ed7c2fa 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -341,7 +341,7 @@ static void netlink_sock_destruct(struct sock *sk)
 	}
 
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(nlk_sk(sk)->groups);
 }
 
@@ -544,7 +544,7 @@ static void netlink_remove(struct sock *sk)
 	table = &nl_table[sk->sk_protocol];
 	if (!rhashtable_remove_fast(&table->hash, &nlk_sk(sk)->node,
 				    netlink_rhashtable_params)) {
-		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
+		WARN_ON(refcount_read(&sk->sk_refcnt) == 1);
 		__sock_put(sk);
 	}
 
@@ -657,7 +657,7 @@ static void deferred_put_nlk_sk(struct rcu_head *head)
 	struct netlink_sock *nlk = container_of(head, struct netlink_sock, rcu);
 	struct sock *sk = &nlk->sk;
 
-	if (!atomic_dec_and_test(&sk->sk_refcnt))
+	if (!refcount_dec_and_test(&sk->sk_refcnt))
 		return;
 
 	if (nlk->cb_running && nlk->cb.done) {
@@ -1797,7 +1797,7 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	}
 
 	if (dst_group) {
-		atomic_inc(&skb->users);
+		refcount_inc(&skb->users);
 		netlink_broadcast(sk, skb, dst_portid, dst_group, GFP_KERNEL);
 	}
 	err = netlink_unicast(sk, skb, dst_portid, msg->msg_flags&MSG_DONTWAIT);
@@ -2175,7 +2175,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	struct netlink_sock *nlk;
 	int ret;
 
-	atomic_inc(&skb->users);
+	refcount_inc(&skb->users);
 
 	sk = netlink_lookup(sock_net(ssk), ssk->sk_protocol, NETLINK_CB(skb).portid);
 	if (sk == NULL) {
@@ -2332,7 +2332,7 @@ int nlmsg_notify(struct sock *sk, struct sk_buff *skb, u32 portid,
 		int exclude_portid = 0;
 
 		if (report) {
-			atomic_inc(&skb->users);
+			refcount_inc(&skb->users);
 			exclude_portid = portid;
 		}
 
@@ -2469,7 +2469,7 @@ static int netlink_seq_show(struct seq_file *seq, void *v)
 			   sk_rmem_alloc_get(s),
 			   sk_wmem_alloc_get(s),
 			   nlk->cb_running,
-			   atomic_read(&s->sk_refcnt),
+			   refcount_read(&s->sk_refcnt),
 			   atomic_read(&s->sk_drops),
 			   sock_i_ino(s)
 			);
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index d72a4f1..0c59354 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -149,7 +149,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		nr_neigh->count    = 0;
 		nr_neigh->number   = nr_neigh_no++;
 		nr_neigh->failed   = 0;
-		atomic_set(&nr_neigh->refcount, 1);
+		refcount_set(&nr_neigh->refcount, 1);
 
 		if (ax25_digi != NULL && ax25_digi->ndigi > 0) {
 			nr_neigh->digipeat = kmemdup(ax25_digi,
@@ -184,7 +184,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 
 		nr_node->which = 0;
 		nr_node->count = 1;
-		atomic_set(&nr_node->refcount, 1);
+		refcount_set(&nr_node->refcount, 1);
 		spin_lock_init(&nr_node->node_lock);
 
 		nr_node->routes[0].quality   = quality;
@@ -431,7 +431,7 @@ static int __must_check nr_add_neigh(ax25_address *callsign,
 	nr_neigh->count    = 0;
 	nr_neigh->number   = nr_neigh_no++;
 	nr_neigh->failed   = 0;
-	atomic_set(&nr_neigh->refcount, 1);
+	refcount_set(&nr_neigh->refcount, 1);
 
 	if (ax25_digi != NULL && ax25_digi->ndigi > 0) {
 		nr_neigh->digipeat = kmemdup(ax25_digi, sizeof(*ax25_digi),
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b9e1a13..e543e59 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1312,7 +1312,7 @@ static void packet_sock_destruct(struct sock *sk)
 	skb_queue_purge(&sk->sk_error_queue);
 
 	WARN_ON(atomic_read(&sk->sk_rmem_alloc));
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 
 	if (!sock_flag(sk, SOCK_DEAD)) {
 		pr_err("Attempt to release alive packet socket: %p\n", sk);
@@ -1680,7 +1680,7 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 		match->flags = flags;
 		INIT_LIST_HEAD(&match->list);
 		spin_lock_init(&match->lock);
-		atomic_set(&match->sk_ref, 0);
+		refcount_set(&match->sk_ref, 0);
 		fanout_init_data(match);
 		match->prot_hook.type = po->prot_hook.type;
 		match->prot_hook.dev = po->prot_hook.dev;
@@ -1695,10 +1695,10 @@ static int fanout_add(struct sock *sk, u16 id, u16 type_flags)
 	    match->prot_hook.type == po->prot_hook.type &&
 	    match->prot_hook.dev == po->prot_hook.dev) {
 		err = -ENOSPC;
-		if (atomic_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
+		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
 			__dev_remove_pack(&po->prot_hook);
 			po->fanout = match;
-			atomic_inc(&match->sk_ref);
+			refcount_inc(&match->sk_ref);
 			__fanout_link(sk, po);
 			err = 0;
 		}
@@ -1724,7 +1724,7 @@ static void fanout_release(struct sock *sk)
 	mutex_lock(&fanout_mutex);
 	po->fanout = NULL;
 
-	if (atomic_dec_and_test(&f->sk_ref)) {
+	if (refcount_dec_and_test(&f->sk_ref)) {
 		list_del(&f->list);
 		dev_remove_pack(&f->prot_hook);
 		fanout_release_data(f);
@@ -2461,7 +2461,7 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 	skb->data_len = to_write;
 	skb->len += to_write;
 	skb->truesize += to_write;
-	atomic_add(to_write, &po->sk.sk_wmem_alloc);
+	refcount_add(to_write, &po->sk.sk_wmem_alloc);
 
 	while (likely(to_write)) {
 		nr_frags = skb_shinfo(skb)->nr_frags;
@@ -4401,7 +4401,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 		seq_printf(seq,
 			   "%pK %-6d %-4d %04x   %-5d %1d %-6u %-6u %-6lu\n",
 			   s,
-			   atomic_read(&s->sk_refcnt),
+			   refcount_read(&s->sk_refcnt),
 			   s->sk_type,
 			   ntohs(po->num),
 			   po->ifindex,
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 9ee4631..94d1d40 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -1,6 +1,8 @@
 #ifndef __PACKET_INTERNAL_H__
 #define __PACKET_INTERNAL_H__
 
+#include <linux/refcount.h>
+
 struct packet_mclist {
 	struct packet_mclist	*next;
 	int			ifindex;
@@ -86,7 +88,7 @@ struct packet_fanout {
 	struct list_head	list;
 	struct sock		*arr[PACKET_FANOUT_MAX];
 	spinlock_t		lock;
-	atomic_t		sk_ref;
+	refcount_t		sk_ref;
 	struct packet_type	prot_hook ____cacheline_aligned_in_smp;
 };
 
diff --git a/net/phonet/socket.c b/net/phonet/socket.c
index ffd5f22..bf95d74 100644
--- a/net/phonet/socket.c
+++ b/net/phonet/socket.c
@@ -358,7 +358,7 @@ static unsigned int pn_socket_poll(struct file *file, struct socket *sock,
 		return POLLHUP;
 
 	if (sk->sk_state == TCP_ESTABLISHED &&
-		atomic_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf &&
+		refcount_read(&sk->sk_wmem_alloc) < sk->sk_sndbuf &&
 		atomic_read(&pn->tx_credits))
 		mask |= POLLOUT | POLLWRNORM | POLLWRBAND;
 
@@ -612,7 +612,7 @@ static int pn_sock_seq_show(struct seq_file *seq, void *v)
 			sk_wmem_alloc_get(sk), sk_rmem_alloc_get(sk),
 			from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			sock_i_ino(sk),
-			atomic_read(&sk->sk_refcnt), sk,
+			refcount_read(&sk->sk_refcnt), sk,
 			atomic_read(&sk->sk_drops));
 	}
 	seq_pad(seq, '\n');
diff --git a/net/rds/ib.c b/net/rds/ib.c
index 5680d90..fd8ec93 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -116,8 +116,8 @@ static void rds_ib_dev_free(struct work_struct *work)
 
 void rds_ib_dev_put(struct rds_ib_device *rds_ibdev)
 {
-	BUG_ON(atomic_read(&rds_ibdev->refcount) <= 0);
-	if (atomic_dec_and_test(&rds_ibdev->refcount))
+	BUG_ON(refcount_read(&rds_ibdev->refcount) == 0);
+	if (refcount_dec_and_test(&rds_ibdev->refcount))
 		queue_work(rds_wq, &rds_ibdev->free_work);
 }
 
@@ -135,7 +135,7 @@ static void rds_ib_add_one(struct ib_device *device)
 		return;
 
 	spin_lock_init(&rds_ibdev->spinlock);
-	atomic_set(&rds_ibdev->refcount, 1);
+	refcount_set(&rds_ibdev->refcount, 1);
 	INIT_WORK(&rds_ibdev->free_work, rds_ib_dev_free);
 
 	rds_ibdev->max_wrs = device->attrs.max_qp_wr;
@@ -195,10 +195,10 @@ static void rds_ib_add_one(struct ib_device *device)
 	down_write(&rds_ib_devices_lock);
 	list_add_tail_rcu(&rds_ibdev->list, &rds_ib_devices);
 	up_write(&rds_ib_devices_lock);
-	atomic_inc(&rds_ibdev->refcount);
+	refcount_inc(&rds_ibdev->refcount);
 
 	ib_set_client_data(device, &rds_ib_client, rds_ibdev);
-	atomic_inc(&rds_ibdev->refcount);
+	refcount_inc(&rds_ibdev->refcount);
 
 	rds_ib_nodev_connect();
 
@@ -229,7 +229,7 @@ struct rds_ib_device *rds_ib_get_client_data(struct ib_device *device)
 	rcu_read_lock();
 	rds_ibdev = ib_get_client_data(device, &rds_ib_client);
 	if (rds_ibdev)
-		atomic_inc(&rds_ibdev->refcount);
+		refcount_inc(&rds_ibdev->refcount);
 	rcu_read_unlock();
 	return rds_ibdev;
 }
diff --git a/net/rds/ib.h b/net/rds/ib.h
index 45ac8e8..ddc97d7 100644
--- a/net/rds/ib.h
+++ b/net/rds/ib.h
@@ -219,7 +219,7 @@ struct rds_ib_device {
 	unsigned int		max_initiator_depth;
 	unsigned int		max_responder_resources;
 	spinlock_t		spinlock;	/* protect the above */
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct work_struct	free_work;
 };
 
diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
index 977f698..9a3c54e 100644
--- a/net/rds/ib_rdma.c
+++ b/net/rds/ib_rdma.c
@@ -52,7 +52,7 @@ static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
 	list_for_each_entry_rcu(rds_ibdev, &rds_ib_devices, list) {
 		list_for_each_entry_rcu(i_ipaddr, &rds_ibdev->ipaddr_list, list) {
 			if (i_ipaddr->ipaddr == ipaddr) {
-				atomic_inc(&rds_ibdev->refcount);
+				refcount_inc(&rds_ibdev->refcount);
 				rcu_read_unlock();
 				return rds_ibdev;
 			}
@@ -134,7 +134,7 @@ void rds_ib_add_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *con
 	spin_unlock_irq(&ib_nodev_conns_lock);
 
 	ic->rds_ibdev = rds_ibdev;
-	atomic_inc(&rds_ibdev->refcount);
+	refcount_inc(&rds_ibdev->refcount);
 }
 
 void rds_ib_remove_conn(struct rds_ib_device *rds_ibdev, struct rds_connection *conn)
diff --git a/net/rds/message.c b/net/rds/message.c
index 49bfb51..4318cc9 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -48,8 +48,8 @@ static unsigned int	rds_exthdr_size[__RDS_EXTHDR_MAX] = {
 
 void rds_message_addref(struct rds_message *rm)
 {
-	rdsdebug("addref rm %p ref %d\n", rm, atomic_read(&rm->m_refcount));
-	atomic_inc(&rm->m_refcount);
+	rdsdebug("addref rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
+	refcount_inc(&rm->m_refcount);
 }
 EXPORT_SYMBOL_GPL(rds_message_addref);
 
@@ -83,9 +83,9 @@ static void rds_message_purge(struct rds_message *rm)
 
 void rds_message_put(struct rds_message *rm)
 {
-	rdsdebug("put rm %p ref %d\n", rm, atomic_read(&rm->m_refcount));
-	WARN(!atomic_read(&rm->m_refcount), "danger refcount zero on %p\n", rm);
-	if (atomic_dec_and_test(&rm->m_refcount)) {
+	rdsdebug("put rm %p ref %d\n", rm, refcount_read(&rm->m_refcount));
+	WARN(!refcount_read(&rm->m_refcount), "danger refcount zero on %p\n", rm);
+	if (refcount_dec_and_test(&rm->m_refcount)) {
 		BUG_ON(!list_empty(&rm->m_sock_item));
 		BUG_ON(!list_empty(&rm->m_conn_item));
 		rds_message_purge(rm);
@@ -206,7 +206,7 @@ struct rds_message *rds_message_alloc(unsigned int extra_len, gfp_t gfp)
 	rm->m_used_sgs = 0;
 	rm->m_total_sgs = extra_len / sizeof(struct scatterlist);
 
-	atomic_set(&rm->m_refcount, 1);
+	refcount_set(&rm->m_refcount, 1);
 	INIT_LIST_HEAD(&rm->m_sock_item);
 	INIT_LIST_HEAD(&rm->m_conn_item);
 	spin_lock_init(&rm->m_rs_lock);
diff --git a/net/rds/rdma.c b/net/rds/rdma.c
index ea96114..1325c20 100644
--- a/net/rds/rdma.c
+++ b/net/rds/rdma.c
@@ -85,7 +85,7 @@ static struct rds_mr *rds_mr_tree_walk(struct rb_root *root, u64 key,
 	if (insert) {
 		rb_link_node(&insert->r_rb_node, parent, p);
 		rb_insert_color(&insert->r_rb_node, root);
-		atomic_inc(&insert->r_refcount);
+		refcount_inc(&insert->r_refcount);
 	}
 	return NULL;
 }
@@ -100,7 +100,7 @@ static void rds_destroy_mr(struct rds_mr *mr)
 	unsigned long flags;
 
 	rdsdebug("RDS: destroy mr key is %x refcnt %u\n",
-			mr->r_key, atomic_read(&mr->r_refcount));
+			mr->r_key, refcount_read(&mr->r_refcount));
 
 	if (test_and_set_bit(RDS_MR_DEAD, &mr->r_state))
 		return;
@@ -216,7 +216,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 		goto out;
 	}
 
-	atomic_set(&mr->r_refcount, 1);
+	refcount_set(&mr->r_refcount, 1);
 	RB_CLEAR_NODE(&mr->r_rb_node);
 	mr->r_trans = rs->rs_transport;
 	mr->r_sock = rs;
@@ -300,7 +300,7 @@ static int __rds_rdma_map(struct rds_sock *rs, struct rds_get_mr_args *args,
 
 	rdsdebug("RDS: get_mr key is %x\n", mr->r_key);
 	if (mr_ret) {
-		atomic_inc(&mr->r_refcount);
+		refcount_inc(&mr->r_refcount);
 		*mr_ret = mr;
 	}
 
@@ -738,7 +738,7 @@ int rds_cmsg_rdma_dest(struct rds_sock *rs, struct rds_message *rm,
 	if (!mr)
 		err = -EINVAL;	/* invalid r_key */
 	else
-		atomic_inc(&mr->r_refcount);
+		refcount_inc(&mr->r_refcount);
 	spin_unlock_irqrestore(&rs->rs_rdma_lock, flags);
 
 	if (mr) {
diff --git a/net/rds/rds.h b/net/rds/rds.h
index ebbf909..3e410cd 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -8,6 +8,7 @@
 #include <linux/mutex.h>
 #include <linux/rds.h>
 #include <linux/rhashtable.h>
+#include <linux/refcount.h>
 
 #include "info.h"
 
@@ -252,7 +253,7 @@ struct rds_ext_header_rdma_dest {
 #define __RDS_EXTHDR_MAX	16 /* for now */
 
 struct rds_incoming {
-	atomic_t		i_refcount;
+	refcount_t		i_refcount;
 	struct list_head	i_item;
 	struct rds_connection	*i_conn;
 	struct rds_conn_path	*i_conn_path;
@@ -266,7 +267,7 @@ struct rds_incoming {
 
 struct rds_mr {
 	struct rb_node		r_rb_node;
-	atomic_t		r_refcount;
+	refcount_t		r_refcount;
 	u32			r_key;
 
 	/* A copy of the creation flags */
@@ -345,7 +346,7 @@ static inline u32 rds_rdma_cookie_offset(rds_rdma_cookie_t cookie)
 #define RDS_MSG_FLUSH		8
 
 struct rds_message {
-	atomic_t		m_refcount;
+	refcount_t		m_refcount;
 	struct list_head	m_sock_item;
 	struct list_head	m_conn_item;
 	struct rds_incoming	m_inc;
@@ -844,7 +845,7 @@ int rds_cmsg_atomic(struct rds_sock *rs, struct rds_message *rm,
 void __rds_put_mr_final(struct rds_mr *mr);
 static inline void rds_mr_put(struct rds_mr *mr)
 {
-	if (atomic_dec_and_test(&mr->r_refcount))
+	if (refcount_dec_and_test(&mr->r_refcount))
 		__rds_put_mr_final(mr);
 }
 
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 9d0666e..6858b71 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -43,7 +43,7 @@
 void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 		  __be32 saddr)
 {
-	atomic_set(&inc->i_refcount, 1);
+	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = conn;
 	inc->i_saddr = saddr;
@@ -56,7 +56,7 @@ EXPORT_SYMBOL_GPL(rds_inc_init);
 void rds_inc_path_init(struct rds_incoming *inc, struct rds_conn_path *cp,
 		       __be32 saddr)
 {
-	atomic_set(&inc->i_refcount, 1);
+	refcount_set(&inc->i_refcount, 1);
 	INIT_LIST_HEAD(&inc->i_item);
 	inc->i_conn = cp->cp_conn;
 	inc->i_conn_path = cp;
@@ -69,14 +69,14 @@ EXPORT_SYMBOL_GPL(rds_inc_path_init);
 
 static void rds_inc_addref(struct rds_incoming *inc)
 {
-	rdsdebug("addref inc %p ref %d\n", inc, atomic_read(&inc->i_refcount));
-	atomic_inc(&inc->i_refcount);
+	rdsdebug("addref inc %p ref %d\n", inc, refcount_read(&inc->i_refcount));
+	refcount_inc(&inc->i_refcount);
 }
 
 void rds_inc_put(struct rds_incoming *inc)
 {
-	rdsdebug("put inc %p ref %d\n", inc, atomic_read(&inc->i_refcount));
-	if (atomic_dec_and_test(&inc->i_refcount)) {
+	rdsdebug("put inc %p ref %d\n", inc, refcount_read(&inc->i_refcount));
+	if (refcount_dec_and_test(&inc->i_refcount)) {
 		BUG_ON(!list_empty(&inc->i_item));
 
 		inc->i_conn->c_trans->inc_free(inc);
diff --git a/net/rds/tcp_send.c b/net/rds/tcp_send.c
index dcf4742..592e68b 100644
--- a/net/rds/tcp_send.c
+++ b/net/rds/tcp_send.c
@@ -208,7 +208,7 @@ void rds_tcp_write_space(struct sock *sk)
 	tc->t_last_seen_una = rds_tcp_snd_una(tc);
 	rds_send_path_drop_acked(cp, rds_tcp_snd_una(tc), rds_tcp_is_acked);
 
-	if ((atomic_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf)
+	if ((refcount_read(&sk->sk_wmem_alloc) << 1) <= sk->sk_sndbuf)
 		queue_delayed_work(rds_wq, &cp->cp_send_w, 0);
 
 out:
diff --git a/net/rxrpc/af_rxrpc.c b/net/rxrpc/af_rxrpc.c
index 5f63f6d..c3990e9 100644
--- a/net/rxrpc/af_rxrpc.c
+++ b/net/rxrpc/af_rxrpc.c
@@ -56,7 +56,7 @@ static void rxrpc_sock_destructor(struct sock *);
  */
 static inline int rxrpc_writable(struct sock *sk)
 {
-	return atomic_read(&sk->sk_wmem_alloc) < (size_t) sk->sk_sndbuf;
+	return refcount_read(&sk->sk_wmem_alloc) < (size_t) sk->sk_sndbuf;
 }
 
 /*
@@ -651,7 +651,7 @@ static void rxrpc_sock_destructor(struct sock *sk)
 
 	rxrpc_purge_queue(&sk->sk_receive_queue);
 
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(!sk_unhashed(sk));
 	WARN_ON(sk->sk_socket);
 
@@ -668,7 +668,7 @@ static int rxrpc_release_sock(struct sock *sk)
 {
 	struct rxrpc_sock *rx = rxrpc_sk(sk);
 
-	_enter("%p{%d,%d}", sk, sk->sk_state, atomic_read(&sk->sk_refcnt));
+	_enter("%p{%d,%d}", sk, sk->sk_state, refcount_read(&sk->sk_refcnt));
 
 	/* declare the socket closed for business */
 	sock_orphan(sk);
diff --git a/net/rxrpc/skbuff.c b/net/rxrpc/skbuff.c
index 67b02c4..b8985d0 100644
--- a/net/rxrpc/skbuff.c
+++ b/net/rxrpc/skbuff.c
@@ -27,7 +27,7 @@ void rxrpc_new_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(op));
-	trace_rxrpc_skb(skb, op, atomic_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 }
 
 /*
@@ -38,7 +38,7 @@ void rxrpc_see_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 	const void *here = __builtin_return_address(0);
 	if (skb) {
 		int n = atomic_read(select_skb_count(op));
-		trace_rxrpc_skb(skb, op, atomic_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	}
 }
 
@@ -49,7 +49,7 @@ void rxrpc_get_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 {
 	const void *here = __builtin_return_address(0);
 	int n = atomic_inc_return(select_skb_count(op));
-	trace_rxrpc_skb(skb, op, atomic_read(&skb->users), n, here);
+	trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 	skb_get(skb);
 }
 
@@ -63,7 +63,7 @@ void rxrpc_free_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 		int n;
 		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(op));
-		trace_rxrpc_skb(skb, op, atomic_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
 }
@@ -78,7 +78,7 @@ void rxrpc_lose_skb(struct sk_buff *skb, enum rxrpc_skb_trace op)
 		int n;
 		CHECK_SLAB_OKAY(&skb->users);
 		n = atomic_dec_return(select_skb_count(op));
-		trace_rxrpc_skb(skb, op, atomic_read(&skb->users), n, here);
+		trace_rxrpc_skb(skb, op, refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
 }
@@ -93,7 +93,7 @@ void rxrpc_purge_queue(struct sk_buff_head *list)
 	while ((skb = skb_dequeue((list))) != NULL) {
 		int n = atomic_dec_return(select_skb_count(rxrpc_skb_rx_purged));
 		trace_rxrpc_skb(skb, rxrpc_skb_rx_purged,
-				atomic_read(&skb->users), n, here);
+				refcount_read(&skb->users), n, here);
 		kfree_skb(skb);
 	}
 }
diff --git a/net/sched/em_meta.c b/net/sched/em_meta.c
index 41c80b6..47ac782 100644
--- a/net/sched/em_meta.c
+++ b/net/sched/em_meta.c
@@ -339,7 +339,7 @@ META_COLLECTOR(int_sk_refcnt)
 		*err = -1;
 		return;
 	}
-	dst->value = atomic_read(&skb->sk->sk_refcnt);
+	dst->value = refcount_read(&skb->sk->sk_refcnt);
 }
 
 META_COLLECTOR(int_sk_rcvbuf)
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index d7b9342..5b49bb6 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -840,7 +840,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 
 			old = dev_graft_qdisc(dev_queue, new);
 			if (new && i > 0)
-				atomic_inc(&new->refcnt);
+				refcount_inc(&new->refcnt);
 
 			if (!ingress)
 				qdisc_destroy(old);
@@ -851,7 +851,7 @@ static int qdisc_graft(struct net_device *dev, struct Qdisc *parent,
 			notify_and_destroy(net, skb, n, classid,
 					   dev->qdisc, new);
 			if (new && !new->ops->attach)
-				atomic_inc(&new->refcnt);
+				refcount_inc(&new->refcnt);
 			dev->qdisc = new ? : &noop_qdisc;
 
 			if (new && new->ops->attach)
@@ -1255,7 +1255,7 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n)
 				if (q == p ||
 				    (p && check_loop(q, p, 0)))
 					return -ELOOP;
-				atomic_inc(&q->refcnt);
+				refcount_inc(&q->refcnt);
 				goto graft;
 			} else {
 				if (!q)
@@ -1370,7 +1370,7 @@ static int tc_fill_qdisc(struct sk_buff *skb, struct Qdisc *q, u32 clid,
 	tcm->tcm_ifindex = qdisc_dev(q)->ifindex;
 	tcm->tcm_parent = clid;
 	tcm->tcm_handle = q->handle;
-	tcm->tcm_info = atomic_read(&q->refcnt);
+	tcm->tcm_info = refcount_read(&q->refcnt);
 	if (nla_put_string(skb, TCA_KIND, q->ops->id))
 		goto nla_put_failure;
 	if (q->ops->dump && q->ops->dump(q, skb) < 0)
diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 481e4f1..e99494e 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -490,7 +490,7 @@ static void sch_atm_dequeue(unsigned long data)
 			ATM_SKB(skb)->vcc = flow->vcc;
 			memcpy(skb_push(skb, flow->hdr_len), flow->hdr,
 			       flow->hdr_len);
-			atomic_add(skb->truesize,
+			refcount_add(skb->truesize,
 				   &sk_atm(flow->vcc)->sk_wmem_alloc);
 			/* atm.atm_options are already set by atm_tc_enqueue */
 			flow->vcc->send(flow->vcc, skb);
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6eb9c8e..6a75581 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -633,7 +633,7 @@ struct Qdisc *qdisc_alloc(struct netdev_queue *dev_queue,
 	sch->dequeue = ops->dequeue;
 	sch->dev_queue = dev_queue;
 	dev_hold(dev);
-	atomic_set(&sch->refcnt, 1);
+	refcount_set(&sch->refcnt, 1);
 
 	return sch;
 errout:
@@ -701,7 +701,7 @@ void qdisc_destroy(struct Qdisc *qdisc)
 	const struct Qdisc_ops  *ops = qdisc->ops;
 
 	if (qdisc->flags & TCQ_F_BUILTIN ||
-	    !atomic_dec_and_test(&qdisc->refcnt))
+	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;
 
 #ifdef CONFIG_NET_SCHED
@@ -739,7 +739,7 @@ struct Qdisc *dev_graft_qdisc(struct netdev_queue *dev_queue,
 	spin_lock_bh(root_lock);
 
 	/* Prune old scheduler */
-	if (oqdisc && atomic_read(&oqdisc->refcnt) <= 1)
+	if (oqdisc && refcount_read(&oqdisc->refcnt) <= 1)
 		qdisc_reset(oqdisc);
 
 	/* ... and graft new one */
@@ -785,7 +785,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 	    dev->priv_flags & IFF_NO_QUEUE) {
 		netdev_for_each_tx_queue(dev, attach_one_default_qdisc, NULL);
 		dev->qdisc = txq->qdisc_sleeping;
-		atomic_inc(&dev->qdisc->refcnt);
+		refcount_inc(&dev->qdisc->refcnt);
 	} else {
 		qdisc = qdisc_create_dflt(txq, &mq_qdisc_ops, TC_H_ROOT);
 		if (qdisc) {
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index d3cc30c..10ff17a 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -89,7 +89,7 @@ static struct sctp_association *sctp_association_init(struct sctp_association *a
 	asoc->base.type = SCTP_EP_TYPE_ASSOCIATION;
 
 	/* Initialize the object handling fields.  */
-	atomic_set(&asoc->base.refcnt, 1);
+	refcount_set(&asoc->base.refcnt, 1);
 
 	/* Initialize the bind addr area.  */
 	sctp_bind_addr_init(&asoc->base.bind_addr, ep->base.bind_addr.port);
@@ -858,7 +858,7 @@ void sctp_assoc_control_transport(struct sctp_association *asoc,
 /* Hold a reference to an association. */
 void sctp_association_hold(struct sctp_association *asoc)
 {
-	atomic_inc(&asoc->base.refcnt);
+	refcount_inc(&asoc->base.refcnt);
 }
 
 /* Release a reference to an association and cleanup
@@ -866,7 +866,7 @@ void sctp_association_hold(struct sctp_association *asoc)
  */
 void sctp_association_put(struct sctp_association *asoc)
 {
-	if (atomic_dec_and_test(&asoc->base.refcnt))
+	if (refcount_dec_and_test(&asoc->base.refcnt))
 		sctp_association_destroy(asoc);
 }
 
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index f99d485..b6c98fe 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -63,7 +63,7 @@ void sctp_auth_key_put(struct sctp_auth_bytes *key)
 	if (!key)
 		return;
 
-	if (atomic_dec_and_test(&key->refcnt)) {
+	if (refcount_dec_and_test(&key->refcnt)) {
 		kzfree(key);
 		SCTP_DBG_OBJCNT_DEC(keys);
 	}
@@ -84,7 +84,7 @@ static struct sctp_auth_bytes *sctp_auth_create_key(__u32 key_len, gfp_t gfp)
 		return NULL;
 
 	key->len = key_len;
-	atomic_set(&key->refcnt, 1);
+	refcount_set(&key->refcnt, 1);
 	SCTP_DBG_OBJCNT_INC(keys);
 
 	return key;
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 615f0dd..6c8087a 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -49,7 +49,7 @@
 /* Initialize datamsg from memory. */
 static void sctp_datamsg_init(struct sctp_datamsg *msg)
 {
-	atomic_set(&msg->refcnt, 1);
+	refcount_set(&msg->refcnt, 1);
 	msg->send_failed = 0;
 	msg->send_error = 0;
 	msg->can_delay = 1;
@@ -136,13 +136,13 @@ static void sctp_datamsg_destroy(struct sctp_datamsg *msg)
 /* Hold a reference. */
 static void sctp_datamsg_hold(struct sctp_datamsg *msg)
 {
-	atomic_inc(&msg->refcnt);
+	refcount_inc(&msg->refcnt);
 }
 
 /* Release a reference. */
 void sctp_datamsg_put(struct sctp_datamsg *msg)
 {
-	if (atomic_dec_and_test(&msg->refcnt))
+	if (refcount_dec_and_test(&msg->refcnt))
 		sctp_datamsg_destroy(msg);
 }
 
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 410ddc1..019fe78 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -113,7 +113,7 @@ static struct sctp_endpoint *sctp_endpoint_init(struct sctp_endpoint *ep,
 	ep->base.type = SCTP_EP_TYPE_SOCKET;
 
 	/* Initialize the basic object fields. */
-	atomic_set(&ep->base.refcnt, 1);
+	refcount_set(&ep->base.refcnt, 1);
 	ep->base.dead = false;
 
 	/* Create an input queue.  */
@@ -284,7 +284,7 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 /* Hold a reference to an endpoint. */
 void sctp_endpoint_hold(struct sctp_endpoint *ep)
 {
-	atomic_inc(&ep->base.refcnt);
+	refcount_inc(&ep->base.refcnt);
 }
 
 /* Release a reference to an endpoint and clean up if there are
@@ -292,7 +292,7 @@ void sctp_endpoint_hold(struct sctp_endpoint *ep)
  */
 void sctp_endpoint_put(struct sctp_endpoint *ep)
 {
-	if (atomic_dec_and_test(&ep->base.refcnt))
+	if (refcount_dec_and_test(&ep->base.refcnt))
 		sctp_endpoint_destroy(ep);
 }
 
diff --git a/net/sctp/output.c b/net/sctp/output.c
index f5320a8..53210b5 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -396,7 +396,7 @@ static void sctp_packet_set_owner_w(struct sk_buff *skb, struct sock *sk)
 	 * therefore only reserve a single byte to keep socket around until
 	 * the packet has been transmitted.
 	 */
-	atomic_inc(&sk->sk_wmem_alloc);
+	refcount_inc(&sk->sk_wmem_alloc);
 }
 
 static int sctp_packet_pack(struct sctp_packet *packet,
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e540826..e8ae4a1 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1081,7 +1081,7 @@ static void sctp_outq_flush(struct sctp_outq *q, int rtx_timeout, gfp_t gfp)
 				 sctp_cname(SCTP_ST_CHUNK(chunk->chunk_hdr->type)) :
 				 "illegal chunk", ntohl(chunk->subh.data_hdr->tsn),
 				 chunk->skb ? chunk->skb->head : NULL, chunk->skb ?
-				 atomic_read(&chunk->skb->users) : -1);
+				 refcount_read(&chunk->skb->users) : -1);
 
 			/* Add the chunk to the packet.  */
 			status = sctp_packet_transmit_chunk(packet, chunk, 0, gfp);
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 206377f..25cd840 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -365,7 +365,7 @@ static int sctp_assocs_seq_show(struct seq_file *seq, void *v)
 		assoc->c.sinit_num_ostreams, assoc->max_retrans,
 		assoc->init_retries, assoc->shutdown_retries,
 		assoc->rtx_data_chunks,
-		atomic_read(&sk->sk_wmem_alloc),
+		refcount_read(&sk->sk_wmem_alloc),
 		sk->sk_wmem_queued,
 		sk->sk_sndbuf,
 		sk->sk_rcvbuf);
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 9e9690b..7eac4e9 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1336,7 +1336,7 @@ struct sctp_chunk *sctp_chunkify(struct sk_buff *skb,
 	INIT_LIST_HEAD(&retval->transmitted_list);
 	INIT_LIST_HEAD(&retval->frag_list);
 	SCTP_DBG_OBJCNT_INC(chunk);
-	atomic_set(&retval->refcnt, 1);
+	refcount_set(&retval->refcnt, 1);
 
 nodata:
 	return retval;
@@ -1449,13 +1449,13 @@ void sctp_chunk_free(struct sctp_chunk *chunk)
 /* Grab a reference to the chunk. */
 void sctp_chunk_hold(struct sctp_chunk *ch)
 {
-	atomic_inc(&ch->refcnt);
+	refcount_inc(&ch->refcnt);
 }
 
 /* Release a reference to the chunk. */
 void sctp_chunk_put(struct sctp_chunk *ch)
 {
-	if (atomic_dec_and_test(&ch->refcnt))
+	if (refcount_dec_and_test(&ch->refcnt))
 		sctp_chunk_destroy(ch);
 }
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 318c678..73a545b 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -163,7 +163,7 @@ static inline void sctp_set_owner_w(struct sctp_chunk *chunk)
 				sizeof(struct sk_buff) +
 				sizeof(struct sctp_chunk);
 
-	atomic_add(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc);
+	refcount_add(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc);
 	sk->sk_wmem_queued += chunk->skb->truesize;
 	sk_mem_charge(sk, chunk->skb->truesize);
 }
@@ -7237,7 +7237,7 @@ struct sk_buff *sctp_skb_recv_datagram(struct sock *sk, int flags,
 		if (flags & MSG_PEEK) {
 			skb = skb_peek(&sk->sk_receive_queue);
 			if (skb)
-				atomic_inc(&skb->users);
+				refcount_inc(&skb->users);
 		} else {
 			skb = __skb_dequeue(&sk->sk_receive_queue);
 		}
@@ -7355,7 +7355,7 @@ static void sctp_wfree(struct sk_buff *skb)
 				sizeof(struct sk_buff) +
 				sizeof(struct sctp_chunk);
 
-	atomic_sub(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc);
+	WARN_ON(refcount_sub_and_test(sizeof(struct sctp_chunk), &sk->sk_wmem_alloc));
 
 	/*
 	 * This undoes what is done via sctp_set_owner_w and sk_mem_charge
diff --git a/net/sctp/transport.c b/net/sctp/transport.c
index a1652ab..a082cd2 100644
--- a/net/sctp/transport.c
+++ b/net/sctp/transport.c
@@ -97,7 +97,7 @@ static struct sctp_transport *sctp_transport_init(struct net *net,
 	/* Initialize the 64-bit random nonce sent with heartbeat. */
 	get_random_bytes(&peer->hb_nonce, sizeof(peer->hb_nonce));
 
-	atomic_set(&peer->refcnt, 1);
+	refcount_set(&peer->refcnt, 1);
 
 	return peer;
 }
@@ -167,7 +167,7 @@ static void sctp_transport_destroy_rcu(struct rcu_head *head)
  */
 static void sctp_transport_destroy(struct sctp_transport *transport)
 {
-	if (unlikely(atomic_read(&transport->refcnt))) {
+	if (unlikely(refcount_read(&transport->refcnt))) {
 		WARN(1, "Attempt to destroy undead transport %p!\n", transport);
 		return;
 	}
@@ -303,7 +303,7 @@ void sctp_transport_route(struct sctp_transport *transport,
 /* Hold a reference to a transport.  */
 int sctp_transport_hold(struct sctp_transport *transport)
 {
-	return atomic_add_unless(&transport->refcnt, 1, 0);
+	return refcount_inc_not_zero(&transport->refcnt);
 }
 
 /* Release a reference to a transport and clean up
@@ -311,7 +311,7 @@ int sctp_transport_hold(struct sctp_transport *transport)
  */
 void sctp_transport_put(struct sctp_transport *transport)
 {
-	if (atomic_dec_and_test(&transport->refcnt))
+	if (refcount_dec_and_test(&transport->refcnt))
 		sctp_transport_destroy(transport);
 }
 
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 2bff63a..b6439b9 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -310,7 +310,7 @@ rpcauth_unhash_cred(struct rpc_cred *cred)
 
 	cache_lock = &cred->cr_auth->au_credcache->lock;
 	spin_lock(cache_lock);
-	ret = atomic_read(&cred->cr_count) == 0;
+	ret = refcount_read(&cred->cr_count) == 0;
 	if (ret)
 		rpcauth_unhash_cred_locked(cred);
 	spin_unlock(cache_lock);
@@ -470,12 +470,12 @@ rpcauth_prune_expired(struct list_head *free, int nr_to_scan)
 		list_del_init(&cred->cr_lru);
 		number_cred_unused--;
 		freed++;
-		if (atomic_read(&cred->cr_count) != 0)
+		if (refcount_read(&cred->cr_count) != 0)
 			continue;
 
 		cache_lock = &cred->cr_auth->au_credcache->lock;
 		spin_lock(cache_lock);
-		if (atomic_read(&cred->cr_count) == 0) {
+		if (refcount_read(&cred->cr_count) == 0) {
 			get_rpccred(cred);
 			list_add_tail(&cred->cr_lru, free);
 			rpcauth_unhash_cred_locked(cred);
@@ -642,7 +642,7 @@ rpcauth_init_cred(struct rpc_cred *cred, const struct auth_cred *acred,
 {
 	INIT_HLIST_NODE(&cred->cr_hash);
 	INIT_LIST_HEAD(&cred->cr_lru);
-	atomic_set(&cred->cr_count, 1);
+	refcount_set(&cred->cr_count, 1);
 	cred->cr_auth = auth;
 	cred->cr_ops = ops;
 	cred->cr_expire = jiffies;
@@ -715,12 +715,12 @@ put_rpccred(struct rpc_cred *cred)
 		return;
 	/* Fast path for unhashed credentials */
 	if (test_bit(RPCAUTH_CRED_HASHED, &cred->cr_flags) == 0) {
-		if (atomic_dec_and_test(&cred->cr_count))
+		if (refcount_dec_and_test(&cred->cr_count))
 			cred->cr_ops->crdestroy(cred);
 		return;
 	}
 
-	if (!atomic_dec_and_lock(&cred->cr_count, &rpc_credcache_lock))
+	if (!refcount_dec_and_lock(&cred->cr_count, &rpc_credcache_lock))
 		return;
 	if (!list_empty(&cred->cr_lru)) {
 		number_cred_unused--;
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index cdeb1d8..59b5860 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -52,6 +52,7 @@
 #include <linux/sunrpc/gss_api.h>
 #include <linux/uaccess.h>
 #include <linux/hashtable.h>
+#include <linux/refcount.h>
 
 #include "../netns.h"
 
@@ -117,14 +118,14 @@ static const struct rpc_pipe_ops gss_upcall_ops_v1;
 static inline struct gss_cl_ctx *
 gss_get_ctx(struct gss_cl_ctx *ctx)
 {
-	atomic_inc(&ctx->count);
+	refcount_inc(&ctx->count);
 	return ctx;
 }
 
 static inline void
 gss_put_ctx(struct gss_cl_ctx *ctx)
 {
-	if (atomic_dec_and_test(&ctx->count))
+	if (refcount_dec_and_test(&ctx->count))
 		gss_free_ctx(ctx);
 }
 
@@ -200,7 +201,7 @@ gss_alloc_context(void)
 		ctx->gc_proc = RPC_GSS_PROC_DATA;
 		ctx->gc_seq = 1;	/* NetApp 6.4R1 doesn't accept seq. no. 0 */
 		spin_lock_init(&ctx->gc_seq_lock);
-		atomic_set(&ctx->count,1);
+		refcount_set(&ctx->count,1);
 	}
 	return ctx;
 }
@@ -287,7 +288,7 @@ gss_fill_context(const void *p, const void *end, struct gss_cl_ctx *ctx, struct
 #define UPCALL_BUF_LEN 128
 
 struct gss_upcall_msg {
-	atomic_t count;
+	refcount_t count;
 	kuid_t	uid;
 	struct rpc_pipe_msg msg;
 	struct list_head list;
@@ -328,7 +329,7 @@ static void
 gss_release_msg(struct gss_upcall_msg *gss_msg)
 {
 	struct net *net = gss_msg->auth->net;
-	if (!atomic_dec_and_test(&gss_msg->count))
+	if (!refcount_dec_and_test(&gss_msg->count))
 		return;
 	put_pipe_version(net);
 	BUG_ON(!list_empty(&gss_msg->list));
@@ -348,7 +349,7 @@ __gss_find_upcall(struct rpc_pipe *pipe, kuid_t uid, const struct gss_auth *auth
 			continue;
 		if (auth && pos->auth->service != auth->service)
 			continue;
-		atomic_inc(&pos->count);
+		refcount_inc(&pos->count);
 		dprintk("RPC:       %s found msg %p\n", __func__, pos);
 		return pos;
 	}
@@ -369,7 +370,7 @@ gss_add_msg(struct gss_upcall_msg *gss_msg)
 	spin_lock(&pipe->lock);
 	old = __gss_find_upcall(pipe, gss_msg->uid, gss_msg->auth);
 	if (old == NULL) {
-		atomic_inc(&gss_msg->count);
+		refcount_inc(&gss_msg->count);
 		list_add(&gss_msg->list, &pipe->in_downcall);
 	} else
 		gss_msg = old;
@@ -383,7 +384,7 @@ __gss_unhash_msg(struct gss_upcall_msg *gss_msg)
 	list_del_init(&gss_msg->list);
 	rpc_wake_up_status(&gss_msg->rpc_waitqueue, gss_msg->msg.errno);
 	wake_up_all(&gss_msg->waitqueue);
-	atomic_dec(&gss_msg->count);
+	WARN_ON(refcount_dec_and_test(&gss_msg->count));
 }
 
 static void
@@ -506,7 +507,7 @@ gss_alloc_msg(struct gss_auth *gss_auth,
 	INIT_LIST_HEAD(&gss_msg->list);
 	rpc_init_wait_queue(&gss_msg->rpc_waitqueue, "RPCSEC_GSS upcall waitq");
 	init_waitqueue_head(&gss_msg->waitqueue);
-	atomic_set(&gss_msg->count, 1);
+	refcount_set(&gss_msg->count, 1);
 	gss_msg->uid = uid;
 	gss_msg->auth = gss_auth;
 	switch (vers) {
@@ -542,11 +543,11 @@ gss_setup_upcall(struct gss_auth *gss_auth, struct rpc_cred *cred)
 	gss_msg = gss_add_msg(gss_new);
 	if (gss_msg == gss_new) {
 		int res;
-		atomic_inc(&gss_msg->count);
+		refcount_inc(&gss_msg->count);
 		res = rpc_queue_upcall(gss_new->pipe, &gss_new->msg);
 		if (res) {
 			gss_unhash_msg(gss_new);
-			atomic_dec(&gss_msg->count);
+			refcount_dec(&gss_msg->count);
 			gss_release_msg(gss_new);
 			gss_msg = ERR_PTR(res);
 		}
@@ -595,7 +596,7 @@ gss_refresh_upcall(struct rpc_task *task)
 		task->tk_timeout = 0;
 		gss_cred->gc_upcall = gss_msg;
 		/* gss_upcall_callback will release the reference to gss_upcall_msg */
-		atomic_inc(&gss_msg->count);
+		refcount_inc(&gss_msg->count);
 		rpc_sleep_on(&gss_msg->rpc_waitqueue, task, gss_upcall_callback);
 	} else {
 		gss_handle_downcall_result(gss_cred, gss_msg);
@@ -815,7 +816,7 @@ gss_pipe_release(struct inode *inode)
 		if (!list_empty(&gss_msg->msg.list))
 			continue;
 		gss_msg->msg.errno = -EPIPE;
-		atomic_inc(&gss_msg->count);
+		refcount_inc(&gss_msg->count);
 		__gss_unhash_msg(gss_msg);
 		spin_unlock(&pipe->lock);
 		gss_release_msg(gss_msg);
@@ -834,7 +835,7 @@ gss_pipe_destroy_msg(struct rpc_pipe_msg *msg)
 	if (msg->errno < 0) {
 		dprintk("RPC:       %s releasing msg %p\n",
 			__func__, gss_msg);
-		atomic_inc(&gss_msg->count);
+		refcount_inc(&gss_msg->count);
 		gss_unhash_msg(gss_msg);
 		if (msg->errno == -ETIMEDOUT)
 			warn_gssd();
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 800caaa..2189667 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2332,7 +2332,7 @@ static void tipc_sk_remove(struct tipc_sock *tsk)
 	struct tipc_net *tn = net_generic(sock_net(sk), tipc_net_id);
 
 	if (!rhashtable_remove_fast(&tn->sk_rht, &tsk->node, tsk_rht_params)) {
-		WARN_ON(atomic_read(&sk->sk_refcnt) == 1);
+		WARN_ON(refcount_read(&sk->sk_refcnt) == 1);
 		__sock_put(sk);
 	}
 }
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 127656e..3a3223c 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -211,7 +211,7 @@ EXPORT_SYMBOL_GPL(unix_peer_get);
 
 static inline void unix_release_addr(struct unix_address *addr)
 {
-	if (atomic_dec_and_test(&addr->refcnt))
+	if (refcount_dec_and_test(&addr->refcnt))
 		kfree(addr);
 }
 
@@ -441,7 +441,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 static int unix_writable(const struct sock *sk)
 {
 	return sk->sk_state != TCP_LISTEN &&
-	       (atomic_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
+	       (refcount_read(&sk->sk_wmem_alloc) << 2) <= sk->sk_sndbuf;
 }
 
 static void unix_write_space(struct sock *sk)
@@ -486,7 +486,7 @@ static void unix_sock_destructor(struct sock *sk)
 
 	skb_queue_purge(&sk->sk_receive_queue);
 
-	WARN_ON(atomic_read(&sk->sk_wmem_alloc));
+	WARN_ON(refcount_read(&sk->sk_wmem_alloc));
 	WARN_ON(!sk_unhashed(sk));
 	WARN_ON(sk->sk_socket);
 	if (!sock_flag(sk, SOCK_DEAD)) {
@@ -863,7 +863,7 @@ static int unix_autobind(struct socket *sock)
 		goto out;
 
 	addr->name->sun_family = AF_UNIX;
-	atomic_set(&addr->refcnt, 1);
+	refcount_set(&addr->refcnt, 1);
 
 retry:
 	addr->len = sprintf(addr->name->sun_path+1, "%05x", ordernum) + 1 + sizeof(short);
@@ -1026,7 +1026,7 @@ static int unix_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	memcpy(addr->name, sunaddr, addr_len);
 	addr->len = addr_len;
 	addr->hash = hash ^ sk->sk_type;
-	atomic_set(&addr->refcnt, 1);
+	refcount_set(&addr->refcnt, 1);
 
 	if (sun_path[0]) {
 		struct path path;
@@ -1324,7 +1324,7 @@ static int unix_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 
 	/* copy address information from listening to new sock*/
 	if (otheru->addr) {
-		atomic_inc(&otheru->addr->refcnt);
+		refcount_inc(&otheru->addr->refcnt);
 		newu->addr = otheru->addr;
 	}
 	if (otheru->path.dentry) {
@@ -2021,7 +2021,7 @@ static ssize_t unix_stream_sendpage(struct socket *socket, struct page *page,
 	skb->len += size;
 	skb->data_len += size;
 	skb->truesize += size;
-	atomic_add(size, &sk->sk_wmem_alloc);
+	refcount_add(size, &sk->sk_wmem_alloc);
 
 	if (newskb) {
 		err = unix_scm_to_skb(&scm, skb, false);
@@ -2795,7 +2795,7 @@ static int unix_seq_show(struct seq_file *seq, void *v)
 
 		seq_printf(seq, "%pK: %08X %08X %08X %04X %02X %5lu",
 			s,
-			atomic_read(&s->sk_refcnt),
+			refcount_read(&s->sk_refcnt),
 			0,
 			s->sk_state == TCP_LISTEN ? __SO_ACCEPTCON : 0,
 			s->sk_type,
diff --git a/net/wireless/lib80211.c b/net/wireless/lib80211.c
index 4596115..472dce0 100644
--- a/net/wireless/lib80211.c
+++ b/net/wireless/lib80211.c
@@ -92,7 +92,7 @@ static void lib80211_crypt_deinit_entries(struct lib80211_crypt_info *info,
 
 	spin_lock_irqsave(info->lock, flags);
 	list_for_each_entry_safe(entry, next, &info->crypt_deinit_list, list) {
-		if (atomic_read(&entry->refcnt) != 0 && !force)
+		if (refcount_read(&entry->refcnt) != 0 && !force)
 			continue;
 
 		list_del(&entry->list);
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index bcaa180..e0cd04d 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -266,7 +266,7 @@ void x25_link_device_up(struct net_device *dev)
 				       X25_MASK_PACKET_SIZE |
 				       X25_MASK_WINDOW_SIZE;
 	nb->t20      = sysctl_x25_restart_request_timeout;
-	atomic_set(&nb->refcnt, 1);
+	refcount_set(&nb->refcnt, 1);
 
 	write_lock_bh(&x25_neigh_list_lock);
 	list_add(&nb->node, &x25_neigh_list);
diff --git a/net/x25/x25_route.c b/net/x25/x25_route.c
index 277c8d2..b85b889 100644
--- a/net/x25/x25_route.c
+++ b/net/x25/x25_route.c
@@ -55,7 +55,7 @@ static int x25_add_route(struct x25_address *address, unsigned int sigdigits,
 
 	rt->sigdigits = sigdigits;
 	rt->dev       = dev;
-	atomic_set(&rt->refcnt, 1);
+	refcount_set(&rt->refcnt, 1);
 
 	list_add(&rt->node, &x25_route_list);
 	rc = 0;
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 6e3f025..25f9939 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -118,7 +118,7 @@ struct sec_path *secpath_dup(struct sec_path *src)
 		for (i = 0; i < sp->len; i++)
 			xfrm_state_hold(sp->xvec[i]);
 	}
-	atomic_set(&sp->refcnt, 1);
+	refcount_set(&sp->refcnt, 1);
 	return sp;
 }
 EXPORT_SYMBOL(secpath_dup);
@@ -219,7 +219,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	}
 
 	/* Allocate new secpath or COW existing one. */
-	if (!skb->sp || atomic_read(&skb->sp->refcnt) != 1) {
+	if (!skb->sp || refcount_read(&skb->sp->refcnt) != 1) {
 		struct sec_path *sp;
 
 		sp = secpath_dup(skb->sp);
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 177e208..bc39de5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -62,7 +62,7 @@ static struct xfrm_policy *__xfrm_policy_unlink(struct xfrm_policy *pol,
 
 static inline bool xfrm_pol_hold_rcu(struct xfrm_policy *policy)
 {
-	return atomic_inc_not_zero(&policy->refcnt);
+	return refcount_inc_not_zero(&policy->refcnt);
 }
 
 static inline bool
@@ -297,7 +297,7 @@ struct xfrm_policy *xfrm_policy_alloc(struct net *net, gfp_t gfp)
 		INIT_HLIST_NODE(&policy->bydst);
 		INIT_HLIST_NODE(&policy->byidx);
 		rwlock_init(&policy->lock);
-		atomic_set(&policy->refcnt, 1);
+		refcount_set(&policy->refcnt, 1);
 		skb_queue_head_init(&policy->polq.hold_queue);
 		setup_timer(&policy->timer, xfrm_policy_timer,
 				(unsigned long)policy);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 64e3c82..e9732c8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -48,7 +48,7 @@ static HLIST_HEAD(xfrm_state_gc_list);
 
 static inline bool xfrm_state_hold_rcu(struct xfrm_state __rcu *x)
 {
-	return atomic_inc_not_zero(&x->refcnt);
+	return refcount_inc_not_zero(&x->refcnt);
 }
 
 static inline unsigned int xfrm_dst_hash(struct net *net,
@@ -485,7 +485,7 @@ struct xfrm_state *xfrm_state_alloc(struct net *net)
 
 	if (x) {
 		write_pnet(&x->xs_net, net);
-		atomic_set(&x->refcnt, 1);
+		refcount_set(&x->refcnt, 1);
 		atomic_set(&x->tunnel_users, 0);
 		INIT_LIST_HEAD(&x->km.all);
 		INIT_HLIST_NODE(&x->bydst);
-- 
2.7.4
