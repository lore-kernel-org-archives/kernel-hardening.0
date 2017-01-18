Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:45 +0200
Message-Id: <1484730707-29313-17-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 16/18] drivers: net convert from atomic_t to refcount_t
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
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c      |  8 +++----
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h      |  4 +++-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  6 +++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  4 +++-
 drivers/net/ethernet/mellanox/mlx4/cq.c            | 12 +++++------
 drivers/net/ethernet/mellanox/mlx4/qp.c            |  8 +++----
 drivers/net/ethernet/mellanox/mlx4/srq.c           |  8 +++----
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       | 16 +++++++-------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 24 ++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/qp.c       |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/srq.c      | 10 ++++-----
 drivers/net/ethernet/sun/niu.c                     |  6 +++---
 drivers/net/ethernet/sun/niu.h                     |  4 +++-
 drivers/net/hamradio/6pack.c                       | 12 +++++------
 drivers/net/macsec.c                               | 25 +++++++++++-----------
 drivers/net/ppp/ppp_async.c                        | 10 ++++-----
 drivers/net/ppp/ppp_generic.c                      | 17 ++++++++-------
 drivers/net/ppp/ppp_synctty.c                      | 11 +++++-----
 drivers/net/wireless/intersil/hostap/hostap_hw.c   | 12 +++++------
 drivers/net/wireless/intersil/hostap/hostap_wlan.h |  3 ++-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    | 15 +++++++------
 include/linux/mlx4/device.h                        |  8 +++----
 include/linux/mlx5/cq.h                            |  4 ++--
 net/netfilter/nfnetlink_acct.c                     |  1 -
 25 files changed, 124 insertions(+), 113 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
index 7ad43af..211d97c 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c
@@ -108,7 +108,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 		list_del(&ce->list);
 		INIT_LIST_HEAD(&ce->list);
 		spin_lock_init(&ce->lock);
-		atomic_set(&ce->refcnt, 0);
+		refcount_set(&ce->refcnt, 0);
 		atomic_dec(&ctbl->nfree);
 		list_add_tail(&ce->list, &ctbl->hash_list[hash]);
 		if (v6) {
@@ -139,7 +139,7 @@ int cxgb4_clip_get(const struct net_device *dev, const u32 *lip, u8 v6)
 	}
 	write_unlock_bh(&ctbl->lock);
 found:
-	atomic_inc(&ce->refcnt);
+	refcount_inc(&ce->refcnt);
 
 	return 0;
 }
@@ -179,7 +179,7 @@ void cxgb4_clip_release(const struct net_device *dev, const u32 *lip, u8 v6)
 found:
 	write_lock_bh(&ctbl->lock);
 	spin_lock_bh(&ce->lock);
-	if (atomic_dec_and_test(&ce->refcnt)) {
+	if (refcount_dec_and_test(&ce->refcnt)) {
 		list_del(&ce->list);
 		INIT_LIST_HEAD(&ce->list);
 		list_add_tail(&ce->list, &ctbl->ce_free_head);
@@ -266,7 +266,7 @@ int clip_tbl_show(struct seq_file *seq, void *v)
 			ip[0] = '\0';
 			sprintf(ip, "%pISc", &ce->addr);
 			seq_printf(seq, "%-25s   %u\n", ip,
-				   atomic_read(&ce->refcnt));
+				   refcount_read(&ce->refcnt));
 		}
 	}
 	seq_printf(seq, "Free clip entries : %d\n", atomic_read(&ctbl->nfree));
diff --git a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
index 35eb43c..a0e0ae1 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/clip_tbl.h
@@ -10,9 +10,11 @@
  *  release for licensing terms and conditions.
  */
 
