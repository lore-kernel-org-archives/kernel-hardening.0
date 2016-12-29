Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 29 Dec 2016 08:56:10 +0200
Message-Id: <1482994571-18687-19-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC PATCH 18/19] drivers: infiniband convert from atomic_t to refcount_t
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org, ishkamiel@gmail.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. Convert the cases found.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
---
 drivers/infiniband/core/addr.c              |   8 +--
 drivers/infiniband/core/cm.c                |  26 +++----
 drivers/infiniband/core/cma.c               |  29 ++++----
 drivers/infiniband/core/cq.c                |   4 +-
 drivers/infiniband/core/iwcm.c              |  10 +--
 drivers/infiniband/core/iwcm.h              |   4 +-
 drivers/infiniband/core/iwpm_util.c         |   8 +--
 drivers/infiniband/core/iwpm_util.h         |   3 +-
 drivers/infiniband/core/mad.c               |  36 +++++-----
 drivers/infiniband/core/mad_priv.h          |   5 +-
 drivers/infiniband/core/mad_rmpp.c          |  11 +--
 drivers/infiniband/core/multicast.c         |  31 +++++----
 drivers/infiniband/core/uverbs.h            |   4 +-
 drivers/infiniband/core/uverbs_cmd.c        |  74 ++++++++++----------
 drivers/infiniband/core/uverbs_main.c       |  14 ++--
 drivers/infiniband/core/verbs.c             | 102 ++++++++++++++--------------
 drivers/infiniband/hw/cxgb3/iwch_ev.c       |   8 +--
 drivers/infiniband/hw/cxgb3/iwch_provider.c |  16 ++---
 drivers/infiniband/hw/cxgb3/iwch_provider.h |   5 +-
 drivers/infiniband/hw/cxgb3/iwch_qp.c       |   4 +-
 drivers/infiniband/hw/cxgb4/cq.c            |   6 +-
 drivers/infiniband/hw/cxgb4/ev.c            |   8 +--
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h      |   3 +-
 drivers/infiniband/hw/hfi1/qp.c             |   2 +-
 drivers/infiniband/hw/hfi1/ruc.c            |   2 +-
 drivers/infiniband/hw/hfi1/user_sdma.c      |  13 ++--
 drivers/infiniband/hw/hns/hns_roce_cq.c     |   8 +--
 drivers/infiniband/hw/hns/hns_roce_device.h |   5 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c     |  10 +--
 drivers/infiniband/hw/i40iw/i40iw.h         |   3 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c      |  50 +++++++-------
 drivers/infiniband/hw/i40iw/i40iw_main.c    |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_puda.h    |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_utils.c   |  16 ++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c   |   2 +-
 drivers/infiniband/hw/i40iw/i40iw_verbs.h   |   4 +-
 drivers/infiniband/hw/mlx4/mcg.c            |  39 +++++------
 drivers/infiniband/hw/mlx5/cq.c             |   2 +-
 drivers/infiniband/hw/mlx5/main.c           |  20 +++---
 drivers/infiniband/hw/nes/nes.c             |   8 +--
 drivers/infiniband/hw/nes/nes_cm.c          |  28 ++++----
 drivers/infiniband/hw/nes/nes_cm.h          |   6 +-
 drivers/infiniband/hw/nes/nes_hw.c          |   8 +--
 drivers/infiniband/hw/nes/nes_hw.h          |   4 +-
 drivers/infiniband/hw/nes/nes_mgt.c         |   6 +-
 drivers/infiniband/hw/nes/nes_utils.c       |   4 +-
 drivers/infiniband/hw/nes/nes_verbs.c       |  44 ++++++------
 drivers/infiniband/hw/nes/nes_verbs.h       |   6 +-
 drivers/infiniband/hw/qib/qib_keys.c        |   4 +-
 drivers/infiniband/hw/qib/qib_ruc.c         |   2 +-
 drivers/infiniband/sw/rdmavt/ah.c           |   4 +-
 drivers/infiniband/sw/rdmavt/mr.c           |   6 +-
 drivers/infiniband/sw/rdmavt/qp.c           |   8 +--
 drivers/infiniband/ulp/ipoib/ipoib.h        |   5 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |   8 +--
 include/linux/mlx5/driver.h                 |   5 +-
 include/rdma/ib_addr.h                      |   3 +-
 include/rdma/ib_verbs.h                     |  15 ++--
 include/rdma/rdmavt_mr.h                    |   6 +-
 include/rdma/rdmavt_qp.h                    |   6 +-
 60 files changed, 408 insertions(+), 379 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 0f58f46..10cf06d 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -213,14 +213,14 @@ static struct rdma_addr_client self;
 
 void rdma_addr_register_client(struct rdma_addr_client *client)
 {
-	atomic_set(&client->refcount, 1);
+	refcount_set(&client->refcount, 1);
 	init_completion(&client->comp);
 }
 EXPORT_SYMBOL(rdma_addr_register_client);
 
 static inline void put_client(struct rdma_addr_client *client)
 {
-	if (atomic_dec_and_test(&client->refcount))
+	if (refcount_dec_and_test(&client->refcount))
 		complete(&client->comp);
 }
 
@@ -633,7 +633,7 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	req->callback = callback;
 	req->context = context;
 	req->client = client;
-	atomic_inc(&client->refcount);
+	refcount_inc(&client->refcount);
 	req->seq = (u32)atomic_inc_return(&ib_nl_addr_request_seq);
 
 	req->status = addr_resolve(src_in, dst_in, addr, true, req->seq);
@@ -648,7 +648,7 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 		break;
 	default:
 		ret = req->status;
-		atomic_dec(&client->refcount);
+		refcount_dec(&client->refcount);
 		goto err;
 	}
 	return ret;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index cf1edfa..cc9c3af 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -48,6 +48,7 @@
 #include <linux/workqueue.h>
 #include <linux/kdev_t.h>
 #include <linux/etherdevice.h>
+#include <linux/refcount.h>
 
 #include <rdma/ib_cache.h>
 #include <rdma/ib_cm.h>
@@ -262,7 +263,7 @@ struct cm_id_private {
 	struct rb_node sidr_id_node;
 	spinlock_t lock;	/* Do not acquire inside cm.lock */
 	struct completion comp;
-	atomic_t refcount;
+	refcount_t refcount;
 	/* Number of clients sharing this ib_cm_id. Only valid for listeners.
 	 * Protected by the cm.lock spinlock. */
 	int listen_sharecount;
@@ -307,7 +308,7 @@ static void cm_work_handler(struct work_struct *work);
 
 static inline void cm_deref_id(struct cm_id_private *cm_id_priv)
 {
-	if (atomic_dec_and_test(&cm_id_priv->refcount))
+	if (refcount_dec_and_test(&cm_id_priv->refcount))
 		complete(&cm_id_priv->comp);
 }
 
@@ -364,7 +365,7 @@ static int cm_alloc_msg(struct cm_id_private *cm_id_priv,
 	m->ah = ah;
 	m->retries = cm_id_priv->max_cm_retries;
 
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 	m->context[0] = cm_id_priv;
 	*msg = m;
 
@@ -522,7 +523,7 @@ static struct cm_id_private * cm_get_id(__be32 local_id, __be32 remote_id)
 			      (__force int) (local_id ^ cm.random_id_operand));
 	if (cm_id_priv) {
 		if (cm_id_priv->id.remote_id == remote_id)
-			atomic_inc(&cm_id_priv->refcount);
+			refcount_inc(&cm_id_priv->refcount);
 		else
 			cm_id_priv = NULL;
 	}
@@ -779,7 +780,7 @@ struct ib_cm_id *ib_create_cm_id(struct ib_device *device,
 	INIT_LIST_HEAD(&cm_id_priv->prim_list);
 	INIT_LIST_HEAD(&cm_id_priv->altr_list);
 	atomic_set(&cm_id_priv->work_count, -1);
-	atomic_set(&cm_id_priv->refcount, 1);
+	refcount_set(&cm_id_priv->refcount, 1);
 	return &cm_id_priv->id;
 
 error:
@@ -1123,7 +1124,7 @@ struct ib_cm_id *ib_cm_insert_listen(struct ib_device *device,
 			spin_unlock_irqrestore(&cm.lock, flags);
 			return ERR_PTR(-EINVAL);
 		}
-		atomic_inc(&cm_id_priv->refcount);
+		refcount_inc(&cm_id_priv->refcount);
 		++cm_id_priv->listen_sharecount;
 		spin_unlock_irqrestore(&cm.lock, flags);
 
@@ -1678,8 +1679,8 @@ static struct cm_id_private * cm_match_req(struct cm_work *work,
 			     NULL, 0);
 		goto out;
 	}
-	atomic_inc(&listen_cm_id_priv->refcount);
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&listen_cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 	cm_id_priv->id.state = IB_CM_REQ_RCVD;
 	atomic_inc(&cm_id_priv->work_count);
 	spin_unlock_irq(&cm.lock);
@@ -1822,7 +1823,8 @@ static int cm_req_handler(struct cm_work *work)
 	return 0;
 
 rejected:
-	atomic_dec(&cm_id_priv->refcount);
+	/* FIXME: make sure we're expecting non-zero! */
+	refcount_dec(&cm_id_priv->refcount);
 	cm_deref_id(listen_cm_id_priv);
 destroy:
 	ib_destroy_cm_id(cm_id);
@@ -2565,7 +2567,7 @@ static struct cm_id_private * cm_acquire_rejected_id(struct cm_rej_msg *rej_msg)
 				       cm.random_id_operand));
 		if (cm_id_priv) {
 			if (cm_id_priv->id.remote_id == remote_id)
-				atomic_inc(&cm_id_priv->refcount);
+				refcount_inc(&cm_id_priv->refcount);
 			else
 				cm_id_priv = NULL;
 		}
@@ -3262,8 +3264,8 @@ static int cm_sidr_req_handler(struct cm_work *work)
 		cm_reject_sidr_req(cm_id_priv, IB_SIDR_UNSUPPORTED);
 		goto out; /* No match. */
 	}
-	atomic_inc(&cur_cm_id_priv->refcount);
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cur_cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 	spin_unlock_irq(&cm.lock);
 
 	cm_id_priv->id.cm_handler = cur_cm_id_priv->id.cm_handler;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e7dcfac..4672265 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -43,6 +43,7 @@
 #include <linux/inetdevice.h>
 #include <linux/slab.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <net/route.h>
 
 #include <net/net_namespace.h>
@@ -195,7 +196,7 @@ struct cma_device {
 	struct list_head	list;
 	struct ib_device	*device;
 	struct completion	comp;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct list_head	id_list;
 	enum ib_gid_type	*default_gid_type;
 };
@@ -243,7 +244,7 @@ enum {
 
 void cma_ref_dev(struct cma_device *cma_dev)
 {
-	atomic_inc(&cma_dev->refcount);
+	refcount_inc(&cma_dev->refcount);
 }
 
 struct cma_device *cma_enum_devices_by_ibdev(cma_device_filter	filter,
@@ -324,7 +325,7 @@ struct rdma_id_private {
 	struct mutex		qp_mutex;
 
 	struct completion	comp;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct mutex		handler_mutex;
 
 	int			backlog;
@@ -498,7 +499,7 @@ static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 
 void cma_deref_dev(struct cma_device *cma_dev)
 {
-	if (atomic_dec_and_test(&cma_dev->refcount))
+	if (refcount_dec_and_test(&cma_dev->refcount))
 		complete(&cma_dev->comp);
 }
 
@@ -757,7 +758,7 @@ static int cma_resolve_ib_dev(struct rdma_id_private *id_priv)
 
 static void cma_deref_id(struct rdma_id_private *id_priv)
 {
-	if (atomic_dec_and_test(&id_priv->refcount))
+	if (refcount_dec_and_test(&id_priv->refcount))
 		complete(&id_priv->comp);
 }
 
@@ -781,7 +782,7 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
 	spin_lock_init(&id_priv->lock);
 	mutex_init(&id_priv->qp_mutex);
 	init_completion(&id_priv->comp);
-	atomic_set(&id_priv->refcount, 1);
+	refcount_set(&id_priv->refcount, 1);
 	mutex_init(&id_priv->handler_mutex);
 	INIT_LIST_HEAD(&id_priv->listen_list);
 	INIT_LIST_HEAD(&id_priv->mc_list);
@@ -1966,7 +1967,7 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	 * Protect against the user destroying conn_id from another thread
 	 * until we're done accessing it.
 	 */
-	atomic_inc(&conn_id->refcount);
+	refcount_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret)
 		goto err3;
@@ -2142,7 +2143,7 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 	 * Protect against the user destroying conn_id from another thread
 	 * until we're done accessing it.
 	 */
-	atomic_inc(&conn_id->refcount);
+	refcount_inc(&conn_id->refcount);
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret) {
 		/* User wants to destroy the CM ID */
@@ -2239,7 +2240,7 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 
 	_cma_attach_to_dev(dev_id_priv, cma_dev);
 	list_add_tail(&dev_id_priv->listen_list, &id_priv->listen_list);
-	atomic_inc(&id_priv->refcount);
+	refcount_inc(&id_priv->refcount);
 	dev_id_priv->internal_id = 1;
 	dev_id_priv->afonly = id_priv->afonly;
 
@@ -2611,7 +2612,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_RESOLVED, RDMA_CM_ROUTE_QUERY))
 		return -EINVAL;
 
-	atomic_inc(&id_priv->refcount);
+	refcount_inc(&id_priv->refcount);
 	if (rdma_cap_ib_sa(id->device, id->port_num))
 		ret = cma_resolve_ib_route(id_priv, timeout_ms);
 	else if (rdma_protocol_roce(id->device, id->port_num))
@@ -2844,7 +2845,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	if (!cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_ADDR_QUERY))
 		return -EINVAL;
 
-	atomic_inc(&id_priv->refcount);
+	refcount_inc(&id_priv->refcount);
 	memcpy(cma_dst_addr(id_priv), dst_addr, rdma_addr_size(dst_addr));
 	if (cma_any_addr(dst_addr)) {
 		ret = cma_resolve_loopback(id_priv);
@@ -4175,7 +4176,7 @@ static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id
 		INIT_WORK(&work->work, cma_ndev_work_handler);
 		work->id = id_priv;
 		work->event.event = RDMA_CM_EVENT_ADDR_CHANGE;
-		atomic_inc(&id_priv->refcount);
+		refcount_inc(&id_priv->refcount);
 		queue_work(cma_wq, &work->work);
 	}
 
@@ -4240,7 +4241,7 @@ static void cma_add_one(struct ib_device *device)
 	}
 
 	init_completion(&cma_dev->comp);
-	atomic_set(&cma_dev->refcount, 1);
+	refcount_set(&cma_dev->refcount, 1);
 	INIT_LIST_HEAD(&cma_dev->id_list);
 	ib_set_client_data(device, &cma_client, cma_dev);
 
@@ -4289,7 +4290,7 @@ static void cma_process_remove(struct cma_device *cma_dev)
 
 		list_del(&id_priv->listen_list);
 		list_del_init(&id_priv->list);
-		atomic_inc(&id_priv->refcount);
+		refcount_inc(&id_priv->refcount);
 		mutex_unlock(&lock);
 
 		ret = id_priv->internal_id ? 1 : cma_remove_id_dev(id_priv);
diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index a754fc7..22a48ae 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -142,7 +142,7 @@ struct ib_cq *ib_alloc_cq(struct ib_device *dev, void *private,
 	cq->event_handler = NULL;
 	cq->cq_context = private;
 	cq->poll_ctx = poll_ctx;
-	atomic_set(&cq->usecnt, 0);
+	refcount_set(&cq->usecnt, 0);
 
 	cq->wc = kmalloc_array(IB_POLL_BATCH, sizeof(*cq->wc), GFP_KERNEL);
 	if (!cq->wc)
@@ -186,7 +186,7 @@ void ib_free_cq(struct ib_cq *cq)
 {
 	int ret;
 
-	if (WARN_ON_ONCE(atomic_read(&cq->usecnt)))
+	if (WARN_ON_ONCE(refcount_read(&cq->usecnt)))
 		return;
 
 	switch (cq->poll_ctx) {
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 31661b5..5c49a7a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -208,8 +208,8 @@ static void free_cm_id(struct iwcm_id_private *cm_id_priv)
  */
 static int iwcm_deref_id(struct iwcm_id_private *cm_id_priv)
 {
-	BUG_ON(atomic_read(&cm_id_priv->refcount)==0);
-	if (atomic_dec_and_test(&cm_id_priv->refcount)) {
+	BUG_ON(refcount_read(&cm_id_priv->refcount)==0);
+	if (refcount_dec_and_test(&cm_id_priv->refcount)) {
 		BUG_ON(!list_empty(&cm_id_priv->work_list));
 		free_cm_id(cm_id_priv);
 		return 1;
@@ -222,7 +222,7 @@ static void add_ref(struct iw_cm_id *cm_id)
 {
 	struct iwcm_id_private *cm_id_priv;
 	cm_id_priv = container_of(cm_id, struct iwcm_id_private, id);
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 }
 
 static void rem_ref(struct iw_cm_id *cm_id)
@@ -254,7 +254,7 @@ struct iw_cm_id *iw_create_cm_id(struct ib_device *device,
 	cm_id_priv->id.add_ref = add_ref;
 	cm_id_priv->id.rem_ref = rem_ref;
 	spin_lock_init(&cm_id_priv->lock);
-	atomic_set(&cm_id_priv->refcount, 1);
+	refcount_set(&cm_id_priv->refcount, 1);
 	init_waitqueue_head(&cm_id_priv->connect_wait);
 	init_completion(&cm_id_priv->destroy_comp);
 	INIT_LIST_HEAD(&cm_id_priv->work_list);
@@ -1081,7 +1081,7 @@ static int cm_event_handler(struct iw_cm_id *cm_id,
 		}
 	}
 
-	atomic_inc(&cm_id_priv->refcount);
+	refcount_inc(&cm_id_priv->refcount);
 	if (list_empty(&cm_id_priv->work_list)) {
 		list_add_tail(&work->list, &cm_id_priv->work_list);
 		queue_work(iwcm_wq, &work->work);
diff --git a/drivers/infiniband/core/iwcm.h b/drivers/infiniband/core/iwcm.h
index 82c2cd1..12fe7da 100644
--- a/drivers/infiniband/core/iwcm.h
+++ b/drivers/infiniband/core/iwcm.h
@@ -33,6 +33,8 @@
 #ifndef IWCM_H
 #define IWCM_H
 
+#include <linux/refcount.h>
+
 enum iw_cm_state {
 	IW_CM_STATE_IDLE,             /* unbound, inactive */
 	IW_CM_STATE_LISTEN,           /* listen waiting for connect */
@@ -52,7 +54,7 @@ struct iwcm_id_private {
 	wait_queue_head_t connect_wait;
 	struct list_head work_list;
 	spinlock_t lock;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct list_head work_free_list;
 };
 
diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 3ef51a9..4961909 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -57,7 +57,7 @@ int iwpm_init(u8 nl_client)
 	if (iwpm_valid_client(nl_client))
 		return -EINVAL;
 	mutex_lock(&iwpm_admin_lock);
-	if (atomic_read(&iwpm_admin.refcount) == 0) {
+	if (refcount_read(&iwpm_admin.refcount) == 0) {
 		iwpm_hash_bucket = kzalloc(IWPM_MAPINFO_HASH_SIZE *
 					sizeof(struct hlist_head), GFP_KERNEL);
 		if (!iwpm_hash_bucket) {
@@ -72,7 +72,7 @@ int iwpm_init(u8 nl_client)
 			goto init_exit;
 		}
 	}
-	atomic_inc(&iwpm_admin.refcount);
+	refcount_inc(&iwpm_admin.refcount);
 init_exit:
 	mutex_unlock(&iwpm_admin_lock);
 	if (!ret) {
@@ -94,12 +94,12 @@ int iwpm_exit(u8 nl_client)
 	if (!iwpm_valid_client(nl_client))
 		return -EINVAL;
 	mutex_lock(&iwpm_admin_lock);
-	if (atomic_read(&iwpm_admin.refcount) == 0) {
+	if (refcount_read(&iwpm_admin.refcount) == 0) {
 		mutex_unlock(&iwpm_admin_lock);
 		pr_err("%s Incorrect usage - negative refcount\n", __func__);
 		return -EINVAL;
 	}
-	if (atomic_dec_and_test(&iwpm_admin.refcount)) {
+	if (refcount_dec_and_test(&iwpm_admin.refcount)) {
 		free_hash_bucket();
 		free_reminfo_bucket();
 		pr_debug("%s: Resources are destroyed\n", __func__);
diff --git a/drivers/infiniband/core/iwpm_util.h b/drivers/infiniband/core/iwpm_util.h
index af1fc14..d7b4ae9 100644
--- a/drivers/infiniband/core/iwpm_util.h
+++ b/drivers/infiniband/core/iwpm_util.h
@@ -45,6 +45,7 @@
 #include <linux/mutex.h>
 #include <linux/jhash.h>
 #include <linux/kref.h>
+#include <linux/refcount.h>
 #include <net/netlink.h>
 #include <linux/errno.h>
 #include <rdma/iw_portmap.h>
@@ -89,7 +90,7 @@ struct iwpm_remote_info {
 };
 
 struct iwpm_admin_data {
-	atomic_t refcount;
+	refcount_t refcount;
 	atomic_t nlmsg_seq;
 	int      client_list[RDMA_NL_NUM_CLIENTS];
 	u32      reg_list[RDMA_NL_NUM_CLIENTS];
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index a009f71..7c34b8e 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -364,7 +364,7 @@ struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
 	INIT_DELAYED_WORK(&mad_agent_priv->timed_work, timeout_sends);
 	INIT_LIST_HEAD(&mad_agent_priv->local_list);
 	INIT_WORK(&mad_agent_priv->local_work, local_completions);
-	atomic_set(&mad_agent_priv->refcount, 1);
+	refcount_set(&mad_agent_priv->refcount, 1);
 	init_completion(&mad_agent_priv->comp);
 
 	spin_lock_irqsave(&port_priv->reg_lock, flags);
@@ -531,7 +531,7 @@ struct ib_mad_agent *ib_register_mad_snoop(struct ib_device *device,
 		goto error2;
 	}
 
-	atomic_set(&mad_snoop_priv->refcount, 1);
+	refcount_set(&mad_snoop_priv->refcount, 1);
 	return &mad_snoop_priv->agent;
 
 error2:
@@ -543,13 +543,13 @@ EXPORT_SYMBOL(ib_register_mad_snoop);
 
 static inline void deref_mad_agent(struct ib_mad_agent_private *mad_agent_priv)
 {
-	if (atomic_dec_and_test(&mad_agent_priv->refcount))
+	if (refcount_dec_and_test(&mad_agent_priv->refcount))
 		complete(&mad_agent_priv->comp);
 }
 
 static inline void deref_snoop_agent(struct ib_mad_snoop_private *mad_snoop_priv)
 {
-	if (atomic_dec_and_test(&mad_snoop_priv->refcount))
+	if (refcount_dec_and_test(&mad_snoop_priv->refcount))
 		complete(&mad_snoop_priv->comp);
 }
 
@@ -653,7 +653,7 @@ static void snoop_send(struct ib_mad_qp_info *qp_info,
 		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
 			continue;
 
-		atomic_inc(&mad_snoop_priv->refcount);
+		refcount_inc(&mad_snoop_priv->refcount);
 		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
 		mad_snoop_priv->agent.snoop_handler(&mad_snoop_priv->agent,
 						    send_buf, mad_send_wc);
@@ -678,7 +678,7 @@ static void snoop_recv(struct ib_mad_qp_info *qp_info,
 		    !(mad_snoop_priv->mad_snoop_flags & mad_snoop_flags))
 			continue;
 
-		atomic_inc(&mad_snoop_priv->refcount);
+		refcount_inc(&mad_snoop_priv->refcount);
 		spin_unlock_irqrestore(&qp_info->snoop_lock, flags);
 		mad_snoop_priv->agent.recv_handler(&mad_snoop_priv->agent, NULL,
 						   mad_recv_wc);
@@ -854,7 +854,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 			 * Reference MAD agent until receive
 			 * side of local completion handled
 			 */
-			atomic_inc(&mad_agent_priv->refcount);
+			refcount_inc(&mad_agent_priv->refcount);
 		} else
 			kfree(mad_priv);
 		break;
@@ -894,7 +894,7 @@ static int handle_outgoing_dr_smp(struct ib_mad_agent_private *mad_agent_priv,
 		local->return_wc_byte_len = mad_size;
 	}
 	/* Reference MAD agent until send side of local completion handled */
-	atomic_inc(&mad_agent_priv->refcount);
+	refcount_inc(&mad_agent_priv->refcount);
 	/* Queue local completion to local list */
 	spin_lock_irqsave(&mad_agent_priv->lock, flags);
 	list_add_tail(&local->completion_list, &mad_agent_priv->local_list);
@@ -1052,7 +1052,7 @@ struct ib_mad_send_buf * ib_create_send_mad(struct ib_mad_agent *mad_agent,
 	}
 
 	mad_send_wr->send_buf.mad_agent = mad_agent;
-	atomic_inc(&mad_agent_priv->refcount);
+	refcount_inc(&mad_agent_priv->refcount);
 	return &mad_send_wr->send_buf;
 }
 EXPORT_SYMBOL(ib_create_send_mad);
@@ -1263,7 +1263,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 		mad_send_wr->status = IB_WC_SUCCESS;
 
 		/* Reference MAD agent until send completes */
-		atomic_inc(&mad_agent_priv->refcount);
+		refcount_inc(&mad_agent_priv->refcount);
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		list_add_tail(&mad_send_wr->agent_list,
 			      &mad_agent_priv->send_list);
@@ -1280,7 +1280,7 @@ int ib_post_send_mad(struct ib_mad_send_buf *send_buf,
 			spin_lock_irqsave(&mad_agent_priv->lock, flags);
 			list_del(&mad_send_wr->agent_list);
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
-			atomic_dec(&mad_agent_priv->refcount);
+			refcount_dec(&mad_agent_priv->refcount);
 			goto error;
 		}
 	}
@@ -1759,7 +1759,7 @@ find_mad_agent(struct ib_mad_port_private *port_priv,
 
 	if (mad_agent) {
 		if (mad_agent->agent.recv_handler)
-			atomic_inc(&mad_agent->refcount);
+			refcount_inc(&mad_agent->refcount);
 		else {
 			dev_notice(&port_priv->device->dev,
 				   "No receive handler for client %p on port %d\n",
@@ -1968,7 +1968,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 				mad_agent_priv->agent.recv_handler(
 						&mad_agent_priv->agent, NULL,
 						mad_recv_wc);
-				atomic_dec(&mad_agent_priv->refcount);
+				refcount_dec(&mad_agent_priv->refcount);
 			} else {
 				/* not user rmpp, revert to normal behavior and
 				 * drop the mad */
@@ -1985,7 +1985,7 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
 					&mad_agent_priv->agent,
 					&mad_send_wr->send_buf,
 					mad_recv_wc);
-			atomic_dec(&mad_agent_priv->refcount);
+			refcount_dec(&mad_agent_priv->refcount);
 
 			mad_send_wc.status = IB_WC_SUCCESS;
 			mad_send_wc.vendor_err = 0;
@@ -2571,7 +2571,7 @@ static void cancel_mads(struct ib_mad_agent_private *mad_agent_priv)
 		list_del(&mad_send_wr->agent_list);
 		mad_agent_priv->agent.send_handler(&mad_agent_priv->agent,
 						   &mad_send_wc);
-		atomic_dec(&mad_agent_priv->refcount);
+		refcount_dec(&mad_agent_priv->refcount);
 	}
 }
 
@@ -2709,7 +2709,7 @@ static void local_completions(struct work_struct *work)
 						&local->mad_send_wr->send_buf,
 						&local->mad_priv->header.recv_wc);
 			spin_lock_irqsave(&recv_mad_agent->lock, flags);
-			atomic_dec(&recv_mad_agent->refcount);
+			refcount_dec(&recv_mad_agent->refcount);
 			spin_unlock_irqrestore(&recv_mad_agent->lock, flags);
 		}
 
@@ -2726,7 +2726,7 @@ static void local_completions(struct work_struct *work)
 						   &mad_send_wc);
 
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
-		atomic_dec(&mad_agent_priv->refcount);
+		refcount_dec(&mad_agent_priv->refcount);
 		if (free_mad)
 			kfree(local->mad_priv);
 		kfree(local);
@@ -2812,7 +2812,7 @@ static void timeout_sends(struct work_struct *work)
 		mad_agent_priv->agent.send_handler(&mad_agent_priv->agent,
 						   &mad_send_wc);
 
-		atomic_dec(&mad_agent_priv->refcount);
+		refcount_dec(&mad_agent_priv->refcount);
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 	}
 	spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
diff --git a/drivers/infiniband/core/mad_priv.h b/drivers/infiniband/core/mad_priv.h
index 28669f6..f4e75ab 100644
--- a/drivers/infiniband/core/mad_priv.h
+++ b/drivers/infiniband/core/mad_priv.h
@@ -38,6 +38,7 @@
 
 #include <linux/completion.h>
 #include <linux/err.h>
+#include <linux/refcount.h>
 #include <linux/workqueue.h>
 #include <rdma/ib_mad.h>
 #include <rdma/ib_smi.h>
@@ -104,7 +105,7 @@ struct ib_mad_agent_private {
 	struct work_struct local_work;
 	struct list_head rmpp_list;
 
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion comp;
 };
 
@@ -113,7 +114,7 @@ struct ib_mad_snoop_private {
 	struct ib_mad_qp_info *qp_info;
 	int snoop_index;
 	int mad_snoop_flags;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion comp;
 };
 
diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 382941b..db96133 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -33,6 +33,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/refcount.h>
 
 #include "mad_priv.h"
 #include "mad_rmpp.h"
@@ -52,7 +53,7 @@ struct mad_rmpp_recv {
 	struct completion comp;
 	enum rmpp_state state;
 	spinlock_t lock;
-	atomic_t refcount;
+	refcount_t refcount;
 
 	struct ib_ah *ah;
 	struct ib_mad_recv_wc *rmpp_wc;
@@ -73,7 +74,7 @@ struct mad_rmpp_recv {
 
 static inline void deref_rmpp_recv(struct mad_rmpp_recv *rmpp_recv)
 {
-	if (atomic_dec_and_test(&rmpp_recv->refcount))
+	if (refcount_dec_and_test(&rmpp_recv->refcount))
 		complete(&rmpp_recv->comp);
 }
 
@@ -304,7 +305,7 @@ create_rmpp_recv(struct ib_mad_agent_private *agent,
 	INIT_DELAYED_WORK(&rmpp_recv->cleanup_work, recv_cleanup_handler);
 	spin_lock_init(&rmpp_recv->lock);
 	rmpp_recv->state = RMPP_STATE_ACTIVE;
-	atomic_set(&rmpp_recv->refcount, 1);
+	refcount_set(&rmpp_recv->refcount, 1);
 
 	rmpp_recv->rmpp_wc = mad_recv_wc;
 	rmpp_recv->cur_seg_buf = &mad_recv_wc->recv_buf;
@@ -356,7 +357,7 @@ acquire_rmpp_recv(struct ib_mad_agent_private *agent,
 	spin_lock_irqsave(&agent->lock, flags);
 	rmpp_recv = find_rmpp_recv(agent, mad_recv_wc);
 	if (rmpp_recv)
-		atomic_inc(&rmpp_recv->refcount);
+		refcount_inc(&rmpp_recv->refcount);
 	spin_unlock_irqrestore(&agent->lock, flags);
 	return rmpp_recv;
 }
@@ -552,7 +553,7 @@ start_rmpp(struct ib_mad_agent_private *agent,
 		destroy_rmpp_recv(rmpp_recv);
 		return continue_rmpp(agent, mad_recv_wc);
 	}
-	atomic_inc(&rmpp_recv->refcount);
+	refcount_inc(&rmpp_recv->refcount);
 
 	if (get_last_flag(&mad_recv_wc->recv_buf)) {
 		rmpp_recv->state = RMPP_STATE_COMPLETE;
diff --git a/drivers/infiniband/core/multicast.c b/drivers/infiniband/core/multicast.c
index 322cb67..9096ace 100644
--- a/drivers/infiniband/core/multicast.c
+++ b/drivers/infiniband/core/multicast.c
@@ -38,6 +38,7 @@
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include <linux/random.h>
+#include <linux/refcount.h>
 
 #include <rdma/ib_cache.h>
 #include "sa.h"
@@ -61,7 +62,7 @@ struct mcast_port {
 	struct mcast_device	*dev;
 	spinlock_t		lock;
 	struct rb_root		table;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	comp;
 	u8			port_num;
 };
@@ -103,7 +104,7 @@ struct mcast_group {
 	struct list_head	active_list;
 	struct mcast_member	*last_join;
 	int			members[NUM_JOIN_MEMBERSHIP_TYPES];
-	atomic_t		refcount;
+	refcount_t		refcount;
 	enum mcast_group_state	state;
 	struct ib_sa_query	*query;
 	u16			pkey_index;
@@ -117,7 +118,7 @@ struct mcast_member {
 	struct mcast_group	*group;
 	struct list_head	list;
 	enum mcast_state	state;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	comp;
 };
 
@@ -178,7 +179,7 @@ static struct mcast_group *mcast_insert(struct mcast_port *port,
 
 static void deref_port(struct mcast_port *port)
 {
-	if (atomic_dec_and_test(&port->refcount))
+	if (refcount_dec_and_test(&port->refcount))
 		complete(&port->comp);
 }
 
@@ -188,7 +189,7 @@ static void release_group(struct mcast_group *group)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (atomic_dec_and_test(&group->refcount)) {
+	if (refcount_dec_and_test(&group->refcount)) {
 		rb_erase(&group->node, &port->table);
 		spin_unlock_irqrestore(&port->lock, flags);
 		kfree(group);
@@ -199,7 +200,7 @@ static void release_group(struct mcast_group *group)
 
 static void deref_member(struct mcast_member *member)
 {
-	if (atomic_dec_and_test(&member->refcount))
+	if (refcount_dec_and_test(&member->refcount))
 		complete(&member->comp);
 }
 
@@ -212,7 +213,7 @@ static void queue_join(struct mcast_member *member)
 	list_add_tail(&member->list, &group->pending_list);
 	if (group->state == MCAST_IDLE) {
 		group->state = MCAST_BUSY;
-		atomic_inc(&group->refcount);
+		refcount_inc(&group->refcount);
 		queue_work(mcast_wq, &group->work);
 	}
 	spin_unlock_irqrestore(&group->lock, flags);
@@ -401,7 +402,7 @@ static void process_group_error(struct mcast_group *group)
 	while (!list_empty(&group->active_list)) {
 		member = list_entry(group->active_list.next,
 				    struct mcast_member, list);
-		atomic_inc(&member->refcount);
+		refcount_inc(&member->refcount);
 		list_del_init(&member->list);
 		adjust_membership(group, member->multicast.rec.join_state, -1);
 		member->state = MCAST_ERROR;
@@ -445,7 +446,7 @@ static void mcast_work_handler(struct work_struct *work)
 				    struct mcast_member, list);
 		multicast = &member->multicast;
 		join_state = multicast->rec.join_state;
-		atomic_inc(&member->refcount);
+		refcount_inc(&member->refcount);
 
 		if (join_state == (group->rec.join_state & join_state)) {
 			status = cmp_rec(&group->rec, &multicast->rec,
@@ -497,7 +498,7 @@ static void process_join_error(struct mcast_group *group, int status)
 	member = list_entry(group->pending_list.next,
 			    struct mcast_member, list);
 	if (group->last_join == member) {
-		atomic_inc(&member->refcount);
+		refcount_inc(&member->refcount);
 		list_del_init(&member->list);
 		spin_unlock_irq(&group->lock);
 		ret = member->multicast.callback(status, &member->multicast);
@@ -589,9 +590,9 @@ static struct mcast_group *acquire_group(struct mcast_port *port,
 		kfree(group);
 		group = cur_group;
 	} else
-		atomic_inc(&port->refcount);
+		refcount_inc(&port->refcount);
 found:
-	atomic_inc(&group->refcount);
+	refcount_inc(&group->refcount);
 	spin_unlock_irqrestore(&port->lock, flags);
 	return group;
 }
@@ -632,7 +633,7 @@ ib_sa_join_multicast(struct ib_sa_client *client,
 	member->multicast.callback = callback;
 	member->multicast.context = context;
 	init_completion(&member->comp);
-	atomic_set(&member->refcount, 1);
+	refcount_set(&member->refcount, 1);
 	member->state = MCAST_JOINING;
 
 	member->group = acquire_group(&dev->port[port_num - dev->start_port],
@@ -772,7 +773,7 @@ static void mcast_groups_event(struct mcast_port *port,
 		group = rb_entry(node, struct mcast_group, node);
 		spin_lock(&group->lock);
 		if (group->state == MCAST_IDLE) {
-			atomic_inc(&group->refcount);
+			refcount_inc(&group->refcount);
 			queue_work(mcast_wq, &group->work);
 		}
 		if (group->state != MCAST_GROUP_ERROR)
@@ -833,7 +834,7 @@ static void mcast_add_one(struct ib_device *device)
 		spin_lock_init(&port->lock);
 		port->table = RB_ROOT;
 		init_completion(&port->comp);
-		atomic_set(&port->refcount, 1);
+		refcount_set(&port->refcount, 1);
 		++count;
 	}
 
diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 455034a..19dc476 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -85,7 +85,7 @@
  */
 
 struct ib_uverbs_device {
-	atomic_t				refcount;
+	refcount_t				refcount;
 	int					num_comp_vectors;
 	struct completion			comp;
 	struct device			       *dev;
@@ -149,7 +149,7 @@ struct ib_uevent_object {
 
 struct ib_uxrcd_object {
 	struct ib_uobject	uobject;
-	atomic_t		refcnt;
+	refcount_t		refcnt;
 };
 
 struct ib_usrq_object {
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 09b6491..b166c83 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -572,7 +572,7 @@ ssize_t ib_uverbs_alloc_pd(struct ib_uverbs_file *file,
 	pd->device  = ib_dev;
 	pd->uobject = uobj;
 	pd->__internal_mr = NULL;
-	atomic_set(&pd->usecnt, 0);
+	refcount_set(&pd->usecnt, 0);
 
 	uobj->object = pd;
 	ret = idr_add_uobj(&ib_uverbs_pd_idr, uobj);
@@ -627,7 +627,7 @@ ssize_t ib_uverbs_dealloc_pd(struct ib_uverbs_file *file,
 		return -EINVAL;
 	pd = uobj->object;
 
-	if (atomic_read(&pd->usecnt)) {
+	if (refcount_read(&pd->usecnt)) {
 		ret = -EBUSY;
 		goto err_put;
 	}
@@ -808,13 +808,13 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 
 		xrcd->inode   = inode;
 		xrcd->device  = ib_dev;
-		atomic_set(&xrcd->usecnt, 0);
+		refcount_set(&xrcd->usecnt, 0);
 		mutex_init(&xrcd->tgt_qp_mutex);
 		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
 		new_xrcd = 1;
 	}
 
-	atomic_set(&obj->refcnt, 0);
+	refcount_set(&obj->refcnt, 0);
 	obj->uobject.object = xrcd;
 	ret = idr_add_uobj(&ib_uverbs_xrcd_idr, &obj->uobject);
 	if (ret)
@@ -830,7 +830,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 			if (ret)
 				goto err_insert_xrcd;
 		}
-		atomic_inc(&xrcd->usecnt);
+		refcount_inc(&xrcd->usecnt);
 	}
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
@@ -856,7 +856,7 @@ ssize_t ib_uverbs_open_xrcd(struct ib_uverbs_file *file,
 	if (inode) {
 		if (new_xrcd)
 			xrcd_table_delete(file->device, inode);
-		atomic_dec(&xrcd->usecnt);
+		refcount_dec(&xrcd->usecnt);
 	}
 
 err_insert_xrcd:
@@ -903,13 +903,13 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 	xrcd  = uobj->object;
 	inode = xrcd->inode;
 	obj   = container_of(uobj, struct ib_uxrcd_object, uobject);
-	if (atomic_read(&obj->refcnt)) {
+	if (refcount_read(&obj->refcnt)) {
 		put_uobj_write(uobj);
 		ret = -EBUSY;
 		goto out;
 	}
 
-	if (!inode || atomic_dec_and_test(&xrcd->usecnt)) {
+	if (!inode || refcount_dec_and_test(&xrcd->usecnt)) {
 		ret = ib_dealloc_xrcd(uobj->object);
 		if (!ret)
 			uobj->live = 0;
@@ -917,7 +917,7 @@ ssize_t ib_uverbs_close_xrcd(struct ib_uverbs_file *file,
 
 	live = uobj->live;
 	if (inode && ret)
-		atomic_inc(&xrcd->usecnt);
+		refcount_inc(&xrcd->usecnt);
 
 	put_uobj_write(uobj);
 
@@ -946,7 +946,7 @@ void ib_uverbs_dealloc_xrcd(struct ib_uverbs_device *dev,
 	struct inode *inode;
 
 	inode = xrcd->inode;
-	if (inode && !atomic_dec_and_test(&xrcd->usecnt))
+	if (inode && !refcount_dec_and_test(&xrcd->usecnt))
 		return;
 
 	ib_dealloc_xrcd(xrcd);
@@ -1017,7 +1017,7 @@ ssize_t ib_uverbs_reg_mr(struct ib_uverbs_file *file,
 	mr->device  = pd->device;
 	mr->pd      = pd;
 	mr->uobject = uobj;
-	atomic_inc(&pd->usecnt);
+	refcount_inc(&pd->usecnt);
 
 	uobj->object = mr;
 	ret = idr_add_uobj(&ib_uverbs_mr_idr, uobj);
@@ -1121,9 +1121,9 @@ ssize_t ib_uverbs_rereg_mr(struct ib_uverbs_file *file,
 					cmd.access_flags, pd, &udata);
 	if (!ret) {
 		if (cmd.flags & IB_MR_REREG_PD) {
-			atomic_inc(&pd->usecnt);
+			refcount_inc(&pd->usecnt);
 			mr->pd = pd;
-			atomic_dec(&old_pd->usecnt);
+			refcount_dec(&old_pd->usecnt);
 		}
 	} else {
 		goto put_uobj_pd;
@@ -1235,7 +1235,7 @@ ssize_t ib_uverbs_alloc_mw(struct ib_uverbs_file *file,
 	mw->device  = pd->device;
 	mw->pd      = pd;
 	mw->uobject = uobj;
-	atomic_inc(&pd->usecnt);
+	refcount_inc(&pd->usecnt);
 
 	uobj->object = mw;
 	ret = idr_add_uobj(&ib_uverbs_mw_idr, uobj);
@@ -1417,7 +1417,7 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	cq->comp_handler  = ib_uverbs_comp_handler;
 	cq->event_handler = ib_uverbs_cq_event_handler;
 	cq->cq_context    = ev_file;
-	atomic_set(&cq->usecnt, 0);
+	refcount_set(&cq->usecnt, 0);
 
 	obj->uobject.object = cq;
 	ret = idr_add_uobj(&ib_uverbs_cq_idr, &obj->uobject);
@@ -1925,16 +1925,16 @@ static int create_qp(struct ib_uverbs_file *file,
 		qp->event_handler = attr.event_handler;
 		qp->qp_context	  = attr.qp_context;
 		qp->qp_type	  = attr.qp_type;
-		atomic_set(&qp->usecnt, 0);
-		atomic_inc(&pd->usecnt);
+		refcount_set(&qp->usecnt, 0);
+		refcount_inc(&pd->usecnt);
 		if (attr.send_cq)
-			atomic_inc(&attr.send_cq->usecnt);
+			refcount_inc(&attr.send_cq->usecnt);
 		if (attr.recv_cq)
-			atomic_inc(&attr.recv_cq->usecnt);
+			refcount_inc(&attr.recv_cq->usecnt);
 		if (attr.srq)
-			atomic_inc(&attr.srq->usecnt);
+			refcount_inc(&attr.srq->usecnt);
 		if (ind_tbl)
-			atomic_inc(&ind_tbl->usecnt);
+			refcount_inc(&ind_tbl->usecnt);
 	}
 	qp->uobject = &obj->uevent.uobject;
 
@@ -1962,7 +1962,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (xrcd) {
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object,
 					  uobject);
-		atomic_inc(&obj->uxrcd->refcnt);
+		refcount_inc(&obj->uxrcd->refcnt);
 		put_xrcd_read(xrcd_uobj);
 	}
 
@@ -2188,7 +2188,7 @@ ssize_t ib_uverbs_open_qp(struct ib_uverbs_file *file,
 	}
 
 	obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
-	atomic_inc(&obj->uxrcd->refcnt);
+	refcount_inc(&obj->uxrcd->refcnt);
 	put_xrcd_read(xrcd_uobj);
 
 	mutex_lock(&file->mutex);
@@ -2519,7 +2519,7 @@ ssize_t ib_uverbs_destroy_qp(struct ib_uverbs_file *file,
 		return ret;
 
 	if (obj->uxrcd)
-		atomic_dec(&obj->uxrcd->refcnt);
+		refcount_dec(&obj->uxrcd->refcnt);
 
 	idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
 
@@ -2978,7 +2978,7 @@ ssize_t ib_uverbs_create_ah(struct ib_uverbs_file *file,
 
 	ah->device  = pd->device;
 	ah->pd      = pd;
-	atomic_inc(&pd->usecnt);
+	refcount_inc(&pd->usecnt);
 	ah->uobject  = uobj;
 	uobj->object = ah;
 
@@ -3340,9 +3340,9 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	wq->pd = pd;
 	wq->device = pd->device;
 	wq->wq_context = wq_init_attr.wq_context;
-	atomic_set(&wq->usecnt, 0);
-	atomic_inc(&pd->usecnt);
-	atomic_inc(&cq->usecnt);
+	refcount_set(&wq->usecnt, 0);
+	refcount_inc(&pd->usecnt);
+	refcount_inc(&cq->usecnt);
 	wq->uobject = &obj->uevent.uobject;
 	obj->uevent.uobject.object = wq;
 	err = idr_add_uobj(&ib_uverbs_wq_idr, &obj->uevent.uobject);
@@ -3599,10 +3599,10 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 	rwq_ind_tbl->uobject = uobj;
 	uobj->object = rwq_ind_tbl;
 	rwq_ind_tbl->device = ib_dev;
-	atomic_set(&rwq_ind_tbl->usecnt, 0);
+	refcount_set(&rwq_ind_tbl->usecnt, 0);
 
 	for (i = 0; i < num_wq_handles; i++)
-		atomic_inc(&wqs[i]->usecnt);
+		refcount_inc(&wqs[i]->usecnt);
 
 	err = idr_add_uobj(&ib_uverbs_rwq_ind_tbl_idr, uobj);
 	if (err)
@@ -3941,7 +3941,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		}
 
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
-		atomic_inc(&obj->uxrcd->refcnt);
+		refcount_inc(&obj->uxrcd->refcnt);
 
 		attr.ext.xrc.cq  = idr_read_cq(cmd->cq_handle, file->ucontext, 0);
 		if (!attr.ext.xrc.cq) {
@@ -3982,12 +3982,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	if (cmd->srq_type == IB_SRQT_XRC) {
 		srq->ext.xrc.cq   = attr.ext.xrc.cq;
 		srq->ext.xrc.xrcd = attr.ext.xrc.xrcd;
-		atomic_inc(&attr.ext.xrc.cq->usecnt);
-		atomic_inc(&attr.ext.xrc.xrcd->usecnt);
+		refcount_inc(&attr.ext.xrc.cq->usecnt);
+		refcount_inc(&attr.ext.xrc.xrcd->usecnt);
 	}
 
-	atomic_inc(&pd->usecnt);
-	atomic_set(&srq->usecnt, 0);
+	refcount_inc(&pd->usecnt);
+	refcount_set(&srq->usecnt, 0);
 
 	obj->uevent.uobject.object = srq;
 	ret = idr_add_uobj(&ib_uverbs_srq_idr, &obj->uevent.uobject);
@@ -4038,7 +4038,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		atomic_dec(&obj->uxrcd->refcnt);
+		refcount_dec(&obj->uxrcd->refcnt);
 		put_uobj_read(xrcd_uobj);
 	}
 
@@ -4218,7 +4218,7 @@ ssize_t ib_uverbs_destroy_srq(struct ib_uverbs_file *file,
 
 	if (srq_type == IB_SRQT_XRC) {
 		us = container_of(obj, struct ib_usrq_object, uevent);
-		atomic_dec(&us->uxrcd->refcnt);
+		refcount_dec(&us->uxrcd->refcnt);
 	}
 
 	idr_remove_uobj(&ib_uverbs_srq_idr, uobj);
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 8135935..27685a2 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -150,7 +150,7 @@ int uverbs_dealloc_mw(struct ib_mw *mw)
 
 	ret = mw->device->dealloc_mw(mw);
 	if (!ret)
-		atomic_dec(&pd->usecnt);
+		refcount_dec(&pd->usecnt);
 	return ret;
 }
 
@@ -366,7 +366,7 @@ static void ib_uverbs_release_file(struct kref *ref)
 		module_put(ib_dev->owner);
 	srcu_read_unlock(&file->device->disassociate_srcu, srcu_key);
 
-	if (atomic_dec_and_test(&file->device->refcount))
+	if (refcount_dec_and_test(&file->device->refcount))
 		ib_uverbs_comp_dev(file->device);
 
 	kfree(file);
@@ -932,7 +932,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 	int srcu_key;
 
 	dev = container_of(inode->i_cdev, struct ib_uverbs_device, cdev);
-	if (!atomic_inc_not_zero(&dev->refcount))
+	if (!refcount_inc_not_zero(&dev->refcount))
 		return -ENXIO;
 
 	srcu_key = srcu_read_lock(&dev->disassociate_srcu);
@@ -986,7 +986,7 @@ static int ib_uverbs_open(struct inode *inode, struct file *filp)
 err:
 	mutex_unlock(&dev->lists_mutex);
 	srcu_read_unlock(&dev->disassociate_srcu, srcu_key);
-	if (atomic_dec_and_test(&dev->refcount))
+	if (refcount_dec_and_test(&dev->refcount))
 		ib_uverbs_comp_dev(dev);
 
 	return ret;
@@ -1135,7 +1135,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		return;
 	}
 
-	atomic_set(&uverbs_dev->refcount, 1);
+	refcount_set(&uverbs_dev->refcount, 1);
 	init_completion(&uverbs_dev->comp);
 	uverbs_dev->xrcd_tree = RB_ROOT;
 	mutex_init(&uverbs_dev->xrcd_tree_mutex);
@@ -1200,7 +1200,7 @@ static void ib_uverbs_add_one(struct ib_device *device)
 		clear_bit(devnum, overflow_map);
 
 err:
-	if (atomic_dec_and_test(&uverbs_dev->refcount))
+	if (refcount_dec_and_test(&uverbs_dev->refcount))
 		ib_uverbs_comp_dev(uverbs_dev);
 	wait_for_completion(&uverbs_dev->comp);
 	kobject_put(&uverbs_dev->kobj);
@@ -1311,7 +1311,7 @@ static void ib_uverbs_remove_one(struct ib_device *device, void *client_data)
 		wait_clients = 0;
 	}
 
-	if (atomic_dec_and_test(&uverbs_dev->refcount))
+	if (refcount_dec_and_test(&uverbs_dev->refcount))
 		ib_uverbs_comp_dev(uverbs_dev);
 	if (wait_clients)
 		wait_for_completion(&uverbs_dev->comp);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 71580cc..11e0cf0 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -240,7 +240,7 @@ struct ib_pd *__ib_alloc_pd(struct ib_device *device, unsigned int flags,
 	pd->device = device;
 	pd->uobject = NULL;
 	pd->__internal_mr = NULL;
-	atomic_set(&pd->usecnt, 0);
+	refcount_set(&pd->usecnt, 0);
 	pd->flags = flags;
 
 	if (device->attrs.device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY)
@@ -300,7 +300,7 @@ void ib_dealloc_pd(struct ib_pd *pd)
 
 	/* uverbs manipulates usecnt with proper locking, while the kabi
 	   requires the caller to guarantee we can't race here. */
-	WARN_ON(atomic_read(&pd->usecnt));
+	WARN_ON(refcount_read(&pd->usecnt));
 
 	/* Making delalloc_pd a void return is a WIP, no driver should return
 	   an error here. */
@@ -321,7 +321,7 @@ struct ib_ah *ib_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 		ah->device  = pd->device;
 		ah->pd      = pd;
 		ah->uobject = NULL;
-		atomic_inc(&pd->usecnt);
+		refcount_inc(&pd->usecnt);
 	}
 
 	return ah;
@@ -595,7 +595,7 @@ int ib_destroy_ah(struct ib_ah *ah)
 	pd = ah->pd;
 	ret = ah->device->destroy_ah(ah);
 	if (!ret)
-		atomic_dec(&pd->usecnt);
+		refcount_dec(&pd->usecnt);
 
 	return ret;
 }
@@ -623,11 +623,11 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		if (srq->srq_type == IB_SRQT_XRC) {
 			srq->ext.xrc.xrcd = srq_init_attr->ext.xrc.xrcd;
 			srq->ext.xrc.cq   = srq_init_attr->ext.xrc.cq;
-			atomic_inc(&srq->ext.xrc.xrcd->usecnt);
-			atomic_inc(&srq->ext.xrc.cq->usecnt);
+			refcount_inc(&srq->ext.xrc.xrcd->usecnt);
+			refcount_inc(&srq->ext.xrc.cq->usecnt);
 		}
-		atomic_inc(&pd->usecnt);
-		atomic_set(&srq->usecnt, 0);
+		refcount_inc(&pd->usecnt);
+		refcount_set(&srq->usecnt, 0);
 	}
 
 	return srq;
@@ -660,7 +660,7 @@ int ib_destroy_srq(struct ib_srq *srq)
 	struct ib_cq *uninitialized_var(cq);
 	int ret;
 
-	if (atomic_read(&srq->usecnt))
+	if (refcount_read(&srq->usecnt))
 		return -EBUSY;
 
 	pd = srq->pd;
@@ -672,10 +672,10 @@ int ib_destroy_srq(struct ib_srq *srq)
 
 	ret = srq->device->destroy_srq(srq);
 	if (!ret) {
-		atomic_dec(&pd->usecnt);
+		refcount_dec(&pd->usecnt);
 		if (srq_type == IB_SRQT_XRC) {
-			atomic_dec(&xrcd->usecnt);
-			atomic_dec(&cq->usecnt);
+			refcount_dec(&xrcd->usecnt);
+			refcount_dec(&cq->usecnt);
 		}
 	}
 
@@ -716,7 +716,7 @@ static struct ib_qp *__ib_open_qp(struct ib_qp *real_qp,
 		return ERR_PTR(-ENOMEM);
 
 	qp->real_qp = real_qp;
-	atomic_inc(&real_qp->usecnt);
+	refcount_inc(&real_qp->usecnt);
 	qp->device = real_qp->device;
 	qp->event_handler = event_handler;
 	qp->qp_context = qp_context;
@@ -763,7 +763,7 @@ static struct ib_qp *ib_create_xrc_qp(struct ib_qp *qp,
 	qp->send_cq = qp->recv_cq = NULL;
 	qp->srq = NULL;
 	qp->xrcd = qp_init_attr->xrcd;
-	atomic_inc(&qp_init_attr->xrcd->usecnt);
+	refcount_inc(&qp_init_attr->xrcd->usecnt);
 	INIT_LIST_HEAD(&qp->open_list);
 
 	qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,
@@ -807,7 +807,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	qp->qp_type    = qp_init_attr->qp_type;
 	qp->rwq_ind_tbl = qp_init_attr->rwq_ind_tbl;
 
-	atomic_set(&qp->usecnt, 0);
+	refcount_set(&qp->usecnt, 0);
 	qp->mrs_used = 0;
 	spin_lock_init(&qp->mr_lock);
 	INIT_LIST_HEAD(&qp->rdma_mrs);
@@ -824,21 +824,21 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	} else {
 		qp->recv_cq = qp_init_attr->recv_cq;
 		if (qp_init_attr->recv_cq)
-			atomic_inc(&qp_init_attr->recv_cq->usecnt);
+			refcount_inc(&qp_init_attr->recv_cq->usecnt);
 		qp->srq = qp_init_attr->srq;
 		if (qp->srq)
-			atomic_inc(&qp_init_attr->srq->usecnt);
+			refcount_inc(&qp_init_attr->srq->usecnt);
 	}
 
 	qp->pd	    = pd;
 	qp->send_cq = qp_init_attr->send_cq;
 	qp->xrcd    = NULL;
 
-	atomic_inc(&pd->usecnt);
+	refcount_inc(&pd->usecnt);
 	if (qp_init_attr->send_cq)
-		atomic_inc(&qp_init_attr->send_cq->usecnt);
+		refcount_inc(&qp_init_attr->send_cq->usecnt);
 	if (qp_init_attr->rwq_ind_tbl)
-		atomic_inc(&qp->rwq_ind_tbl->usecnt);
+		refcount_inc(&qp->rwq_ind_tbl->usecnt);
 
 	if (qp_init_attr->cap.max_rdma_ctxs) {
 		ret = rdma_rw_init_mrs(qp, qp_init_attr);
@@ -1289,7 +1289,7 @@ int ib_close_qp(struct ib_qp *qp)
 	list_del(&qp->open_list);
 	spin_unlock_irqrestore(&real_qp->device->event_handler_lock, flags);
 
-	atomic_dec(&real_qp->usecnt);
+	refcount_dec(&real_qp->usecnt);
 	kfree(qp);
 
 	return 0;
@@ -1307,7 +1307,7 @@ static int __ib_destroy_shared_qp(struct ib_qp *qp)
 
 	mutex_lock(&xrcd->tgt_qp_mutex);
 	ib_close_qp(qp);
-	if (atomic_read(&real_qp->usecnt) == 0)
+	if (refcount_read(&real_qp->usecnt) == 0)
 		list_del(&real_qp->xrcd_list);
 	else
 		real_qp = NULL;
@@ -1316,7 +1316,7 @@ static int __ib_destroy_shared_qp(struct ib_qp *qp)
 	if (real_qp) {
 		ret = ib_destroy_qp(real_qp);
 		if (!ret)
-			atomic_dec(&xrcd->usecnt);
+			refcount_dec(&xrcd->usecnt);
 		else
 			__ib_insert_xrcd_qp(xrcd, real_qp);
 	}
@@ -1334,7 +1334,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 
 	WARN_ON_ONCE(qp->mrs_used > 0);
 
-	if (atomic_read(&qp->usecnt))
+	if (refcount_read(&qp->usecnt))
 		return -EBUSY;
 
 	if (qp->real_qp != qp)
@@ -1352,15 +1352,15 @@ int ib_destroy_qp(struct ib_qp *qp)
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
 		if (pd)
-			atomic_dec(&pd->usecnt);
+			refcount_dec(&pd->usecnt);
 		if (scq)
-			atomic_dec(&scq->usecnt);
+			refcount_dec(&scq->usecnt);
 		if (rcq)
-			atomic_dec(&rcq->usecnt);
+			refcount_dec(&rcq->usecnt);
 		if (srq)
-			atomic_dec(&srq->usecnt);
+			refcount_dec(&srq->usecnt);
 		if (ind_tbl)
-			atomic_dec(&ind_tbl->usecnt);
+			refcount_dec(&ind_tbl->usecnt);
 	}
 
 	return ret;
@@ -1385,7 +1385,7 @@ struct ib_cq *ib_create_cq(struct ib_device *device,
 		cq->comp_handler  = comp_handler;
 		cq->event_handler = event_handler;
 		cq->cq_context    = cq_context;
-		atomic_set(&cq->usecnt, 0);
+		refcount_set(&cq->usecnt, 0);
 	}
 
 	return cq;
@@ -1401,7 +1401,7 @@ EXPORT_SYMBOL(ib_modify_cq);
 
 int ib_destroy_cq(struct ib_cq *cq)
 {
-	if (atomic_read(&cq->usecnt))
+	if (refcount_read(&cq->usecnt))
 		return -EBUSY;
 
 	return cq->device->destroy_cq(cq);
@@ -1424,7 +1424,7 @@ int ib_dereg_mr(struct ib_mr *mr)
 
 	ret = mr->device->dereg_mr(mr);
 	if (!ret)
-		atomic_dec(&pd->usecnt);
+		refcount_dec(&pd->usecnt);
 
 	return ret;
 }
@@ -1456,7 +1456,7 @@ struct ib_mr *ib_alloc_mr(struct ib_pd *pd,
 		mr->device  = pd->device;
 		mr->pd      = pd;
 		mr->uobject = NULL;
-		atomic_inc(&pd->usecnt);
+		refcount_inc(&pd->usecnt);
 		mr->need_inval = false;
 	}
 
@@ -1479,7 +1479,7 @@ struct ib_fmr *ib_alloc_fmr(struct ib_pd *pd,
 	if (!IS_ERR(fmr)) {
 		fmr->device = pd->device;
 		fmr->pd     = pd;
-		atomic_inc(&pd->usecnt);
+		refcount_inc(&pd->usecnt);
 	}
 
 	return fmr;
@@ -1506,7 +1506,7 @@ int ib_dealloc_fmr(struct ib_fmr *fmr)
 	pd = fmr->pd;
 	ret = fmr->device->dealloc_fmr(fmr);
 	if (!ret)
-		atomic_dec(&pd->usecnt);
+		refcount_dec(&pd->usecnt);
 
 	return ret;
 }
@@ -1525,7 +1525,7 @@ int ib_attach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 
 	ret = qp->device->attach_mcast(qp, gid, lid);
 	if (!ret)
-		atomic_inc(&qp->usecnt);
+		refcount_inc(&qp->usecnt);
 	return ret;
 }
 EXPORT_SYMBOL(ib_attach_mcast);
@@ -1541,7 +1541,7 @@ int ib_detach_mcast(struct ib_qp *qp, union ib_gid *gid, u16 lid)
 
 	ret = qp->device->detach_mcast(qp, gid, lid);
 	if (!ret)
-		atomic_dec(&qp->usecnt);
+		refcount_dec(&qp->usecnt);
 	return ret;
 }
 EXPORT_SYMBOL(ib_detach_mcast);
@@ -1557,7 +1557,7 @@ struct ib_xrcd *ib_alloc_xrcd(struct ib_device *device)
 	if (!IS_ERR(xrcd)) {
 		xrcd->device = device;
 		xrcd->inode = NULL;
-		atomic_set(&xrcd->usecnt, 0);
+		refcount_set(&xrcd->usecnt, 0);
 		mutex_init(&xrcd->tgt_qp_mutex);
 		INIT_LIST_HEAD(&xrcd->tgt_qp_list);
 	}
@@ -1571,7 +1571,7 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
 	struct ib_qp *qp;
 	int ret;
 
-	if (atomic_read(&xrcd->usecnt))
+	if (refcount_read(&xrcd->usecnt))
 		return -EBUSY;
 
 	while (!list_empty(&xrcd->tgt_qp_list)) {
@@ -1616,9 +1616,9 @@ struct ib_wq *ib_create_wq(struct ib_pd *pd,
 		wq->device = pd->device;
 		wq->pd = pd;
 		wq->uobject = NULL;
-		atomic_inc(&pd->usecnt);
-		atomic_inc(&wq_attr->cq->usecnt);
-		atomic_set(&wq->usecnt, 0);
+		refcount_inc(&pd->usecnt);
+		refcount_inc(&wq_attr->cq->usecnt);
+		refcount_set(&wq->usecnt, 0);
 	}
 	return wq;
 }
@@ -1634,13 +1634,13 @@ int ib_destroy_wq(struct ib_wq *wq)
 	struct ib_cq *cq = wq->cq;
 	struct ib_pd *pd = wq->pd;
 
-	if (atomic_read(&wq->usecnt))
+	if (refcount_read(&wq->usecnt))
 		return -EBUSY;
 
 	err = wq->device->destroy_wq(wq);
 	if (!err) {
-		atomic_dec(&pd->usecnt);
-		atomic_dec(&cq->usecnt);
+		refcount_dec(&pd->usecnt);
+		refcount_dec(&cq->usecnt);
 	}
 	return err;
 }
@@ -1697,10 +1697,10 @@ struct ib_rwq_ind_table *ib_create_rwq_ind_table(struct ib_device *device,
 	rwq_ind_table->log_ind_tbl_size = init_attr->log_ind_tbl_size;
 	rwq_ind_table->device = device;
 	rwq_ind_table->uobject = NULL;
-	atomic_set(&rwq_ind_table->usecnt, 0);
+	refcount_set(&rwq_ind_table->usecnt, 0);
 
 	for (i = 0; i < table_size; i++)
-		atomic_inc(&rwq_ind_table->ind_tbl[i]->usecnt);
+		refcount_inc(&rwq_ind_table->ind_tbl[i]->usecnt);
 
 	return rwq_ind_table;
 }
@@ -1716,13 +1716,13 @@ int ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *rwq_ind_table)
 	u32 table_size = (1 << rwq_ind_table->log_ind_tbl_size);
 	struct ib_wq **ind_tbl = rwq_ind_table->ind_tbl;
 
-	if (atomic_read(&rwq_ind_table->usecnt))
+	if (refcount_read(&rwq_ind_table->usecnt))
 		return -EBUSY;
 
 	err = rwq_ind_table->device->destroy_rwq_ind_table(rwq_ind_table);
 	if (!err) {
 		for (i = 0; i < table_size; i++)
-			atomic_dec(&ind_tbl[i]->usecnt);
+			refcount_dec(&ind_tbl[i]->usecnt);
 	}
 
 	return err;
@@ -1739,7 +1739,7 @@ struct ib_flow *ib_create_flow(struct ib_qp *qp,
 
 	flow_id = qp->device->create_flow(qp, flow_attr, domain);
 	if (!IS_ERR(flow_id)) {
-		atomic_inc(&qp->usecnt);
+		refcount_inc(&qp->usecnt);
 		flow_id->qp = qp;
 	}
 	return flow_id;
@@ -1753,7 +1753,7 @@ int ib_destroy_flow(struct ib_flow *flow_id)
 
 	err = qp->device->destroy_flow(flow_id);
 	if (!err)
-		atomic_dec(&qp->usecnt);
+		refcount_dec(&qp->usecnt);
 	return err;
 }
 EXPORT_SYMBOL(ib_destroy_flow);
diff --git a/drivers/infiniband/hw/cxgb3/iwch_ev.c b/drivers/infiniband/hw/cxgb3/iwch_ev.c
index abcc9e7..3196a36 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_ev.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_ev.c
@@ -74,7 +74,7 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	       CQE_STATUS(rsp_msg->cqe), CQE_TYPE(rsp_msg->cqe),
 	       CQE_WRID_HI(rsp_msg->cqe), CQE_WRID_LOW(rsp_msg->cqe));
 
-	atomic_inc(&qhp->refcnt);
+	refcount_inc(&qhp->refcnt);
 	spin_unlock(&rnicp->lock);
 
 	if (qhp->attr.state == IWCH_QP_STATE_RTS) {
@@ -99,7 +99,7 @@ static void post_qp_event(struct iwch_dev *rnicp, struct iwch_cq *chp,
 	(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 	spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
 
-	if (atomic_dec_and_test(&qhp->refcnt))
+	if (refcount_dec_and_test(&qhp->refcnt))
 		wake_up(&qhp->wait);
 }
 
@@ -127,7 +127,7 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 		goto out;
 	}
 	iwch_qp_add_ref(&qhp->ibqp);
-	atomic_inc(&chp->refcnt);
+	refcount_inc(&chp->refcnt);
 	spin_unlock(&rnicp->lock);
 
 	/*
@@ -224,7 +224,7 @@ void iwch_ev_dispatch(struct cxio_rdev *rdev_p, struct sk_buff *skb)
 		break;
 	}
 done:
-	if (atomic_dec_and_test(&chp->refcnt))
+	if (refcount_dec_and_test(&chp->refcnt))
 	        wake_up(&chp->wait);
 	iwch_qp_rem_ref(&qhp->ibqp);
 out:
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 9d5fe18..041963a 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -135,8 +135,8 @@ static int iwch_destroy_cq(struct ib_cq *ib_cq)
 	chp = to_iwch_cq(ib_cq);
 
 	remove_handle(chp->rhp, &chp->rhp->cqidr, chp->cq.cqid);
-	atomic_dec(&chp->refcnt);
-	wait_event(chp->wait, !atomic_read(&chp->refcnt));
+	refcount_dec(&chp->refcnt);
+	wait_event(chp->wait, !refcount_read(&chp->refcnt));
 
 	cxio_destroy_cq(&chp->rhp->rdev, &chp->cq);
 	kfree(chp);
@@ -201,7 +201,7 @@ static struct ib_cq *iwch_create_cq(struct ib_device *ibdev,
 	chp->ibcq.cqe = 1 << chp->cq.size_log2;
 	spin_lock_init(&chp->lock);
 	spin_lock_init(&chp->comp_handler_lock);
-	atomic_set(&chp->refcnt, 1);
+	refcount_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);
 	if (insert_handle(rhp, &rhp->cqidr, chp, chp->cq.cqid)) {
 		cxio_destroy_cq(&chp->rhp->rdev, &chp->cq);
@@ -810,8 +810,8 @@ static int iwch_destroy_qp(struct ib_qp *ib_qp)
 
 	remove_handle(rhp, &rhp->qpidr, qhp->wq.qpid);
 
-	atomic_dec(&qhp->refcnt);
-	wait_event(qhp->wait, !atomic_read(&qhp->refcnt));
+	refcount_dec(&qhp->refcnt);
+	wait_event(qhp->wait, !refcount_read(&qhp->refcnt));
 
 	ucontext = ib_qp->uobject ? to_iwch_ucontext(ib_qp->uobject->context)
 				  : NULL;
@@ -921,7 +921,7 @@ static struct ib_qp *iwch_create_qp(struct ib_pd *pd,
 
 	spin_lock_init(&qhp->lock);
 	init_waitqueue_head(&qhp->wait);
-	atomic_set(&qhp->refcnt, 1);
+	refcount_set(&qhp->refcnt, 1);
 
 	if (insert_handle(rhp, &rhp->qpidr, qhp, qhp->wq.qpid)) {
 		cxio_destroy_qp(&rhp->rdev, &qhp->wq,
@@ -1024,13 +1024,13 @@ static int iwch_ib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 void iwch_qp_add_ref(struct ib_qp *qp)
 {
 	PDBG("%s ib_qp %p\n", __func__, qp);
-	atomic_inc(&(to_iwch_qp(qp)->refcnt));
+	refcount_inc(&(to_iwch_qp(qp)->refcnt));
 }
 
 void iwch_qp_rem_ref(struct ib_qp *qp)
 {
 	PDBG("%s ib_qp %p\n", __func__, qp);
-	if (atomic_dec_and_test(&(to_iwch_qp(qp)->refcnt)))
+	if (refcount_dec_and_test(&(to_iwch_qp(qp)->refcnt)))
 	        wake_up(&(to_iwch_qp(qp)->wait));
 }
 
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.h b/drivers/infiniband/hw/cxgb3/iwch_provider.h
index 252c464..f70ba41 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.h
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.h
@@ -34,6 +34,7 @@
 
 #include <linux/list.h>
 #include <linux/spinlock.h>
+#include <linux/refcount.h>
 #include <rdma/ib_verbs.h>
 #include <asm/types.h>
 #include "t3cdev.h"
@@ -106,7 +107,7 @@ struct iwch_cq {
 	struct t3_cq cq;
 	spinlock_t lock;
 	spinlock_t comp_handler_lock;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	wait_queue_head_t wait;
 	u32 __user *user_rptr_addr;
 };
@@ -165,7 +166,7 @@ struct iwch_qp {
 	struct iwch_qp_attributes attr;
 	struct t3_wq wq;
 	spinlock_t lock;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	wait_queue_head_t wait;
 	enum IWCH_QP_FLAGS flags;
 	struct timer_list timer;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_qp.c b/drivers/infiniband/hw/cxgb3/iwch_qp.c
index a9194db..17f94a0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_qp.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_qp.c
@@ -731,7 +731,7 @@ static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
 
 	PDBG("%s qhp %p rchp %p schp %p\n", __func__, qhp, rchp, schp);
 	/* take a ref on the qhp since we must release the lock */
-	atomic_inc(&qhp->refcnt);
+	refcount_inc(&qhp->refcnt);
 	spin_unlock(&qhp->lock);
 
 	/* locking hierarchy: cq lock first, then qp lock. */
@@ -763,7 +763,7 @@ static void __flush_qp(struct iwch_qp *qhp, struct iwch_cq *rchp,
 	}
 
 	/* deref */
-	if (atomic_dec_and_test(&qhp->refcnt))
+	if (refcount_dec_and_test(&qhp->refcnt))
 	        wake_up(&qhp->wait);
 
 	spin_lock(&qhp->lock);
diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 19c6477..cab3df3 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -859,8 +859,8 @@ int c4iw_destroy_cq(struct ib_cq *ib_cq)
 	chp = to_c4iw_cq(ib_cq);
 
 	remove_handle(chp->rhp, &chp->rhp->cqidr, chp->cq.cqid);
-	atomic_dec(&chp->refcnt);
-	wait_event(chp->wait, !atomic_read(&chp->refcnt));
+	refcount_dec(&chp->refcnt);
+	wait_event(chp->wait, !refcount_read(&chp->refcnt));
 
 	ucontext = ib_cq->uobject ? to_c4iw_ucontext(ib_cq->uobject->context)
 				  : NULL;
@@ -954,7 +954,7 @@ struct ib_cq *c4iw_create_cq(struct ib_device *ibdev,
 	chp->ibcq.cqe = entries - 2;
 	spin_lock_init(&chp->lock);
 	spin_lock_init(&chp->comp_handler_lock);
-	atomic_set(&chp->refcnt, 1);
+	refcount_set(&chp->refcnt, 1);
 	init_waitqueue_head(&chp->wait);
 	ret = insert_handle(rhp, &rhp->cqidr, chp, chp->cq.cqid);
 	if (ret)
diff --git a/drivers/infiniband/hw/cxgb4/ev.c b/drivers/infiniband/hw/cxgb4/ev.c
index bdfac2c..e95609d 100644
--- a/drivers/infiniband/hw/cxgb4/ev.c
+++ b/drivers/infiniband/hw/cxgb4/ev.c
@@ -151,7 +151,7 @@ void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe)
 	}
 
 	c4iw_qp_add_ref(&qhp->ibqp);
-	atomic_inc(&chp->refcnt);
+	refcount_inc(&chp->refcnt);
 	spin_unlock_irq(&dev->lock);
 
 	/* Bad incoming write */
@@ -213,7 +213,7 @@ void c4iw_ev_dispatch(struct c4iw_dev *dev, struct t4_cqe *err_cqe)
 		break;
 	}
 done:
-	if (atomic_dec_and_test(&chp->refcnt))
+	if (refcount_dec_and_test(&chp->refcnt))
 		wake_up(&chp->wait);
 	c4iw_qp_rem_ref(&qhp->ibqp);
 out:
@@ -228,13 +228,13 @@ int c4iw_ev_handler(struct c4iw_dev *dev, u32 qid)
 	spin_lock_irqsave(&dev->lock, flag);
 	chp = get_chp(dev, qid);
 	if (chp) {
-		atomic_inc(&chp->refcnt);
+		refcount_inc(&chp->refcnt);
 		spin_unlock_irqrestore(&dev->lock, flag);
 		t4_clear_cq_armed(&chp->cq);
 		spin_lock_irqsave(&chp->comp_handler_lock, flag);
 		(*chp->ibcq.comp_handler)(&chp->ibcq, chp->ibcq.cq_context);
 		spin_unlock_irqrestore(&chp->comp_handler_lock, flag);
-		if (atomic_dec_and_test(&chp->refcnt))
+		if (refcount_dec_and_test(&chp->refcnt))
 			wake_up(&chp->wait);
 	} else {
 		PDBG("%s unknown cqid 0x%x\n", __func__, qid);
diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
index 4dc1415..a236a90 100644
--- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
+++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
@@ -45,6 +45,7 @@
 #include <linux/kref.h>
 #include <linux/timer.h>
 #include <linux/io.h>
+#include <linux/refcount.h>
 
 #include <asm/byteorder.h>
 
@@ -419,7 +420,7 @@ struct c4iw_cq {
 	struct t4_cq cq;
 	spinlock_t lock;
 	spinlock_t comp_handler_lock;
-	atomic_t refcnt;
+	refcount_t refcnt;
 	wait_queue_head_t wait;
 };
 
diff --git a/drivers/infiniband/hw/hfi1/qp.c b/drivers/infiniband/hw/hfi1/qp.c
index d752d67..b8bc0e6 100644
--- a/drivers/infiniband/hw/hfi1/qp.c
+++ b/drivers/infiniband/hw/hfi1/qp.c
@@ -748,7 +748,7 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter)
 		   iter->n,
 		   qp_idle(qp) ? "I" : "B",
 		   qp->ibqp.qp_num,
-		   atomic_read(&qp->refcount),
+		   refcount_read(&qp->refcount),
 		   qp_type_str[qp->ibqp.qp_type],
 		   qp->state,
 		   wqe ? wqe->wr.opcode : 0,
diff --git a/drivers/infiniband/hw/hfi1/ruc.c b/drivers/infiniband/hw/hfi1/ruc.c
index 717ed4b15..d1fd652 100644
--- a/drivers/infiniband/hw/hfi1/ruc.c
+++ b/drivers/infiniband/hw/hfi1/ruc.c
@@ -957,7 +957,7 @@ void hfi1_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)
-		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
+		refcount_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	rvt_qp_swqe_complete(qp, wqe, status);
 
diff --git a/drivers/infiniband/hw/hfi1/user_sdma.c b/drivers/infiniband/hw/hfi1/user_sdma.c
index 7d22f8e..fa5e5c9 100644
--- a/drivers/infiniband/hw/hfi1/user_sdma.c
+++ b/drivers/infiniband/hw/hfi1/user_sdma.c
@@ -60,6 +60,7 @@
 #include <linux/mmu_context.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/refcount.h>
 
 #include "hfi.h"
 #include "sdma.h"
@@ -190,7 +191,7 @@ struct user_sdma_iovec {
 struct sdma_mmu_node {
 	struct mmu_rb_node rb;
 	struct hfi1_user_sdma_pkt_q *pq;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct page **pages;
 	unsigned npages;
 };
@@ -1178,7 +1179,7 @@ static int pin_vector_pages(struct user_sdma_request *req,
 
 		node->rb.addr = (unsigned long)iovec->iov.iov_base;
 		node->pq = pq;
-		atomic_set(&node->refcount, 0);
+		refcount_set(&node->refcount, 0);
 	}
 
 	npages = num_user_pages(&iovec->iov);
@@ -1602,7 +1603,7 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 				hfi1_mmu_rb_remove(req->pq->handler,
 						   &node->rb);
 			else
-				atomic_dec(&node->refcount);
+				refcount_dec(&node->refcount);
 		}
 	}
 	kfree(req->tids);
@@ -1634,7 +1635,7 @@ static int sdma_rb_insert(void *arg, struct mmu_rb_node *mnode)
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
-	atomic_inc(&node->refcount);
+	refcount_inc(&node->refcount);
 	return 0;
 }
 
@@ -1651,7 +1652,7 @@ static int sdma_rb_evict(void *arg, struct mmu_rb_node *mnode,
 	struct evict_data *evict_data = evict_arg;
 
 	/* is this node still being used? */
-	if (atomic_read(&node->refcount))
+	if (refcount_read(&node->refcount))
 		return 0; /* keep this node */
 
 	/* this node will be evicted, add its pages to our count */
@@ -1681,7 +1682,7 @@ static int sdma_rb_invalidate(void *arg, struct mmu_rb_node *mnode)
 	struct sdma_mmu_node *node =
 		container_of(mnode, struct sdma_mmu_node, rb);
 
-	if (!atomic_read(&node->refcount))
+	if (!refcount_read(&node->refcount))
 		return 1;
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 589496c..3605adb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -152,7 +152,7 @@ static int hns_roce_cq_alloc(struct hns_roce_dev *hr_dev, int nent,
 	hr_cq->cons_index = 0;
 	hr_cq->uar = hr_uar;
 
-	atomic_set(&hr_cq->refcount, 1);
+	refcount_set(&hr_cq->refcount, 1);
 	init_completion(&hr_cq->free);
 
 	return 0;
@@ -194,7 +194,7 @@ void hns_roce_free_cq(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	synchronize_irq(hr_dev->eq_table.eq[hr_cq->vector].irq);
 
 	/* wait for all interrupt processed */
-	if (atomic_dec_and_test(&hr_cq->refcount))
+	if (refcount_dec_and_test(&hr_cq->refcount))
 		complete(&hr_cq->free);
 	wait_for_completion(&hr_cq->free);
 
@@ -436,7 +436,7 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
 	cq = radix_tree_lookup(&cq_table->tree,
 			       cqn & (hr_dev->caps.num_cqs - 1));
 	if (cq)
-		atomic_inc(&cq->refcount);
+		refcount_inc(&cq->refcount);
 
 	if (!cq) {
 		dev_warn(dev, "Async event for bogus CQ %08x\n", cqn);
@@ -445,7 +445,7 @@ void hns_roce_cq_event(struct hns_roce_dev *hr_dev, u32 cqn, int event_type)
 
 	cq->event(cq, (enum hns_roce_event)event_type);
 
-	if (atomic_dec_and_test(&cq->refcount))
+	if (refcount_dec_and_test(&cq->refcount))
 		complete(&cq->free);
 }
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 1a6cb5d..23aebb6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -33,6 +33,7 @@
 #ifndef _HNS_ROCE_DEVICE_H
 #define _HNS_ROCE_DEVICE_H
 
+#include <linux/refcount.h>
 #include <rdma/ib_verbs.h>
 
 #define DRV_NAME "hns_roce"
@@ -310,7 +311,7 @@ struct hns_roce_cq {
 	u16				*tptr_addr;
 	unsigned long			cqn;
 	u32				vector;
-	atomic_t			refcount;
+	refcount_t			refcount;
 	struct completion		free;
 };
 
@@ -427,7 +428,7 @@ struct hns_roce_qp {
 					 enum hns_roce_event);
 	unsigned long		qpn;
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index f036f32..83bcf40 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -51,7 +51,7 @@ void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
 
 	qp = __hns_roce_qp_lookup(hr_dev, qpn);
 	if (qp)
-		atomic_inc(&qp->refcount);
+		refcount_inc(&qp->refcount);
 
 	spin_unlock(&qp_table->lock);
 
@@ -62,7 +62,7 @@ void hns_roce_qp_event(struct hns_roce_dev *hr_dev, u32 qpn, int event_type)
 
 	qp->event(qp, (enum hns_roce_event)event_type);
 
-	if (atomic_dec_and_test(&qp->refcount))
+	if (refcount_dec_and_test(&qp->refcount))
 		complete(&qp->free);
 }
 
@@ -157,7 +157,7 @@ static int hns_roce_gsi_qp_alloc(struct hns_roce_dev *hr_dev, unsigned long qpn,
 		goto err_put_irrl;
 	}
 
-	atomic_set(&hr_qp->refcount, 1);
+	refcount_set(&hr_qp->refcount, 1);
 	init_completion(&hr_qp->free);
 
 	return 0;
@@ -202,7 +202,7 @@ static int hns_roce_qp_alloc(struct hns_roce_dev *hr_dev, unsigned long qpn,
 		goto err_put_irrl;
 	}
 
-	atomic_set(&hr_qp->refcount, 1);
+	refcount_set(&hr_qp->refcount, 1);
 	init_completion(&hr_qp->free);
 
 	return 0;
@@ -232,7 +232,7 @@ void hns_roce_qp_free(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 {
 	struct hns_roce_qp_table *qp_table = &hr_dev->qp_table;
 
-	if (atomic_dec_and_test(&hr_qp->refcount))
+	if (refcount_dec_and_test(&hr_qp->refcount))
 		complete(&hr_qp->free);
 	wait_for_completion(&hr_qp->free);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw.h b/drivers/infiniband/hw/i40iw/i40iw.h
index da2eb5a..0be1b50 100644
--- a/drivers/infiniband/hw/i40iw/i40iw.h
+++ b/drivers/infiniband/hw/i40iw/i40iw.h
@@ -45,6 +45,7 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 #include <linux/crc32c.h>
+#include <linux/refcount.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_pack.h>
@@ -140,7 +141,7 @@ struct i40iw_cqp_request {
 	struct cqp_commands_info info;
 	wait_queue_head_t waitq;
 	struct list_head list;
-	atomic_t refcount;
+	refcount_t refcount;
 	void (*callback_fcn)(struct i40iw_cqp_request*, u32);
 	void *param;
 	struct i40iw_cqp_compl_info compl_info;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 95a0586..388d3dc 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -76,7 +76,7 @@ void i40iw_free_sqbuf(struct i40iw_sc_vsi *vsi, void *bufp)
 	struct i40iw_puda_buf *buf = (struct i40iw_puda_buf *)bufp;
 	struct i40iw_puda_rsrc *ilq = vsi->ilq;
 
-	if (!atomic_dec_return(&buf->refcount))
+	if (refcount_dec_and_test(&buf->refcount))
 		i40iw_puda_ret_bufpool(ilq, buf);
 }
 
@@ -345,7 +345,7 @@ static void i40iw_free_retrans_entry(struct i40iw_cm_node *cm_node)
 		cm_node->send_entry = NULL;
 		i40iw_free_sqbuf(&iwdev->vsi, (void *)send_entry->sqbuf);
 		kfree(send_entry);
-		atomic_dec(&cm_node->ref_count);
+		refcount_dec(&cm_node->ref_count);
 	}
 }
 
@@ -532,7 +532,7 @@ static struct i40iw_puda_buf *i40iw_form_cm_frame(struct i40iw_cm_node *cm_node,
 	if (pdata && pdata->addr)
 		memcpy(buf, pdata->addr, pdata->size);
 
-	atomic_set(&sqbuf->refcount, 1);
+	refcount_set(&sqbuf->refcount, 1);
 
 	return sqbuf;
 }
@@ -571,7 +571,7 @@ static void i40iw_active_open_err(struct i40iw_cm_node *cm_node, bool reset)
 			    __func__,
 			    cm_node,
 			    cm_node->state);
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 	}
 
@@ -1093,11 +1093,11 @@ int i40iw_schedule_cm_timer(struct i40iw_cm_node *cm_node,
 	if (type == I40IW_TIMER_TYPE_SEND) {
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
 		cm_node->send_entry = new_send;
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		spin_unlock_irqrestore(&cm_node->retrans_list_lock, flags);
 		new_send->timetosend = jiffies + I40IW_RETRY_TIMEOUT;
 
-		atomic_inc(&sqbuf->refcount);
+		refcount_inc(&sqbuf->refcount);
 		i40iw_puda_send_buf(vsi->ilq, sqbuf);
 		if (!send_retrans) {
 			i40iw_cleanup_retrans_entry(cm_node);
@@ -1141,7 +1141,7 @@ static void i40iw_retrans_expired(struct i40iw_cm_node *cm_node)
 		i40iw_send_reset(cm_node);
 		break;
 	default:
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 		i40iw_create_event(cm_node, I40IW_CM_EVENT_ABORTED);
 		break;
@@ -1211,7 +1211,7 @@ static void i40iw_cm_timer_tick(unsigned long pass)
 	list_for_each_safe(list_node, list_core_temp, &cm_core->connected_nodes) {
 		cm_node = container_of(list_node, struct i40iw_cm_node, list);
 		if (cm_node->close_entry || cm_node->send_entry) {
-			atomic_inc(&cm_node->ref_count);
+			refcount_inc(&cm_node->ref_count);
 			list_add(&cm_node->timer_entry, &timer_list);
 		}
 	}
@@ -1273,7 +1273,7 @@ static void i40iw_cm_timer_tick(unsigned long pass)
 
 		vsi = &cm_node->iwdev->vsi;
 		dev = cm_node->dev;
-		atomic_inc(&send_entry->sqbuf->refcount);
+		refcount_inc(&send_entry->sqbuf->refcount);
 		i40iw_puda_send_buf(vsi->ilq, send_entry->sqbuf);
 		spin_lock_irqsave(&cm_node->retrans_list_lock, flags);
 		if (send_entry->send_retrans) {
@@ -1430,7 +1430,7 @@ struct i40iw_cm_node *i40iw_find_node(struct i40iw_cm_core *cm_core,
 		    !memcmp(cm_node->rem_addr, rem_addr, sizeof(cm_node->rem_addr)) &&
 		    (cm_node->rem_port == rem_port)) {
 			if (add_refcnt)
-				atomic_inc(&cm_node->ref_count);
+				refcount_inc(&cm_node->ref_count);
 			spin_unlock_irqrestore(&cm_core->ht_lock, flags);
 			return cm_node;
 		}
@@ -1472,7 +1472,7 @@ static struct i40iw_cm_listener *i40iw_find_listener(
 		     !memcmp(listen_addr, ip_zero, sizeof(listen_addr))) &&
 		     (listen_port == dst_port) &&
 		     (listener_state & listen_node->listener_state)) {
-			atomic_inc(&listen_node->ref_count);
+			refcount_inc(&listen_node->ref_count);
 			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 			return listen_node;
 		}
@@ -1822,7 +1822,7 @@ static int i40iw_dec_refcnt_listen(struct i40iw_cm_core *cm_core,
 		list_for_each_safe(list_pos, list_temp, &cm_core->connected_nodes) {
 			cm_node = container_of(list_pos, struct i40iw_cm_node, list);
 			if ((cm_node->listener == listener) && !cm_node->accelerated) {
-				atomic_inc(&cm_node->ref_count);
+				refcount_inc(&cm_node->ref_count);
 				list_add(&cm_node->reset_entry, &reset_list);
 			}
 		}
@@ -1859,7 +1859,7 @@ static int i40iw_dec_refcnt_listen(struct i40iw_cm_core *cm_core,
 				event.cm_info.loc_port = loopback->loc_port;
 				event.cm_info.cm_id = loopback->cm_id;
 				event.cm_info.ipv4 = loopback->ipv4;
-				atomic_inc(&loopback->ref_count);
+				refcount_inc(&loopback->ref_count);
 				loopback->state = I40IW_CM_STATE_CLOSED;
 				i40iw_event_connect_error(&event);
 				cm_node->state = I40IW_CM_STATE_LISTENER_DESTROYED;
@@ -1868,7 +1868,7 @@ static int i40iw_dec_refcnt_listen(struct i40iw_cm_core *cm_core,
 		}
 	}
 
-	if (!atomic_dec_return(&listener->ref_count)) {
+	if (refcount_dec_and_test(&listener->ref_count)) {
 		spin_lock_irqsave(&cm_core->listen_list_lock, flags);
 		list_del(&listener->list);
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
@@ -2171,7 +2171,7 @@ static struct i40iw_cm_node *i40iw_make_cm_node(
 	ether_addr_copy(cm_node->loc_mac, netdev->dev_addr);
 	spin_lock_init(&cm_node->retrans_list_lock);
 
-	atomic_set(&cm_node->ref_count, 1);
+	refcount_set(&cm_node->ref_count, 1);
 	/* associate our parent CM core */
 	cm_node->cm_core = cm_core;
 	cm_node->tcp_cntxt.loc_id = I40IW_CM_DEF_LOCAL_ID;
@@ -2236,7 +2236,7 @@ static void i40iw_rem_ref_cm_node(struct i40iw_cm_node *cm_node)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cm_node->cm_core->ht_lock, flags);
-	if (atomic_dec_return(&cm_node->ref_count)) {
+	if (!refcount_dec_and_test(&cm_node->ref_count)) {
 		spin_unlock_irqrestore(&cm_node->cm_core->ht_lock, flags);
 		return;
 	}
@@ -2314,7 +2314,7 @@ static void i40iw_handle_fin_pkt(struct i40iw_cm_node *cm_node)
 		cm_node->tcp_cntxt.rcv_nxt++;
 		i40iw_cleanup_retrans_entry(cm_node);
 		cm_node->state = I40IW_CM_STATE_CLOSED;
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 		break;
 	case I40IW_CM_STATE_FIN_WAIT1:
@@ -2574,7 +2574,7 @@ static void i40iw_handle_syn_pkt(struct i40iw_cm_node *cm_node,
 		break;
 	case I40IW_CM_STATE_CLOSED:
 		i40iw_cleanup_retrans_entry(cm_node);
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 		break;
 	case I40IW_CM_STATE_OFFLOADED:
@@ -2648,7 +2648,7 @@ static void i40iw_handle_synack_pkt(struct i40iw_cm_node *cm_node,
 	case I40IW_CM_STATE_CLOSED:
 		cm_node->tcp_cntxt.loc_seq_num = ntohl(tcph->ack_seq);
 		i40iw_cleanup_retrans_entry(cm_node);
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 		break;
 	case I40IW_CM_STATE_ESTABLISHED:
@@ -2718,7 +2718,7 @@ static int i40iw_handle_ack_pkt(struct i40iw_cm_node *cm_node,
 		break;
 	case I40IW_CM_STATE_CLOSED:
 		i40iw_cleanup_retrans_entry(cm_node);
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 		i40iw_send_reset(cm_node);
 		break;
 	case I40IW_CM_STATE_LAST_ACK:
@@ -2814,7 +2814,7 @@ static struct i40iw_cm_listener *i40iw_make_listen_node(
 				       I40IW_CM_LISTENER_EITHER_STATE);
 	if (listener &&
 	    (listener->listener_state == I40IW_CM_LISTENER_ACTIVE_STATE)) {
-		atomic_dec(&listener->ref_count);
+		refcount_dec(&listener->ref_count);
 		i40iw_debug(cm_core->dev,
 			    I40IW_DEBUG_CM,
 			    "Not creating listener since it already exists\n");
@@ -2832,7 +2832,7 @@ static struct i40iw_cm_listener *i40iw_make_listen_node(
 
 		INIT_LIST_HEAD(&listener->child_listen_list);
 
-		atomic_set(&listener->ref_count, 1);
+		refcount_set(&listener->ref_count, 1);
 	} else {
 		listener->reused_node = 1;
 	}
@@ -3151,7 +3151,7 @@ void i40iw_receive_ilq(struct i40iw_sc_vsi *vsi, struct i40iw_puda_buf *rbuf)
 				    I40IW_DEBUG_CM,
 				    "%s allocate node failed\n",
 				    __func__);
-			atomic_dec(&listener->ref_count);
+			refcount_dec(&listener->ref_count);
 			return;
 		}
 		if (!tcph->rst && !tcph->fin) {
@@ -3160,7 +3160,7 @@ void i40iw_receive_ilq(struct i40iw_sc_vsi *vsi, struct i40iw_puda_buf *rbuf)
 			i40iw_rem_ref_cm_node(cm_node);
 			return;
 		}
-		atomic_inc(&cm_node->ref_count);
+		refcount_inc(&cm_node->ref_count);
 	} else if (cm_node->state == I40IW_CM_STATE_OFFLOADED) {
 		i40iw_rem_ref_cm_node(cm_node);
 		return;
@@ -4166,7 +4166,7 @@ static void i40iw_cm_event_handler(struct work_struct *work)
  */
 static void i40iw_cm_post_event(struct i40iw_cm_event *event)
 {
-	atomic_inc(&event->cm_node->ref_count);
+	refcount_inc(&event->cm_node->ref_count);
 	event->cm_info.cm_id->add_ref(event->cm_info.cm_id);
 	INIT_WORK(&event->event_work, i40iw_cm_event_handler);
 
diff --git a/drivers/infiniband/hw/i40iw/i40iw_main.c b/drivers/infiniband/hw/i40iw/i40iw_main.c
index 2728af3..53549b4 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_main.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_main.c
@@ -1113,7 +1113,7 @@ static enum i40iw_status_code i40iw_alloc_local_mac_ipaddr_entry(struct i40iw_de
 	}
 
 	/* increment refcount, because we need the cqp request ret value */
-	atomic_inc(&cqp_request->refcount);
+	refcount_inc(&cqp_request->refcount);
 
 	cqp_info = &cqp_request->info;
 	cqp_info->cqp_cmd = OP_ALLOC_LOCAL_MAC_IPADDR_ENTRY;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_puda.h b/drivers/infiniband/hw/i40iw/i40iw_puda.h
index dba05ce..0f8f06a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_puda.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_puda.h
@@ -35,6 +35,8 @@
 #ifndef I40IW_PUDA_H
 #define I40IW_PUDA_H
 
+#include <linux/refcount.h>
+
 #define I40IW_IEQ_MPA_FRAMING 6
 
 struct i40iw_sc_dev;
@@ -90,7 +92,7 @@ struct i40iw_puda_buf {
 	u8 tcphlen;		/* tcp length in bytes */
 	u8 maclen;		/* mac length in bytes */
 	u32 totallen;		/* machlen+iphlen+tcphlen+datalen */
-	atomic_t refcount;
+	refcount_t refcount;
 	u8 hdrlen;
 	bool ipv4;
 	u32 seqnum;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_utils.c b/drivers/infiniband/hw/i40iw/i40iw_utils.c
index 0f5d43d..9c4c5ee 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_utils.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_utils.c
@@ -314,10 +314,10 @@ struct i40iw_cqp_request *i40iw_get_cqp_request(struct i40iw_cqp *cqp, bool wait
 	}
 
 	if (wait) {
-		atomic_set(&cqp_request->refcount, 2);
+		refcount_set(&cqp_request->refcount, 2);
 		cqp_request->waiting = true;
 	} else {
-		atomic_set(&cqp_request->refcount, 1);
+		refcount_set(&cqp_request->refcount, 1);
 	}
 	return cqp_request;
 }
@@ -352,7 +352,7 @@ void i40iw_free_cqp_request(struct i40iw_cqp *cqp, struct i40iw_cqp_request *cqp
 void i40iw_put_cqp_request(struct i40iw_cqp *cqp,
 			   struct i40iw_cqp_request *cqp_request)
 {
-	if (atomic_dec_and_test(&cqp_request->refcount))
+	if (refcount_dec_and_test(&cqp_request->refcount))
 		i40iw_free_cqp_request(cqp, cqp_request);
 }
 
@@ -473,7 +473,7 @@ void i40iw_rem_devusecount(struct i40iw_device *iwdev)
  */
 void i40iw_add_pdusecount(struct i40iw_pd *iwpd)
 {
-	atomic_inc(&iwpd->usecount);
+	refcount_inc(&iwpd->usecount);
 }
 
 /**
@@ -483,7 +483,7 @@ void i40iw_add_pdusecount(struct i40iw_pd *iwpd)
  */
 void i40iw_rem_pdusecount(struct i40iw_pd *iwpd, struct i40iw_device *iwdev)
 {
-	if (!atomic_dec_and_test(&iwpd->usecount))
+	if (!refcount_dec_and_test(&iwpd->usecount))
 		return;
 	i40iw_free_resource(iwdev, iwdev->allocated_pds, iwpd->sc_pd.pd_id);
 	kfree(iwpd);
@@ -497,7 +497,7 @@ void i40iw_add_ref(struct ib_qp *ibqp)
 {
 	struct i40iw_qp *iwqp = (struct i40iw_qp *)ibqp;
 
-	atomic_inc(&iwqp->refcount);
+	refcount_inc(&iwqp->refcount);
 }
 
 /**
@@ -517,7 +517,7 @@ void i40iw_rem_ref(struct ib_qp *ibqp)
 	iwqp = to_iwqp(ibqp);
 	iwdev = iwqp->iwdev;
 	spin_lock_irqsave(&iwdev->qptable_lock, flags);
-	if (!atomic_dec_and_test(&iwqp->refcount)) {
+	if (!refcount_dec_and_test(&iwqp->refcount)) {
 		spin_unlock_irqrestore(&iwdev->qptable_lock, flags);
 		return;
 	}
@@ -931,7 +931,7 @@ static void i40iw_cqp_manage_hmc_fcn_callback(struct i40iw_cqp_request *cqp_requ
 
 	if (hmcfcninfo && hmcfcninfo->callback_fcn) {
 		i40iw_debug(&iwdev->sc_dev, I40IW_DEBUG_HMC, "%s1\n", __func__);
-		atomic_inc(&cqp_request->refcount);
+		refcount_inc(&cqp_request->refcount);
 		work = &iwdev->virtchnl_w[hmcfcninfo->iw_vf_idx];
 		work->cqp_request = cqp_request;
 		INIT_WORK(&work->work, i40iw_cqp_manage_hmc_fcn_worker);
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index 29e97df..fd1073a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -264,7 +264,7 @@ static void i40iw_alloc_push_page(struct i40iw_device *iwdev, struct i40iw_sc_qp
 	if (!cqp_request)
 		return;
 
-	atomic_inc(&cqp_request->refcount);
+	refcount_inc(&cqp_request->refcount);
 
 	cqp_info = &cqp_request->info;
 	cqp_info->cqp_cmd = OP_MANAGE_PUSH_PAGE;
diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.h b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
index 07c3fec..14f70c3 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.h
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.h
@@ -35,6 +35,8 @@
 #ifndef I40IW_VERBS_H
 #define I40IW_VERBS_H
 
+#include <linux/refcount.h>
+
 struct i40iw_ucontext {
 	struct ib_ucontext ibucontext;
 	struct i40iw_device *iwdev;
@@ -140,7 +142,7 @@ struct i40iw_qp {
 	struct i40iw_qp_host_ctx_info ctx_info;
 	struct i40iwarp_offload_info iwarp_info;
 	void *allocated_buffer;
-	atomic_t refcount;
+	refcount_t refcount;
 	struct iw_cm_id *cm_id;
 	void *cm_node;
 	struct ib_mr *lsmm_mr;
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index e010fe4..82c866d 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -38,6 +38,7 @@
 #include <linux/mlx4/cmd.h>
 #include <linux/rbtree.h>
 #include <linux/delay.h>
+#include <linux/refcount.h>
 
 #include "mlx4_ib.h"
 
@@ -121,7 +122,7 @@ struct mcast_group {
 	   2. Each invocation of the worker thread
 	   3. Membership of the port at the SA
 	*/
-	atomic_t		refcount;
+	refcount_t		refcount;
 
 	/* delayed work to clean pending SM request */
 	struct delayed_work	timeout_work;
@@ -138,9 +139,9 @@ struct mcast_req {
 };
 
 
-#define safe_atomic_dec(ref) \
+#define safe_refcount_dec(ref) \
 	do {\
-		if (atomic_dec_and_test(ref)) \
+		if (refcount_dec_and_test(ref)) \
 			mcg_warn_group(group, "did not expect to reach zero\n"); \
 	} while (0)
 
@@ -441,11 +442,11 @@ static int release_group(struct mcast_group *group, int from_timeout_handler)
 
 	mutex_lock(&ctx->mcg_table_lock);
 	mutex_lock(&group->lock);
-	if (atomic_dec_and_test(&group->refcount)) {
+	if (refcount_dec_and_test(&group->refcount)) {
 		if (!from_timeout_handler) {
 			if (group->state != MCAST_IDLE &&
 			    !cancel_delayed_work(&group->timeout_work)) {
-				atomic_inc(&group->refcount);
+				refcount_inc(&group->refcount);
 				mutex_unlock(&group->lock);
 				mutex_unlock(&ctx->mcg_table_lock);
 				return 0;
@@ -574,9 +575,9 @@ static void mlx4_ib_mcg_timeout_handler(struct work_struct *work)
 	} else
 		mcg_warn_group(group, "invalid state %s\n", get_state_string(group->state));
 	group->state = MCAST_IDLE;
-	atomic_inc(&group->refcount);
+	refcount_inc(&group->refcount);
 	if (!queue_work(group->demux->mcg_wq, &group->work))
-		safe_atomic_dec(&group->refcount);
+		safe_refcount_dec(&group->refcount);
 
 	mutex_unlock(&group->lock);
 }
@@ -775,7 +776,7 @@ static struct mcast_group *search_relocate_mgid0_group(struct mlx4_ib_demux_ctx
 					return NULL;
 				}
 
-				atomic_inc(&group->refcount);
+				refcount_inc(&group->refcount);
 				add_sysfs_port_mcg_attr(ctx->dev, ctx->port, &group->dentry.attr);
 				mutex_unlock(&group->lock);
 				mutex_unlock(&ctx->mcg_table_lock);
@@ -863,7 +864,7 @@ static struct mcast_group *acquire_group(struct mlx4_ib_demux_ctx *ctx,
 	add_sysfs_port_mcg_attr(ctx->dev, ctx->port, &group->dentry.attr);
 
 found:
-	atomic_inc(&group->refcount);
+	refcount_inc(&group->refcount);
 	return group;
 }
 
@@ -871,13 +872,13 @@ static void queue_req(struct mcast_req *req)
 {
 	struct mcast_group *group = req->group;
 
-	atomic_inc(&group->refcount); /* for the request */
-	atomic_inc(&group->refcount); /* for scheduling the work */
+	refcount_inc(&group->refcount); /* for the request */
+	refcount_inc(&group->refcount); /* for scheduling the work */
 	list_add_tail(&req->group_list, &group->pending_list);
 	list_add_tail(&req->func_list, &group->func[req->func].pending);
 	/* calls mlx4_ib_mcg_work_handler */
 	if (!queue_work(group->demux->mcg_wq, &group->work))
-		safe_atomic_dec(&group->refcount);
+		safe_refcount_dec(&group->refcount);
 }
 
 int mlx4_ib_mcg_demux_handler(struct ib_device *ibdev, int port, int slave,
@@ -911,9 +912,9 @@ int mlx4_ib_mcg_demux_handler(struct ib_device *ibdev, int port, int slave,
 		group->prev_state = group->state;
 		group->state = MCAST_RESP_READY;
 		/* calls mlx4_ib_mcg_work_handler */
-		atomic_inc(&group->refcount);
+		refcount_inc(&group->refcount);
 		if (!queue_work(ctx->mcg_wq, &group->work))
-			safe_atomic_dec(&group->refcount);
+			safe_refcount_dec(&group->refcount);
 		mutex_unlock(&group->lock);
 		release_group(group, 0);
 		return 1; /* consumed */
@@ -1014,7 +1015,7 @@ static ssize_t sysfs_show_group(struct device *dev,
 	len += sprintf(buf + len, "%1d [%02d,%02d,%02d] %4d %4s %5s     ",
 			group->rec.scope_join_state & 0xf,
 			group->members[2], group->members[1], group->members[0],
-			atomic_read(&group->refcount),
+			refcount_read(&group->refcount),
 			pending_str,
 			state_str);
 	for (f = 0; f < MAX_VFS; ++f)
@@ -1101,8 +1102,8 @@ static void _mlx4_ib_mcg_port_cleanup(struct mlx4_ib_demux_ctx *ctx, int destroy
 	mutex_lock(&ctx->mcg_table_lock);
 	while ((p = rb_first(&ctx->mcg_table)) != NULL) {
 		group = rb_entry(p, struct mcast_group, node);
-		if (atomic_read(&group->refcount))
-			mcg_warn_group(group, "group refcount %d!!! (pointer %p)\n", atomic_read(&group->refcount), group);
+		if (refcount_read(&group->refcount))
+			mcg_warn_group(group, "group refcount %d!!! (pointer %p)\n", refcount_read(&group->refcount), group);
 
 		force_clean_group(group);
 	}
@@ -1182,7 +1183,7 @@ static void clear_pending_reqs(struct mcast_group *group, int vf)
 			list_del(&req->group_list);
 			list_del(&req->func_list);
 			kfree(req);
-			atomic_dec(&group->refcount);
+			refcount_dec(&group->refcount);
 		}
 	}
 
@@ -1230,7 +1231,7 @@ void clean_vf_mcast(struct mlx4_ib_demux_ctx *ctx, int slave)
 	for (p = rb_first(&ctx->mcg_table); p; p = rb_next(p)) {
 		group = rb_entry(p, struct mcast_group, node);
 		mutex_lock(&group->lock);
-		if (atomic_read(&group->refcount)) {
+		if (refcount_read(&group->refcount)) {
 			/* clear pending requests of this VF */
 			clear_pending_reqs(group, slave);
 			push_deleteing_req(group, slave);
diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index b3ef47c..5c45cea 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -188,7 +188,7 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 			wqe_ctr = be16_to_cpu(cqe->wqe_counter);
 			wc->wr_id = srq->wrid[wqe_ctr];
 			mlx5_ib_free_srq_wqe(srq, wqe_ctr);
-			if (msrq && atomic_dec_and_test(&msrq->refcount))
+			if (msrq && refcount_dec_and_test(&msrq->refcount))
 				complete(&msrq->free);
 		}
 	} else {
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index d566f67..c938dda 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2645,7 +2645,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	}
 	devr->p0->device  = &dev->ib_dev;
 	devr->p0->uobject = NULL;
-	atomic_set(&devr->p0->usecnt, 0);
+	refcount_set(&devr->p0->usecnt, 0);
 
 	devr->c0 = mlx5_ib_create_cq(&dev->ib_dev, &cq_attr, NULL, NULL);
 	if (IS_ERR(devr->c0)) {
@@ -2657,7 +2657,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->c0->comp_handler  = NULL;
 	devr->c0->event_handler = NULL;
 	devr->c0->cq_context    = NULL;
-	atomic_set(&devr->c0->usecnt, 0);
+	refcount_set(&devr->c0->usecnt, 0);
 
 	devr->x0 = mlx5_ib_alloc_xrcd(&dev->ib_dev, NULL, NULL);
 	if (IS_ERR(devr->x0)) {
@@ -2666,7 +2666,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	}
 	devr->x0->device = &dev->ib_dev;
 	devr->x0->inode = NULL;
-	atomic_set(&devr->x0->usecnt, 0);
+	refcount_set(&devr->x0->usecnt, 0);
 	mutex_init(&devr->x0->tgt_qp_mutex);
 	INIT_LIST_HEAD(&devr->x0->tgt_qp_list);
 
@@ -2677,7 +2677,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	}
 	devr->x1->device = &dev->ib_dev;
 	devr->x1->inode = NULL;
-	atomic_set(&devr->x1->usecnt, 0);
+	refcount_set(&devr->x1->usecnt, 0);
 	mutex_init(&devr->x1->tgt_qp_mutex);
 	INIT_LIST_HEAD(&devr->x1->tgt_qp_list);
 
@@ -2701,10 +2701,10 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->s0->srq_type      = IB_SRQT_XRC;
 	devr->s0->ext.xrc.xrcd	= devr->x0;
 	devr->s0->ext.xrc.cq	= devr->c0;
-	atomic_inc(&devr->s0->ext.xrc.xrcd->usecnt);
-	atomic_inc(&devr->s0->ext.xrc.cq->usecnt);
-	atomic_inc(&devr->p0->usecnt);
-	atomic_set(&devr->s0->usecnt, 0);
+	refcount_inc(&devr->s0->ext.xrc.xrcd->usecnt);
+	refcount_inc(&devr->s0->ext.xrc.cq->usecnt);
+	refcount_inc(&devr->p0->usecnt);
+	refcount_set(&devr->s0->usecnt, 0);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.attr.max_sge = 1;
@@ -2722,8 +2722,8 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->s1->srq_context   = NULL;
 	devr->s1->srq_type      = IB_SRQT_BASIC;
 	devr->s1->ext.xrc.cq	= devr->c0;
-	atomic_inc(&devr->p0->usecnt);
-	atomic_set(&devr->s0->usecnt, 0);
+	refcount_inc(&devr->p0->usecnt);
+	refcount_set(&devr->s0->usecnt, 0);
 
 	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port) {
 		INIT_WORK(&devr->ports[port].pkey_change_work,
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 5b96010..ebeeac9 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -257,8 +257,8 @@ void nes_add_ref(struct ib_qp *ibqp)
 
 	nesqp = to_nesqp(ibqp);
 	nes_debug(NES_DBG_QP, "Bumping refcount for QP%u.  Pre-inc value = %u\n",
-			ibqp->qp_num, atomic_read(&nesqp->refcount));
-	atomic_inc(&nesqp->refcount);
+			ibqp->qp_num, refcount_read(&nesqp->refcount));
+	refcount_inc(&nesqp->refcount);
 }
 
 static void nes_cqp_rem_ref_callback(struct nes_device *nesdev, struct nes_cqp_request *cqp_request)
@@ -306,13 +306,13 @@ void nes_rem_ref(struct ib_qp *ibqp)
 
 	nesqp = to_nesqp(ibqp);
 
-	if (atomic_read(&nesqp->refcount) == 0) {
+	if (refcount_read(&nesqp->refcount) == 0) {
 		printk(KERN_INFO PFX "%s: Reference count already 0 for QP%d, last aeq = 0x%04X.\n",
 				__func__, ibqp->qp_num, nesqp->last_aeq);
 		BUG();
 	}
 
-	if (atomic_dec_and_test(&nesqp->refcount)) {
+	if (refcount_dec_and_test(&nesqp->refcount)) {
 		if (nesqp->pau_mode)
 			nes_destroy_pau_qp(nesdev, nesqp);
 
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 53eb47b..906d3c0 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -814,7 +814,7 @@ static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node)
 				  "refcount = %d: HIT A "
 				  "NES_TIMER_TYPE_CLOSE with something "
 				  "to do!!!\n", nesqp->hwqp.qp_id, cm_id,
-				  atomic_read(&nesqp->refcount));
+				  refcount_read(&nesqp->refcount));
 			nesqp->hw_tcp_state = NES_AEQE_TCP_STATE_CLOSED;
 			nesqp->last_aeq = NES_AEQE_AEID_RESET_SENT;
 			nesqp->ibqp_state = IB_QPS_ERR;
@@ -826,7 +826,7 @@ static void handle_recv_entry(struct nes_cm_node *cm_node, u32 rem_node)
 				  "refcount = %d: HIT A "
 				  "NES_TIMER_TYPE_CLOSE with nothing "
 				  "to do!!!\n", nesqp->hwqp.qp_id, cm_id,
-				  atomic_read(&nesqp->refcount));
+				  refcount_read(&nesqp->refcount));
 		}
 	} else if (rem_node) {
 		/* TIME_WAIT state */
@@ -1186,7 +1186,7 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
 		     listen_addr == 0x00000000) &&
 		    (listen_port == dst_port) &&
 		    (listener_state & listen_node->listener_state)) {
-			atomic_inc(&listen_node->ref_count);
+			refcount_inc(&listen_node->ref_count);
 			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 			return listen_node;
 		}
@@ -1240,7 +1240,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 
 	nes_debug(NES_DBG_CM, "attempting listener= %p free_nodes= %d, "
 		  "refcnt=%d\n", listener, free_hanging_nodes,
-		  atomic_read(&listener->ref_count));
+		  refcount_read(&listener->ref_count));
 	/* free non-accelerated child nodes for this listener */
 	INIT_LIST_HEAD(&reset_list);
 	if (free_hanging_nodes) {
@@ -1309,7 +1309,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 	}
 
 	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
-	if (!atomic_dec_return(&listener->ref_count)) {
+	if (refcount_dec_and_test(&listener->ref_count)) {
 		list_del(&listener->list);
 
 		/* decrement our listen node count */
@@ -1496,7 +1496,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 	spin_lock_init(&cm_node->retrans_list_lock);
 
 	cm_node->loopbackpartner = NULL;
-	atomic_set(&cm_node->ref_count, 1);
+	refcount_set(&cm_node->ref_count, 1);
 	/* associate our parent CM core */
 	cm_node->cm_core = cm_core;
 	cm_node->tcp_cntxt.loc_id = NES_CM_DEF_LOCAL_ID;
@@ -1548,7 +1548,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
  */
 static int add_ref_cm_node(struct nes_cm_node *cm_node)
 {
-	atomic_inc(&cm_node->ref_count);
+	refcount_inc(&cm_node->ref_count);
 	return 0;
 }
 
@@ -1566,7 +1566,7 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
 		return -EINVAL;
 
 	spin_lock_irqsave(&cm_node->cm_core->ht_lock, flags);
-	if (atomic_dec_return(&cm_node->ref_count)) {
+	if (!refcount_dec_and_test(&cm_node->ref_count)) {
 		spin_unlock_irqrestore(&cm_node->cm_core->ht_lock, flags);
 		return 0;
 	}
@@ -1668,7 +1668,7 @@ static void handle_fin_pkt(struct nes_cm_node *cm_node)
 {
 	nes_debug(NES_DBG_CM, "Received FIN, cm_node = %p, state = %u. "
 		  "refcnt=%d\n", cm_node, cm_node->state,
-		  atomic_read(&cm_node->ref_count));
+		  refcount_read(&cm_node->ref_count));
 	switch (cm_node->state) {
 	case NES_CM_STATE_SYN_RCVD:
 	case NES_CM_STATE_SYN_SENT:
@@ -1726,7 +1726,7 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 	atomic_inc(&cm_resets_recvd);
 	nes_debug(NES_DBG_CM, "Received Reset, cm_node = %p, state = %u."
 			" refcnt=%d\n", cm_node, cm_node->state,
-			atomic_read(&cm_node->ref_count));
+			refcount_read(&cm_node->ref_count));
 	cleanup_retrans_entry(cm_node);
 	switch (cm_node->state) {
 	case NES_CM_STATE_SYN_SENT:
@@ -2274,7 +2274,7 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 
 	if (listener && listener->listener_state == NES_CM_LISTENER_ACTIVE_STATE) {
 		/* find automatically incs ref count ??? */
-		atomic_dec(&listener->ref_count);
+		refcount_dec(&listener->ref_count);
 		nes_debug(NES_DBG_CM, "Not creating listener since it already exists\n");
 		return NULL;
 	}
@@ -2289,7 +2289,7 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
 		listener->loc_port = cm_info->loc_port;
 		listener->reused_node = 0;
 
-		atomic_set(&listener->ref_count, 1);
+		refcount_set(&listener->ref_count, 1);
 	}
 	/* pasive case */
 	/* find already inc'ed the ref count */
@@ -2624,7 +2624,7 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 				nes_debug(NES_DBG_CM, "Unable to allocate "
 					  "node\n");
 				cm_packets_dropped++;
-				atomic_dec(&listener->ref_count);
+				refcount_dec(&listener->ref_count);
 				dev_kfree_skb_any(skb);
 				break;
 			}
@@ -2976,7 +2976,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 				  "cm_id = %p, refcount = %u.\n",
 				  nesqp->hwqp.qp_id, nesqp->hwqp.sq_head,
 				  nesqp->hwqp.sq_tail, cm_id,
-				  atomic_read(&nesqp->refcount));
+				  refcount_read(&nesqp->refcount));
 
 			ret = cm_id->event_handler(cm_id, &cm_event);
 			if (ret)
diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
index d827d03..4a5812e 100644
--- a/drivers/infiniband/hw/nes/nes_cm.h
+++ b/drivers/infiniband/hw/nes/nes_cm.h
@@ -34,6 +34,8 @@
 #ifndef NES_CM_H
 #define NES_CM_H
 
+#include <linux/refcount.h>
+
 #define QUEUE_EVENTS
 
 #define NES_MANAGE_APBVT_DEL 0
@@ -297,7 +299,7 @@ struct nes_cm_listener {
 	u16                        loc_port;
 	struct iw_cm_id            *cm_id;
 	enum nes_cm_conn_type      conn_type;
-	atomic_t                   ref_count;
+	refcount_t                   ref_count;
 	struct nes_vnic            *nesvnic;
 	atomic_t                   pend_accepts_cnt;
 	int                        backlog;
@@ -318,7 +320,7 @@ struct nes_cm_node {
 	struct nes_cm_tcp_context tcp_cntxt;
 	struct nes_cm_core        *cm_core;
 	struct sk_buff_head       resend_list;
-	atomic_t                  ref_count;
+	refcount_t                  ref_count;
 	struct net_device         *netdev;
 
 	struct nes_cm_node        *loopbackpartner;
diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 19acd13..e6c04cc 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -3563,7 +3563,7 @@ static void nes_process_iwarp_aeqe(struct nes_device *nesdev,
 				nes_debug(NES_DBG_AEQ, "QP%u Not decrementing QP refcount (%d),"
 						" need ae to finish up, original_last_aeq = 0x%04X."
 						" last_aeq = 0x%04X, scheduling timer. TCP state = %d\n",
-						nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+						nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 						async_event_id, nesqp->last_aeq, tcp_state);
 			}
 			break;
@@ -3756,7 +3756,7 @@ int nes_manage_apbvt(struct nes_vnic *nesvnic, u32 accel_local_port,
 
 	nes_debug(NES_DBG_QP, "Waiting for CQP completion for APBVT.\n");
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	if (add_port == NES_MANAGE_APBVT_ADD)
@@ -3826,7 +3826,7 @@ void nes_manage_arp_cache(struct net_device *netdev, unsigned char *mac_addr,
 	nes_debug(NES_DBG_NETDEV, "Not waiting for CQP, cqp.sq_head=%u, cqp.sq_tail=%u\n",
 			nesdev->cqp.sq_head, nesdev->cqp.sq_tail);
 
-	atomic_set(&cqp_request->refcount, 1);
+	refcount_set(&cqp_request->refcount, 1);
 	nes_post_cqp_request(nesdev, cqp_request);
 }
 
@@ -3850,7 +3850,7 @@ void flush_wqes(struct nes_device *nesdev, struct nes_qp *nesqp,
 	}
 	if (wait_completion) {
 		cqp_request->waiting = 1;
-		atomic_set(&cqp_request->refcount, 2);
+		refcount_set(&cqp_request->refcount, 2);
 	} else {
 		cqp_request->waiting = 0;
 	}
diff --git a/drivers/infiniband/hw/nes/nes_hw.h b/drivers/infiniband/hw/nes/nes_hw.h
index 1b66ef1..0579488 100644
--- a/drivers/infiniband/hw/nes/nes_hw.h
+++ b/drivers/infiniband/hw/nes/nes_hw.h
@@ -33,6 +33,8 @@
 #ifndef __NES_HW_H
 #define __NES_HW_H
 
+#include <linux/refcount.h>
+
 #define NES_PHY_TYPE_CX4       1
 #define NES_PHY_TYPE_1G        2
 #define NES_PHY_TYPE_ARGUS     4
@@ -880,7 +882,7 @@ struct nes_cqp_request {
 	wait_queue_head_t     waitq;
 	struct nes_hw_cqp_wqe cqp_wqe;
 	struct list_head      list;
-	atomic_t              refcount;
+	refcount_t              refcount;
 	void (*cqp_callback)(struct nes_device *nesdev, struct nes_cqp_request *cqp_request);
 	u16                   major_code;
 	u16                   minor_code;
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 33624f1..2051ac4 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -471,7 +471,7 @@ static int forward_fpdus(struct nes_vnic *nesvnic, struct nes_qp *nesqp)
 		cqp_request->callback = 1;
 		cqp_request->cqp_callback = nes_download_callback;
 
-		atomic_set(&cqp_request->refcount, 1);
+		refcount_set(&cqp_request->refcount, 1);
 		nes_post_cqp_request(nesdev, cqp_request);
 		spin_unlock_irqrestore(&nesqp->pau_lock, flags);
 	}
@@ -695,7 +695,7 @@ static void nes_chg_qh_handler(struct nes_device *nesdev, struct nes_cqp_request
 		new_request->cqp_callback_pointer = qh_chg;
 		new_request->callback = 1;
 		new_request->cqp_callback = nes_chg_qh_handler;
-		atomic_set(&new_request->refcount, 1);
+		refcount_set(&new_request->refcount, 1);
 		nes_post_cqp_request(nesdev, new_request);
 		break;
 
@@ -751,7 +751,7 @@ static int nes_change_quad_hash(struct nes_device *nesdev,
 	cqp_request->cqp_callback_pointer = qh_chg;
 	cqp_request->callback = 1;
 	cqp_request->cqp_callback = nes_chg_qh_handler;
-	atomic_set(&cqp_request->refcount, 1);
+	refcount_set(&cqp_request->refcount, 1);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	return ret;
diff --git a/drivers/infiniband/hw/nes/nes_utils.c b/drivers/infiniband/hw/nes/nes_utils.c
index 37331e2..60ad51c 100644
--- a/drivers/infiniband/hw/nes/nes_utils.c
+++ b/drivers/infiniband/hw/nes/nes_utils.c
@@ -617,7 +617,7 @@ void nes_free_cqp_request(struct nes_device *nesdev,
 void nes_put_cqp_request(struct nes_device *nesdev,
 			 struct nes_cqp_request *cqp_request)
 {
-	if (atomic_dec_and_test(&cqp_request->refcount))
+	if (refcount_dec_and_test(&cqp_request->refcount))
 		nes_free_cqp_request(nesdev, cqp_request);
 }
 
@@ -656,7 +656,7 @@ void nes_post_cqp_request(struct nes_device *nesdev,
 			opcode & NES_CQP_OPCODE_MASK,
 			le32_to_cpu(cqp_wqe->wqe_words[NES_CQP_WQE_ID_IDX]), cqp_request,
 			nesdev->cqp.sq_head, nesdev->cqp.sq_tail, nesdev->cqp.sq_size,
-			cqp_request->waiting, atomic_read(&cqp_request->refcount));
+			cqp_request->waiting, refcount_read(&cqp_request->refcount));
 
 		barrier();
 
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index aff9fb1..4ee9dc8 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -124,7 +124,7 @@ static struct ib_mw *nes_alloc_mw(struct ib_pd *ibpd, enum ib_mw_type type,
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_LEN_HIGH_PD_IDX, (nespd->pd_id & 0x00007fff));
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, stag);
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -181,7 +181,7 @@ static int nes_dealloc_mw(struct ib_mw *ibmw)
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_WQE_OPCODE_IDX, NES_CQP_DEALLOCATE_STAG);
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, ibmw->rkey);
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -274,7 +274,7 @@ static int alloc_fast_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 	cqp_wqe->wqe_words[NES_CQP_WQE_OPCODE_IDX] |= cpu_to_le32(NES_CQP_STAG_PBL_BLK_SIZE);
 	barrier();
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -592,7 +592,7 @@ static struct ib_ucontext *nes_alloc_ucontext(struct ib_device *ibdev,
 
 	INIT_LIST_HEAD(&nes_ucontext->cq_reg_mem_list);
 	INIT_LIST_HEAD(&nes_ucontext->qp_reg_mem_list);
-	atomic_set(&nes_ucontext->usecnt, 1);
+	refcount_set(&nes_ucontext->usecnt, 1);
 	return &nes_ucontext->ibucontext;
 }
 
@@ -606,7 +606,7 @@ static int nes_dealloc_ucontext(struct ib_ucontext *context)
 	/* struct nes_device *nesdev = nesvnic->nesdev; */
 	struct nes_ucontext *nes_ucontext = to_nesucontext(context);
 
-	if (!atomic_dec_and_test(&nes_ucontext->usecnt))
+	if (!refcount_dec_and_test(&nes_ucontext->usecnt))
 	  return 0;
 	kfree(nes_ucontext);
 	return 0;
@@ -1263,7 +1263,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 			u64temp = (u64)nesqp->nesqp_context_pbase;
 			set_wqe_64bit_value(cqp_wqe->wqe_words, NES_CQP_QP_WQE_CONTEXT_LOW_IDX, u64temp);
 
-			atomic_set(&cqp_request->refcount, 2);
+			refcount_set(&cqp_request->refcount, 2);
 			nes_post_cqp_request(nesdev, cqp_request);
 
 			/* Wait for CQP */
@@ -1398,7 +1398,7 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 
 		nes_debug(NES_DBG_QP, "Generating a CM Timeout Event for "
 				"QP%u. cm_id = %p, refcount = %u. \n",
-				nesqp->hwqp.qp_id, cm_id, atomic_read(&nesqp->refcount));
+				nesqp->hwqp.qp_id, cm_id, refcount_read(&nesqp->refcount));
 
 		cm_id->rem_ref(cm_id);
 		ret = cm_id->event_handler(cm_id, &cm_event);
@@ -1647,7 +1647,7 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev,
 	cqp_wqe->wqe_words[NES_CQP_CQ_WQE_CQ_CONTEXT_HIGH_IDX] =
 			cpu_to_le32(((u32)((u64temp) >> 33)) & 0x7FFFFFFF);
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -1751,7 +1751,7 @@ static int nes_destroy_cq(struct ib_cq *ib_cq)
 	if (!nescq->mcrqf)
 		nes_free_resource(nesadapter, nesadapter->allocated_cqs, nescq->hw_cq.cq_number);
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -1963,7 +1963,7 @@ static int nes_reg_mr(struct nes_device *nesdev, struct nes_pd *nespd,
 	}
 	barrier();
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -2531,7 +2531,7 @@ static int nes_dereg_mr(struct ib_mr *ib_mr)
 			NES_CQP_STAG_DEALLOC_PBLS | NES_CQP_STAG_MR);
 	set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_STAG_WQE_STAG_IDX, ib_mr->rkey);
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -2679,7 +2679,7 @@ int nes_hw_modify_qp(struct nes_device *nesdev, struct nes_qp *nesqp,
 	u16 major_code;
 
 	nes_debug(NES_DBG_MOD_QP, "QP%u, refcount=%d\n",
-			nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount));
+			nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount));
 
 	cqp_request = nes_get_cqp_request(nesdev);
 	if (cqp_request == NULL) {
@@ -2708,7 +2708,7 @@ int nes_hw_modify_qp(struct nes_device *nesdev, struct nes_qp *nesqp,
 		set_wqe_32bit_value(cqp_wqe->wqe_words, NES_CQP_QP_WQE_NEW_MSS_IDX, termlen);
 	}
 
-	atomic_set(&cqp_request->refcount, 2);
+	refcount_set(&cqp_request->refcount, 2);
 	nes_post_cqp_request(nesdev, cqp_request);
 
 	/* Wait for CQP */
@@ -2764,7 +2764,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	nes_debug(NES_DBG_MOD_QP, "QP%u: QP State=%u, cur QP State=%u,"
 			" iwarp_state=0x%X, refcount=%d\n",
 			nesqp->hwqp.qp_id, attr->qp_state, nesqp->ibqp_state,
-			nesqp->iwarp_state, atomic_read(&nesqp->refcount));
+			nesqp->iwarp_state, refcount_read(&nesqp->refcount));
 
 	spin_lock_irqsave(&nesqp->lock, qplockflags);
 
@@ -2956,14 +2956,14 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if ((issue_modify_qp) && (nesqp->ibqp_state > IB_QPS_RTS)) {
 		nes_debug(NES_DBG_MOD_QP, "QP%u Issued ModifyQP refcount (%d),"
 				" original_last_aeq = 0x%04X. last_aeq = 0x%04X.\n",
-				nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+				nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 				original_last_aeq, nesqp->last_aeq);
 		if (!ret || original_last_aeq != NES_AEQE_AEID_RDMAP_ROE_BAD_LLP_CLOSE) {
 			if (dont_wait) {
 				if (nesqp->cm_id && nesqp->hw_tcp_state != 0) {
 					nes_debug(NES_DBG_MOD_QP, "QP%u Queuing fake disconnect for QP refcount (%d),"
 							" original_last_aeq = 0x%04X. last_aeq = 0x%04X.\n",
-							nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+							nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 							original_last_aeq, nesqp->last_aeq);
 					/* this one is for the cm_disconnect thread */
 					spin_lock_irqsave(&nesqp->lock, qplockflags);
@@ -2973,7 +2973,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					nes_cm_disconn(nesqp);
 				} else {
 					nes_debug(NES_DBG_MOD_QP, "QP%u No fake disconnect, QP refcount=%d\n",
-							nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount));
+							nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount));
 				}
 			} else {
 				spin_lock_irqsave(&nesqp->lock, qplockflags);
@@ -2984,7 +2984,7 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 						nes_debug(NES_DBG_MOD_QP, "QP%u Not decrementing QP refcount (%d),"
 								" need ae to finish up, original_last_aeq = 0x%04X."
 								" last_aeq = 0x%04X, scheduling timer.\n",
-								nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+								nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 								original_last_aeq, nesqp->last_aeq);
 						schedule_nes_timer(nesqp->cm_node, (struct sk_buff *) nesqp, NES_TIMER_TYPE_CLOSE, 1, 0);
 					}
@@ -2994,27 +2994,27 @@ int nes_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 					nes_debug(NES_DBG_MOD_QP, "QP%u Not decrementing QP refcount (%d),"
 							" need ae to finish up, original_last_aeq = 0x%04X."
 							" last_aeq = 0x%04X.\n",
-							nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+							nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 							original_last_aeq, nesqp->last_aeq);
 				}
 			}
 		} else {
 			nes_debug(NES_DBG_MOD_QP, "QP%u Decrementing QP refcount (%d), No ae to finish up,"
 					" original_last_aeq = 0x%04X. last_aeq = 0x%04X.\n",
-					nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+					nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 					original_last_aeq, nesqp->last_aeq);
 		}
 	} else {
 		nes_debug(NES_DBG_MOD_QP, "QP%u Decrementing QP refcount (%d), No ae to finish up,"
 				" original_last_aeq = 0x%04X. last_aeq = 0x%04X.\n",
-				nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount),
+				nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount),
 				original_last_aeq, nesqp->last_aeq);
 	}
 
 	err = 0;
 
 	nes_debug(NES_DBG_MOD_QP, "QP%u Leaving, refcount=%d\n",
-			nesqp->hwqp.qp_id, atomic_read(&nesqp->refcount));
+			nesqp->hwqp.qp_id, refcount_read(&nesqp->refcount));
 
 	return err;
 }
diff --git a/drivers/infiniband/hw/nes/nes_verbs.h b/drivers/infiniband/hw/nes/nes_verbs.h
index e02a566..570095b 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.h
+++ b/drivers/infiniband/hw/nes/nes_verbs.h
@@ -35,6 +35,8 @@
 #ifndef NES_VERBS_H
 #define NES_VERBS_H
 
+#include <linux/refcount.h>
+
 struct nes_device;
 
 #define NES_MAX_USER_DB_REGIONS  4096
@@ -59,7 +61,7 @@ struct nes_ucontext {
 	struct list_head   cq_reg_mem_list;
 	struct list_head   qp_reg_mem_list;
 	u32                mcrqf;
-	atomic_t	   usecnt;
+	refcount_t	   usecnt;
 };
 
 struct nes_pd {
@@ -154,7 +156,7 @@ struct nes_qp {
 	u32                   hte_index;
 	u32                   last_aeq;
 	u32                   qp_mem_size;
-	atomic_t              refcount;
+	refcount_t              refcount;
 	atomic_t              close_timer_started;
 	u32                   mmap_sq_db_index;
 	u32                   mmap_rq_db_index;
diff --git a/drivers/infiniband/hw/qib/qib_keys.c b/drivers/infiniband/hw/qib/qib_keys.c
index 2c3c935..3c65ce6 100644
--- a/drivers/infiniband/hw/qib/qib_keys.c
+++ b/drivers/infiniband/hw/qib/qib_keys.c
@@ -172,7 +172,7 @@ int qib_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 		mr = rcu_dereference(dev->dma_mr);
 		if (!mr)
 			goto bail;
-		if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
+		if (unlikely(!refcount_inc_not_zero(&mr->refcount)))
 			goto bail;
 		rcu_read_unlock();
 
@@ -194,7 +194,7 @@ int qib_rkey_ok(struct rvt_qp *qp, struct rvt_sge *sge,
 	if (unlikely(vaddr < mr->iova || off + len > mr->length ||
 		     (mr->access_flags & acc) == 0))
 		goto bail;
-	if (unlikely(!atomic_inc_not_zero(&mr->refcount)))
+	if (unlikely(!refcount_inc_not_zero(&mr->refcount)))
 		goto bail;
 	rcu_read_unlock();
 
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index e54a2fe..628637a 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -808,7 +808,7 @@ void qib_send_complete(struct rvt_qp *qp, struct rvt_swqe *wqe,
 	if (qp->ibqp.qp_type == IB_QPT_UD ||
 	    qp->ibqp.qp_type == IB_QPT_SMI ||
 	    qp->ibqp.qp_type == IB_QPT_GSI)
-		atomic_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
+		refcount_dec(&ibah_to_rvtah(wqe->ud_wr.ah)->refcount);
 
 	rvt_qp_swqe_complete(qp, wqe, status);
 
diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
index 16c4461..563ea54 100644
--- a/drivers/infiniband/sw/rdmavt/ah.c
+++ b/drivers/infiniband/sw/rdmavt/ah.c
@@ -128,7 +128,7 @@ struct ib_ah *rvt_create_ah(struct ib_pd *pd,
 	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
 
 	ah->attr = *ah_attr;
-	atomic_set(&ah->refcount, 0);
+	refcount_set(&ah->refcount, 0);
 
 	if (dev->driver_f.notify_new_ah)
 		dev->driver_f.notify_new_ah(pd->device, ah_attr, ah);
@@ -148,7 +148,7 @@ int rvt_destroy_ah(struct ib_ah *ibah)
 	struct rvt_ah *ah = ibah_to_rvtah(ibah);
 	unsigned long flags;
 
-	if (atomic_read(&ah->refcount) != 0)
+	if (refcount_read(&ah->refcount) != 0)
 		return -EBUSY;
 
 	spin_lock_irqsave(&dev->n_ahs_lock, flags);
diff --git a/drivers/infiniband/sw/rdmavt/mr.c b/drivers/infiniband/sw/rdmavt/mr.c
index 52fd152..5ffb63a 100644
--- a/drivers/infiniband/sw/rdmavt/mr.c
+++ b/drivers/infiniband/sw/rdmavt/mr.c
@@ -141,7 +141,7 @@ static int rvt_init_mregion(struct rvt_mregion *mr, struct ib_pd *pd,
 	}
 	init_completion(&mr->comp);
 	/* count returning the ptr to user */
-	atomic_set(&mr->refcount, 1);
+	refcount_set(&mr->refcount, 1);
 	atomic_set(&mr->lkey_invalid, 0);
 	mr->pd = pd;
 	mr->max_segs = count;
@@ -446,7 +446,7 @@ int rvt_dereg_mr(struct ib_mr *ibmr)
 	if (!timeout) {
 		rvt_pr_err(rdi,
 			   "rvt_dereg_mr timeout mr %p pd %p refcount %u\n",
-			   mr, mr->mr.pd, atomic_read(&mr->mr.refcount));
+			   mr, mr->mr.pd, refcount_read(&mr->mr.refcount));
 		rvt_get_mr(&mr->mr);
 		ret = -EBUSY;
 		goto out;
@@ -678,7 +678,7 @@ int rvt_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 	u32 ps;
 	struct rvt_dev_info *rdi = ib_to_rvt(ibfmr->device);
 
-	i = atomic_read(&fmr->mr.refcount);
+	i = refcount_read(&fmr->mr.refcount);
 	if (i > 2)
 		return -EBUSY;
 
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 2a13ac6..cdcf260 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -434,7 +434,7 @@ static void rvt_clear_mr_refs(struct rvt_qp *qp, int clr_sends)
 			if (qp->ibqp.qp_type == IB_QPT_UD ||
 			    qp->ibqp.qp_type == IB_QPT_SMI ||
 			    qp->ibqp.qp_type == IB_QPT_GSI)
-				atomic_dec(&ibah_to_rvtah(
+				refcount_dec(&ibah_to_rvtah(
 						wqe->ud_wr.ah)->refcount);
 			if (++qp->s_last >= qp->s_size)
 				qp->s_last = 0;
@@ -600,7 +600,7 @@ static void rvt_reset_qp(struct rvt_dev_info *rdi, struct rvt_qp *qp,
 
 		/* take qp out the hash and wait for it to be unused */
 		rvt_remove_qp(rdi, qp);
-		wait_event(qp->wait, !atomic_read(&qp->refcount));
+		wait_event(qp->wait, !refcount_read(&qp->refcount));
 
 		/* grab the lock b/c it was locked at call time */
 		spin_lock_irq(&qp->r_lock);
@@ -777,7 +777,7 @@ struct ib_qp *rvt_create_qp(struct ib_pd *ibpd,
 		spin_lock_init(&qp->s_hlock);
 		spin_lock_init(&qp->s_lock);
 		spin_lock_init(&qp->r_rq.lock);
-		atomic_set(&qp->refcount, 0);
+		refcount_set(&qp->refcount, 0);
 		atomic_set(&qp->local_ops_pending, 0);
 		init_waitqueue_head(&qp->wait);
 		init_timer(&qp->s_timer);
@@ -1721,7 +1721,7 @@ static int rvt_post_one_wr(struct rvt_qp *qp,
 		struct rvt_ah *ah = ibah_to_rvtah(wqe->ud_wr.ah);
 
 		log_pmtu = ah->log_pmtu;
-		atomic_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
+		refcount_inc(&ibah_to_rvtah(ud_wr(wr)->ah)->refcount);
 	}
 
 	if (rdi->post_parms[wr->opcode].flags & RVT_OPERATION_LOCAL) {
diff --git a/drivers/infiniband/ulp/ipoib/ipoib.h b/drivers/infiniband/ulp/ipoib/ipoib.h
index da12717..b302167 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib.h
+++ b/drivers/infiniband/ulp/ipoib/ipoib.h
@@ -42,6 +42,7 @@
 #include <linux/kref.h>
 #include <linux/if_infiniband.h>
 #include <linux/mutex.h>
+#include <linux/refcount.h>
 
 #include <net/neighbour.h>
 #include <net/sch_generic.h>
@@ -444,7 +445,7 @@ struct ipoib_neigh {
 	struct list_head    list;
 	struct ipoib_neigh __rcu *hnext;
 	struct rcu_head     rcu;
-	atomic_t	    refcnt;
+	refcount_t	    refcnt;
 	unsigned long       alive;
 };
 
@@ -454,7 +455,7 @@ struct ipoib_neigh {
 void ipoib_neigh_dtor(struct ipoib_neigh *neigh);
 static inline void ipoib_neigh_put(struct ipoib_neigh *neigh)
 {
-	if (atomic_dec_and_test(&neigh->refcnt))
+	if (refcount_dec_and_test(&neigh->refcnt))
 		ipoib_neigh_dtor(neigh);
 }
 struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 3ce0765..2568f5b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1226,7 +1226,7 @@ struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 	     neigh = rcu_dereference_bh(neigh->hnext)) {
 		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
 			/* found, take one ref on behalf of the caller */
-			if (!atomic_inc_not_zero(&neigh->refcnt)) {
+			if (!refcount_inc_not_zero(&neigh->refcnt)) {
 				/* deleted */
 				neigh = NULL;
 				goto out_unlock;
@@ -1328,7 +1328,7 @@ static struct ipoib_neigh *ipoib_neigh_ctor(u8 *daddr,
 	INIT_LIST_HEAD(&neigh->list);
 	ipoib_cm_set(neigh, NULL);
 	/* one ref on behalf of the caller */
-	atomic_set(&neigh->refcnt, 1);
+	refcount_set(&neigh->refcnt, 1);
 
 	return neigh;
 }
@@ -1360,7 +1360,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 					       lockdep_is_held(&priv->lock))) {
 		if (memcmp(daddr, neigh->daddr, INFINIBAND_ALEN) == 0) {
 			/* found, take one ref on behalf of the caller */
-			if (!atomic_inc_not_zero(&neigh->refcnt)) {
+			if (!refcount_inc_not_zero(&neigh->refcnt)) {
 				/* deleted */
 				neigh = NULL;
 				break;
@@ -1375,7 +1375,7 @@ struct ipoib_neigh *ipoib_neigh_alloc(u8 *daddr,
 		goto out_unlock;
 
 	/* one ref on behalf of the hash table */
-	atomic_inc(&neigh->refcnt);
+	refcount_inc(&neigh->refcnt);
 	neigh->alive = jiffies;
 	/* put in hash */
 	rcu_assign_pointer(neigh->hnext,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0ae5536..446a353 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -43,6 +43,7 @@
 #include <linux/radix-tree.h>
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
+#include <linux/refcount.h>
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/doorbell.h>
@@ -387,7 +388,7 @@ enum mlx5_res_type {
 
 struct mlx5_core_rsc_common {
 	enum mlx5_res_type	res;
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
@@ -400,7 +401,7 @@ struct mlx5_core_srq {
 	int		wqe_shift;
 	void (*event)	(struct mlx5_core_srq *, enum mlx5_event);
 
-	atomic_t		refcount;
+	refcount_t		refcount;
 	struct completion	free;
 };
 
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 1beab55..14e8628 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -41,6 +41,7 @@
 #include <linux/inetdevice.h>
 #include <linux/socket.h>
 #include <linux/if_vlan.h>
+#include <linux/refcount.h>
 #include <net/ipv6.h>
 #include <net/if_inet6.h>
 #include <net/ip.h>
@@ -50,7 +51,7 @@
 #include <net/net_namespace.h>
 
 struct rdma_addr_client {
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion comp;
 };
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8029d2a..6384c29 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -58,6 +58,7 @@
 
 #include <linux/if_link.h>
 #include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <linux/mmu_notifier.h>
 #include <asm/uaccess.h>
 
@@ -1389,7 +1390,7 @@ struct ib_pd {
 	u32			flags;
 	struct ib_device       *device;
 	struct ib_uobject      *uobject;
-	atomic_t          	usecnt; /* count all resources */
+	refcount_t          	usecnt; /* count all resources */
 
 	u32			unsafe_global_rkey;
 
@@ -1401,7 +1402,7 @@ struct ib_pd {
 
 struct ib_xrcd {
 	struct ib_device       *device;
-	atomic_t		usecnt; /* count all exposed resources */
+	refcount_t		usecnt; /* count all exposed resources */
 	struct inode	       *inode;
 
 	struct mutex		tgt_qp_mutex;
@@ -1429,7 +1430,7 @@ struct ib_cq {
 	void                  (*event_handler)(struct ib_event *, void *);
 	void                   *cq_context;
 	int               	cqe;
-	atomic_t          	usecnt; /* count number of work queues */
+	refcount_t          	usecnt; /* count number of work queues */
 	enum ib_poll_context	poll_ctx;
 	struct ib_wc		*wc;
 	union {
@@ -1445,7 +1446,7 @@ struct ib_srq {
 	void		      (*event_handler)(struct ib_event *, void *);
 	void		       *srq_context;
 	enum ib_srq_type	srq_type;
-	atomic_t		usecnt;
+	refcount_t		usecnt;
 
 	union {
 		struct {
@@ -1476,7 +1477,7 @@ struct ib_wq {
 	u32		wq_num;
 	enum ib_wq_state       state;
 	enum ib_wq_type	wq_type;
-	atomic_t		usecnt;
+	refcount_t		usecnt;
 };
 
 struct ib_wq_init_attr {
@@ -1501,7 +1502,7 @@ struct ib_wq_attr {
 struct ib_rwq_ind_table {
 	struct ib_device	*device;
 	struct ib_uobject      *uobject;
-	atomic_t		usecnt;
+	refcount_t		usecnt;
 	u32		ind_tbl_num;
 	u32		log_ind_tbl_size;
 	struct ib_wq	**ind_tbl;
@@ -1531,7 +1532,7 @@ struct ib_qp {
 	struct list_head	xrcd_list;
 
 	/* count times opened, mcast attaches, flow attaches */
-	atomic_t		usecnt;
+	refcount_t		usecnt;
 	struct list_head	open_list;
 	struct ib_qp           *real_qp;
 	struct ib_uobject      *uobject;
diff --git a/include/rdma/rdmavt_mr.h b/include/rdma/rdmavt_mr.h
index de59de2..f6aa67b 100644
--- a/include/rdma/rdmavt_mr.h
+++ b/include/rdma/rdmavt_mr.h
@@ -83,7 +83,7 @@ struct rvt_mregion {
 	u8  lkey_published;     /* in global table */
 	atomic_t lkey_invalid;	/* true if current lkey is invalid */
 	struct completion comp; /* complete when refcount goes to zero */
-	atomic_t refcount;
+	refcount_t refcount;
 	struct rvt_segarray *map[0];    /* the segments */
 };
 
@@ -123,13 +123,13 @@ struct rvt_sge_state {
 
 static inline void rvt_put_mr(struct rvt_mregion *mr)
 {
-	if (unlikely(atomic_dec_and_test(&mr->refcount)))
+	if (unlikely(refcount_dec_and_test(&mr->refcount)))
 		complete(&mr->comp);
 }
 
 static inline void rvt_get_mr(struct rvt_mregion *mr)
 {
-	atomic_inc(&mr->refcount);
+	refcount_inc(&mr->refcount);
 }
 
 static inline void rvt_put_ss(struct rvt_sge_state *ss)
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index f3dbd15..1c0b021f 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -304,7 +304,7 @@ struct rvt_qp {
 	u8 s_draining;
 
 	/* start of read/write fields */
-	atomic_t refcount ____cacheline_aligned_in_smp;
+	refcount_t refcount ____cacheline_aligned_in_smp;
 	wait_queue_head_t wait;
 
 	struct rvt_ack_entry *s_ack_queue;
@@ -472,7 +472,7 @@ static inline struct rvt_rwqe *rvt_get_rwqe_ptr(struct rvt_rq *rq, unsigned n)
  */
 static inline void rvt_get_qp(struct rvt_qp *qp)
 {
-	atomic_inc(&qp->refcount);
+	refcount_inc(&qp->refcount);
 }
 
 /**
@@ -481,7 +481,7 @@ static inline void rvt_get_qp(struct rvt_qp *qp)
  */
 static inline void rvt_put_qp(struct rvt_qp *qp)
 {
-	if (qp && atomic_dec_and_test(&qp->refcount))
+	if (qp && refcount_dec_and_test(&qp->refcount))
 		wake_up(&qp->wait);
 }
 
-- 
2.7.4
