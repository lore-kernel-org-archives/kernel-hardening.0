Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:42 +0200
Message-Id: <1478809488-18303-8-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 07/13] net: atm: identify wrapping atomic usage
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, Hans Liljestrand <ishkamiel@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Hans Liljestrand <ishkamiel@gmail.com>

In some cases atomic is not used for reference
counting and therefore should be allowed to overflow.
Identify such cases and make a switch to non-hardened
atomic version.

Changes in net/atm/* required various corresponding
changes in drivers/atm/*, so altogether this is separated
in patch of its own.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>

Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 drivers/atm/adummy.c     |  2 +-
 drivers/atm/ambassador.c |  8 ++++----
 drivers/atm/atmtcp.c     | 14 +++++++-------
 drivers/atm/eni.c        | 10 +++++-----
 drivers/atm/firestream.c |  8 ++++----
 drivers/atm/fore200e.c   | 14 +++++++-------
 drivers/atm/he.c         | 18 +++++++++---------
 drivers/atm/horizon.c    |  4 ++--
 drivers/atm/idt77252.c   | 36 ++++++++++++++++++------------------
 drivers/atm/iphase.c     | 34 +++++++++++++++++-----------------
 drivers/atm/lanai.c      | 12 ++++++------
 drivers/atm/nicstar.c    | 47 ++++++++++++++++++++++++-----------------------
 drivers/atm/solos-pci.c  |  4 ++--
 drivers/atm/suni.c       |  5 +++--
 drivers/atm/uPD98402.c   | 16 ++++++++--------
 drivers/atm/zatm.c       |  7 ++++---
 drivers/usb/atm/usbatm.c | 24 ++++++++++++------------
 include/linux/atmdev.h   |  2 +-
 include/linux/sonet.h    |  2 +-
 net/atm/atm_misc.c       |  8 ++++----
 net/atm/proc.c           |  8 +++++---
 net/atm/resources.c      |  4 ++--
 22 files changed, 146 insertions(+), 141 deletions(-)

diff --git a/drivers/atm/adummy.c b/drivers/atm/adummy.c
index f9b983a..1ec68fe 100644
--- a/drivers/atm/adummy.c
+++ b/drivers/atm/adummy.c
@@ -114,7 +114,7 @@ adummy_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		vcc->pop(vcc, skb);
 	else
 		dev_kfree_skb_any(skb);
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_wrap(&vcc->stats->tx);
 
 	return 0;
 }
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index f1a9198..a8f534f 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -454,7 +454,7 @@ static void tx_complete (amb_dev * dev, tx_out * tx) {
   PRINTD (DBG_FLOW|DBG_TX, "tx_complete %p %p", dev, tx);
   
   // VC layer stats
-  atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+  atomic_inc_wrap(&ATM_SKB(skb)->vcc->stats->tx);
   
   // free the descriptor
   kfree (tx_descr);
@@ -495,7 +495,7 @@ static void rx_complete (amb_dev * dev, rx_out * rx) {
 	  dump_skb ("<<<", vc, skb);
 	  
 	  // VC layer stats
-	  atomic_inc(&atm_vcc->stats->rx);
+	  atomic_inc_wrap(&atm_vcc->stats->rx);
 	  __net_timestamp(skb);
 	  // end of our responsibility
 	  atm_vcc->push (atm_vcc, skb);
@@ -510,7 +510,7 @@ static void rx_complete (amb_dev * dev, rx_out * rx) {
       } else {
       	PRINTK (KERN_INFO, "dropped over-size frame");
 	// should we count this?
-	atomic_inc(&atm_vcc->stats->rx_drop);
+	atomic_inc_wrap(&atm_vcc->stats->rx_drop);
       }
       
     } else {
@@ -1338,7 +1338,7 @@ static int amb_send (struct atm_vcc * atm_vcc, struct sk_buff * skb) {
   }
   
   if (check_area (skb->data, skb->len)) {
-    atomic_inc(&atm_vcc->stats->tx_err);
+    atomic_inc_wrap(&atm_vcc->stats->tx_err);
     return -ENOMEM; // ?
   }
   
diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index 480fa6f..e46ee1f 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -206,7 +206,7 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb(skb);
 		if (dev_data) return 0;
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		return -ENOLINK;
 	}
 	size = skb->len+sizeof(struct atmtcp_hdr);
@@ -214,7 +214,7 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	if (!new_skb) {
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		return -ENOBUFS;
 	}
 	hdr = (void *) skb_put(new_skb,sizeof(struct atmtcp_hdr));
@@ -225,8 +225,8 @@ static int atmtcp_v_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	if (vcc->pop) vcc->pop(vcc,skb);
 	else dev_kfree_skb(skb);
 	out_vcc->push(out_vcc,new_skb);
-	atomic_inc(&vcc->stats->tx);
-	atomic_inc(&out_vcc->stats->rx);
+	atomic_inc_wrap(&vcc->stats->tx);
+	atomic_inc_wrap(&out_vcc->stats->rx);
 	return 0;
 }
 
@@ -300,7 +300,7 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	read_unlock(&vcc_sklist_lock);
 	if (!out_vcc) {
 		result = -EUNATCH;
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		goto done;
 	}
 	skb_pull(skb,sizeof(struct atmtcp_hdr));
@@ -312,8 +312,8 @@ static int atmtcp_c_send(struct atm_vcc *vcc,struct sk_buff *skb)
 	__net_timestamp(new_skb);
 	skb_copy_from_linear_data(skb, skb_put(new_skb, skb->len), skb->len);
 	out_vcc->push(out_vcc,new_skb);
-	atomic_inc(&vcc->stats->tx);
-	atomic_inc(&out_vcc->stats->rx);
+	atomic_inc_wrap(&vcc->stats->tx);
+	atomic_inc_wrap(&out_vcc->stats->rx);
 done:
 	if (vcc->pop) vcc->pop(vcc,skb);
 	else dev_kfree_skb(skb);
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index f2aaf9e..49e3083 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -525,7 +525,7 @@ static int rx_aal0(struct atm_vcc *vcc)
 		DPRINTK(DEV_LABEL "(itf %d): trashing empty cell\n",
 		    vcc->dev->number);
 		length = 0;
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_wrap(&vcc->stats->rx_err);
 	}
 	else {
 		length = ATM_CELL_SIZE-1; /* no HEC */
