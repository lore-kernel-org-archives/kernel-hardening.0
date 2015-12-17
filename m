Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:47 -0500
Message-Id: <1450364270-12687-10-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 09/12] drivers: opt out of PAX_REFCOUNT protection (2 of 2)
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 drivers/net/ipvlan/ipvlan_core.c          |  2 +-
 drivers/net/macvlan.c                     |  2 +-
 drivers/net/usb/sierra_net.c              |  4 +--
 drivers/net/wireless/rt2x00/rt2x00.h      |  2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |  4 +--
 drivers/oprofile/buffer_sync.c            |  8 ++---
 drivers/oprofile/event_buffer.c           |  2 +-
 drivers/oprofile/oprof.c                  |  2 +-
 drivers/oprofile/oprofile_stats.c         | 10 +++----
 drivers/oprofile/oprofile_stats.h         | 10 +++----
 drivers/oprofile/oprofilefs.c             |  6 ++--
 drivers/regulator/core.c                  |  4 +--
 drivers/scsi/fcoe/fcoe_sysfs.c            | 12 ++++----
 drivers/scsi/hosts.c                      |  4 +--
 drivers/scsi/libfc/fc_exch.c              | 50 +++++++++++++++----------------
 drivers/scsi/lpfc/lpfc.h                  |  8 ++---
 drivers/scsi/lpfc/lpfc_debugfs.c          | 18 +++++------
 drivers/scsi/lpfc/lpfc_scsi.c             | 10 +++----
 drivers/scsi/pmcraid.c                    | 20 ++++++-------
 drivers/scsi/pmcraid.h                    |  8 ++---
 drivers/scsi/qla4xxx/ql4_def.h            |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  6 ++--
 drivers/scsi/scsi_lib.c                   |  8 ++---
 drivers/scsi/scsi_sysfs.c                 |  2 +-
 drivers/scsi/scsi_transport_fc.c          |  6 ++--
 drivers/scsi/scsi_transport_iscsi.c       |  6 ++--
 drivers/scsi/scsi_transport_srp.c         |  6 ++--
 drivers/scsi/sd.c                         |  2 +-
 drivers/staging/android/timed_output.c    |  6 ++--
 drivers/staging/octeon/ethernet-rx.c      | 12 ++++----
 drivers/staging/octeon/ethernet.c         |  8 ++---
 drivers/target/sbp/sbp_target.c           |  4 +--
 drivers/target/target_core_device.c       |  2 +-
 drivers/target/target_core_transport.c    |  2 +-
 drivers/tty/hvc/hvsi.c                    | 12 ++++----
 drivers/tty/hvc/hvsi_lib.c                |  4 +--
 drivers/tty/serial/ioc4_serial.c          |  6 ++--
 drivers/tty/serial/msm_serial.c           |  4 +--
 drivers/uio/uio.c                         | 12 ++++----
 drivers/usb/atm/usbatm.c                  | 24 +++++++--------
 drivers/usb/core/devices.c                |  6 ++--
 drivers/usb/core/hcd.c                    |  4 +--
 drivers/usb/core/sysfs.c                  |  2 +-
 drivers/usb/core/usb.c                    |  2 +-
 drivers/usb/host/ehci-hub.c               |  4 +--
 drivers/usb/misc/appledisplay.c           |  4 +--
 drivers/usb/usbip/vhci.h                  |  2 +-
 drivers/usb/usbip/vhci_hcd.c              |  6 ++--
 drivers/usb/usbip/vhci_rx.c               |  2 +-
 drivers/usb/wusbcore/wa-hc.h              |  4 +--
 drivers/usb/wusbcore/wa-xfer.c            |  2 +-
 drivers/video/fbdev/hyperv_fb.c           |  4 +--
 drivers/video/fbdev/udlfb.c               | 32 ++++++++++----------
 include/linux/uio_driver.h                |  2 +-
 include/linux/usb.h                       |  2 +-
 include/media/v4l2-device.h               |  2 +-
 include/scsi/scsi_device.h                |  6 ++--
 include/target/target_core_base.h         |  2 +-
 58 files changed, 204 insertions(+), 204 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 207f62e..af3f5e5 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -466,7 +466,7 @@ static void ipvlan_multicast_enqueue(struct ipvl_port *port,
 		schedule_work(&port->wq);
 	} else {
 		spin_unlock(&port->backlog.lock);
-		atomic_long_inc(&skb->dev->rx_dropped);
+		atomic_long_inc_unchecked(&skb->dev->rx_dropped);
 		kfree_skb(skb);
 	}
 }
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9f59f17..0f9ae3b2 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -335,7 +335,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 free_nskb:
 	kfree_skb(nskb);
 err:
-	atomic_long_inc(&skb->dev->rx_dropped);
+	atomic_long_inc_unchecked(&skb->dev->rx_dropped);
 }
 
 static void macvlan_flush_sources(struct macvlan_port *port,
diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index a2515887..6d13233 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -51,7 +51,7 @@ static const char driver_name[] = "sierra_net";
 /* atomic counter partially included in MAC address to make sure 2 devices
  * do not end up with the same MAC - concept breaks in case of > 255 ifaces
  */
-static	atomic_t iface_counter = ATOMIC_INIT(0);
+static	atomic_unchecked_t iface_counter = ATOMIC_INIT(0);
 
 /*
  * SYNC Timer Delay definition used to set the expiry time
@@ -697,7 +697,7 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->netdev_ops = &sierra_net_device_ops;
 
 	/* change MAC addr to include, ifacenum, and to be unique */
-	dev->net->dev_addr[ETH_ALEN-2] = atomic_inc_return(&iface_counter);
+	dev->net->dev_addr[ETH_ALEN-2] = atomic_inc_return_unchecked(&iface_counter);
 	dev->net->dev_addr[ETH_ALEN-1] = ifacenum;
 
 	/* we will have to manufacture ethernet headers, prepare template */
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 9bb398b..b0cc047 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -375,7 +375,7 @@ struct rt2x00_intf {
 	 * for hardware which doesn't support hardware
 	 * sequence counting.
 	 */
-	atomic_t seqno;
+	atomic_unchecked_t seqno;
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 68b620b..92ecd9e 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -224,9 +224,9 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 	 * sequence counter given by mac80211.
 	 */
 	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
-		seqno = atomic_add_return(0x10, &intf->seqno);
+		seqno = atomic_add_return_unchecked(0x10, &intf->seqno);
 	else
-		seqno = atomic_read(&intf->seqno);
+		seqno = atomic_read_unchecked(&intf->seqno);
 
 	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 	hdr->seq_ctrl |= cpu_to_le16(seqno);
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 82f7000..d6d0447 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -345,7 +345,7 @@ static void add_data(struct op_entry *entry, struct mm_struct *mm)
 		if (cookie == NO_COOKIE)
 			offset = pc;
 		if (cookie == INVALID_COOKIE) {
-			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+			atomic_inc_unchecked(&oprofile_stats.sample_lost_no_mapping);
 			offset = pc;
 		}
 		if (cookie != last_cookie) {
@@ -389,14 +389,14 @@ add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 	/* add userspace sample */
 
 	if (!mm) {
-		atomic_inc(&oprofile_stats.sample_lost_no_mm);
+		atomic_inc_unchecked(&oprofile_stats.sample_lost_no_mm);
 		return 0;
 	}
 
 	cookie = lookup_dcookie(mm, s->eip, &offset);
 
 	if (cookie == INVALID_COOKIE) {
-		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+		atomic_inc_unchecked(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
 	}
 
@@ -554,7 +554,7 @@ void sync_buffer(int cpu)
 		/* ignore backtraces if failed to add a sample */
 		if (state == sb_bt_start) {
 			state = sb_bt_ignore;
-			atomic_inc(&oprofile_stats.bt_lost_no_mapping);
+			atomic_inc_unchecked(&oprofile_stats.bt_lost_no_mapping);
 		}
 	}
 	release_mm(mm);
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index c0cc4e7..44d4e54 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -53,7 +53,7 @@ void add_event_entry(unsigned long value)
 	}
 
 	if (buffer_pos == buffer_size) {
-		atomic_inc(&oprofile_stats.event_lost_overflow);
+		atomic_inc_unchecked(&oprofile_stats.event_lost_overflow);
 		return;
 	}
 
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index ed2c3ec..deda85a 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -110,7 +110,7 @@ static void switch_worker(struct work_struct *work)
 	if (oprofile_ops.switch_events())
 		return;
 
-	atomic_inc(&oprofile_stats.multiplex_counter);
+	atomic_inc_unchecked(&oprofile_stats.multiplex_counter);
 	start_switch_worker();
 }
 
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 59659ce..6c860a0 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -30,11 +30,11 @@ void oprofile_reset_stats(void)
 		cpu_buf->sample_invalid_eip = 0;
 	}
 
