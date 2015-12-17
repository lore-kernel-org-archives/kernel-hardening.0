Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dave@progbits.org>
Date: Thu, 17 Dec 2015 09:57:46 -0500
Message-Id: <1450364270-12687-9-git-send-email-dave@progbits.org>
In-Reply-To: <1450364270-12687-1-git-send-email-dave@progbits.org>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
Subject: [kernel-hardening][RFC PATCH v2 08/12] drivers: opt out of PAX_REFCOUNT protection (1 of 2)
To: kernel-hardening@lists.openwall.com
Cc: David Windsor <dave@progbits.org>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: David Windsor <dave@progbits.org>
---
 drivers/acpi/apei/ghes.c                  |   4 +-
 drivers/ata/libata-core.c                 |   4 +-
 drivers/ata/libata-scsi.c                 |   2 +-
 drivers/ata/libata.h                      |   2 +-
 drivers/atm/adummy.c                      |   2 +-
 drivers/atm/ambassador.c                  |   8 +-
 drivers/atm/atmtcp.c                      |  14 +--
 drivers/atm/eni.c                         |  10 +-
 drivers/atm/firestream.c                  |   8 +-
 drivers/atm/fore200e.c                    |  14 +--
 drivers/atm/he.c                          |  18 ++--
 drivers/atm/horizon.c                     |   4 +-
 drivers/atm/idt77252.c                    |  36 +++----
 drivers/atm/iphase.c                      |  34 +++----
 drivers/atm/lanai.c                       |  12 +--
 drivers/atm/nicstar.c                     |  46 ++++-----
 drivers/atm/solos-pci.c                   |   4 +-
 drivers/atm/suni.c                        |   4 +-
 drivers/atm/uPD98402.c                    |  16 +--
 drivers/atm/zatm.c                        |   6 +-
 drivers/base/power/wakeup.c               |   8 +-
 drivers/block/drbd/drbd_bitmap.c          |   2 +-
 drivers/block/drbd/drbd_int.h             |   8 +-
 drivers/block/drbd/drbd_main.c            |  12 +--
 drivers/block/drbd/drbd_nl.c              |   4 +-
 drivers/block/drbd/drbd_receiver.c        |  30 +++---
 drivers/block/drbd/drbd_worker.c          |   8 +-
 drivers/char/ipmi/ipmi_msghandler.c       |   8 +-
 drivers/char/ipmi/ipmi_si_intf.c          |   8 +-
 drivers/crypto/hifn_795x.c                |   4 +-
 drivers/edac/edac_device.c                |   4 +-
 drivers/edac/edac_pci.c                   |   4 +-
 drivers/edac/edac_pci_sysfs.c             |  20 ++--
 drivers/firewire/core-card.c              |   4 +-
 drivers/firmware/efi/cper.c               |   8 +-
 drivers/gpio/gpio-vr41xx.c                |   2 +-
 drivers/gpu/drm/i810/i810_drv.h           |   4 +-
 drivers/gpu/drm/mga/mga_drv.h             |   4 +-
 drivers/gpu/drm/mga/mga_irq.c             |   8 +-
 drivers/gpu/drm/qxl/qxl_cmd.c             |  12 +--
 drivers/gpu/drm/qxl/qxl_debugfs.c         |   8 +-
 drivers/gpu/drm/qxl/qxl_drv.h             |   8 +-
 drivers/gpu/drm/qxl/qxl_irq.c             |  16 +--
 drivers/gpu/drm/r128/r128_cce.c           |   2 +-
 drivers/gpu/drm/r128/r128_drv.h           |   4 +-
 drivers/gpu/drm/r128/r128_irq.c           |   4 +-
 drivers/gpu/drm/r128/r128_state.c         |   4 +-
 drivers/gpu/drm/radeon/radeon_drv.h       |   2 +-
 drivers/gpu/drm/radeon/radeon_irq.c       |   6 +-
 drivers/gpu/drm/via/via_drv.h             |   4 +-
 drivers/gpu/drm/via/via_irq.c             |  18 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c      |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c       |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c    |   2 +-
 drivers/hid/hid-core.c                    |   4 +-
 drivers/hv/channel.c                      |   2 +-
 drivers/hv/hv_balloon.c                   |  18 ++--
 drivers/hv/hyperv_vmbus.h                 |   2 +-
 drivers/hwmon/sht15.c                     |  12 +--
 drivers/infiniband/core/cm.c              |  32 +++---
 drivers/infiniband/core/fmr_pool.c        |  20 ++--
 drivers/infiniband/hw/cxgb4/mem.c         |   4 +-
 drivers/infiniband/hw/ipath/ipath_rc.c    |   6 +-
 drivers/infiniband/hw/ipath/ipath_ruc.c   |   6 +-
 drivers/infiniband/hw/mlx4/mad.c          |   2 +-
 drivers/infiniband/hw/mlx4/mcg.c          |   2 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h      |   2 +-
 drivers/infiniband/hw/nes/nes.c           |   4 +-
 drivers/infiniband/hw/nes/nes.h           |  40 ++++----
 drivers/infiniband/hw/nes/nes_cm.c        |  62 ++++++------
 drivers/infiniband/hw/nes/nes_mgt.c       |   8 +-
 drivers/infiniband/hw/nes/nes_nic.c       |  40 ++++----
 drivers/infiniband/hw/nes/nes_verbs.c     |  10 +-
 drivers/input/gameport/gameport.c         |   4 +-
 drivers/input/input.c                     |   4 +-
 drivers/input/joystick/xpad.c             |   4 +-
 drivers/input/misc/ims-pcu.c              |   4 +-
 drivers/input/serio/serio.c               |   4 +-
 drivers/input/serio/serio_raw.c           |   4 +-
 drivers/isdn/capi/capi.c                  |  10 +-
 drivers/md/dm-raid1.c                     |  18 ++--
 drivers/md/dm-stripe.c                    |  10 +-
 drivers/md/dm.c                           |  16 +--
 drivers/md/md.c                           |  26 ++---
 drivers/md/md.h                           |   6 +-
 drivers/md/raid1.c                        |   4 +-
 drivers/md/raid10.c                       |  16 +--
 drivers/md/raid5.c                        |  10 +-
 drivers/media/pci/ivtv/ivtv-driver.c      |   2 +-
 drivers/media/pci/solo6x10/solo6x10-p2m.c |   2 +-
 drivers/media/pci/solo6x10/solo6x10.h     |   2 +-
 drivers/media/pci/tw68/tw68-core.c        |   2 +-
 drivers/media/radio/radio-maxiradio.c     |   2 +-
 drivers/media/radio/radio-shark.c         |   2 +-
 drivers/media/radio/radio-shark2.c        |   2 +-
 drivers/media/radio/radio-si476x.c        |   2 +-
 drivers/media/v4l2-core/v4l2-device.c     |   4 +-
 drivers/misc/lis3lv02d/lis3lv02d.c        |   8 +-
 drivers/misc/lis3lv02d/lis3lv02d.h        |   2 +-
 drivers/misc/sgi-gru/gruhandles.c         |   4 +-
 drivers/misc/sgi-gru/gruprocfs.c          |   8 +-
 drivers/misc/sgi-gru/grutables.h          | 158 +++++++++++++++---------------
 drivers/net/hyperv/hyperv_net.h           |   2 +-
 drivers/net/hyperv/rndis_filter.c         |   4 +-
 105 files changed, 561 insertions(+), 561 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 2bfd53c..391e9a4 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -478,7 +478,7 @@ static void __ghes_print_estatus(const char *pfx,
 				 const struct acpi_hest_generic *generic,
 				 const struct acpi_hest_generic_status *estatus)
 {
-	static atomic_t seqno;
+	static atomic_unchecked_t seqno;
 	unsigned int curr_seqno;
 	char pfx_seq[64];
 
@@ -489,7 +489,7 @@ static void __ghes_print_estatus(const char *pfx,
 		else
 			pfx = KERN_ERR;
 	}
-	curr_seqno = atomic_inc_return(&seqno);
+	curr_seqno = atomic_inc_return_unchecked(&seqno);
 	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}" HW_ERR, pfx, curr_seqno);
 	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
 	       pfx_seq, generic->header.source_id);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 790e0de..24718d0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -102,7 +102,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-atomic_t ata_print_id = ATOMIC_INIT(0);
+atomic_unchecked_t ata_print_id = ATOMIC_INIT(0);
 
 struct ata_force_param {
 	const char	*name;
@@ -6134,7 +6134,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
-		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
+		host->ports[i]->print_id = atomic_inc_return_unchecked(&ata_print_id);
 		host->ports[i]->local_port_no = i + 1;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 0d7f0da..bc20aa6 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4193,7 +4193,7 @@ int ata_sas_port_init(struct ata_port *ap)
 
 	if (rc)
 		return rc;
-	ap->print_id = atomic_inc_return(&ata_print_id);
+	ap->print_id = atomic_inc_return_unchecked(&ata_print_id);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_init);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index f840ca1..edd6ef3 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -53,7 +53,7 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
-extern atomic_t ata_print_id;
+extern atomic_unchecked_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/drivers/atm/adummy.c b/drivers/atm/adummy.c
index f9b983a..887b9d8 100644
--- a/drivers/atm/adummy.c
+++ b/drivers/atm/adummy.c
@@ -114,7 +114,7 @@ adummy_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		vcc->pop(vcc, skb);
 	else
 		dev_kfree_skb_any(skb);
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_unchecked(&vcc->stats->tx);
 
 	return 0;
 }
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index f1a9198..f466a4a 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -454,7 +454,7 @@ static void tx_complete (amb_dev * dev, tx_out * tx) {
   PRINTD (DBG_FLOW|DBG_TX, "tx_complete %p %p", dev, tx);
   
   // VC layer stats
-  atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+  atomic_inc_unchecked(&ATM_SKB(skb)->vcc->stats->tx);
   
   // free the descriptor
   kfree (tx_descr);
@@ -495,7 +495,7 @@ static void rx_complete (amb_dev * dev, rx_out * rx) {
 	  dump_skb ("<<<", vc, skb);
 	  
 	  // VC layer stats
-	  atomic_inc(&atm_vcc->stats->rx);
+	  atomic_inc_unchecked(&atm_vcc->stats->rx);
 	  __net_timestamp(skb);
 	  // end of our responsibility
 	  atm_vcc->push (atm_vcc, skb);
@@ -510,7 +510,7 @@ static void rx_complete (amb_dev * dev, rx_out * rx) {
       } else {
       	PRINTK (KERN_INFO, "dropped over-size frame");
 	// should we count this?
-	atomic_inc(&atm_vcc->stats->rx_drop);
+	atomic_inc_unchecked(&atm_vcc->stats->rx_drop);
       }
       
     } else {
@@ -1338,7 +1338,7 @@ static int amb_send (struct atm_vcc * atm_vcc, struct sk_buff * skb) {
   }
   
   if (check_area (skb->data, skb->len)) {
-    atomic_inc(&atm_vcc->stats->tx_err);
+    atomic_inc_unchecked(&atm_vcc->stats->tx_err);
     return -ENOMEM; // ?
   }
   
diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 480fa6f..947067c 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -206,7 +206,7 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb(skb);
 		if (dev_data) return 0;
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		return -ENOLINK;
 	}
 	size = skb->len+sizeof(struct atmtcp_hdr);
@@ -214,7 +214,7 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	if (!new_skb) {
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		return -ENOBUFS;
 	}
 	hdr = (void *) skb_put(new_skb,sizeof(struct atmtcp_hdr));
@@ -225,8 +225,8 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	if (vcc->pop) vcc->pop(vcc,skb);
 	else dev_kfree_skb(skb);
 	out_vcc->push(out_vcc,new_skb);
-	atomic_inc(&vcc->stats->tx);
-	atomic_inc(&out_vcc->stats->rx);
+	atomic_inc_unchecked(&vcc->stats->tx);
+	atomic_inc_unchecked(&out_vcc->stats->rx);
 	return 0;
 }
 
@@ -300,7 +300,7 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	read_unlock(&vcc_sklist_lock);
 	if (!out_vcc) {
 		result = -EUNATCH;
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		goto done;
 	}
 	skb_pull(skb,sizeof(struct atmtcp_hdr));
@@ -312,8 +312,8 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	__net_timestamp(new_skb);
 	skb_copy_from_linear_data(skb, skb_put(new_skb, skb->len), skb->len);
 	out_vcc->push(out_vcc,new_skb);
-	atomic_inc(&vcc->stats->tx);
-	atomic_inc(&out_vcc->stats->rx);
+	atomic_inc_unchecked(&vcc->stats->tx);
+	atomic_inc_unchecked(&out_vcc->stats->rx);
 done:
 	if (vcc->pop) vcc->pop(vcc,skb);
 	else dev_kfree_skb(skb);
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 6339efd..2b441d5 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -525,7 +525,7 @@ static int rx_aal0(struct atm_vcc *vcc)
 		DPRINTK(DEV_LABEL "(itf %d): trashing empty cell\n",
 		    vcc->dev->number);
 		length = 0;
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_unchecked(&vcc->stats->rx_err);
 	}
 	else {
 		length = ATM_CELL_SIZE-1; /* no HEC */
@@ -580,7 +580,7 @@ static int rx_aal5(struct atm_vcc *vcc)
 			    size);
 		}
 		eff = length = 0;
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_unchecked(&vcc->stats->rx_err);
 	}
 	else {
 		size = (descr & MID_RED_COUNT)*(ATM_CELL_PAYLOAD >> 2);
@@ -597,7 +597,7 @@ static int rx_aal5(struct atm_vcc *vcc)
 			    "(VCI=%d,length=%ld,size=%ld (descr 0x%lx))\n",
 			    vcc->dev->number,vcc->vci,length,size << 2,descr);
 			length = eff = 0;
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 		}
 	}
 	skb = eff ? atm_alloc_charge(vcc,eff << 2,GFP_ATOMIC) : NULL;
@@ -770,7 +770,7 @@ rx_dequeued++;
 			vcc->push(vcc,skb);
 			pushed++;
 		}
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 	}
 	wake_up(&eni_dev->rx_wait);
 }
@@ -1230,7 +1230,7 @@ static void dequeue_tx(struct atm_dev *dev)
 				 DMA_TO_DEVICE);
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb_irq(skb);
-		atomic_inc(&vcc->stats->tx);
+		atomic_inc_unchecked(&vcc->stats->tx);
 		wake_up(&eni_dev->tx_wait);
 dma_complete++;
 	}
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 82f2ae0..f205c02 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -749,7 +749,7 @@ static void process_txdone_queue (struct fs_dev *dev, struct queue *q)
 				}
 			}
 
-			atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+			atomic_inc_unchecked(&ATM_SKB(skb)->vcc->stats->tx);
 
 			fs_dprintk (FS_DEBUG_TXMEM, "i");
 			fs_dprintk (FS_DEBUG_ALLOC, "Free t-skb: %p\n", skb);
@@ -816,7 +816,7 @@ static void process_incoming (struct fs_dev *dev, struct queue *q)
 #endif
 				skb_put (skb, qe->p1 & 0xffff); 
 				ATM_SKB(skb)->vcc = atm_vcc;
-				atomic_inc(&atm_vcc->stats->rx);
+				atomic_inc_unchecked(&atm_vcc->stats->rx);
 				__net_timestamp(skb);
 				fs_dprintk (FS_DEBUG_ALLOC, "Free rec-skb: %p (pushed)\n", skb);
 				atm_vcc->push (atm_vcc, skb);
@@ -837,12 +837,12 @@ static void process_incoming (struct fs_dev *dev, struct queue *q)
 				kfree (pe);
 			}
 			if (atm_vcc)
-				atomic_inc(&atm_vcc->stats->rx_drop);
+				atomic_inc_unchecked(&atm_vcc->stats->rx_drop);
 			break;
 		case 0x1f: /*  Reassembly abort: no buffers. */
 			/* Silently increment error counter. */
 			if (atm_vcc)
-				atomic_inc(&atm_vcc->stats->rx_drop);
+				atomic_inc_unchecked(&atm_vcc->stats->rx_drop);
 			break;
 		default: /* Hmm. Haven't written the code to handle the others yet... -- REW */
 			printk (KERN_WARNING "Don't know what to do with RX status %x: %s.\n", 
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 75dde90..4309ead 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -932,9 +932,9 @@ fore200e_tx_irq(struct fore200e* fore200e)
 #endif
 		/* check error condition */
 		if (*entry->status & STATUS_ERROR)
-		    atomic_inc(&vcc->stats->tx_err);
+		    atomic_inc_unchecked(&vcc->stats->tx_err);
 		else
-		    atomic_inc(&vcc->stats->tx);
+		    atomic_inc_unchecked(&vcc->stats->tx);
 	    }
 	}
 
@@ -1083,7 +1083,7 @@ fore200e_push_rpd(struct fore200e* fore200e, struct atm_vcc* vcc, struct rpd* rp
     if (skb == NULL) {
 	DPRINTK(2, "unable to alloc new skb, rx PDU length = %d\n", pdu_len);
 
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_unchecked(&vcc->stats->rx_drop);
 	return -ENOMEM;
     } 
 
@@ -1126,14 +1126,14 @@ fore200e_push_rpd(struct fore200e* fore200e, struct atm_vcc* vcc, struct rpd* rp
 
 	dev_kfree_skb_any(skb);
 
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_unchecked(&vcc->stats->rx_drop);
 	return -ENOMEM;
     }
 
     ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
     vcc->push(vcc, skb);
-    atomic_inc(&vcc->stats->rx);
+    atomic_inc_unchecked(&vcc->stats->rx);
 
     ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
@@ -1211,7 +1211,7 @@ fore200e_rx_irq(struct fore200e* fore200e)
 		DPRINTK(2, "damaged PDU on %d.%d.%d\n",
 			fore200e->atm_dev->number,
 			entry->rpd->atm_header.vpi, entry->rpd->atm_header.vci);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_unchecked(&vcc->stats->rx_err);
 	    }
 	}
 
@@ -1656,7 +1656,7 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		goto retry_here;
 	    }
 
-	    atomic_inc(&vcc->stats->tx_err);
+	    atomic_inc_unchecked(&vcc->stats->tx_err);
 
 	    fore200e->tx_sat++;
 	    DPRINTK(2, "tx queue of device %s is saturated, PDU dropped - heartbeat is %08x\n",
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index a8da3a5..67cf6c2 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1692,7 +1692,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 
 		if (RBRQ_HBUF_ERR(he_dev->rbrq_head)) {
 			hprintk("HBUF_ERR!  (cid 0x%x)\n", cid);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_unchecked(&vcc->stats->rx_drop);
 			goto return_host_buffers;
 		}
 
@@ -1719,7 +1719,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 				RBRQ_LEN_ERR(he_dev->rbrq_head)
 							? "LEN_ERR" : "",
 							vcc->vpi, vcc->vci);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			goto return_host_buffers;
 		}
 
@@ -1771,7 +1771,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 		vcc->push(vcc, skb);
 		spin_lock(&he_dev->global_lock);
 
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 
 return_host_buffers:
 		++pdus_assembled;
@@ -2097,7 +2097,7 @@ __enqueue_tpd(struct he_dev *he_dev, struct he_tpd *tpd, unsigned cid)
 					tpd->vcc->pop(tpd->vcc, tpd->skb);
 				else
 					dev_kfree_skb_any(tpd->skb);
-				atomic_inc(&tpd->vcc->stats->tx_err);
+				atomic_inc_unchecked(&tpd->vcc->stats->tx_err);
 			}
 			dma_pool_free(he_dev->tpd_pool, tpd, TPD_ADDR(tpd->status));
 			return;
@@ -2509,7 +2509,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		return -EINVAL;
 	}
 
@@ -2520,7 +2520,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		return -EINVAL;
 	}
 #endif
@@ -2532,7 +2532,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		spin_unlock_irqrestore(&he_dev->global_lock, flags);
 		return -ENOMEM;
 	}
@@ -2574,7 +2574,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 					vcc->pop(vcc, skb);
 				else
 					dev_kfree_skb_any(skb);
-				atomic_inc(&vcc->stats->tx_err);
+				atomic_inc_unchecked(&vcc->stats->tx_err);
 				spin_unlock_irqrestore(&he_dev->global_lock, flags);
 				return -ENOMEM;
 			}