@@ -580,7 +580,7 @@ static int rx_aal5(struct atm_vcc *vcc)
 			    size);
 		}
 		eff = length = 0;
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_wrap(&vcc->stats->rx_err);
 	}
 	else {
 		size = (descr & MID_RED_COUNT)*(ATM_CELL_PAYLOAD >> 2);
@@ -597,7 +597,7 @@ static int rx_aal5(struct atm_vcc *vcc)
 			    "(VCI=%d,length=%ld,size=%ld (descr 0x%lx))\n",
 			    vcc->dev->number,vcc->vci,length,size << 2,descr);
 			length = eff = 0;
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 		}
 	}
 	skb = eff ? atm_alloc_charge(vcc,eff << 2,GFP_ATOMIC) : NULL;
@@ -770,7 +770,7 @@ rx_dequeued++;
 			vcc->push(vcc,skb);
 			pushed++;
 		}
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 	}
 	wake_up(&eni_dev->rx_wait);
 }
@@ -1230,7 +1230,7 @@ static void dequeue_tx(struct atm_dev *dev)
 				 DMA_TO_DEVICE);
 		if (vcc->pop) vcc->pop(vcc,skb);
 		else dev_kfree_skb_irq(skb);
-		atomic_inc(&vcc->stats->tx);
+		atomic_inc_wrap(&vcc->stats->tx);
 		wake_up(&eni_dev->tx_wait);
 dma_complete++;
 	}
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 85aaf22..81a982c 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -753,7 +753,7 @@ static void process_txdone_queue (struct fs_dev *dev, struct queue *q)
 				}
 			}
 
-			atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+			atomic_inc_wrap(&ATM_SKB(skb)->vcc->stats->tx);
 
 			fs_dprintk (FS_DEBUG_TXMEM, "i");
 			fs_dprintk (FS_DEBUG_ALLOC, "Free t-skb: %p\n", skb);
@@ -820,7 +820,7 @@ static void process_incoming (struct fs_dev *dev, struct queue *q)
 #endif
 				skb_put (skb, qe->p1 & 0xffff); 
 				ATM_SKB(skb)->vcc = atm_vcc;
-				atomic_inc(&atm_vcc->stats->rx);
+				atomic_inc_wrap(&atm_vcc->stats->rx);
 				__net_timestamp(skb);
 				fs_dprintk (FS_DEBUG_ALLOC, "Free rec-skb: %p (pushed)\n", skb);
 				atm_vcc->push (atm_vcc, skb);
@@ -841,12 +841,12 @@ static void process_incoming (struct fs_dev *dev, struct queue *q)
 				kfree (pe);
 			}
 			if (atm_vcc)
-				atomic_inc(&atm_vcc->stats->rx_drop);
+				atomic_inc_wrap(&atm_vcc->stats->rx_drop);
 			break;
 		case 0x1f: /*  Reassembly abort: no buffers. */
 			/* Silently increment error counter. */
 			if (atm_vcc)
-				atomic_inc(&atm_vcc->stats->rx_drop);
+				atomic_inc_wrap(&atm_vcc->stats->rx_drop);
 			break;
 		default: /* Hmm. Haven't written the code to handle the others yet... -- REW */
 			printk (KERN_WARNING "Don't know what to do with RX status %x: %s.\n", 
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 81aaa50..3585b32 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -932,9 +932,9 @@ fore200e_tx_irq(struct fore200e* fore200e)
 #endif
 		/* check error condition */
 		if (*entry->status & STATUS_ERROR)
-		    atomic_inc(&vcc->stats->tx_err);
+		    atomic_inc_wrap(&vcc->stats->tx_err);
 		else
-		    atomic_inc(&vcc->stats->tx);
+		    atomic_inc_wrap(&vcc->stats->tx);
 	    }
 	}
 
@@ -1083,7 +1083,7 @@ fore200e_push_rpd(struct fore200e* fore200e, struct atm_vcc* vcc, struct rpd* rp
     if (skb == NULL) {
 	DPRINTK(2, "unable to alloc new skb, rx PDU length = %d\n", pdu_len);
 
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_wrap(&vcc->stats->rx_drop);
 	return -ENOMEM;
     } 
 
@@ -1126,14 +1126,14 @@ fore200e_push_rpd(struct fore200e* fore200e, struct atm_vcc* vcc, struct rpd* rp
 
 	dev_kfree_skb_any(skb);
 
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_wrap(&vcc->stats->rx_drop);
 	return -ENOMEM;
     }
 
     ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
     vcc->push(vcc, skb);
-    atomic_inc(&vcc->stats->rx);
+    atomic_inc_wrap(&vcc->stats->rx);
 
     ASSERT(atomic_read(&sk_atm(vcc)->sk_wmem_alloc) >= 0);
 
@@ -1211,7 +1211,7 @@ fore200e_rx_irq(struct fore200e* fore200e)
 		DPRINTK(2, "damaged PDU on %d.%d.%d\n",
 			fore200e->atm_dev->number,
 			entry->rpd->atm_header.vpi, entry->rpd->atm_header.vci);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_wrap(&vcc->stats->rx_err);
 	    }
 	}
 
@@ -1656,7 +1656,7 @@ fore200e_send(struct atm_vcc *vcc, struct sk_buff *skb)
 		goto retry_here;
 	    }
 
-	    atomic_inc(&vcc->stats->tx_err);
+	    atomic_inc_wrap(&vcc->stats->tx_err);
 
 	    fore200e->tx_sat++;
 	    DPRINTK(2, "tx queue of device %s is saturated, PDU dropped - heartbeat is %08x\n",
diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 31b513a..f1fbf6d 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1691,7 +1691,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 
 		if (RBRQ_HBUF_ERR(he_dev->rbrq_head)) {
 			hprintk("HBUF_ERR!  (cid 0x%x)\n", cid);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_wrap(&vcc->stats->rx_drop);
 			goto return_host_buffers;
 		}
 
@@ -1718,7 +1718,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 				RBRQ_LEN_ERR(he_dev->rbrq_head)
 							? "LEN_ERR" : "",
 							vcc->vpi, vcc->vci);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			goto return_host_buffers;
 		}
 