+#include <linux/refcount.h>
+
 struct clip_entry {
 	spinlock_t lock;	/* Hold while modifying clip reference */
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct list_head list;
 	union {
 		struct sockaddr_in addr;
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 3dd8788..ebf0c06 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1727,7 +1727,7 @@ static int mtk_open(struct net_device *dev)
 	struct mtk_eth *eth = mac->hw;
 
 	/* we run 2 netdevs on the same dma ring so we only bring it up once */
-	if (!atomic_read(&eth->dma_refcnt)) {
+	if (!refcount_read(&eth->dma_refcnt)) {
 		int err = mtk_start_dma(eth);
 
 		if (err)
@@ -1738,7 +1738,7 @@ static int mtk_open(struct net_device *dev)
 		mtk_irq_enable(eth, MTK_QDMA_INT_MASK, MTK_TX_DONE_INT);
 		mtk_irq_enable(eth, MTK_PDMA_INT_MASK, MTK_RX_DONE_INT);
 	}
-	atomic_inc(&eth->dma_refcnt);
+	refcount_inc(&eth->dma_refcnt);
 
 	phy_start(dev->phydev);
 	netif_start_queue(dev);
@@ -1778,7 +1778,7 @@ static int mtk_stop(struct net_device *dev)
 	phy_stop(dev->phydev);
 
 	/* only shutdown DMA if this is the last user */
-	if (!atomic_dec_and_test(&eth->dma_refcnt))
+	if (!refcount_dec_and_test(&eth->dma_refcnt))
 		return 0;
 
 	mtk_irq_disable(eth, MTK_QDMA_INT_MASK, MTK_TX_DONE_INT);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 99b1c8e..e5b99b7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -15,6 +15,8 @@
 #ifndef MTK_ETH_H
 #define MTK_ETH_H
 
+#include <linux/refcount.h>
+
 #define MTK_QDMA_PAGE_SIZE	2048
 #define	MTK_MAX_RX_LENGTH	1536
 #define MTK_TX_DMA_BUF_LEN	0x3fff
@@ -541,7 +543,7 @@ struct mtk_eth {
 	struct regmap			*pctl;
 	u32				chip_id;
 	bool				hwlro;
-	atomic_t			dma_refcnt;
+	refcount_t			dma_refcnt;
 	struct mtk_tx_ring		tx_ring;
 	struct mtk_rx_ring		rx_ring[MTK_MAX_RX_RING_NUM];
 	struct napi_struct		tx_napi;
diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index a849da9..7691cac 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -69,7 +69,7 @@ void mlx4_cq_tasklet_cb(unsigned long data)
 	list_for_each_entry_safe(mcq, temp, &ctx->process_list, tasklet_ctx.list) {
 		list_del_init(&mcq->tasklet_ctx.list);
 		mcq->tasklet_ctx.comp(mcq);
-		if (atomic_dec_and_test(&mcq->refcount))
+		if (refcount_dec_and_test(&mcq->refcount))
 			complete(&mcq->free);
 		if (time_after(jiffies, end))
 			break;
@@ -91,7 +91,7 @@ static void mlx4_add_cq_to_tasklet(struct mlx4_cq *cq)
 	 * still arrive.
 	 */
 	if (list_empty_careful(&cq->tasklet_ctx.list)) {
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 		list_add_tail(&cq->tasklet_ctx.list, &tasklet_ctx->list);
 	}
 	spin_unlock_irqrestore(&tasklet_ctx->lock, flags);
@@ -122,7 +122,7 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
 
 	cq = radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cqs - 1));
 	if (cq)
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 
 	spin_unlock(&cq_table->lock);
 
@@ -133,7 +133,7 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cqn, int event_type)
 
 	cq->event(cq, event_type);
 
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 }
 
@@ -337,7 +337,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	cq->cons_index = 0;
 	cq->arm_sn     = 1;
 	cq->uar        = uar;
-	atomic_set(&cq->refcount, 1);
+	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 	cq->comp = mlx4_add_cq_to_tasklet;
 	cq->tasklet_ctx.priv =
@@ -379,7 +379,7 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 	radix_tree_delete(&cq_table->tree, cq->cqn);
 	spin_unlock_irq(&cq_table->lock);
 
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 	wait_for_completion(&cq->free);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index d1cd9c3..6d15227 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -55,7 +55,7 @@ void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 
 	qp = __mlx4_qp_lookup(dev, qpn);
 	if (qp)
-		atomic_inc(&qp->refcount);
+		refcount_inc(&qp->refcount);
 
 	spin_unlock(&qp_table->lock);
 
@@ -66,7 +66,7 @@ void mlx4_qp_event(struct mlx4_dev *dev, u32 qpn, int event_type)
 
 	qp->event(qp, event_type);
 
-	if (atomic_dec_and_test(&qp->refcount))
+	if (refcount_dec_and_test(&qp->refcount))
 		complete(&qp->free);
 }
 
@@ -406,7 +406,7 @@ int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp, gfp_t gfp)
 	if (err)
 		goto err_icm;
 
-	atomic_set(&qp->refcount, 1);
+	refcount_set(&qp->refcount, 1);
 	init_completion(&qp->free);
 
 	return 0;
@@ -500,7 +500,7 @@ EXPORT_SYMBOL_GPL(mlx4_qp_remove);
 
 void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp)
 {
-	if (atomic_dec_and_test(&qp->refcount))
+	if (refcount_dec_and_test(&qp->refcount))
 		complete(&qp->free);
 	wait_for_completion(&qp->free);
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index f44d089..3369f65 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -49,7 +49,7 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 	srq = radix_tree_lookup(&srq_table->tree, srqn & (dev->caps.num_srqs - 1));
 	rcu_read_unlock();
 	if (srq)
-		atomic_inc(&srq->refcount);
+		refcount_inc(&srq->refcount);
 	else {
 		mlx4_warn(dev, "Async event for bogus SRQ %08x\n", srqn);
 		return;
@@ -57,7 +57,7 @@ void mlx4_srq_event(struct mlx4_dev *dev, u32 srqn, int event_type)
 
 	srq->event(srq, event_type);
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 }
 
@@ -203,7 +203,7 @@ int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcd,
 	if (err)
 		goto err_radix;
 
-	atomic_set(&srq->refcount, 1);
+	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
 
 	return 0;
@@ -232,7 +232,7 @@ void mlx4_srq_free(struct mlx4_dev *dev, struct mlx4_srq *srq)
 	radix_tree_delete(&srq_table->tree, srq->srqn);
 	spin_unlock_irq(&srq_table->lock);
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 	wait_for_completion(&srq->free);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 32d4af9..fa2917f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -58,7 +58,7 @@ void mlx5_cq_tasklet_cb(unsigned long data)
 				 tasklet_ctx.list) {
 		list_del_init(&mcq->tasklet_ctx.list);
 		mcq->tasklet_ctx.comp(mcq);
-		if (atomic_dec_and_test(&mcq->refcount))
+		if (refcount_dec_and_test(&mcq->refcount))
 			complete(&mcq->free);
 		if (time_after(jiffies, end))
 			break;
@@ -80,7 +80,7 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq)
 	 * still arrive.
 	 */
 	if (list_empty_careful(&cq->tasklet_ctx.list)) {
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 		list_add_tail(&cq->tasklet_ctx.list, &tasklet_ctx->list);
 	}
 	spin_unlock_irqrestore(&tasklet_ctx->lock, flags);
