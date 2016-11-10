Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:45 +0200
Message-Id: <1478809488-18303-11-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 10/13] drivers: identify wrapping atomic usage (part 2/2)
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dwindsor@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

This might need more fine-grained split between
different drivers.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/net/usb/sierra_net.c                     |  4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |  4 +-
 drivers/oprofile/buffer_sync.c                   |  8 ++--
 drivers/oprofile/event_buffer.c                  |  2 +-
 drivers/oprofile/oprof.c                         |  2 +-
 drivers/oprofile/oprofile_stats.c                | 10 ++---
 drivers/oprofile/oprofile_stats.h                | 10 ++---
 drivers/oprofile/oprofilefs.c                    |  8 ++--
 drivers/regulator/core.c                         |  4 +-
 drivers/scsi/fcoe/fcoe_sysfs.c                   | 12 +++---
 drivers/scsi/libfc/fc_exch.c                     | 54 +++++++++++++-----------
 drivers/scsi/lpfc/lpfc.h                         |  8 ++--
 drivers/scsi/lpfc/lpfc_debugfs.c                 | 18 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c                    | 10 ++---
 drivers/scsi/pmcraid.c                           | 24 +++++------
 drivers/scsi/pmcraid.h                           |  8 ++--
 drivers/scsi/qla4xxx/ql4_def.h                   |  3 +-
 drivers/scsi/qla4xxx/ql4_os.c                    |  7 +--
 drivers/scsi/scsi_lib.c                          |  8 ++--
 drivers/scsi/scsi_sysfs.c                        |  2 +-
 drivers/scsi/scsi_transport_fc.c                 |  6 +--
 drivers/scsi/scsi_transport_iscsi.c              |  7 +--
 drivers/scsi/scsi_transport_srp.c                |  6 +--
 drivers/scsi/sd.c                                |  2 +-
 drivers/target/sbp/sbp_target.c                  |  4 +-
 drivers/tty/hvc/hvsi.c                           | 12 +++---
 drivers/tty/hvc/hvsi_lib.c                       |  4 +-
 drivers/tty/serial/ioc4_serial.c                 |  6 +--
 drivers/tty/serial/msm_serial.c                  |  4 +-
 drivers/uio/uio.c                                | 13 +++---
 drivers/usb/core/devices.c                       |  6 +--
 drivers/usb/core/hcd.c                           |  4 +-
 drivers/usb/core/sysfs.c                         |  2 +-
 drivers/usb/core/usb.c                           |  2 +-
 drivers/usb/host/ehci-hub.c                      |  4 +-
 drivers/usb/misc/appledisplay.c                  |  4 +-
 drivers/usb/usbip/vhci.h                         |  2 +-
 drivers/usb/usbip/vhci_hcd.c                     |  6 +--
 drivers/usb/usbip/vhci_rx.c                      |  2 +-
 drivers/usb/wusbcore/wa-hc.h                     |  4 +-
 drivers/usb/wusbcore/wa-xfer.c                   |  2 +-
 drivers/video/fbdev/hyperv_fb.c                  |  4 +-
 drivers/video/fbdev/udlfb.c                      | 32 +++++++-------
 include/linux/oprofile.h                         |  2 +-
 include/linux/uio_driver.h                       |  2 +-
 include/linux/usb.h                              |  2 +-
 include/scsi/scsi_device.h                       |  6 +--
 include/video/udlfb.h                            | 12 ++++--
 49 files changed, 192 insertions(+), 178 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index a2515887..d285128 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -51,7 +51,7 @@ static const char driver_name[] = "sierra_net";
 /* atomic counter partially included in MAC address to make sure 2 devices
  * do not end up with the same MAC - concept breaks in case of > 255 ifaces
  */
-static	atomic_t iface_counter = ATOMIC_INIT(0);
+static	atomic_wrap_t iface_counter = ATOMIC_INIT(0);
 
 /*
  * SYNC Timer Delay definition used to set the expiry time
@@ -697,7 +697,7 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->netdev_ops = &sierra_net_device_ops;
 
 	/* change MAC addr to include, ifacenum, and to be unique */
-	dev->net->dev_addr[ETH_ALEN-2] = atomic_inc_return(&iface_counter);
+	dev->net->dev_addr[ETH_ALEN-2] = atomic_inc_return_wrap(&iface_counter);
 	dev->net->dev_addr[ETH_ALEN-1] = ifacenum;
 
 	/* we will have to manufacture ethernet headers, prepare template */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index f68d492..fc712ef 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -378,7 +378,7 @@ struct rt2x00_intf {
 	 * for hardware which doesn't support hardware
 	 * sequence counting.
 	 */
-	atomic_t seqno;
+	atomic_wrap_t seqno;
 };
 
 static inline struct rt2x00_intf* vif_to_intf(struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 68b620b..1dfaaab 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -224,9 +224,9 @@ static void rt2x00queue_create_tx_descriptor_seq(struct rt2x00_dev *rt2x00dev,
 	 * sequence counter given by mac80211.
 	 */
 	if (test_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc->flags))
-		seqno = atomic_add_return(0x10, &intf->seqno);
+		seqno = atomic_add_return_wrap(0x10, &intf->seqno);
 	else
-		seqno = atomic_read(&intf->seqno);
+		seqno = atomic_read_wrap(&intf->seqno);
 
 	hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
 	hdr->seq_ctrl |= cpu_to_le16(seqno);
diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 82f7000..8db7343 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -345,7 +345,7 @@ static void add_data(struct op_entry *entry, struct mm_struct *mm)
 		if (cookie == NO_COOKIE)
 			offset = pc;
 		if (cookie == INVALID_COOKIE) {
-			atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+			atomic_inc_wrap(&oprofile_stats.sample_lost_no_mapping);
 			offset = pc;
 		}
 		if (cookie != last_cookie) {
@@ -389,14 +389,14 @@ add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 	/* add userspace sample */
 
 	if (!mm) {
-		atomic_inc(&oprofile_stats.sample_lost_no_mm);
+		atomic_inc_wrap(&oprofile_stats.sample_lost_no_mm);
 		return 0;
 	}
 
 	cookie = lookup_dcookie(mm, s->eip, &offset);
 
 	if (cookie == INVALID_COOKIE) {
-		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
+		atomic_inc_wrap(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
 	}
 
@@ -554,7 +554,7 @@ void sync_buffer(int cpu)
 		/* ignore backtraces if failed to add a sample */
 		if (state == sb_bt_start) {
 			state = sb_bt_ignore;
-			atomic_inc(&oprofile_stats.bt_lost_no_mapping);
+			atomic_inc_wrap(&oprofile_stats.bt_lost_no_mapping);
 		}
 	}
 	release_mm(mm);
diff --git a/drivers/oprofile/event_buffer.c b/drivers/oprofile/event_buffer.c
index c0cc4e7..56909b8 100644
--- a/drivers/oprofile/event_buffer.c
+++ b/drivers/oprofile/event_buffer.c
@@ -53,7 +53,7 @@ void add_event_entry(unsigned long value)
 	}
 
 	if (buffer_pos == buffer_size) {
-		atomic_inc(&oprofile_stats.event_lost_overflow);
+		atomic_inc_wrap(&oprofile_stats.event_lost_overflow);
 		return;
 	}
 
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index ed2c3ec..d0c9ef4 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -110,7 +110,7 @@ static void switch_worker(struct work_struct *work)
 	if (oprofile_ops.switch_events())
 		return;
 
-	atomic_inc(&oprofile_stats.multiplex_counter);
+	atomic_inc_wrap(&oprofile_stats.multiplex_counter);
 	start_switch_worker();
 }
 
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 59659ce..e7f2a16d 100644
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
+	atomic_set_wrap(&oprofile_stats.sample_lost_no_mm, 0);
+	atomic_set_wrap(&oprofile_stats.sample_lost_no_mapping, 0);
+	atomic_set_wrap(&oprofile_stats.event_lost_overflow, 0);
+	atomic_set_wrap(&oprofile_stats.bt_lost_no_mapping, 0);
+	atomic_set_wrap(&oprofile_stats.multiplex_counter, 0);
 }
 
 
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 1fc622b..f464cf6 100644
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
+	atomic_wrap_t sample_lost_no_mm;
+	atomic_wrap_t sample_lost_no_mapping;
+	atomic_wrap_t bt_lost_no_mapping;
+	atomic_wrap_t event_lost_overflow;
+	atomic_wrap_t multiplex_counter;
 };
 
 extern struct oprofile_stat_struct oprofile_stats;