@@ -1770,7 +1770,7 @@ he_service_rbrq(struct he_dev *he_dev, int group)
 		vcc->push(vcc, skb);
 		spin_lock(&he_dev->global_lock);
 
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 
 return_host_buffers:
 		++pdus_assembled;
@@ -2096,7 +2096,7 @@ __enqueue_tpd(struct he_dev *he_dev, struct he_tpd *tpd, unsigned cid)
 					tpd->vcc->pop(tpd->vcc, tpd->skb);
 				else
 					dev_kfree_skb_any(tpd->skb);
-				atomic_inc(&tpd->vcc->stats->tx_err);
+				atomic_inc_wrap(&tpd->vcc->stats->tx_err);
 			}
 			dma_pool_free(he_dev->tpd_pool, tpd, TPD_ADDR(tpd->status));
 			return;
@@ -2508,7 +2508,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		return -EINVAL;
 	}
 
@@ -2519,7 +2519,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		return -EINVAL;
 	}
 #endif
@@ -2531,7 +2531,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			vcc->pop(vcc, skb);
 		else
 			dev_kfree_skb_any(skb);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		spin_unlock_irqrestore(&he_dev->global_lock, flags);
 		return -ENOMEM;
 	}
@@ -2573,7 +2573,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 					vcc->pop(vcc, skb);
 				else
 					dev_kfree_skb_any(skb);
-				atomic_inc(&vcc->stats->tx_err);
+				atomic_inc_wrap(&vcc->stats->tx_err);
 				spin_unlock_irqrestore(&he_dev->global_lock, flags);
 				return -ENOMEM;
 			}