-	atomic_set(&oprofile_stats.sample_lost_no_mm, 0);
-	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
-	atomic_set(&oprofile_stats.event_lost_overflow, 0);
-	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
-	atomic_set(&oprofile_stats.multiplex_counter, 0);
+	atomic_set_unchecked(&oprofile_stats.sample_lost_no_mm, 0);
+	atomic_set_unchecked(&oprofile_stats.sample_lost_no_mapping, 0);
+	atomic_set_unchecked(&oprofile_stats.event_lost_overflow, 0);
+	atomic_set_unchecked(&oprofile_stats.bt_lost_no_mapping, 0);
+	atomic_set_unchecked(&oprofile_stats.multiplex_counter, 0);
 }
 
 
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 1fc622b..8c48fc3 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -13,11 +13,11 @@
 #include <linux/atomic.h>
 
 struct oprofile_stat_struct {
-	atomic_t sample_lost_no_mm;
-	atomic_t sample_lost_no_mapping;
-	atomic_t bt_lost_no_mapping;
-	atomic_t event_lost_overflow;
-	atomic_t multiplex_counter;
+	atomic_unchecked_t sample_lost_no_mm;
+	atomic_unchecked_t sample_lost_no_mapping;
+	atomic_unchecked_t bt_lost_no_mapping;
+	atomic_unchecked_t event_lost_overflow;
+	atomic_unchecked_t multiplex_counter;
 };
 
 extern struct oprofile_stat_struct oprofile_stats;
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index dd92c5e..dfc04b5 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -176,8 +176,8 @@ int oprofilefs_create_ro_ulong(struct dentry *root,
 
 static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	atomic_t *val = file->private_data;
-	return oprofilefs_ulong_to_user(atomic_read(val), buf, count, offset);
+	atomic_unchecked_t *val = file->private_data;
+	return oprofilefs_ulong_to_user(atomic_read_unchecked(val), buf, count, offset);
 }
 
 
@@ -189,7 +189,7 @@ static const struct file_operations atomic_ro_fops = {
 
 
 int oprofilefs_create_ro_atomic(struct dentry *root,
-	char const *name, atomic_t *val)
+	char const *name, atomic_unchecked_t *val)
 {
 	return __oprofilefs_create_file(root, name,
 					&atomic_ro_fops, 0444, val);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 5081533..794deb2 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3650,7 +3650,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
 	struct regulator_config *config = NULL;
-	static atomic_t regulator_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t regulator_no = ATOMIC_INIT(-1);
 	struct regulator_dev *rdev;
 	struct device *dev;
 	int ret, i;
@@ -3733,7 +3733,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
-		    (unsigned long) atomic_inc_return(&regulator_no));
+		    (unsigned long) atomic_inc_return_unchecked(&regulator_no));
 	ret = device_register(&rdev->dev);
 	if (ret != 0) {
 		put_device(&rdev->dev);
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 045c4e1..13de803 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -33,8 +33,8 @@
  */
 #include "libfcoe.h"
 
-static atomic_t ctlr_num;
-static atomic_t fcf_num;
+static atomic_unchecked_t ctlr_num;
+static atomic_unchecked_t fcf_num;
 
 /*
  * fcoe_fcf_dev_loss_tmo: the default number of seconds that fcoe sysfs
@@ -685,7 +685,7 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 	if (!ctlr)
 		goto out;
 
-	ctlr->id = atomic_inc_return(&ctlr_num) - 1;
+	ctlr->id = atomic_inc_return_unchecked(&ctlr_num) - 1;
 	ctlr->f = f;
 	ctlr->mode = FIP_CONN_TYPE_FABRIC;
 	INIT_LIST_HEAD(&ctlr->fcfs);
@@ -902,7 +902,7 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->dev.parent = &ctlr->dev;
 	fcf->dev.bus = &fcoe_bus_type;
 	fcf->dev.type = &fcoe_fcf_device_type;
-	fcf->id = atomic_inc_return(&fcf_num) - 1;
+	fcf->id = atomic_inc_return_unchecked(&fcf_num) - 1;
 	fcf->state = FCOE_FCF_STATE_UNKNOWN;
 
 	fcf->dev_loss_tmo = ctlr->fcf_dev_loss_tmo;
@@ -938,8 +938,8 @@ int __init fcoe_sysfs_setup(void)
 {
 	int error;
 
-	atomic_set(&ctlr_num, 0);
-	atomic_set(&fcf_num, 0);
+	atomic_set_unchecked(&ctlr_num, 0);
+	atomic_set_unchecked(&fcf_num, 0);
 
 	error = bus_register(&fcoe_bus_type);
 	if (error)
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e..20236b4 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -42,7 +42,7 @@
 #include "scsi_logging.h"
 
 
-static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
+static atomic_unchecked_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
 
 
 static void scsi_host_cls_release(struct device *dev)
@@ -392,7 +392,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	 * subtract one because we increment first then return, but we need to
 	 * know what the next host number was before increment
 	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	shost->host_no = atomic_inc_return_unchecked(&scsi_host_next_hn) - 1;
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 30f9ef0..a1e29ac 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -101,12 +101,12 @@ struct fc_exch_mgr {
 	u16		pool_max_index;
 
 	struct {
-		atomic_t no_free_exch;
-		atomic_t no_free_exch_xid;
-		atomic_t xid_not_found;
-		atomic_t xid_busy;
-		atomic_t seq_not_found;
-		atomic_t non_bls_resp;
+		atomic_unchecked_t no_free_exch;
+		atomic_unchecked_t no_free_exch_xid;
+		atomic_unchecked_t xid_not_found;
+		atomic_unchecked_t xid_busy;
+		atomic_unchecked_t seq_not_found;
+		atomic_unchecked_t non_bls_resp;
 	} stats;
 };
 
@@ -809,7 +809,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	/* allocate memory for exchange */
 	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
 	if (!ep) {
-		atomic_inc(&mp->stats.no_free_exch);
+		atomic_inc_unchecked(&mp->stats.no_free_exch);
 		goto out;
 	}
 	memset(ep, 0, sizeof(*ep));
@@ -872,7 +872,7 @@ out:
 	return ep;
 err:
 	spin_unlock_bh(&pool->lock);
-	atomic_inc(&mp->stats.no_free_exch_xid);
+	atomic_inc_unchecked(&mp->stats.no_free_exch_xid);
 	mempool_free(ep, mp->ep_pool);
 	return NULL;
 }
@@ -1021,7 +1021,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		xid = ntohs(fh->fh_ox_id);	/* we originated exch */
 		ep = fc_exch_find(mp, xid);
 		if (!ep) {
-			atomic_inc(&mp->stats.xid_not_found);
+			atomic_inc_unchecked(&mp->stats.xid_not_found);
 			reject = FC_RJT_OX_ID;
 			goto out;
 		}
@@ -1051,7 +1051,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		ep = fc_exch_find(mp, xid);
 		if ((f_ctl & FC_FC_FIRST_SEQ) && fc_sof_is_init(fr_sof(fp))) {
 			if (ep) {
-				atomic_inc(&mp->stats.xid_busy);
+				atomic_inc_unchecked(&mp->stats.xid_busy);
 				reject = FC_RJT_RX_ID;
 				goto rel;
 			}
@@ -1062,7 +1062,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 			}
 			xid = ep->xid;	/* get our XID */
 		} else if (!ep) {
-			atomic_inc(&mp->stats.xid_not_found);
+			atomic_inc_unchecked(&mp->stats.xid_not_found);
 			reject = FC_RJT_RX_ID;	/* XID not found */
 			goto out;
 		}