@@ -2605,7 +2605,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	__enqueue_tpd(he_dev, tpd, cid);
 	spin_unlock_irqrestore(&he_dev->global_lock, flags);
 
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_unchecked(&vcc->stats->tx);
 
 	return 0;
 }
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 527bbd5..96570c8 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1018,7 +1018,7 @@ static void rx_schedule (hrz_dev * dev, int irq) {
 	{
 	  struct atm_vcc * vcc = ATM_SKB(skb)->vcc;
 	  // VC layer stats
-	  atomic_inc(&vcc->stats->rx);
+	  atomic_inc_unchecked(&vcc->stats->rx);
 	  __net_timestamp(skb);
 	  // end of our responsibility
 	  vcc->push (vcc, skb);
@@ -1170,7 +1170,7 @@ static void tx_schedule (hrz_dev * const dev, int irq) {
 	dev->tx_iovec = NULL;
 	
 	// VC layer stats
-	atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+	atomic_inc_unchecked(&ATM_SKB(skb)->vcc->stats->tx);
 	
 	// free the skb
 	hrz_kfree_skb (skb);
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 074616b..d6b3d5f 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -811,7 +811,7 @@ drain_scq(struct idt77252_dev *card, struct vc_map *vc)
 		else
 			dev_kfree_skb(skb);
 
-		atomic_inc(&vcc->stats->tx);
+		atomic_inc_unchecked(&vcc->stats->tx);
 	}
 
 	atomic_dec(&scq->used);
@@ -1073,13 +1073,13 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			if ((sb = dev_alloc_skb(64)) == NULL) {
 				printk("%s: Can't allocate buffers for aal0.\n",
 				       card->name);
-				atomic_add(i, &vcc->stats->rx_drop);
+				atomic_add_unchecked(i, &vcc->stats->rx_drop);
 				break;
 			}
 			if (!atm_charge(vcc, sb->truesize)) {
 				RXPRINTK("%s: atm_charge() dropped aal0 packets.\n",
 					 card->name);
-				atomic_add(i - 1, &vcc->stats->rx_drop);
+				atomic_add_unchecked(i - 1, &vcc->stats->rx_drop);
 				dev_kfree_skb(sb);
 				break;
 			}
@@ -1096,7 +1096,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			ATM_SKB(sb)->vcc = vcc;
 			__net_timestamp(sb);
 			vcc->push(vcc, sb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_unchecked(&vcc->stats->rx);
 
 			cell += ATM_CELL_PAYLOAD;
 		}
@@ -1133,13 +1133,13 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			         "(CDC: %08x)\n",
 			         card->name, len, rpp->len, readl(SAR_REG_CDC));
 			recycle_rx_pool_skb(card, rpp);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			return;
 		}
 		if (stat & SAR_RSQE_CRC) {
 			RXPRINTK("%s: AAL5 CRC error.\n", card->name);
 			recycle_rx_pool_skb(card, rpp);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			return;
 		}
 		if (skb_queue_len(&rpp->queue) > 1) {
@@ -1150,7 +1150,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 				RXPRINTK("%s: Can't alloc RX skb.\n",
 					 card->name);
 				recycle_rx_pool_skb(card, rpp);
-				atomic_inc(&vcc->stats->rx_err);
+				atomic_inc_unchecked(&vcc->stats->rx_err);
 				return;
 			}
 			if (!atm_charge(vcc, skb->truesize)) {
@@ -1169,7 +1169,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			__net_timestamp(skb);
 
 			vcc->push(vcc, skb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_unchecked(&vcc->stats->rx);
 
 			return;
 		}
@@ -1191,7 +1191,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 		__net_timestamp(skb);
 
 		vcc->push(vcc, skb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 
 		if (skb->truesize > SAR_FB_SIZE_3)
 			add_rx_skb(card, 3, SAR_FB_SIZE_3, 1);
@@ -1302,14 +1302,14 @@ idt77252_rx_raw(struct idt77252_dev *card)
 		if (vcc->qos.aal != ATM_AAL0) {
 			RPRINTK("%s: raw cell for non AAL0 vc %u.%u\n",
 				card->name, vpi, vci);
-			atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc_unchecked(&vcc->stats->rx_drop);
 			goto drop;
 		}
 	
 		if ((sb = dev_alloc_skb(64)) == NULL) {
 			printk("%s: Can't allocate buffers for AAL0.\n",
 			       card->name);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			goto drop;
 		}
 
@@ -1328,7 +1328,7 @@ idt77252_rx_raw(struct idt77252_dev *card)
 		ATM_SKB(sb)->vcc = vcc;
 		__net_timestamp(sb);
 		vcc->push(vcc, sb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 
 drop:
 		skb_pull(queue, 64);
@@ -1953,13 +1953,13 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 
 	if (vc == NULL) {
 		printk("%s: NULL connection in send().\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 	if (!test_bit(VCF_TX, &vc->flags)) {
 		printk("%s: Trying to transmit on a non-tx VC.\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1971,14 +1971,14 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 		break;
 	default:
 		printk("%s: Unsupported AAL: %d\n", card->name, vcc->qos.aal);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 
 	if (skb_shinfo(skb)->nr_frags != 0) {
 		printk("%s: No scatter-gather yet.\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1986,7 +1986,7 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 
 	err = queue_skb(card, vc, skb, oam);
 	if (err) {
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return err;
 	}
@@ -2009,7 +2009,7 @@ idt77252_send_oam(struct atm_vcc *vcc, void *cell, int flags)
 	skb = dev_alloc_skb(64);
 	if (!skb) {
 		printk("%s: Out of memory in send_oam().\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		return -ENOMEM;
 	}
 	atomic_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 65e6590..df77d04 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -1145,7 +1145,7 @@ static int rx_pkt(struct atm_dev *dev)
 	status = (u_short) (buf_desc_ptr->desc_mode);  
 	if (status & (RX_CER | RX_PTE | RX_OFL))  
 	{  
-                atomic_inc(&vcc->stats->rx_err);
+                atomic_inc_unchecked(&vcc->stats->rx_err);
 		IF_ERR(printk("IA: bad packet, dropping it");)  
                 if (status & RX_CER) { 
                     IF_ERR(printk(" cause: packet CRC error\n");)
@@ -1168,7 +1168,7 @@ static int rx_pkt(struct atm_dev *dev)
 	len = dma_addr - buf_addr;  
         if (len > iadev->rx_buf_sz) {
            printk("Over %d bytes sdu received, dropped!!!\n", iadev->rx_buf_sz);
-           atomic_inc(&vcc->stats->rx_err);
+           atomic_inc_unchecked(&vcc->stats->rx_err);
 	   goto out_free_desc;
         }
 		  
@@ -1318,7 +1318,7 @@ static void rx_dle_intr(struct atm_dev *dev)
           ia_vcc = INPH_IA_VCC(vcc);
           if (ia_vcc == NULL)
           {
-             atomic_inc(&vcc->stats->rx_err);
+             atomic_inc_unchecked(&vcc->stats->rx_err);
              atm_return(vcc, skb->truesize);
              dev_kfree_skb_any(skb);
              goto INCR_DLE;
@@ -1330,7 +1330,7 @@ static void rx_dle_intr(struct atm_dev *dev)
           if ((length > iadev->rx_buf_sz) || (length > 
                               (skb->len - sizeof(struct cpcs_trailer))))
           {
-             atomic_inc(&vcc->stats->rx_err);
+             atomic_inc_unchecked(&vcc->stats->rx_err);
              IF_ERR(printk("rx_dle_intr: Bad  AAL5 trailer %d (skb len %d)", 
                                                             length, skb->len);)
              atm_return(vcc, skb->truesize);
@@ -1346,7 +1346,7 @@ static void rx_dle_intr(struct atm_dev *dev)
 
 	  IF_RX(printk("rx_dle_intr: skb push");)  
 	  vcc->push(vcc,skb);  
-	  atomic_inc(&vcc->stats->rx);
+	  atomic_inc_unchecked(&vcc->stats->rx);
           iadev->rx_pkt_cnt++;
       }  
 INCR_DLE:
@@ -2828,15 +2828,15 @@ static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)
          {
              struct k_sonet_stats *stats;
              stats = &PRIV(_ia_dev[board])->sonet_stats;
-             printk("section_bip: %d\n", atomic_read(&stats->section_bip));
-             printk("line_bip   : %d\n", atomic_read(&stats->line_bip));
-             printk("path_bip   : %d\n", atomic_read(&stats->path_bip));
-             printk("line_febe  : %d\n", atomic_read(&stats->line_febe));
-             printk("path_febe  : %d\n", atomic_read(&stats->path_febe));
-             printk("corr_hcs   : %d\n", atomic_read(&stats->corr_hcs));
-             printk("uncorr_hcs : %d\n", atomic_read(&stats->uncorr_hcs));
-             printk("tx_cells   : %d\n", atomic_read(&stats->tx_cells));
-             printk("rx_cells   : %d\n", atomic_read(&stats->rx_cells));
+             printk("section_bip: %d\n", atomic_read_unchecked(&stats->section_bip));
+             printk("line_bip   : %d\n", atomic_read_unchecked(&stats->line_bip));
+             printk("path_bip   : %d\n", atomic_read_unchecked(&stats->path_bip));
+             printk("line_febe  : %d\n", atomic_read_unchecked(&stats->line_febe));
+             printk("path_febe  : %d\n", atomic_read_unchecked(&stats->path_febe));
+             printk("corr_hcs   : %d\n", atomic_read_unchecked(&stats->corr_hcs));
+             printk("uncorr_hcs : %d\n", atomic_read_unchecked(&stats->uncorr_hcs));
+             printk("tx_cells   : %d\n", atomic_read_unchecked(&stats->tx_cells));
+             printk("rx_cells   : %d\n", atomic_read_unchecked(&stats->rx_cells));
          }
             ia_cmds.status = 0;
             break;
@@ -2941,7 +2941,7 @@ static int ia_pkt_tx (struct atm_vcc *vcc, struct sk_buff *skb) {
 	if ((desc == 0) || (desc > iadev->num_tx_desc))  
 	{  
 		IF_ERR(printk(DEV_LABEL "invalid desc for send: %d\n", desc);) 
-                atomic_inc(&vcc->stats->tx);
+                atomic_inc_unchecked(&vcc->stats->tx);
 		if (vcc->pop)   
 		    vcc->pop(vcc, skb);   
 		else  
@@ -3046,14 +3046,14 @@ static int ia_pkt_tx (struct atm_vcc *vcc, struct sk_buff *skb) {
         ATM_DESC(skb) = vcc->vci;
         skb_queue_tail(&iadev->tx_dma_q, skb);
 
-        atomic_inc(&vcc->stats->tx);
+        atomic_inc_unchecked(&vcc->stats->tx);
         iadev->tx_pkt_cnt++;
 	/* Increment transaction counter */  
 	writel(2, iadev->dma+IPHASE5575_TX_COUNTER);  
         
 #if 0        
         /* add flow control logic */ 
-        if (atomic_read(&vcc->stats->tx) % 20 == 0) {
+        if (atomic_read_unchecked(&vcc->stats->tx) % 20 == 0) {
           if (iavcc->vc_desc_cnt > 10) {
              vcc->tx_quota =  vcc->tx_quota * 3 / 4;
             printk("Tx1:  vcc->tx_quota = %d \n", (u32)vcc->tx_quota );
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index ce43ae3..969de38 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1295,7 +1295,7 @@ static void lanai_send_one_aal5(struct lanai_dev *lanai,
 	vcc_tx_add_aal5_trailer(lvcc, skb->len, 0, 0);
 	lanai_endtx(lanai, lvcc);
 	lanai_free_skb(lvcc->tx.atmvcc, skb);
-	atomic_inc(&lvcc->tx.atmvcc->stats->tx);
+	atomic_inc_unchecked(&lvcc->tx.atmvcc->stats->tx);
 }
 
 /* Try to fill the buffer - don't call unless there is backlog */
@@ -1418,7 +1418,7 @@ static void vcc_rx_aal5(struct lanai_vcc *lvcc, int endptr)
 	ATM_SKB(skb)->vcc = lvcc->rx.atmvcc;
 	__net_timestamp(skb);
 	lvcc->rx.atmvcc->push(lvcc->rx.atmvcc, skb);
-	atomic_inc(&lvcc->rx.atmvcc->stats->rx);
+	atomic_inc_unchecked(&lvcc->rx.atmvcc->stats->rx);
     out:
 	lvcc->rx.buf.ptr = end;
 	cardvcc_write(lvcc, endptr, vcc_rxreadptr);
@@ -1659,7 +1659,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		DPRINTK("(itf %d) got RX service entry 0x%X for non-AAL5 "
 		    "vcc %d\n", lanai->number, (unsigned int) s, vci);
 		lanai->stats.service_rxnotaal5++;
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_unchecked(&lvcc->rx.atmvcc->stats->rx_err);
 		return 0;
 	}
 	if (likely(!(s & (SERVICE_TRASH | SERVICE_STREAM | SERVICE_CRCERR)))) {
@@ -1671,7 +1671,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		int bytes;
 		read_unlock(&vcc_sklist_lock);
 		DPRINTK("got trashed rx pdu on vci %d\n", vci);
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_unchecked(&lvcc->rx.atmvcc->stats->rx_err);
 		lvcc->stats.x.aal5.service_trash++;
 		bytes = (SERVICE_GET_END(s) * 16) -
 		    (((unsigned long) lvcc->rx.buf.ptr) -
@@ -1683,7 +1683,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 	}
 	if (s & SERVICE_STREAM) {
 		read_unlock(&vcc_sklist_lock);
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_unchecked(&lvcc->rx.atmvcc->stats->rx_err);
 		lvcc->stats.x.aal5.service_stream++;
 		printk(KERN_ERR DEV_LABEL "(itf %d): Got AAL5 stream "
 		    "PDU on VCI %d!\n", lanai->number, vci);
@@ -1691,7 +1691,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		return 0;
 	}
 	DPRINTK("got rx crc error on vci %d\n", vci);
-	atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+	atomic_inc_unchecked(&lvcc->rx.atmvcc->stats->rx_err);
 	lvcc->stats.x.aal5.service_rxcrc++;
 	lvcc->rx.buf.ptr = &lvcc->rx.buf.start[SERVICE_GET_END(s) * 4];
 	cardvcc_write(lvcc, SERVICE_GET_END(s), vcc_rxreadptr);
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index ddc4ceb..36e29aa 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1632,7 +1632,7 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if ((vc = (vc_map *) vcc->dev_data) == NULL) {
 		printk("nicstar%d: vcc->dev_data == NULL on ns_send().\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1640,7 +1640,7 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if (!vc->tx) {
 		printk("nicstar%d: Trying to transmit on a non-tx VC.\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1648,14 +1648,14 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if (vcc->qos.aal != ATM_AAL5 && vcc->qos.aal != ATM_AAL0) {
 		printk("nicstar%d: Only AAL0 and AAL5 are supported.\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
 	if (skb_shinfo(skb)->nr_frags != 0) {
 		printk("nicstar%d: No scatter-gather yet.\n", card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1703,11 +1703,11 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	if (push_scqe(card, vc, scq, &scqe, skb) != 0) {
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_unchecked(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_unchecked(&vcc->stats->tx);
 
 	return 0;
 }
@@ -2024,14 +2024,14 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				printk
 				    ("nicstar%d: Can't allocate buffers for aal0.\n",
 				     card->index);
-				atomic_add(i, &vcc->stats->rx_drop);
+				atomic_add_unchecked(i, &vcc->stats->rx_drop);
 				break;
 			}
 			if (!atm_charge(vcc, sb->truesize)) {
 				RXPRINTK
 				    ("nicstar%d: atm_charge() dropped aal0 packets.\n",
 				     card->index);
-				atomic_add(i - 1, &vcc->stats->rx_drop);	/* already increased by 1 */
+				atomic_add_unchecked(i - 1, &vcc->stats->rx_drop);	/* already increased by 1 */
 				dev_kfree_skb_any(sb);
 				break;
 			}
@@ -2046,7 +2046,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			ATM_SKB(sb)->vcc = vcc;
 			__net_timestamp(sb);
 			vcc->push(vcc, sb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_unchecked(&vcc->stats->rx);
 			cell += ATM_CELL_PAYLOAD;
 		}
 
@@ -2063,7 +2063,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			if (iovb == NULL) {
 				printk("nicstar%d: Out of iovec buffers.\n",
 				       card->index);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_unchecked(&vcc->stats->rx_drop);
 				recycle_rx_buf(card, skb);
 				return;
 			}
@@ -2087,7 +2087,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 		   small or large buffer itself. */
 	} else if (NS_PRV_IOVCNT(iovb) >= NS_MAX_IOVECS) {
 		printk("nicstar%d: received too big AAL5 SDU.\n", card->index);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_unchecked(&vcc->stats->rx_err);
 		recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 				      NS_MAX_IOVECS);
 		NS_PRV_IOVCNT(iovb) = 0;
@@ -2107,7 +2107,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			    ("nicstar%d: Expected a small buffer, and this is not one.\n",
 			     card->index);
 			which_list(card, skb);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			recycle_rx_buf(card, skb);
 			vc->rx_iov = NULL;
 			recycle_iov_buf(card, iovb);
@@ -2120,7 +2120,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			    ("nicstar%d: Expected a large buffer, and this is not one.\n",
 			     card->index);
 			which_list(card, skb);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 					      NS_PRV_IOVCNT(iovb));
 			vc->rx_iov = NULL;
@@ -2143,7 +2143,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				printk(" - PDU size mismatch.\n");
 			else
 				printk(".\n");
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_unchecked(&vcc->stats->rx_err);
 			recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 					      NS_PRV_IOVCNT(iovb));
 			vc->rx_iov = NULL;
@@ -2157,14 +2157,14 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			/* skb points to a small buffer */
 			if (!atm_charge(vcc, skb->truesize)) {
 				push_rxbufs(card, skb);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_unchecked(&vcc->stats->rx_drop);
 			} else {
 				skb_put(skb, len);
 				dequeue_sm_buf(card, skb);
 				ATM_SKB(skb)->vcc = vcc;
 				__net_timestamp(skb);
 				vcc->push(vcc, skb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_unchecked(&vcc->stats->rx);
 			}
 		} else if (NS_PRV_IOVCNT(iovb) == 2) {	/* One small plus one large buffer */
 			struct sk_buff *sb;
@@ -2175,14 +2175,14 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			if (len <= NS_SMBUFSIZE) {
 				if (!atm_charge(vcc, sb->truesize)) {
 					push_rxbufs(card, sb);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_unchecked(&vcc->stats->rx_drop);
 				} else {
 					skb_put(sb, len);
 					dequeue_sm_buf(card, sb);
 					ATM_SKB(sb)->vcc = vcc;
 					__net_timestamp(sb);
 					vcc->push(vcc, sb);
-					atomic_inc(&vcc->stats->rx);
+					atomic_inc_unchecked(&vcc->stats->rx);
 				}
 
 				push_rxbufs(card, skb);
@@ -2191,7 +2191,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 
 				if (!atm_charge(vcc, skb->truesize)) {
 					push_rxbufs(card, skb);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_unchecked(&vcc->stats->rx_drop);
 				} else {
 					dequeue_lg_buf(card, skb);
 					skb_push(skb, NS_SMBUFSIZE);
@@ -2201,7 +2201,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					ATM_SKB(skb)->vcc = vcc;
 					__net_timestamp(skb);
 					vcc->push(vcc, skb);
-					atomic_inc(&vcc->stats->rx);
+					atomic_inc_unchecked(&vcc->stats->rx);
 				}
 
 				push_rxbufs(card, sb);
@@ -2222,7 +2222,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					printk
 					    ("nicstar%d: Out of huge buffers.\n",
 					     card->index);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_unchecked(&vcc->stats->rx_drop);
 					recycle_iovec_rx_bufs(card,
 							      (struct iovec *)
 							      iovb->data,
@@ -2273,7 +2273,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					card->hbpool.count++;
 				} else
 					dev_kfree_skb_any(hb);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_unchecked(&vcc->stats->rx_drop);
 			} else {
 				/* Copy the small buffer to the huge buffer */
 				sb = (struct sk_buff *)iov->iov_base;
@@ -2307,7 +2307,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				ATM_SKB(hb)->vcc = vcc;
 				__net_timestamp(hb);
 				vcc->push(vcc, hb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_unchecked(&vcc->stats->rx);
 			}
 		}
 
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 74e18b0..f16afa0 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -838,7 +838,7 @@ static void solos_bh(unsigned long card_arg)
 				}
 				atm_charge(vcc, skb->truesize);
 				vcc->push(vcc, skb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_unchecked(&vcc->stats->rx);
 				break;
 
 			case PKT_STATUS:
@@ -1116,7 +1116,7 @@ static uint32_t fpga_tx(struct solos_card *card)
 			vcc = SKB_CB(oldskb)->vcc;
 
 			if (vcc) {
-				atomic_inc(&vcc->stats->tx);
+				atomic_inc_unchecked(&vcc->stats->tx);
 				solos_pop(vcc, oldskb);
 			} else {
 				dev_kfree_skb_irq(oldskb);
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 0215934..ce9f5b1 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -49,8 +49,8 @@ static DEFINE_SPINLOCK(sunis_lock);
 
 
 #define ADD_LIMITED(s,v) \
-    atomic_add((v),&stats->s); \
-    if (atomic_read(&stats->s) < 0) atomic_set(&stats->s,INT_MAX);
+    atomic_add_unchecked((v),&stats->s); \
+    if (atomic_read_unchecked(&stats->s) < 0) atomic_set_unchecked(&stats->s,INT_MAX);
 
 
 static void suni_hz(unsigned long from_timer)
diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index 5120a96..e2572bd 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -42,7 +42,7 @@ static int fetch_stats(struct atm_dev *dev,struct sonet_stats __user *arg,int ze
 	struct sonet_stats tmp;
  	int error = 0;
 
-	atomic_add(GET(HECCT),&PRIV(dev)->sonet_stats.uncorr_hcs);
+	atomic_add_unchecked(GET(HECCT),&PRIV(dev)->sonet_stats.uncorr_hcs);
 	sonet_copy_stats(&PRIV(dev)->sonet_stats,&tmp);
 	if (arg) error = copy_to_user(arg,&tmp,sizeof(tmp));
 	if (zero && !error) {
@@ -161,9 +161,9 @@ static int uPD98402_ioctl(struct atm_dev *dev,unsigned int cmd,void __user *arg)
 
 
 #define ADD_LIMITED(s,v) \
-    { atomic_add(GET(v),&PRIV(dev)->sonet_stats.s); \
-    if (atomic_read(&PRIV(dev)->sonet_stats.s) < 0) \
-	atomic_set(&PRIV(dev)->sonet_stats.s,INT_MAX); }
+    { atomic_add_unchecked(GET(v),&PRIV(dev)->sonet_stats.s); \
+    if (atomic_read_unchecked(&PRIV(dev)->sonet_stats.s) < 0) \
+	atomic_set_unchecked(&PRIV(dev)->sonet_stats.s,INT_MAX); }
 
 
 static void stat_event(struct atm_dev *dev)
@@ -194,7 +194,7 @@ static void uPD98402_int(struct atm_dev *dev)
 		if (reason & uPD98402_INT_PFM) stat_event(dev);
 		if (reason & uPD98402_INT_PCO) {
 			(void) GET(PCOCR); /* clear interrupt cause */
-			atomic_add(GET(HECCT),
+			atomic_add_unchecked(GET(HECCT),
 			    &PRIV(dev)->sonet_stats.uncorr_hcs);
 		}
 		if ((reason & uPD98402_INT_RFO) && 
@@ -222,9 +222,9 @@ static int uPD98402_start(struct atm_dev *dev)
 	PUT(~(uPD98402_INT_PFM | uPD98402_INT_ALM | uPD98402_INT_RFO |
 	  uPD98402_INT_LOS),PIMR); /* enable them */
 	(void) fetch_stats(dev,NULL,1); /* clear kernel counters */
-	atomic_set(&PRIV(dev)->sonet_stats.corr_hcs,-1);
-	atomic_set(&PRIV(dev)->sonet_stats.tx_cells,-1);
-	atomic_set(&PRIV(dev)->sonet_stats.rx_cells,-1);
+	atomic_set_unchecked(&PRIV(dev)->sonet_stats.corr_hcs,-1);
+	atomic_set_unchecked(&PRIV(dev)->sonet_stats.tx_cells,-1);
+	atomic_set_unchecked(&PRIV(dev)->sonet_stats.rx_cells,-1);
 	return 0;
 }
 
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index cecfb94..87009ec 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -459,7 +459,7 @@ printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
 		}
 		if (!size) {
 			dev_kfree_skb_irq(skb);
-			if (vcc) atomic_inc(&vcc->stats->rx_err);
+			if (vcc) atomic_inc_unchecked(&vcc->stats->rx_err);
 			continue;
 		}
 		if (!atm_charge(vcc,skb->truesize)) {
@@ -469,7 +469,7 @@ printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
 		skb->len = size;
 		ATM_SKB(skb)->vcc = vcc;
 		vcc->push(vcc,skb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_unchecked(&vcc->stats->rx);
 	}
 	zout(pos & 0xffff,MTA(mbx));
 #if 0 /* probably a stupid idea */
@@ -733,7 +733,7 @@ if (*ZATM_PRV_DSC(skb) != (uPD98401_TXPD_V | uPD98401_TXPD_DP |
 			skb_queue_head(&zatm_vcc->backlog,skb);
 			break;
 		}
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_unchecked(&vcc->stats->tx);
 	wake_up(&zatm_vcc->tx_wait);
 }
 
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 51f15bc..892a668 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -33,14 +33,14 @@ static bool pm_abort_suspend __read_mostly;
  * They need to be modified together atomically, so it's better to use one
  * atomic variable to hold them both.
  */
-static atomic_t combined_event_count = ATOMIC_INIT(0);
+static atomic_unchecked_t combined_event_count = ATOMIC_INIT(0);
 
 #define IN_PROGRESS_BITS	(sizeof(int) * 4)
 #define MAX_IN_PROGRESS		((1 << IN_PROGRESS_BITS) - 1)
 
 static void split_counters(unsigned int *cnt, unsigned int *inpr)
 {
-	unsigned int comb = atomic_read(&combined_event_count);
+	unsigned int comb = atomic_read_unchecked(&combined_event_count);
 
 	*cnt = (comb >> IN_PROGRESS_BITS);
 	*inpr = comb & MAX_IN_PROGRESS;
@@ -537,7 +537,7 @@ static void wakeup_source_activate(struct wakeup_source *ws)
 		ws->start_prevent_time = ws->last_time;
 
 	/* Increment the counter of events in progress. */
-	cec = atomic_inc_return(&combined_event_count);
+	cec = atomic_inc_return_unchecked(&combined_event_count);
 
 	trace_wakeup_source_activate(ws->name, cec);
 }
@@ -663,7 +663,7 @@ static void wakeup_source_deactivate(struct wakeup_source *ws)
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
 	 */
-	cec = atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
+	cec = atomic_add_return_unchecked(MAX_IN_PROGRESS, &combined_event_count);
 	trace_wakeup_source_deactivate(ws->name, cec);
 
 	split_counters(&cnt, &inpr);
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 434c77d..6d3219a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1036,7 +1036,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 		submit_bio(rw, bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
-		atomic_add(len >> 9, &device->rs_sect_ev);
+		atomic_add_unchecked(len >> 9, &device->rs_sect_ev);
 	}
 }
 
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index efd19c2..6ccfa94 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -386,7 +386,7 @@ struct drbd_epoch {
 	struct drbd_connection *connection;
 	struct list_head list;
 	unsigned int barrier_nr;
-	atomic_t epoch_size; /* increased on every request added. */
+	atomic_unchecked_t epoch_size; /* increased on every request added. */
 	atomic_t active;     /* increased on every req. added, and dec on every finished. */
 	unsigned long flags;
 };
@@ -947,7 +947,7 @@ struct drbd_device {
 	unsigned int al_tr_number;
 	int al_tr_cycle;
 	wait_queue_head_t seq_wait;
-	atomic_t packet_seq;
+	atomic_unchecked_t packet_seq;
 	unsigned int peer_seq;
 	spinlock_t peer_seq_lock;
 	unsigned long comm_bm_set; /* communicated number of set bits. */
@@ -956,8 +956,8 @@ struct drbd_device {
 	struct mutex own_state_mutex;
 	struct mutex *state_mutex; /* either own_state_mutex or first_peer_device(device)->connection->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
-	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
-	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
+	atomic_unchecked_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
+	atomic_unchecked_t rs_sect_ev; /* for submitted resync data rate, both */
 	int rs_last_sect_ev; /* counter to compare with */
 	int rs_last_events;  /* counter of read or write "events" (unit sectors)
 			      * on the lower level device when we last looked. */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a151853..b9b5baa 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1328,7 +1328,7 @@ static int _drbd_send_ack(struct drbd_peer_device *peer_device, enum drbd_packet
 	p->sector = sector;
 	p->block_id = block_id;
 	p->blksize = blksize;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&peer_device->device->packet_seq));
+	p->seq_num = cpu_to_be32(atomic_inc_return_unchecked(&peer_device->device->packet_seq));
 	return drbd_send_command(peer_device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
@@ -1634,7 +1634,7 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->block_id = (unsigned long)req;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
+	p->seq_num = cpu_to_be32(atomic_inc_return_unchecked(&device->packet_seq));
 	dp_flags = bio_flags_to_wire(peer_device->connection, req->master_bio->bi_rw);
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
@@ -1915,8 +1915,8 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	atomic_set(&device->unacked_cnt, 0);
 	atomic_set(&device->local_cnt, 0);
 	atomic_set(&device->pp_in_use_by_net, 0);
-	atomic_set(&device->rs_sect_in, 0);
-	atomic_set(&device->rs_sect_ev, 0);
+	atomic_set_unchecked(&device->rs_sect_in, 0);
+	atomic_set_unchecked(&device->rs_sect_ev, 0);
 	atomic_set(&device->ap_in_flight, 0);
 	atomic_set(&device->md_io.in_use, 0);
 
@@ -2683,8 +2683,8 @@ void drbd_destroy_connection(struct kref *kref)
 	struct drbd_connection *connection = container_of(kref, struct drbd_connection, kref);
 	struct drbd_resource *resource = connection->resource;
 
-	if (atomic_read(&connection->current_epoch->epoch_size) !=  0)
-		drbd_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
+	if (atomic_read_unchecked(&connection->current_epoch->epoch_size) !=  0)
+		drbd_err(connection, "epoch_size:%d\n", atomic_read_unchecked(&connection->current_epoch->epoch_size));
 	kfree(connection->current_epoch);
 
 	idr_destroy(&connection->peer_devices);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 74df8cf..e41fc24 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3637,13 +3637,13 @@ finish:
 
 void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib)
 {
-	static atomic_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
+	static atomic_unchecked_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
 	struct sk_buff *msg;
 	struct drbd_genlmsghdr *d_out;
 	unsigned seq;
 	int err = -ENOMEM;
 
-	seq = atomic_inc_return(&drbd_genl_seq);
+	seq = atomic_inc_return_unchecked(&drbd_genl_seq);
 	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 	if (!msg)
 		goto failed;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c097909..11820ed 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -870,7 +870,7 @@ int drbd_connected(struct drbd_peer_device *peer_device)
 	struct drbd_device *device = peer_device->device;
 	int err;
 
-	atomic_set(&device->packet_seq, 0);
+	atomic_set_unchecked(&device->packet_seq, 0);
 	device->peer_seq = 0;
 
 	device->state_mutex = peer_device->connection->agreed_pro_version < 100 ?
@@ -1233,7 +1233,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 	do {
 		next_epoch = NULL;
 
-		epoch_size = atomic_read(&epoch->epoch_size);
+		epoch_size = atomic_read_unchecked(&epoch->epoch_size);
 
 		switch (ev & ~EV_CLEANUP) {
 		case EV_PUT:
@@ -1273,7 +1273,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 					rv = FE_DESTROYED;
 			} else {
 				epoch->flags = 0;
-				atomic_set(&epoch->epoch_size, 0);
+				atomic_set_unchecked(&epoch->epoch_size, 0);
 				/* atomic_set(&epoch->active, 0); is already zero */
 				if (rv == FE_STILL_LIVE)
 					rv = FE_RECYCLED;
@@ -1550,7 +1550,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 		conn_wait_active_ee_empty(connection);
 		drbd_flush(connection);
 
-		if (atomic_read(&connection->current_epoch->epoch_size)) {
+		if (atomic_read_unchecked(&connection->current_epoch->epoch_size)) {
 			epoch = kmalloc(sizeof(struct drbd_epoch), GFP_NOIO);
 			if (epoch)
 				break;
@@ -1564,11 +1564,11 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 	}
 
 	epoch->flags = 0;
-	atomic_set(&epoch->epoch_size, 0);
+	atomic_set_unchecked(&epoch->epoch_size, 0);
 	atomic_set(&epoch->active, 0);
 
 	spin_lock(&connection->epoch_lock);
-	if (atomic_read(&connection->current_epoch->epoch_size)) {
+	if (atomic_read_unchecked(&connection->current_epoch->epoch_size)) {
 		list_add(&epoch->list, &connection->current_epoch->list);
 		connection->current_epoch = epoch;
 		connection->epochs++;
@@ -1802,7 +1802,7 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	list_add_tail(&peer_req->w.list, &device->sync_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	atomic_add(pi->size >> 9, &device->rs_sect_ev);
+	atomic_add_unchecked(pi->size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
 		return 0;
 
@@ -1900,7 +1900,7 @@ static int receive_RSDataReply(struct drbd_connection *connection, struct packet
 		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
 	}
 
-	atomic_add(pi->size >> 9, &device->rs_sect_in);
+	atomic_add_unchecked(pi->size >> 9, &device->rs_sect_in);
 
 	return err;
 }
@@ -2290,7 +2290,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 		err = wait_for_and_update_peer_seq(peer_device, peer_seq);
 		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
-		atomic_inc(&connection->current_epoch->epoch_size);
+		atomic_inc_unchecked(&connection->current_epoch->epoch_size);
 		err2 = drbd_drain_block(peer_device, pi->size);
 		if (!err)
 			err = err2;
@@ -2334,7 +2334,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 	spin_lock(&connection->epoch_lock);
 	peer_req->epoch = connection->current_epoch;
-	atomic_inc(&peer_req->epoch->epoch_size);
+	atomic_inc_unchecked(&peer_req->epoch->epoch_size);
 	atomic_inc(&peer_req->epoch->active);
 	spin_unlock(&connection->epoch_lock);
 
@@ -2479,7 +2479,7 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 
 	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 		      (int)part_stat_read(&disk->part0, sectors[1]) -
-			atomic_read(&device->rs_sect_ev);
+			atomic_read_unchecked(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
 	    || curr_events - device->rs_last_events > 64) {
@@ -2618,7 +2618,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			device->use_csums = true;
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
-			atomic_add(size >> 9, &device->rs_sect_in);
+			atomic_add_unchecked(size >> 9, &device->rs_sect_in);
 			peer_req->w.cb = w_e_end_ov_reply;
 			dec_rs_pending(device);
 			/* drbd_rs_begin_io done when we sent this request,
@@ -2691,7 +2691,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		goto out_free_e;
 
 submit_for_resync:
-	atomic_add(size >> 9, &device->rs_sect_ev);
+	atomic_add_unchecked(size >> 9, &device->rs_sect_ev);
 
 submit:
 	update_receiver_timing_details(connection, drbd_submit_peer_request);
@@ -4678,7 +4678,7 @@ static void conn_disconnect(struct drbd_connection *connection)
 	if (!list_empty(&connection->current_epoch->list))
 		drbd_err(connection, "ASSERTION FAILED: connection->current_epoch->list not empty\n");
 	/* ok, no more ee's on the fly, it is safe to reset the epoch_size */
-	atomic_set(&connection->current_epoch->epoch_size, 0);
+	atomic_set_unchecked(&connection->current_epoch->epoch_size, 0);
 	connection->send.seen_any_write_yet = false;
 
 	drbd_info(connection, "Connection closed\n");
@@ -5182,7 +5182,7 @@ static int got_IsInSync(struct drbd_connection *connection, struct packet_info *
 		put_ldev(device);
 	}
 	dec_rs_pending(device);
-	atomic_add(blksize >> 9, &device->rs_sect_in);
+	atomic_add_unchecked(blksize >> 9, &device->rs_sect_in);
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d0fae55..4469096 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -408,7 +408,7 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	list_add_tail(&peer_req->w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	atomic_add(size >> 9, &device->rs_sect_ev);
+	atomic_add_unchecked(size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
 		return 0;
 
@@ -553,7 +553,7 @@ static int drbd_rs_number_requests(struct drbd_device *device)
 	unsigned int sect_in;  /* Number of sectors that came in since the last turn */
 	int number, mxb;
 
-	sect_in = atomic_xchg(&device->rs_sect_in, 0);
+	sect_in = atomic_xchg_unchecked(&device->rs_sect_in, 0);
 	device->rs_in_flight -= sect_in;
 
 	rcu_read_lock();
@@ -1595,8 +1595,8 @@ void drbd_rs_controller_reset(struct drbd_device *device)
 	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
 	struct fifo_buffer *plan;
 
-	atomic_set(&device->rs_sect_in, 0);
-	atomic_set(&device->rs_sect_ev, 0);
+	atomic_set_unchecked(&device->rs_sect_in, 0);
+	atomic_set_unchecked(&device->rs_sect_ev, 0);
 	device->rs_in_flight = 0;
 	device->rs_last_events =
 		(int)part_stat_read(&disk->part0, sectors[0]) +
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index bf75f63..359fa10 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -436,7 +436,7 @@ struct ipmi_smi {
 	struct proc_dir_entry *proc_dir;
 	char                  proc_dir_name[10];
 
-	atomic_t stats[IPMI_NUM_STATS];
+	atomic_unchecked_t stats[IPMI_NUM_STATS];
 
 	/*
 	 * run_to_completion duplicate of smb_info, smi_info
@@ -468,9 +468,9 @@ static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
 #define ipmi_inc_stat(intf, stat) \
-	atomic_inc(&(intf)->stats[IPMI_STAT_ ## stat])
+	atomic_inc_unchecked(&(intf)->stats[IPMI_STAT_ ## stat])
 #define ipmi_get_stat(intf, stat) \
-	((unsigned int) atomic_read(&(intf)->stats[IPMI_STAT_ ## stat]))
+	((unsigned int) atomic_read_unchecked(&(intf)->stats[IPMI_STAT_ ## stat]))
 
 static char *addr_src_to_str[] = { "invalid", "hotmod", "hardcoded", "SPMI",
 				   "ACPI", "SMBIOS", "PCI",
@@ -2828,7 +2828,7 @@ int ipmi_register_smi(struct ipmi_smi_handlers *handlers,
 	INIT_LIST_HEAD(&intf->cmd_rcvrs);
 	init_waitqueue_head(&intf->waitq);
 	for (i = 0; i < IPMI_NUM_STATS; i++)
-		atomic_set(&intf->stats[i], 0);
+		atomic_set_unchecked(&intf->stats[i], 0);
 
 	intf->proc_dir = NULL;
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 8a45e92..e41b1c7 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -289,7 +289,7 @@ struct smi_info {
 	unsigned char slave_addr;
 
 	/* Counters and things for the proc filesystem. */
-	atomic_t stats[SI_NUM_STATS];
+	atomic_unchecked_t stats[SI_NUM_STATS];
 
 	struct task_struct *thread;
 
@@ -298,9 +298,9 @@ struct smi_info {
 };
 
 #define smi_inc_stat(smi, stat) \
-	atomic_inc(&(smi)->stats[SI_STAT_ ## stat])
+	atomic_inc_unchecked(&(smi)->stats[SI_STAT_ ## stat])
 #define smi_get_stat(smi, stat) \
-	((unsigned int) atomic_read(&(smi)->stats[SI_STAT_ ## stat]))
+	((unsigned int) atomic_read_unchecked(&(smi)->stats[SI_STAT_ ## stat]))
 
 #define SI_MAX_PARMS 4
 
@@ -3500,7 +3500,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	atomic_set(&new_smi->req_events, 0);
 	new_smi->run_to_completion = false;
 	for (i = 0; i < SI_NUM_STATS; i++)
-		atomic_set(&new_smi->stats[i], 0);
+		atomic_set_unchecked(&new_smi->stats[i], 0);
 
 	new_smi->interrupt_disabled = true;
 	atomic_set(&new_smi->need_watch, 0);
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 8d2a772..33826c9 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -51,7 +51,7 @@ module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
 MODULE_PARM_DESC(hifn_pll_ref,
 		 "PLL reference clock (pci[freq] or ext[freq], default ext)");
 
-static atomic_t hifn_dev_number;
+static atomic_unchecked_t hifn_dev_number;
 
 #define ACRYPTO_OP_DECRYPT	0
 #define ACRYPTO_OP_ENCRYPT	1
@@ -2577,7 +2577,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_out_disable_pci_device;
 
 	snprintf(name, sizeof(name), "hifn%d",
-			atomic_inc_return(&hifn_dev_number)-1);
+			atomic_inc_return_unchecked(&hifn_dev_number)-1);
 
 	err = pci_request_regions(pdev, name);
 	if (err)
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 592af5f..bb1d583 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -477,9 +477,9 @@ void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
  */
 int edac_device_alloc_index(void)
 {
-	static atomic_t device_indexes = ATOMIC_INIT(0);
+	static atomic_unchecked_t device_indexes = ATOMIC_INIT(0);
 
-	return atomic_inc_return(&device_indexes) - 1;
+	return atomic_inc_return_unchecked(&device_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_index);
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 2cf44b4d..6dd2dc7 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -29,7 +29,7 @@
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
 static LIST_HEAD(edac_pci_list);
-static atomic_t pci_indexes = ATOMIC_INIT(0);
+static atomic_unchecked_t pci_indexes = ATOMIC_INIT(0);
 
 /*
  * edac_pci_alloc_ctl_info
@@ -315,7 +315,7 @@ EXPORT_SYMBOL_GPL(edac_pci_reset_delay_period);
  */
 int edac_pci_alloc_index(void)
 {
-	return atomic_inc_return(&pci_indexes) - 1;
+	return atomic_inc_return_unchecked(&pci_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
 
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 24d877f..40f4ecb 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -23,8 +23,8 @@ static int edac_pci_log_pe = 1;		/* log PCI parity errors */
 static int edac_pci_log_npe = 1;	/* log PCI non-parity error errors */
 static int edac_pci_poll_msec = 1000;	/* one second workq period */
 
-static atomic_t pci_parity_count = ATOMIC_INIT(0);
-static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
+static atomic_unchecked_t pci_parity_count = ATOMIC_INIT(0);
+static atomic_unchecked_t pci_nonparity_count = ATOMIC_INIT(0);
 
 static struct kobject *edac_pci_top_main_kobj;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
@@ -576,7 +576,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
 				pci_name(dev));
-			atomic_inc(&pci_nonparity_count);
+			atomic_inc_unchecked(&pci_nonparity_count);
 		}
 
 		if (status & (PCI_STATUS_PARITY)) {
@@ -584,7 +584,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				"Master Data Parity Error on %s\n",
 				pci_name(dev));
 
-			atomic_inc(&pci_parity_count);
+			atomic_inc_unchecked(&pci_parity_count);
 		}
 
 		if (status & (PCI_STATUS_DETECTED_PARITY)) {
@@ -592,7 +592,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				"Detected Parity Error on %s\n",
 				pci_name(dev));
 
-			atomic_inc(&pci_parity_count);
+			atomic_inc_unchecked(&pci_parity_count);
 		}
 	}
 
@@ -615,7 +615,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",
 					pci_name(dev));
-				atomic_inc(&pci_nonparity_count);
+				atomic_inc_unchecked(&pci_nonparity_count);
 			}
 
 			if (status & (PCI_STATUS_PARITY)) {
@@ -623,7 +623,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 					"Master Data Parity Error on "
 					"%s\n", pci_name(dev));
 
-				atomic_inc(&pci_parity_count);
+				atomic_inc_unchecked(&pci_parity_count);
 			}
 
 			if (status & (PCI_STATUS_DETECTED_PARITY)) {
@@ -631,7 +631,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 					"Detected Parity Error on %s\n",
 					pci_name(dev));
 
-				atomic_inc(&pci_parity_count);
+				atomic_inc_unchecked(&pci_parity_count);
 			}
 		}
 	}
@@ -669,7 +669,7 @@ void edac_pci_do_parity_check(void)
 	if (!check_pci_errors)
 		return;
 
-	before_count = atomic_read(&pci_parity_count);
+	before_count = atomic_read_unchecked(&pci_parity_count);
 
 	/* scan all PCI devices looking for a Parity Error on devices and
 	 * bridges.
@@ -681,7 +681,7 @@ void edac_pci_do_parity_check(void)
 	/* Only if operator has selected panic on PCI Error */
 	if (edac_pci_get_panic_on_pe()) {
 		/* If the count is different 'after' from 'before' */
-		if (before_count != atomic_read(&pci_parity_count))
+		if (before_count != atomic_read_unchecked(&pci_parity_count))
 			panic("EDAC: PCI Parity Error");
 	}
 }
diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 57ea7f4..9c461ac 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -528,9 +528,9 @@ void fw_card_initialize(struct fw_card *card,
 			const struct fw_card_driver *driver,
 			struct device *device)
 {
-	static atomic_t index = ATOMIC_INIT(-1);
+	static atomic_unchecked_t index = ATOMIC_INIT(-1);
 
-	card->index = atomic_inc_return(&index);
+	card->index = atomic_inc_return_unchecked(&index);
 	card->driver = driver;
 	card->device = device;
 	card->current_tlabel = 0;
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d425374..1da1716 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -44,12 +44,12 @@ static char rcd_decode_str[CPER_REC_LEN];
  */
 u64 cper_next_record_id(void)
 {
-	static atomic64_t seq;
+	static atomic64_unchecked_t seq;
 
-	if (!atomic64_read(&seq))
-		atomic64_set(&seq, ((u64)get_seconds()) << 32);
+	if (!atomic64_read_unchecked(&seq))
+		atomic64_set_unchecked(&seq, ((u64)get_seconds()) << 32);
 
-	return atomic64_inc_return(&seq);
+	return atomic64_inc_return_unchecked(&seq);
 }
 EXPORT_SYMBOL_GPL(cper_next_record_id);
 
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index c1caa45..f0f97d2 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -224,7 +224,7 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
+	atomic_inc_unchecked(&irq_err_count);
 
 	return -EINVAL;
 }
diff --git a/drivers/gpu/drm/i810/i810_drv.h b/drivers/gpu/drm/i810/i810_drv.h
index 93ec5dc..82acbaf 100644
--- a/drivers/gpu/drm/i810/i810_drv.h
+++ b/drivers/gpu/drm/i810/i810_drv.h
@@ -110,8 +110,8 @@ typedef struct drm_i810_private {
 	int page_flipping;
 
 	wait_queue_head_t irq_queue;
-	atomic_t irq_received;
-	atomic_t irq_emitted;
+	atomic_unchecked_t irq_received;
+	atomic_unchecked_t irq_emitted;
 
 	int front_offset;
 } drm_i810_private_t;
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index b4a20149..219ab78 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -122,9 +122,9 @@ typedef struct drm_mga_private {
 	u32 clear_cmd;
 	u32 maccess;
 
-	atomic_t vbl_received;          /**< Number of vblanks received. */
+	atomic_unchecked_t vbl_received;          /**< Number of vblanks received. */
 	wait_queue_head_t fence_queue;
-	atomic_t last_fence_retired;
+	atomic_unchecked_t last_fence_retired;
 	u32 next_fence_to_post;
 
 	unsigned int fb_cpp;
diff --git a/drivers/gpu/drm/mga/mga_irq.c b/drivers/gpu/drm/mga/mga_irq.c
index 1b071b8..de8601a 100644
--- a/drivers/gpu/drm/mga/mga_irq.c
+++ b/drivers/gpu/drm/mga/mga_irq.c
@@ -43,7 +43,7 @@ u32 mga_get_vblank_counter(struct drm_device *dev, int crtc)
 	if (crtc != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_unchecked(&dev_priv->vbl_received);
 }
 
 
@@ -59,7 +59,7 @@ irqreturn_t mga_driver_irq_handler(int irq, void *arg)
 	/* VBLANK interrupt */
 	if (status & MGA_VLINEPEN) {
 		MGA_WRITE(MGA_ICLEAR, MGA_VLINEICLR);
-		atomic_inc(&dev_priv->vbl_received);
+		atomic_inc_unchecked(&dev_priv->vbl_received);
 		drm_handle_vblank(dev, 0);
 		handled = 1;
 	}
@@ -78,7 +78,7 @@ irqreturn_t mga_driver_irq_handler(int irq, void *arg)
 		if ((prim_start & ~0x03) != (prim_end & ~0x03))
 			MGA_WRITE(MGA_PRIMEND, prim_end);
 
-		atomic_inc(&dev_priv->last_fence_retired);
+		atomic_inc_unchecked(&dev_priv->last_fence_retired);
 		wake_up(&dev_priv->fence_queue);
 		handled = 1;
 	}
@@ -129,7 +129,7 @@ int mga_driver_fence_wait(struct drm_device *dev, unsigned int *sequence)
 	 * using fences.
 	 */
 	DRM_WAIT_ON(ret, dev_priv->fence_queue, 3 * HZ,
-		    (((cur_fence = atomic_read(&dev_priv->last_fence_retired))
+		    (((cur_fence = atomic_read_unchecked(&dev_priv->last_fence_retired))
 		      - *sequence) <= (1 << 23)));
 
 	*sequence = cur_fence;
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index fdc1833..f307630 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -285,27 +285,27 @@ static int wait_for_io_cmd_user(struct qxl_device *qdev, uint8_t val, long port,
 	int ret;
 
 	mutex_lock(&qdev->async_io_mutex);
-	irq_num = atomic_read(&qdev->irq_received_io_cmd);
+	irq_num = atomic_read_unchecked(&qdev->irq_received_io_cmd);
 	if (qdev->last_sent_io_cmd > irq_num) {
 		if (intr)
 			ret = wait_event_interruptible_timeout(qdev->io_cmd_event,
-							       atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+							       atomic_read_unchecked(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 		else
 			ret = wait_event_timeout(qdev->io_cmd_event,
-						 atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+						 atomic_read_unchecked(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 		/* 0 is timeout, just bail the "hw" has gone away */
 		if (ret <= 0)
 			goto out;
-		irq_num = atomic_read(&qdev->irq_received_io_cmd);
+		irq_num = atomic_read_unchecked(&qdev->irq_received_io_cmd);
 	}
 	outb(val, addr);
 	qdev->last_sent_io_cmd = irq_num + 1;
 	if (intr)
 		ret = wait_event_interruptible_timeout(qdev->io_cmd_event,
-						       atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+						       atomic_read_unchecked(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 	else
 		ret = wait_event_timeout(qdev->io_cmd_event,
-					 atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+					 atomic_read_unchecked(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 out:
 	if (ret > 0)
 		ret = 0;
diff --git a/drivers/gpu/drm/qxl/qxl_debugfs.c b/drivers/gpu/drm/qxl/qxl_debugfs.c
index 6911b8c..89d6867 100644
--- a/drivers/gpu/drm/qxl/qxl_debugfs.c
+++ b/drivers/gpu/drm/qxl/qxl_debugfs.c
@@ -42,10 +42,10 @@ qxl_debugfs_irq_received(struct seq_file *m, void *data)
 	struct drm_info_node *node = (struct drm_info_node *) m->private;
 	struct qxl_device *qdev = node->minor->dev->dev_private;
 
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_display));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_cursor));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_io_cmd));
+	seq_printf(m, "%d\n", atomic_read_unchecked(&qdev->irq_received));
+	seq_printf(m, "%d\n", atomic_read_unchecked(&qdev->irq_received_display));
+	seq_printf(m, "%d\n", atomic_read_unchecked(&qdev->irq_received_cursor));
+	seq_printf(m, "%d\n", atomic_read_unchecked(&qdev->irq_received_io_cmd));
 	seq_printf(m, "%d\n", qdev->irq_received_error);
 	return 0;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 01a8694..584fb48 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -290,10 +290,10 @@ struct qxl_device {
 	unsigned int last_sent_io_cmd;
 
 	/* interrupt handling */
-	atomic_t irq_received;
-	atomic_t irq_received_display;
-	atomic_t irq_received_cursor;
-	atomic_t irq_received_io_cmd;
+	atomic_unchecked_t irq_received;
+	atomic_unchecked_t irq_received_display;
+	atomic_unchecked_t irq_received_cursor;
+	atomic_unchecked_t irq_received_io_cmd;
 	unsigned irq_received_error;
 	wait_queue_head_t display_event;
 	wait_queue_head_t cursor_event;
diff --git a/drivers/gpu/drm/qxl/qxl_irq.c b/drivers/gpu/drm/qxl/qxl_irq.c
index 0bf1e20..42a7310 100644
--- a/drivers/gpu/drm/qxl/qxl_irq.c
+++ b/drivers/gpu/drm/qxl/qxl_irq.c
@@ -36,19 +36,19 @@ irqreturn_t qxl_irq_handler(int irq, void *arg)
 	if (!pending)
 		return IRQ_NONE;
 
-	atomic_inc(&qdev->irq_received);
+	atomic_inc_unchecked(&qdev->irq_received);
 
 	if (pending & QXL_INTERRUPT_DISPLAY) {
-		atomic_inc(&qdev->irq_received_display);
+		atomic_inc_unchecked(&qdev->irq_received_display);
 		wake_up_all(&qdev->display_event);
 		qxl_queue_garbage_collect(qdev, false);
 	}
 	if (pending & QXL_INTERRUPT_CURSOR) {
-		atomic_inc(&qdev->irq_received_cursor);
+		atomic_inc_unchecked(&qdev->irq_received_cursor);
 		wake_up_all(&qdev->cursor_event);
 	}
 	if (pending & QXL_INTERRUPT_IO_CMD) {
-		atomic_inc(&qdev->irq_received_io_cmd);
+		atomic_inc_unchecked(&qdev->irq_received_io_cmd);
 		wake_up_all(&qdev->io_cmd_event);
 	}
 	if (pending & QXL_INTERRUPT_ERROR) {
@@ -85,10 +85,10 @@ int qxl_irq_init(struct qxl_device *qdev)
 	init_waitqueue_head(&qdev->io_cmd_event);
 	INIT_WORK(&qdev->client_monitors_config_work,
 		  qxl_client_monitors_config_work_func);
-	atomic_set(&qdev->irq_received, 0);
-	atomic_set(&qdev->irq_received_display, 0);
-	atomic_set(&qdev->irq_received_cursor, 0);
-	atomic_set(&qdev->irq_received_io_cmd, 0);
+	atomic_set_unchecked(&qdev->irq_received, 0);
+	atomic_set_unchecked(&qdev->irq_received_display, 0);
+	atomic_set_unchecked(&qdev->irq_received_cursor, 0);
+	atomic_set_unchecked(&qdev->irq_received_io_cmd, 0);
 	qdev->irq_received_error = 0;
 	ret = drm_irq_install(qdev->ddev, qdev->ddev->pdev->irq);
 	qdev->ram_header->int_mask = QXL_INTERRUPT_MASK;
diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index 2c45ac9..5d740f8 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -377,7 +377,7 @@ static int r128_do_init_cce(struct drm_device *dev, drm_r128_init_t *init)
 
 	/* GH: Simple idle check.
 	 */
-	atomic_set(&dev_priv->idle_count, 0);
+	atomic_set_unchecked(&dev_priv->idle_count, 0);
 
 	/* We don't support anything other than bus-mastering ring mode,
 	 * but the ring can be in either AGP or PCI space for the ring
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 723e5d6..102dbaf 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -93,14 +93,14 @@ typedef struct drm_r128_private {
 	int is_pci;
 	unsigned long cce_buffers_offset;
 
-	atomic_t idle_count;
+	atomic_unchecked_t idle_count;
 
 	int page_flipping;
 	int current_page;
 	u32 crtc_offset;
 	u32 crtc_offset_cntl;
 
-	atomic_t vbl_received;
+	atomic_unchecked_t vbl_received;
 
 	u32 color_fmt;
 	unsigned int front_offset;
diff --git a/drivers/gpu/drm/r128/r128_irq.c b/drivers/gpu/drm/r128/r128_irq.c
index c2ae496..30b5993 100644
--- a/drivers/gpu/drm/r128/r128_irq.c
+++ b/drivers/gpu/drm/r128/r128_irq.c
@@ -41,7 +41,7 @@ u32 r128_get_vblank_counter(struct drm_device *dev, int crtc)
 	if (crtc != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_unchecked(&dev_priv->vbl_received);
 }
 
 irqreturn_t r128_driver_irq_handler(int irq, void *arg)
@@ -55,7 +55,7 @@ irqreturn_t r128_driver_irq_handler(int irq, void *arg)
 	/* VBLANK interrupt */
 	if (status & R128_CRTC_VBLANK_INT) {
 		R128_WRITE(R128_GEN_INT_STATUS, R128_CRTC_VBLANK_INT_AK);
-		atomic_inc(&dev_priv->vbl_received);
+		atomic_inc_unchecked(&dev_priv->vbl_received);
 		drm_handle_vblank(dev, 0);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 8fd2d9f..18c9660 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -320,10 +320,10 @@ static void r128_clear_box(drm_r128_private_t *dev_priv,
 
 static void r128_cce_performance_boxes(drm_r128_private_t *dev_priv)
 {
-	if (atomic_read(&dev_priv->idle_count) == 0)
+	if (atomic_read_unchecked(&dev_priv->idle_count) == 0)
 		r128_clear_box(dev_priv, 64, 4, 8, 8, 0, 255, 0);
 	else
-		atomic_set(&dev_priv->idle_count, 0);
+		atomic_set_unchecked(&dev_priv->idle_count, 0);
 }
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_drv.h b/drivers/gpu/drm/radeon/radeon_drv.h
index 46bd393..6ae4719 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -264,7 +264,7 @@ typedef struct drm_radeon_private {
 
 	/* SW interrupt */
 	wait_queue_head_t swi_queue;
-	atomic_t swi_emitted;
+	atomic_unchecked_t swi_emitted;
 	int vblank_crtc;
 	uint32_t irq_enable_reg;
 	uint32_t r500_disp_irq_reg;
diff --git a/drivers/gpu/drm/radeon/radeon_irq.c b/drivers/gpu/drm/radeon/radeon_irq.c
index 244b19b..c19226d 100644
--- a/drivers/gpu/drm/radeon/radeon_irq.c
+++ b/drivers/gpu/drm/radeon/radeon_irq.c
@@ -226,8 +226,8 @@ static int radeon_emit_irq(struct drm_device * dev)
 	unsigned int ret;
 	RING_LOCALS;
 
-	atomic_inc(&dev_priv->swi_emitted);
-	ret = atomic_read(&dev_priv->swi_emitted);
+	atomic_inc_unchecked(&dev_priv->swi_emitted);
+	ret = atomic_read_unchecked(&dev_priv->swi_emitted);
 
 	BEGIN_RING(4);
 	OUT_RING_REG(RADEON_LAST_SWI_REG, ret);
@@ -353,7 +353,7 @@ int radeon_driver_irq_postinstall(struct drm_device *dev)
 	drm_radeon_private_t *dev_priv =
 	    (drm_radeon_private_t *) dev->dev_private;
 
-	atomic_set(&dev_priv->swi_emitted, 0);
+	atomic_set_unchecked(&dev_priv->swi_emitted, 0);
 	init_waitqueue_head(&dev_priv->swi_queue);
 
 	dev->max_vblank_count = 0x001fffff;
diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index ef8c500..01030c8 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -53,7 +53,7 @@ typedef struct drm_via_ring_buffer {
 typedef uint32_t maskarray_t[5];
 
 typedef struct drm_via_irq {
-	atomic_t irq_received;
+	atomic_unchecked_t irq_received;
 	uint32_t pending_mask;
 	uint32_t enable_mask;
 	wait_queue_head_t irq_queue;
@@ -77,7 +77,7 @@ typedef struct drm_via_private {
 	struct timeval last_vblank;
 	int last_vblank_valid;
 	unsigned usec_per_vblank;
-	atomic_t vbl_received;
+	atomic_unchecked_t vbl_received;
 	drm_via_state_t hc_state;
 	char pci_buf[VIA_PCI_BUF_SIZE];
 	const uint32_t *fire_offsets[VIA_FIRE_BUF_SIZE];
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index 1319433..a993b0c 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -101,7 +101,7 @@ u32 via_get_vblank_counter(struct drm_device *dev, int crtc)
 	if (crtc != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_unchecked(&dev_priv->vbl_received);
 }
 
 irqreturn_t via_driver_irq_handler(int irq, void *arg)
@@ -116,8 +116,8 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 
 	status = VIA_READ(VIA_REG_INTERRUPT);
 	if (status & VIA_IRQ_VBLANK_PENDING) {
-		atomic_inc(&dev_priv->vbl_received);
-		if (!(atomic_read(&dev_priv->vbl_received) & 0x0F)) {
+		atomic_inc_unchecked(&dev_priv->vbl_received);
+		if (!(atomic_read_unchecked(&dev_priv->vbl_received) & 0x0F)) {
 			do_gettimeofday(&cur_vblank);
 			if (dev_priv->last_vblank_valid) {
 				dev_priv->usec_per_vblank =
@@ -127,7 +127,7 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 			dev_priv->last_vblank = cur_vblank;
 			dev_priv->last_vblank_valid = 1;
 		}
-		if (!(atomic_read(&dev_priv->vbl_received) & 0xFF)) {
+		if (!(atomic_read_unchecked(&dev_priv->vbl_received) & 0xFF)) {
 			DRM_DEBUG("US per vblank is: %u\n",
 				  dev_priv->usec_per_vblank);
 		}
@@ -137,7 +137,7 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 
 	for (i = 0; i < dev_priv->num_irqs; ++i) {
 		if (status & cur_irq->pending_mask) {
-			atomic_inc(&cur_irq->irq_received);
+			atomic_inc_unchecked(&cur_irq->irq_received);
 			wake_up(&cur_irq->irq_queue);
 			handled = 1;
 			if (dev_priv->irq_map[drm_via_irq_dma0_td] == i)
@@ -242,11 +242,11 @@ via_driver_irq_wait(struct drm_device *dev, unsigned int irq, int force_sequence
 		DRM_WAIT_ON(ret, cur_irq->irq_queue, 3 * HZ,
 			    ((VIA_READ(masks[irq][2]) & masks[irq][3]) ==
 			     masks[irq][4]));
-		cur_irq_sequence = atomic_read(&cur_irq->irq_received);
+		cur_irq_sequence = atomic_read_unchecked(&cur_irq->irq_received);
 	} else {
 		DRM_WAIT_ON(ret, cur_irq->irq_queue, 3 * HZ,
 			    (((cur_irq_sequence =
-			       atomic_read(&cur_irq->irq_received)) -
+			       atomic_read_unchecked(&cur_irq->irq_received)) -
 			      *sequence) <= (1 << 23)));
 	}
 	*sequence = cur_irq_sequence;
@@ -284,7 +284,7 @@ void via_driver_irq_preinstall(struct drm_device *dev)
 		}
 
 		for (i = 0; i < dev_priv->num_irqs; ++i) {
-			atomic_set(&cur_irq->irq_received, 0);
+			atomic_set_unchecked(&cur_irq->irq_received, 0);
 			cur_irq->enable_mask = dev_priv->irq_masks[i][0];
 			cur_irq->pending_mask = dev_priv->irq_masks[i][1];
 			init_waitqueue_head(&cur_irq->irq_queue);
@@ -366,7 +366,7 @@ int via_wait_irq(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	switch (irqwait->request.type & ~VIA_IRQ_FLAGS_MASK) {
 	case VIA_IRQ_RELATIVE:
 		irqwait->request.sequence +=
-			atomic_read(&cur_irq->irq_received);
+			atomic_read_unchecked(&cur_irq->irq_received);
 		irqwait->request.type &= ~_DRM_VBLANK_RELATIVE;
 	case VIA_IRQ_ABSOLUTE:
 		break;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index d8896ed..f5ca485 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -447,7 +447,7 @@ struct vmw_private {
 	 * Fencing and IRQs.
 	 */
 
-	atomic_t marker_seq;
+	atomic_unchecked_t marker_seq;
 	wait_queue_head_t fence_queue;
 	wait_queue_head_t fifo_queue;
 	spinlock_t waiter_lock;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index 39f2b03..004a773 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -152,7 +152,7 @@ int vmw_fifo_init(struct vmw_private *dev_priv, struct vmw_fifo_state *fifo)
 		 (unsigned int) min,
 		 (unsigned int) fifo->capabilities);
 
-	atomic_set(&dev_priv->marker_seq, dev_priv->last_read_seqno);
+	atomic_set_unchecked(&dev_priv->marker_seq, dev_priv->last_read_seqno);
 	iowrite32(dev_priv->last_read_seqno, fifo_mem + SVGA_FIFO_FENCE);
 	vmw_marker_queue_init(&fifo->marker_queue);
 	return vmw_fifo_send_fence(dev_priv, &dummy);
@@ -492,7 +492,7 @@ int vmw_fifo_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 
 	fm = vmw_fifo_reserve(dev_priv, bytes);
 	if (unlikely(fm == NULL)) {
-		*seqno = atomic_read(&dev_priv->marker_seq);
+		*seqno = atomic_read_unchecked(&dev_priv->marker_seq);
 		ret = -ENOMEM;
 		(void)vmw_fallback_wait(dev_priv, false, true, *seqno,
 					false, 3*HZ);
@@ -500,7 +500,7 @@ int vmw_fifo_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 	}
 
 	do {
-		*seqno = atomic_add_return(1, &dev_priv->marker_seq);
+		*seqno = atomic_add_return_unchecked(1, &dev_priv->marker_seq);
 	} while (*seqno == 0);
 
 	if (!(fifo_state->capabilities & SVGA_FIFO_CAP_FENCE)) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
index 9fe9827..0aa2fc0 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
@@ -102,7 +102,7 @@ bool vmw_seqno_passed(struct vmw_private *dev_priv,
 	 * emitted. Then the fence is stale and signaled.
 	 */
 
-	ret = ((atomic_read(&dev_priv->marker_seq) - seqno)
+	ret = ((atomic_read_unchecked(&dev_priv->marker_seq) - seqno)
 	       > VMW_FENCE_WRAP);
 
 	return ret;
@@ -133,7 +133,7 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 
 	if (fifo_idle)
 		down_read(&fifo_state->rwsem);
-	signal_seq = atomic_read(&dev_priv->marker_seq);
+	signal_seq = atomic_read_unchecked(&dev_priv->marker_seq);
 	ret = 0;
 
 	for (;;) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
index efd1ffd..0ae13ca 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
@@ -135,7 +135,7 @@ int vmw_wait_lag(struct vmw_private *dev_priv,
 	while (!vmw_lag_lt(queue, us)) {
 		spin_lock(&queue->lock);
 		if (list_empty(&queue->head))
-			seqno = atomic_read(&dev_priv->marker_seq);
+			seqno = atomic_read_unchecked(&dev_priv->marker_seq);
 		else {
 			marker = list_first_entry(&queue->head,
 						 struct vmw_marker, head);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e6fce23..85949a0 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2550,7 +2550,7 @@ EXPORT_SYMBOL_GPL(hid_ignore);
 
 int hid_add_device(struct hid_device *hdev)
 {
-	static atomic_t id = ATOMIC_INIT(0);
+	static atomic_unchecked_t id = ATOMIC_INIT(0);
 	int ret;
 
 	if (WARN_ON(hdev->status & HID_STAT_ADDED))
@@ -2593,7 +2593,7 @@ int hid_add_device(struct hid_device *hdev)
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
-		     hdev->vendor, hdev->product, atomic_inc_return(&id));
+		     hdev->vendor, hdev->product, atomic_inc_return_unchecked(&id));
 
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 603ce97..7f27468 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -382,7 +382,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	int ret = 0;
 
 	next_gpadl_handle =
-		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
+		(atomic_inc_return_unchecked(&vmbus_connection.next_gpadl_handle) - 1);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 8a725cd..91abaf0 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -469,7 +469,7 @@ MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
 
 module_param(pressure_report_delay, uint, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
-static atomic_t trans_id = ATOMIC_INIT(0);
+static atomic_unchecked_t trans_id = ATOMIC_INIT(0);
 
 static int dm_ring_size = (5 * PAGE_SIZE);
 
@@ -943,7 +943,7 @@ static void hot_add_req(struct work_struct *dummy)
 		pr_info("Memory hot add failed\n");
 
 	dm->state = DM_INITIALIZED;
-	resp.hdr.trans_id = atomic_inc_return(&trans_id);
+	resp.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 	vmbus_sendpacket(dm->dev->channel, &resp,
 			sizeof(struct dm_hot_add_response),
 			(unsigned long)NULL,
@@ -1024,7 +1024,7 @@ static void post_status(struct hv_dynmem_device *dm)
 	memset(&status, 0, sizeof(struct dm_status));
 	status.hdr.type = DM_STATUS_REPORT;
 	status.hdr.size = sizeof(struct dm_status);
-	status.hdr.trans_id = atomic_inc_return(&trans_id);
+	status.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 
 	/*
 	 * The host expects the guest to report free and committed memory.
@@ -1048,7 +1048,7 @@ static void post_status(struct hv_dynmem_device *dm)
 	 * send the status. This can happen if we were interrupted
 	 * after we picked our transaction ID.
 	 */
-	if (status.hdr.trans_id != atomic_read(&trans_id))
+	if (status.hdr.trans_id != atomic_read_unchecked(&trans_id))
 		return;
 
 	/*
@@ -1193,7 +1193,7 @@ static void balloon_up(struct work_struct *dummy)
 		 */
 
 		do {
-			bl_resp->hdr.trans_id = atomic_inc_return(&trans_id);
+			bl_resp->hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 			ret = vmbus_sendpacket(dm_device.dev->channel,
 						bl_resp,
 						bl_resp->hdr.size,
@@ -1239,7 +1239,7 @@ static void balloon_down(struct hv_dynmem_device *dm,
 
 	memset(&resp, 0, sizeof(struct dm_unballoon_response));
 	resp.hdr.type = DM_UNBALLOON_RESPONSE;
-	resp.hdr.trans_id = atomic_inc_return(&trans_id);
+	resp.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 	resp.hdr.size = sizeof(struct dm_unballoon_response);
 
 	vmbus_sendpacket(dm_device.dev->channel, &resp,
@@ -1300,7 +1300,7 @@ static void version_resp(struct hv_dynmem_device *dm,
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
-	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
+	version_req.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 	version_req.version.version = DYNMEM_PROTOCOL_VERSION_WIN7;
 	version_req.is_last_attempt = 1;
 
@@ -1473,7 +1473,7 @@ static int balloon_probe(struct hv_device *dev,
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
-	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
+	version_req.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 	version_req.version.version = DYNMEM_PROTOCOL_VERSION_WIN8;
 	version_req.is_last_attempt = 0;
 
@@ -1504,7 +1504,7 @@ static int balloon_probe(struct hv_device *dev,
 	memset(&cap_msg, 0, sizeof(struct dm_capabilities));
 	cap_msg.hdr.type = DM_CAPABILITIES_REPORT;
 	cap_msg.hdr.size = sizeof(struct dm_capabilities);
-	cap_msg.hdr.trans_id = atomic_inc_return(&trans_id);
+	cap_msg.hdr.trans_id = atomic_inc_return_unchecked(&trans_id);
 
 	cap_msg.caps.cap_bits.balloon = 1;
 	cap_msg.caps.cap_bits.hot_add = 1;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index cddc0c9..2eb587d 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -645,7 +645,7 @@ enum vmbus_connect_state {
 struct vmbus_connection {
 	enum vmbus_connect_state conn_state;
 
-	atomic_t next_gpadl_handle;
+	atomic_unchecked_t next_gpadl_handle;
 
 	struct completion  unload_event;
 	/*
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 497a7f8..3fffedf 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -169,7 +169,7 @@ struct sht15_data {
 	int				supply_uv;
 	bool				supply_uv_valid;
 	struct work_struct		update_supply_work;
-	atomic_t			interrupt_handled;
+	atomic_unchecked_t		interrupt_handled;
 };
 
 /**
@@ -542,13 +542,13 @@ static int sht15_measurement(struct sht15_data *data,
 	ret = gpio_direction_input(data->pdata->gpio_data);
 	if (ret)
 		return ret;
-	atomic_set(&data->interrupt_handled, 0);
+	atomic_set_unchecked(&data->interrupt_handled, 0);
 
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
 	if (gpio_get_value(data->pdata->gpio_data) == 0) {
 		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
 		/* Only relevant if the interrupt hasn't occurred. */
-		if (!atomic_read(&data->interrupt_handled))
+		if (!atomic_read_unchecked(&data->interrupt_handled))
 			schedule_work(&data->read_work);
 	}
 	ret = wait_event_timeout(data->wait_queue,
@@ -820,7 +820,7 @@ static irqreturn_t sht15_interrupt_fired(int irq, void *d)
 
 	/* First disable the interrupt */
 	disable_irq_nosync(irq);
-	atomic_inc(&data->interrupt_handled);
+	atomic_inc_unchecked(&data->interrupt_handled);
 	/* Then schedule a reading work struct */
 	if (data->state != SHT15_READING_NOTHING)
 		schedule_work(&data->read_work);
@@ -842,11 +842,11 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 		 * If not, then start the interrupt again - care here as could
 		 * have gone low in meantime so verify it hasn't!
 		 */
-		atomic_set(&data->interrupt_handled, 0);
+		atomic_set_unchecked(&data->interrupt_handled, 0);
 		enable_irq(gpio_to_irq(data->pdata->gpio_data));
 		/* If still not occurred or another handler was scheduled */
 		if (gpio_get_value(data->pdata->gpio_data)
-		    || atomic_read(&data->interrupt_handled))
+		    || atomic_read_unchecked(&data->interrupt_handled))
 			return;
 	}
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 8be7352..02f9653 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -115,7 +115,7 @@ static char const counter_group_names[CM_COUNTER_GROUPS]
 
 struct cm_counter_group {
 	struct kobject obj;
-	atomic_long_t counter[CM_ATTR_COUNT];
+	atomic_long_unchecked_t counter[CM_ATTR_COUNT];
 };
 
 struct cm_counter_attribute {
@@ -1416,7 +1416,7 @@ static void cm_dup_req_handler(struct cm_work *work,
 	struct ib_mad_send_buf *msg = NULL;
 	int ret;
 
-	atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+	atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 			counter[CM_REQ_COUNTER]);
 
 	/* Quick state check to discard duplicate REQs. */
@@ -1803,7 +1803,7 @@ static void cm_dup_rep_handler(struct cm_work *work)
 	if (!cm_id_priv)
 		return;
 
-	atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+	atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 			counter[CM_REP_COUNTER]);
 	ret = cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg);
 	if (ret)
@@ -1970,7 +1970,7 @@ static int cm_rtu_handler(struct cm_work *work)
 	if (cm_id_priv->id.state != IB_CM_REP_SENT &&
 	    cm_id_priv->id.state != IB_CM_MRA_REP_RCVD) {
 		spin_unlock_irq(&cm_id_priv->lock);
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_RTU_COUNTER]);
 		goto out;
 	}
@@ -2153,7 +2153,7 @@ static int cm_dreq_handler(struct cm_work *work)
 	cm_id_priv = cm_acquire_id(dreq_msg->remote_comm_id,
 				   dreq_msg->local_comm_id);
 	if (!cm_id_priv) {
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_DREQ_COUNTER]);
 		cm_issue_drep(work->port, work->mad_recv_wc);
 		return -EINVAL;
@@ -2178,7 +2178,7 @@ static int cm_dreq_handler(struct cm_work *work)
 	case IB_CM_MRA_REP_RCVD:
 		break;
 	case IB_CM_TIMEWAIT:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_DREQ_COUNTER]);
 		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
 			goto unlock;
@@ -2192,7 +2192,7 @@ static int cm_dreq_handler(struct cm_work *work)
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_DREQ_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_DREQ_COUNTER]);
 		goto unlock;
 	default:
@@ -2559,7 +2559,7 @@ static int cm_mra_handler(struct cm_work *work)
 		    ib_modify_mad(cm_id_priv->av.port->mad_agent,
 				  cm_id_priv->msg, timeout)) {
 			if (cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
-				atomic_long_inc(&work->port->
+				atomic_long_inc_unchecked(&work->port->
 						counter_group[CM_RECV_DUPLICATES].
 						counter[CM_MRA_COUNTER]);
 			goto out;
@@ -2568,7 +2568,7 @@ static int cm_mra_handler(struct cm_work *work)
 		break;
 	case IB_CM_MRA_REQ_RCVD:
 	case IB_CM_MRA_REP_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_MRA_COUNTER]);
 		/* fall through */
 	default:
@@ -2730,7 +2730,7 @@ static int cm_lap_handler(struct cm_work *work)
 	case IB_CM_LAP_IDLE:
 		break;
 	case IB_CM_MRA_LAP_SENT:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_LAP_COUNTER]);
 		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
 			goto unlock;
@@ -2746,7 +2746,7 @@ static int cm_lap_handler(struct cm_work *work)
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_LAP_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_LAP_COUNTER]);
 		goto unlock;
 	default:
@@ -3030,7 +3030,7 @@ static int cm_sidr_req_handler(struct cm_work *work)
 	cur_cm_id_priv = cm_insert_remote_sidr(cm_id_priv);
 	if (cur_cm_id_priv) {
 		spin_unlock_irq(&cm.lock);
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_unchecked(&work->port->counter_group[CM_RECV_DUPLICATES].
 				counter[CM_SIDR_REQ_COUNTER]);
 		goto out; /* Duplicate message. */
 	}
@@ -3245,10 +3245,10 @@ static void cm_send_handler(struct ib_mad_agent *mad_agent,
 	if (!msg->context[0] && (attr_index != CM_REJ_COUNTER))
 		msg->retries = 1;
 
-	atomic_long_add(1 + msg->retries,
+	atomic_long_add_unchecked(1 + msg->retries,
 			&port->counter_group[CM_XMIT].counter[attr_index]);
 	if (msg->retries)
-		atomic_long_add(msg->retries,
+		atomic_long_add_unchecked(msg->retries,
 				&port->counter_group[CM_XMIT_RETRIES].
 				counter[attr_index]);
 
@@ -3474,7 +3474,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	}
 
 	attr_id = be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.attr_id);
-	atomic_long_inc(&port->counter_group[CM_RECV].
+	atomic_long_inc_unchecked(&port->counter_group[CM_RECV].
 			counter[attr_id - CM_ATTR_ID_OFFSET]);
 
 	work = kmalloc(sizeof *work + sizeof(struct ib_sa_path_rec) * paths,
@@ -3717,7 +3717,7 @@ static ssize_t cm_show_counter(struct kobject *obj, struct attribute *attr,
 	cm_attr = container_of(attr, struct cm_counter_attribute, attr);
 
 	return sprintf(buf, "%ld\n",
-		       atomic_long_read(&group->counter[cm_attr->index]));
+		       atomic_long_read_unchecked(&group->counter[cm_attr->index]));
 }
 
 static const struct sysfs_ops cm_counter_ops = {
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index 9f5ad7c..588cd84 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -98,8 +98,8 @@ struct ib_fmr_pool {
 
 	struct task_struct       *thread;
 
-	atomic_t                  req_ser;
-	atomic_t                  flush_ser;
+	atomic_unchecked_t        req_ser;
+	atomic_unchecked_t        flush_ser;
 
 	wait_queue_head_t         force_wait;
 };
@@ -179,10 +179,10 @@ static int ib_fmr_cleanup_thread(void *pool_ptr)
 	struct ib_fmr_pool *pool = pool_ptr;
 
 	do {
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) < 0) {
+		if (atomic_read_unchecked(&pool->flush_ser) - atomic_read_unchecked(&pool->req_ser) < 0) {
 			ib_fmr_batch_release(pool);
 
-			atomic_inc(&pool->flush_ser);
+			atomic_inc_unchecked(&pool->flush_ser);
 			wake_up_interruptible(&pool->force_wait);
 
 			if (pool->flush_function)
@@ -190,7 +190,7 @@ static int ib_fmr_cleanup_thread(void *pool_ptr)
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) >= 0 &&
+		if (atomic_read_unchecked(&pool->flush_ser) - atomic_read_unchecked(&pool->req_ser) >= 0 &&
 		    !kthread_should_stop())
 			schedule();
 		__set_current_state(TASK_RUNNING);
@@ -282,8 +282,8 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 	pool->dirty_watermark = params->dirty_watermark;
 	pool->dirty_len       = 0;
 	spin_lock_init(&pool->pool_lock);
-	atomic_set(&pool->req_ser,   0);
-	atomic_set(&pool->flush_ser, 0);
+	atomic_set_unchecked(&pool->req_ser,   0);
+	atomic_set_unchecked(&pool->flush_ser, 0);
 	init_waitqueue_head(&pool->force_wait);
 
 	pool->thread = kthread_run(ib_fmr_cleanup_thread,
@@ -411,11 +411,11 @@ int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 	}
 	spin_unlock_irq(&pool->pool_lock);
 
-	serial = atomic_inc_return(&pool->req_ser);
+	serial = atomic_inc_return_unchecked(&pool->req_ser);
 	wake_up_process(pool->thread);
 
 	if (wait_event_interruptible(pool->force_wait,
-				     atomic_read(&pool->flush_ser) - serial >= 0))
+				     atomic_read_unchecked(&pool->flush_ser) - serial >= 0))
 		return -EINTR;
 
 	return 0;
@@ -525,7 +525,7 @@ int ib_fmr_pool_unmap(struct ib_pool_fmr *fmr)
 		} else {
 			list_add_tail(&fmr->list, &pool->dirty_list);
 			if (++pool->dirty_len >= pool->dirty_watermark) {
-				atomic_inc(&pool->req_ser);
+				atomic_inc_unchecked(&pool->req_ser);
 				wake_up_process(pool->thread);
 			}
 		}
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index cff815b..75576dd 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -256,7 +256,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	int err;
 	struct fw_ri_tpte tpt;
 	u32 stag_idx;
-	static atomic_t key;
+	static atomic_unchecked_t key;
 
 	if (c4iw_fatal_error(rdev))
 		return -EIO;
@@ -277,7 +277,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 		if (rdev->stats.stag.cur > rdev->stats.stag.max)
 			rdev->stats.stag.max = rdev->stats.stag.cur;
 		mutex_unlock(&rdev->stats.lock);
-		*stag = (stag_idx << 8) | (atomic_inc_return(&key) & 0xff);
+		*stag = (stag_idx << 8) | (atomic_inc_return_unchecked(&key) & 0xff);
 	}
 	PDBG("%s stag_state 0x%0x type 0x%0x pdid 0x%0x, stag_idx 0x%x\n",
 	     __func__, stag_state, type, pdid, stag_idx);
diff --git a/drivers/infiniband/hw/ipath/ipath_rc.c b/drivers/infiniband/hw/ipath/ipath_rc.c
index 79b3dbc..96e5fcc 100644
--- a/drivers/infiniband/hw/ipath/ipath_rc.c
+++ b/drivers/infiniband/hw/ipath/ipath_rc.c
@@ -1868,7 +1868,7 @@ void ipath_rc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 		struct ib_atomic_eth *ateth;
 		struct ipath_ack_entry *e;
 		u64 vaddr;
-		atomic64_t *maddr;
+		atomic64_unchecked_t *maddr;
 		u64 sdata;
 		u32 rkey;
 		u8 next;
@@ -1903,11 +1903,11 @@ void ipath_rc_rcv(struct ipath_ibdev *dev, struct ipath_ib_header *hdr,
 					    IB_ACCESS_REMOTE_ATOMIC)))
 			goto nack_acc_unlck;
 		/* Perform atomic OP and save result. */
-		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
+		maddr = (atomic64_unchecked_t *) qp->r_sge.sge.vaddr;
 		sdata = be64_to_cpu(ateth->swap_data);
 		e = &qp->s_ack_queue[qp->r_head_ack_queue];
 		e->atomic_data = (opcode == OP(FETCH_ADD)) ?
-			(u64) atomic64_add_return(sdata, maddr) - sdata :
+			(u64) atomic64_add_return_unchecked(sdata, maddr) - sdata :
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      be64_to_cpu(ateth->compare_data),
 				      sdata);
diff --git a/drivers/infiniband/hw/ipath/ipath_ruc.c b/drivers/infiniband/hw/ipath/ipath_ruc.c
index 1f95bba..9530f87 100644
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c
@@ -266,7 +266,7 @@ static void ipath_ruc_loopback(struct ipath_qp *sqp)
 	unsigned long flags;
 	struct ib_wc wc;
 	u64 sdata;
-	atomic64_t *maddr;
+	atomic64_unchecked_t *maddr;
 	enum ib_wc_status send_status;
 
 	/*
@@ -382,11 +382,11 @@ again:
 					    IB_ACCESS_REMOTE_ATOMIC)))
 			goto acc_err;
 		/* Perform atomic OP and save result. */
-		maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
+		maddr = (atomic64_unchecked_t *) qp->r_sge.sge.vaddr;
 		sdata = wqe->wr.wr.atomic.compare_add;
 		*(u64 *) sqp->s_sge.sge.vaddr =
 			(wqe->wr.opcode == IB_WR_ATOMIC_FETCH_AND_ADD) ?
-			(u64) atomic64_add_return(sdata, maddr) - sdata :
+			(u64) atomic64_add_return_unchecked(sdata, maddr) - sdata :
 			(u64) cmpxchg((u64 *) qp->r_sge.sge.vaddr,
 				      sdata, wqe->wr.wr.atomic.swap);
 		goto send_comp;
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 68b3dfa..3e0c511 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -98,7 +98,7 @@ __be64 mlx4_ib_gen_node_guid(void)
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
 {
-	return cpu_to_be64(atomic_inc_return(&ctx->tid)) |
+	return cpu_to_be64(atomic_inc_return_unchecked(&ctx->tid)) |
 		cpu_to_be64(0xff00000000000000LL);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index a0559a8..86a2320 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1042,7 +1042,7 @@ int mlx4_ib_mcg_port_init(struct mlx4_ib_demux_ctx *ctx)
 {
 	char name[20];
 
-	atomic_set(&ctx->tid, 0);
+	atomic_set_unchecked(&ctx->tid, 0);
 	sprintf(name, "mlx4_ib_mcg%d", ctx->port);
 	ctx->mcg_wq = create_singlethread_workqueue(name);
 	if (!ctx->mcg_wq)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 334387f..e640d74 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -436,7 +436,7 @@ struct mlx4_ib_demux_ctx {
 	struct list_head	mcg_mgid0_list;
 	struct workqueue_struct	*mcg_wq;
 	struct mlx4_ib_demux_pv_ctx **tun;
-	atomic_t tid;
+	atomic_unchecked_t tid;
 	int    flushing; /* flushing the work queue */
 };
 
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 9f9d5c5..3c19aac 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(limit_maxrdreqsz, "Limit max read request size to 256 Bytes");
 LIST_HEAD(nes_adapter_list);
 static LIST_HEAD(nes_dev_list);
 
-atomic_t qps_destroyed;
+atomic_unchecked_t qps_destroyed;
 
 static unsigned int ee_flsh_adapter;
 static unsigned int sysfs_nonidx_addr;
@@ -279,7 +279,7 @@ static void nes_cqp_rem_ref_callback(struct nes_device *nesdev, struct nes_cqp_r
 	struct nes_qp *nesqp = cqp_request->cqp_callback_pointer;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 
-	atomic_inc(&qps_destroyed);
+	atomic_inc_unchecked(&qps_destroyed);
 
 	/* Free the control structures */
 
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index bd9d132..70d84f4 100644
--- a/drivers/infiniband/hw/nes/nes.h
+++ b/drivers/infiniband/hw/nes/nes.h
@@ -180,17 +180,17 @@ extern unsigned int nes_debug_level;
 extern unsigned int wqm_quanta;
 extern struct list_head nes_adapter_list;
 
-extern atomic_t cm_connects;
-extern atomic_t cm_accepts;
-extern atomic_t cm_disconnects;
-extern atomic_t cm_closes;
-extern atomic_t cm_connecteds;
-extern atomic_t cm_connect_reqs;
-extern atomic_t cm_rejects;
-extern atomic_t mod_qp_timouts;
-extern atomic_t qps_created;
-extern atomic_t qps_destroyed;
-extern atomic_t sw_qps_destroyed;
+extern atomic_unchecked_t cm_connects;
+extern atomic_unchecked_t cm_accepts;
+extern atomic_unchecked_t cm_disconnects;
+extern atomic_unchecked_t cm_closes;
+extern atomic_unchecked_t cm_connecteds;
+extern atomic_unchecked_t cm_connect_reqs;
+extern atomic_unchecked_t cm_rejects;
+extern atomic_unchecked_t mod_qp_timouts;
+extern atomic_unchecked_t qps_created;
+extern atomic_unchecked_t qps_destroyed;
+extern atomic_unchecked_t sw_qps_destroyed;
 extern u32 mh_detected;
 extern u32 mh_pauses_sent;
 extern u32 cm_packets_sent;
@@ -199,16 +199,16 @@ extern u32 cm_packets_created;
 extern u32 cm_packets_received;
 extern u32 cm_packets_dropped;
 extern u32 cm_packets_retrans;
-extern atomic_t cm_listens_created;
-extern atomic_t cm_listens_destroyed;
+extern atomic_unchecked_t cm_listens_created;
+extern atomic_unchecked_t cm_listens_destroyed;
 extern u32 cm_backlog_drops;
-extern atomic_t cm_loopbacks;
-extern atomic_t cm_nodes_created;
-extern atomic_t cm_nodes_destroyed;
-extern atomic_t cm_accel_dropped_pkts;
-extern atomic_t cm_resets_recvd;
-extern atomic_t pau_qps_created;
-extern atomic_t pau_qps_destroyed;
+extern atomic_unchecked_t cm_loopbacks;
+extern atomic_unchecked_t cm_nodes_created;
+extern atomic_unchecked_t cm_nodes_destroyed;
+extern atomic_unchecked_t cm_accel_dropped_pkts;
+extern atomic_unchecked_t cm_resets_recvd;
+extern atomic_unchecked_t pau_qps_created;
+extern atomic_unchecked_t pau_qps_destroyed;
 
 extern u32 int_mod_timer_init;
 extern u32 int_mod_cq_depth_256;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 8a3ad17..e805492 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -69,14 +69,14 @@ u32 cm_packets_dropped;
 u32 cm_packets_retrans;
 u32 cm_packets_created;
 u32 cm_packets_received;
-atomic_t cm_listens_created;
-atomic_t cm_listens_destroyed;
+atomic_unchecked_t cm_listens_created;
+atomic_unchecked_t cm_listens_destroyed;
 u32 cm_backlog_drops;
-atomic_t cm_loopbacks;
-atomic_t cm_nodes_created;
-atomic_t cm_nodes_destroyed;
-atomic_t cm_accel_dropped_pkts;
-atomic_t cm_resets_recvd;
+atomic_unchecked_t cm_loopbacks;
+atomic_unchecked_t cm_nodes_created;
+atomic_unchecked_t cm_nodes_destroyed;
+atomic_unchecked_t cm_accel_dropped_pkts;
+atomic_unchecked_t cm_resets_recvd;
 
 static inline int mini_cm_accelerated(struct nes_cm_core *, struct nes_cm_node *);
 static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *, struct nes_vnic *, struct nes_cm_info *);
@@ -150,13 +150,13 @@ static struct nes_cm_ops nes_cm_api = {
 
 static struct nes_cm_core *g_cm_core;
 
-atomic_t cm_connects;
-atomic_t cm_accepts;
-atomic_t cm_disconnects;
-atomic_t cm_closes;
-atomic_t cm_connecteds;
-atomic_t cm_connect_reqs;
-atomic_t cm_rejects;
+atomic_unchecked_t cm_connects;
+atomic_unchecked_t cm_accepts;
+atomic_unchecked_t cm_disconnects;
+atomic_unchecked_t cm_closes;
+atomic_unchecked_t cm_connecteds;
+atomic_unchecked_t cm_connect_reqs;
+atomic_unchecked_t cm_rejects;
 
 int nes_add_ref_cm_node(struct nes_cm_node *cm_node)
 {
@@ -1461,7 +1461,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 		kfree(listener);
 		listener = NULL;
 		ret = 0;
-		atomic_inc(&cm_listens_destroyed);
+		atomic_inc_unchecked(&cm_listens_destroyed);
 	} else {
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 	}
@@ -1670,7 +1670,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 		  cm_node->rem_mac);
 
 	add_hte_node(cm_core, cm_node);
-	atomic_inc(&cm_nodes_created);
+	atomic_inc_unchecked(&cm_nodes_created);
 
 	return cm_node;
 }
@@ -1731,7 +1731,7 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
 	}
 
 	atomic_dec(&cm_core->node_cnt);
-	atomic_inc(&cm_nodes_destroyed);
+	atomic_inc_unchecked(&cm_nodes_destroyed);
 	nesqp = cm_node->nesqp;
 	if (nesqp) {
 		nesqp->cm_node = NULL;
@@ -1795,7 +1795,7 @@ static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc,
 
 static void drop_packet(struct sk_buff *skb)
 {
-	atomic_inc(&cm_accel_dropped_pkts);
+	atomic_inc_unchecked(&cm_accel_dropped_pkts);
 	dev_kfree_skb_any(skb);
 }
 
@@ -1858,7 +1858,7 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 {
 
 	int	reset = 0;	/* whether to send reset in case of err.. */
-	atomic_inc(&cm_resets_recvd);
+	atomic_inc_unchecked(&cm_resets_recvd);
 	nes_debug(NES_DBG_CM, "Received Reset, cm_node = %p, state = %u."
 			" refcnt=%d\n", cm_node, cm_node->state,
 			atomic_read(&cm_node->ref_count));
@@ -2526,7 +2526,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 				rem_ref_cm_node(cm_node->cm_core, cm_node);
 				return NULL;
 			}
-			atomic_inc(&cm_loopbacks);
+			atomic_inc_unchecked(&cm_loopbacks);
 			loopbackremotenode->loopbackpartner = cm_node;
 			loopbackremotenode->tcp_cntxt.rcv_wscale =
 				NES_CM_DEFAULT_RCV_WND_SCALE;
@@ -2807,7 +2807,7 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 				nes_queue_mgt_skbs(skb, nesvnic, cm_node->nesqp);
 			else {
 				rem_ref_cm_node(cm_core, cm_node);
-				atomic_inc(&cm_accel_dropped_pkts);
+				atomic_inc_unchecked(&cm_accel_dropped_pkts);
 				dev_kfree_skb_any(skb);
 			}
 			break;
@@ -3118,7 +3118,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 
 	if ((cm_id) && (cm_id->event_handler)) {
 		if (issue_disconn) {
-			atomic_inc(&cm_disconnects);
+			atomic_inc_unchecked(&cm_disconnects);
 			cm_event.event = IW_CM_EVENT_DISCONNECT;
 			cm_event.status = disconn_status;
 			cm_event.local_addr = cm_id->local_addr;
@@ -3140,7 +3140,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 		}
 
 		if (issue_close) {
-			atomic_inc(&cm_closes);
+			atomic_inc_unchecked(&cm_closes);
 			nes_disconnect(nesqp, 1);
 
 			cm_id->provider_data = nesqp;
@@ -3278,7 +3278,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	nes_debug(NES_DBG_CM, "QP%u, cm_node=%p, jiffies = %lu listener = %p\n",
 		nesqp->hwqp.qp_id, cm_node, jiffies, cm_node->listener);
-	atomic_inc(&cm_accepts);
+	atomic_inc_unchecked(&cm_accepts);
 
 	nes_debug(NES_DBG_CM, "netdev refcnt = %u.\n",
 			netdev_refcnt_read(nesvnic->netdev));
@@ -3476,7 +3476,7 @@ int nes_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	struct nes_cm_core *cm_core;
 	u8 *start_buff;
 
-	atomic_inc(&cm_rejects);
+	atomic_inc_unchecked(&cm_rejects);
 	cm_node = (struct nes_cm_node *)cm_id->provider_data;
 	loopback = cm_node->loopbackpartner;
 	cm_core = cm_node->cm_core;
@@ -3541,7 +3541,7 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		  ntohs(raddr->sin_port), ntohl(laddr->sin_addr.s_addr),
 		  ntohs(laddr->sin_port));
 
-	atomic_inc(&cm_connects);
+	atomic_inc_unchecked(&cm_connects);
 	nesqp->active_conn = 1;
 
 	/* cache the cm_id in the qp */
@@ -3688,7 +3688,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 			g_cm_core->api->stop_listener(g_cm_core, (void *)cm_node);
 			return err;
 		}
-		atomic_inc(&cm_listens_created);
+		atomic_inc_unchecked(&cm_listens_created);
 	}
 
 	cm_id->add_ref(cm_id);
@@ -3795,7 +3795,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	if (nesqp->destroyed)
 		return;
-	atomic_inc(&cm_connecteds);
+	atomic_inc_unchecked(&cm_connecteds);
 	nes_debug(NES_DBG_CM, "QP%u attempting to connect to  0x%08X:0x%04X on"
 		  " local port 0x%04X. jiffies = %lu.\n",
 		  nesqp->hwqp.qp_id, ntohl(raddr->sin_addr.s_addr),
@@ -3980,7 +3980,7 @@ static void cm_event_reset(struct nes_cm_event *event)
 
 	cm_id->add_ref(cm_id);
 	ret = cm_id->event_handler(cm_id, &cm_event);
-	atomic_inc(&cm_closes);
+	atomic_inc_unchecked(&cm_closes);
 	cm_event.event = IW_CM_EVENT_CLOSE;
 	cm_event.status = 0;
 	cm_event.provider_data = cm_id->provider_data;
@@ -4020,7 +4020,7 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 		return;
 	cm_id = cm_node->cm_id;
 
-	atomic_inc(&cm_connect_reqs);
+	atomic_inc_unchecked(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
 		  cm_node, cm_id, jiffies);
 
@@ -4069,7 +4069,7 @@ static void cm_event_mpa_reject(struct nes_cm_event *event)
 		return;
 	cm_id = cm_node->cm_id;
 
-	atomic_inc(&cm_connect_reqs);
+	atomic_inc_unchecked(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
 		  cm_node, cm_id, jiffies);
 
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 4166452..fc952c3 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -40,8 +40,8 @@
 #include "nes.h"
 #include "nes_mgt.h"
 
-atomic_t pau_qps_created;
-atomic_t pau_qps_destroyed;
+atomic_unchecked_t pau_qps_created;
+atomic_unchecked_t pau_qps_destroyed;
 
 static void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
 {
@@ -621,7 +621,7 @@ void nes_destroy_pau_qp(struct nes_device *nesdev, struct nes_qp *nesqp)
 {
 	struct sk_buff *skb;
 	unsigned long flags;
-	atomic_inc(&pau_qps_destroyed);
+	atomic_inc_unchecked(&pau_qps_destroyed);
 
 	/* Free packets that have not yet been forwarded */
 	/* Lock is acquired by skb_dequeue when removing the skb */
@@ -810,7 +810,7 @@ static void nes_mgt_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *
 					cq->cq_vbase[head].cqe_words[NES_NIC_CQE_HASH_RCVNXT]);
 				skb_queue_head_init(&nesqp->pau_list);
 				spin_lock_init(&nesqp->pau_lock);
-				atomic_inc(&pau_qps_created);
+				atomic_inc_unchecked(&pau_qps_created);
 				nes_change_quad_hash(nesdev, mgtvnic->nesvnic, nesqp);
 			}
 
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 70acda9..a96de9d 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1274,39 +1274,39 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
 	target_stat_values[++index] = mh_detected;
 	target_stat_values[++index] = mh_pauses_sent;
 	target_stat_values[++index] = nesvnic->endnode_ipv4_tcp_retransmits;
-	target_stat_values[++index] = atomic_read(&cm_connects);
-	target_stat_values[++index] = atomic_read(&cm_accepts);
-	target_stat_values[++index] = atomic_read(&cm_disconnects);
-	target_stat_values[++index] = atomic_read(&cm_connecteds);
-	target_stat_values[++index] = atomic_read(&cm_connect_reqs);
-	target_stat_values[++index] = atomic_read(&cm_rejects);
-	target_stat_values[++index] = atomic_read(&mod_qp_timouts);
-	target_stat_values[++index] = atomic_read(&qps_created);
-	target_stat_values[++index] = atomic_read(&sw_qps_destroyed);
-	target_stat_values[++index] = atomic_read(&qps_destroyed);
-	target_stat_values[++index] = atomic_read(&cm_closes);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_connects);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_accepts);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_disconnects);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_connecteds);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_connect_reqs);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_rejects);
+	target_stat_values[++index] = atomic_read_unchecked(&mod_qp_timouts);
+	target_stat_values[++index] = atomic_read_unchecked(&qps_created);
+	target_stat_values[++index] = atomic_read_unchecked(&sw_qps_destroyed);
+	target_stat_values[++index] = atomic_read_unchecked(&qps_destroyed);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_closes);
 	target_stat_values[++index] = cm_packets_sent;
 	target_stat_values[++index] = cm_packets_bounced;
 	target_stat_values[++index] = cm_packets_created;
 	target_stat_values[++index] = cm_packets_received;
 	target_stat_values[++index] = cm_packets_dropped;
 	target_stat_values[++index] = cm_packets_retrans;
-	target_stat_values[++index] = atomic_read(&cm_listens_created);
-	target_stat_values[++index] = atomic_read(&cm_listens_destroyed);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_listens_created);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_listens_destroyed);
 	target_stat_values[++index] = cm_backlog_drops;
-	target_stat_values[++index] = atomic_read(&cm_loopbacks);
-	target_stat_values[++index] = atomic_read(&cm_nodes_created);
-	target_stat_values[++index] = atomic_read(&cm_nodes_destroyed);
-	target_stat_values[++index] = atomic_read(&cm_accel_dropped_pkts);
-	target_stat_values[++index] = atomic_read(&cm_resets_recvd);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_loopbacks);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_nodes_created);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_nodes_destroyed);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_accel_dropped_pkts);
+	target_stat_values[++index] = atomic_read_unchecked(&cm_resets_recvd);
 	target_stat_values[++index] = nesadapter->free_4kpbl;
 	target_stat_values[++index] = nesadapter->free_256pbl;
 	target_stat_values[++index] = int_mod_timer_init;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.aggregated;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.flushed;
 	target_stat_values[++index] = nesvnic->lro_mgr.stats.no_desc;
-	target_stat_values[++index] = atomic_read(&pau_qps_created);
-	target_stat_values[++index] = atomic_read(&pau_qps_destroyed);
+	target_stat_values[++index] = atomic_read_unchecked(&pau_qps_created);
+	target_stat_values[++index] = atomic_read_unchecked(&pau_qps_destroyed);
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index fbc43e5..3672792 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -46,9 +46,9 @@
 
 #include <rdma/ib_umem.h>
 
-atomic_t mod_qp_timouts;
-atomic_t qps_created;
-atomic_t sw_qps_destroyed;
+atomic_unchecked_t mod_qp_timouts;
+atomic_unchecked_t qps_created;
+atomic_unchecked_t sw_qps_destroyed;
 
 static void nes_unregister_ofa_device(struct nes_ib_device *nesibdev);
 
@@ -1137,7 +1137,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	if (init_attr->create_flags)
 		return ERR_PTR(-EINVAL);
 
-	atomic_inc(&qps_created);
+	atomic_inc_unchecked(&qps_created);
 	switch (init_attr->qp_type) {
 		case IB_QPT_RC:
 			if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) {
@@ -1471,7 +1471,7 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 	struct iw_cm_event cm_event;
 	int ret = 0;
 
-	atomic_inc(&sw_qps_destroyed);
+	atomic_inc_unchecked(&sw_qps_destroyed);
 	nesqp->destroyed = 1;
 
 	/* Blow away the connection if it exists. */
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index e853a21..56fc5a8 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -527,14 +527,14 @@ EXPORT_SYMBOL(gameport_set_phys);
  */
 static void gameport_init_port(struct gameport *gameport)
 {
-	static atomic_t gameport_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t gameport_no = ATOMIC_INIT(-1);
 
 	__module_get(THIS_MODULE);
 
 	mutex_init(&gameport->drv_mutex);
 	device_initialize(&gameport->dev);
 	dev_set_name(&gameport->dev, "gameport%lu",
-			(unsigned long)atomic_inc_return(&gameport_no));
+			(unsigned long)atomic_inc_return_unchecked(&gameport_no));
 	gameport->dev.bus = &gameport_bus;
 	gameport->dev.release = gameport_release_port;
 	if (gameport->parent)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index 78d2499..1f0318e 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1775,7 +1775,7 @@ EXPORT_SYMBOL_GPL(input_class);
  */
 struct input_dev *input_allocate_device(void)
 {
-	static atomic_t input_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t input_no = ATOMIC_INIT(-1);
 	struct input_dev *dev;
 
 	dev = kzalloc(sizeof(struct input_dev), GFP_KERNEL);
@@ -1790,7 +1790,7 @@ struct input_dev *input_allocate_device(void)
 		INIT_LIST_HEAD(&dev->node);
 
 		dev_set_name(&dev->dev, "input%lu",
-			     (unsigned long)atomic_inc_return(&input_no));
+			     (unsigned long)atomic_inc_return_unchecked(&input_no));
 
 		__module_get(THIS_MODULE);
 	}
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index f8850f9..9708a2d 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -959,7 +959,7 @@ static void xpad_led_set(struct led_classdev *led_cdev,
 
 static int xpad_led_probe(struct usb_xpad *xpad)
 {
-	static atomic_t led_seq = ATOMIC_INIT(-1);
+	static atomic_unchecked_t led_seq = ATOMIC_INIT(-1);
 	struct xpad_led *led;
 	struct led_classdev *led_cdev;
 	int error;
@@ -971,7 +971,7 @@ static int xpad_led_probe(struct usb_xpad *xpad)
 	if (!led)
 		return -ENOMEM;
 
-	xpad->led_no = atomic_inc_return(&led_seq);
+	xpad->led_no = atomic_inc_return_unchecked(&led_seq);
 
 	snprintf(led->name, sizeof(led->name), "xpad%lu", xpad->led_no);
 	led->xpad = xpad;
diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index ac1fa5f..5f7502c 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1851,7 +1851,7 @@ static int ims_pcu_identify_type(struct ims_pcu *pcu, u8 *device_id)
 
 static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 {
-	static atomic_t device_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t device_no = ATOMIC_INIT(-1);
 
 	const struct ims_pcu_device_info *info;
 	int error;
@@ -1882,7 +1882,7 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 	}
 
 	/* Device appears to be operable, complete initialization */
-	pcu->device_no = atomic_inc_return(&device_no);
+	pcu->device_no = atomic_inc_return_unchecked(&device_no);
 
 	/*
 	 * PCU-B devices, both GEN_1 and GEN_2 do not have OFN sensor
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index a05a517..323a2fd 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -514,7 +514,7 @@ static void serio_release_port(struct device *dev)
  */
 static void serio_init_port(struct serio *serio)
 {
-	static atomic_t serio_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t serio_no = ATOMIC_INIT(-1);
 
 	__module_get(THIS_MODULE);
 
@@ -525,7 +525,7 @@ static void serio_init_port(struct serio *serio)
 	mutex_init(&serio->drv_mutex);
 	device_initialize(&serio->dev);
 	dev_set_name(&serio->dev, "serio%lu",
-		     (unsigned long)atomic_inc_return(&serio_no));
+		     (unsigned long)atomic_inc_return_unchecked(&serio_no));
 	serio->dev.bus = &serio_bus;
 	serio->dev.release = serio_release_port;
 	serio->dev.groups = serio_device_attr_groups;
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 71ef5d6..93380a9 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -292,7 +292,7 @@ static irqreturn_t serio_raw_interrupt(struct serio *serio, unsigned char data,
 
 static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 {
-	static atomic_t serio_raw_no = ATOMIC_INIT(-1);
+	static atomic_unchecked_t serio_raw_no = ATOMIC_INIT(-1);
 	struct serio_raw *serio_raw;
 	int err;
 
@@ -303,7 +303,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	snprintf(serio_raw->name, sizeof(serio_raw->name),
-		 "serio_raw%ld", (long)atomic_inc_return(&serio_raw_no));
+		 "serio_raw%ld", (long)atomic_inc_return_unchecked(&serio_raw_no));
 	kref_init(&serio_raw->kref);
 	INIT_LIST_HEAD(&serio_raw->client_list);
 	init_waitqueue_head(&serio_raw->wait);
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6a2df32..dc962f1 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -81,8 +81,8 @@ struct capiminor {
 
 	struct capi20_appl	*ap;
 	u32			ncci;
-	atomic_t		datahandle;
-	atomic_t		msgid;
+	atomic_unchecked_t	datahandle;
+	atomic_unchecked_t	msgid;
 
 	struct tty_port port;
 	int                ttyinstop;
@@ -391,7 +391,7 @@ gen_data_b3_resp_for(struct capiminor *mp, struct sk_buff *skb)
 		capimsg_setu16(s, 2, mp->ap->applid);
 		capimsg_setu8 (s, 4, CAPI_DATA_B3);
 		capimsg_setu8 (s, 5, CAPI_RESP);
-		capimsg_setu16(s, 6, atomic_inc_return(&mp->msgid));
+		capimsg_setu16(s, 6, atomic_inc_return_unchecked(&mp->msgid));
 		capimsg_setu32(s, 8, mp->ncci);
 		capimsg_setu16(s, 12, datahandle);
 	}
@@ -512,14 +512,14 @@ static void handle_minor_send(struct capiminor *mp)
 		mp->outbytes -= len;
 		spin_unlock_bh(&mp->outlock);
 
-		datahandle = atomic_inc_return(&mp->datahandle);
+		datahandle = atomic_inc_return_unchecked(&mp->datahandle);
 		skb_push(skb, CAPI_DATA_B3_REQ_LEN);
 		memset(skb->data, 0, CAPI_DATA_B3_REQ_LEN);
 		capimsg_setu16(skb->data, 0, CAPI_DATA_B3_REQ_LEN);
 		capimsg_setu16(skb->data, 2, mp->ap->applid);
 		capimsg_setu8 (skb->data, 4, CAPI_DATA_B3);
 		capimsg_setu8 (skb->data, 5, CAPI_REQ);
-		capimsg_setu16(skb->data, 6, atomic_inc_return(&mp->msgid));
+		capimsg_setu16(skb->data, 6, atomic_inc_return_unchecked(&mp->msgid));
 		capimsg_setu32(skb->data, 8, mp->ncci);	/* NCCI */
 		capimsg_setu32(skb->data, 12, (u32)(long)skb->data);/* Data32 */
 		capimsg_setu16(skb->data, 16, len);	/* Data length */
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index d83696b..44f22f7 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -42,7 +42,7 @@ enum dm_raid1_error {
 
 struct mirror {
 	struct mirror_set *ms;
-	atomic_t error_count;
+	atomic_unchecked_t error_count;
 	unsigned long error_type;
 	struct dm_dev *dev;
 	sector_t offset;
@@ -188,7 +188,7 @@ static struct mirror *get_valid_mirror(struct mirror_set *ms)
 	struct mirror *m;
 
 	for (m = ms->mirror; m < ms->mirror + ms->nr_mirrors; m++)
-		if (!atomic_read(&m->error_count))
+		if (!atomic_read_unchecked(&m->error_count))
 			return m;
 
 	return NULL;
@@ -220,7 +220,7 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 	 * simple way to tell if a device has encountered
 	 * errors.
 	 */
-	atomic_inc(&m->error_count);
+	atomic_inc_unchecked(&m->error_count);
 
 	if (test_and_set_bit(error_type, &m->error_type))
 		return;
@@ -378,7 +378,7 @@ static void reset_ms_flags(struct mirror_set *ms)
 
 	ms->leg_failure = 0;
 	for (m = 0; m < ms->nr_mirrors; m++) {
-		atomic_set(&(ms->mirror[m].error_count), 0);
+		atomic_set_unchecked(&(ms->mirror[m].error_count), 0);
 		ms->mirror[m].error_type = 0;
 	}
 }
@@ -423,7 +423,7 @@ static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 	struct mirror *m = get_default_mirror(ms);
 
 	do {
-		if (likely(!atomic_read(&m->error_count)))
+		if (likely(!atomic_read_unchecked(&m->error_count)))
 			return m;
 
 		if (m-- == ms->mirror)
@@ -437,7 +437,7 @@ static int default_ok(struct mirror *m)
 {
 	struct mirror *default_mirror = get_default_mirror(m->ms);
 
-	return !atomic_read(&default_mirror->error_count);
+	return !atomic_read_unchecked(&default_mirror->error_count);
 }
 
 static int mirror_available(struct mirror_set *ms, struct bio *bio)
@@ -574,7 +574,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 		 */
 		if (likely(region_in_sync(ms, region, 1)))
 			m = choose_mirror(ms, bio->bi_iter.bi_sector);
-		else if (m && atomic_read(&m->error_count))
+		else if (m && atomic_read_unchecked(&m->error_count))
 			m = NULL;
 
 		if (likely(m))
@@ -956,7 +956,7 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 	}
 
 	ms->mirror[mirror].ms = ms;
-	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	atomic_set_unchecked(&(ms->mirror[mirror].error_count), 0);
 	ms->mirror[mirror].error_type = 0;
 	ms->mirror[mirror].offset = offset;
 
@@ -1380,7 +1380,7 @@ static void mirror_resume(struct dm_target *ti)
  */
 static char device_status_char(struct mirror *m)
 {
-	if (!atomic_read(&(m->error_count)))
+	if (!atomic_read_unchecked(&(m->error_count)))
 		return 'A';
 
 	return (test_bit(DM_RAID1_FLUSH_ERROR, &(m->error_type))) ? 'F' :
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a672a15..dc85e99 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -21,7 +21,7 @@ struct stripe {
 	struct dm_dev *dev;
 	sector_t physical_start;
 
-	atomic_t error_count;
+	atomic_unchecked_t error_count;
 };
 
 struct stripe_c {
@@ -188,7 +188,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			kfree(sc);
 			return r;
 		}
-		atomic_set(&(sc->stripe[i].error_count), 0);
+		atomic_set_unchecked(&(sc->stripe[i].error_count), 0);
 	}
 
 	ti->private = sc;
@@ -332,7 +332,7 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%d ", sc->stripes);
 		for (i = 0; i < sc->stripes; i++)  {
 			DMEMIT("%s ", sc->stripe[i].dev->name);
-			buffer[i] = atomic_read(&(sc->stripe[i].error_count)) ?
+			buffer[i] = atomic_read_unchecked(&(sc->stripe[i].error_count)) ?
 				'D' : 'A';
 		}
 		buffer[i] = '\0';
@@ -377,8 +377,8 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
 	 */
 	for (i = 0; i < sc->stripes; i++)
 		if (!strcmp(sc->stripe[i].dev->name, major_minor)) {
-			atomic_inc(&(sc->stripe[i].error_count));
-			if (atomic_read(&(sc->stripe[i].error_count)) <
+			atomic_inc_unchecked(&(sc->stripe[i].error_count));
+			if (atomic_read_unchecked(&(sc->stripe[i].error_count)) <
 			    DM_IO_ERROR_THRESHOLD)
 				schedule_work(&sc->trigger_event);
 		}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3e32f4e..01e0a7f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -194,9 +194,9 @@ struct mapped_device {
 	/*
 	 * Event handling.
 	 */
-	atomic_t event_nr;
+	atomic_unchecked_t event_nr;
 	wait_queue_head_t eventq;
-	atomic_t uevent_seq;
+	atomic_unchecked_t uevent_seq;
 	struct list_head uevent_list;
 	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
@@ -2339,8 +2339,8 @@ static struct mapped_device *alloc_dev(int minor)
 	spin_lock_init(&md->deferred_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
-	atomic_set(&md->event_nr, 0);
-	atomic_set(&md->uevent_seq, 0);
+	atomic_set_unchecked(&md->event_nr, 0);
+	atomic_set_unchecked(&md->uevent_seq, 0);
 	INIT_LIST_HEAD(&md->uevent_list);
 	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
@@ -2481,7 +2481,7 @@ static void event_callback(void *context)
 
 	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
-	atomic_inc(&md->event_nr);
+	atomic_inc_unchecked(&md->event_nr);
 	wake_up(&md->eventq);
 }
 
@@ -3479,18 +3479,18 @@ int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
 {
-	return atomic_add_return(1, &md->uevent_seq);
+	return atomic_add_return_unchecked(1, &md->uevent_seq);
 }
 
 uint32_t dm_get_event_nr(struct mapped_device *md)
 {
-	return atomic_read(&md->event_nr);
+	return atomic_read_unchecked(&md->event_nr);
 }
 
 int dm_wait_event(struct mapped_device *md, int event_nr)
 {
 	return wait_event_interruptible(md->eventq,
-			(event_nr != atomic_read(&md->event_nr)));
+			(event_nr != atomic_read_unchecked(&md->event_nr)));
 }
 
 void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 95e7b72..11002b9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -197,10 +197,10 @@ EXPORT_SYMBOL_GPL(bio_clone_mddev);
  *  start build, activate spare
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
-static atomic_t md_event_count;
+static atomic_unchecked_t md_event_count;
 void md_new_event(struct mddev *mddev)
 {
-	atomic_inc(&md_event_count);
+	atomic_inc_unchecked(&md_event_count);
 	wake_up(&md_event_waiters);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
@@ -210,7 +210,7 @@ EXPORT_SYMBOL_GPL(md_new_event);
  */
 static void md_new_event_inintr(struct mddev *mddev)
 {
-	atomic_inc(&md_event_count);
+	atomic_inc_unchecked(&md_event_count);
 	wake_up(&md_event_waiters);
 }
 
@@ -1449,7 +1449,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE) &&
 	    (le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
 		rdev->new_data_offset += (s32)le32_to_cpu(sb->new_offset);
-	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
+	atomic_set_unchecked(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
@@ -1700,7 +1700,7 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
-	sb->cnt_corrected_read = cpu_to_le32(atomic_read(&rdev->corrected_errors));
+	sb->cnt_corrected_read = cpu_to_le32(atomic_read_unchecked(&rdev->corrected_errors));
 
 	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
 	sb->size = cpu_to_le64(mddev->dev_sectors);
@@ -2622,7 +2622,7 @@ __ATTR_PREALLOC(state, S_IRUGO|S_IWUSR, state_show, state_store);
 static ssize_t
 errors_show(struct md_rdev *rdev, char *page)
 {
-	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
+	return sprintf(page, "%d\n", atomic_read_unchecked(&rdev->corrected_errors));
 }
 
 static ssize_t
@@ -2634,7 +2634,7 @@ errors_store(struct md_rdev *rdev, const char *buf, size_t len)
 	rv = kstrtouint(buf, 10, &n);
 	if (rv < 0)
 		return rv;
-	atomic_set(&rdev->corrected_errors, n);
+	atomic_set_unchecked(&rdev->corrected_errors, n);
 	return len;
 }
 static struct rdev_sysfs_entry rdev_errors =
@@ -3071,8 +3071,8 @@ int md_rdev_init(struct md_rdev *rdev)
 	rdev->sb_loaded = 0;
 	rdev->bb_page = NULL;
 	atomic_set(&rdev->nr_pending, 0);
-	atomic_set(&rdev->read_errors, 0);
-	atomic_set(&rdev->corrected_errors, 0);
+	atomic_set_unchecked(&rdev->read_errors, 0);
+	atomic_set_unchecked(&rdev->corrected_errors, 0);
 
 	INIT_LIST_HEAD(&rdev->same_set);
 	init_waitqueue_head(&rdev->blocked_wait);
@@ -7256,7 +7256,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
-		seq->poll_event = atomic_read(&md_event_count);
+		seq->poll_event = atomic_read_unchecked(&md_event_count);
 		return 0;
 	}
 	if (v == (void*)2) {
@@ -7359,7 +7359,7 @@ static int md_seq_open(struct inode *inode, struct file *file)
 		return error;
 
 	seq = file->private_data;
-	seq->poll_event = atomic_read(&md_event_count);
+	seq->poll_event = atomic_read_unchecked(&md_event_count);
 	return error;
 }
 
@@ -7376,7 +7376,7 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
 	/* always allow read */
 	mask = POLLIN | POLLRDNORM;
 
-	if (seq->poll_event != atomic_read(&md_event_count))
+	if (seq->poll_event != atomic_read_unchecked(&md_event_count))
 		mask |= POLLERR | POLLPRI;
 	return mask;
 }
@@ -7472,7 +7472,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 			      (int)part_stat_read(&disk->part0, sectors[1]) -
-			      atomic_read(&disk->sync_io);
+			      atomic_read_unchecked(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
 		 * disk_stats is counted when it completes.
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 7da6e9c..f0c1f10 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -96,13 +96,13 @@ struct md_rdev {
 					 * only maintained for arrays that
 					 * support hot removal
 					 */
-	atomic_t	read_errors;	/* number of consecutive read errors that
+	atomic_unchecked_t	read_errors;	/* number of consecutive read errors that
 					 * we have tried to ignore.
 					 */
 	struct timespec last_read_error;	/* monotonic time since our
 						 * last read error
 						 */
-	atomic_t	corrected_errors; /* number of corrected read errors,
+	atomic_unchecked_t	corrected_errors; /* number of corrected read errors,
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
@@ -487,7 +487,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
+	atomic_add_unchecked(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
 }
 
 struct md_personality
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d10d300..6169233 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1937,7 +1937,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_sync_page_io(rdev, sect, s,
 					    bio->bi_io_vec[idx].bv_page,
 					    READ) != 0)
-				atomic_add(s, &rdev->corrected_errors);
+				atomic_add_unchecked(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
 		sect += s;
@@ -2170,7 +2170,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 			    !test_bit(Faulty, &rdev->flags)) {
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
-					atomic_add(s, &rdev->corrected_errors);
+					atomic_add_unchecked(s, &rdev->corrected_errors);
 					printk(KERN_INFO
 					       "md/raid1:%s: read error corrected "
 					       "(%d sectors at %llu on %s)\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d4b70d9..3e3bbb8 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1934,7 +1934,7 @@ static void end_sync_read(struct bio *bio, int error)
 		/* The write handler will notice the lack of
 		 * R10BIO_Uptodate and record any errors etc
 		 */
-		atomic_add(r10_bio->sectors,
+		atomic_add_unchecked(r10_bio->sectors,
 			   &conf->mirrors[d].rdev->corrected_errors);
 
 	/* for reconstruct, we always reschedule after a read.
@@ -2281,7 +2281,7 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct timespec cur_time_mon;
 	unsigned long hours_since_last;
-	unsigned int read_errors = atomic_read(&rdev->read_errors);
+	unsigned int read_errors = atomic_read_unchecked(&rdev->read_errors);
 
 	ktime_get_ts(&cur_time_mon);
 
@@ -2303,9 +2303,9 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 	 * overflowing the shift of read_errors by hours_since_last.
 	 */
 	if (hours_since_last >= 8 * sizeof(read_errors))
-		atomic_set(&rdev->read_errors, 0);
+		atomic_set_unchecked(&rdev->read_errors, 0);
 	else
-		atomic_set(&rdev->read_errors, read_errors >> hours_since_last);
+		atomic_set_unchecked(&rdev->read_errors, read_errors >> hours_since_last);
 }
 
 static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
@@ -2359,8 +2359,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		return;
 
 	check_decay_read_errors(mddev, rdev);
-	atomic_inc(&rdev->read_errors);
-	if (atomic_read(&rdev->read_errors) > max_read_errors) {
+	atomic_inc_unchecked(&rdev->read_errors);
+	if (atomic_read_unchecked(&rdev->read_errors) > max_read_errors) {
 		char b[BDEVNAME_SIZE];
 		bdevname(rdev->bdev, b);
 
@@ -2368,7 +2368,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		       "md/raid10:%s: %s: Raid device exceeded "
 		       "read_error threshold [cur %d:max %d]\n",
 		       mdname(mddev), b,
-		       atomic_read(&rdev->read_errors), max_read_errors);
+		       atomic_read_unchecked(&rdev->read_errors), max_read_errors);
 		printk(KERN_NOTICE
 		       "md/raid10:%s: %s: Failing raid device\n",
 		       mdname(mddev), b);
@@ -2523,7 +2523,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
 				       bdevname(rdev->bdev, b));
-				atomic_add(s, &rdev->corrected_errors);
+				atomic_add_unchecked(s, &rdev->corrected_errors);
 			}
 
 			rdev_dec_pending(rdev, mddev);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d4f7b1..0902720 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2331,21 +2331,21 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				mdname(conf->mddev), STRIPE_SECTORS,
 				(unsigned long long)s,
 				bdevname(rdev->bdev, b));
-			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
+			atomic_add_unchecked(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
 
-		if (atomic_read(&rdev->read_errors))
-			atomic_set(&rdev->read_errors, 0);
+		if (atomic_read_unchecked(&rdev->read_errors))
+			atomic_set_unchecked(&rdev->read_errors, 0);
 	} else {
 		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
 		int set_bad = 0;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
-		atomic_inc(&rdev->read_errors);
+		atomic_inc_unchecked(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
 			printk_ratelimited(
 				KERN_WARNING
@@ -2373,7 +2373,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
-		} else if (atomic_read(&rdev->read_errors)
+		} else if (atomic_read_unchecked(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
 			       "md/raid:%s: Too many read errors, failing device %s.\n",
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 8616fa8..e16eeaf 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -83,7 +83,7 @@ static struct pci_device_id ivtv_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci,ivtv_pci_tbl);
 
 /* ivtv instance counter */
-static atomic_t ivtv_instance = ATOMIC_INIT(0);
+static atomic_unchecked_t ivtv_instance = ATOMIC_INIT(0);
 
 /* Parameter declarations */
 static int cardtype[IVTV_MAX_CARDS];
diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index 8c84846..27b4f83 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -73,7 +73,7 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 
 	/* Get next ID. According to Softlogic, 6110 has problems on !=0 P2M */
 	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m) {
-		p2m_id = atomic_inc_return(&solo_dev->p2m_count) % SOLO_NR_P2M;
+		p2m_id = atomic_inc_return_unchecked(&solo_dev->p2m_count) % SOLO_NR_P2M;
 		if (p2m_id < 0)
 			p2m_id = -p2m_id;
 	}
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 1ca54b0..7d7cb9a 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -218,7 +218,7 @@ struct solo_dev {
 
 	/* P2M DMA Engine */
 	struct solo_p2m_dev	p2m_dev[SOLO_NR_P2M];
-	atomic_t		p2m_count;
+	atomic_unchecked_t	p2m_count;
 	int			p2m_jiffies;
 	unsigned int		p2m_timeouts;
 
diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index c135165..dc69499 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -60,7 +60,7 @@ static unsigned int card[] = {[0 ... (TW68_MAXBOARDS - 1)] = UNSET };
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
-static atomic_t tw68_instance = ATOMIC_INIT(0);
+static atomic_unchecked_t tw68_instance = ATOMIC_INIT(0);
 
 /* ------------------------------------------------------------------ */
 
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5236035..c622c74 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(radio_nr, "Radio device number");
 /* TEA5757 pin mappings */
 static const int clk = 1, data = 2, wren = 4, mo_st = 8, power = 16;
 
-static atomic_t maxiradio_instance = ATOMIC_INIT(0);
+static atomic_unchecked_t maxiradio_instance = ATOMIC_INIT(0);
 
 #define PCI_VENDOR_ID_GUILLEMOT 0x5046
 #define PCI_DEVICE_ID_GUILLEMOT_MAXIRADIO 0x1001
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 050b3bb..79f62b9 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -79,7 +79,7 @@ struct shark_device {
 	u32 last_val;
 };
 
-static atomic_t shark_instance = ATOMIC_INIT(0);
+static atomic_unchecked_t shark_instance = ATOMIC_INIT(0);
 
 static void shark_write_val(struct snd_tea575x *tea, u32 val)
 {
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 8654e0d..0608a64 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -74,7 +74,7 @@ struct shark_device {
 	u8 *transfer_buffer;
 };
 
-static atomic_t shark_instance = ATOMIC_INIT(0);
+static atomic_unchecked_t shark_instance = ATOMIC_INIT(0);
 
 static int shark_write_reg(struct radio_tea5777 *tea, u64 reg)
 {
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 9cbb8cd..2bf2ff3 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1445,7 +1445,7 @@ static int si476x_radio_probe(struct platform_device *pdev)
 	struct si476x_radio *radio;
 	struct v4l2_ctrl *ctrl;
 
-	static atomic_t instance = ATOMIC_INIT(0);
+	static atomic_unchecked_t instance = ATOMIC_INIT(0);
 
 	radio = devm_kzalloc(&pdev->dev, sizeof(*radio), GFP_KERNEL);
 	if (!radio)
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 5b0a30b..1974b38 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -74,9 +74,9 @@ int v4l2_device_put(struct v4l2_device *v4l2_dev)
 EXPORT_SYMBOL_GPL(v4l2_device_put);
 
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
-						atomic_t *instance)
+						atomic_unchecked_t *instance)
 {
-	int num = atomic_inc_return(instance) - 1;
+	int num = atomic_inc_return_unchecked(instance) - 1;
 	int len = strlen(basename);
 
 	if (basename[len - 1] >= '0' && basename[len - 1] <= '9')
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index fb8705f..dc2f679 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -497,7 +497,7 @@ static irqreturn_t lis302dl_interrupt(int irq, void *data)
 	 * the lid is closed. This leads to interrupts as soon as a little move
 	 * is done.
 	 */
-	atomic_inc(&lis3->count);
+	atomic_inc_unchecked(&lis3->count);
 
 	wake_up_interruptible(&lis3->misc_wait);
 	kill_fasync(&lis3->async_queue, SIGIO, POLL_IN);
@@ -583,7 +583,7 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 	if (lis3->pm_dev)
 		pm_runtime_get_sync(lis3->pm_dev);
 
-	atomic_set(&lis3->count, 0);
+	atomic_set_unchecked(&lis3->count, 0);
 	return 0;
 }
 
@@ -615,7 +615,7 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 	add_wait_queue(&lis3->misc_wait, &wait);
 	while (true) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		data = atomic_xchg(&lis3->count, 0);
+		data = atomic_xchg_unchecked(&lis3->count, 0);
 		if (data)
 			break;
 
@@ -656,7 +656,7 @@ static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
 					      struct lis3lv02d, miscdev);
 
 	poll_wait(file, &lis3->misc_wait, wait);
-	if (atomic_read(&lis3->count))
+	if (atomic_read_unchecked(&lis3->count))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index c439c82..1f20f57 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -297,7 +297,7 @@ struct lis3lv02d {
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	struct regulator_bulk_data regulators[2];
-	atomic_t		count;     /* interrupt count after last read */
+	atomic_unchecked_t	count;     /* interrupt count after last read */
 	union axis_conversion	ac;        /* hw -> logical axis */
 	int			mapped_btns[3];
 
diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
index 2f30bad..c4c13d0 100644
--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -44,8 +44,8 @@ static void update_mcs_stats(enum mcs_op op, unsigned long clks)
 	unsigned long nsec;
 
 	nsec = CLKS2NSEC(clks);
-	atomic_long_inc(&mcs_op_statistics[op].count);
-	atomic_long_add(nsec, &mcs_op_statistics[op].total);
+	atomic_long_inc_unchecked(&mcs_op_statistics[op].count);
+	atomic_long_add_unchecked(nsec, &mcs_op_statistics[op].total);
 	if (mcs_op_statistics[op].max < nsec)
 		mcs_op_statistics[op].max = nsec;
 }
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 4f76359..cdfcb2e 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -32,9 +32,9 @@
 
 #define printstat(s, f)		printstat_val(s, &gru_stats.f, #f)
 
-static void printstat_val(struct seq_file *s, atomic_long_t *v, char *id)
+static void printstat_val(struct seq_file *s, atomic_long_unchecked_t *v, char *id)
 {
-	unsigned long val = atomic_long_read(v);
+	unsigned long val = atomic_long_read_unchecked(v);
 
 	seq_printf(s, "%16lu %s\n", val, id);
 }
@@ -134,8 +134,8 @@ static int mcs_statistics_show(struct seq_file *s, void *p)
 
 	seq_printf(s, "%-20s%12s%12s%12s\n", "#id", "count", "aver-clks", "max-clks");
 	for (op = 0; op < mcsop_last; op++) {
-		count = atomic_long_read(&mcs_op_statistics[op].count);
-		total = atomic_long_read(&mcs_op_statistics[op].total);
+		count = atomic_long_read_unchecked(&mcs_op_statistics[op].count);
+		total = atomic_long_read_unchecked(&mcs_op_statistics[op].total);
 		max = mcs_op_statistics[op].max;
 		seq_printf(s, "%-20s%12ld%12ld%12ld\n", id[op], count,
 			   count ? total / count : 0, max);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 5c3ce24..4915ccb 100644
--- a/drivers/misc/sgi-gru/grutables.h
+++ b/drivers/misc/sgi-gru/grutables.h
@@ -167,82 +167,82 @@ extern unsigned int gru_max_gids;
  * GRU statistics.
  */
 struct gru_stats_s {
-	atomic_long_t vdata_alloc;
-	atomic_long_t vdata_free;
-	atomic_long_t gts_alloc;
-	atomic_long_t gts_free;
-	atomic_long_t gms_alloc;
-	atomic_long_t gms_free;
-	atomic_long_t gts_double_allocate;
-	atomic_long_t assign_context;
-	atomic_long_t assign_context_failed;
-	atomic_long_t free_context;
-	atomic_long_t load_user_context;
-	atomic_long_t load_kernel_context;
-	atomic_long_t lock_kernel_context;
-	atomic_long_t unlock_kernel_context;
-	atomic_long_t steal_user_context;
-	atomic_long_t steal_kernel_context;
-	atomic_long_t steal_context_failed;
-	atomic_long_t nopfn;
-	atomic_long_t asid_new;
-	atomic_long_t asid_next;
-	atomic_long_t asid_wrap;
-	atomic_long_t asid_reuse;
-	atomic_long_t intr;
-	atomic_long_t intr_cbr;
-	atomic_long_t intr_tfh;
-	atomic_long_t intr_spurious;
-	atomic_long_t intr_mm_lock_failed;
-	atomic_long_t call_os;
-	atomic_long_t call_os_wait_queue;
-	atomic_long_t user_flush_tlb;
-	atomic_long_t user_unload_context;
-	atomic_long_t user_exception;
-	atomic_long_t set_context_option;
-	atomic_long_t check_context_retarget_intr;
-	atomic_long_t check_context_unload;
-	atomic_long_t tlb_dropin;
-	atomic_long_t tlb_preload_page;
-	atomic_long_t tlb_dropin_fail_no_asid;
-	atomic_long_t tlb_dropin_fail_upm;
-	atomic_long_t tlb_dropin_fail_invalid;
-	atomic_long_t tlb_dropin_fail_range_active;
-	atomic_long_t tlb_dropin_fail_idle;
-	atomic_long_t tlb_dropin_fail_fmm;
-	atomic_long_t tlb_dropin_fail_no_exception;
-	atomic_long_t tfh_stale_on_fault;
-	atomic_long_t mmu_invalidate_range;
-	atomic_long_t mmu_invalidate_page;
-	atomic_long_t flush_tlb;
-	atomic_long_t flush_tlb_gru;
-	atomic_long_t flush_tlb_gru_tgh;
-	atomic_long_t flush_tlb_gru_zero_asid;
-
-	atomic_long_t copy_gpa;
-	atomic_long_t read_gpa;
-
-	atomic_long_t mesq_receive;
-	atomic_long_t mesq_receive_none;
-	atomic_long_t mesq_send;
-	atomic_long_t mesq_send_failed;
-	atomic_long_t mesq_noop;
-	atomic_long_t mesq_send_unexpected_error;
-	atomic_long_t mesq_send_lb_overflow;
-	atomic_long_t mesq_send_qlimit_reached;
-	atomic_long_t mesq_send_amo_nacked;
-	atomic_long_t mesq_send_put_nacked;
-	atomic_long_t mesq_page_overflow;
-	atomic_long_t mesq_qf_locked;
-	atomic_long_t mesq_qf_noop_not_full;
-	atomic_long_t mesq_qf_switch_head_failed;
-	atomic_long_t mesq_qf_unexpected_error;
-	atomic_long_t mesq_noop_unexpected_error;
-	atomic_long_t mesq_noop_lb_overflow;
-	atomic_long_t mesq_noop_qlimit_reached;
-	atomic_long_t mesq_noop_amo_nacked;
-	atomic_long_t mesq_noop_put_nacked;
-	atomic_long_t mesq_noop_page_overflow;
+	atomic_long_unchecked_t vdata_alloc;
+	atomic_long_unchecked_t vdata_free;
+	atomic_long_unchecked_t gts_alloc;
+	atomic_long_unchecked_t gts_free;
+	atomic_long_unchecked_t gms_alloc;
+	atomic_long_unchecked_t gms_free;
+	atomic_long_unchecked_t gts_double_allocate;
+	atomic_long_unchecked_t assign_context;
+	atomic_long_unchecked_t assign_context_failed;
+	atomic_long_unchecked_t free_context;
+	atomic_long_unchecked_t load_user_context;
+	atomic_long_unchecked_t load_kernel_context;
+	atomic_long_unchecked_t lock_kernel_context;
+	atomic_long_unchecked_t unlock_kernel_context;
+	atomic_long_unchecked_t steal_user_context;
+	atomic_long_unchecked_t steal_kernel_context;
+	atomic_long_unchecked_t steal_context_failed;
+	atomic_long_unchecked_t nopfn;
+	atomic_long_unchecked_t asid_new;
+	atomic_long_unchecked_t asid_next;
+	atomic_long_unchecked_t asid_wrap;
+	atomic_long_unchecked_t asid_reuse;
+	atomic_long_unchecked_t intr;
+	atomic_long_unchecked_t intr_cbr;
+	atomic_long_unchecked_t intr_tfh;
+	atomic_long_unchecked_t intr_spurious;
+	atomic_long_unchecked_t intr_mm_lock_failed;
+	atomic_long_unchecked_t call_os;
+	atomic_long_unchecked_t call_os_wait_queue;
+	atomic_long_unchecked_t user_flush_tlb;
+	atomic_long_unchecked_t user_unload_context;
+	atomic_long_unchecked_t user_exception;
+	atomic_long_unchecked_t set_context_option;
+	atomic_long_unchecked_t check_context_retarget_intr;
+	atomic_long_unchecked_t check_context_unload;
+	atomic_long_unchecked_t tlb_dropin;
+	atomic_long_unchecked_t tlb_preload_page;
+	atomic_long_unchecked_t tlb_dropin_fail_no_asid;
+	atomic_long_unchecked_t tlb_dropin_fail_upm;
+	atomic_long_unchecked_t tlb_dropin_fail_invalid;
+	atomic_long_unchecked_t tlb_dropin_fail_range_active;
+	atomic_long_unchecked_t tlb_dropin_fail_idle;
+	atomic_long_unchecked_t tlb_dropin_fail_fmm;
+	atomic_long_unchecked_t tlb_dropin_fail_no_exception;
+	atomic_long_unchecked_t tfh_stale_on_fault;
+	atomic_long_unchecked_t mmu_invalidate_range;
+	atomic_long_unchecked_t mmu_invalidate_page;
+	atomic_long_unchecked_t flush_tlb;
+	atomic_long_unchecked_t flush_tlb_gru;
+	atomic_long_unchecked_t flush_tlb_gru_tgh;
+	atomic_long_unchecked_t flush_tlb_gru_zero_asid;
+
+	atomic_long_unchecked_t copy_gpa;
+	atomic_long_unchecked_t read_gpa;
+
+	atomic_long_unchecked_t mesq_receive;
+	atomic_long_unchecked_t mesq_receive_none;
+	atomic_long_unchecked_t mesq_send;
+	atomic_long_unchecked_t mesq_send_failed;
+	atomic_long_unchecked_t mesq_noop;
+	atomic_long_unchecked_t mesq_send_unexpected_error;
+	atomic_long_unchecked_t mesq_send_lb_overflow;
+	atomic_long_unchecked_t mesq_send_qlimit_reached;
+	atomic_long_unchecked_t mesq_send_amo_nacked;
+	atomic_long_unchecked_t mesq_send_put_nacked;
+	atomic_long_unchecked_t mesq_page_overflow;
+	atomic_long_unchecked_t mesq_qf_locked;
+	atomic_long_unchecked_t mesq_qf_noop_not_full;
+	atomic_long_unchecked_t mesq_qf_switch_head_failed;
+	atomic_long_unchecked_t mesq_qf_unexpected_error;
+	atomic_long_unchecked_t mesq_noop_unexpected_error;
+	atomic_long_unchecked_t mesq_noop_lb_overflow;
+	atomic_long_unchecked_t mesq_noop_qlimit_reached;
+	atomic_long_unchecked_t mesq_noop_amo_nacked;
+	atomic_long_unchecked_t mesq_noop_put_nacked;
+	atomic_long_unchecked_t mesq_noop_page_overflow;
 
 };
 
@@ -251,8 +251,8 @@ enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
 	tghop_invalidate, mcsop_last};
 
 struct mcs_op_statistic {
-	atomic_long_t	count;
-	atomic_long_t	total;
+	atomic_long_unchecked_t	count;
+	atomic_long_unchecked_t	total;
 	unsigned long	max;
 };
 
@@ -275,7 +275,7 @@ extern struct mcs_op_statistic mcs_op_statistics[mcsop_last];
 
 #define STAT(id)	do {						\
 				if (gru_options & OPT_STATS)		\
-					atomic_long_inc(&gru_stats.id);	\
+					atomic_long_inc_unchecked(&gru_stats.id);	\
 			} while (0)
 
 #ifdef CONFIG_SGI_GRU_DEBUG
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index dd45440..c5f3cae 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -177,7 +177,7 @@ struct rndis_device {
 	enum rndis_device_state state;
 	bool link_state;
 	bool link_change;
-	atomic_t new_req_id;
+	atomic_unchecked_t new_req_id;
 
 	spinlock_t request_lock;
 	struct list_head req_list;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 236aeb7..fd695e2 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -101,7 +101,7 @@ static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 	 * template
 	 */
 	set = &rndis_msg->msg.set_req;
-	set->req_id = atomic_inc_return(&dev->new_req_id);
+	set->req_id = atomic_inc_return_unchecked(&dev->new_req_id);
 
 	/* Add to the request list */
 	spin_lock_irqsave(&dev->request_lock, flags);
@@ -924,7 +924,7 @@ static void rndis_filter_halt_device(struct rndis_device *dev)
 
 	/* Setup the rndis set */
 	halt = &request->request_msg.msg.halt_req;
-	halt->req_id = atomic_inc_return(&dev->new_req_id);
+	halt->req_id = atomic_inc_return_unchecked(&dev->new_req_id);
 
 	/* Ignore return since this msg is optional. */
 	rndis_filter_send_request(dev, request);
-- 
2.5.0