@@ -2604,7 +2604,7 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	__enqueue_tpd(he_dev, tpd, cid);
 	spin_unlock_irqrestore(&he_dev->global_lock, flags);
 
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_wrap(&vcc->stats->tx);
 
 	return 0;
 }
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 5fc81e2..364d2cb 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1018,7 +1018,7 @@ static void rx_schedule (hrz_dev * dev, int irq) {
 	{
 	  struct atm_vcc * vcc = ATM_SKB(skb)->vcc;
 	  // VC layer stats
-	  atomic_inc(&vcc->stats->rx);
+	  atomic_inc_wrap(&vcc->stats->rx);
 	  __net_timestamp(skb);
 	  // end of our responsibility
 	  vcc->push (vcc, skb);
@@ -1170,7 +1170,7 @@ static void tx_schedule (hrz_dev * const dev, int irq) {
 	dev->tx_iovec = NULL;
 	
 	// VC layer stats
-	atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
+	atomic_inc_wrap(&ATM_SKB(skb)->vcc->stats->tx);
 	
 	// free the skb
 	hrz_kfree_skb (skb);
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 074616b..e25bbf6 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -811,7 +811,7 @@ drain_scq(struct idt77252_dev *card, struct vc_map *vc)
 		else
 			dev_kfree_skb(skb);
 
-		atomic_inc(&vcc->stats->tx);
+		atomic_inc_wrap(&vcc->stats->tx);
 	}
 
 	atomic_dec(&scq->used);
@@ -1073,13 +1073,13 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			if ((sb = dev_alloc_skb(64)) == NULL) {
 				printk("%s: Can't allocate buffers for aal0.\n",
 				       card->name);
-				atomic_add(i, &vcc->stats->rx_drop);
+				atomic_add_wrap(i, &vcc->stats->rx_drop);
 				break;
 			}
 			if (!atm_charge(vcc, sb->truesize)) {
 				RXPRINTK("%s: atm_charge() dropped aal0 packets.\n",
 					 card->name);
-				atomic_add(i - 1, &vcc->stats->rx_drop);
+				atomic_add_wrap(i - 1, &vcc->stats->rx_drop);
 				dev_kfree_skb(sb);
 				break;
 			}
@@ -1096,7 +1096,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			ATM_SKB(sb)->vcc = vcc;
 			__net_timestamp(sb);
 			vcc->push(vcc, sb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_wrap(&vcc->stats->rx);
 
 			cell += ATM_CELL_PAYLOAD;
 		}
@@ -1133,13 +1133,13 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			         "(CDC: %08x)\n",
 			         card->name, len, rpp->len, readl(SAR_REG_CDC));
 			recycle_rx_pool_skb(card, rpp);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			return;
 		}
 		if (stat & SAR_RSQE_CRC) {
 			RXPRINTK("%s: AAL5 CRC error.\n", card->name);
 			recycle_rx_pool_skb(card, rpp);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			return;
 		}
 		if (skb_queue_len(&rpp->queue) > 1) {
@@ -1150,7 +1150,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 				RXPRINTK("%s: Can't alloc RX skb.\n",
 					 card->name);
 				recycle_rx_pool_skb(card, rpp);
-				atomic_inc(&vcc->stats->rx_err);
+				atomic_inc_wrap(&vcc->stats->rx_err);
 				return;
 			}
 			if (!atm_charge(vcc, skb->truesize)) {
@@ -1169,7 +1169,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 			__net_timestamp(skb);
 
 			vcc->push(vcc, skb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_wrap(&vcc->stats->rx);
 
 			return;
 		}
@@ -1191,7 +1191,7 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 		__net_timestamp(skb);
 
 		vcc->push(vcc, skb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 
 		if (skb->truesize > SAR_FB_SIZE_3)
 			add_rx_skb(card, 3, SAR_FB_SIZE_3, 1);
@@ -1302,14 +1302,14 @@ idt77252_rx_raw(struct idt77252_dev *card)
 		if (vcc->qos.aal != ATM_AAL0) {
 			RPRINTK("%s: raw cell for non AAL0 vc %u.%u\n",
 				card->name, vpi, vci);
-			atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc_wrap(&vcc->stats->rx_drop);
 			goto drop;
 		}
 	
 		if ((sb = dev_alloc_skb(64)) == NULL) {
 			printk("%s: Can't allocate buffers for AAL0.\n",
 			       card->name);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			goto drop;
 		}
 
@@ -1328,7 +1328,7 @@ idt77252_rx_raw(struct idt77252_dev *card)
 		ATM_SKB(sb)->vcc = vcc;
 		__net_timestamp(sb);
 		vcc->push(vcc, sb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 
 drop:
 		skb_pull(queue, 64);
@@ -1953,13 +1953,13 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 
 	if (vc == NULL) {
 		printk("%s: NULL connection in send().\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 	if (!test_bit(VCF_TX, &vc->flags)) {
 		printk("%s: Trying to transmit on a non-tx VC.\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1971,14 +1971,14 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 		break;
 	default:
 		printk("%s: Unsupported AAL: %d\n", card->name, vcc->qos.aal);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
 
 	if (skb_shinfo(skb)->nr_frags != 0) {
 		printk("%s: No scatter-gather yet.\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return -EINVAL;
 	}
@@ -1986,7 +1986,7 @@ idt77252_send_skb(struct atm_vcc *vcc, struct sk_buff *skb, int oam)
 
 	err = queue_skb(card, vc, skb, oam);
 	if (err) {
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb(skb);
 		return err;
 	}
@@ -2009,7 +2009,7 @@ idt77252_send_oam(struct atm_vcc *vcc, void *cell, int flags)
 	skb = dev_alloc_skb(64);
 	if (!skb) {
 		printk("%s: Out of memory in send_oam().\n", card->name);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		return -ENOMEM;
 	}
 	atomic_add(skb->truesize, &sk_atm(vcc)->sk_wmem_alloc);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index b275676..b018a40 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -1146,7 +1146,7 @@ static int rx_pkt(struct atm_dev *dev)
 	status = (u_short) (buf_desc_ptr->desc_mode);  
 	if (status & (RX_CER | RX_PTE | RX_OFL))  
 	{  
-                atomic_inc(&vcc->stats->rx_err);
+                atomic_inc_wrap(&vcc->stats->rx_err);
 		IF_ERR(printk("IA: bad packet, dropping it");)  
                 if (status & RX_CER) { 
                     IF_ERR(printk(" cause: packet CRC error\n");)
@@ -1169,7 +1169,7 @@ static int rx_pkt(struct atm_dev *dev)
 	len = dma_addr - buf_addr;  
         if (len > iadev->rx_buf_sz) {
            printk("Over %d bytes sdu received, dropped!!!\n", iadev->rx_buf_sz);
-           atomic_inc(&vcc->stats->rx_err);
+           atomic_inc_wrap(&vcc->stats->rx_err);
 	   goto out_free_desc;
         }
 		  
@@ -1319,7 +1319,7 @@ static void rx_dle_intr(struct atm_dev *dev)
           ia_vcc = INPH_IA_VCC(vcc);
           if (ia_vcc == NULL)
           {
-             atomic_inc(&vcc->stats->rx_err);
+             atomic_inc_wrap(&vcc->stats->rx_err);
              atm_return(vcc, skb->truesize);
              dev_kfree_skb_any(skb);
              goto INCR_DLE;
@@ -1331,7 +1331,7 @@ static void rx_dle_intr(struct atm_dev *dev)
           if ((length > iadev->rx_buf_sz) || (length > 
                               (skb->len - sizeof(struct cpcs_trailer))))
           {
-             atomic_inc(&vcc->stats->rx_err);
+             atomic_inc_wrap(&vcc->stats->rx_err);
              IF_ERR(printk("rx_dle_intr: Bad  AAL5 trailer %d (skb len %d)", 
                                                             length, skb->len);)
              atm_return(vcc, skb->truesize);
@@ -1347,7 +1347,7 @@ static void rx_dle_intr(struct atm_dev *dev)
 
 	  IF_RX(printk("rx_dle_intr: skb push");)  
 	  vcc->push(vcc,skb);  
-	  atomic_inc(&vcc->stats->rx);
+	  atomic_inc_wrap(&vcc->stats->rx);
           iadev->rx_pkt_cnt++;
       }  
 INCR_DLE:
@@ -2834,15 +2834,15 @@ static int ia_ioctl(struct atm_dev *dev, unsigned int cmd, void __user *arg)
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
+             printk("section_bip: %d\n", atomic_read_wrap(&stats->section_bip));
+             printk("line_bip   : %d\n", atomic_read_wrap(&stats->line_bip));
+             printk("path_bip   : %d\n", atomic_read_wrap(&stats->path_bip));
+             printk("line_febe  : %d\n", atomic_read_wrap(&stats->line_febe));
+             printk("path_febe  : %d\n", atomic_read_wrap(&stats->path_febe));
+             printk("corr_hcs   : %d\n", atomic_read_wrap(&stats->corr_hcs));
+             printk("uncorr_hcs : %d\n", atomic_read_wrap(&stats->uncorr_hcs));
+             printk("tx_cells   : %d\n", atomic_read_wrap(&stats->tx_cells));
+             printk("rx_cells   : %d\n", atomic_read_wrap(&stats->rx_cells));
          }
             ia_cmds.status = 0;
             break;
@@ -2947,7 +2947,7 @@ static int ia_pkt_tx (struct atm_vcc *vcc, struct sk_buff *skb) {
 	if ((desc == 0) || (desc > iadev->num_tx_desc))  
 	{  
 		IF_ERR(printk(DEV_LABEL "invalid desc for send: %d\n", desc);) 
-                atomic_inc(&vcc->stats->tx);
+                atomic_inc_wrap(&vcc->stats->tx);
 		if (vcc->pop)   
 		    vcc->pop(vcc, skb);   
 		else  
@@ -3052,14 +3052,14 @@ static int ia_pkt_tx (struct atm_vcc *vcc, struct sk_buff *skb) {
         ATM_DESC(skb) = vcc->vci;
         skb_queue_tail(&iadev->tx_dma_q, skb);
 
-        atomic_inc(&vcc->stats->tx);
+        atomic_inc_wrap(&vcc->stats->tx);
         iadev->tx_pkt_cnt++;
 	/* Increment transaction counter */  
 	writel(2, iadev->dma+IPHASE5575_TX_COUNTER);  
         
 #if 0        
         /* add flow control logic */ 
-        if (atomic_read(&vcc->stats->tx) % 20 == 0) {
+	if (atomic_read_wrap(&vcc->stats->tx) % 20 == 0) {
           if (iavcc->vc_desc_cnt > 10) {
              vcc->tx_quota =  vcc->tx_quota * 3 / 4;
             printk("Tx1:  vcc->tx_quota = %d \n", (u32)vcc->tx_quota );
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index ce43ae3..d9989f8 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -1295,7 +1295,7 @@ static void lanai_send_one_aal5(struct lanai_dev *lanai,
 	vcc_tx_add_aal5_trailer(lvcc, skb->len, 0, 0);
 	lanai_endtx(lanai, lvcc);
 	lanai_free_skb(lvcc->tx.atmvcc, skb);
-	atomic_inc(&lvcc->tx.atmvcc->stats->tx);
+	atomic_inc_wrap(&lvcc->tx.atmvcc->stats->tx);
 }
 
 /* Try to fill the buffer - don't call unless there is backlog */
@@ -1418,7 +1418,7 @@ static void vcc_rx_aal5(struct lanai_vcc *lvcc, int endptr)
 	ATM_SKB(skb)->vcc = lvcc->rx.atmvcc;
 	__net_timestamp(skb);
 	lvcc->rx.atmvcc->push(lvcc->rx.atmvcc, skb);
-	atomic_inc(&lvcc->rx.atmvcc->stats->rx);
+	atomic_inc_wrap(&lvcc->rx.atmvcc->stats->rx);
     out:
 	lvcc->rx.buf.ptr = end;
 	cardvcc_write(lvcc, endptr, vcc_rxreadptr);
@@ -1659,7 +1659,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		DPRINTK("(itf %d) got RX service entry 0x%X for non-AAL5 "
 		    "vcc %d\n", lanai->number, (unsigned int) s, vci);
 		lanai->stats.service_rxnotaal5++;
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_wrap(&lvcc->rx.atmvcc->stats->rx_err);
 		return 0;
 	}
 	if (likely(!(s & (SERVICE_TRASH | SERVICE_STREAM | SERVICE_CRCERR)))) {
@@ -1671,7 +1671,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		int bytes;
 		read_unlock(&vcc_sklist_lock);
 		DPRINTK("got trashed rx pdu on vci %d\n", vci);
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_wrap(&lvcc->rx.atmvcc->stats->rx_err);
 		lvcc->stats.x.aal5.service_trash++;
 		bytes = (SERVICE_GET_END(s) * 16) -
 		    (((unsigned long) lvcc->rx.buf.ptr) -
@@ -1683,7 +1683,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 	}
 	if (s & SERVICE_STREAM) {
 		read_unlock(&vcc_sklist_lock);
-		atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+		atomic_inc_wrap(&lvcc->rx.atmvcc->stats->rx_err);
 		lvcc->stats.x.aal5.service_stream++;
 		printk(KERN_ERR DEV_LABEL "(itf %d): Got AAL5 stream "
 		    "PDU on VCI %d!\n", lanai->number, vci);
@@ -1691,7 +1691,7 @@ static int handle_service(struct lanai_dev *lanai, u32 s)
 		return 0;
 	}
 	DPRINTK("got rx crc error on vci %d\n", vci);
-	atomic_inc(&lvcc->rx.atmvcc->stats->rx_err);
+	atomic_inc_wrap(&lvcc->rx.atmvcc->stats->rx_err);
 	lvcc->stats.x.aal5.service_rxcrc++;
 	lvcc->rx.buf.ptr = &lvcc->rx.buf.start[SERVICE_GET_END(s) * 4];
 	cardvcc_write(lvcc, SERVICE_GET_END(s), vcc_rxreadptr);
diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index c7296b5..5da3ba0 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -1635,7 +1635,7 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if ((vc = (vc_map *) vcc->dev_data) == NULL) {
 		printk("nicstar%d: vcc->dev_data == NULL on ns_send().\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1643,7 +1643,7 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if (!vc->tx) {
 		printk("nicstar%d: Trying to transmit on a non-tx VC.\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1651,14 +1651,14 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	if (vcc->qos.aal != ATM_AAL5 && vcc->qos.aal != ATM_AAL0) {
 		printk("nicstar%d: Only AAL0 and AAL5 are supported.\n",
 		       card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
 
 	if (skb_shinfo(skb)->nr_frags != 0) {
 		printk("nicstar%d: No scatter-gather yet.\n", card->index);
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EINVAL;
 	}
@@ -1706,11 +1706,11 @@ static int ns_send(struct atm_vcc *vcc, struct sk_buff *skb)
 	}
 
 	if (push_scqe(card, vc, scq, &scqe, skb) != 0) {
-		atomic_inc(&vcc->stats->tx_err);
+		atomic_inc_wrap(&vcc->stats->tx_err);
 		dev_kfree_skb_any(skb);
 		return -EIO;
 	}
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_wrap(&vcc->stats->tx);
 
 	return 0;
 }
@@ -2028,14 +2028,15 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				printk
 				    ("nicstar%d: Can't allocate buffers for aal0.\n",
 				     card->index);
-				atomic_add(i, &vcc->stats->rx_drop);
+				atomic_add_wrap(i, &vcc->stats->rx_drop);
 				break;
 			}
 			if (!atm_charge(vcc, sb->truesize)) {
 				RXPRINTK
 				    ("nicstar%d: atm_charge() dropped aal0 packets.\n",
 				     card->index);
-				atomic_add(i - 1, &vcc->stats->rx_drop);	/* already increased by 1 */
+				atomic_add_wrap(i - 1, &vcc->stats->rx_drop);
+						/* already increased by 1 */
 				dev_kfree_skb_any(sb);
 				break;
 			}
@@ -2050,7 +2051,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			ATM_SKB(sb)->vcc = vcc;
 			__net_timestamp(sb);
 			vcc->push(vcc, sb);
-			atomic_inc(&vcc->stats->rx);
+			atomic_inc_wrap(&vcc->stats->rx);
 			cell += ATM_CELL_PAYLOAD;
 		}
 
@@ -2067,7 +2068,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			if (iovb == NULL) {
 				printk("nicstar%d: Out of iovec buffers.\n",
 				       card->index);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_wrap(&vcc->stats->rx_drop);
 				recycle_rx_buf(card, skb);
 				return;
 			}
@@ -2091,7 +2092,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 		   small or large buffer itself. */
 	} else if (NS_PRV_IOVCNT(iovb) >= NS_MAX_IOVECS) {
 		printk("nicstar%d: received too big AAL5 SDU.\n", card->index);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_wrap(&vcc->stats->rx_err);
 		recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 				      NS_MAX_IOVECS);
 		NS_PRV_IOVCNT(iovb) = 0;
@@ -2111,7 +2112,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			    ("nicstar%d: Expected a small buffer, and this is not one.\n",
 			     card->index);
 			which_list(card, skb);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			recycle_rx_buf(card, skb);
 			vc->rx_iov = NULL;
 			recycle_iov_buf(card, iovb);
@@ -2124,7 +2125,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			    ("nicstar%d: Expected a large buffer, and this is not one.\n",
 			     card->index);
 			which_list(card, skb);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 					      NS_PRV_IOVCNT(iovb));
 			vc->rx_iov = NULL;
@@ -2147,7 +2148,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				printk(" - PDU size mismatch.\n");
 			else
 				printk(".\n");
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			recycle_iovec_rx_bufs(card, (struct iovec *)iovb->data,
 					      NS_PRV_IOVCNT(iovb));
 			vc->rx_iov = NULL;
@@ -2161,14 +2162,14 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			/* skb points to a small buffer */
 			if (!atm_charge(vcc, skb->truesize)) {
 				push_rxbufs(card, skb);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_wrap(&vcc->stats->rx_drop);
 			} else {
 				skb_put(skb, len);
 				dequeue_sm_buf(card, skb);
 				ATM_SKB(skb)->vcc = vcc;
 				__net_timestamp(skb);
 				vcc->push(vcc, skb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_wrap(&vcc->stats->rx);
 			}
 		} else if (NS_PRV_IOVCNT(iovb) == 2) {	/* One small plus one large buffer */
 			struct sk_buff *sb;
@@ -2179,14 +2180,14 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 			if (len <= NS_SMBUFSIZE) {
 				if (!atm_charge(vcc, sb->truesize)) {
 					push_rxbufs(card, sb);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_wrap(&vcc->stats->rx_drop);
 				} else {
 					skb_put(sb, len);
 					dequeue_sm_buf(card, sb);
 					ATM_SKB(sb)->vcc = vcc;
 					__net_timestamp(sb);
 					vcc->push(vcc, sb);
-					atomic_inc(&vcc->stats->rx);
+					atomic_inc_wrap(&vcc->stats->rx);
 				}
 
 				push_rxbufs(card, skb);
@@ -2195,7 +2196,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 
 				if (!atm_charge(vcc, skb->truesize)) {
 					push_rxbufs(card, skb);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_wrap(&vcc->stats->rx_drop);
 				} else {
 					dequeue_lg_buf(card, skb);
 					skb_push(skb, NS_SMBUFSIZE);
@@ -2205,7 +2206,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					ATM_SKB(skb)->vcc = vcc;
 					__net_timestamp(skb);
 					vcc->push(vcc, skb);
-					atomic_inc(&vcc->stats->rx);
+					atomic_inc_wrap(&vcc->stats->rx);
 				}
 
 				push_rxbufs(card, sb);
@@ -2226,7 +2227,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					printk
 					    ("nicstar%d: Out of huge buffers.\n",
 					     card->index);
-					atomic_inc(&vcc->stats->rx_drop);
+					atomic_inc_wrap(&vcc->stats->rx_drop);
 					recycle_iovec_rx_bufs(card,
 							      (struct iovec *)
 							      iovb->data,
@@ -2277,7 +2278,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 					card->hbpool.count++;
 				} else
 					dev_kfree_skb_any(hb);
-				atomic_inc(&vcc->stats->rx_drop);
+				atomic_inc_wrap(&vcc->stats->rx_drop);
 			} else {
 				/* Copy the small buffer to the huge buffer */
 				sb = (struct sk_buff *)iov->iov_base;
@@ -2311,7 +2312,7 @@ static void dequeue_rx(ns_dev * card, ns_rsqe * rsqe)
 				ATM_SKB(hb)->vcc = vcc;
 				__net_timestamp(hb);
 				vcc->push(vcc, hb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_wrap(&vcc->stats->rx);
 			}
 		}
 
diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 6ac2b2b..3547869 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -849,7 +849,7 @@ static void solos_bh(unsigned long card_arg)
 				}
 				atm_charge(vcc, skb->truesize);
 				vcc->push(vcc, skb);
-				atomic_inc(&vcc->stats->rx);
+				atomic_inc_wrap(&vcc->stats->rx);
 				break;
 
 			case PKT_STATUS:
@@ -1130,7 +1130,7 @@ static uint32_t fpga_tx(struct solos_card *card)
 			vcc = SKB_CB(oldskb)->vcc;
 
 			if (vcc) {
-				atomic_inc(&vcc->stats->tx);
+				atomic_inc_wrap(&vcc->stats->tx);
 				solos_pop(vcc, oldskb);
 			} else {
 				dev_kfree_skb_irq(oldskb);
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 0215934..5f589a7 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -49,8 +49,9 @@ static DEFINE_SPINLOCK(sunis_lock);
 
 
 #define ADD_LIMITED(s,v) \
-    atomic_add((v),&stats->s); \
-    if (atomic_read(&stats->s) < 0) atomic_set(&stats->s,INT_MAX);
+    atomic_add_wrap((v), &stats->s); \
+    if (atomic_read_wrap(&stats->s) < 0) \
+		atomic_set_wrap(&stats->s,INT_MAX);
 
 
 static void suni_hz(unsigned long from_timer)
diff --git a/drivers/atm/uPD98402.c b/drivers/atm/uPD98402.c
index 5120a96..c1ecb8a 100644
--- a/drivers/atm/uPD98402.c
+++ b/drivers/atm/uPD98402.c
@@ -42,7 +42,7 @@ static int fetch_stats(struct atm_dev *dev,struct sonet_stats __user *arg,int ze
 	struct sonet_stats tmp;
  	int error = 0;
 
-	atomic_add(GET(HECCT),&PRIV(dev)->sonet_stats.uncorr_hcs);
+	atomic_add_wrap(GET(HECCT),&PRIV(dev)->sonet_stats.uncorr_hcs);
 	sonet_copy_stats(&PRIV(dev)->sonet_stats,&tmp);
 	if (arg) error = copy_to_user(arg,&tmp,sizeof(tmp));
 	if (zero && !error) {
@@ -161,9 +161,9 @@ static int uPD98402_ioctl(struct atm_dev *dev,unsigned int cmd,void __user *arg)
 
 
 #define ADD_LIMITED(s,v) \
-    { atomic_add(GET(v),&PRIV(dev)->sonet_stats.s); \
-    if (atomic_read(&PRIV(dev)->sonet_stats.s) < 0) \
-	atomic_set(&PRIV(dev)->sonet_stats.s,INT_MAX); }
+    { atomic_add_wrap(GET(v),&PRIV(dev)->sonet_stats.s); \
+    if (atomic_read_wrap(&PRIV(dev)->sonet_stats.s) < 0) \
+	atomic_set_wrap(&PRIV(dev)->sonet_stats.s,INT_MAX); }
 
 
 static void stat_event(struct atm_dev *dev)
@@ -194,7 +194,7 @@ static void uPD98402_int(struct atm_dev *dev)
 		if (reason & uPD98402_INT_PFM) stat_event(dev);
 		if (reason & uPD98402_INT_PCO) {
 			(void) GET(PCOCR); /* clear interrupt cause */
-			atomic_add(GET(HECCT),
+			atomic_add_wrap(GET(HECCT),
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
+	atomic_set_wrap(&PRIV(dev)->sonet_stats.corr_hcs,-1);
+	atomic_set_wrap(&PRIV(dev)->sonet_stats.tx_cells,-1);
+	atomic_set_wrap(&PRIV(dev)->sonet_stats.rx_cells,-1);
 	return 0;
 }
 
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index d3dc954..1a901d8 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -459,7 +459,8 @@ printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
 		}
 		if (!size) {
 			dev_kfree_skb_irq(skb);
-			if (vcc) atomic_inc(&vcc->stats->rx_err);
+			if (vcc)
+				atomic_inc_wrap(&vcc->stats->rx_err);
 			continue;
 		}
 		if (!atm_charge(vcc,skb->truesize)) {
@@ -469,7 +470,7 @@ printk("dummy: 0x%08lx, 0x%08lx\n",dummy[0],dummy[1]);
 		skb->len = size;
 		ATM_SKB(skb)->vcc = vcc;
 		vcc->push(vcc,skb);
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 	}
 	zout(pos & 0xffff,MTA(mbx));
 #if 0 /* probably a stupid idea */
@@ -734,7 +735,7 @@ if (*ZATM_PRV_DSC(skb) != (uPD98401_TXPD_V | uPD98401_TXPD_DP |
 			skb_queue_head(&zatm_vcc->backlog,skb);
 			break;
 		}
-	atomic_inc(&vcc->stats->tx);
+	atomic_inc_wrap(&vcc->stats->tx);
 	wake_up(&zatm_vcc->tx_wait);
 }
 
diff --git a/drivers/usb/atm/usbatm.c b/drivers/usb/atm/usbatm.c
index 4dec9df..775d623 100644
--- a/drivers/usb/atm/usbatm.c
+++ b/drivers/usb/atm/usbatm.c
@@ -331,7 +331,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (printk_ratelimit())
 			atm_warn(instance, "%s: OAM not supported (vpi %d, vci %d)!\n",
 				__func__, vpi, vci);
-		atomic_inc(&vcc->stats->rx_err);
+		atomic_inc_wrap(&vcc->stats->rx_err);
 		return;
 	}
 
@@ -358,7 +358,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (length > ATM_MAX_AAL5_PDU) {
 			atm_rldbg(instance, "%s: bogus length %u (vcc: 0x%p)!\n",
 				  __func__, length, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			goto out;
 		}
 
@@ -367,14 +367,14 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 		if (sarb->len < pdu_length) {
 			atm_rldbg(instance, "%s: bogus pdu_length %u (sarb->len: %u, vcc: 0x%p)!\n",
 				  __func__, pdu_length, sarb->len, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			goto out;
 		}
 
 		if (crc32_be(~0, skb_tail_pointer(sarb) - pdu_length, pdu_length) != 0xc704dd7b) {
 			atm_rldbg(instance, "%s: packet failed crc check (vcc: 0x%p)!\n",
 				  __func__, vcc);
-			atomic_inc(&vcc->stats->rx_err);
+			atomic_inc_wrap(&vcc->stats->rx_err);
 			goto out;
 		}
 
@@ -387,7 +387,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 			if (printk_ratelimit())
 				atm_err(instance, "%s: no memory for skb (length: %u)!\n",
 					__func__, length);
-			atomic_inc(&vcc->stats->rx_drop);
+			atomic_inc_wrap(&vcc->stats->rx_drop);
 			goto out;
 		}
 
@@ -415,7 +415,7 @@ static void usbatm_extract_one_cell(struct usbatm_data *instance, unsigned char
 
 		vcc->push(vcc, skb);
 
-		atomic_inc(&vcc->stats->rx);
+		atomic_inc_wrap(&vcc->stats->rx);
 	out:
 		skb_trim(sarb, 0);
 	}
@@ -613,7 +613,7 @@ static void usbatm_tx_process(unsigned long data)
 			struct atm_vcc *vcc = UDSL_SKB(skb)->atm.vcc;
 
 			usbatm_pop(vcc, skb);
-			atomic_inc(&vcc->stats->tx);
+			atomic_inc_wrap(&vcc->stats->tx);
 
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
+			       atomic_read_wrap(&atm_dev->stats.aal5.tx),
+			       atomic_read_wrap(&atm_dev->stats.aal5.tx_err),
+			       atomic_read_wrap(&atm_dev->stats.aal5.rx),
+			       atomic_read_wrap(&atm_dev->stats.aal5.rx_err),
+			       atomic_read_wrap(&atm_dev->stats.aal5.rx_drop));
 
 	if (!left--) {
 		if (instance->disconnected)
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index c1da539..3517cd2 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -28,7 +28,7 @@ struct compat_atm_iobuf {
 #endif
 
 struct k_atm_aal_stats {
-#define __HANDLE_ITEM(i) atomic_t i
+#define __HANDLE_ITEM(i) atomic_wrap_t i
 	__AAL_STAT_ITEMS
 #undef __HANDLE_ITEM
 };
diff --git a/include/linux/sonet.h b/include/linux/sonet.h
index 680f9a3..5ac02b6 100644
--- a/include/linux/sonet.h
+++ b/include/linux/sonet.h
@@ -7,7 +7,7 @@
 #include <uapi/linux/sonet.h>
 
 struct k_sonet_stats {
-#define __HANDLE_ITEM(i) atomic_t i
+#define __HANDLE_ITEM(i) atomic_wrap_t i
 	__SONET_ITEMS
 #undef __HANDLE_ITEM
 };
diff --git a/net/atm/atm_misc.c b/net/atm/atm_misc.c
index 876fbe8..32d1f18 100644
--- a/net/atm/atm_misc.c
+++ b/net/atm/atm_misc.c
@@ -17,7 +17,7 @@ int atm_charge(struct atm_vcc *vcc, int truesize)
 	if (atomic_read(&sk_atm(vcc)->sk_rmem_alloc) <= sk_atm(vcc)->sk_rcvbuf)
 		return 1;
 	atm_return(vcc, truesize);
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_wrap(&vcc->stats->rx_drop);
 	return 0;
 }
 EXPORT_SYMBOL(atm_charge);
@@ -39,7 +39,7 @@ struct sk_buff *atm_alloc_charge(struct atm_vcc *vcc, int pdu_size,
 		}
 	}
 	atm_return(vcc, guess);
-	atomic_inc(&vcc->stats->rx_drop);
+	atomic_inc_wrap(&vcc->stats->rx_drop);
 	return NULL;
 }
 EXPORT_SYMBOL(atm_alloc_charge);
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(atm_pcr_goal);
 
 void sonet_copy_stats(struct k_sonet_stats *from, struct sonet_stats *to)
 {
-#define __HANDLE_ITEM(i) to->i = atomic_read(&from->i)
+#define __HANDLE_ITEM(i) (to->i = atomic_read_wrap(&from->i))
 	__SONET_ITEMS
 #undef __HANDLE_ITEM
 }
@@ -94,7 +94,7 @@ EXPORT_SYMBOL(sonet_copy_stats);
 
 void sonet_subtract_stats(struct k_sonet_stats *from, struct sonet_stats *to)
 {
-#define __HANDLE_ITEM(i) atomic_sub(to->i, &from->i)
+#define __HANDLE_ITEM(i) atomic_sub_wrap(to->i, &from->i)
 	__SONET_ITEMS
 #undef __HANDLE_ITEM
 }
diff --git a/net/atm/proc.c b/net/atm/proc.c
index bbb6461..ec27520 100644
--- a/net/atm/proc.c
+++ b/net/atm/proc.c
@@ -45,9 +45,11 @@ static void add_stats(struct seq_file *seq, const char *aal,
   const struct k_atm_aal_stats *stats)
 {
 	seq_printf(seq, "%s ( %d %d %d %d %d )", aal,
-		   atomic_read(&stats->tx), atomic_read(&stats->tx_err),
-		   atomic_read(&stats->rx), atomic_read(&stats->rx_err),
-		   atomic_read(&stats->rx_drop));
+		   atomic_read_wrap(&stats->tx),
+		   atomic_read_wrap(&stats->tx_err),
+		   atomic_read_wrap(&stats->rx),
+		   atomic_read_wrap(&stats->rx_err),
+		   atomic_read_wrap(&stats->rx_drop));
 }
 
 static void atm_dev_info(struct seq_file *seq, const struct atm_dev *dev)
diff --git a/net/atm/resources.c b/net/atm/resources.c
index 0447d5d..a024ba9 100644
--- a/net/atm/resources.c
+++ b/net/atm/resources.c
@@ -160,7 +160,7 @@ EXPORT_SYMBOL(atm_dev_deregister);
 static void copy_aal_stats(struct k_atm_aal_stats *from,
     struct atm_aal_stats *to)
 {
-#define __HANDLE_ITEM(i) to->i = atomic_read(&from->i)
+#define __HANDLE_ITEM(i) (to->i = atomic_read_wrap(&from->i))
 	__AAL_STAT_ITEMS
 #undef __HANDLE_ITEM
 }
@@ -168,7 +168,7 @@ static void copy_aal_stats(struct k_atm_aal_stats *from,
 static void subtract_aal_stats(struct k_atm_aal_stats *from,
     struct atm_aal_stats *to)
 {
-#define __HANDLE_ITEM(i) atomic_sub(to->i, &from->i)
+#define __HANDLE_ITEM(i) atomic_sub_wrap(to->i, &from->i)
 	__AAL_STAT_ITEMS
 #undef __HANDLE_ITEM
 }
-- 
2.7.4