@@ -1080,7 +1080,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 	} else {
 		sp = &ep->seq;
 		if (sp->id != fh->fh_seq_id) {
-			atomic_inc(&mp->stats.seq_not_found);
+			atomic_inc_unchecked(&mp->stats.seq_not_found);
 			if (f_ctl & FC_FC_END_SEQ) {
 				/*
 				 * Update sequence_id based on incoming last
@@ -1531,22 +1531,22 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 
 	ep = fc_exch_find(mp, ntohs(fh->fh_ox_id));
 	if (!ep) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_unchecked(&mp->stats.xid_not_found);
 		goto out;
 	}
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_unchecked(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	if (ep->rxid == FC_XID_UNKNOWN)
 		ep->rxid = ntohs(fh->fh_rx_id);
 	if (ep->sid != 0 && ep->sid != ntoh24(fh->fh_d_id)) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_unchecked(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	if (ep->did != ntoh24(fh->fh_s_id) &&
 	    ep->did != FC_FID_FLOGI) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_unchecked(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	sof = fr_sof(fp);
@@ -1555,7 +1555,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		sp->ssb_stat |= SSB_ST_RESP;
 		sp->id = fh->fh_seq_id;
 	} else if (sp->id != fh->fh_seq_id) {
-		atomic_inc(&mp->stats.seq_not_found);
+		atomic_inc_unchecked(&mp->stats.seq_not_found);
 		goto rel;
 	}
 
@@ -1618,9 +1618,9 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
 
 	if (!sp)
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_unchecked(&mp->stats.xid_not_found);
 	else
-		atomic_inc(&mp->stats.non_bls_resp);
+		atomic_inc_unchecked(&mp->stats.non_bls_resp);
 
 	fc_frame_free(fp);
 }
@@ -2261,13 +2261,13 @@ void fc_exch_update_stats(struct fc_lport *lport)
 
 	list_for_each_entry(ema, &lport->ema_list, ema_list) {
 		mp = ema->mp;
-		st->fc_no_free_exch += atomic_read(&mp->stats.no_free_exch);
+		st->fc_no_free_exch += atomic_read_unchecked(&mp->stats.no_free_exch);
 		st->fc_no_free_exch_xid +=
-				atomic_read(&mp->stats.no_free_exch_xid);
-		st->fc_xid_not_found += atomic_read(&mp->stats.xid_not_found);
-		st->fc_xid_busy += atomic_read(&mp->stats.xid_busy);
-		st->fc_seq_not_found += atomic_read(&mp->stats.seq_not_found);
-		st->fc_non_bls_resp += atomic_read(&mp->stats.non_bls_resp);
+				atomic_read_unchecked(&mp->stats.no_free_exch_xid);
+		st->fc_xid_not_found += atomic_read_unchecked(&mp->stats.xid_not_found);
+		st->fc_xid_busy += atomic_read_unchecked(&mp->stats.xid_busy);
+		st->fc_seq_not_found += atomic_read_unchecked(&mp->stats.seq_not_found);
+		st->fc_non_bls_resp += atomic_read_unchecked(&mp->stats.non_bls_resp);
 	}
 }
 EXPORT_SYMBOL(fc_exch_update_stats);
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index a5a56fa..43499fd 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -435,7 +435,7 @@ struct lpfc_vport {
 	struct dentry *debug_nodelist;
 	struct dentry *vport_debugfs_root;
 	struct lpfc_debugfs_trc *disc_trc;
-	atomic_t disc_trc_cnt;
+	atomic_unchecked_t disc_trc_cnt;
 #endif
 	uint8_t stat_data_enabled;
 	uint8_t stat_data_blocked;
@@ -885,8 +885,8 @@ struct lpfc_hba {
 	struct timer_list fabric_block_timer;
 	unsigned long bit_flags;
 #define	FABRIC_COMANDS_BLOCKED	0
-	atomic_t num_rsrc_err;
-	atomic_t num_cmd_success;
+	atomic_unchecked_t num_rsrc_err;
+	atomic_unchecked_t num_cmd_success;
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -921,7 +921,7 @@ struct lpfc_hba {
 
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
-	atomic_t slow_ring_trc_cnt;
+	atomic_unchecked_t slow_ring_trc_cnt;
 	/* iDiag debugfs sub-directory */
 	struct dentry *idiag_root;
 	struct dentry *idiag_pci_cfg;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 25aa9b9..d700a65 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -106,7 +106,7 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 
 #include <linux/debugfs.h>
 
-static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
+static atomic_unchecked_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
 /* iDiag */
@@ -147,7 +147,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
 	lpfc_debugfs_enable = 0;
 
 	len = 0;
-	index = (atomic_read(&vport->disc_trc_cnt) + 1) &
+	index = (atomic_read_unchecked(&vport->disc_trc_cnt) + 1) &
 		(lpfc_debugfs_max_disc_trc - 1);
 	for (i = index; i < lpfc_debugfs_max_disc_trc; i++) {
 		dtp = vport->disc_trc + i;
@@ -213,7 +213,7 @@ lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
 	lpfc_debugfs_enable = 0;
 
 	len = 0;
-	index = (atomic_read(&phba->slow_ring_trc_cnt) + 1) &
+	index = (atomic_read_unchecked(&phba->slow_ring_trc_cnt) + 1) &
 		(lpfc_debugfs_max_slow_ring_trc - 1);
 	for (i = index; i < lpfc_debugfs_max_slow_ring_trc; i++) {
 		dtp = phba->slow_ring_trc + i;
@@ -646,14 +646,14 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 		!vport || !vport->disc_trc)
 		return;
 
-	index = atomic_inc_return(&vport->disc_trc_cnt) &
+	index = atomic_inc_return_unchecked(&vport->disc_trc_cnt) &
 		(lpfc_debugfs_max_disc_trc - 1);
 	dtp = vport->disc_trc + index;
 	dtp->fmt = fmt;
 	dtp->data1 = data1;
 	dtp->data2 = data2;
 	dtp->data3 = data3;
-	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
+	dtp->seq_cnt = atomic_inc_return_unchecked(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
 	return;
@@ -684,14 +684,14 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 		!phba || !phba->slow_ring_trc)
 		return;
 
-	index = atomic_inc_return(&phba->slow_ring_trc_cnt) &
+	index = atomic_inc_return_unchecked(&phba->slow_ring_trc_cnt) &
 		(lpfc_debugfs_max_slow_ring_trc - 1);
 	dtp = phba->slow_ring_trc + index;
 	dtp->fmt = fmt;
 	dtp->data1 = data1;
 	dtp->data2 = data2;
 	dtp->data3 = data3;
-	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
+	dtp->seq_cnt = atomic_inc_return_unchecked(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
 	return;
@@ -4268,7 +4268,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 						 "slow_ring buffer\n");
 				goto debug_failed;
 			}
-			atomic_set(&phba->slow_ring_trc_cnt, 0);
+			atomic_set_unchecked(&phba->slow_ring_trc_cnt, 0);
 			memset(phba->slow_ring_trc, 0,
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
@@ -4314,7 +4314,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				 "buffer\n");
 		goto debug_failed;
 	}
-	atomic_set(&vport->disc_trc_cnt, 0);
+	atomic_set_unchecked(&vport->disc_trc_cnt, 0);
 
 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index e5eb40d..056dcd4 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -261,7 +261,7 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 	unsigned long expires;
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	atomic_inc(&phba->num_rsrc_err);
+	atomic_inc_unchecked(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time = jiffies;
 
 	expires = phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL;
@@ -303,8 +303,8 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 	unsigned long num_rsrc_err, num_cmd_success;
 	int i;
 
-	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
-	num_cmd_success = atomic_read(&phba->num_cmd_success);
+	num_rsrc_err = atomic_read_unchecked(&phba->num_rsrc_err);
+	num_cmd_success = atomic_read_unchecked(&phba->num_cmd_success);
 
 	/*
 	 * The error and success command counters are global per
@@ -331,8 +331,8 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
-	atomic_set(&phba->num_rsrc_err, 0);
-	atomic_set(&phba->num_cmd_success, 0);
+	atomic_set_unchecked(&phba->num_rsrc_err, 0);
+	atomic_set_unchecked(&phba->num_cmd_success, 0);
 }
 
 /**
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index ed31d8c..ab856b3 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -200,8 +200,8 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
 		res->scsi_dev = scsi_dev;
 		scsi_dev->hostdata = res;
 		res->change_detected = 0;
-		atomic_set(&res->read_failures, 0);
-		atomic_set(&res->write_failures, 0);
+		atomic_set_unchecked(&res->read_failures, 0);
+		atomic_set_unchecked(&res->write_failures, 0);
 		rc = 0;
 	}
 	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
@@ -2640,9 +2640,9 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 
 	/* If this was a SCSI read/write command keep count of errors */
 	if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_READ_CMD)
-		atomic_inc(&res->read_failures);
+		atomic_inc_unchecked(&res->read_failures);
 	else if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_WRITE_CMD)
-		atomic_inc(&res->write_failures);
+		atomic_inc_unchecked(&res->write_failures);
 
 	if (!RES_IS_GSCSI(res->cfg_entry) &&
 		masked_ioasc != PMCRAID_IOASC_HW_DEVICE_BUS_STATUS_ERROR) {
@@ -3468,7 +3468,7 @@ static int pmcraid_queuecommand_lck(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+	ioarcb->hrrq_id = atomic_add_return_unchecked(1, &(pinstance->last_message_id)) %
 			  pinstance->num_hrrq;
 	cmd->cmd_done = pmcraid_io_done;
 
@@ -3782,7 +3782,7 @@ static long pmcraid_ioctl_passthrough(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
+	ioarcb->hrrq_id = atomic_add_return_unchecked(1, &(pinstance->last_message_id)) %
 			  pinstance->num_hrrq;
 
 	if (request_size) {
@@ -4420,7 +4420,7 @@ static void pmcraid_worker_function(struct work_struct *workp)
 
 	pinstance = container_of(workp, struct pmcraid_instance, worker_q);
 	/* add resources only after host is added into system */
-	if (!atomic_read(&pinstance->expose_resources))
+	if (!atomic_read_unchecked(&pinstance->expose_resources))
 		return;
 
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
@@ -5237,8 +5237,8 @@ static int pmcraid_init_instance(struct pci_dev *pdev, struct Scsi_Host *host,
 	init_waitqueue_head(&pinstance->reset_wait_q);
 
 	atomic_set(&pinstance->outstanding_cmds, 0);
-	atomic_set(&pinstance->last_message_id, 0);
-	atomic_set(&pinstance->expose_resources, 0);
+	atomic_set_unchecked(&pinstance->last_message_id, 0);
+	atomic_set_unchecked(&pinstance->expose_resources, 0);
 
 	INIT_LIST_HEAD(&pinstance->free_res_q);
 	INIT_LIST_HEAD(&pinstance->used_res_q);
@@ -5951,7 +5951,7 @@ static int pmcraid_probe(struct pci_dev *pdev,
 	/* Schedule worker thread to handle CCN and take care of adding and
 	 * removing devices to OS
 	 */
-	atomic_set(&pinstance->expose_resources, 1);
+	atomic_set_unchecked(&pinstance->expose_resources, 1);
 	schedule_work(&pinstance->worker_q);
 	return rc;
 
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index e1d150f..6c6df44 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -748,7 +748,7 @@ struct pmcraid_instance {
 	struct pmcraid_isr_param hrrq_vector[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Message id as filled in last fired IOARCB, used to identify HRRQ */
-	atomic_t last_message_id;
+	atomic_unchecked_t last_message_id;
 
 	/* configuration table */
 	struct pmcraid_config_table *cfg_table;
@@ -777,7 +777,7 @@ struct pmcraid_instance {
 	atomic_t outstanding_cmds;
 
 	/* should add/delete resources to mid-layer now ?*/
-	atomic_t expose_resources;
+	atomic_unchecked_t expose_resources;
 
 
 
@@ -813,8 +813,8 @@ struct pmcraid_resource_entry {
 		struct pmcraid_config_table_entry_ext cfg_entry_ext;
 	};
 	struct scsi_device *scsi_dev;	/* Link scsi_device structure */
-	atomic_t read_failures;		/* count of failed READ commands */
-	atomic_t write_failures;	/* count of failed WRITE commands */
+	atomic_unchecked_t read_failures;	/* count of failed READ commands */
+	atomic_unchecked_t write_failures;	/* count of failed WRITE commands */
 
 	/* To indicate add/delete/modify during CCN */
 	u8 change_detected;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index a7cfc27..151f483 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -306,7 +306,7 @@ struct ddb_entry {
 					   * (4000 only) */
 	atomic_t relogin_timer;		  /* Max Time to wait for
 					   * relogin to complete */
-	atomic_t relogin_retry_count;	  /* Num of times relogin has been
+	atomic_unchecked_t relogin_retry_count;	  /* Num of times relogin has been
 					   * retried */
 	uint32_t default_time2wait;	  /* Default Min time between
 					   * relogins (+aens) */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6d25879..3031a9f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4491,12 +4491,12 @@ static void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
 		 */
 		if (!iscsi_is_session_online(cls_sess)) {
 			/* Reset retry relogin timer */
-			atomic_inc(&ddb_entry->relogin_retry_count);
+			atomic_inc_unchecked(&ddb_entry->relogin_retry_count);
 			DEBUG2(ql4_printk(KERN_INFO, ha,
 				"%s: index[%d] relogin timed out-retrying"
 				" relogin (%d), retry (%d)\n", __func__,
 				ddb_entry->fw_ddb_index,
-				atomic_read(&ddb_entry->relogin_retry_count),
+				atomic_read_unchecked(&ddb_entry->relogin_retry_count),
 				ddb_entry->default_time2wait + 4));
 			set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
 			atomic_set(&ddb_entry->retry_relogin_timer,
@@ -6604,7 +6604,7 @@ static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
 
 	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
 	atomic_set(&ddb_entry->relogin_timer, 0);
-	atomic_set(&ddb_entry->relogin_retry_count, 0);
+	atomic_set_unchecked(&ddb_entry->relogin_retry_count, 0);
 	def_timeout = le16_to_cpu(ddb_entry->fw_ddb_entry.def_timeout);
 	ddb_entry->default_relogin_timeout =
 		(def_timeout > LOGIN_TOV) && (def_timeout < LOGIN_TOV * 10) ?
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 448ebda..9bd345f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1597,7 +1597,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
-	atomic_inc(&cmd->device->iorequest_cnt);
+	atomic_inc_unchecked(&cmd->device->iorequest_cnt);
 
 	/*
 	 * SCSI request completion path will do scsi_device_unbusy(),
@@ -1620,9 +1620,9 @@ static void scsi_softirq_done(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	atomic_inc(&cmd->device->iodone_cnt);
+	atomic_inc_unchecked(&cmd->device->iodone_cnt);
 	if (cmd->result)
-		atomic_inc(&cmd->device->ioerr_cnt);
+		atomic_inc_unchecked(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS &&
@@ -1663,7 +1663,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
 
-	atomic_inc(&cmd->device->iorequest_cnt);
+	atomic_inc_unchecked(&cmd->device->iorequest_cnt);
 
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 9ad4116..4e736fc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -788,7 +788,7 @@ show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
 		    char *buf)						\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	unsigned long long count = atomic_read(&sdev->field);		\
+	unsigned long long count = atomic_read_unchecked(&sdev->field);	\
 	return snprintf(buf, 20, "0x%llx\n", count);			\
 }									\
 static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 24eaaf6..0e8cb69 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -502,7 +502,7 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_class,
  * Netlink Infrastructure
  */
 
-static atomic_t fc_event_seq;
+static atomic_unchecked_t fc_event_seq;
 
 /**
  * fc_get_event_number - Obtain the next sequential FC event number
@@ -515,7 +515,7 @@ static atomic_t fc_event_seq;
 u32
 fc_get_event_number(void)
 {
-	return atomic_add_return(1, &fc_event_seq);
+	return atomic_add_return_unchecked(1, &fc_event_seq);
 }
 EXPORT_SYMBOL(fc_get_event_number);
 
@@ -659,7 +659,7 @@ static __init int fc_transport_init(void)
 {
 	int error;
 
-	atomic_set(&fc_event_seq, 0);
+	atomic_set_unchecked(&fc_event_seq, 0);
 
 	error = transport_class_register(&fc_host_class);
 	if (error)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 55647aa..b647d05 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -79,7 +79,7 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
+static atomic_unchecked_t iscsi_session_nr; /* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
 static DEFINE_IDA(iscsi_sess_ida);
@@ -2073,7 +2073,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	int err;
 
 	ihost = shost->shost_data;
-	session->sid = atomic_add_return(1, &iscsi_session_nr);
+	session->sid = atomic_add_return_unchecked(1, &iscsi_session_nr);
 
 	if (target_id == ISCSI_MAX_TARGET) {
 		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
@@ -4517,7 +4517,7 @@ static __init int iscsi_transport_init(void)
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
-	atomic_set(&iscsi_session_nr, 0);
+	atomic_set_unchecked(&iscsi_session_nr, 0);
 
 	err = class_register(&iscsi_transport_class);
 	if (err)
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..00560ec 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -35,7 +35,7 @@
 #include "scsi_priv.h"
 
 struct srp_host_attrs {
-	atomic_t next_port_id;
+	atomic_unchecked_t next_port_id;
 };
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
@@ -105,7 +105,7 @@ static int srp_host_setup(struct transport_container *tc, struct device *dev,
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 
-	atomic_set(&srp_host->next_port_id, 0);
+	atomic_set_unchecked(&srp_host->next_port_id, 0);
 	return 0;
 }
 
@@ -752,7 +752,7 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 			  rport_fast_io_fail_timedout);
 	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
 
-	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
+	id = atomic_inc_return_unchecked(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
 	transport_setup_device(&rport->dev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a20da8c..d01312b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2973,7 +2973,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	atomic_set(&sdkp->openers, 0);
-	atomic_set(&sdkp->device->ioerr_cnt, 0);
+	atomic_set_unchecked(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
diff --git a/drivers/staging/android/timed_output.c b/drivers/staging/android/timed_output.c
index b41429f..2de5373 100644
--- a/drivers/staging/android/timed_output.c
+++ b/drivers/staging/android/timed_output.c
@@ -25,7 +25,7 @@
 #include "timed_output.h"
 
 static struct class *timed_output_class;
-static atomic_t device_count;
+static atomic_unchecked_t device_count;
 
 static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
 			   char *buf)
@@ -65,7 +65,7 @@ static int create_timed_output_class(void)
 		timed_output_class = class_create(THIS_MODULE, "timed_output");
 		if (IS_ERR(timed_output_class))
 			return PTR_ERR(timed_output_class);
-		atomic_set(&device_count, 0);
+		atomic_set_unchecked(&device_count, 0);
 		timed_output_class->dev_groups = timed_output_groups;
 	}
 
@@ -83,7 +83,7 @@ int timed_output_dev_register(struct timed_output_dev *tdev)
 	if (ret < 0)
 		return ret;
 
-	tdev->index = atomic_inc_return(&device_count);
+	tdev->index = atomic_inc_return_unchecked(&device_count);
 	tdev->dev = device_create(timed_output_class, NULL,
 		MKDEV(0, tdev->index), NULL, "%s", tdev->name);
 	if (IS_ERR(tdev->dev))
diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 22853d3..cfa3c49 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -335,14 +335,14 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 				/* Increment RX stats for virtual ports */
 				if (work->ipprt >= CVMX_PIP_NUM_INPUT_PORTS) {
 #ifdef CONFIG_64BIT
-					atomic64_add(1,
+					atomic64_add_unchecked(1,
 						     (atomic64_t *)&priv->stats.rx_packets);
-					atomic64_add(skb->len,
+					atomic64_add_unchecked(skb->len,
 						     (atomic64_t *)&priv->stats.rx_bytes);
 #else
-					atomic_add(1,
+					atomic_add_unchecked(1,
 						   (atomic_t *)&priv->stats.rx_packets);
-					atomic_add(skb->len,
+					atomic_add_unchecked(skb->len,
 						   (atomic_t *)&priv->stats.rx_bytes);
 #endif
 				}
@@ -354,10 +354,10 @@ static int cvm_oct_napi_poll(struct napi_struct *napi, int budget)
 					   dev->name);
 				*/
 #ifdef CONFIG_64BIT
-				atomic64_add(1,
+				atomic64_add_unchecked(1,
 					     (atomic64_t *)&priv->stats.rx_dropped);
 #else
-				atomic_add(1,
+				atomic_add_unchecked(1,
 					   (atomic_t *)&priv->stats.rx_dropped);
 #endif
 				dev_kfree_skb_irq(skb);
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index f9dba23..7bc0ef3 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -231,11 +231,11 @@ static struct net_device_stats *cvm_oct_common_get_stats(struct net_device *dev)
 		 * since the RX tasklet also increments it.
 		 */
 #ifdef CONFIG_64BIT
-		atomic64_add(rx_status.dropped_packets,
-			     (atomic64_t *)&priv->stats.rx_dropped);
+		atomic64_add_unchecked(rx_status.dropped_packets,
+			     (atomic64_unchecked_t *)&priv->stats.rx_dropped);
 #else
-		atomic_add(rx_status.dropped_packets,
-			     (atomic_t *)&priv->stats.rx_dropped);
+		atomic_add_unchecked(rx_status.dropped_packets,
+			     (atomic_unchecked_t *)&priv->stats.rx_dropped);
 #endif
 	}
 
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 0edf320..49afe95 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -60,7 +60,7 @@ static const u32 sbp_unit_directory_template[] = {
 
 #define SESSION_MAINTENANCE_INTERVAL HZ
 
-static atomic_t login_id = ATOMIC_INIT(0);
+static atomic_unchecked_t login_id = ATOMIC_INIT(0);
 
 static void session_maintenance_work(struct work_struct *);
 static int sbp_run_transaction(struct fw_card *, int, int, int, int,
@@ -441,7 +441,7 @@ static void sbp_management_request_login(
 	login->login_lun = unpacked_lun;
 	login->status_fifo_addr = sbp2_pointer_to_addr(&req->orb.status_fifo);
 	login->exclusive = LOGIN_ORB_EXCLUSIVE(be32_to_cpu(req->orb.misc));
-	login->login_id = atomic_inc_return(&login_id);
+	login->login_id = atomic_inc_return_unchecked(&login_id);
 
 	login->tgt_agt = sbp_target_agent_register(login);
 	if (IS_ERR(login->tgt_agt)) {
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 8f1cd19..ba7a8f1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -772,7 +772,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	spin_lock_init(&dev->se_tmr_lock);
 	spin_lock_init(&dev->qf_cmd_lock);
 	sema_init(&dev->caw_sem, 1);
-	atomic_set(&dev->dev_ordered_id, 0);
+	atomic_set_unchecked(&dev->dev_ordered_id, 0);
 	INIT_LIST_HEAD(&dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&dev->t10_pr.registration_list);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ce8574b..98d6199 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1181,7 +1181,7 @@ transport_check_alloc_task_attr(struct se_cmd *cmd)
 	 * Used to determine when ORDERED commands should go from
 	 * Dormant to Active status.
 	 */
-	cmd->se_ordered_id = atomic_inc_return(&dev->dev_ordered_id);
+	cmd->se_ordered_id = atomic_inc_return_unchecked(&dev->dev_ordered_id);
 	pr_debug("Allocated se_ordered_id: %u for Task Attr: 0x%02x on %s\n",
 			cmd->se_ordered_id, cmd->sam_task_attr,
 			dev->transport->name);
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 4190199..48f2920 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -85,7 +85,7 @@ struct hvsi_struct {
 	int n_outbuf;
 	uint32_t vtermno;
 	uint32_t virq;
-	atomic_t seqno; /* HVSI packet sequence number */
+	atomic_unchecked_t seqno; /* HVSI packet sequence number */
 	uint16_t mctrl;
 	uint8_t state;  /* HVSI protocol state */
 	uint8_t flags;
@@ -295,7 +295,7 @@ static int hvsi_version_respond(struct hvsi_struct *hp, uint16_t query_seqno)
 
 	packet.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
 	packet.hdr.len = sizeof(struct hvsi_query_response);
-	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.seqno = atomic_inc_return_unchecked(&hp->seqno);
 	packet.verb = VSV_SEND_VERSION_NUMBER;
 	packet.u.version = HVSI_VERSION;
 	packet.query_seqno = query_seqno+1;
@@ -555,7 +555,7 @@ static int hvsi_query(struct hvsi_struct *hp, uint16_t verb)
 
 	packet.hdr.type = VS_QUERY_PACKET_HEADER;
 	packet.hdr.len = sizeof(struct hvsi_query);
-	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.seqno = atomic_inc_return_unchecked(&hp->seqno);
 	packet.verb = verb;
 
 	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
@@ -597,7 +597,7 @@ static int hvsi_set_mctrl(struct hvsi_struct *hp, uint16_t mctrl)
 	int wrote;
 
 	packet.hdr.type = VS_CONTROL_PACKET_HEADER,
-	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.seqno = atomic_inc_return_unchecked(&hp->seqno);
 	packet.hdr.len = sizeof(struct hvsi_control);
 	packet.verb = VSV_SET_MODEM_CTL;
 	packet.mask = HVSI_TSDTR;
@@ -680,7 +680,7 @@ static int hvsi_put_chars(struct hvsi_struct *hp, const char *buf, int count)
 	BUG_ON(count > HVSI_MAX_OUTGOING_DATA);
 
 	packet.hdr.type = VS_DATA_PACKET_HEADER;
-	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.seqno = atomic_inc_return_unchecked(&hp->seqno);
 	packet.hdr.len = count + sizeof(struct hvsi_header);
 	memcpy(&packet.data, buf, count);
 
@@ -697,7 +697,7 @@ static void hvsi_close_protocol(struct hvsi_struct *hp)
 	struct hvsi_control packet __ALIGNED__;
 
 	packet.hdr.type = VS_CONTROL_PACKET_HEADER;
-	packet.hdr.seqno = atomic_inc_return(&hp->seqno);
+	packet.hdr.seqno = atomic_inc_return_unchecked(&hp->seqno);
 	packet.hdr.len = 6;
 	packet.verb = VSV_CLOSE_PROTOCOL;
 
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index a270f04..7c77b5d 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -8,7 +8,7 @@
 
 static int hvsi_send_packet(struct hvsi_priv *pv, struct hvsi_header *packet)
 {
-	packet->seqno = cpu_to_be16(atomic_inc_return(&pv->seqno));
+	packet->seqno = cpu_to_be16(atomic_inc_return_unchecked(&pv->seqno));
 
 	/* Assumes that always succeeds, works in practice */
 	return pv->put_chars(pv->termno, (char *)packet, packet->len);
@@ -20,7 +20,7 @@ static void hvsi_start_handshake(struct hvsi_priv *pv)
 
 	/* Reset state */
 	pv->established = 0;
-	atomic_set(&pv->seqno, 0);
+	atomic_set_unchecked(&pv->seqno, 0);
 
 	pr_devel("HVSI@%x: Handshaking started\n", pv->termno);
 
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index e5c42fe..f091b02 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -437,7 +437,7 @@ struct ioc4_soft {
 		} is_intr_info[MAX_IOC4_INTR_ENTS];
 
 		/* Number of entries active in the above array */
-		atomic_t is_num_intrs;
+		atomic_unchecked_t is_num_intrs;
 	} is_intr_type[IOC4_NUM_INTR_TYPES];
 
 	/* is_ir_lock must be held while
@@ -974,7 +974,7 @@ intr_connect(struct ioc4_soft *soft, int type,
 	BUG_ON(!((type == IOC4_SIO_INTR_TYPE)
 	       || (type == IOC4_OTHER_INTR_TYPE)));
 
-	i = atomic_inc_return(&soft-> is_intr_type[type].is_num_intrs) - 1;
+	i = atomic_inc_return_unchecked(&soft-> is_intr_type[type].is_num_intrs) - 1;
 	BUG_ON(!(i < MAX_IOC4_INTR_ENTS || (printk("i %d\n", i), 0)));
 
 	/* Save off the lower level interrupt handler */
@@ -1001,7 +1001,7 @@ static irqreturn_t ioc4_intr(int irq, void *arg)
 
 	soft = arg;
 	for (intr_type = 0; intr_type < IOC4_NUM_INTR_TYPES; intr_type++) {
-		num_intrs = (int)atomic_read(
+		num_intrs = (int)atomic_read_unchecked(
 				&soft->is_intr_type[intr_type].is_num_intrs);
 
 		this_mir = this_ir = pending_intrs(soft, intr_type);
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index b73889c..9f74f0a 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1012,7 +1012,7 @@ static struct uart_driver msm_uart_driver = {
 	.cons = MSM_CONSOLE,
 };
 
-static atomic_t msm_uart_next_id = ATOMIC_INIT(0);
+static atomic_unchecked_t msm_uart_next_id = ATOMIC_INIT(0);
 
 static const struct of_device_id msm_uartdm_table[] = {
 	{ .compatible = "qcom,msm-uartdm-v1.1", .data = (void *)UARTDM_1P1 },
@@ -1036,7 +1036,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 		line = pdev->id;
 
 	if (line < 0)
-		line = atomic_inc_return(&msm_uart_next_id) - 1;
+		line = atomic_inc_return_unchecked(&msm_uart_next_id) - 1;
 
 	if (unlikely(line < 0 || line >= UART_NR))
 		return -ENXIO;
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 3257d42..16f1d37 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -231,7 +231,7 @@ static ssize_t event_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
+	return sprintf(buf, "%u\n", (unsigned int)atomic_read_unchecked(&idev->event));
 }
 static DEVICE_ATTR_RO(event);
 
@@ -393,7 +393,7 @@ void uio_event_notify(struct uio_info *info)
 {
 	struct uio_device *idev = info->uio_dev;
 
-	atomic_inc(&idev->event);
+	atomic_inc_unchecked(&idev->event);
 	wake_up_interruptible(&idev->wait);
 	kill_fasync(&idev->async_queue, SIGIO, POLL_IN);
 }
@@ -446,7 +446,7 @@ static int uio_open(struct inode *inode, struct file *filep)
 	}
 
 	listener->dev = idev;
-	listener->event_count = atomic_read(&idev->event);
+	listener->event_count = atomic_read_unchecked(&idev->event);
 	filep->private_data = listener;
 
 	if (idev->info->open) {
@@ -497,7 +497,7 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
 		return -EIO;
 
 	poll_wait(filep, &idev->wait, wait);
-	if (listener->event_count != atomic_read(&idev->event))
+	if (listener->event_count != atomic_read_unchecked(&idev->event))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
@@ -522,7 +522,7 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		event_count = atomic_read(&idev->event);
+		event_count = atomic_read_unchecked(&idev->event);
 		if (event_count != listener->event_count) {
 			if (copy_to_user(buf, &event_count, count))
 				retval = -EFAULT;
@@ -813,7 +813,7 @@ int __uio_register_device(struct module *owner,
 	idev->owner = owner;
 	idev->info = info;
 	init_waitqueue_head(&idev->wait);
-	atomic_set(&idev->event, 0);
+	atomic_set_unchecked(&idev->event, 0);
 
 	ret = uio_get_minor(idev);
 	if (ret)
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index db322d9..f0f4bc1 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -331,7 +331,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (printk_ratelimit())
 			atm_warn(instance, "%s: OAM not supported (vpi %d, vci %d)!\n",
 				__func__, vpi, vci);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_unchecked(&vcc->stats->rx_err);
 		return;
 	}
 
@@ -358,7 +358,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (length > ATM_MAX_AAL5_PDU) {
 			atm_rldbg(instance, "%s: bogus length %u (vcc: 0x%p)!\n",
 				  __func__, length, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			goto out;
 		}
 
@@ -367,14 +367,14 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (sarb->len < pdu_length) {
 			atm_rldbg(instance, "%s: bogus pdu_length %u (sarb->len: %u, vcc: 0x%p)!\n",
 				  __func__, pdu_length, sarb->len, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			goto out;
 		}
 
 		if (crc32_be(~0, skb_tail_pointer(sarb) - pdu_length, pdu_length) != 0xc704dd7b) {
 			atm_rldbg(instance, "%s: packet failed crc check (vcc: 0x%p)!\n",
 				  __func__, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			goto out;
 		}
 
@@ -387,7 +387,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 			if (printk_ratelimit())
 				atm_err(instance, "%s: no memory for skb (length: %u)!\n",
 					__func__, length);
-			atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc_unchecked(&vcc->stats->rx_drop);
 			goto out;
 		}
 
@@ -415,7 +415,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 
 		vcc->push(vcc, skb);
 
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 	out:
 		skb_trim(sarb, 0);
 	}
@@ -613,7 +613,7 @@ static void usbatm_tx_process(unsigned long data)
 			struct atm_vcc *vcc = UDSL_SKB(skb)->atm.vcc;
 
 			usbatm_pop(vcc, skb);
-			atomic_inc(&vcc->stats->tx);
+			atomic_inc_unchecked(&vcc->stats->tx);
 
 			skb = skb_dequeue(&instance->sndqueue);
 		}
@@ -757,11 +757,11 @@ static int usbatm_atm_proc_read(struct atm_dev *atm_dev, loff_t *pos, char *page
 	if (!left--)
 		return sprintf(page,
 			       "AAL5: tx %d ( %d err ), rx %d ( %d err, %d drop )\n",
-			       atomic_read(&atm_dev->stats.aal5.tx),
-			       atomic_read(&atm_dev->stats.aal5.tx_err),
-			       atomic_read(&atm_dev->stats.aal5.rx),
-			       atomic_read(&atm_dev->stats.aal5.rx_err),
-			       atomic_read(&atm_dev->stats.aal5.rx_drop));
+			       atomic_read_unchecked(&atm_dev->stats.aal5.tx),
+			       atomic_read_unchecked(&atm_dev->stats.aal5.tx_err),
+			       atomic_read_unchecked(&atm_dev->stats.aal5.rx),
+			       atomic_read_unchecked(&atm_dev->stats.aal5.rx_err),
+			       atomic_read_unchecked(&atm_dev->stats.aal5.rx_drop));
 
 	if (!left--) {
 		if (instance->disconnected)
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 2a3bbdf..91d72cf 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -126,7 +126,7 @@ static const char format_endpt[] =
  * time it gets called.
  */
 static struct device_connect_event {
-	atomic_t count;
+	atomic_unchecked_t count;
 	wait_queue_head_t wait;
 } device_event = {
 	.count = ATOMIC_INIT(1),
@@ -164,7 +164,7 @@ static const struct class_info clas_info[] = {
 
 void usbfs_conn_disc_event(void)
 {
-	atomic_add(2, &device_event.count);
+	atomic_add_unchecked(2, &device_event.count);
 	wake_up(&device_event.wait);
 }
 
@@ -652,7 +652,7 @@ static unsigned int usb_device_poll(struct file *file,
 
 	poll_wait(file, &device_event.wait, wait);
 
-	event_count = atomic_read(&device_event.count);
+	event_count = atomic_read_unchecked(&device_event.count);
 	if (file->f_version != event_count) {
 		file->f_version = event_count;
 		return POLLIN | POLLRDNORM;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index cbcd092..e783f87 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1554,7 +1554,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_unchecked(&urb->dev->urbnum);
 	usbmon_urb_submit(&hcd->self, urb);
 
 	/* NOTE requirements on root-hub callers (usbfs and the hub
@@ -1581,7 +1581,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
-		atomic_dec(&urb->dev->urbnum);
+		atomic_dec_unchecked(&urb->dev->urbnum);
 		if (atomic_read(&urb->reject))
 			wake_up(&usb_kill_urb_queue);
 		usb_put_urb(urb);
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index d269738..7340cd7 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -244,7 +244,7 @@ static ssize_t urbnum_show(struct device *dev, struct device_attribute *attr,
 	struct usb_device *udev;
 
 	udev = to_usb_device(dev);
-	return sprintf(buf, "%d\n", atomic_read(&udev->urbnum));
+	return sprintf(buf, "%d\n", atomic_read_unchecked(&udev->urbnum));
 }
 static DEVICE_ATTR_RO(urbnum);
 
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 8d5b2f4..3896940 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -447,7 +447,7 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 	set_dev_node(&dev->dev, dev_to_node(bus->controller));
 	dev->state = USB_STATE_ATTACHED;
 	dev->lpm_disable_count = 1;
-	atomic_set(&dev->urbnum, 0);
+	atomic_set_unchecked(&dev->urbnum, 0);
 
 	INIT_LIST_HEAD(&dev->ep0.urb_list);
 	dev->ep0.desc.bLength = USB_DT_ENDPOINT_SIZE;
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 22abb68..50b7b84 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -773,7 +773,7 @@ static struct urb *request_single_step_set_feature_urb(
 	urb->transfer_flags = URB_DIR_IN;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_unchecked(&urb->dev->urbnum);
 	urb->setup_dma = dma_map_single(
 			hcd->self.controller,
 			urb->setup_packet,
@@ -840,7 +840,7 @@ static int ehset_single_step_set_feature(struct usb_hcd *hcd, int port)
 	urb->status = -EINPROGRESS;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_unchecked(&urb->dev->urbnum);
 	retval = submit_single_step_set_feature(hcd, urb, 0);
 	if (!retval && !wait_for_completion_timeout(&done,
 						msecs_to_jiffies(2000))) {
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index a0a3827..d7ec10b 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -84,7 +84,7 @@ struct appledisplay {
 	struct mutex sysfslock;		/* concurrent read and write */
 };
 
-static atomic_t count_displays = ATOMIC_INIT(0);
+static atomic_unchecked_t count_displays = ATOMIC_INIT(0);
 static struct workqueue_struct *wq;
 
 static void appledisplay_complete(struct urb *urb)
@@ -288,7 +288,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
-		atomic_inc_return(&count_displays) - 1);
+		atomic_inc_return_unchecked(&count_displays) - 1);
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
diff --git a/drivers/usb/usbip/vhci.h b/drivers/usb/usbip/vhci.h
index a863a98..d272795 100644
--- a/drivers/usb/usbip/vhci.h
+++ b/drivers/usb/usbip/vhci.h
@@ -83,7 +83,7 @@ struct vhci_hcd {
 	unsigned resuming:1;
 	unsigned long re_timeout;
 
-	atomic_t seqnum;
+	atomic_unchecked_t seqnum;
 
 	/*
 	 * NOTE:
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index e9ef1ec..c3a0b04 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -440,7 +440,7 @@ static void vhci_tx_urb(struct urb *urb)
 
 	spin_lock(&vdev->priv_lock);
 
-	priv->seqnum = atomic_inc_return(&the_controller->seqnum);
+	priv->seqnum = atomic_inc_return_unchecked(&the_controller->seqnum);
 	if (priv->seqnum == 0xffff)
 		dev_info(&urb->dev->dev, "seqnum max\n");
 
@@ -685,7 +685,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 			return -ENOMEM;
 		}
 
-		unlink->seqnum = atomic_inc_return(&the_controller->seqnum);
+		unlink->seqnum = atomic_inc_return_unchecked(&the_controller->seqnum);
 		if (unlink->seqnum == 0xffff)
 			pr_info("seqnum max\n");
 
@@ -889,7 +889,7 @@ static int vhci_start(struct usb_hcd *hcd)
 		vdev->rhport = rhport;
 	}
 
-	atomic_set(&vhci->seqnum, 0);
+	atomic_set_unchecked(&vhci->seqnum, 0);
 	spin_lock_init(&vhci->lock);
 
 	hcd->power_budget = 0; /* no limit */
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index 00e4a54..d676f85 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -80,7 +80,7 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	if (!urb) {
 		pr_err("cannot find a urb of seqnum %u\n", pdu->base.seqnum);
 		pr_info("max seqnum %d\n",
-			atomic_read(&the_controller->seqnum));
+			atomic_read_unchecked(&the_controller->seqnum));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
diff --git a/drivers/usb/wusbcore/wa-hc.h b/drivers/usb/wusbcore/wa-hc.h
index edc7267..9f65ce2 100644
--- a/drivers/usb/wusbcore/wa-hc.h
+++ b/drivers/usb/wusbcore/wa-hc.h
@@ -240,7 +240,7 @@ struct wahc {
 	spinlock_t xfer_list_lock;
 	struct work_struct xfer_enqueue_work;
 	struct work_struct xfer_error_work;
-	atomic_t xfer_id_count;
+	atomic_unchecked_t xfer_id_count;
 
 	kernel_ulong_t	quirks;
 };
@@ -305,7 +305,7 @@ static inline void wa_init(struct wahc *wa)
 	INIT_WORK(&wa->xfer_enqueue_work, wa_urb_enqueue_run);
 	INIT_WORK(&wa->xfer_error_work, wa_process_errored_transfers_run);
 	wa->dto_in_use = 0;
-	atomic_set(&wa->xfer_id_count, 1);
+	atomic_set_unchecked(&wa->xfer_id_count, 1);
 	/* init the buf in URBs */
 	for (index = 0; index < WA_MAX_BUF_IN_URBS; ++index)
 		usb_init_urb(&(wa->buf_in_urbs[index]));
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 69af4fd..da390d7 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -314,7 +314,7 @@ static void wa_xfer_completion(struct wa_xfer *xfer)
  */
 static void wa_xfer_id_init(struct wa_xfer *xfer)
 {
-	xfer->id = atomic_add_return(1, &xfer->wa->xfer_id_count);
+	xfer->id = atomic_add_return_unchecked(1, &xfer->wa->xfer_id_count);
 }
 
 /* Return the xfer's ID. */
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 807ee22..7814cd6 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -240,7 +240,7 @@ static uint screen_fb_size;
 static inline int synthvid_send(struct hv_device *hdev,
 				struct synthvid_msg *msg)
 {
-	static atomic64_t request_id = ATOMIC64_INIT(0);
+	static atomic64_unchecked_t request_id = ATOMIC64_INIT(0);
 	int ret;
 
 	msg->pipe_hdr.type = PIPE_MSG_DATA;
@@ -248,7 +248,7 @@ static inline int synthvid_send(struct hv_device *hdev,
 
 	ret = vmbus_sendpacket(hdev->channel, msg,
 			       msg->vid_hdr.size + sizeof(struct pipe_msg_hdr),
-			       atomic64_inc_return(&request_id),
+			       atomic64_inc_return_unchecked(&request_id),
 			       VM_PKT_DATA_INBAND, 0);
 
 	if (ret)
diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index ff2b873..5ba574d 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -623,11 +623,11 @@ static int dlfb_handle_damage(struct dlfb_data *dev, int x, int y,
 		dlfb_urb_completion(urb);
 
 error:
-	atomic_add(bytes_sent, &dev->bytes_sent);
-	atomic_add(bytes_identical, &dev->bytes_identical);
-	atomic_add(width*height*2, &dev->bytes_rendered);
+	atomic_add_unchecked(bytes_sent, &dev->bytes_sent);
+	atomic_add_unchecked(bytes_identical, &dev->bytes_identical);
+	atomic_add_unchecked(width*height*2, &dev->bytes_rendered);
 	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
+	atomic_add_unchecked(((unsigned int) ((end_cycles - start_cycles)
 		    >> 10)), /* Kcycles */
 		   &dev->cpu_kcycles_used);
 
@@ -748,11 +748,11 @@ static void dlfb_dpy_deferred_io(struct fb_info *info,
 		dlfb_urb_completion(urb);
 
 error:
-	atomic_add(bytes_sent, &dev->bytes_sent);
-	atomic_add(bytes_identical, &dev->bytes_identical);
-	atomic_add(bytes_rendered, &dev->bytes_rendered);
+	atomic_add_unchecked(bytes_sent, &dev->bytes_sent);
+	atomic_add_unchecked(bytes_identical, &dev->bytes_identical);
+	atomic_add_unchecked(bytes_rendered, &dev->bytes_rendered);
 	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
+	atomic_add_unchecked(((unsigned int) ((end_cycles - start_cycles)
 		    >> 10)), /* Kcycles */
 		   &dev->cpu_kcycles_used);
 }
@@ -1373,7 +1373,7 @@ static ssize_t metrics_bytes_rendered_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_rendered));
+			atomic_read_unchecked(&dev->bytes_rendered));
 }
 
 static ssize_t metrics_bytes_identical_show(struct device *fbdev,
@@ -1381,7 +1381,7 @@ static ssize_t metrics_bytes_identical_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_identical));
+			atomic_read_unchecked(&dev->bytes_identical));
 }
 
 static ssize_t metrics_bytes_sent_show(struct device *fbdev,
@@ -1389,7 +1389,7 @@ static ssize_t metrics_bytes_sent_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_sent));
+			atomic_read_unchecked(&dev->bytes_sent));
 }
 
 static ssize_t metrics_cpu_kcycles_used_show(struct device *fbdev,
@@ -1397,7 +1397,7 @@ static ssize_t metrics_cpu_kcycles_used_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->cpu_kcycles_used));
+			atomic_read_unchecked(&dev->cpu_kcycles_used));
 }
 
 static ssize_t edid_show(
@@ -1457,10 +1457,10 @@ static ssize_t metrics_reset_store(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 
-	atomic_set(&dev->bytes_rendered, 0);
-	atomic_set(&dev->bytes_identical, 0);
-	atomic_set(&dev->bytes_sent, 0);
-	atomic_set(&dev->cpu_kcycles_used, 0);
+	atomic_set_unchecked(&dev->bytes_rendered, 0);
+	atomic_set_unchecked(&dev->bytes_identical, 0);
+	atomic_set_unchecked(&dev->bytes_sent, 0);
+	atomic_set_unchecked(&dev->cpu_kcycles_used, 0);
 
 	return count;
 }
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 32c0e83..671eb35 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -67,7 +67,7 @@ struct uio_device {
         struct module           *owner;
         struct device           *dev;
         int                     minor;
-        atomic_t                event;
+        atomic_unchecked_t      event;
         struct fasync_struct    *async_queue;
         wait_queue_head_t       wait;
         struct uio_info         *info;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 447fe29..ff424fd 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -592,7 +592,7 @@ struct usb_device {
 	int maxchild;
 
 	u32 quirks;
-	atomic_t urbnum;
+	atomic_unchecked_t urbnum;
 
 	unsigned long active_duration;
 
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 9c58157..d86ebf5 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -93,7 +93,7 @@ int __must_check v4l2_device_register(struct device *dev, struct v4l2_device *v4
    this function returns 0. If the name ends with a digit (e.g. cx18),
    then the name will be set to cx18-0 since cx180 looks really odd. */
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
-						atomic_t *instance);
+						atomic_unchecked_t *instance);
 
 /* Set v4l2_dev->dev to NULL. Call when the USB parent disconnects.
    Since the parent disappears this ensures that v4l2_dev doesn't have an
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ae84b22..7954097 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -185,9 +185,9 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-	atomic_t iorequest_cnt;
-	atomic_t iodone_cnt;
-	atomic_t ioerr_cnt;
+	atomic_unchecked_t iorequest_cnt;
+	atomic_unchecked_t iodone_cnt;
+	atomic_unchecked_t ioerr_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 17ae2d6..2c06382 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -751,7 +751,7 @@ struct se_device {
 	atomic_long_t		write_bytes;
 	/* Active commands on this virtual SE device */
 	atomic_t		simple_cmds;
-	atomic_t		dev_ordered_id;
+	atomic_unchecked_t	dev_ordered_id;
 	atomic_t		dev_ordered_sync;
 	atomic_t		dev_qf_count;
 	u32			export_count;
-- 
2.5.0