diff --git a/drivers/oprofile/oprofilefs.c b/drivers/oprofile/oprofilefs.c
index 134398e..00b5a84 100644
--- a/drivers/oprofile/oprofilefs.c
+++ b/drivers/oprofile/oprofilefs.c
@@ -176,8 +176,10 @@ int oprofilefs_create_ro_ulong(struct dentry *root,
 
 static ssize_t atomic_read_file(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
-	atomic_t *val = file->private_data;
-	return oprofilefs_ulong_to_user(atomic_read(val), buf, count, offset);
+	atomic_wrap_t *val = file->private_data;
+
+	return oprofilefs_ulong_to_user(atomic_read_wrap(val),
+					buf, count, offset);
 }
 
 
@@ -189,7 +191,7 @@ static const struct file_operations atomic_ro_fops = {
 
 
 int oprofilefs_create_ro_atomic(struct dentry *root,
-	char const *name, atomic_t *val)
+	char const *name, atomic_wrap_t *val)
 {
 	return __oprofilefs_create_file(root, name,
 					&atomic_ro_fops, 0444, val);
diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 67426c0..443c4bb 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -3916,7 +3916,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	const struct regulation_constraints *constraints = NULL;
 	const struct regulator_init_data *init_data;
 	struct regulator_config *config = NULL;
-	static atomic_t regulator_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t regulator_no = ATOMIC_INIT(-1);
 	struct regulator_dev *rdev;
 	struct device *dev;
 	int ret, i;
@@ -4009,7 +4009,7 @@ regulator_register(const struct regulator_desc *regulator_desc,
 	rdev->dev.class = &regulator_class;
 	rdev->dev.parent = dev;
 	dev_set_name(&rdev->dev, "regulator.%lu",
-		    (unsigned long) atomic_inc_return(&regulator_no));
+		    (unsigned long) atomic_inc_return_wrap(&regulator_no));
 
 	/* set regulator constraints */
 	if (init_data)
diff --git a/drivers/scsi/fcoe/fcoe_sysfs.c b/drivers/scsi/fcoe/fcoe_sysfs.c
index 0675fd1..4c39c9a 100644
--- a/drivers/scsi/fcoe/fcoe_sysfs.c
+++ b/drivers/scsi/fcoe/fcoe_sysfs.c
@@ -33,8 +33,8 @@
  */
 #include "libfcoe.h"
 
-static atomic_t ctlr_num;
-static atomic_t fcf_num;
+static atomic_wrap_t ctlr_num;
+static atomic_wrap_t fcf_num;
 
 /*
  * fcoe_fcf_dev_loss_tmo: the default number of seconds that fcoe sysfs
@@ -724,7 +724,7 @@ struct fcoe_ctlr_device *fcoe_ctlr_device_add(struct device *parent,
 	if (!ctlr)
 		goto out;
 
-	ctlr->id = atomic_inc_return(&ctlr_num) - 1;
+	ctlr->id = atomic_inc_return_wrap(&ctlr_num) - 1;
 	ctlr->f = f;
 	ctlr->mode = FIP_CONN_TYPE_FABRIC;
 	INIT_LIST_HEAD(&ctlr->fcfs);
@@ -941,7 +941,7 @@ struct fcoe_fcf_device *fcoe_fcf_device_add(struct fcoe_ctlr_device *ctlr,
 	fcf->dev.parent = &ctlr->dev;
 	fcf->dev.bus = &fcoe_bus_type;
 	fcf->dev.type = &fcoe_fcf_device_type;
-	fcf->id = atomic_inc_return(&fcf_num) - 1;
+	fcf->id = atomic_inc_return_wrap(&fcf_num) - 1;
 	fcf->state = FCOE_FCF_STATE_UNKNOWN;
 
 	fcf->dev_loss_tmo = ctlr->fcf_dev_loss_tmo;
@@ -977,8 +977,8 @@ int __init fcoe_sysfs_setup(void)
 {
 	int error;
 
-	atomic_set(&ctlr_num, 0);
-	atomic_set(&fcf_num, 0);
+	atomic_set_wrap(&ctlr_num, 0);
+	atomic_set_wrap(&fcf_num, 0);
 
 	error = bus_register(&fcoe_bus_type);
 	if (error)
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 16ca31a..311481b 100644
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
+		atomic_wrap_t no_free_exch;
+		atomic_wrap_t no_free_exch_xid;
+		atomic_wrap_t xid_not_found;
+		atomic_wrap_t xid_busy;
+		atomic_wrap_t seq_not_found;
+		atomic_wrap_t non_bls_resp;
 	} stats;
 };
 
@@ -809,7 +809,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	/* allocate memory for exchange */
 	ep = mempool_alloc(mp->ep_pool, GFP_ATOMIC);
 	if (!ep) {
-		atomic_inc(&mp->stats.no_free_exch);
+		atomic_inc_wrap(&mp->stats.no_free_exch);
 		goto out;
 	}
 	memset(ep, 0, sizeof(*ep));
@@ -872,7 +872,7 @@ static struct fc_exch *fc_exch_em_alloc(struct fc_lport *lport,
 	return ep;
 err:
 	spin_unlock_bh(&pool->lock);
-	atomic_inc(&mp->stats.no_free_exch_xid);
+	atomic_inc_wrap(&mp->stats.no_free_exch_xid);
 	mempool_free(ep, mp->ep_pool);
 	return NULL;
 }
@@ -1029,7 +1029,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		xid = ntohs(fh->fh_ox_id);	/* we originated exch */
 		ep = fc_exch_find(mp, xid);
 		if (!ep) {
-			atomic_inc(&mp->stats.xid_not_found);
+			atomic_inc_wrap(&mp->stats.xid_not_found);
 			reject = FC_RJT_OX_ID;
 			goto out;
 		}
@@ -1059,7 +1059,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 		ep = fc_exch_find(mp, xid);
 		if ((f_ctl & FC_FC_FIRST_SEQ) && fc_sof_is_init(fr_sof(fp))) {
 			if (ep) {
-				atomic_inc(&mp->stats.xid_busy);
+				atomic_inc_wrap(&mp->stats.xid_busy);
 				reject = FC_RJT_RX_ID;
 				goto rel;
 			}
@@ -1070,7 +1070,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 			}
 			xid = ep->xid;	/* get our XID */
 		} else if (!ep) {
-			atomic_inc(&mp->stats.xid_not_found);
+			atomic_inc_wrap(&mp->stats.xid_not_found);
 			reject = FC_RJT_RX_ID;	/* XID not found */
 			goto out;
 		}
@@ -1088,7 +1088,7 @@ static enum fc_pf_rjt_reason fc_seq_lookup_recip(struct fc_lport *lport,
 	} else {
 		sp = &ep->seq;
 		if (sp->id != fh->fh_seq_id) {
-			atomic_inc(&mp->stats.seq_not_found);
+			atomic_inc_wrap(&mp->stats.seq_not_found);
 			if (f_ctl & FC_FC_END_SEQ) {
 				/*
 				 * Update sequence_id based on incoming last
@@ -1539,22 +1539,22 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 
 	ep = fc_exch_find(mp, ntohs(fh->fh_ox_id));
 	if (!ep) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_wrap(&mp->stats.xid_not_found);
 		goto out;
 	}
 	if (ep->esb_stat & ESB_ST_COMPLETE) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_wrap(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	if (ep->rxid == FC_XID_UNKNOWN)
 		ep->rxid = ntohs(fh->fh_rx_id);
 	if (ep->sid != 0 && ep->sid != ntoh24(fh->fh_d_id)) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_wrap(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	if (ep->did != ntoh24(fh->fh_s_id) &&
 	    ep->did != FC_FID_FLOGI) {
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_wrap(&mp->stats.xid_not_found);
 		goto rel;
 	}
 	sof = fr_sof(fp);
@@ -1563,7 +1563,7 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 		sp->ssb_stat |= SSB_ST_RESP;
 		sp->id = fh->fh_seq_id;
 	} else if (sp->id != fh->fh_seq_id) {
-		atomic_inc(&mp->stats.seq_not_found);
+		atomic_inc_wrap(&mp->stats.seq_not_found);
 		goto rel;
 	}
 
@@ -1626,9 +1626,9 @@ static void fc_exch_recv_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	sp = fc_seq_lookup_orig(mp, fp);	/* doesn't hold sequence */
 
 	if (!sp)
-		atomic_inc(&mp->stats.xid_not_found);
+		atomic_inc_wrap(&mp->stats.xid_not_found);
 	else
-		atomic_inc(&mp->stats.non_bls_resp);
+		atomic_inc_wrap(&mp->stats.non_bls_resp);
 
 	fc_frame_free(fp);
 }
@@ -2268,13 +2268,17 @@ void fc_exch_update_stats(struct fc_lport *lport)
 
 	list_for_each_entry(ema, &lport->ema_list, ema_list) {
 		mp = ema->mp;
-		st->fc_no_free_exch += atomic_read(&mp->stats.no_free_exch);
+		st->fc_no_free_exch +=
+				atomic_read_wrap(&mp->stats.no_free_exch);
 		st->fc_no_free_exch_xid +=
-				atomic_read(&mp->stats.no_free_exch_xid);
-		st->fc_xid_not_found += atomic_read(&mp->stats.xid_not_found);
-		st->fc_xid_busy += atomic_read(&mp->stats.xid_busy);
-		st->fc_seq_not_found += atomic_read(&mp->stats.seq_not_found);
-		st->fc_non_bls_resp += atomic_read(&mp->stats.non_bls_resp);
+				atomic_read_wrap(&mp->stats.no_free_exch_xid);
+		st->fc_xid_not_found +=
+				atomic_read_wrap(&mp->stats.xid_not_found);
+		st->fc_xid_busy += atomic_read_wrap(&mp->stats.xid_busy);
+		st->fc_seq_not_found +=
+				atomic_read_wrap(&mp->stats.seq_not_found);
+		st->fc_non_bls_resp +=
+				atomic_read_wrap(&mp->stats.non_bls_resp);
 	}
 }
 EXPORT_SYMBOL(fc_exch_update_stats);
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index b484859..efce99f 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -430,7 +430,7 @@ struct lpfc_vport {
 	struct dentry *debug_nodelist;
 	struct dentry *vport_debugfs_root;
 	struct lpfc_debugfs_trc *disc_trc;
-	atomic_t disc_trc_cnt;
+	atomic_wrap_t disc_trc_cnt;
 #endif
 	uint8_t stat_data_enabled;
 	uint8_t stat_data_blocked;
@@ -898,8 +898,8 @@ struct lpfc_hba {
 	struct timer_list fabric_block_timer;
 	unsigned long bit_flags;
 #define	FABRIC_COMANDS_BLOCKED	0
-	atomic_t num_rsrc_err;
-	atomic_t num_cmd_success;
+	atomic_wrap_t num_rsrc_err;
+	atomic_wrap_t num_cmd_success;
 	unsigned long last_rsrc_error_time;
 	unsigned long last_ramp_down_time;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
@@ -934,7 +934,7 @@ struct lpfc_hba {
 
 	struct dentry *debug_slow_ring_trc;
 	struct lpfc_debugfs_trc *slow_ring_trc;
-	atomic_t slow_ring_trc_cnt;
+	atomic_wrap_t slow_ring_trc_cnt;
 	/* iDiag debugfs sub-directory */
 	struct dentry *idiag_root;
 	struct dentry *idiag_pci_cfg;
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index a63542b..1059d95 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -106,7 +106,7 @@ MODULE_PARM_DESC(lpfc_debugfs_mask_disc_trc,
 
 #include <linux/debugfs.h>
 
-static atomic_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
+static atomic_wrap_t lpfc_debugfs_seq_trc_cnt = ATOMIC_INIT(0);
 static unsigned long lpfc_debugfs_start_time = 0L;
 
 /* iDiag */
@@ -147,7 +147,7 @@ lpfc_debugfs_disc_trc_data(struct lpfc_vport *vport, char *buf, int size)
 	lpfc_debugfs_enable = 0;
 
 	len = 0;
-	index = (atomic_read(&vport->disc_trc_cnt) + 1) &
+	index = (atomic_read_wrap(&vport->disc_trc_cnt) + 1) &
 		(lpfc_debugfs_max_disc_trc - 1);
 	for (i = index; i < lpfc_debugfs_max_disc_trc; i++) {
 		dtp = vport->disc_trc + i;
@@ -213,7 +213,7 @@ lpfc_debugfs_slow_ring_trc_data(struct lpfc_hba *phba, char *buf, int size)
 	lpfc_debugfs_enable = 0;
 
 	len = 0;
-	index = (atomic_read(&phba->slow_ring_trc_cnt) + 1) &
+	index = (atomic_read_wrap(&phba->slow_ring_trc_cnt) + 1) &
 		(lpfc_debugfs_max_slow_ring_trc - 1);
 	for (i = index; i < lpfc_debugfs_max_slow_ring_trc; i++) {
 		dtp = phba->slow_ring_trc + i;
@@ -646,14 +646,14 @@ lpfc_debugfs_disc_trc(struct lpfc_vport *vport, int mask, char *fmt,
 		!vport || !vport->disc_trc)
 		return;
 
-	index = atomic_inc_return(&vport->disc_trc_cnt) &
+	index = atomic_inc_return_wrap(&vport->disc_trc_cnt) &
 		(lpfc_debugfs_max_disc_trc - 1);
 	dtp = vport->disc_trc + index;
 	dtp->fmt = fmt;
 	dtp->data1 = data1;
 	dtp->data2 = data2;
 	dtp->data3 = data3;
-	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
+	dtp->seq_cnt = atomic_inc_return_wrap(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
 	return;
@@ -684,14 +684,14 @@ lpfc_debugfs_slow_ring_trc(struct lpfc_hba *phba, char *fmt,
 		!phba || !phba->slow_ring_trc)
 		return;
 
-	index = atomic_inc_return(&phba->slow_ring_trc_cnt) &
+	index = atomic_inc_return_wrap(&phba->slow_ring_trc_cnt) &
 		(lpfc_debugfs_max_slow_ring_trc - 1);
 	dtp = phba->slow_ring_trc + index;
 	dtp->fmt = fmt;
 	dtp->data1 = data1;
 	dtp->data2 = data2;
 	dtp->data3 = data3;
-	dtp->seq_cnt = atomic_inc_return(&lpfc_debugfs_seq_trc_cnt);
+	dtp->seq_cnt = atomic_inc_return_wrap(&lpfc_debugfs_seq_trc_cnt);
 	dtp->jif = jiffies;
 #endif
 	return;
@@ -4268,7 +4268,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 						 "slow_ring buffer\n");
 				goto debug_failed;
 			}
-			atomic_set(&phba->slow_ring_trc_cnt, 0);
+			atomic_set_wrap(&phba->slow_ring_trc_cnt, 0);
 			memset(phba->slow_ring_trc, 0,
 				(sizeof(struct lpfc_debugfs_trc) *
 				lpfc_debugfs_max_slow_ring_trc));
@@ -4314,7 +4314,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				 "buffer\n");
 		goto debug_failed;
 	}
-	atomic_set(&vport->disc_trc_cnt, 0);
+	atomic_set_wrap(&vport->disc_trc_cnt, 0);
 
 	snprintf(name, sizeof(name), "discovery_trace");
 	vport->debug_disc_trc =
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d197aa1..2fb02ef 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -261,7 +261,7 @@ lpfc_rampdown_queue_depth(struct lpfc_hba *phba)
 	unsigned long expires;
 
 	spin_lock_irqsave(&phba->hbalock, flags);
-	atomic_inc(&phba->num_rsrc_err);
+	atomic_inc_wrap(&phba->num_rsrc_err);
 	phba->last_rsrc_error_time = jiffies;
 
 	expires = phba->last_ramp_down_time + QUEUE_RAMP_DOWN_INTERVAL;
@@ -303,8 +303,8 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 	unsigned long num_rsrc_err, num_cmd_success;
 	int i;
 
-	num_rsrc_err = atomic_read(&phba->num_rsrc_err);
-	num_cmd_success = atomic_read(&phba->num_cmd_success);
+	num_rsrc_err = atomic_read_wrap(&phba->num_rsrc_err);
+	num_cmd_success = atomic_read_wrap(&phba->num_cmd_success);
 
 	/*
 	 * The error and success command counters are global per
@@ -331,8 +331,8 @@ lpfc_ramp_down_queue_handler(struct lpfc_hba *phba)
 			}
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
-	atomic_set(&phba->num_rsrc_err, 0);
-	atomic_set(&phba->num_cmd_success, 0);
+	atomic_set_wrap(&phba->num_rsrc_err, 0);
+	atomic_set_wrap(&phba->num_cmd_success, 0);
 }
 
 /**
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 68a5c34..265a755 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -201,8 +201,8 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
 		res->scsi_dev = scsi_dev;
 		scsi_dev->hostdata = res;
 		res->change_detected = 0;
-		atomic_set(&res->read_failures, 0);
-		atomic_set(&res->write_failures, 0);
+		atomic_set_wrap(&res->read_failures, 0);
+		atomic_set_wrap(&res->write_failures, 0);
 		rc = 0;
 	}
 	spin_unlock_irqrestore(&pinstance->resource_lock, lock_flags);
@@ -2641,9 +2641,9 @@ static int pmcraid_error_handler(struct pmcraid_cmd *cmd)
 
 	/* If this was a SCSI read/write command keep count of errors */
 	if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_READ_CMD)
-		atomic_inc(&res->read_failures);
+		atomic_inc_wrap(&res->read_failures);
 	else if (SCSI_CMD_TYPE(scsi_cmd->cmnd[0]) == SCSI_WRITE_CMD)
-		atomic_inc(&res->write_failures);
+		atomic_inc_wrap(&res->write_failures);
 
 	if (!RES_IS_GSCSI(res->cfg_entry) &&
 		masked_ioasc != PMCRAID_IOASC_HW_DEVICE_BUS_STATUS_ERROR) {
@@ -3469,8 +3469,8 @@ static int pmcraid_queuecommand_lck(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
-			  pinstance->num_hrrq;
+	ioarcb->hrrq_id = atomic_add_return_wrap(1,
+			  &(pinstance->last_message_id)) % pinstance->num_hrrq;
 	cmd->cmd_done = pmcraid_io_done;
 
 	if (RES_IS_GSCSI(res->cfg_entry) || RES_IS_VSET(res->cfg_entry)) {
@@ -3783,8 +3783,8 @@ static long pmcraid_ioctl_passthrough(
 	 * block of scsi_cmd which is re-used (e.g. cancel/abort), which uses
 	 * hrrq_id assigned here in queuecommand
 	 */
-	ioarcb->hrrq_id = atomic_add_return(1, &(pinstance->last_message_id)) %
-			  pinstance->num_hrrq;
+	ioarcb->hrrq_id = atomic_add_return_wrap(1,
+			  &(pinstance->last_message_id)) % pinstance->num_hrrq;
 
 	if (request_size) {
 		rc = pmcraid_build_passthrough_ioadls(cmd,
@@ -4420,7 +4420,7 @@ static void pmcraid_worker_function(struct work_struct *workp)
 
 	pinstance = container_of(workp, struct pmcraid_instance, worker_q);
 	/* add resources only after host is added into system */
-	if (!atomic_read(&pinstance->expose_resources))
+	if (!atomic_read_wrap(&pinstance->expose_resources))
 		return;
 
 	fw_version = be16_to_cpu(pinstance->inq_data->fw_version);
@@ -5237,8 +5237,8 @@ static int pmcraid_init_instance(struct pci_dev *pdev, struct Scsi_Host *host,
 	init_waitqueue_head(&pinstance->reset_wait_q);
 
 	atomic_set(&pinstance->outstanding_cmds, 0);
-	atomic_set(&pinstance->last_message_id, 0);
-	atomic_set(&pinstance->expose_resources, 0);
+	atomic_set_wrap(&pinstance->last_message_id, 0);
+	atomic_set_wrap(&pinstance->expose_resources, 0);
 
 	INIT_LIST_HEAD(&pinstance->free_res_q);
 	INIT_LIST_HEAD(&pinstance->used_res_q);
@@ -5949,7 +5949,7 @@ static int pmcraid_probe(struct pci_dev *pdev,
 	/* Schedule worker thread to handle CCN and take care of adding and
 	 * removing devices to OS
 	 */
-	atomic_set(&pinstance->expose_resources, 1);
+	atomic_set_wrap(&pinstance->expose_resources, 1);
 	schedule_work(&pinstance->worker_q);
 	return rc;
 
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index e1d150f..68e28d2 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -748,7 +748,7 @@ struct pmcraid_instance {
 	struct pmcraid_isr_param hrrq_vector[PMCRAID_NUM_MSIX_VECTORS];
 
 	/* Message id as filled in last fired IOARCB, used to identify HRRQ */
-	atomic_t last_message_id;
+	atomic_wrap_t last_message_id;
 
 	/* configuration table */
 	struct pmcraid_config_table *cfg_table;
@@ -777,7 +777,7 @@ struct pmcraid_instance {
 	atomic_t outstanding_cmds;
 
 	/* should add/delete resources to mid-layer now ?*/
-	atomic_t expose_resources;
+	atomic_wrap_t expose_resources;
 
 
 
@@ -813,8 +813,8 @@ struct pmcraid_resource_entry {
 		struct pmcraid_config_table_entry_ext cfg_entry_ext;
 	};
 	struct scsi_device *scsi_dev;	/* Link scsi_device structure */
-	atomic_t read_failures;		/* count of failed READ commands */
-	atomic_t write_failures;	/* count of failed WRITE commands */
+	atomic_wrap_t read_failures;	/* count of failed READ commands */
+	atomic_wrap_t write_failures;	/* count of failed WRITE commands */
 
 	/* To indicate add/delete/modify during CCN */
 	u8 change_detected;
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index a7cfc27..92998fc 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -306,7 +306,8 @@ struct ddb_entry {
 					   * (4000 only) */
 	atomic_t relogin_timer;		  /* Max Time to wait for
 					   * relogin to complete */
-	atomic_t relogin_retry_count;	  /* Num of times relogin has been
+	atomic_wrap_t relogin_retry_count;
+					  /* Num of times relogin has been
 					   * retried */
 	uint32_t default_time2wait;	  /* Default Min time between
 					   * relogins (+aens) */
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 01c3610..df2ec0e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4490,12 +4490,13 @@ static void qla4xxx_check_relogin_flash_ddb(struct iscsi_cls_session *cls_sess)
 		 */
 		if (!iscsi_is_session_online(cls_sess)) {
 			/* Reset retry relogin timer */
-			atomic_inc(&ddb_entry->relogin_retry_count);
+			atomic_inc_wrap(&ddb_entry->relogin_retry_count);
 			DEBUG2(ql4_printk(KERN_INFO, ha,
 				"%s: index[%d] relogin timed out-retrying"
 				" relogin (%d), retry (%d)\n", __func__,
 				ddb_entry->fw_ddb_index,
-				atomic_read(&ddb_entry->relogin_retry_count),
+				atomic_read_wrap(&ddb_entry->
+						 relogin_retry_count),
 				ddb_entry->default_time2wait + 4));
 			set_bit(DPC_RELOGIN_DEVICE, &ha->dpc_flags);
 			atomic_set(&ddb_entry->retry_relogin_timer,
@@ -6603,7 +6604,7 @@ static void qla4xxx_setup_flash_ddb_entry(struct scsi_qla_host *ha,
 
 	atomic_set(&ddb_entry->retry_relogin_timer, INVALID_ENTRY);
 	atomic_set(&ddb_entry->relogin_timer, 0);
-	atomic_set(&ddb_entry->relogin_retry_count, 0);
+	atomic_set_wrap(&ddb_entry->relogin_retry_count, 0);
 	def_timeout = le16_to_cpu(ddb_entry->fw_ddb_entry.def_timeout);
 	ddb_entry->default_relogin_timeout =
 		(def_timeout > LOGIN_TOV) && (def_timeout < LOGIN_TOV * 10) ?
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 2cca9cf..da9fd24 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1513,7 +1513,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
-	atomic_inc(&cmd->device->iorequest_cnt);
+	atomic_inc_wrap(&cmd->device->iorequest_cnt);
 
 	/*
 	 * SCSI request completion path will do scsi_device_unbusy(),
@@ -1536,9 +1536,9 @@ static void scsi_softirq_done(struct request *rq)
 
 	INIT_LIST_HEAD(&cmd->eh_entry);
 
-	atomic_inc(&cmd->device->iodone_cnt);
+	atomic_inc_wrap(&cmd->device->iodone_cnt);
 	if (cmd->result)
-		atomic_inc(&cmd->device->ioerr_cnt);
+		atomic_inc_wrap(&cmd->device->ioerr_cnt);
 
 	disposition = scsi_decide_disposition(cmd);
 	if (disposition != SUCCESS &&
@@ -1579,7 +1579,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host = cmd->device->host;
 	int rtn = 0;
 
-	atomic_inc(&cmd->device->iorequest_cnt);
+	atomic_inc_wrap(&cmd->device->iorequest_cnt);
 
 	/* check if the device is still usable */
 	if (unlikely(cmd->device->sdev_state == SDEV_DEL)) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..92710f3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -848,7 +848,7 @@ show_iostat_##field(struct device *dev, struct device_attribute *attr,	\
 		    char *buf)						\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	unsigned long long count = atomic_read(&sdev->field);		\
+	unsigned long long count = atomic_read_wrap(&sdev->field);	\
 	return snprintf(buf, 20, "0x%llx\n", count);			\
 }									\
 static DEVICE_ATTR(field, S_IRUGO, show_iostat_##field, NULL)
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 0f3a386..c571cfa 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -502,7 +502,7 @@ static DECLARE_TRANSPORT_CLASS(fc_vport_class,
  * Netlink Infrastructure
  */
 
-static atomic_t fc_event_seq;
+static atomic_wrap_t fc_event_seq;
 
 /**
  * fc_get_event_number - Obtain the next sequential FC event number
@@ -515,7 +515,7 @@ static atomic_t fc_event_seq;
 u32
 fc_get_event_number(void)
 {
-	return atomic_add_return(1, &fc_event_seq);
+	return atomic_add_return_wrap(1, &fc_event_seq);
 }
 EXPORT_SYMBOL(fc_get_event_number);
 
@@ -659,7 +659,7 @@ static __init int fc_transport_init(void)
 {
 	int error;
 
-	atomic_set(&fc_event_seq, 0);
+	atomic_set_wrap(&fc_event_seq, 0);
 
 	error = transport_class_register(&fc_host_class);
 	if (error)
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 42bca61..fda2eb6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -79,7 +79,8 @@ struct iscsi_internal {
 	struct transport_container session_cont;
 };
 
-static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
+static atomic_wrap_t iscsi_session_nr;
+		/* sysfs session id for next new session */
 static struct workqueue_struct *iscsi_eh_timer_workq;
 
 static DEFINE_IDA(iscsi_sess_ida);
@@ -2073,7 +2074,7 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 	int id = 0;
 	int err;
 
-	session->sid = atomic_add_return(1, &iscsi_session_nr);
+	session->sid = atomic_add_return_wrap(1, &iscsi_session_nr);
 
 	if (target_id == ISCSI_MAX_TARGET) {
 		id = ida_simple_get(&iscsi_sess_ida, 0, 0, GFP_KERNEL);
@@ -4523,7 +4524,7 @@ static __init int iscsi_transport_init(void)
 	printk(KERN_INFO "Loading iSCSI transport class v%s.\n",
 		ISCSI_TRANSPORT_VERSION);
 
-	atomic_set(&iscsi_session_nr, 0);
+	atomic_set_wrap(&iscsi_session_nr, 0);
 
 	err = class_register(&iscsi_transport_class);
 	if (err)
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..f6ec5f9 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -35,7 +35,7 @@
 #include "scsi_priv.h"
 
 struct srp_host_attrs {
-	atomic_t next_port_id;
+	atomic_wrap_t next_port_id;
 };
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
@@ -105,7 +105,7 @@ static int srp_host_setup(struct transport_container *tc, struct device *dev,
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct srp_host_attrs *srp_host = to_srp_host_attrs(shost);
 
-	atomic_set(&srp_host->next_port_id, 0);
+	atomic_set_wrap(&srp_host->next_port_id, 0);
 	return 0;
 }
 
@@ -752,7 +752,7 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 			  rport_fast_io_fail_timedout);
 	INIT_DELAYED_WORK(&rport->dev_loss_work, rport_dev_loss_timedout);
 
-	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
+	id = atomic_inc_return_wrap(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
 	transport_setup_device(&rport->dev);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 51e5629..ad79801 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3081,7 +3081,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	atomic_set(&sdkp->openers, 0);
-	atomic_set(&sdkp->device->ioerr_cnt, 0);
+	atomic_set_wrap(&sdkp->device->ioerr_cnt, 0);
 
 	if (!sdp->request_queue->rq_timeout) {
 		if (sdp->type != TYPE_MOD)
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 58bb6ed..3e0a1ee 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -56,7 +56,7 @@ static const u32 sbp_unit_directory_template[] = {
 
 #define SESSION_MAINTENANCE_INTERVAL HZ
 
-static atomic_t login_id = ATOMIC_INIT(0);
+static atomic_wrap_t login_id = ATOMIC_INIT(0);
 
 static void session_maintenance_work(struct work_struct *);
 static int sbp_run_transaction(struct fw_card *, int, int, int, int,
@@ -422,7 +422,7 @@ static void sbp_management_request_login(
 	login->login_lun = unpacked_lun;
 	login->status_fifo_addr = sbp2_pointer_to_addr(&req->orb.status_fifo);
 	login->exclusive = LOGIN_ORB_EXCLUSIVE(be32_to_cpu(req->orb.misc));
-	login->login_id = atomic_inc_return(&login_id);
+	login->login_id = atomic_inc_return_wrap(&login_id);
 
 	login->tgt_agt = sbp_target_agent_register(login);
 	if (IS_ERR(login->tgt_agt)) {
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index 96ce6bd..c05b32e 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -85,7 +85,7 @@ struct hvsi_struct {
 	int n_outbuf;
 	uint32_t vtermno;
 	uint32_t virq;
-	atomic_t seqno; /* HVSI packet sequence number */
+	atomic_wrap_t seqno; /* HVSI packet sequence number */
 	uint16_t mctrl;
 	uint8_t state;  /* HVSI protocol state */
 	uint8_t flags;
@@ -297,7 +297,7 @@ static int hvsi_version_respond(struct hvsi_struct *hp, uint16_t query_seqno)
 
 	packet.hdr.type = VS_QUERY_RESPONSE_PACKET_HEADER;
 	packet.hdr.len = sizeof(struct hvsi_query_response);
-	packet.hdr.seqno = cpu_to_be16(atomic_inc_return(&hp->seqno));
+	packet.hdr.seqno = cpu_to_be16(atomic_inc_return_wrap(&hp->seqno));
 	packet.verb = cpu_to_be16(VSV_SEND_VERSION_NUMBER);
 	packet.u.version = HVSI_VERSION;
 	packet.query_seqno = cpu_to_be16(query_seqno+1);
@@ -557,7 +557,7 @@ static int hvsi_query(struct hvsi_struct *hp, uint16_t verb)
 
 	packet.hdr.type = VS_QUERY_PACKET_HEADER;
 	packet.hdr.len = sizeof(struct hvsi_query);
-	packet.hdr.seqno = cpu_to_be16(atomic_inc_return(&hp->seqno));
+	packet.hdr.seqno = cpu_to_be16(atomic_inc_return_wrap(&hp->seqno));
 	packet.verb = cpu_to_be16(verb);
 
 	pr_debug("%s: sending %i bytes\n", __func__, packet.hdr.len);
@@ -599,7 +599,7 @@ static int hvsi_set_mctrl(struct hvsi_struct *hp, uint16_t mctrl)
 	int wrote;
 
 	packet.hdr.type = VS_CONTROL_PACKET_HEADER;
-	packet.hdr.seqno = cpu_to_be16(atomic_inc_return(&hp->seqno));
+	packet.hdr.seqno = cpu_to_be16(atomic_inc_return_wrap(&hp->seqno));
 	packet.hdr.len = sizeof(struct hvsi_control);
 	packet.verb = cpu_to_be16(VSV_SET_MODEM_CTL);
 	packet.mask = cpu_to_be32(HVSI_TSDTR);
@@ -682,7 +682,7 @@ static int hvsi_put_chars(struct hvsi_struct *hp, const char *buf, int count)
 	BUG_ON(count > HVSI_MAX_OUTGOING_DATA);
 
 	packet.hdr.type = VS_DATA_PACKET_HEADER;
-	packet.hdr.seqno = cpu_to_be16(atomic_inc_return(&hp->seqno));
+	packet.hdr.seqno = cpu_to_be16(atomic_inc_return_wrap(&hp->seqno));
 	packet.hdr.len = count + sizeof(struct hvsi_header);
 	memcpy(&packet.data, buf, count);
 
@@ -699,7 +699,7 @@ static void hvsi_close_protocol(struct hvsi_struct *hp)
 	struct hvsi_control packet __ALIGNED__;
 
 	packet.hdr.type = VS_CONTROL_PACKET_HEADER;
-	packet.hdr.seqno = cpu_to_be16(atomic_inc_return(&hp->seqno));
+	packet.hdr.seqno = cpu_to_be16(atomic_inc_return_wrap(&hp->seqno));
 	packet.hdr.len = 6;
 	packet.verb = cpu_to_be16(VSV_CLOSE_PROTOCOL);
 
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index a270f04..ce9ceaf 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -8,7 +8,7 @@
 
 static int hvsi_send_packet(struct hvsi_priv *pv, struct hvsi_header *packet)
 {
-	packet->seqno = cpu_to_be16(atomic_inc_return(&pv->seqno));
+	packet->seqno = cpu_to_be16(atomic_inc_return_wrap(&pv->seqno));
 
 	/* Assumes that always succeeds, works in practice */
 	return pv->put_chars(pv->termno, (char *)packet, packet->len);
@@ -20,7 +20,7 @@ static void hvsi_start_handshake(struct hvsi_priv *pv)
 
 	/* Reset state */
 	pv->established = 0;
-	atomic_set(&pv->seqno, 0);
+	atomic_set_wrap(&pv->seqno, 0);
 
 	pr_devel("HVSI@%x: Handshaking started\n", pv->termno);
 
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index e5c42fe..edfed43 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -437,7 +437,7 @@ struct ioc4_soft {
 		} is_intr_info[MAX_IOC4_INTR_ENTS];
 
 		/* Number of entries active in the above array */
-		atomic_t is_num_intrs;
+		atomic_wrap_t is_num_intrs;
 	} is_intr_type[IOC4_NUM_INTR_TYPES];
 
 	/* is_ir_lock must be held while
@@ -974,7 +974,7 @@ intr_connect(struct ioc4_soft *soft, int type,
 	BUG_ON(!((type == IOC4_SIO_INTR_TYPE)
 	       || (type == IOC4_OTHER_INTR_TYPE)));
 
-	i = atomic_inc_return(&soft-> is_intr_type[type].is_num_intrs) - 1;
+	i = atomic_inc_return_wrap(&soft->is_intr_type[type].is_num_intrs) - 1;
 	BUG_ON(!(i < MAX_IOC4_INTR_ENTS || (printk("i %d\n", i), 0)));
 
 	/* Save off the lower level interrupt handler */
@@ -1001,7 +1001,7 @@ static irqreturn_t ioc4_intr(int irq, void *arg)
 
 	soft = arg;
 	for (intr_type = 0; intr_type < IOC4_NUM_INTR_TYPES; intr_type++) {
-		num_intrs = (int)atomic_read(
+		num_intrs = (int)atomic_read_wrap(
 				&soft->is_intr_type[intr_type].is_num_intrs);
 
 		this_mir = this_ir = pending_intrs(soft, intr_type);
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 7312e7e..dab67a7 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1726,7 +1726,7 @@ static struct uart_driver msm_uart_driver = {
 	.cons = MSM_CONSOLE,
 };
 
-static atomic_t msm_uart_next_id = ATOMIC_INIT(0);
+static atomic_wrap_t msm_uart_next_id = ATOMIC_INIT(0);
 
 static const struct of_device_id msm_uartdm_table[] = {
 	{ .compatible = "qcom,msm-uartdm-v1.1", .data = (void *)UARTDM_1P1 },
@@ -1750,7 +1750,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 		line = pdev->id;
 
 	if (line < 0)
-		line = atomic_inc_return(&msm_uart_next_id) - 1;
+		line = atomic_inc_return_wrap(&msm_uart_next_id) - 1;
 
 	if (unlikely(line < 0 || line >= UART_NR))
 		return -ENXIO;
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index fba021f..a5bed75 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -231,7 +231,8 @@ static ssize_t event_show(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
+	return sprintf(buf, "%u\n",
+			(unsigned int)atomic_read_wrap(&idev->event));
 }
 static DEVICE_ATTR_RO(event);
 
@@ -401,7 +402,7 @@ void uio_event_notify(struct uio_info *info)
 {
 	struct uio_device *idev = info->uio_dev;
 
-	atomic_inc(&idev->event);
+	atomic_inc_wrap(&idev->event);
 	wake_up_interruptible(&idev->wait);
 	kill_fasync(&idev->async_queue, SIGIO, POLL_IN);
 }
@@ -454,7 +455,7 @@ static int uio_open(struct inode *inode, struct file *filep)
 	}
 
 	listener->dev = idev;
-	listener->event_count = atomic_read(&idev->event);
+	listener->event_count = atomic_read_wrap(&idev->event);
 	filep->private_data = listener;
 
 	if (idev->info->open) {
@@ -505,7 +506,7 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
 		return -EIO;
 
 	poll_wait(filep, &idev->wait, wait);
-	if (listener->event_count != atomic_read(&idev->event))
+	if (listener->event_count != atomic_read_wrap(&idev->event))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
@@ -530,7 +531,7 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
 
-		event_count = atomic_read(&idev->event);
+		event_count = atomic_read_wrap(&idev->event);
 		if (event_count != listener->event_count) {
 			__set_current_state(TASK_RUNNING);
 			if (copy_to_user(buf, &event_count, count))
@@ -822,7 +823,7 @@ int __uio_register_device(struct module *owner,
 	idev->owner = owner;
 	idev->info = info;
 	init_waitqueue_head(&idev->wait);
-	atomic_set(&idev->event, 0);
+	atomic_set_wrap(&idev->event, 0);
 
 	ret = uio_get_minor(idev);
 	if (ret)
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index ef04b50..27b7a73 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -119,7 +119,7 @@ static const char format_endpt[] =
  * time it gets called.
  */
 static struct device_connect_event {
-	atomic_t count;
+	atomic_wrap_t count;
 	wait_queue_head_t wait;
 } device_event = {
 	.count = ATOMIC_INIT(1),
@@ -157,7 +157,7 @@ static const struct class_info clas_info[] = {
 
 void usbfs_conn_disc_event(void)
 {
-	atomic_add(2, &device_event.count);
+	atomic_add_wrap(2, &device_event.count);
 	wake_up(&device_event.wait);
 }
 
@@ -648,7 +648,7 @@ static unsigned int usb_device_poll(struct file *file,
 
 	poll_wait(file, &device_event.wait, wait);
 
-	event_count = atomic_read(&device_event.count);
+	event_count = atomic_read_wrap(&device_event.count);
 	if (file->f_version != event_count) {
 		file->f_version = event_count;
 		return POLLIN | POLLRDNORM;
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 479e223..b208757 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1631,7 +1631,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 	 */
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_wrap(&urb->dev->urbnum);
 	usbmon_urb_submit(&hcd->self, urb);
 
 	/* NOTE requirements on root-hub callers (usbfs and the hub
@@ -1658,7 +1658,7 @@ int usb_hcd_submit_urb (struct urb *urb, gfp_t mem_flags)
 		urb->hcpriv = NULL;
 		INIT_LIST_HEAD(&urb->urb_list);
 		atomic_dec(&urb->use_count);
-		atomic_dec(&urb->dev->urbnum);
+		atomic_dec_wrap(&urb->dev->urbnum);
 		if (atomic_read(&urb->reject))
 			wake_up(&usb_kill_urb_queue);
 		usb_put_urb(urb);
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index c953a0f..33ccc34 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -259,7 +259,7 @@ static ssize_t urbnum_show(struct device *dev, struct device_attribute *attr,
 	struct usb_device *udev;
 
 	udev = to_usb_device(dev);
-	return sprintf(buf, "%d\n", atomic_read(&udev->urbnum));
+	return sprintf(buf, "%d\n", atomic_read_wrap(&udev->urbnum));
 }
 static DEVICE_ATTR_RO(urbnum);
 
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 5921514..bebba54 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -455,7 +455,7 @@ struct usb_device *usb_alloc_dev(struct usb_device *parent,
 	set_dev_node(&dev->dev, dev_to_node(bus->controller));
 	dev->state = USB_STATE_ATTACHED;
 	dev->lpm_disable_count = 1;
-	atomic_set(&dev->urbnum, 0);
+	atomic_set_wrap(&dev->urbnum, 0);
 
 	INIT_LIST_HEAD(&dev->ep0.urb_list);
 	dev->ep0.desc.bLength = USB_DT_ENDPOINT_SIZE;
diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 74f62d6..8fb7d3d 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -777,7 +777,7 @@ static struct urb *request_single_step_set_feature_urb(
 	urb->transfer_flags = URB_DIR_IN;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_wrap(&urb->dev->urbnum);
 	urb->setup_dma = dma_map_single(
 			hcd->self.controller,
 			urb->setup_packet,
@@ -844,7 +844,7 @@ static int ehset_single_step_set_feature(struct usb_hcd *hcd, int port)
 	urb->status = -EINPROGRESS;
 	usb_get_urb(urb);
 	atomic_inc(&urb->use_count);
-	atomic_inc(&urb->dev->urbnum);
+	atomic_inc_wrap(&urb->dev->urbnum);
 	retval = submit_single_step_set_feature(hcd, urb, 0);
 	if (!retval && !wait_for_completion_timeout(&done,
 						msecs_to_jiffies(2000))) {
diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index da5ff40..d90cef2 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -84,7 +84,7 @@ struct appledisplay {
 	struct mutex sysfslock;		/* concurrent read and write */
 };
 
-static atomic_t count_displays = ATOMIC_INIT(0);
+static atomic_wrap_t count_displays = ATOMIC_INIT(0);
 
 static void appledisplay_complete(struct urb *urb)
 {
@@ -283,7 +283,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
-		atomic_inc_return(&count_displays) - 1);
+		atomic_inc_return_wrap(&count_displays) - 1);
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = 0xff;
diff --git a/drivers/usb/usbip/vhci.h b/drivers/usb/usbip/vhci.h
index 88b71c4..a54538c 100644
--- a/drivers/usb/usbip/vhci.h
+++ b/drivers/usb/usbip/vhci.h
@@ -96,7 +96,7 @@ struct vhci_hcd {
 	unsigned resuming:1;
 	unsigned long re_timeout;
 
-	atomic_t seqnum;
+	atomic_wrap_t seqnum;
 
 	/*
 	 * NOTE:
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 03eccf2..6f8e9a5 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -476,7 +476,7 @@ static void vhci_tx_urb(struct urb *urb)
 
 	spin_lock_irqsave(&vdev->priv_lock, flags);
 
-	priv->seqnum = atomic_inc_return(&vhci->seqnum);
+	priv->seqnum = atomic_inc_return_wrap(&vhci->seqnum);
 	if (priv->seqnum == 0xffff)
 		dev_info(&urb->dev->dev, "seqnum max\n");
 
@@ -730,7 +730,7 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 			return -ENOMEM;
 		}
 
-		unlink->seqnum = atomic_inc_return(&vhci->seqnum);
+		unlink->seqnum = atomic_inc_return_wrap(&vhci->seqnum);
 		if (unlink->seqnum == 0xffff)
 			pr_info("seqnum max\n");
 
@@ -956,7 +956,7 @@ static int vhci_start(struct usb_hcd *hcd)
 		vdev->rhport = rhport;
 	}
 
-	atomic_set(&vhci->seqnum, 0);
+	atomic_set_wrap(&vhci->seqnum, 0);
 	spin_lock_init(&vhci->lock);
 
 	hcd->power_budget = 0; /* no limit */
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index fc2d319..7e2c1cd 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -82,7 +82,7 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 	if (!urb) {
 		pr_err("cannot find a urb of seqnum %u\n", pdu->base.seqnum);
 		pr_info("max seqnum %d\n",
-			atomic_read(&vhci->seqnum));
+			atomic_read_wrap(&vhci->seqnum));
 		usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
 		return;
 	}
diff --git a/drivers/usb/wusbcore/wa-hc.h b/drivers/usb/wusbcore/wa-hc.h
index edc7267..7a0e889 100644
--- a/drivers/usb/wusbcore/wa-hc.h
+++ b/drivers/usb/wusbcore/wa-hc.h
@@ -240,7 +240,7 @@ struct wahc {
 	spinlock_t xfer_list_lock;
 	struct work_struct xfer_enqueue_work;
 	struct work_struct xfer_error_work;
-	atomic_t xfer_id_count;
+	atomic_wrap_t xfer_id_count;
 
 	kernel_ulong_t	quirks;
 };
@@ -305,7 +305,7 @@ static inline void wa_init(struct wahc *wa)
 	INIT_WORK(&wa->xfer_enqueue_work, wa_urb_enqueue_run);
 	INIT_WORK(&wa->xfer_error_work, wa_process_errored_transfers_run);
 	wa->dto_in_use = 0;
-	atomic_set(&wa->xfer_id_count, 1);
+	atomic_set_wrap(&wa->xfer_id_count, 1);
 	/* init the buf in URBs */
 	for (index = 0; index < WA_MAX_BUF_IN_URBS; ++index)
 		usb_init_urb(&(wa->buf_in_urbs[index]));
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 167fcc71..71cd4d0 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -314,7 +314,7 @@ static void wa_xfer_completion(struct wa_xfer *xfer)
  */
 static void wa_xfer_id_init(struct wa_xfer *xfer)
 {
-	xfer->id = atomic_add_return(1, &xfer->wa->xfer_id_count);
+	xfer->id = atomic_add_return_wrap(1, &xfer->wa->xfer_id_count);
 }
 
 /* Return the xfer's ID. */
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index 2fd49b2..56a347a 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -240,7 +240,7 @@ static uint screen_fb_size;
 static inline int synthvid_send(struct hv_device *hdev,
 				struct synthvid_msg *msg)
 {
-	static atomic64_t request_id = ATOMIC64_INIT(0);
+	static atomic64_wrap_t request_id = ATOMIC64_INIT(0);
 	int ret;
 
 	msg->pipe_hdr.type = PIPE_MSG_DATA;
@@ -248,7 +248,7 @@ static inline int synthvid_send(struct hv_device *hdev,
 
 	ret = vmbus_sendpacket(hdev->channel, msg,
 			       msg->vid_hdr.size + sizeof(struct pipe_msg_hdr),
-			       atomic64_inc_return(&request_id),
+			       atomic64_inc_return_wrap(&request_id),
 			       VM_PKT_DATA_INBAND, 0);
 
 	if (ret)
diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index e9c2f7b..205d362 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -623,11 +623,11 @@ static int dlfb_handle_damage(struct dlfb_data *dev, int x, int y,
 		dlfb_urb_completion(urb);
 
 error:
-	atomic_add(bytes_sent, &dev->bytes_sent);
-	atomic_add(bytes_identical, &dev->bytes_identical);
-	atomic_add(width*height*2, &dev->bytes_rendered);
+	atomic_add_wrap(bytes_sent, &dev->bytes_sent);
+	atomic_add_wrap(bytes_identical, &dev->bytes_identical);
+	atomic_add_wrap(width*height*2, &dev->bytes_rendered);
 	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
+	atomic_add_wrap(((unsigned int) ((end_cycles - start_cycles)
 		    >> 10)), /* Kcycles */
 		   &dev->cpu_kcycles_used);
 
@@ -748,11 +748,11 @@ static void dlfb_dpy_deferred_io(struct fb_info *info,
 		dlfb_urb_completion(urb);
 
 error:
-	atomic_add(bytes_sent, &dev->bytes_sent);
-	atomic_add(bytes_identical, &dev->bytes_identical);
-	atomic_add(bytes_rendered, &dev->bytes_rendered);
+	atomic_add_wrap(bytes_sent, &dev->bytes_sent);
+	atomic_add_wrap(bytes_identical, &dev->bytes_identical);
+	atomic_add_wrap(bytes_rendered, &dev->bytes_rendered);
 	end_cycles = get_cycles();
-	atomic_add(((unsigned int) ((end_cycles - start_cycles)
+	atomic_add_wrap(((unsigned int) ((end_cycles - start_cycles)
 		    >> 10)), /* Kcycles */
 		   &dev->cpu_kcycles_used);
 }
@@ -1373,7 +1373,7 @@ static ssize_t metrics_bytes_rendered_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_rendered));
+			atomic_read_wrap(&dev->bytes_rendered));
 }
 
 static ssize_t metrics_bytes_identical_show(struct device *fbdev,
@@ -1381,7 +1381,7 @@ static ssize_t metrics_bytes_identical_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_identical));
+			atomic_read_wrap(&dev->bytes_identical));
 }
 
 static ssize_t metrics_bytes_sent_show(struct device *fbdev,
@@ -1389,7 +1389,7 @@ static ssize_t metrics_bytes_sent_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->bytes_sent));
+			atomic_read_wrap(&dev->bytes_sent));
 }
 
 static ssize_t metrics_cpu_kcycles_used_show(struct device *fbdev,
@@ -1397,7 +1397,7 @@ static ssize_t metrics_cpu_kcycles_used_show(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 	return snprintf(buf, PAGE_SIZE, "%u\n",
-			atomic_read(&dev->cpu_kcycles_used));
+			atomic_read_wrap(&dev->cpu_kcycles_used));
 }
 
 static ssize_t edid_show(
@@ -1457,10 +1457,10 @@ static ssize_t metrics_reset_store(struct device *fbdev,
 	struct fb_info *fb_info = dev_get_drvdata(fbdev);
 	struct dlfb_data *dev = fb_info->par;
 
-	atomic_set(&dev->bytes_rendered, 0);
-	atomic_set(&dev->bytes_identical, 0);
-	atomic_set(&dev->bytes_sent, 0);
-	atomic_set(&dev->cpu_kcycles_used, 0);
+	atomic_set_wrap(&dev->bytes_rendered, 0);
+	atomic_set_wrap(&dev->bytes_identical, 0);
+	atomic_set_wrap(&dev->bytes_sent, 0);
+	atomic_set_wrap(&dev->cpu_kcycles_used, 0);
 
 	return count;
 }
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index b2a0f15..3a8b186 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -140,7 +140,7 @@ int oprofilefs_create_ro_ulong(struct dentry * root,
  
 /** Create a file for read-only access to an atomic_t. */
 int oprofilefs_create_ro_atomic(struct dentry * root,
-	char const * name, atomic_t * val);
+	char const *name, atomic_wrap_t *val);
  
 /** create a directory */
 struct dentry *oprofilefs_mkdir(struct dentry *parent, char const *name);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 32c0e83..210eb56 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -67,7 +67,7 @@ struct uio_device {
         struct module           *owner;
         struct device           *dev;
         int                     minor;
-        atomic_t                event;
+	atomic_wrap_t		event;
         struct fasync_struct    *async_queue;
         wait_queue_head_t       wait;
         struct uio_info         *info;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index eba1f10..164a40e 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -599,7 +599,7 @@ struct usb_device {
 	int maxchild;
 
 	u32 quirks;
-	atomic_t urbnum;
+	atomic_wrap_t urbnum;
 
 	unsigned long active_duration;
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8a95631..18dac0e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -193,9 +193,9 @@ struct scsi_device {
 	unsigned int max_device_blocked; /* what device_blocked counts down from  */
 #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
-	atomic_t iorequest_cnt;
-	atomic_t iodone_cnt;
-	atomic_t ioerr_cnt;
+	atomic_wrap_t iorequest_cnt;
+	atomic_wrap_t iodone_cnt;
+	atomic_wrap_t ioerr_cnt;
 
 	struct device		sdev_gendev,
 				sdev_dev;
diff --git a/include/video/udlfb.h b/include/video/udlfb.h
index f9466fa..c3eb166 100644
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -53,10 +53,14 @@ struct dlfb_data {
 	u32 pseudo_palette[256];
 	int blank_mode; /*one of FB_BLANK_ */
 	/* blit-only rendering path metrics, exposed through sysfs */
-	atomic_t bytes_rendered; /* raw pixel-bytes driver asked to render */
-	atomic_t bytes_identical; /* saved effort with backbuffer comparison */
-	atomic_t bytes_sent; /* to usb, after compression including overhead */
-	atomic_t cpu_kcycles_used; /* transpired during pixel processing */
+	atomic_wrap_t bytes_rendered;
+			/* raw pixel-bytes driver asked to render */
+	atomic_wrap_t bytes_identical;
+			/* saved effort with backbuffer comparison */
+	atomic_wrap_t bytes_sent;
+			/* to usb, after compression including overhead */
+	atomic_wrap_t cpu_kcycles_used;
+			/* transpired during pixel processing */
 };
 
 #define NR_USB_REQUEST_I2C_SUB_IO 0x02
-- 
2.7.4