@@ -94,7 +94,7 @@ void mlx5_cq_completion(struct mlx5_core_dev *dev, u32 cqn)
 	spin_lock(&table->lock);
 	cq = radix_tree_lookup(&table->tree, cqn);
 	if (likely(cq))
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 	spin_unlock(&table->lock);
 
 	if (!cq) {
@@ -106,7 +106,7 @@ void mlx5_cq_completion(struct mlx5_core_dev *dev, u32 cqn)
 
 	cq->comp(cq);
 
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 }
 
@@ -119,7 +119,7 @@ void mlx5_cq_event(struct mlx5_core_dev *dev, u32 cqn, int event_type)
 
 	cq = radix_tree_lookup(&table->tree, cqn);
 	if (cq)
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 
 	spin_unlock(&table->lock);
 
@@ -130,7 +130,7 @@ void mlx5_cq_event(struct mlx5_core_dev *dev, u32 cqn, int event_type)
 
 	cq->event(cq, event_type);
 
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 }
 
@@ -159,7 +159,7 @@ int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	cq->cqn = MLX5_GET(create_cq_out, out, cqn);
 	cq->cons_index = 0;
 	cq->arm_sn     = 0;
-	atomic_set(&cq->refcount, 1);
+	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 	if (!cq->comp)
 		cq->comp = mlx5_add_cq_to_tasklet;
