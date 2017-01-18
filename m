Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:41 +0200
Message-Id: <1484730707-29313-13-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 12/18] sound: convert from atomic_t to refcount_t
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
 sound/core/seq/seq_clientmgr.c |  2 +-
 sound/core/seq/seq_ports.c     |  8 ++++----
 sound/core/seq/seq_ports.h     |  3 ++-
 sound/usb/card.c               | 10 +++++-----
 sound/usb/usbaudio.h           |  4 +++-
 5 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 4c93520..3440f76 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -666,7 +666,7 @@ static int deliver_to_subscribers(struct snd_seq_client *client,
 		down_read(&grp->list_mutex);
 	list_for_each_entry(subs, &grp->list_head, src_list) {
 		/* both ports ready? */
-		if (atomic_read(&subs->ref_count) != 2)
+		if (refcount_read(&subs->ref_count) != 2)
 			continue;
 		event->dest = subs->info.dest;
 		if (subs->info.flags & SNDRV_SEQ_PORT_SUBS_TIMESTAMP)
diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index fe686ee..d9b21a1 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -241,7 +241,7 @@ static void clear_subscriber_list(struct snd_seq_client *client,
 			 * we decrease the counter, and when both ports are deleted
 			 * remove the subscriber info
 			 */
-			if (atomic_dec_and_test(&subs->ref_count))
+			if (refcount_dec_and_test(&subs->ref_count))
 				kfree(subs);
 			continue;
 		}
@@ -520,7 +520,7 @@ static int check_and_subscribe_port(struct snd_seq_client *client,
 	else
 		list_add_tail(&subs->dest_list, &grp->list_head);
 	grp->exclusive = exclusive;
-	atomic_inc(&subs->ref_count);
+	refcount_inc(&subs->ref_count);
 	write_unlock_irq(&grp->list_lock);
 	err = 0;
 
@@ -570,7 +570,7 @@ int snd_seq_port_connect(struct snd_seq_client *connector,
 		return -ENOMEM;
 
 	subs->info = *info;
-	atomic_set(&subs->ref_count, 0);
+	refcount_set(&subs->ref_count, 0);
 	INIT_LIST_HEAD(&subs->src_list);
 	INIT_LIST_HEAD(&subs->dest_list);
 
@@ -613,7 +613,7 @@ int snd_seq_port_disconnect(struct snd_seq_client *connector,
 	/* look for the connection */
 	list_for_each_entry(subs, &src->list_head, src_list) {
 		if (match_subs_info(info, &subs->info)) {
-			atomic_dec(&subs->ref_count); /* mark as not ready */
+			refcount_dec(&subs->ref_count); /* mark as not ready */
 			err = 0;
 			break;
 		}
diff --git a/sound/core/seq/seq_ports.h b/sound/core/seq/seq_ports.h
index 26bd71f..d09e396 100644
--- a/sound/core/seq/seq_ports.h
+++ b/sound/core/seq/seq_ports.h
@@ -21,6 +21,7 @@
 #ifndef __SND_SEQ_PORTS_H
 #define __SND_SEQ_PORTS_H
 
+#include <linux/refcount.h>
 #include <sound/seq_kernel.h>
 #include "seq_lock.h"
 
@@ -44,7 +45,7 @@ struct snd_seq_subscribers {
 	struct snd_seq_port_subscribe info;	/* additional info */
 	struct list_head src_list;	/* link of sources */
 	struct list_head dest_list;	/* link of destinations */
-	atomic_t ref_count;
+	refcount_t ref_count;
 };
 
 struct snd_seq_port_subs_info {
diff --git a/sound/usb/card.c b/sound/usb/card.c
index f36cb06..ff3a1d5 100644
--- a/sound/usb/card.c
+++ b/sound/usb/card.c
@@ -378,7 +378,7 @@ static int snd_usb_audio_create(struct usb_interface *intf,
 	chip->setup = device_setup[idx];
 	chip->autoclock = autoclock;
 	atomic_set(&chip->active, 1); /* avoid autopm during probing */
-	atomic_set(&chip->usage_count, 0);
+	refcount_set(&chip->usage_count, 0);
 	atomic_set(&chip->shutdown, 0);
 
 	chip->usb_id = USB_ID(le16_to_cpu(dev->descriptor.idVendor),
@@ -657,7 +657,7 @@ static void usb_audio_disconnect(struct usb_interface *intf)
 		 * they are protected by snd_usb_lock_shutdown()
 		 */
 		wait_event(chip->shutdown_wait,
-			   !atomic_read(&chip->usage_count));
+			   !refcount_read(&chip->usage_count));
 		snd_card_disconnect(card);
 		/* release the pcm resources */
 		list_for_each_entry(as, &chip->pcm_list, list) {
@@ -692,7 +692,7 @@ int snd_usb_lock_shutdown(struct snd_usb_audio *chip)
 {
 	int err;
 
-	atomic_inc(&chip->usage_count);
+	refcount_inc(&chip->usage_count);
 	if (atomic_read(&chip->shutdown)) {
 		err = -EIO;
 		goto error;
@@ -703,7 +703,7 @@ int snd_usb_lock_shutdown(struct snd_usb_audio *chip)
 	return 0;
 
  error:
-	if (atomic_dec_and_test(&chip->usage_count))
+	if (refcount_dec_and_test(&chip->usage_count))
 		wake_up(&chip->shutdown_wait);
 	return err;
 }
@@ -712,7 +712,7 @@ int snd_usb_lock_shutdown(struct snd_usb_audio *chip)
 void snd_usb_unlock_shutdown(struct snd_usb_audio *chip)
 {
 	snd_usb_autosuspend(chip);
-	if (atomic_dec_and_test(&chip->usage_count))
+	if (refcount_dec_and_test(&chip->usage_count))
 		wake_up(&chip->shutdown_wait);
 }
 
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 4d5c89a..74785d0 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -26,6 +26,8 @@
 #define USB_ID_VENDOR(id) ((id) >> 16)
 #define USB_ID_PRODUCT(id) ((u16)(id))
 
+#include <linux/refcount.h>
+
 /*
  *
  */
@@ -40,7 +42,7 @@ struct snd_usb_audio {
 	unsigned int autosuspended:1;	
 	atomic_t active;
 	atomic_t shutdown;
-	atomic_t usage_count;
+	refcount_t usage_count;
 	wait_queue_head_t shutdown_wait;
 	unsigned int txfr_quirk:1; /* Subframe boundaries on transfers */
 	unsigned int tx_length_quirk:1; /* Put length specifier in transfers */
-- 
2.7.4