@@ -220,7 +220,7 @@ int mlx5_core_destroy_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
 	synchronize_irq(cq->irqn);
 
 	mlx5_debug_cq_remove(dev, cq);
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 	wait_for_completion(&cq->free);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index a263d89..affba72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -163,7 +163,7 @@ static void tree_init_node(struct fs_node *node,
 			   unsigned int refcount,
 			   void (*remove_func)(struct fs_node *))
 {
-	atomic_set(&node->refcount, refcount);
+	refcount_set(&node->refcount, refcount);
 	INIT_LIST_HEAD(&node->list);
 	INIT_LIST_HEAD(&node->children);
 	mutex_init(&node->lock);
@@ -173,7 +173,7 @@ static void tree_init_node(struct fs_node *node,
 static void tree_add_node(struct fs_node *node, struct fs_node *parent)
 {
 	if (parent)
-		atomic_inc(&parent->refcount);
+		refcount_inc(&parent->refcount);
 	node->parent = parent;
 
 	/* Parent is the root */
@@ -185,7 +185,7 @@ static void tree_add_node(struct fs_node *node, struct fs_node *parent)
 
 static void tree_get_node(struct fs_node *node)
 {
-	atomic_inc(&node->refcount);
+	refcount_inc(&node->refcount);
 }
 
 static void nested_lock_ref_node(struct fs_node *node,
@@ -193,7 +193,7 @@ static void nested_lock_ref_node(struct fs_node *node,
 {
 	if (node) {
 		mutex_lock_nested(&node->lock, class);
-		atomic_inc(&node->refcount);
+		refcount_inc(&node->refcount);
 	}
 }
 
@@ -201,14 +201,14 @@ static void lock_ref_node(struct fs_node *node)
 {
 	if (node) {
 		mutex_lock(&node->lock);
-		atomic_inc(&node->refcount);
+		refcount_inc(&node->refcount);
 	}
 }
 
 static void unlock_ref_node(struct fs_node *node)
 {
 	if (node) {
-		atomic_dec(&node->refcount);
+		refcount_dec(&node->refcount);
 		mutex_unlock(&node->lock);
 	}
 }
@@ -218,7 +218,7 @@ static void tree_put_node(struct fs_node *node)
 	struct fs_node *parent_node = node->parent;
 
 	lock_ref_node(parent_node);
-	if (atomic_dec_and_test(&node->refcount)) {
+	if (refcount_dec_and_test(&node->refcount)) {
 		if (parent_node)
 			list_del_init(&node->list);
 		if (node->remove_func)
@@ -233,8 +233,8 @@ static void tree_put_node(struct fs_node *node)
 
 static int tree_remove_node(struct fs_node *node)
 {
-	if (atomic_read(&node->refcount) > 1) {
-		atomic_dec(&node->refcount);
+	if (refcount_read(&node->refcount) > 1) {
+		refcount_dec(&node->refcount);
 		return -EEXIST;
 	}
 	tree_put_node(node);
@@ -982,7 +982,7 @@ static void destroy_flow_handle(struct fs_fte *fte,
 				int i)
 {
 	for (; --i >= 0;) {
-		if (atomic_dec_and_test(&handle->rule[i]->node.refcount)) {
+		if (refcount_dec_and_test(&handle->rule[i]->node.refcount)) {
 			fte->dests_size--;
 			list_del(&handle->rule[i]->node.list);
 			kfree(handle->rule[i]);
@@ -1013,7 +1013,7 @@ create_flow_handle(struct fs_fte *fte,
 		if (dest) {
 			rule = find_flow_rule(fte, dest + i);
 			if (rule) {
-				atomic_inc(&rule->node.refcount);
+				refcount_inc(&rule->node.refcount);
 				goto rule_found;
 			}
 		}
@@ -1273,7 +1273,7 @@ static struct mlx5_flow_handle *add_rule_fg(struct mlx5_flow_group *fg,
 	list_add(&fte->node.list, prev);
 add_rules:
 	for (i = 0; i < handle->num_rules; i++) {
-		if (atomic_read(&handle->rule[i]->node.refcount) == 1)
+		if (refcount_read(&handle->rule[i]->node.refcount) == 1)
 			tree_add_node(&handle->rule[i]->node, &fte->node);
 	}
 unlock_fte:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
index 8e668c6..86bc743 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -33,6 +33,7 @@
 #ifndef _MLX5_FS_CORE_
 #define _MLX5_FS_CORE_
 
+#include <linux/refcount.h>
 #include <linux/mlx5/fs.h>
 
 enum fs_node_type {
@@ -80,7 +81,7 @@ struct fs_node {
 	struct fs_node		*root;
 	/* lock the node for writing and traversing */
 	struct mutex		lock;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	void			(*remove_func)(struct fs_node *);
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/qp.c b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
index d0a4005..4af636f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/qp.c
@@ -50,7 +50,7 @@ static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
 
 	common = radix_tree_lookup(&table->tree, rsn);
 	if (common)
-		atomic_inc(&common->refcount);
+		refcount_inc(&common->refcount);
 
 	spin_unlock(&table->lock);
 
@@ -64,7 +64,7 @@ static struct mlx5_core_rsc_common *mlx5_get_rsc(struct mlx5_core_dev *dev,
 
 void mlx5_core_put_rsc(struct mlx5_core_rsc_common *common)
 {
-	if (atomic_dec_and_test(&common->refcount))
+	if (refcount_dec_and_test(&common->refcount))
 		complete(&common->free);
 }
 
@@ -248,7 +248,7 @@ static int create_qprqsq_common(struct mlx5_core_dev *dev,
 	if (err)
 		return err;
 
-	atomic_set(&qp->common.refcount, 1);
+	refcount_set(&qp->common.refcount, 1);
 	init_completion(&qp->common.free);
 	qp->pid = current->pid;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/srq.c b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
index 30996300..8d6c1d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/srq.c
@@ -48,7 +48,7 @@ void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type)
 
 	srq = radix_tree_lookup(&table->tree, srqn);
 	if (srq)
-		atomic_inc(&srq->refcount);
+		refcount_inc(&srq->refcount);
 
 	spin_unlock(&table->lock);
 
@@ -59,7 +59,7 @@ void mlx5_srq_event(struct mlx5_core_dev *dev, u32 srqn, int event_type)
 
 	srq->event(srq, event_type);
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 }
 
@@ -141,7 +141,7 @@ struct mlx5_core_srq *mlx5_core_get_srq(struct mlx5_core_dev *dev, u32 srqn)
 
 	srq = radix_tree_lookup(&table->tree, srqn);
 	if (srq)
-		atomic_inc(&srq->refcount);
+		refcount_inc(&srq->refcount);
 
 	spin_unlock(&table->lock);
 
@@ -473,7 +473,7 @@ int mlx5_core_create_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq,
 	if (err)
 		return err;
 
-	atomic_set(&srq->refcount, 1);
+	refcount_set(&srq->refcount, 1);
 	init_completion(&srq->free);
 
 	spin_lock_irq(&table->lock);
@@ -515,7 +515,7 @@ int mlx5_core_destroy_srq(struct mlx5_core_dev *dev, struct mlx5_core_srq *srq)
 	if (err)
 		return err;
 
-	if (atomic_dec_and_test(&srq->refcount))
+	if (refcount_dec_and_test(&srq->refcount))
 		complete(&srq->free);
 	wait_for_completion(&srq->free);
 
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index f90d1af..7c39e39 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -9480,7 +9480,7 @@ static struct niu_parent *niu_new_parent(struct niu *np,
 	memcpy(&p->id, id, sizeof(*id));
 	p->plat_type = ptype;
 	INIT_LIST_HEAD(&p->list);
-	atomic_set(&p->refcnt, 0);
+	refcount_set(&p->refcnt, 0);
 	list_add(&p->list, &niu_parent_list);
 	spin_lock_init(&p->lock);
 
@@ -9540,7 +9540,7 @@ static struct niu_parent *niu_get_parent(struct niu *np,
 					port_name);
 		if (!err) {
 			p->ports[port] = np;
-			atomic_inc(&p->refcnt);
+			refcount_inc(&p->refcnt);
 		}
 	}
 	mutex_unlock(&niu_parent_lock);
@@ -9568,7 +9568,7 @@ static void niu_put_parent(struct niu *np)
 	p->ports[port] = NULL;
 	np->parent = NULL;
 
-	if (atomic_dec_and_test(&p->refcnt)) {
+	if (refcount_dec_and_test(&p->refcnt)) {
 		list_del(&p->list);
 		platform_device_unregister(p->plat_dev);
 	}
diff --git a/drivers/net/ethernet/sun/niu.h b/drivers/net/ethernet/sun/niu.h
index 51e177e..fc3d2b7 100644
--- a/drivers/net/ethernet/sun/niu.h
+++ b/drivers/net/ethernet/sun/niu.h
@@ -6,6 +6,8 @@
 #ifndef _NIU_H
 #define _NIU_H
 
+#include <linux/refcount.h>
+
 #define PIO			0x000000UL
 #define FZC_PIO			0x080000UL
 #define FZC_MAC			0x180000UL
@@ -3070,7 +3072,7 @@ struct niu_parent {
 
 	struct niu		*ports[NIU_MAX_PORTS];
 
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct list_head	list;
 
 	spinlock_t		lock;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 922bf44..ea6c975 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -35,7 +35,7 @@
 #include <linux/tcp.h>
 #include <linux/semaphore.h>
 #include <linux/compat.h>
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #define SIXPACK_VERSION    "Revision: 0.3.0"
 
@@ -120,7 +120,7 @@ struct sixpack {
 
 	struct timer_list	tx_t;
 	struct timer_list	resync_t;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 	struct semaphore	dead_sem;
 	spinlock_t		lock;
 };
@@ -381,7 +381,7 @@ static struct sixpack *sp_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	sp = tty->disc_data;
 	if (sp)
-		atomic_inc(&sp->refcnt);
+		refcount_inc(&sp->refcnt);
 	read_unlock(&disc_data_lock);
 
 	return sp;
@@ -389,7 +389,7 @@ static struct sixpack *sp_get(struct tty_struct *tty)
 
 static void sp_put(struct sixpack *sp)
 {
-	if (atomic_dec_and_test(&sp->refcnt))
+	if (refcount_dec_and_test(&sp->refcnt))
 		up(&sp->dead_sem);
 }
 
@@ -580,7 +580,7 @@ static int sixpack_open(struct tty_struct *tty)
 	sp->dev = dev;
 
 	spin_lock_init(&sp->lock);
-	atomic_set(&sp->refcnt, 1);
+	refcount_set(&sp->refcnt, 1);
 	sema_init(&sp->dead_sem, 0);
 
 	/* !!! length of the buffers. MTU is IP MTU, not PACLEN!  */
@@ -676,7 +676,7 @@ static void sixpack_close(struct tty_struct *tty)
 	 * We have now ensured that nobody can start using ap from now on, but
 	 * we have to wait for all existing users to finish.
 	 */
-	if (!atomic_dec_and_test(&sp->refcnt))
+	if (!refcount_dec_and_test(&sp->refcnt))
 		down(&sp->dead_sem);
 
 	/* We must stop the queue to avoid potentially scribbling
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f83cf66..ec7b017 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -16,6 +16,7 @@
 #include <crypto/aead.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
+#include <linux/refcount.h>
 #include <net/genetlink.h>
 #include <net/sock.h>
 #include <net/gro_cells.h>
@@ -146,7 +147,7 @@ struct macsec_rx_sa {
 	struct macsec_key key;
 	spinlock_t lock;
 	u32 next_pn;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	bool active;
 	struct macsec_rx_sa_stats __percpu *stats;
 	struct macsec_rx_sc *sc;
@@ -171,7 +172,7 @@ struct macsec_rx_sc {
 	bool active;
 	struct macsec_rx_sa __rcu *sa[MACSEC_NUM_AN];
 	struct pcpu_rx_sc_stats __percpu *stats;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	struct rcu_head rcu_head;
 };
 
@@ -187,7 +188,7 @@ struct macsec_tx_sa {
 	struct macsec_key key;
 	spinlock_t lock;
 	u32 next_pn;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	bool active;
 	struct macsec_tx_sa_stats __percpu *stats;
 	struct rcu_head rcu;
@@ -314,7 +315,7 @@ static struct macsec_rx_sa *macsec_rxsa_get(struct macsec_rx_sa __rcu *ptr)
 	if (!sa || !sa->active)
 		return NULL;
 
-	if (!atomic_inc_not_zero(&sa->refcnt))
+	if (!refcount_inc_not_zero(&sa->refcnt))
 		return NULL;
 
 	return sa;
@@ -330,12 +331,12 @@ static void free_rx_sc_rcu(struct rcu_head *head)
 
 static struct macsec_rx_sc *macsec_rxsc_get(struct macsec_rx_sc *sc)
 {
-	return atomic_inc_not_zero(&sc->refcnt) ? sc : NULL;
+	return refcount_inc_not_zero(&sc->refcnt) ? sc : NULL;
 }
 
 static void macsec_rxsc_put(struct macsec_rx_sc *sc)
 {
-	if (atomic_dec_and_test(&sc->refcnt))
+	if (refcount_dec_and_test(&sc->refcnt))
 		call_rcu(&sc->rcu_head, free_rx_sc_rcu);
 }
 
@@ -350,7 +351,7 @@ static void free_rxsa(struct rcu_head *head)
 
 static void macsec_rxsa_put(struct macsec_rx_sa *sa)
 {
-	if (atomic_dec_and_test(&sa->refcnt))
+	if (refcount_dec_and_test(&sa->refcnt))
 		call_rcu(&sa->rcu, free_rxsa);
 }
 
@@ -361,7 +362,7 @@ static struct macsec_tx_sa *macsec_txsa_get(struct macsec_tx_sa __rcu *ptr)
 	if (!sa || !sa->active)
 		return NULL;
 
-	if (!atomic_inc_not_zero(&sa->refcnt))
+	if (!refcount_inc_not_zero(&sa->refcnt))
 		return NULL;
 
 	return sa;
@@ -378,7 +379,7 @@ static void free_txsa(struct rcu_head *head)
 
 static void macsec_txsa_put(struct macsec_tx_sa *sa)
 {
-	if (atomic_dec_and_test(&sa->refcnt))
+	if (refcount_dec_and_test(&sa->refcnt))
 		call_rcu(&sa->rcu, free_txsa);
 }
 
@@ -1321,7 +1322,7 @@ static int init_rx_sa(struct macsec_rx_sa *rx_sa, char *sak, int key_len,
 
 	rx_sa->active = false;
 	rx_sa->next_pn = 1;
-	atomic_set(&rx_sa->refcnt, 1);
+	refcount_set(&rx_sa->refcnt, 1);
 	spin_lock_init(&rx_sa->lock);
 
 	return 0;
@@ -1392,7 +1393,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 
 	rx_sc->sci = sci;
 	rx_sc->active = true;
-	atomic_set(&rx_sc->refcnt, 1);
+	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
 	rcu_assign_pointer(rx_sc->next, secy->rx_sc);
@@ -1418,7 +1419,7 @@ static int init_tx_sa(struct macsec_tx_sa *tx_sa, char *sak, int key_len,
 	}
 
 	tx_sa->active = false;
-	atomic_set(&tx_sa->refcnt, 1);
+	refcount_set(&tx_sa->refcnt, 1);
 	spin_lock_init(&tx_sa->lock);
 
 	return 0;
diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index feb9569..2d08f7e 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -69,7 +69,7 @@ struct asyncppp {
 
 	struct tasklet_struct tsk;
 
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	struct semaphore dead_sem;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 	unsigned char	obuf[OBUFSIZE];
@@ -140,14 +140,14 @@ static struct asyncppp *ap_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	ap = tty->disc_data;
 	if (ap != NULL)
-		atomic_inc(&ap->refcnt);
+		refcount_inc(&ap->refcnt);
 	read_unlock(&disc_data_lock);
 	return ap;
 }
 
 static void ap_put(struct asyncppp *ap)
 {
-	if (atomic_dec_and_test(&ap->refcnt))
+	if (refcount_dec_and_test(&ap->refcnt))
 		up(&ap->dead_sem);
 }
 
@@ -185,7 +185,7 @@ ppp_asynctty_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
 
-	atomic_set(&ap->refcnt, 1);
+	refcount_set(&ap->refcnt, 1);
 	sema_init(&ap->dead_sem, 0);
 
 	ap->chan.private = ap;
@@ -234,7 +234,7 @@ ppp_asynctty_close(struct tty_struct *tty)
 	 * our channel ops (i.e. ppp_async_send/ioctl) are in progress
 	 * by the time it returns.
 	 */
-	if (!atomic_dec_and_test(&ap->refcnt))
+	if (!refcount_dec_and_test(&ap->refcnt))
 		down(&ap->dead_sem);
 	tasklet_kill(&ap->tsk);
 
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 3d3b1f4..474a7ec 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -50,6 +50,7 @@
 #include <asm/unaligned.h>
 #include <net/slhc_vj.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
@@ -83,7 +84,7 @@ struct ppp_file {
 	struct sk_buff_head xq;		/* pppd transmit queue */
 	struct sk_buff_head rq;		/* receive queue for pppd */
 	wait_queue_head_t rwait;	/* for poll on reading /dev/ppp */
-	atomic_t	refcnt;		/* # refs (incl /dev/ppp attached) */
+	refcount_t	refcnt;		/* # refs (incl /dev/ppp attached) */
 	int		hdrlen;		/* space to leave for headers */
 	int		index;		/* interface unit / channel number */
 	int		dead;		/* unit/channel has been shut down */
@@ -406,7 +407,7 @@ static int ppp_release(struct inode *unused, struct file *file)
 				unregister_netdevice(ppp->dev);
 			rtnl_unlock();
 		}
-		if (atomic_dec_and_test(&pf->refcnt)) {
+		if (refcount_dec_and_test(&pf->refcnt)) {
 			switch (pf->kind) {
 			case INTERFACE:
 				ppp_destroy_interface(PF_TO_PPP(pf));
@@ -879,7 +880,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 		mutex_lock(&pn->all_ppp_mutex);
 		ppp = ppp_find_unit(pn, unit);
 		if (ppp) {
-			atomic_inc(&ppp->file.refcnt);
+			refcount_inc(&ppp->file.refcnt);
 			file->private_data = &ppp->file;
 			err = 0;
 		}
@@ -894,7 +895,7 @@ static int ppp_unattached_ioctl(struct net *net, struct ppp_file *pf,
 		spin_lock_bh(&pn->all_channels_lock);
 		chan = ppp_find_channel(pn, unit);
 		if (chan) {
-			atomic_inc(&chan->file.refcnt);
+			refcount_inc(&chan->file.refcnt);
 			file->private_data = &chan->file;
 			err = 0;
 		}
@@ -2642,7 +2643,7 @@ ppp_unregister_channel(struct ppp_channel *chan)
 
 	pch->file.dead = 1;
 	wake_up_interruptible(&pch->file.rwait);
-	if (atomic_dec_and_test(&pch->file.refcnt))
+	if (refcount_dec_and_test(&pch->file.refcnt))
 		ppp_destroy_channel(pch);
 }
 
@@ -3012,7 +3013,7 @@ init_ppp_file(struct ppp_file *pf, int kind)
 	pf->kind = kind;
 	skb_queue_head_init(&pf->xq);
 	skb_queue_head_init(&pf->rq);
-	atomic_set(&pf->refcnt, 1);
+	refcount_set(&pf->refcnt, 1);
 	init_waitqueue_head(&pf->rwait);
 }
 
@@ -3129,7 +3130,7 @@ ppp_connect_channel(struct channel *pch, int unit)
 	list_add_tail(&pch->clist, &ppp->channels);
 	++ppp->n_channels;
 	pch->ppp = ppp;
-	atomic_inc(&ppp->file.refcnt);
+	refcount_inc(&ppp->file.refcnt);
 	ppp_unlock(ppp);
 	ret = 0;
 
@@ -3160,7 +3161,7 @@ ppp_disconnect_channel(struct channel *pch)
 		if (--ppp->n_channels == 0)
 			wake_up_interruptible(&ppp->file.rwait);
 		ppp_unlock(ppp);
-		if (atomic_dec_and_test(&ppp->file.refcnt))
+		if (refcount_dec_and_test(&ppp->file.refcnt))
 			ppp_destroy_interface(ppp);
 		err = 0;
 	}
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 9ae5398..4a643f8 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -46,6 +46,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
+#include <linux/refcount.h>
 #include <asm/unaligned.h>
 #include <linux/uaccess.h>
 
@@ -72,7 +73,7 @@ struct syncppp {
 
 	struct tasklet_struct tsk;
 
-	atomic_t	refcnt;
+	refcount_t	refcnt;
 	struct completion dead_cmp;
 	struct ppp_channel chan;	/* interface to generic ppp layer */
 };
@@ -141,14 +142,14 @@ static struct syncppp *sp_get(struct tty_struct *tty)
 	read_lock(&disc_data_lock);
 	ap = tty->disc_data;
 	if (ap != NULL)
-		atomic_inc(&ap->refcnt);
+		refcount_inc(&ap->refcnt);
 	read_unlock(&disc_data_lock);
 	return ap;
 }
 
 static void sp_put(struct syncppp *ap)
 {
-	if (atomic_dec_and_test(&ap->refcnt))
+	if (refcount_dec_and_test(&ap->refcnt))
 		complete(&ap->dead_cmp);
 }
 
@@ -182,7 +183,7 @@ ppp_sync_open(struct tty_struct *tty)
 	skb_queue_head_init(&ap->rqueue);
 	tasklet_init(&ap->tsk, ppp_sync_process, (unsigned long) ap);
 
-	atomic_set(&ap->refcnt, 1);
+	refcount_set(&ap->refcnt, 1);
 	init_completion(&ap->dead_cmp);
 
 	ap->chan.private = ap;
@@ -232,7 +233,7 @@ ppp_sync_close(struct tty_struct *tty)
 	 * our channel ops (i.e. ppp_sync_send/ioctl) are in progress
 	 * by the time it returns.
 	 */
-	if (!atomic_dec_and_test(&ap->refcnt))
+	if (!refcount_dec_and_test(&ap->refcnt))
 		wait_for_completion(&ap->dead_cmp);
 	tasklet_kill(&ap->tsk);
 
diff --git a/drivers/net/wireless/intersil/hostap/hostap_hw.c b/drivers/net/wireless/intersil/hostap/hostap_hw.c
index 544ef7a..d147bcd 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_hw.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_hw.c
@@ -190,7 +190,7 @@ static inline void __hostap_cmd_queue_free(local_info_t *local,
 		}
 	}
 
-	if (atomic_dec_and_test(&entry->usecnt) && entry->del_req)
+	if (refcount_dec_and_test(&entry->usecnt) && entry->del_req)
 		kfree(entry);
 }
 
@@ -228,7 +228,7 @@ static void prism2_clear_cmd_queue(local_info_t *local)
 	spin_lock_irqsave(&local->cmdlock, flags);
 	list_for_each_safe(ptr, n, &local->cmd_queue) {
 		entry = list_entry(ptr, struct hostap_cmd_queue, list);
-		atomic_inc(&entry->usecnt);
+		refcount_inc(&entry->usecnt);
 		printk(KERN_DEBUG "%s: removed pending cmd_queue entry "
 		       "(type=%d, cmd=0x%04x, param0=0x%04x)\n",
 		       local->dev->name, entry->type, entry->cmd,
@@ -350,7 +350,7 @@ static int hfa384x_cmd(struct net_device *dev, u16 cmd, u16 param0,
 	if (entry == NULL)
 		return -ENOMEM;
 
-	atomic_set(&entry->usecnt, 1);
+	refcount_set(&entry->usecnt, 1);
 	entry->type = CMD_SLEEP;
 	entry->cmd = cmd;
 	entry->param0 = param0;
@@ -516,7 +516,7 @@ static int hfa384x_cmd_callback(struct net_device *dev, u16 cmd, u16 param0,
 	if (entry == NULL)
 		return -ENOMEM;
 
-	atomic_set(&entry->usecnt, 1);
+	refcount_set(&entry->usecnt, 1);
 	entry->type = CMD_CALLBACK;
 	entry->cmd = cmd;
 	entry->param0 = param0;
@@ -666,7 +666,7 @@ static void prism2_cmd_ev(struct net_device *dev)
 	if (!list_empty(&local->cmd_queue)) {
 		entry = list_entry(local->cmd_queue.next,
 				   struct hostap_cmd_queue, list);
-		atomic_inc(&entry->usecnt);
+		refcount_inc(&entry->usecnt);
 		list_del_init(&entry->list);
 		local->cmd_queue_len--;
 
@@ -718,7 +718,7 @@ static void prism2_cmd_ev(struct net_device *dev)
 			entry = NULL;
 		}
 		if (entry)
-			atomic_inc(&entry->usecnt);
+			refcount_inc(&entry->usecnt);
 	}
 	spin_unlock(&local->cmdlock);
 
diff --git a/drivers/net/wireless/intersil/hostap/hostap_wlan.h b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
index ca25283..5352adb 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/intersil/hostap/hostap_wlan.h
@@ -6,6 +6,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 #include <net/iw_handler.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/lib80211.h>
@@ -557,7 +558,7 @@ struct hostap_cmd_queue {
 	u16 resp0, res;
 	volatile int issued, issuing;
 
-	atomic_t usecnt;
+	refcount_t usecnt;
 	int del_req;
 };
 
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index bca6935..465ea53 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -64,6 +64,7 @@
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
 #include <linux/firmware.h>
+#include <linux/refcount.h>
 
 #include "mic.h"
 #include "orinoco.h"
@@ -268,7 +269,7 @@ enum ezusb_state {
 
 struct request_context {
 	struct list_head list;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion done;	/* Signals that CTX is dead */
 	int killed;
 	struct urb *outurb;	/* OUT for req pkt */
@@ -298,7 +299,7 @@ static inline u8 ezusb_reply_inc(u8 count)
 
 static void ezusb_request_context_put(struct request_context *ctx)
 {
-	if (!atomic_dec_and_test(&ctx->refcount))
+	if (!refcount_dec_and_test(&ctx->refcount))
 		return;
 
 	WARN_ON(!ctx->done.done);
@@ -328,7 +329,7 @@ static void ezusb_request_timerfn(u_long _ctx)
 	} else {
 		ctx->state = EZUSB_CTX_RESP_TIMEOUT;
 		dev_dbg(&ctx->outurb->dev->dev, "couldn't unlink\n");
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 		ctx->killed = 1;
 		ezusb_ctx_complete(ctx);
 		ezusb_request_context_put(ctx);
@@ -361,7 +362,7 @@ static struct request_context *ezusb_alloc_ctx(struct ezusb_priv *upriv,
 	ctx->out_rid = out_rid;
 	ctx->in_rid = in_rid;
 
-	atomic_set(&ctx->refcount, 1);
+	refcount_set(&ctx->refcount, 1);
 	init_completion(&ctx->done);
 
 	setup_timer(&ctx->timer, ezusb_request_timerfn, (u_long)ctx);
@@ -470,7 +471,7 @@ static void ezusb_req_queue_run(struct ezusb_priv *upriv)
 	list_move_tail(&ctx->list, &upriv->req_active);
 
 	if (ctx->state == EZUSB_CTX_QUEUED) {
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 		result = usb_submit_urb(ctx->outurb, GFP_ATOMIC);
 		if (result) {
 			ctx->state = EZUSB_CTX_REQSUBMIT_FAIL;
@@ -508,7 +509,7 @@ static void ezusb_req_enqueue_run(struct ezusb_priv *upriv,
 		spin_unlock_irqrestore(&upriv->req_lock, flags);
 		goto done;
 	}
-	atomic_inc(&ctx->refcount);
+	refcount_inc(&ctx->refcount);
 	list_add_tail(&ctx->list, &upriv->req_pending);
 	spin_unlock_irqrestore(&upriv->req_lock, flags);
 
@@ -1465,7 +1466,7 @@ static inline void ezusb_delete(struct ezusb_priv *upriv)
 		int err;
 
 		ctx = list_entry(item, struct request_context, list);
-		atomic_inc(&ctx->refcount);
+		refcount_inc(&ctx->refcount);
 
 		ctx->outurb->transfer_flags |= URB_ASYNC_UNLINK;
 		err = usb_unlink_urb(ctx->outurb);
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 93bdb34..d65d06f 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -40,7 +40,7 @@
 #include <linux/cpu_rmap.h>
 #include <linux/crash_dump.h>
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 
 #include <linux/timecounter.h>
 
@@ -738,7 +738,7 @@ struct mlx4_cq {
 	int			cqn;
 	unsigned		vector;
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 	struct {
 		struct list_head list;
@@ -754,7 +754,7 @@ struct mlx4_qp {
 
 	int			qpn;
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
@@ -766,7 +766,7 @@ struct mlx4_srq {
 	int			max_gs;
 	int			wqe_shift;
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 7c3c0d3..8a783ee 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -35,14 +35,14 @@
 
 #include <rdma/ib_verbs.h>
 #include <linux/mlx5/driver.h>
-
+#include <linux/refcount.h>
 
 struct mlx5_core_cq {
 	u32			cqn;
 	int			cqe_sz;
 	__be32		       *set_ci_db;
 	__be32		       *arm_db;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 	unsigned		vector;
 	unsigned int		irqn;
diff --git a/net/netfilter/nfnetlink_acct.c b/net/netfilter/nfnetlink_acct.c
index f44cbd3..c86da17 100644
--- a/net/netfilter/nfnetlink_acct.c
+++ b/net/netfilter/nfnetlink_acct.c
@@ -326,7 +326,6 @@ static int nfnl_acct_get(struct net *net, struct sock *nfnl,
 static int nfnl_acct_try_del(struct nf_acct *cur)
 {
 	int ret = 0;
-	unsigned int refcount;
 
 	/* We want to avoid races with nfnl_acct_put. So only when the current
 	 * refcnt is 1, we decrease it to 0.
-- 
2.7.4
