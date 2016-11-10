Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Thu, 10 Nov 2016 22:24:44 +0200
Message-Id: <1478809488-18303-10-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC v4 PATCH 09/13] drivers: identify wrapping atomic usage (part 1/2)
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
 drivers/acpi/apei/ghes.c                  |   4 +-
 drivers/ata/libata-core.c                 |   5 +-
 drivers/ata/libata-scsi.c                 |   2 +-
 drivers/ata/libata.h                      |   2 +-
 drivers/base/power/wakeup.c               |   8 +-
 drivers/block/drbd/drbd_bitmap.c          |   2 +-
 drivers/block/drbd/drbd_int.h             |   9 +-
 drivers/block/drbd/drbd_main.c            |  15 +--
 drivers/block/drbd/drbd_nl.c              |  16 +--
 drivers/block/drbd/drbd_receiver.c        |  34 +++----
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
 drivers/gpu/drm/mga/mga_irq.c             |   9 +-
 drivers/gpu/drm/qxl/qxl_cmd.c             |  12 +--
 drivers/gpu/drm/qxl/qxl_debugfs.c         |   8 +-
 drivers/gpu/drm/qxl/qxl_drv.h             |   8 +-
 drivers/gpu/drm/qxl/qxl_irq.c             |  16 +--
 drivers/gpu/drm/r128/r128_cce.c           |   2 +-
 drivers/gpu/drm/r128/r128_drv.h           |   4 +-
 drivers/gpu/drm/r128/r128_irq.c           |   4 +-
 drivers/gpu/drm/r128/r128_state.c         |   4 +-
 drivers/gpu/drm/via/via_drv.h             |   4 +-
 drivers/gpu/drm/via/via_irq.c             |  18 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |   2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c      |   6 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_irq.c       |   4 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_marker.c    |   2 +-
 drivers/hid/hid-core.c                    |   4 +-
 drivers/hv/channel.c                      |   4 +-
 drivers/hv/hv_balloon.c                   |  19 ++--
 drivers/hv/hyperv_vmbus.h                 |   2 +-
 drivers/hwmon/sht15.c                     |  12 +--
 drivers/infiniband/core/cm.c              |  52 +++++-----
 drivers/infiniband/core/fmr_pool.c        |  23 +++--
 drivers/infiniband/hw/cxgb4/mem.c         |   4 +-
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
 drivers/input/misc/ims-pcu.c              |   4 +-
 drivers/input/serio/serio.c               |   4 +-
 drivers/input/serio/serio_raw.c           |   4 +-
 drivers/isdn/capi/capi.c                  |  11 ++-
 drivers/md/dm-core.h                      |   4 +-
 drivers/md/dm-raid.c                      |   3 +-
 drivers/md/dm-raid1.c                     |  18 ++--
 drivers/md/dm-stripe.c                    |  11 ++-
 drivers/md/dm.c                           |  12 +--
 drivers/md/md.c                           |  32 +++---
 drivers/md/md.h                           |  15 +--
 drivers/md/raid1.c                        |   8 +-
 drivers/md/raid10.c                       |  20 ++--
 drivers/md/raid5.c                        |  17 ++--
 drivers/media/pci/ivtv/ivtv-driver.c      |   2 +-
 drivers/media/pci/solo6x10/solo6x10-p2m.c |   3 +-
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
 include/linux/genhd.h                     |   2 +-
 include/media/v4l2-device.h               |   2 +-
 88 files changed, 491 insertions(+), 459 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index f0a029e..c25a4be 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -483,7 +483,7 @@ static void __ghes_print_estatus(const char *pfx,
 				 const struct acpi_hest_generic *generic,
 				 const struct acpi_hest_generic_status *estatus)
 {
-	static atomic_t seqno;
+	static atomic_wrap_t seqno;
 	unsigned int curr_seqno;
 	char pfx_seq[64];
 
@@ -494,7 +494,7 @@ static void __ghes_print_estatus(const char *pfx,
 		else
 			pfx = KERN_ERR;
 	}
-	curr_seqno = atomic_inc_return(&seqno);
+	curr_seqno = atomic_inc_return_wrap(&seqno);
 	snprintf(pfx_seq, sizeof(pfx_seq), "%s{%u}" HW_ERR, pfx, curr_seqno);
 	printk("%s""Hardware error from APEI Generic Hardware Error Source: %d\n",
 	       pfx_seq, generic->header.source_id);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 223a770..2f2565c 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -105,7 +105,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-atomic_t ata_print_id = ATOMIC_INIT(0);
+atomic_wrap_t ata_print_id = ATOMIC_INIT(0);
 
 struct ata_force_param {
 	const char	*name;
@@ -6327,7 +6327,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++) {
-		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
+		host->ports[i]->print_id =
+			atomic_inc_return_wrap(&ata_print_id);
 		host->ports[i]->local_port_no = i + 1;
 	}
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9cceb4a..fb247ec 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4907,7 +4907,7 @@ int ata_sas_port_init(struct ata_port *ap)
 
 	if (rc)
 		return rc;
-	ap->print_id = atomic_inc_return(&ata_print_id);
+	ap->print_id = atomic_inc_return_wrap(&ata_print_id);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_init);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 3b301a4..7f7a622 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -53,7 +53,7 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
-extern atomic_t ata_print_id;
+extern atomic_wrap_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 62e4de2..efed054 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -36,14 +36,14 @@ static bool pm_abort_suspend __read_mostly;
  * They need to be modified together atomically, so it's better to use one
  * atomic variable to hold them both.
  */
-static atomic_t combined_event_count = ATOMIC_INIT(0);
+static atomic_wrap_t combined_event_count = ATOMIC_INIT(0);
 
 #define IN_PROGRESS_BITS	(sizeof(int) * 4)
 #define MAX_IN_PROGRESS		((1 << IN_PROGRESS_BITS) - 1)
 
 static void split_counters(unsigned int *cnt, unsigned int *inpr)
 {
-	unsigned int comb = atomic_read(&combined_event_count);
+	unsigned int comb = atomic_read_wrap(&combined_event_count);
 
 	*cnt = (comb >> IN_PROGRESS_BITS);
 	*inpr = comb & MAX_IN_PROGRESS;
@@ -538,7 +538,7 @@ static void wakeup_source_activate(struct wakeup_source *ws)
 		ws->start_prevent_time = ws->last_time;
 
 	/* Increment the counter of events in progress. */
-	cec = atomic_inc_return(&combined_event_count);
+	cec = atomic_inc_return_wrap(&combined_event_count);
 
 	trace_wakeup_source_activate(ws->name, cec);
 }
@@ -664,7 +664,7 @@ static void wakeup_source_deactivate(struct wakeup_source *ws)
 	 * Increment the counter of registered wakeup events and decrement the
 	 * couter of wakeup events in progress simultaneously.
 	 */
-	cec = atomic_add_return(MAX_IN_PROGRESS, &combined_event_count);
+	cec = atomic_add_return_wrap(MAX_IN_PROGRESS, &combined_event_count);
 	trace_wakeup_source_deactivate(ws->name, cec);
 
 	split_counters(&cnt, &inpr);
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index ab62b81..637619c 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1034,7 +1034,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 		submit_bio(bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
-		atomic_add(len >> 9, &device->rs_sect_ev);
+		atomic_add_wrap(len >> 9, &device->rs_sect_ev);
 	}
 }
 
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4cb8f21..7bbe3b8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -383,7 +383,7 @@ struct drbd_epoch {
 	struct drbd_connection *connection;
 	struct list_head list;
 	unsigned int barrier_nr;
-	atomic_t epoch_size; /* increased on every request added. */
+	atomic_wrap_t epoch_size; /* increased on every request added. */
 	atomic_t active;     /* increased on every req. added, and dec on every finished. */
 	unsigned long flags;
 };
@@ -960,7 +960,7 @@ struct drbd_device {
 	unsigned int al_tr_number;
 	int al_tr_cycle;
 	wait_queue_head_t seq_wait;
-	atomic_t packet_seq;
+	atomic_wrap_t packet_seq;
 	unsigned int peer_seq;
 	spinlock_t peer_seq_lock;
 	unsigned long comm_bm_set; /* communicated number of set bits. */
@@ -969,8 +969,9 @@ struct drbd_device {
 	struct mutex own_state_mutex;
 	struct mutex *state_mutex; /* either own_state_mutex or first_peer_device(device)->connection->cstate_mutex */
 	char congestion_reason;  /* Why we where congested... */
-	atomic_t rs_sect_in; /* for incoming resync data rate, SyncTarget */
-	atomic_t rs_sect_ev; /* for submitted resync data rate, both */
+	atomic_wrap_t rs_sect_in;
+			/* for incoming resync data rate, SyncTarget */
+	atomic_wrap_t rs_sect_ev; /* for submitted resync data rate, both */
 	int rs_last_sect_ev; /* counter to compare with */
 	int rs_last_events;  /* counter of read or write "events" (unit sectors)
 			      * on the lower level device when we last looked. */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 100be55..7ee89e9 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1363,7 +1363,8 @@ static int _drbd_send_ack(struct drbd_peer_device *peer_device, enum drbd_packet
 	p->sector = sector;
 	p->block_id = block_id;
 	p->blksize = blksize;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&peer_device->device->packet_seq));
+	p->seq_num = cpu_to_be32(atomic_inc_return_wrap(&peer_device->
+				device->packet_seq));
 	return drbd_send_command(peer_device, sock, cmd, sizeof(*p), NULL, 0);
 }
 
@@ -1695,7 +1696,7 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 		return -EIO;
 	p->sector = cpu_to_be64(req->i.sector);
 	p->block_id = (unsigned long)req;
-	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
+	p->seq_num = cpu_to_be32(atomic_inc_return_wrap(&device->packet_seq));
 	dp_flags = bio_flags_to_wire(peer_device->connection, req->master_bio);
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
@@ -1984,8 +1985,8 @@ void drbd_init_set_defaults(struct drbd_device *device)
 	atomic_set(&device->unacked_cnt, 0);
 	atomic_set(&device->local_cnt, 0);
 	atomic_set(&device->pp_in_use_by_net, 0);
-	atomic_set(&device->rs_sect_in, 0);
-	atomic_set(&device->rs_sect_ev, 0);
+	atomic_set_wrap(&device->rs_sect_in, 0);
+	atomic_set_wrap(&device->rs_sect_ev, 0);
 	atomic_set(&device->ap_in_flight, 0);
 	atomic_set(&device->md_io.in_use, 0);
 
@@ -2752,8 +2753,10 @@ void drbd_destroy_connection(struct kref *kref)
 	struct drbd_connection *connection = container_of(kref, struct drbd_connection, kref);
 	struct drbd_resource *resource = connection->resource;
 
-	if (atomic_read(&connection->current_epoch->epoch_size) !=  0)
-		drbd_err(connection, "epoch_size:%d\n", atomic_read(&connection->current_epoch->epoch_size));
+	if (atomic_read_wrap(&connection->current_epoch->epoch_size) !=  0)
+		drbd_err(connection, "epoch_size:%d\n",
+				atomic_read_wrap(&connection->
+					current_epoch->epoch_size));
 	kfree(connection->current_epoch);
 
 	idr_destroy(&connection->peer_devices);
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f35db29..224cdf3 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -89,8 +89,8 @@ int drbd_adm_get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 #include "drbd_nla.h"
 #include <linux/genl_magic_func.h>
 
-static atomic_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
-static atomic_t notify_genl_seq = ATOMIC_INIT(2); /* two. */
+static atomic_wrap_t drbd_genl_seq = ATOMIC_INIT(2); /* two. */
+static atomic_wrap_t notify_genl_seq = ATOMIC_INIT(2); /* two. */
 
 DEFINE_MUTEX(notification_mutex);
 
@@ -4549,7 +4549,7 @@ void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib)
 	unsigned seq;
 	int err = -ENOMEM;
 
-	seq = atomic_inc_return(&drbd_genl_seq);
+	seq = atomic_inc_return_wrap(&drbd_genl_seq);
 	msg = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 	if (!msg)
 		goto failed;
@@ -4601,7 +4601,7 @@ void notify_resource_state(struct sk_buff *skb,
 	int err;
 
 	if (!skb) {
-		seq = atomic_inc_return(&notify_genl_seq);
+		seq = atomic_inc_return_wrap(&notify_genl_seq);
 		skb = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 		err = -ENOMEM;
 		if (!skb)
@@ -4652,7 +4652,7 @@ void notify_device_state(struct sk_buff *skb,
 	int err;
 
 	if (!skb) {
-		seq = atomic_inc_return(&notify_genl_seq);
+		seq = atomic_inc_return_wrap(&notify_genl_seq);
 		skb = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 		err = -ENOMEM;
 		if (!skb)
@@ -4701,7 +4701,7 @@ void notify_connection_state(struct sk_buff *skb,
 	int err;
 
 	if (!skb) {
-		seq = atomic_inc_return(&notify_genl_seq);
+		seq = atomic_inc_return_wrap(&notify_genl_seq);
 		skb = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 		err = -ENOMEM;
 		if (!skb)
@@ -4751,7 +4751,7 @@ void notify_peer_device_state(struct sk_buff *skb,
 	int err;
 
 	if (!skb) {
-		seq = atomic_inc_return(&notify_genl_seq);
+		seq = atomic_inc_return_wrap(&notify_genl_seq);
 		skb = genlmsg_new(NLMSG_GOODSIZE, GFP_NOIO);
 		err = -ENOMEM;
 		if (!skb)
@@ -4794,7 +4794,7 @@ void notify_helper(enum drbd_notification_type type,
 {
 	struct drbd_resource *resource = device ? device->resource : connection->resource;
 	struct drbd_helper_info helper_info;
-	unsigned int seq = atomic_inc_return(&notify_genl_seq);
+	unsigned int seq = atomic_inc_return_wrap(&notify_genl_seq);
 	struct sk_buff *skb = NULL;
 	struct drbd_genlmsghdr *dh;
 	int err;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 942384f..b0deeeb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -898,7 +898,7 @@ int drbd_connected(struct drbd_peer_device *peer_device)
 	struct drbd_device *device = peer_device->device;
 	int err;
 
-	atomic_set(&device->packet_seq, 0);
+	atomic_set_wrap(&device->packet_seq, 0);
 	device->peer_seq = 0;
 
 	device->state_mutex = peer_device->connection->agreed_pro_version < 100 ?
@@ -1333,7 +1333,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 	do {
 		next_epoch = NULL;
 
-		epoch_size = atomic_read(&epoch->epoch_size);
+		epoch_size = atomic_read_wrap(&epoch->epoch_size);
 
 		switch (ev & ~EV_CLEANUP) {
 		case EV_PUT:
@@ -1373,7 +1373,7 @@ static enum finish_epoch drbd_may_finish_epoch(struct drbd_connection *connectio
 					rv = FE_DESTROYED;
 			} else {
 				epoch->flags = 0;
-				atomic_set(&epoch->epoch_size, 0);
+				atomic_set_wrap(&epoch->epoch_size, 0);
 				/* atomic_set(&epoch->active, 0); is already zero */
 				if (rv == FE_STILL_LIVE)
 					rv = FE_RECYCLED;
@@ -1759,7 +1759,7 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 		conn_wait_active_ee_empty(connection);
 		drbd_flush(connection);
 
-		if (atomic_read(&connection->current_epoch->epoch_size)) {
+		if (atomic_read_wrap(&connection->current_epoch->epoch_size)) {
 			epoch = kmalloc(sizeof(struct drbd_epoch), GFP_NOIO);
 			if (epoch)
 				break;
@@ -1773,11 +1773,11 @@ static int receive_Barrier(struct drbd_connection *connection, struct packet_inf
 	}
 
 	epoch->flags = 0;
-	atomic_set(&epoch->epoch_size, 0);
+	atomic_set_wrap(&epoch->epoch_size, 0);
 	atomic_set(&epoch->active, 0);
 
 	spin_lock(&connection->epoch_lock);
-	if (atomic_read(&connection->current_epoch->epoch_size)) {
+	if (atomic_read_wrap(&connection->current_epoch->epoch_size)) {
 		list_add(&epoch->list, &connection->current_epoch->list);
 		connection->current_epoch = epoch;
 		connection->epochs++;
@@ -2052,7 +2052,7 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	list_add_tail(&peer_req->w.list, &device->sync_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	atomic_add(pi->size >> 9, &device->rs_sect_ev);
+	atomic_add_wrap(pi->size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, REQ_OP_WRITE, 0,
 				     DRBD_FAULT_RS_WR) == 0)
 		return 0;
@@ -2151,7 +2151,7 @@ static int receive_RSDataReply(struct drbd_connection *connection, struct packet
 		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
 	}
 
-	atomic_add(pi->size >> 9, &device->rs_sect_in);
+	atomic_add_wrap(pi->size >> 9, &device->rs_sect_in);
 
 	return err;
 }
@@ -2548,7 +2548,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 		err = wait_for_and_update_peer_seq(peer_device, peer_seq);
 		drbd_send_ack_dp(peer_device, P_NEG_ACK, p, pi->size);
-		atomic_inc(&connection->current_epoch->epoch_size);
+		atomic_inc_wrap(&connection->current_epoch->epoch_size);
 		err2 = drbd_drain_block(peer_device, pi->size);
 		if (!err)
 			err = err2;
@@ -2589,7 +2589,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 
 	spin_lock(&connection->epoch_lock);
 	peer_req->epoch = connection->current_epoch;
-	atomic_inc(&peer_req->epoch->epoch_size);
+	atomic_inc_wrap(&peer_req->epoch->epoch_size);
 	atomic_inc(&peer_req->epoch->active);
 	spin_unlock(&connection->epoch_lock);
 
@@ -2735,7 +2735,7 @@ bool drbd_rs_c_min_rate_throttle(struct drbd_device *device)
 
 	curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 		      (int)part_stat_read(&disk->part0, sectors[1]) -
-			atomic_read(&device->rs_sect_ev);
+			atomic_read_wrap(&device->rs_sect_ev);
 
 	if (atomic_read(&device->ap_actlog_cnt)
 	    || curr_events - device->rs_last_events > 64) {
@@ -2881,7 +2881,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 			device->use_csums = true;
 		} else if (pi->cmd == P_OV_REPLY) {
 			/* track progress, we may need to throttle */
-			atomic_add(size >> 9, &device->rs_sect_in);
+			atomic_add_wrap(size >> 9, &device->rs_sect_in);
 			peer_req->w.cb = w_e_end_ov_reply;
 			dec_rs_pending(device);
 			/* drbd_rs_begin_io done when we sent this request,
@@ -2954,7 +2954,7 @@ static int receive_DataRequest(struct drbd_connection *connection, struct packet
 		goto out_free_e;
 
 submit_for_resync:
-	atomic_add(size >> 9, &device->rs_sect_ev);
+	atomic_add_wrap(size >> 9, &device->rs_sect_ev);
 
 submit:
 	update_receiver_timing_details(connection, drbd_submit_peer_request);
@@ -4907,7 +4907,7 @@ static int receive_rs_deallocated(struct drbd_connection *connection, struct pac
 		list_add_tail(&peer_req->w.list, &device->sync_ee);
 		spin_unlock_irq(&device->resource->req_lock);
 
-		atomic_add(pi->size >> 9, &device->rs_sect_ev);
+		atomic_add_wrap(pi->size >> 9, &device->rs_sect_ev);
 		err = drbd_submit_peer_request(device, peer_req, op, 0, DRBD_FAULT_RS_WR);
 
 		if (err) {
@@ -4931,7 +4931,7 @@ static int receive_rs_deallocated(struct drbd_connection *connection, struct pac
 		drbd_send_ack_ex(peer_device, P_NEG_ACK, sector, size, ID_SYNCER);
 	}
 
-	atomic_add(size >> 9, &device->rs_sect_in);
+	atomic_add_wrap(size >> 9, &device->rs_sect_in);
 
 	return err;
 }
@@ -5068,7 +5068,7 @@ static void conn_disconnect(struct drbd_connection *connection)
 	if (!list_empty(&connection->current_epoch->list))
 		drbd_err(connection, "ASSERTION FAILED: connection->current_epoch->list not empty\n");
 	/* ok, no more ee's on the fly, it is safe to reset the epoch_size */
-	atomic_set(&connection->current_epoch->epoch_size, 0);
+	atomic_set_wrap(&connection->current_epoch->epoch_size, 0);
 	connection->send.seen_any_write_yet = false;
 
 	drbd_info(connection, "Connection closed\n");
@@ -5574,7 +5574,7 @@ static int got_IsInSync(struct drbd_connection *connection, struct packet_info *
 		put_ldev(device);
 	}
 	dec_rs_pending(device);
-	atomic_add(blksize >> 9, &device->rs_sect_in);
+	atomic_add_wrap(blksize >> 9, &device->rs_sect_in);
 
 	return 0;
 }
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index c6755c9..1456ce0 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -408,7 +408,7 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	list_add_tail(&peer_req->w.list, &device->read_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
-	atomic_add(size >> 9, &device->rs_sect_ev);
+	atomic_add_wrap(size >> 9, &device->rs_sect_ev);
 	if (drbd_submit_peer_request(device, peer_req, REQ_OP_READ, 0,
 				     DRBD_FAULT_RS_RD) == 0)
 		return 0;
@@ -554,7 +554,7 @@ static int drbd_rs_number_requests(struct drbd_device *device)
 	unsigned int sect_in;  /* Number of sectors that came in since the last turn */
 	int number, mxb;
 
-	sect_in = atomic_xchg(&device->rs_sect_in, 0);
+	sect_in = atomic_xchg_wrap(&device->rs_sect_in, 0);
 	device->rs_in_flight -= sect_in;
 
 	rcu_read_lock();
@@ -1662,8 +1662,8 @@ void drbd_rs_controller_reset(struct drbd_device *device)
 	struct gendisk *disk = device->ldev->backing_bdev->bd_contains->bd_disk;
 	struct fifo_buffer *plan;
 
-	atomic_set(&device->rs_sect_in, 0);
-	atomic_set(&device->rs_sect_ev, 0);
+	atomic_set_wrap(&device->rs_sect_in, 0);
+	atomic_set_wrap(&device->rs_sect_ev, 0);
 	device->rs_in_flight = 0;
 	device->rs_last_events =
 		(int)part_stat_read(&disk->part0, sectors[0]) +
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index fcdd886..73ad3df 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -436,7 +436,7 @@ struct ipmi_smi {
 	struct proc_dir_entry *proc_dir;
 	char                  proc_dir_name[10];
 
-	atomic_t stats[IPMI_NUM_STATS];
+	atomic_wrap_t stats[IPMI_NUM_STATS];
 
 	/*
 	 * run_to_completion duplicate of smb_info, smi_info
@@ -468,9 +468,9 @@ static LIST_HEAD(smi_watchers);
 static DEFINE_MUTEX(smi_watchers_mutex);
 
 #define ipmi_inc_stat(intf, stat) \
-	atomic_inc(&(intf)->stats[IPMI_STAT_ ## stat])
+	atomic_inc_wrap(&(intf)->stats[IPMI_STAT_ ## stat])
 #define ipmi_get_stat(intf, stat) \
-	((unsigned int) atomic_read(&(intf)->stats[IPMI_STAT_ ## stat]))
+	((unsigned int) atomic_read_wrap(&(intf)->stats[IPMI_STAT_ ## stat]))
 
 static const char * const addr_src_to_str[] = {
 	"invalid", "hotmod", "hardcoded", "SPMI", "ACPI", "SMBIOS", "PCI",
@@ -2835,7 +2835,7 @@ int ipmi_register_smi(const struct ipmi_smi_handlers *handlers,
 	INIT_LIST_HEAD(&intf->cmd_rcvrs);
 	init_waitqueue_head(&intf->waitq);
 	for (i = 0; i < IPMI_NUM_STATS; i++)
-		atomic_set(&intf->stats[i], 0);
+		atomic_set_wrap(&intf->stats[i], 0);
 
 	intf->proc_dir = NULL;
 
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index a112c01..e18be9e 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -302,7 +302,7 @@ struct smi_info {
 	unsigned char slave_addr;
 
 	/* Counters and things for the proc filesystem. */
-	atomic_t stats[SI_NUM_STATS];
+	atomic_wrap_t stats[SI_NUM_STATS];
 
 	struct task_struct *thread;
 
@@ -311,9 +311,9 @@ struct smi_info {
 };
 
 #define smi_inc_stat(smi, stat) \
-	atomic_inc(&(smi)->stats[SI_STAT_ ## stat])
+	atomic_inc_wrap(&(smi)->stats[SI_STAT_ ## stat])
 #define smi_get_stat(smi, stat) \
-	((unsigned int) atomic_read(&(smi)->stats[SI_STAT_ ## stat]))
+	((unsigned int) atomic_read_wrap(&(smi)->stats[SI_STAT_ ## stat]))
 
 #define SI_MAX_PARMS 4
 
@@ -3578,7 +3578,7 @@ static int try_smi_init(struct smi_info *new_smi)
 	atomic_set(&new_smi->req_events, 0);
 	new_smi->run_to_completion = false;
 	for (i = 0; i < SI_NUM_STATS; i++)
-		atomic_set(&new_smi->stats[i], 0);
+		atomic_set_wrap(&new_smi->stats[i], 0);
 
 	new_smi->interrupt_disabled = true;
 	atomic_set(&new_smi->need_watch, 0);
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e09d405..eda55dd 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -37,7 +37,7 @@ module_param_string(hifn_pll_ref, hifn_pll_ref, sizeof(hifn_pll_ref), 0444);
 MODULE_PARM_DESC(hifn_pll_ref,
 		 "PLL reference clock (pci[freq] or ext[freq], default ext)");
 
-static atomic_t hifn_dev_number;
+static atomic_wrap_t hifn_dev_number;
 
 #define ACRYPTO_OP_DECRYPT	0
 #define ACRYPTO_OP_ENCRYPT	1
@@ -2475,7 +2475,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_out_disable_pci_device;
 
 	snprintf(name, sizeof(name), "hifn%d",
-			atomic_inc_return(&hifn_dev_number) - 1);
+			atomic_inc_return_wrap(&hifn_dev_number) - 1);
 
 	err = pci_request_regions(pdev, name);
 	if (err)
diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index a979003..83f3cfc 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -468,9 +468,9 @@ void edac_device_reset_delay_period(struct edac_device_ctl_info *edac_dev,
  */
 int edac_device_alloc_index(void)
 {
-	static atomic_t device_indexes = ATOMIC_INIT(0);
+	static atomic_wrap_t device_indexes = ATOMIC_INIT(0);
 
-	return atomic_inc_return(&device_indexes) - 1;
+	return atomic_inc_return_wrap(&device_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_device_alloc_index);
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index 8f2f289..8f228a8 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -29,7 +29,7 @@
 
 static DEFINE_MUTEX(edac_pci_ctls_mutex);
 static LIST_HEAD(edac_pci_list);
-static atomic_t pci_indexes = ATOMIC_INIT(0);
+static atomic_wrap_t pci_indexes = ATOMIC_INIT(0);
 
 /*
  * edac_pci_alloc_ctl_info
@@ -224,7 +224,7 @@ static void edac_pci_workq_function(struct work_struct *work_req)
  */
 int edac_pci_alloc_index(void)
 {
-	return atomic_inc_return(&pci_indexes) - 1;
+	return atomic_inc_return_wrap(&pci_indexes) - 1;
 }
 EXPORT_SYMBOL_GPL(edac_pci_alloc_index);
 
diff --git a/drivers/edac/edac_pci_sysfs.c b/drivers/edac/edac_pci_sysfs.c
index 6e3428b..d53fb15 100644
--- a/drivers/edac/edac_pci_sysfs.c
+++ b/drivers/edac/edac_pci_sysfs.c
@@ -23,8 +23,8 @@ static int edac_pci_log_pe = 1;		/* log PCI parity errors */
 static int edac_pci_log_npe = 1;	/* log PCI non-parity error errors */
 static int edac_pci_poll_msec = 1000;	/* one second workq period */
 
-static atomic_t pci_parity_count = ATOMIC_INIT(0);
-static atomic_t pci_nonparity_count = ATOMIC_INIT(0);
+static atomic_wrap_t pci_parity_count = ATOMIC_INIT(0);
+static atomic_wrap_t pci_nonparity_count = ATOMIC_INIT(0);
 
 static struct kobject *edac_pci_top_main_kobj;
 static atomic_t edac_pci_sysfs_refcount = ATOMIC_INIT(0);
@@ -564,7 +564,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 			edac_printk(KERN_CRIT, EDAC_PCI,
 				"Signaled System Error on %s\n",
 				pci_name(dev));
-			atomic_inc(&pci_nonparity_count);
+			atomic_inc_wrap(&pci_nonparity_count);
 		}
 
 		if (status & (PCI_STATUS_PARITY)) {
@@ -572,7 +572,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				"Master Data Parity Error on %s\n",
 				pci_name(dev));
 
-			atomic_inc(&pci_parity_count);
+			atomic_inc_wrap(&pci_parity_count);
 		}
 
 		if (status & (PCI_STATUS_DETECTED_PARITY)) {
@@ -580,7 +580,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				"Detected Parity Error on %s\n",
 				pci_name(dev));
 
-			atomic_inc(&pci_parity_count);
+			atomic_inc_wrap(&pci_parity_count);
 		}
 	}
 
@@ -603,7 +603,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 				edac_printk(KERN_CRIT, EDAC_PCI, "Bridge "
 					"Signaled System Error on %s\n",
 					pci_name(dev));
-				atomic_inc(&pci_nonparity_count);
+				atomic_inc_wrap(&pci_nonparity_count);
 			}
 
 			if (status & (PCI_STATUS_PARITY)) {
@@ -611,7 +611,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 					"Master Data Parity Error on "
 					"%s\n", pci_name(dev));
 
-				atomic_inc(&pci_parity_count);
+				atomic_inc_wrap(&pci_parity_count);
 			}
 
 			if (status & (PCI_STATUS_DETECTED_PARITY)) {
@@ -619,7 +619,7 @@ static void edac_pci_dev_parity_test(struct pci_dev *dev)
 					"Detected Parity Error on %s\n",
 					pci_name(dev));
 
-				atomic_inc(&pci_parity_count);
+				atomic_inc_wrap(&pci_parity_count);
 			}
 		}
 	}
@@ -657,7 +657,7 @@ void edac_pci_do_parity_check(void)
 	if (!check_pci_errors)
 		return;
 
-	before_count = atomic_read(&pci_parity_count);
+	before_count = atomic_read_wrap(&pci_parity_count);
 
 	/* scan all PCI devices looking for a Parity Error on devices and
 	 * bridges.
@@ -669,7 +669,7 @@ void edac_pci_do_parity_check(void)
 	/* Only if operator has selected panic on PCI Error */
 	if (edac_pci_get_panic_on_pe()) {
 		/* If the count is different 'after' from 'before' */
-		if (before_count != atomic_read(&pci_parity_count))
+		if (before_count != atomic_read_wrap(&pci_parity_count))
 			panic("EDAC: PCI Parity Error");
 	}
 }
diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index 57ea7f4..3e3a716 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -528,9 +528,9 @@ void fw_card_initialize(struct fw_card *card,
 			const struct fw_card_driver *driver,
 			struct device *device)
 {
-	static atomic_t index = ATOMIC_INIT(-1);
+	static atomic_wrap_t index = ATOMIC_INIT(-1);
 
-	card->index = atomic_inc_return(&index);
+	card->index = atomic_inc_return_wrap(&index);
 	card->driver = driver;
 	card->device = device;
 	card->current_tlabel = 0;
diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
index d425374..e70a487 100644
--- a/drivers/firmware/efi/cper.c
+++ b/drivers/firmware/efi/cper.c
@@ -44,12 +44,12 @@ static char rcd_decode_str[CPER_REC_LEN];
  */
 u64 cper_next_record_id(void)
 {
-	static atomic64_t seq;
+	static atomic64_wrap_t seq;
 
-	if (!atomic64_read(&seq))
-		atomic64_set(&seq, ((u64)get_seconds()) << 32);
+	if (!atomic64_read_wrap(&seq))
+		atomic64_set_wrap(&seq, ((u64)get_seconds()) << 32);
 
-	return atomic64_inc_return(&seq);
+	return atomic64_inc_return_wrap(&seq);
 }
 EXPORT_SYMBOL_GPL(cper_next_record_id);
 
diff --git a/drivers/gpio/gpio-vr41xx.c b/drivers/gpio/gpio-vr41xx.c
index ac8deb0..56843b0c2 100644
--- a/drivers/gpio/gpio-vr41xx.c
+++ b/drivers/gpio/gpio-vr41xx.c
@@ -224,7 +224,7 @@ static int giu_get_irq(unsigned int irq)
 	printk(KERN_ERR "spurious GIU interrupt: %04x(%04x),%04x(%04x)\n",
 	       maskl, pendl, maskh, pendh);
 
-	atomic_inc(&irq_err_count);
+	atomic_inc_wrap(&irq_err_count);
 
 	return -EINVAL;
 }
diff --git a/drivers/gpu/drm/i810/i810_drv.h b/drivers/gpu/drm/i810/i810_drv.h
index 93ec5dc..793a9f1 100644
--- a/drivers/gpu/drm/i810/i810_drv.h
+++ b/drivers/gpu/drm/i810/i810_drv.h
@@ -110,8 +110,8 @@ typedef struct drm_i810_private {
 	int page_flipping;
 
 	wait_queue_head_t irq_queue;
-	atomic_t irq_received;
-	atomic_t irq_emitted;
+	atomic_wrap_t irq_received;
+	atomic_wrap_t irq_emitted;
 
 	int front_offset;
 } drm_i810_private_t;
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index bb31233..b6e7c9d 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -122,9 +122,9 @@ typedef struct drm_mga_private {
 	u32 clear_cmd;
 	u32 maccess;
 
-	atomic_t vbl_received;          /**< Number of vblanks received. */
+	atomic_wrap_t vbl_received;          /**< Number of vblanks received. */
 	wait_queue_head_t fence_queue;
-	atomic_t last_fence_retired;
+	atomic_wrap_t last_fence_retired;
 	u32 next_fence_to_post;
 
 	unsigned int fb_cpp;
diff --git a/drivers/gpu/drm/mga/mga_irq.c b/drivers/gpu/drm/mga/mga_irq.c
index 693ba70..d7fb10a 100644
--- a/drivers/gpu/drm/mga/mga_irq.c
+++ b/drivers/gpu/drm/mga/mga_irq.c
@@ -43,7 +43,7 @@ u32 mga_get_vblank_counter(struct drm_device *dev, unsigned int pipe)
 	if (pipe != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_wrap(&dev_priv->vbl_received);
 }
 
 
@@ -59,7 +59,7 @@ irqreturn_t mga_driver_irq_handler(int irq, void *arg)
 	/* VBLANK interrupt */
 	if (status & MGA_VLINEPEN) {
 		MGA_WRITE(MGA_ICLEAR, MGA_VLINEICLR);
-		atomic_inc(&dev_priv->vbl_received);
+		atomic_inc_wrap(&dev_priv->vbl_received);
 		drm_handle_vblank(dev, 0);
 		handled = 1;
 	}
@@ -78,7 +78,7 @@ irqreturn_t mga_driver_irq_handler(int irq, void *arg)
 		if ((prim_start & ~0x03) != (prim_end & ~0x03))
 			MGA_WRITE(MGA_PRIMEND, prim_end);
 
-		atomic_inc(&dev_priv->last_fence_retired);
+		atomic_inc_wrap(&dev_priv->last_fence_retired);
 		wake_up(&dev_priv->fence_queue);
 		handled = 1;
 	}
@@ -129,7 +129,8 @@ int mga_driver_fence_wait(struct drm_device *dev, unsigned int *sequence)
 	 * using fences.
 	 */
 	DRM_WAIT_ON(ret, dev_priv->fence_queue, 3 * HZ,
-		    (((cur_fence = atomic_read(&dev_priv->last_fence_retired))
+		    (((cur_fence = atomic_read_wrap(&dev_priv->
+						    last_fence_retired))
 		      - *sequence) <= (1 << 23)));
 
 	*sequence = cur_fence;
diff --git a/drivers/gpu/drm/qxl/qxl_cmd.c b/drivers/gpu/drm/qxl/qxl_cmd.c
index 04270f5..f74daa3 100644
--- a/drivers/gpu/drm/qxl/qxl_cmd.c
+++ b/drivers/gpu/drm/qxl/qxl_cmd.c
@@ -285,27 +285,27 @@ static int wait_for_io_cmd_user(struct qxl_device *qdev, uint8_t val, long port,
 	int ret;
 
 	mutex_lock(&qdev->async_io_mutex);
-	irq_num = atomic_read(&qdev->irq_received_io_cmd);
+	irq_num = atomic_read_wrap(&qdev->irq_received_io_cmd);
 	if (qdev->last_sent_io_cmd > irq_num) {
 		if (intr)
 			ret = wait_event_interruptible_timeout(qdev->io_cmd_event,
-							       atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+							       atomic_read_wrap(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 		else
 			ret = wait_event_timeout(qdev->io_cmd_event,
-						 atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+						 atomic_read_wrap(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 		/* 0 is timeout, just bail the "hw" has gone away */
 		if (ret <= 0)
 			goto out;
-		irq_num = atomic_read(&qdev->irq_received_io_cmd);
+		irq_num = atomic_read_wrap(&qdev->irq_received_io_cmd);
 	}
 	outb(val, addr);
 	qdev->last_sent_io_cmd = irq_num + 1;
 	if (intr)
 		ret = wait_event_interruptible_timeout(qdev->io_cmd_event,
-						       atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+						       atomic_read_wrap(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 	else
 		ret = wait_event_timeout(qdev->io_cmd_event,
-					 atomic_read(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
+					 atomic_read_wrap(&qdev->irq_received_io_cmd) > irq_num, 5*HZ);
 out:
 	if (ret > 0)
 		ret = 0;
diff --git a/drivers/gpu/drm/qxl/qxl_debugfs.c b/drivers/gpu/drm/qxl/qxl_debugfs.c
index 6911b8c..73c1448 100644
--- a/drivers/gpu/drm/qxl/qxl_debugfs.c
+++ b/drivers/gpu/drm/qxl/qxl_debugfs.c
@@ -42,10 +42,10 @@ qxl_debugfs_irq_received(struct seq_file *m, void *data)
 	struct drm_info_node *node = (struct drm_info_node *) m->private;
 	struct qxl_device *qdev = node->minor->dev->dev_private;
 
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_display));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_cursor));
-	seq_printf(m, "%d\n", atomic_read(&qdev->irq_received_io_cmd));
+	seq_printf(m, "%d\n", atomic_read_wrap(&qdev->irq_received));
+	seq_printf(m, "%d\n", atomic_read_wrap(&qdev->irq_received_display));
+	seq_printf(m, "%d\n", atomic_read_wrap(&qdev->irq_received_cursor));
+	seq_printf(m, "%d\n", atomic_read_wrap(&qdev->irq_received_io_cmd));
 	seq_printf(m, "%d\n", qdev->irq_received_error);
 	return 0;
 }
diff --git a/drivers/gpu/drm/qxl/qxl_drv.h b/drivers/gpu/drm/qxl/qxl_drv.h
index 5f3e5ad..f49d8f4 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.h
+++ b/drivers/gpu/drm/qxl/qxl_drv.h
@@ -293,10 +293,10 @@ struct qxl_device {
 	unsigned int last_sent_io_cmd;
 
 	/* interrupt handling */
-	atomic_t irq_received;
-	atomic_t irq_received_display;
-	atomic_t irq_received_cursor;
-	atomic_t irq_received_io_cmd;
+	atomic_wrap_t irq_received;
+	atomic_wrap_t irq_received_display;
+	atomic_wrap_t irq_received_cursor;
+	atomic_wrap_t irq_received_io_cmd;
 	unsigned irq_received_error;
 	wait_queue_head_t display_event;
 	wait_queue_head_t cursor_event;
diff --git a/drivers/gpu/drm/qxl/qxl_irq.c b/drivers/gpu/drm/qxl/qxl_irq.c
index 0bf1e20..7a1c710 100644
--- a/drivers/gpu/drm/qxl/qxl_irq.c
+++ b/drivers/gpu/drm/qxl/qxl_irq.c
@@ -36,19 +36,19 @@ irqreturn_t qxl_irq_handler(int irq, void *arg)
 	if (!pending)
 		return IRQ_NONE;
 
-	atomic_inc(&qdev->irq_received);
+	atomic_inc_wrap(&qdev->irq_received);
 
 	if (pending & QXL_INTERRUPT_DISPLAY) {
-		atomic_inc(&qdev->irq_received_display);
+		atomic_inc_wrap(&qdev->irq_received_display);
 		wake_up_all(&qdev->display_event);
 		qxl_queue_garbage_collect(qdev, false);
 	}
 	if (pending & QXL_INTERRUPT_CURSOR) {
-		atomic_inc(&qdev->irq_received_cursor);
+		atomic_inc_wrap(&qdev->irq_received_cursor);
 		wake_up_all(&qdev->cursor_event);
 	}
 	if (pending & QXL_INTERRUPT_IO_CMD) {
-		atomic_inc(&qdev->irq_received_io_cmd);
+		atomic_inc_wrap(&qdev->irq_received_io_cmd);
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
+	atomic_set_wrap(&qdev->irq_received, 0);
+	atomic_set_wrap(&qdev->irq_received_display, 0);
+	atomic_set_wrap(&qdev->irq_received_cursor, 0);
+	atomic_set_wrap(&qdev->irq_received_io_cmd, 0);
 	qdev->irq_received_error = 0;
 	ret = drm_irq_install(qdev->ddev, qdev->ddev->pdev->irq);
 	qdev->ram_header->int_mask = QXL_INTERRUPT_MASK;
diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index 14fd83b5f..7d68759 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -377,7 +377,7 @@ static int r128_do_init_cce(struct drm_device *dev, drm_r128_init_t *init)
 
 	/* GH: Simple idle check.
 	 */
-	atomic_set(&dev_priv->idle_count, 0);
+	atomic_set_wrap(&dev_priv->idle_count, 0);
 
 	/* We don't support anything other than bus-mastering ring mode,
 	 * but the ring can be in either AGP or PCI space for the ring
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 09143b8..c3b5234 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -93,14 +93,14 @@ typedef struct drm_r128_private {
 	int is_pci;
 	unsigned long cce_buffers_offset;
 
-	atomic_t idle_count;
+	atomic_wrap_t idle_count;
 
 	int page_flipping;
 	int current_page;
 	u32 crtc_offset;
 	u32 crtc_offset_cntl;
 
-	atomic_t vbl_received;
+	atomic_wrap_t vbl_received;
 
 	u32 color_fmt;
 	unsigned int front_offset;
diff --git a/drivers/gpu/drm/r128/r128_irq.c b/drivers/gpu/drm/r128/r128_irq.c
index 9730f49..1dbe534 100644
--- a/drivers/gpu/drm/r128/r128_irq.c
+++ b/drivers/gpu/drm/r128/r128_irq.c
@@ -41,7 +41,7 @@ u32 r128_get_vblank_counter(struct drm_device *dev, unsigned int pipe)
 	if (pipe != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_wrap(&dev_priv->vbl_received);
 }
 
 irqreturn_t r128_driver_irq_handler(int irq, void *arg)
@@ -55,7 +55,7 @@ irqreturn_t r128_driver_irq_handler(int irq, void *arg)
 	/* VBLANK interrupt */
 	if (status & R128_CRTC_VBLANK_INT) {
 		R128_WRITE(R128_GEN_INT_STATUS, R128_CRTC_VBLANK_INT_AK);
-		atomic_inc(&dev_priv->vbl_received);
+		atomic_inc_wrap(&dev_priv->vbl_received);
 		drm_handle_vblank(dev, 0);
 		return IRQ_HANDLED;
 	}
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 8fd2d9f..bd88dca 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -320,10 +320,10 @@ static void r128_clear_box(drm_r128_private_t *dev_priv,
 
 static void r128_cce_performance_boxes(drm_r128_private_t *dev_priv)
 {
-	if (atomic_read(&dev_priv->idle_count) == 0)
+	if (atomic_read_wrap(&dev_priv->idle_count) == 0)
 		r128_clear_box(dev_priv, 64, 4, 8, 8, 0, 255, 0);
 	else
-		atomic_set(&dev_priv->idle_count, 0);
+		atomic_set_wrap(&dev_priv->idle_count, 0);
 }
 
 #endif
diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index 286a785..8100a59 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -53,7 +53,7 @@ typedef struct drm_via_ring_buffer {
 typedef uint32_t maskarray_t[5];
 
 typedef struct drm_via_irq {
-	atomic_t irq_received;
+	atomic_wrap_t irq_received;
 	uint32_t pending_mask;
 	uint32_t enable_mask;
 	wait_queue_head_t irq_queue;
@@ -77,7 +77,7 @@ typedef struct drm_via_private {
 	struct timeval last_vblank;
 	int last_vblank_valid;
 	unsigned usec_per_vblank;
-	atomic_t vbl_received;
+	atomic_wrap_t vbl_received;
 	drm_via_state_t hc_state;
 	char pci_buf[VIA_PCI_BUF_SIZE];
 	const uint32_t *fire_offsets[VIA_FIRE_BUF_SIZE];
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index ea8172c..c8f893f 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -102,7 +102,7 @@ u32 via_get_vblank_counter(struct drm_device *dev, unsigned int pipe)
 	if (pipe != 0)
 		return 0;
 
-	return atomic_read(&dev_priv->vbl_received);
+	return atomic_read_wrap(&dev_priv->vbl_received);
 }
 
 irqreturn_t via_driver_irq_handler(int irq, void *arg)
@@ -117,8 +117,8 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 
 	status = VIA_READ(VIA_REG_INTERRUPT);
 	if (status & VIA_IRQ_VBLANK_PENDING) {
-		atomic_inc(&dev_priv->vbl_received);
-		if (!(atomic_read(&dev_priv->vbl_received) & 0x0F)) {
+		atomic_inc_wrap(&dev_priv->vbl_received);
+		if (!(atomic_read_wrap(&dev_priv->vbl_received) & 0x0F)) {
 			do_gettimeofday(&cur_vblank);
 			if (dev_priv->last_vblank_valid) {
 				dev_priv->usec_per_vblank =
@@ -128,7 +128,7 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 			dev_priv->last_vblank = cur_vblank;
 			dev_priv->last_vblank_valid = 1;
 		}
-		if (!(atomic_read(&dev_priv->vbl_received) & 0xFF)) {
+		if (!(atomic_read_wrap(&dev_priv->vbl_received) & 0xFF)) {
 			DRM_DEBUG("US per vblank is: %u\n",
 				  dev_priv->usec_per_vblank);
 		}
@@ -138,7 +138,7 @@ irqreturn_t via_driver_irq_handler(int irq, void *arg)
 
 	for (i = 0; i < dev_priv->num_irqs; ++i) {
 		if (status & cur_irq->pending_mask) {
-			atomic_inc(&cur_irq->irq_received);
+			atomic_inc_wrap(&cur_irq->irq_received);
 			wake_up(&cur_irq->irq_queue);
 			handled = 1;
 			if (dev_priv->irq_map[drm_via_irq_dma0_td] == i)
@@ -243,11 +243,11 @@ via_driver_irq_wait(struct drm_device *dev, unsigned int irq, int force_sequence
 		DRM_WAIT_ON(ret, cur_irq->irq_queue, 3 * HZ,
 			    ((VIA_READ(masks[irq][2]) & masks[irq][3]) ==
 			     masks[irq][4]));
-		cur_irq_sequence = atomic_read(&cur_irq->irq_received);
+		cur_irq_sequence = atomic_read_wrap(&cur_irq->irq_received);
 	} else {
 		DRM_WAIT_ON(ret, cur_irq->irq_queue, 3 * HZ,
 			    (((cur_irq_sequence =
-			       atomic_read(&cur_irq->irq_received)) -
+			       atomic_read_wrap(&cur_irq->irq_received)) -
 			      *sequence) <= (1 << 23)));
 	}
 	*sequence = cur_irq_sequence;
@@ -285,7 +285,7 @@ void via_driver_irq_preinstall(struct drm_device *dev)
 		}
 
 		for (i = 0; i < dev_priv->num_irqs; ++i) {
-			atomic_set(&cur_irq->irq_received, 0);
+			atomic_set_wrap(&cur_irq->irq_received, 0);
 			cur_irq->enable_mask = dev_priv->irq_masks[i][0];
 			cur_irq->pending_mask = dev_priv->irq_masks[i][1];
 			init_waitqueue_head(&cur_irq->irq_queue);
@@ -367,7 +367,7 @@ int via_wait_irq(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	switch (irqwait->request.type & ~VIA_IRQ_FLAGS_MASK) {
 	case VIA_IRQ_RELATIVE:
 		irqwait->request.sequence +=
-			atomic_read(&cur_irq->irq_received);
+			atomic_read_wrap(&cur_irq->irq_received);
 		irqwait->request.type &= ~_DRM_VBLANK_RELATIVE;
 	case VIA_IRQ_ABSOLUTE:
 		break;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index 1e59a48..37ff30d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -439,7 +439,7 @@ struct vmw_private {
 	 * Fencing and IRQs.
 	 */
 
-	atomic_t marker_seq;
+	atomic_wrap_t marker_seq;
 	wait_queue_head_t fence_queue;
 	wait_queue_head_t fifo_queue;
 	spinlock_t waiter_lock;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
index b6a0806..7c01c13 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c
@@ -156,7 +156,7 @@ int vmw_fifo_init(struct vmw_private *dev_priv, struct vmw_fifo_state *fifo)
 		 (unsigned int) min,
 		 (unsigned int) fifo->capabilities);
 
-	atomic_set(&dev_priv->marker_seq, dev_priv->last_read_seqno);
+	atomic_set_wrap(&dev_priv->marker_seq, dev_priv->last_read_seqno);
 	vmw_mmio_write(dev_priv->last_read_seqno, fifo_mem + SVGA_FIFO_FENCE);
 	vmw_marker_queue_init(&fifo->marker_queue);
 
@@ -544,7 +544,7 @@ int vmw_fifo_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 
 	fm = vmw_fifo_reserve(dev_priv, bytes);
 	if (unlikely(fm == NULL)) {
-		*seqno = atomic_read(&dev_priv->marker_seq);
+		*seqno = atomic_read_wrap(&dev_priv->marker_seq);
 		ret = -ENOMEM;
 		(void)vmw_fallback_wait(dev_priv, false, true, *seqno,
 					false, 3*HZ);
@@ -552,7 +552,7 @@ int vmw_fifo_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 	}
 
 	do {
-		*seqno = atomic_add_return(1, &dev_priv->marker_seq);
+		*seqno = atomic_add_return_wrap(1, &dev_priv->marker_seq);
 	} while (*seqno == 0);
 
 	if (!(fifo_state->capabilities & SVGA_FIFO_CAP_FENCE)) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
index 0c7e172..1f764d3 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
@@ -103,7 +103,7 @@ bool vmw_seqno_passed(struct vmw_private *dev_priv,
 	 * emitted. Then the fence is stale and signaled.
 	 */
 
-	ret = ((atomic_read(&dev_priv->marker_seq) - seqno)
+	ret = ((atomic_read_wrap(&dev_priv->marker_seq) - seqno)
 	       > VMW_FENCE_WRAP);
 
 	return ret;
@@ -142,7 +142,7 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 		}
 	}
 
-	signal_seq = atomic_read(&dev_priv->marker_seq);
+	signal_seq = atomic_read_wrap(&dev_priv->marker_seq);
 	ret = 0;
 
 	for (;;) {
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
index efd1ffd..3cb80ad 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_marker.c
@@ -135,7 +135,7 @@ int vmw_wait_lag(struct vmw_private *dev_priv,
 	while (!vmw_lag_lt(queue, us)) {
 		spin_lock(&queue->lock);
 		if (list_empty(&queue->head))
-			seqno = atomic_read(&dev_priv->marker_seq);
+			seqno = atomic_read_wrap(&dev_priv->marker_seq);
 		else {
 			marker = list_first_entry(&queue->head,
 						 struct vmw_marker, head);
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 2b89c70..f0ccf7e 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2645,7 +2645,7 @@ EXPORT_SYMBOL_GPL(hid_ignore);
 
 int hid_add_device(struct hid_device *hdev)
 {
-	static atomic_t id = ATOMIC_INIT(0);
+	static atomic_wrap_t id = ATOMIC_INIT(0);
 	int ret;
 
 	if (WARN_ON(hdev->status & HID_STAT_ADDED))
@@ -2689,7 +2689,7 @@ int hid_add_device(struct hid_device *hdev)
 	/* XXX hack, any other cleaner solution after the driver core
 	 * is converted to allow more than 20 bytes as the device name? */
 	dev_set_name(&hdev->dev, "%04X:%04X:%04X.%04X", hdev->bus,
-		     hdev->vendor, hdev->product, atomic_inc_return(&id));
+		     hdev->vendor, hdev->product, atomic_inc_return_wrap(&id));
 
 	hid_debug_register(hdev, dev_name(&hdev->dev));
 	ret = device_add(&hdev->dev);
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 16f91c8..6adbe2b 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -396,8 +396,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	unsigned long flags;
 	int ret = 0;
 
-	next_gpadl_handle =
-		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
+	next_gpadl_handle = (atomic_inc_return_wrap(
+				&vmbus_connection.next_gpadl_handle) - 1);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo);
 	if (ret)
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index fdf8da9..7e3b886 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -482,7 +482,7 @@ MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
 
 module_param(pressure_report_delay, uint, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(pressure_report_delay, "Delay in secs in reporting pressure");
-static atomic_t trans_id = ATOMIC_INIT(0);
+static atomic_wrap_t trans_id = ATOMIC_INIT(0);
 
 static int dm_ring_size = (5 * PAGE_SIZE);
 
@@ -1010,7 +1010,7 @@ static void hot_add_req(struct work_struct *dummy)
 		pr_info("Memory hot add failed\n");
 
 	dm->state = DM_INITIALIZED;
-	resp.hdr.trans_id = atomic_inc_return(&trans_id);
+	resp.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 	vmbus_sendpacket(dm->dev->channel, &resp,
 			sizeof(struct dm_hot_add_response),
 			(unsigned long)NULL,
@@ -1089,7 +1089,7 @@ static void post_status(struct hv_dynmem_device *dm)
 	memset(&status, 0, sizeof(struct dm_status));
 	status.hdr.type = DM_STATUS_REPORT;
 	status.hdr.size = sizeof(struct dm_status);
-	status.hdr.trans_id = atomic_inc_return(&trans_id);
+	status.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 
 	/*
 	 * The host expects the guest to report free and committed memory.
@@ -1113,7 +1113,7 @@ static void post_status(struct hv_dynmem_device *dm)
 	 * send the status. This can happen if we were interrupted
 	 * after we picked our transaction ID.
 	 */
-	if (status.hdr.trans_id != atomic_read(&trans_id))
+	if (status.hdr.trans_id != atomic_read_wrap(&trans_id))
 		return;
 
 	/*
@@ -1257,7 +1257,8 @@ static void balloon_up(struct work_struct *dummy)
 		 */
 
 		do {
-			bl_resp->hdr.trans_id = atomic_inc_return(&trans_id);
+			bl_resp->hdr.trans_id =
+				atomic_inc_return_wrap(&trans_id);
 			ret = vmbus_sendpacket(dm_device.dev->channel,
 						bl_resp,
 						bl_resp->hdr.size,
@@ -1303,7 +1304,7 @@ static void balloon_down(struct hv_dynmem_device *dm,
 
 	memset(&resp, 0, sizeof(struct dm_unballoon_response));
 	resp.hdr.type = DM_UNBALLOON_RESPONSE;
-	resp.hdr.trans_id = atomic_inc_return(&trans_id);
+	resp.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 	resp.hdr.size = sizeof(struct dm_unballoon_response);
 
 	vmbus_sendpacket(dm_device.dev->channel, &resp,
@@ -1363,7 +1364,7 @@ static void version_resp(struct hv_dynmem_device *dm,
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
-	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
+	version_req.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 	version_req.version.version = dm->next_version;
 
 	/*
@@ -1550,7 +1551,7 @@ static int balloon_probe(struct hv_device *dev,
 	memset(&version_req, 0, sizeof(struct dm_version_request));
 	version_req.hdr.type = DM_VERSION_REQUEST;
 	version_req.hdr.size = sizeof(struct dm_version_request);
-	version_req.hdr.trans_id = atomic_inc_return(&trans_id);
+	version_req.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 	version_req.version.version = DYNMEM_PROTOCOL_VERSION_WIN10;
 	version_req.is_last_attempt = 0;
 
@@ -1581,7 +1582,7 @@ static int balloon_probe(struct hv_device *dev,
 	memset(&cap_msg, 0, sizeof(struct dm_capabilities));
 	cap_msg.hdr.type = DM_CAPABILITIES_REPORT;
 	cap_msg.hdr.size = sizeof(struct dm_capabilities);
-	cap_msg.hdr.trans_id = atomic_inc_return(&trans_id);
+	cap_msg.hdr.trans_id = atomic_inc_return_wrap(&trans_id);
 
 	cap_msg.caps.cap_bits.balloon = 1;
 	cap_msg.caps.cap_bits.hot_add = 1;
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index a5b4442..a1f4de6 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -567,7 +567,7 @@ enum vmbus_connect_state {
 struct vmbus_connection {
 	enum vmbus_connect_state conn_state;
 
-	atomic_t next_gpadl_handle;
+	atomic_wrap_t next_gpadl_handle;
 
 	struct completion  unload_event;
 	/*
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index a2fdbb7..4a911ce 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -170,7 +170,7 @@ struct sht15_data {
 	int				supply_uv;
 	bool				supply_uv_valid;
 	struct work_struct		update_supply_work;
-	atomic_t			interrupt_handled;
+	atomic_wrap_t			interrupt_handled;
 };
 
 /**
@@ -530,13 +530,13 @@ static int sht15_measurement(struct sht15_data *data,
 	ret = gpio_direction_input(data->pdata->gpio_data);
 	if (ret)
 		return ret;
-	atomic_set(&data->interrupt_handled, 0);
+	atomic_set_wrap(&data->interrupt_handled, 0);
 
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
 	if (gpio_get_value(data->pdata->gpio_data) == 0) {
 		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
 		/* Only relevant if the interrupt hasn't occurred. */
-		if (!atomic_read(&data->interrupt_handled))
+		if (!atomic_read_wrap(&data->interrupt_handled))
 			schedule_work(&data->read_work);
 	}
 	ret = wait_event_timeout(data->wait_queue,
@@ -808,7 +808,7 @@ static irqreturn_t sht15_interrupt_fired(int irq, void *d)
 
 	/* First disable the interrupt */
 	disable_irq_nosync(irq);
-	atomic_inc(&data->interrupt_handled);
+	atomic_inc_wrap(&data->interrupt_handled);
 	/* Then schedule a reading work struct */
 	if (data->state != SHT15_READING_NOTHING)
 		schedule_work(&data->read_work);
@@ -830,11 +830,11 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 		 * If not, then start the interrupt again - care here as could
 		 * have gone low in meantime so verify it hasn't!
 		 */
-		atomic_set(&data->interrupt_handled, 0);
+		atomic_set_wrap(&data->interrupt_handled, 0);
 		enable_irq(gpio_to_irq(data->pdata->gpio_data));
 		/* If still not occurred or another handler was scheduled */
 		if (gpio_get_value(data->pdata->gpio_data)
-		    || atomic_read(&data->interrupt_handled))
+		    || atomic_read_wrap(&data->interrupt_handled))
 			return;
 	}
 
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c995255..6532e91 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -115,7 +115,7 @@ static char const counter_group_names[CM_COUNTER_GROUPS]
 
 struct cm_counter_group {
 	struct kobject obj;
-	atomic_long_t counter[CM_ATTR_COUNT];
+	atomic_long_wrap_t counter[CM_ATTR_COUNT];
 };
 
 struct cm_counter_attribute {
@@ -1476,7 +1476,7 @@ static void cm_dup_req_handler(struct cm_work *work,
 	struct ib_mad_send_buf *msg = NULL;
 	int ret;
 
-	atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+	atomic_long_inc_wrap(&work->port->counter_group[CM_RECV_DUPLICATES].
 			counter[CM_REQ_COUNTER]);
 
 	/* Quick state check to discard duplicate REQs. */
@@ -1884,7 +1884,7 @@ static void cm_dup_rep_handler(struct cm_work *work)
 	if (!cm_id_priv)
 		return;
 
-	atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+	atomic_long_inc_wrap(&work->port->counter_group[CM_RECV_DUPLICATES].
 			counter[CM_REP_COUNTER]);
 	ret = cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg);
 	if (ret)
@@ -2051,8 +2051,9 @@ static int cm_rtu_handler(struct cm_work *work)
 	if (cm_id_priv->id.state != IB_CM_REP_SENT &&
 	    cm_id_priv->id.state != IB_CM_MRA_REP_RCVD) {
 		spin_unlock_irq(&cm_id_priv->lock);
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_RTU_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_RTU_COUNTER]);
 		goto out;
 	}
 	cm_id_priv->id.state = IB_CM_ESTABLISHED;
@@ -2234,8 +2235,9 @@ static int cm_dreq_handler(struct cm_work *work)
 	cm_id_priv = cm_acquire_id(dreq_msg->remote_comm_id,
 				   dreq_msg->local_comm_id);
 	if (!cm_id_priv) {
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_DREQ_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_DREQ_COUNTER]);
 		cm_issue_drep(work->port, work->mad_recv_wc);
 		return -EINVAL;
 	}
@@ -2259,8 +2261,9 @@ static int cm_dreq_handler(struct cm_work *work)
 	case IB_CM_MRA_REP_RCVD:
 		break;
 	case IB_CM_TIMEWAIT:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_DREQ_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_DREQ_COUNTER]);
 		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
 			goto unlock;
 
@@ -2273,8 +2276,9 @@ static int cm_dreq_handler(struct cm_work *work)
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_DREQ_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_DREQ_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_DREQ_COUNTER]);
 		goto unlock;
 	default:
 		goto unlock;
@@ -2640,7 +2644,7 @@ static int cm_mra_handler(struct cm_work *work)
 		    ib_modify_mad(cm_id_priv->av.port->mad_agent,
 				  cm_id_priv->msg, timeout)) {
 			if (cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
-				atomic_long_inc(&work->port->
+				atomic_long_inc_wrap(&work->port->
 						counter_group[CM_RECV_DUPLICATES].
 						counter[CM_MRA_COUNTER]);
 			goto out;
@@ -2649,8 +2653,9 @@ static int cm_mra_handler(struct cm_work *work)
 		break;
 	case IB_CM_MRA_REQ_RCVD:
 	case IB_CM_MRA_REP_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_MRA_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_MRA_COUNTER]);
 		/* fall through */
 	default:
 		goto out;
@@ -2811,8 +2816,9 @@ static int cm_lap_handler(struct cm_work *work)
 	case IB_CM_LAP_IDLE:
 		break;
 	case IB_CM_MRA_LAP_SENT:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
-				counter[CM_LAP_COUNTER]);
+		atomic_long_inc_wrap(&work->port->
+				     counter_group[CM_RECV_DUPLICATES].
+				     counter[CM_LAP_COUNTER]);
 		if (cm_alloc_response_msg(work->port, work->mad_recv_wc, &msg))
 			goto unlock;
 
@@ -2827,7 +2833,8 @@ static int cm_lap_handler(struct cm_work *work)
 			cm_free_msg(msg);
 		goto deref;
 	case IB_CM_LAP_RCVD:
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_wrap(&work->port->
+				counter_group[CM_RECV_DUPLICATES].
 				counter[CM_LAP_COUNTER]);
 		goto unlock;
 	default:
@@ -3113,7 +3120,8 @@ static int cm_sidr_req_handler(struct cm_work *work)
 	cur_cm_id_priv = cm_insert_remote_sidr(cm_id_priv);
 	if (cur_cm_id_priv) {
 		spin_unlock_irq(&cm.lock);
-		atomic_long_inc(&work->port->counter_group[CM_RECV_DUPLICATES].
+		atomic_long_inc_wrap(&work->port->
+				counter_group[CM_RECV_DUPLICATES].
 				counter[CM_SIDR_REQ_COUNTER]);
 		goto out; /* Duplicate message. */
 	}
@@ -3327,10 +3335,10 @@ static void cm_send_handler(struct ib_mad_agent *mad_agent,
 	if (!msg->context[0] && (attr_index != CM_REJ_COUNTER))
 		msg->retries = 1;
 
-	atomic_long_add(1 + msg->retries,
+	atomic_long_add_wrap(1 + msg->retries,
 			&port->counter_group[CM_XMIT].counter[attr_index]);
 	if (msg->retries)
-		atomic_long_add(msg->retries,
+		atomic_long_add_wrap(msg->retries,
 				&port->counter_group[CM_XMIT_RETRIES].
 				counter[attr_index]);
 
@@ -3557,7 +3565,7 @@ static void cm_recv_handler(struct ib_mad_agent *mad_agent,
 	}
 
 	attr_id = be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.attr_id);
-	atomic_long_inc(&port->counter_group[CM_RECV].
+	atomic_long_inc_wrap(&port->counter_group[CM_RECV].
 			counter[attr_id - CM_ATTR_ID_OFFSET]);
 
 	work = kmalloc(sizeof *work + sizeof(struct ib_sa_path_rec) * paths,
@@ -3764,7 +3772,7 @@ static ssize_t cm_show_counter(struct kobject *obj, struct attribute *attr,
 	cm_attr = container_of(attr, struct cm_counter_attribute, attr);
 
 	return sprintf(buf, "%ld\n",
-		       atomic_long_read(&group->counter[cm_attr->index]));
+		       atomic_long_read_wrap(&group->counter[cm_attr->index]));
 }
 
 static const struct sysfs_ops cm_counter_ops = {
diff --git a/drivers/infiniband/core/fmr_pool.c b/drivers/infiniband/core/fmr_pool.c
index cdbb1f1..f714a6f 100644
--- a/drivers/infiniband/core/fmr_pool.c
+++ b/drivers/infiniband/core/fmr_pool.c
@@ -98,8 +98,8 @@ struct ib_fmr_pool {
 
 	struct task_struct       *thread;
 
-	atomic_t                  req_ser;
-	atomic_t                  flush_ser;
+	atomic_wrap_t        req_ser;
+	atomic_wrap_t        flush_ser;
 
 	wait_queue_head_t         force_wait;
 };
@@ -179,10 +179,11 @@ static int ib_fmr_cleanup_thread(void *pool_ptr)
 	struct ib_fmr_pool *pool = pool_ptr;
 
 	do {
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) < 0) {
+		if (atomic_read_wrap(&pool->flush_ser) -
+				atomic_read_wrap(&pool->req_ser) < 0) {
 			ib_fmr_batch_release(pool);
 
-			atomic_inc(&pool->flush_ser);
+			atomic_inc_wrap(&pool->flush_ser);
 			wake_up_interruptible(&pool->force_wait);
 
 			if (pool->flush_function)
@@ -190,7 +191,8 @@ static int ib_fmr_cleanup_thread(void *pool_ptr)
 		}
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (atomic_read(&pool->flush_ser) - atomic_read(&pool->req_ser) >= 0 &&
+		if (atomic_read_wrap(&pool->flush_ser) -
+				atomic_read_wrap(&pool->req_ser) >= 0 &&
 		    !kthread_should_stop())
 			schedule();
 		__set_current_state(TASK_RUNNING);
@@ -262,8 +264,8 @@ struct ib_fmr_pool *ib_create_fmr_pool(struct ib_pd             *pd,
 	pool->dirty_watermark = params->dirty_watermark;
 	pool->dirty_len       = 0;
 	spin_lock_init(&pool->pool_lock);
-	atomic_set(&pool->req_ser,   0);
-	atomic_set(&pool->flush_ser, 0);
+	atomic_set_wrap(&pool->req_ser,   0);
+	atomic_set_wrap(&pool->flush_ser, 0);
 	init_waitqueue_head(&pool->force_wait);
 
 	pool->thread = kthread_run(ib_fmr_cleanup_thread,
@@ -388,11 +390,12 @@ int ib_flush_fmr_pool(struct ib_fmr_pool *pool)
 	}
 	spin_unlock_irq(&pool->pool_lock);
 
-	serial = atomic_inc_return(&pool->req_ser);
+	serial = atomic_inc_return_wrap(&pool->req_ser);
 	wake_up_process(pool->thread);
 
 	if (wait_event_interruptible(pool->force_wait,
-				     atomic_read(&pool->flush_ser) - serial >= 0))
+				     atomic_read_wrap(&pool->flush_ser) -
+				     serial >= 0))
 		return -EINTR;
 
 	return 0;
@@ -502,7 +505,7 @@ int ib_fmr_pool_unmap(struct ib_pool_fmr *fmr)
 		} else {
 			list_add_tail(&fmr->list, &pool->dirty_list);
 			if (++pool->dirty_len >= pool->dirty_watermark) {
-				atomic_inc(&pool->req_ser);
+				atomic_inc_wrap(&pool->req_ser);
 				wake_up_process(pool->thread);
 			}
 		}
diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 80e2774..107629d 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -266,7 +266,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 	int err;
 	struct fw_ri_tpte tpt;
 	u32 stag_idx;
-	static atomic_t key;
+	static atomic_wrap_t key;
 
 	if (c4iw_fatal_error(rdev))
 		return -EIO;
@@ -287,7 +287,7 @@ static int write_tpt_entry(struct c4iw_rdev *rdev, u32 reset_tpt_entry,
 		if (rdev->stats.stag.cur > rdev->stats.stag.max)
 			rdev->stats.stag.max = rdev->stats.stag.cur;
 		mutex_unlock(&rdev->stats.lock);
-		*stag = (stag_idx << 8) | (atomic_inc_return(&key) & 0xff);
+		*stag = (stag_idx << 8) | (atomic_inc_return_wrap(&key) & 0xff);
 	}
 	PDBG("%s stag_state 0x%0x type 0x%0x pdid 0x%0x, stag_idx 0x%x\n",
 	     __func__, stag_state, type, pdid, stag_idx);
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 1672907..baa0570 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -99,7 +99,7 @@ __be64 mlx4_ib_gen_node_guid(void)
 
 __be64 mlx4_ib_get_new_demux_tid(struct mlx4_ib_demux_ctx *ctx)
 {
-	return cpu_to_be64(atomic_inc_return(&ctx->tid)) |
+	return cpu_to_be64(atomic_inc_return_wrap(&ctx->tid)) |
 		cpu_to_be64(0xff00000000000000LL);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index a21d37f..8e68763 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -1043,7 +1043,7 @@ int mlx4_ib_mcg_port_init(struct mlx4_ib_demux_ctx *ctx)
 {
 	char name[20];
 
-	atomic_set(&ctx->tid, 0);
+	atomic_set_wrap(&ctx->tid, 0);
 	sprintf(name, "mlx4_ib_mcg%d", ctx->port);
 	ctx->mcg_wq = alloc_ordered_workqueue(name, WQ_MEM_RECLAIM);
 	if (!ctx->mcg_wq)
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 35141f4..867a6e9 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -457,7 +457,7 @@ struct mlx4_ib_demux_ctx {
 	struct list_head	mcg_mgid0_list;
 	struct workqueue_struct	*mcg_wq;
 	struct mlx4_ib_demux_pv_ctx **tun;
-	atomic_t tid;
+	atomic_wrap_t tid;
 	int    flushing; /* flushing the work queue */
 };
 
diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
index 35cbb17..8b516e3 100644
--- a/drivers/infiniband/hw/nes/nes.c
+++ b/drivers/infiniband/hw/nes/nes.c
@@ -97,7 +97,7 @@ MODULE_PARM_DESC(limit_maxrdreqsz, "Limit max read request size to 256 Bytes");
 LIST_HEAD(nes_adapter_list);
 static LIST_HEAD(nes_dev_list);
 
-atomic_t qps_destroyed;
+atomic_wrap_t qps_destroyed;
 
 static unsigned int ee_flsh_adapter;
 static unsigned int sysfs_nonidx_addr;
@@ -268,7 +268,7 @@ static void nes_cqp_rem_ref_callback(struct nes_device *nesdev, struct nes_cqp_r
 	struct nes_qp *nesqp = cqp_request->cqp_callback_pointer;
 	struct nes_adapter *nesadapter = nesdev->nesadapter;
 
-	atomic_inc(&qps_destroyed);
+	atomic_inc_wrap(&qps_destroyed);
 
 	/* Free the control structures */
 
diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
index e7430c9..d6e45c5d 100644
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
+extern atomic_wrap_t cm_connects;
+extern atomic_wrap_t cm_accepts;
+extern atomic_wrap_t cm_disconnects;
+extern atomic_wrap_t cm_closes;
+extern atomic_wrap_t cm_connecteds;
+extern atomic_wrap_t cm_connect_reqs;
+extern atomic_wrap_t cm_rejects;
+extern atomic_wrap_t mod_qp_timouts;
+extern atomic_wrap_t qps_created;
+extern atomic_wrap_t qps_destroyed;
+extern atomic_wrap_t sw_qps_destroyed;
 extern u32 mh_detected;
 extern u32 mh_pauses_sent;
 extern u32 cm_packets_sent;
@@ -199,16 +199,16 @@ extern u32 cm_packets_created;
 extern u32 cm_packets_received;
 extern u32 cm_packets_dropped;
 extern u32 cm_packets_retrans;
-extern atomic_t cm_listens_created;
-extern atomic_t cm_listens_destroyed;
+extern atomic_wrap_t cm_listens_created;
+extern atomic_wrap_t cm_listens_destroyed;
 extern u32 cm_backlog_drops;
-extern atomic_t cm_loopbacks;
-extern atomic_t cm_nodes_created;
-extern atomic_t cm_nodes_destroyed;
-extern atomic_t cm_accel_dropped_pkts;
-extern atomic_t cm_resets_recvd;
-extern atomic_t pau_qps_created;
-extern atomic_t pau_qps_destroyed;
+extern atomic_wrap_t cm_loopbacks;
+extern atomic_wrap_t cm_nodes_created;
+extern atomic_wrap_t cm_nodes_destroyed;
+extern atomic_wrap_t cm_accel_dropped_pkts;
+extern atomic_wrap_t cm_resets_recvd;
+extern atomic_wrap_t pau_qps_created;
+extern atomic_wrap_t pau_qps_destroyed;
 
 extern u32 int_mod_timer_init;
 extern u32 int_mod_cq_depth_256;
diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 57db9b3..925cb6b 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -69,14 +69,14 @@ u32 cm_packets_dropped;
 u32 cm_packets_retrans;
 u32 cm_packets_created;
 u32 cm_packets_received;
-atomic_t cm_listens_created;
-atomic_t cm_listens_destroyed;
+atomic_wrap_t cm_listens_created;
+atomic_wrap_t cm_listens_destroyed;
 u32 cm_backlog_drops;
-atomic_t cm_loopbacks;
-atomic_t cm_nodes_created;
-atomic_t cm_nodes_destroyed;
-atomic_t cm_accel_dropped_pkts;
-atomic_t cm_resets_recvd;
+atomic_wrap_t cm_loopbacks;
+atomic_wrap_t cm_nodes_created;
+atomic_wrap_t cm_nodes_destroyed;
+atomic_wrap_t cm_accel_dropped_pkts;
+atomic_wrap_t cm_resets_recvd;
 
 static inline int mini_cm_accelerated(struct nes_cm_core *, struct nes_cm_node *);
 static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *, struct nes_vnic *, struct nes_cm_info *);
@@ -150,13 +150,13 @@ static const struct nes_cm_ops nes_cm_api = {
 
 static struct nes_cm_core *g_cm_core;
 
-atomic_t cm_connects;
-atomic_t cm_accepts;
-atomic_t cm_disconnects;
-atomic_t cm_closes;
-atomic_t cm_connecteds;
-atomic_t cm_connect_reqs;
-atomic_t cm_rejects;
+atomic_wrap_t cm_connects;
+atomic_wrap_t cm_accepts;
+atomic_wrap_t cm_disconnects;
+atomic_wrap_t cm_closes;
+atomic_wrap_t cm_connecteds;
+atomic_wrap_t cm_connect_reqs;
+atomic_wrap_t cm_rejects;
 
 int nes_add_ref_cm_node(struct nes_cm_node *cm_node)
 {
@@ -1333,7 +1333,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 		kfree(listener);
 		listener = NULL;
 		ret = 0;
-		atomic_inc(&cm_listens_destroyed);
+		atomic_inc_wrap(&cm_listens_destroyed);
 	} else {
 		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
 	}
@@ -1537,7 +1537,7 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
 		  cm_node->rem_mac);
 
 	add_hte_node(cm_core, cm_node);
-	atomic_inc(&cm_nodes_created);
+	atomic_inc_wrap(&cm_nodes_created);
 
 	return cm_node;
 }
@@ -1596,7 +1596,7 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
 	}
 
 	atomic_dec(&cm_core->node_cnt);
-	atomic_inc(&cm_nodes_destroyed);
+	atomic_inc_wrap(&cm_nodes_destroyed);
 	nesqp = cm_node->nesqp;
 	if (nesqp) {
 		nesqp->cm_node = NULL;
@@ -1660,7 +1660,7 @@ static int process_options(struct nes_cm_node *cm_node, u8 *optionsloc,
 
 static void drop_packet(struct sk_buff *skb)
 {
-	atomic_inc(&cm_accel_dropped_pkts);
+	atomic_inc_wrap(&cm_accel_dropped_pkts);
 	dev_kfree_skb_any(skb);
 }
 
@@ -1723,7 +1723,7 @@ static void handle_rst_pkt(struct nes_cm_node *cm_node, struct sk_buff *skb,
 {
 
 	int	reset = 0;	/* whether to send reset in case of err.. */
-	atomic_inc(&cm_resets_recvd);
+	atomic_inc_wrap(&cm_resets_recvd);
 	nes_debug(NES_DBG_CM, "Received Reset, cm_node = %p, state = %u."
 			" refcnt=%d\n", cm_node, cm_node->state,
 			atomic_read(&cm_node->ref_count));
@@ -2369,7 +2369,7 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
 				rem_ref_cm_node(cm_node->cm_core, cm_node);
 				return NULL;
 			}
-			atomic_inc(&cm_loopbacks);
+			atomic_inc_wrap(&cm_loopbacks);
 			loopbackremotenode->loopbackpartner = cm_node;
 			loopbackremotenode->tcp_cntxt.rcv_wscale =
 				NES_CM_DEFAULT_RCV_WND_SCALE;
@@ -2644,7 +2644,7 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
 				nes_queue_mgt_skbs(skb, nesvnic, cm_node->nesqp);
 			else {
 				rem_ref_cm_node(cm_core, cm_node);
-				atomic_inc(&cm_accel_dropped_pkts);
+				atomic_inc_wrap(&cm_accel_dropped_pkts);
 				dev_kfree_skb_any(skb);
 			}
 			break;
@@ -2965,7 +2965,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 
 	if ((cm_id) && (cm_id->event_handler)) {
 		if (issue_disconn) {
-			atomic_inc(&cm_disconnects);
+			atomic_inc_wrap(&cm_disconnects);
 			cm_event.event = IW_CM_EVENT_DISCONNECT;
 			cm_event.status = disconn_status;
 			cm_event.local_addr = cm_id->m_local_addr;
@@ -2987,7 +2987,7 @@ static int nes_cm_disconn_true(struct nes_qp *nesqp)
 		}
 
 		if (issue_close) {
-			atomic_inc(&cm_closes);
+			atomic_inc_wrap(&cm_closes);
 			nes_disconnect(nesqp, 1);
 
 			cm_id->provider_data = nesqp;
@@ -3124,7 +3124,7 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 
 	nes_debug(NES_DBG_CM, "QP%u, cm_node=%p, jiffies = %lu listener = %p\n",
 		nesqp->hwqp.qp_id, cm_node, jiffies, cm_node->listener);
-	atomic_inc(&cm_accepts);
+	atomic_inc_wrap(&cm_accepts);
 
 	nes_debug(NES_DBG_CM, "netdev refcnt = %u.\n",
 			netdev_refcnt_read(nesvnic->netdev));
@@ -3320,7 +3320,7 @@ int nes_reject(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	struct nes_cm_core *cm_core;
 	u8 *start_buff;
 
-	atomic_inc(&cm_rejects);
+	atomic_inc_wrap(&cm_rejects);
 	cm_node = (struct nes_cm_node *)cm_id->provider_data;
 	loopback = cm_node->loopbackpartner;
 	cm_core = cm_node->cm_core;
@@ -3382,7 +3382,7 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		  ntohs(raddr->sin_port), ntohl(laddr->sin_addr.s_addr),
 		  ntohs(laddr->sin_port));
 
-	atomic_inc(&cm_connects);
+	atomic_inc_wrap(&cm_connects);
 	nesqp->active_conn = 1;
 
 	/* cache the cm_id in the qp */
@@ -3496,7 +3496,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
 			g_cm_core->api->stop_listener(g_cm_core, (void *)cm_node);
 			return err;
 		}
-		atomic_inc(&cm_listens_created);
+		atomic_inc_wrap(&cm_listens_created);
 	}
 
 	cm_id->add_ref(cm_id);
@@ -3603,7 +3603,7 @@ static void cm_event_connected(struct nes_cm_event *event)
 
 	if (nesqp->destroyed)
 		return;
-	atomic_inc(&cm_connecteds);
+	atomic_inc_wrap(&cm_connecteds);
 	nes_debug(NES_DBG_CM, "QP%u attempting to connect to  0x%08X:0x%04X on"
 		  " local port 0x%04X. jiffies = %lu.\n",
 		  nesqp->hwqp.qp_id, ntohl(raddr->sin_addr.s_addr),
@@ -3788,7 +3788,7 @@ static void cm_event_reset(struct nes_cm_event *event)
 
 	cm_id->add_ref(cm_id);
 	ret = cm_id->event_handler(cm_id, &cm_event);
-	atomic_inc(&cm_closes);
+	atomic_inc_wrap(&cm_closes);
 	cm_event.event = IW_CM_EVENT_CLOSE;
 	cm_event.status = 0;
 	cm_event.provider_data = cm_id->provider_data;
@@ -3828,7 +3828,7 @@ static void cm_event_mpa_req(struct nes_cm_event *event)
 		return;
 	cm_id = cm_node->cm_id;
 
-	atomic_inc(&cm_connect_reqs);
+	atomic_inc_wrap(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
 		  cm_node, cm_id, jiffies);
 
@@ -3877,7 +3877,7 @@ static void cm_event_mpa_reject(struct nes_cm_event *event)
 		return;
 	cm_id = cm_node->cm_id;
 
-	atomic_inc(&cm_connect_reqs);
+	atomic_inc_wrap(&cm_connect_reqs);
 	nes_debug(NES_DBG_CM, "cm_node = %p - cm_id = %p, jiffies = %lu\n",
 		  cm_node, cm_id, jiffies);
 
diff --git a/drivers/infiniband/hw/nes/nes_mgt.c b/drivers/infiniband/hw/nes/nes_mgt.c
index 4166452..2022669 100644
--- a/drivers/infiniband/hw/nes/nes_mgt.c
+++ b/drivers/infiniband/hw/nes/nes_mgt.c
@@ -40,8 +40,8 @@
 #include "nes.h"
 #include "nes_mgt.h"
 
-atomic_t pau_qps_created;
-atomic_t pau_qps_destroyed;
+atomic_wrap_t pau_qps_created;
+atomic_wrap_t pau_qps_destroyed;
 
 static void nes_replenish_mgt_rq(struct nes_vnic_mgt *mgtvnic)
 {
@@ -621,7 +621,7 @@ void nes_destroy_pau_qp(struct nes_device *nesdev, struct nes_qp *nesqp)
 {
 	struct sk_buff *skb;
 	unsigned long flags;
-	atomic_inc(&pau_qps_destroyed);
+	atomic_inc_wrap(&pau_qps_destroyed);
 
 	/* Free packets that have not yet been forwarded */
 	/* Lock is acquired by skb_dequeue when removing the skb */
@@ -810,7 +810,7 @@ static void nes_mgt_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *
 					cq->cq_vbase[head].cqe_words[NES_NIC_CQE_HASH_RCVNXT]);
 				skb_queue_head_init(&nesqp->pau_list);
 				spin_lock_init(&nesqp->pau_lock);
-				atomic_inc(&pau_qps_created);
+				atomic_inc_wrap(&pau_qps_created);
 				nes_change_quad_hash(nesdev, mgtvnic->nesvnic, nesqp);
 			}
 
diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
index 2b27d13..d516c5e 100644
--- a/drivers/infiniband/hw/nes/nes_nic.c
+++ b/drivers/infiniband/hw/nes/nes_nic.c
@@ -1264,36 +1264,36 @@ static void nes_netdev_get_ethtool_stats(struct net_device *netdev,
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
+	target_stat_values[++index] = atomic_read_wrap(&cm_connects);
+	target_stat_values[++index] = atomic_read_wrap(&cm_accepts);
+	target_stat_values[++index] = atomic_read_wrap(&cm_disconnects);
+	target_stat_values[++index] = atomic_read_wrap(&cm_connecteds);
+	target_stat_values[++index] = atomic_read_wrap(&cm_connect_reqs);
+	target_stat_values[++index] = atomic_read_wrap(&cm_rejects);
+	target_stat_values[++index] = atomic_read_wrap(&mod_qp_timouts);
+	target_stat_values[++index] = atomic_read_wrap(&qps_created);
+	target_stat_values[++index] = atomic_read_wrap(&sw_qps_destroyed);
+	target_stat_values[++index] = atomic_read_wrap(&qps_destroyed);
+	target_stat_values[++index] = atomic_read_wrap(&cm_closes);
 	target_stat_values[++index] = cm_packets_sent;
 	target_stat_values[++index] = cm_packets_bounced;
 	target_stat_values[++index] = cm_packets_created;
 	target_stat_values[++index] = cm_packets_received;
 	target_stat_values[++index] = cm_packets_dropped;
 	target_stat_values[++index] = cm_packets_retrans;
-	target_stat_values[++index] = atomic_read(&cm_listens_created);
-	target_stat_values[++index] = atomic_read(&cm_listens_destroyed);
+	target_stat_values[++index] = atomic_read_wrap(&cm_listens_created);
+	target_stat_values[++index] = atomic_read_wrap(&cm_listens_destroyed);
 	target_stat_values[++index] = cm_backlog_drops;
-	target_stat_values[++index] = atomic_read(&cm_loopbacks);
-	target_stat_values[++index] = atomic_read(&cm_nodes_created);
-	target_stat_values[++index] = atomic_read(&cm_nodes_destroyed);
-	target_stat_values[++index] = atomic_read(&cm_accel_dropped_pkts);
-	target_stat_values[++index] = atomic_read(&cm_resets_recvd);
+	target_stat_values[++index] = atomic_read_wrap(&cm_loopbacks);
+	target_stat_values[++index] = atomic_read_wrap(&cm_nodes_created);
+	target_stat_values[++index] = atomic_read_wrap(&cm_nodes_destroyed);
+	target_stat_values[++index] = atomic_read_wrap(&cm_accel_dropped_pkts);
+	target_stat_values[++index] = atomic_read_wrap(&cm_resets_recvd);
 	target_stat_values[++index] = nesadapter->free_4kpbl;
 	target_stat_values[++index] = nesadapter->free_256pbl;
 	target_stat_values[++index] = int_mod_timer_init;
-	target_stat_values[++index] = atomic_read(&pau_qps_created);
-	target_stat_values[++index] = atomic_read(&pau_qps_destroyed);
+	target_stat_values[++index] = atomic_read_wrap(&pau_qps_created);
+	target_stat_values[++index] = atomic_read_wrap(&pau_qps_destroyed);
 }
 
 /**
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index bd69125..9318f3c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -46,9 +46,9 @@
 
 #include <rdma/ib_umem.h>
 
-atomic_t mod_qp_timouts;
-atomic_t qps_created;
-atomic_t sw_qps_destroyed;
+atomic_wrap_t mod_qp_timouts;
+atomic_wrap_t qps_created;
+atomic_wrap_t sw_qps_destroyed;
 
 static void nes_unregister_ofa_device(struct nes_ib_device *nesibdev);
 static int nes_dereg_mr(struct ib_mr *ib_mr);
@@ -1040,7 +1040,7 @@ static struct ib_qp *nes_create_qp(struct ib_pd *ibpd,
 	if (init_attr->create_flags)
 		return ERR_PTR(-EINVAL);
 
-	atomic_inc(&qps_created);
+	atomic_inc_wrap(&qps_created);
 	switch (init_attr->qp_type) {
 		case IB_QPT_RC:
 			if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) {
@@ -1376,7 +1376,7 @@ static int nes_destroy_qp(struct ib_qp *ibqp)
 	struct iw_cm_event cm_event;
 	int ret = 0;
 
-	atomic_inc(&sw_qps_destroyed);
+	atomic_inc_wrap(&sw_qps_destroyed);
 	nesqp->destroyed = 1;
 
 	/* Blow away the connection if it exists. */
diff --git a/drivers/input/gameport/gameport.c b/drivers/input/gameport/gameport.c
index 4a2a9e3..2932903 100644
--- a/drivers/input/gameport/gameport.c
+++ b/drivers/input/gameport/gameport.c
@@ -527,14 +527,14 @@ EXPORT_SYMBOL(gameport_set_phys);
  */
 static void gameport_init_port(struct gameport *gameport)
 {
-	static atomic_t gameport_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t gameport_no = ATOMIC_INIT(-1);
 
 	__module_get(THIS_MODULE);
 
 	mutex_init(&gameport->drv_mutex);
 	device_initialize(&gameport->dev);
 	dev_set_name(&gameport->dev, "gameport%lu",
-			(unsigned long)atomic_inc_return(&gameport_no));
+			(unsigned long)atomic_inc_return_wrap(&gameport_no));
 	gameport->dev.bus = &gameport_bus;
 	gameport->dev.release = gameport_release_port;
 	if (gameport->parent)
diff --git a/drivers/input/input.c b/drivers/input/input.c
index d95c34e..e2a8ffa 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1780,7 +1780,7 @@ EXPORT_SYMBOL_GPL(input_class);
  */
 struct input_dev *input_allocate_device(void)
 {
-	static atomic_t input_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t input_no = ATOMIC_INIT(-1);
 	struct input_dev *dev;
 
 	dev = kzalloc(sizeof(struct input_dev), GFP_KERNEL);
@@ -1795,7 +1795,7 @@ struct input_dev *input_allocate_device(void)
 		INIT_LIST_HEAD(&dev->node);
 
 		dev_set_name(&dev->dev, "input%lu",
-			     (unsigned long)atomic_inc_return(&input_no));
+			     (unsigned long)atomic_inc_return_wrap(&input_no));
 
 		__module_get(THIS_MODULE);
 	}
diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
index 9c0ea36..87acf90 100644
--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -1855,7 +1855,7 @@ static int ims_pcu_identify_type(struct ims_pcu *pcu, u8 *device_id)
 
 static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 {
-	static atomic_t device_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t device_no = ATOMIC_INIT(-1);
 
 	const struct ims_pcu_device_info *info;
 	int error;
@@ -1886,7 +1886,7 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
 	}
 
 	/* Device appears to be operable, complete initialization */
-	pcu->device_no = atomic_inc_return(&device_no);
+	pcu->device_no = atomic_inc_return_wrap(&device_no);
 
 	/*
 	 * PCU-B devices, both GEN_1 and GEN_2 do not have OFN sensor
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 1ca7f55..78db72e 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -512,7 +512,7 @@ static void serio_release_port(struct device *dev)
  */
 static void serio_init_port(struct serio *serio)
 {
-	static atomic_t serio_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t serio_no = ATOMIC_INIT(-1);
 
 	__module_get(THIS_MODULE);
 
@@ -523,7 +523,7 @@ static void serio_init_port(struct serio *serio)
 	mutex_init(&serio->drv_mutex);
 	device_initialize(&serio->dev);
 	dev_set_name(&serio->dev, "serio%lu",
-		     (unsigned long)atomic_inc_return(&serio_no));
+		     (unsigned long)atomic_inc_return_wrap(&serio_no));
 	serio->dev.bus = &serio_bus;
 	serio->dev.release = serio_release_port;
 	serio->dev.groups = serio_device_attr_groups;
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 71ef5d6..10d7b5b 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -292,7 +292,7 @@ static irqreturn_t serio_raw_interrupt(struct serio *serio, unsigned char data,
 
 static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 {
-	static atomic_t serio_raw_no = ATOMIC_INIT(-1);
+	static atomic_wrap_t serio_raw_no = ATOMIC_INIT(-1);
 	struct serio_raw *serio_raw;
 	int err;
 
@@ -303,7 +303,7 @@ static int serio_raw_connect(struct serio *serio, struct serio_driver *drv)
 	}
 
 	snprintf(serio_raw->name, sizeof(serio_raw->name),
-		 "serio_raw%ld", (long)atomic_inc_return(&serio_raw_no));
+		 "serio_raw%ld", (long)atomic_inc_return_wrap(&serio_raw_no));
 	kref_init(&serio_raw->kref);
 	INIT_LIST_HEAD(&serio_raw->client_list);
 	init_waitqueue_head(&serio_raw->wait);
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index 6a2df32..70ef916 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -81,8 +81,8 @@ struct capiminor {
 
 	struct capi20_appl	*ap;
 	u32			ncci;
-	atomic_t		datahandle;
-	atomic_t		msgid;
+	atomic_wrap_t	datahandle;
+	atomic_wrap_t	msgid;
 
 	struct tty_port port;
 	int                ttyinstop;
@@ -391,7 +391,7 @@ gen_data_b3_resp_for(struct capiminor *mp, struct sk_buff *skb)
 		capimsg_setu16(s, 2, mp->ap->applid);
 		capimsg_setu8 (s, 4, CAPI_DATA_B3);
 		capimsg_setu8 (s, 5, CAPI_RESP);
-		capimsg_setu16(s, 6, atomic_inc_return(&mp->msgid));
+		capimsg_setu16(s, 6, atomic_inc_return_wrap(&mp->msgid));
 		capimsg_setu32(s, 8, mp->ncci);
 		capimsg_setu16(s, 12, datahandle);
 	}
@@ -512,14 +512,15 @@ static void handle_minor_send(struct capiminor *mp)
 		mp->outbytes -= len;
 		spin_unlock_bh(&mp->outlock);
 
-		datahandle = atomic_inc_return(&mp->datahandle);
+		datahandle = atomic_inc_return_wrap(&mp->datahandle);
 		skb_push(skb, CAPI_DATA_B3_REQ_LEN);
 		memset(skb->data, 0, CAPI_DATA_B3_REQ_LEN);
 		capimsg_setu16(skb->data, 0, CAPI_DATA_B3_REQ_LEN);
 		capimsg_setu16(skb->data, 2, mp->ap->applid);
 		capimsg_setu8 (skb->data, 4, CAPI_DATA_B3);
 		capimsg_setu8 (skb->data, 5, CAPI_REQ);
-		capimsg_setu16(skb->data, 6, atomic_inc_return(&mp->msgid));
+		capimsg_setu16(skb->data, 6,
+			       atomic_inc_return_wrap(&mp->msgid));
 		capimsg_setu32(skb->data, 8, mp->ncci);	/* NCCI */
 		capimsg_setu32(skb->data, 12, (u32)(long)skb->data);/* Data32 */
 		capimsg_setu16(skb->data, 16, len);	/* Data length */
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 40ceba1..7ebbae9 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -75,8 +75,8 @@ struct mapped_device {
 	 * Event handling.
 	 */
 	wait_queue_head_t eventq;
-	atomic_t event_nr;
-	atomic_t uevent_seq;
+	atomic_wrap_t event_nr;
+	atomic_wrap_t uevent_seq;
 	struct list_head uevent_list;
 	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8abde6b..ebff142 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3190,7 +3190,8 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 				      mddev->resync_max_sectors : mddev->dev_sectors;
 		progress = rs_get_progress(rs, resync_max_sectors, &array_in_sync);
 		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
-				    atomic64_read(&mddev->resync_mismatches) : 0;
+				    atomic64_read_wrap(&mddev->
+						    resync_mismatches) : 0;
 		sync_action = decipher_sync_action(&rs->md);
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D' or 'A' now */
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index bdf1606..f80fdce 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -42,7 +42,7 @@ enum dm_raid1_error {
 
 struct mirror {
 	struct mirror_set *ms;
-	atomic_t error_count;
+	atomic_wrap_t error_count;
 	unsigned long error_type;
 	struct dm_dev *dev;
 	sector_t offset;
@@ -188,7 +188,7 @@ static struct mirror *get_valid_mirror(struct mirror_set *ms)
 	struct mirror *m;
 
 	for (m = ms->mirror; m < ms->mirror + ms->nr_mirrors; m++)
-		if (!atomic_read(&m->error_count))
+		if (!atomic_read_wrap(&m->error_count))
 			return m;
 
 	return NULL;
@@ -220,7 +220,7 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 	 * simple way to tell if a device has encountered
 	 * errors.
 	 */
-	atomic_inc(&m->error_count);
+	atomic_inc_wrap(&m->error_count);
 
 	if (test_and_set_bit(error_type, &m->error_type))
 		return;
@@ -379,7 +379,7 @@ static void reset_ms_flags(struct mirror_set *ms)
 
 	ms->leg_failure = 0;
 	for (m = 0; m < ms->nr_mirrors; m++) {
-		atomic_set(&(ms->mirror[m].error_count), 0);
+		atomic_set_wrap(&(ms->mirror[m].error_count), 0);
 		ms->mirror[m].error_type = 0;
 	}
 }
@@ -424,7 +424,7 @@ static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 	struct mirror *m = get_default_mirror(ms);
 
 	do {
-		if (likely(!atomic_read(&m->error_count)))
+		if (likely(!atomic_read_wrap(&m->error_count)))
 			return m;
 
 		if (m-- == ms->mirror)
@@ -438,7 +438,7 @@ static int default_ok(struct mirror *m)
 {
 	struct mirror *default_mirror = get_default_mirror(m->ms);
 
-	return !atomic_read(&default_mirror->error_count);
+	return !atomic_read_wrap(&default_mirror->error_count);
 }
 
 static int mirror_available(struct mirror_set *ms, struct bio *bio)
@@ -578,7 +578,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 		 */
 		if (likely(region_in_sync(ms, region, 1)))
 			m = choose_mirror(ms, bio->bi_iter.bi_sector);
-		else if (m && atomic_read(&m->error_count))
+		else if (m && atomic_read_wrap(&m->error_count))
 			m = NULL;
 
 		if (likely(m))
@@ -963,7 +963,7 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 	}
 
 	ms->mirror[mirror].ms = ms;
-	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	atomic_set_wrap(&(ms->mirror[mirror].error_count), 0);
 	ms->mirror[mirror].error_type = 0;
 	ms->mirror[mirror].offset = offset;
 
@@ -1388,7 +1388,7 @@ static void mirror_resume(struct dm_target *ti)
  */
 static char device_status_char(struct mirror *m)
 {
-	if (!atomic_read(&(m->error_count)))
+	if (!atomic_read_wrap(&(m->error_count)))
 		return 'A';
 
 	return (test_bit(DM_RAID1_FLUSH_ERROR, &(m->error_type))) ? 'F' :
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 28193a5..c118b28 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -21,7 +21,7 @@ struct stripe {
 	struct dm_dev *dev;
 	sector_t physical_start;
 
-	atomic_t error_count;
+	atomic_wrap_t error_count;
 };
 
 struct stripe_c {
@@ -190,7 +190,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 			kfree(sc);
 			return r;
 		}
-		atomic_set(&(sc->stripe[i].error_count), 0);
+		atomic_set_wrap(&(sc->stripe[i].error_count), 0);
 	}
 
 	ti->private = sc;
@@ -357,7 +357,8 @@ static void stripe_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%d ", sc->stripes);
 		for (i = 0; i < sc->stripes; i++)  {
 			DMEMIT("%s ", sc->stripe[i].dev->name);
-			buffer[i] = atomic_read(&(sc->stripe[i].error_count)) ?
+			buffer[i] = atomic_read_wrap(&(sc->
+						stripe[i].error_count)) ?
 				'D' : 'A';
 		}
 		buffer[i] = '\0';
@@ -402,8 +403,8 @@ static int stripe_end_io(struct dm_target *ti, struct bio *bio, int error)
 	 */
 	for (i = 0; i < sc->stripes; i++)
 		if (!strcmp(sc->stripe[i].dev->name, major_minor)) {
-			atomic_inc(&(sc->stripe[i].error_count));
-			if (atomic_read(&(sc->stripe[i].error_count)) <
+			atomic_inc_wrap(&(sc->stripe[i].error_count));
+			if (atomic_read_wrap(&(sc->stripe[i].error_count)) <
 			    DM_IO_ERROR_THRESHOLD)
 				schedule_work(&sc->trigger_event);
 		}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 147af95..6e71bd3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1484,8 +1484,8 @@ static struct mapped_device *alloc_dev(int minor)
 	spin_lock_init(&md->deferred_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
-	atomic_set(&md->event_nr, 0);
-	atomic_set(&md->uevent_seq, 0);
+	atomic_set_wrap(&md->event_nr, 0);
+	atomic_set_wrap(&md->uevent_seq, 0);
 	INIT_LIST_HEAD(&md->uevent_list);
 	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
@@ -1624,7 +1624,7 @@ static void event_callback(void *context)
 
 	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
-	atomic_inc(&md->event_nr);
+	atomic_inc_wrap(&md->event_nr);
 	wake_up(&md->eventq);
 }
 
@@ -2412,18 +2412,18 @@ int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
 
 uint32_t dm_next_uevent_seq(struct mapped_device *md)
 {
-	return atomic_add_return(1, &md->uevent_seq);
+	return atomic_add_return_wrap(1, &md->uevent_seq);
 }
 
 uint32_t dm_get_event_nr(struct mapped_device *md)
 {
-	return atomic_read(&md->event_nr);
+	return atomic_read_wrap(&md->event_nr);
 }
 
 int dm_wait_event(struct mapped_device *md, int event_nr)
 {
 	return wait_event_interruptible(md->eventq,
-			(event_nr != atomic_read(&md->event_nr)));
+			(event_nr != atomic_read_wrap(&md->event_nr)));
 }
 
 void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index eac84d8..1a78066 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -198,10 +198,10 @@ EXPORT_SYMBOL_GPL(bio_clone_mddev);
  *  start build, activate spare
  */
 static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
-static atomic_t md_event_count;
+static atomic_wrap_t md_event_count;
 void md_new_event(struct mddev *mddev)
 {
-	atomic_inc(&md_event_count);
+	atomic_inc_wrap(&md_event_count);
 	wake_up(&md_event_waiters);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
@@ -1434,7 +1434,8 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_RESHAPE_ACTIVE) &&
 	    (le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
 		rdev->new_data_offset += (s32)le32_to_cpu(sb->new_offset);
-	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
+	atomic_set_wrap(&rdev->corrected_errors,
+			le32_to_cpu(sb->cnt_corrected_read));
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
 	bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
@@ -1700,7 +1701,8 @@ static void super_1_sync(struct mddev *mddev, struct md_rdev *rdev)
 	else
 		sb->resync_offset = cpu_to_le64(0);
 
-	sb->cnt_corrected_read = cpu_to_le32(atomic_read(&rdev->corrected_errors));
+	sb->cnt_corrected_read = cpu_to_le32(atomic_read_wrap(
+				&rdev->corrected_errors));
 
 	sb->raid_disks = cpu_to_le32(mddev->raid_disks);
 	sb->size = cpu_to_le64(mddev->dev_sectors);
@@ -2719,7 +2721,7 @@ __ATTR_PREALLOC(state, S_IRUGO|S_IWUSR, state_show, state_store);
 static ssize_t
 errors_show(struct md_rdev *rdev, char *page)
 {
-	return sprintf(page, "%d\n", atomic_read(&rdev->corrected_errors));
+	return sprintf(page, "%d\n", atomic_read_wrap(&rdev->corrected_errors));
 }
 
 static ssize_t
@@ -2731,7 +2733,7 @@ errors_store(struct md_rdev *rdev, const char *buf, size_t len)
 	rv = kstrtouint(buf, 10, &n);
 	if (rv < 0)
 		return rv;
-	atomic_set(&rdev->corrected_errors, n);
+	atomic_set_wrap(&rdev->corrected_errors, n);
 	return len;
 }
 static struct rdev_sysfs_entry rdev_errors =
@@ -3180,8 +3182,8 @@ int md_rdev_init(struct md_rdev *rdev)
 	rdev->sb_loaded = 0;
 	rdev->bb_page = NULL;
 	atomic_set(&rdev->nr_pending, 0);
-	atomic_set(&rdev->read_errors, 0);
-	atomic_set(&rdev->corrected_errors, 0);
+	atomic_set_wrap(&rdev->read_errors, 0);
+	atomic_set_wrap(&rdev->corrected_errors, 0);
 
 	INIT_LIST_HEAD(&rdev->same_set);
 	init_waitqueue_head(&rdev->blocked_wait);
@@ -4403,7 +4405,7 @@ mismatch_cnt_show(struct mddev *mddev, char *page)
 {
 	return sprintf(page, "%llu\n",
 		       (unsigned long long)
-		       atomic64_read(&mddev->resync_mismatches));
+		       atomic64_read_wrap(&mddev->resync_mismatches));
 }
 
 static struct md_sysfs_entry md_mismatches = __ATTR_RO(mismatch_cnt);
@@ -5460,7 +5462,7 @@ static void md_clean(struct mddev *mddev)
 	mddev->new_layout = 0;
 	mddev->new_chunk_sectors = 0;
 	mddev->curr_resync = 0;
-	atomic64_set(&mddev->resync_mismatches, 0);
+	atomic64_set_wrap(&mddev->resync_mismatches, 0);
 	mddev->suspend_lo = mddev->suspend_hi = 0;
 	mddev->sync_speed_min = mddev->sync_speed_max = 0;
 	mddev->recovery = 0;
@@ -7455,7 +7457,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 
 		spin_unlock(&pers_lock);
 		seq_printf(seq, "\n");
-		seq->poll_event = atomic_read(&md_event_count);
+		seq->poll_event = atomic_read_wrap(&md_event_count);
 		return 0;
 	}
 	if (v == (void*)2) {
@@ -7555,7 +7557,7 @@ static int md_seq_open(struct inode *inode, struct file *file)
 		return error;
 
 	seq = file->private_data;
-	seq->poll_event = atomic_read(&md_event_count);
+	seq->poll_event = atomic_read_wrap(&md_event_count);
 	return error;
 }
 
@@ -7572,7 +7574,7 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
 	/* always allow read */
 	mask = POLLIN | POLLRDNORM;
 
-	if (seq->poll_event != atomic_read(&md_event_count))
+	if (seq->poll_event != atomic_read_wrap(&md_event_count))
 		mask |= POLLERR | POLLPRI;
 	return mask;
 }
@@ -7668,7 +7670,7 @@ static int is_mddev_idle(struct mddev *mddev, int init)
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
 		curr_events = (int)part_stat_read(&disk->part0, sectors[0]) +
 			      (int)part_stat_read(&disk->part0, sectors[1]) -
-			      atomic_read(&disk->sync_io);
+			      atomic_read_wrap(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
 		 * disk_stats is counted when it completes.
@@ -7938,7 +7940,7 @@ void md_do_sync(struct md_thread *thread)
 		 * which defaults to physical size, but can be virtual size
 		 */
 		max_sectors = mddev->resync_max_sectors;
-		atomic64_set(&mddev->resync_mismatches, 0);
+		atomic64_set_wrap(&mddev->resync_mismatches, 0);
 		/* we don't use the checkpoint if there's a bitmap */
 		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 			j = mddev->resync_min;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2b20417..9354de8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -96,13 +96,13 @@ struct md_rdev {
 					 * only maintained for arrays that
 					 * support hot removal
 					 */
-	atomic_t	read_errors;	/* number of consecutive read errors that
-					 * we have tried to ignore.
+	atomic_wrap_t	read_errors;	/* number of consecutive read errors
+					 * that we have tried to ignore.
 					 */
 	time64_t	last_read_error;	/* monotonic time since our
 						 * last read error
 						 */
-	atomic_t	corrected_errors; /* number of corrected read errors,
+	atomic_wrap_t	corrected_errors; /* number of corrected read errors,
 					   * for reporting to userspace and storing
 					   * in superblock.
 					   */
@@ -289,9 +289,10 @@ struct mddev {
 
 	sector_t			resync_max_sectors; /* may be set by personality */
 
-	atomic64_t			resync_mismatches; /* count of sectors where
-							    * parity/replica mismatch found
-							    */
+	atomic64_wrap_t			resync_mismatches;
+						/* count of sectors where
+						 * parity/replica mismatch found
+						 */
 
 	/* allow user-space to request suspension of IO to regions of the array */
 	sector_t			suspend_lo;
@@ -468,7 +469,7 @@ extern void mddev_unlock(struct mddev *mddev);
 
 static inline void md_sync_acct(struct block_device *bdev, unsigned long nr_sectors)
 {
-	atomic_add(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
+	atomic_add_wrap(nr_sectors, &bdev->bd_contains->bd_disk->sync_io);
 }
 
 struct md_personality
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1961d82..059113a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1876,7 +1876,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 			if (r1_sync_page_io(rdev, sect, s,
 					    bio->bi_io_vec[idx].bv_page,
 					    READ) != 0)
-				atomic_add(s, &rdev->corrected_errors);
+				atomic_add_wrap(s, &rdev->corrected_errors);
 		}
 		sectors -= s;
 		sect += s;
@@ -1967,7 +1967,8 @@ static void process_checks(struct r1bio *r1_bio)
 		} else
 			j = 0;
 		if (j >= 0)
-			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
+			atomic64_add_wrap(r1_bio->sectors,
+					  &mddev->resync_mismatches);
 		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
 			      && !error)) {
 			/* No need to write to this device. */
@@ -2118,7 +2119,8 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 				rcu_read_unlock();
 				if (r1_sync_page_io(rdev, sect, s,
 						    conf->tmppage, READ)) {
-					atomic_add(s, &rdev->corrected_errors);
+					atomic_add_wrap(s,
+							&rdev->corrected_errors);
 					printk(KERN_INFO
 					       "md/raid1:%s: read error corrected "
 					       "(%d sectors at %llu on %s)\n",
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index be1a9fc..5ef27b5 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1826,7 +1826,7 @@ static void end_sync_read(struct bio *bio)
 		/* The write handler will notice the lack of
 		 * R10BIO_Uptodate and record any errors etc
 		 */
-		atomic_add(r10_bio->sectors,
+		atomic_add_wrap(r10_bio->sectors,
 			   &conf->mirrors[d].rdev->corrected_errors);
 
 	/* for reconstruct, we always reschedule after a read.
@@ -1975,7 +1975,8 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			}
 			if (j == vcnt)
 				continue;
-			atomic64_add(r10_bio->sectors, &mddev->resync_mismatches);
+			atomic64_add_wrap(r10_bio->sectors,
+					  &mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
 				/* Don't fix anything. */
 				continue;
@@ -2174,7 +2175,7 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 {
 	long cur_time_mon;
 	unsigned long hours_since_last;
-	unsigned int read_errors = atomic_read(&rdev->read_errors);
+	unsigned int read_errors = atomic_read_wrap(&rdev->read_errors);
 
 	cur_time_mon = ktime_get_seconds();
 
@@ -2195,9 +2196,10 @@ static void check_decay_read_errors(struct mddev *mddev, struct md_rdev *rdev)
 	 * overflowing the shift of read_errors by hours_since_last.
 	 */
 	if (hours_since_last >= 8 * sizeof(read_errors))
-		atomic_set(&rdev->read_errors, 0);
+		atomic_set_wrap(&rdev->read_errors, 0);
 	else
-		atomic_set(&rdev->read_errors, read_errors >> hours_since_last);
+		atomic_set_wrap(&rdev->read_errors,
+				read_errors >> hours_since_last);
 }
 
 static int r10_sync_page_io(struct md_rdev *rdev, sector_t sector,
@@ -2251,8 +2253,8 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		return;
 
 	check_decay_read_errors(mddev, rdev);
-	atomic_inc(&rdev->read_errors);
-	if (atomic_read(&rdev->read_errors) > max_read_errors) {
+	atomic_inc_wrap(&rdev->read_errors);
+	if (atomic_read_wrap(&rdev->read_errors) > max_read_errors) {
 		char b[BDEVNAME_SIZE];
 		bdevname(rdev->bdev, b);
 
@@ -2260,7 +2262,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		       "md/raid10:%s: %s: Raid device exceeded "
 		       "read_error threshold [cur %d:max %d]\n",
 		       mdname(mddev), b,
-		       atomic_read(&rdev->read_errors), max_read_errors);
+		       atomic_read_wrap(&rdev->read_errors), max_read_errors);
 		printk(KERN_NOTICE
 		       "md/raid10:%s: %s: Failing raid device\n",
 		       mdname(mddev), b);
@@ -2417,7 +2419,7 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
 				       bdevname(rdev->bdev, b));
-				atomic_add(s, &rdev->corrected_errors);
+				atomic_add_wrap(s, &rdev->corrected_errors);
 			}
 
 			rdev_dec_pending(rdev, mddev);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 92ac251..b2bca0b 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2354,21 +2354,22 @@ static void raid5_end_read_request(struct bio * bi)
 				mdname(conf->mddev), STRIPE_SECTORS,
 				(unsigned long long)s,
 				bdevname(rdev->bdev, b));
-			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
+			atomic_add_wrap(STRIPE_SECTORS,
+					&rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
 		} else if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
 			clear_bit(R5_ReadNoMerge, &sh->dev[i].flags);
 
-		if (atomic_read(&rdev->read_errors))
-			atomic_set(&rdev->read_errors, 0);
+		if (atomic_read_wrap(&rdev->read_errors))
+			atomic_set_wrap(&rdev->read_errors, 0);
 	} else {
 		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
 		int set_bad = 0;
 
 		clear_bit(R5_UPTODATE, &sh->dev[i].flags);
-		atomic_inc(&rdev->read_errors);
+		atomic_inc_wrap(&rdev->read_errors);
 		if (test_bit(R5_ReadRepl, &sh->dev[i].flags))
 			printk_ratelimited(
 				KERN_WARNING
@@ -2396,7 +2397,7 @@ static void raid5_end_read_request(struct bio * bi)
 				mdname(conf->mddev),
 				(unsigned long long)s,
 				bdn);
-		} else if (atomic_read(&rdev->read_errors)
+		} else if (atomic_read_wrap(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
 			       "md/raid:%s: Too many read errors, failing device %s.\n",
@@ -3763,7 +3764,8 @@ static void handle_parity_checks5(struct r5conf *conf, struct stripe_head *sh,
 			 */
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			atomic64_add_wrap(STRIPE_SECTORS,
+					  &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
@@ -3915,7 +3917,8 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 				 */
 			}
 		} else {
-			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
+			atomic64_add_wrap(STRIPE_SECTORS,
+					  &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
 				set_bit(STRIPE_INSYNC, &sh->state);
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index ee48c3e..fd5b791 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -83,7 +83,7 @@ static struct pci_device_id ivtv_pci_tbl[] = {
 MODULE_DEVICE_TABLE(pci,ivtv_pci_tbl);
 
 /* ivtv instance counter */
-static atomic_t ivtv_instance = ATOMIC_INIT(0);
+static atomic_wrap_t ivtv_instance = ATOMIC_INIT(0);
 
 /* Parameter declarations */
 static int cardtype[IVTV_MAX_CARDS];
diff --git a/drivers/media/pci/solo6x10/solo6x10-p2m.c b/drivers/media/pci/solo6x10/solo6x10-p2m.c
index 8c84846..e63dc0f 100644
--- a/drivers/media/pci/solo6x10/solo6x10-p2m.c
+++ b/drivers/media/pci/solo6x10/solo6x10-p2m.c
@@ -73,7 +73,8 @@ int solo_p2m_dma_desc(struct solo_dev *solo_dev,
 
 	/* Get next ID. According to Softlogic, 6110 has problems on !=0 P2M */
 	if (solo_dev->type != SOLO_DEV_6110 && multi_p2m) {
-		p2m_id = atomic_inc_return(&solo_dev->p2m_count) % SOLO_NR_P2M;
+		p2m_id = atomic_inc_return_wrap(&solo_dev->p2m_count) %
+			SOLO_NR_P2M;
 		if (p2m_id < 0)
 			p2m_id = -p2m_id;
 	}
diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
index 5bd4987..3bafa1b 100644
--- a/drivers/media/pci/solo6x10/solo6x10.h
+++ b/drivers/media/pci/solo6x10/solo6x10.h
@@ -216,7 +216,7 @@ struct solo_dev {
 
 	/* P2M DMA Engine */
 	struct solo_p2m_dev	p2m_dev[SOLO_NR_P2M];
-	atomic_t		p2m_count;
+	atomic_wrap_t	p2m_count;
 	int			p2m_jiffies;
 	unsigned int		p2m_timeouts;
 
diff --git a/drivers/media/pci/tw68/tw68-core.c b/drivers/media/pci/tw68/tw68-core.c
index 8474528..151c587 100644
--- a/drivers/media/pci/tw68/tw68-core.c
+++ b/drivers/media/pci/tw68/tw68-core.c
@@ -61,7 +61,7 @@ static unsigned int card[] = {[0 ... (TW68_MAXBOARDS - 1)] = UNSET };
 module_param_array(card, int, NULL, 0444);
 MODULE_PARM_DESC(card, "card type");
 
-static atomic_t tw68_instance = ATOMIC_INIT(0);
+static atomic_wrap_t tw68_instance = ATOMIC_INIT(0);
 
 /* ------------------------------------------------------------------ */
 
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 8253f79..7bb1d5d 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -61,7 +61,7 @@ MODULE_PARM_DESC(radio_nr, "Radio device number");
 /* TEA5757 pin mappings */
 static const int clk = 1, data = 2, wren = 4, mo_st = 8, power = 16;
 
-static atomic_t maxiradio_instance = ATOMIC_INIT(0);
+static atomic_wrap_t maxiradio_instance = ATOMIC_INIT(0);
 
 #define PCI_VENDOR_ID_GUILLEMOT 0x5046
 #define PCI_DEVICE_ID_GUILLEMOT_MAXIRADIO 0x1001
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 85667a9..084d94d 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -79,7 +79,7 @@ struct shark_device {
 	u32 last_val;
 };
 
-static atomic_t shark_instance = ATOMIC_INIT(0);
+static atomic_wrap_t shark_instance = ATOMIC_INIT(0);
 
 static void shark_write_val(struct snd_tea575x *tea, u32 val)
 {
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 0e65a85..c0a5d51 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -74,7 +74,7 @@ struct shark_device {
 	u8 *transfer_buffer;
 };
 
-static atomic_t shark_instance = ATOMIC_INIT(0);
+static atomic_wrap_t shark_instance = ATOMIC_INIT(0);
 
 static int shark_write_reg(struct radio_tea5777 *tea, u64 reg)
 {
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index 271f725..04a552b 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -1445,7 +1445,7 @@ static int si476x_radio_probe(struct platform_device *pdev)
 	struct si476x_radio *radio;
 	struct v4l2_ctrl *ctrl;
 
-	static atomic_t instance = ATOMIC_INIT(0);
+	static atomic_wrap_t instance = ATOMIC_INIT(0);
 
 	radio = devm_kzalloc(&pdev->dev, sizeof(*radio), GFP_KERNEL);
 	if (!radio)
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 62bbed7..c77eef5 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -74,9 +74,9 @@ int v4l2_device_put(struct v4l2_device *v4l2_dev)
 EXPORT_SYMBOL_GPL(v4l2_device_put);
 
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
-						atomic_t *instance)
+						atomic_wrap_t *instance)
 {
-	int num = atomic_inc_return(instance) - 1;
+	int num = atomic_inc_return_wrap(instance) - 1;
 	int len = strlen(basename);
 
 	if (basename[len - 1] >= '0' && basename[len - 1] <= '9')
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index fb8705f..5d13db8 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -497,7 +497,7 @@ static irqreturn_t lis302dl_interrupt(int irq, void *data)
 	 * the lid is closed. This leads to interrupts as soon as a little move
 	 * is done.
 	 */
-	atomic_inc(&lis3->count);
+	atomic_inc_wrap(&lis3->count);
 
 	wake_up_interruptible(&lis3->misc_wait);
 	kill_fasync(&lis3->async_queue, SIGIO, POLL_IN);
@@ -583,7 +583,7 @@ static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
 	if (lis3->pm_dev)
 		pm_runtime_get_sync(lis3->pm_dev);
 
-	atomic_set(&lis3->count, 0);
+	atomic_set_wrap(&lis3->count, 0);
 	return 0;
 }
 
@@ -615,7 +615,7 @@ static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf,
 	add_wait_queue(&lis3->misc_wait, &wait);
 	while (true) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		data = atomic_xchg(&lis3->count, 0);
+		data = atomic_xchg_wrap(&lis3->count, 0);
 		if (data)
 			break;
 
@@ -656,7 +656,7 @@ static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table *wait)
 					      struct lis3lv02d, miscdev);
 
 	poll_wait(file, &lis3->misc_wait, wait);
-	if (atomic_read(&lis3->count))
+	if (atomic_read_wrap(&lis3->count))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.h b/drivers/misc/lis3lv02d/lis3lv02d.h
index c439c82..a77faee 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.h
+++ b/drivers/misc/lis3lv02d/lis3lv02d.h
@@ -297,7 +297,7 @@ struct lis3lv02d {
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	struct regulator_bulk_data regulators[2];
-	atomic_t		count;     /* interrupt count after last read */
+	atomic_wrap_t	count;     /* interrupt count after last read */
 	union axis_conversion	ac;        /* hw -> logical axis */
 	int			mapped_btns[3];
 
diff --git a/drivers/misc/sgi-gru/gruhandles.c b/drivers/misc/sgi-gru/gruhandles.c
index 1ee8e82..435cb49 100644
--- a/drivers/misc/sgi-gru/gruhandles.c
+++ b/drivers/misc/sgi-gru/gruhandles.c
@@ -44,8 +44,8 @@ static void update_mcs_stats(enum mcs_op op, unsigned long clks)
 	unsigned long nsec;
 
 	nsec = CLKS2NSEC(clks);
-	atomic_long_inc(&mcs_op_statistics[op].count);
-	atomic_long_add(nsec, &mcs_op_statistics[op].total);
+	atomic_long_inc_wrap(&mcs_op_statistics[op].count);
+	atomic_long_add_wrap(nsec, &mcs_op_statistics[op].total);
 	if (mcs_op_statistics[op].max < nsec)
 		mcs_op_statistics[op].max = nsec;
 }
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 4f76359..0aef871 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -32,9 +32,9 @@
 
 #define printstat(s, f)		printstat_val(s, &gru_stats.f, #f)
 
-static void printstat_val(struct seq_file *s, atomic_long_t *v, char *id)
+static void printstat_val(struct seq_file *s, atomic_long_wrap_t *v, char *id)
 {
-	unsigned long val = atomic_long_read(v);
+	unsigned long val = atomic_long_read_wrap(v);
 
 	seq_printf(s, "%16lu %s\n", val, id);
 }
@@ -134,8 +134,8 @@ static int mcs_statistics_show(struct seq_file *s, void *p)
 
 	seq_printf(s, "%-20s%12s%12s%12s\n", "#id", "count", "aver-clks", "max-clks");
 	for (op = 0; op < mcsop_last; op++) {
-		count = atomic_long_read(&mcs_op_statistics[op].count);
-		total = atomic_long_read(&mcs_op_statistics[op].total);
+		count = atomic_long_read_wrap(&mcs_op_statistics[op].count);
+		total = atomic_long_read_wrap(&mcs_op_statistics[op].total);
 		max = mcs_op_statistics[op].max;
 		seq_printf(s, "%-20s%12ld%12ld%12ld\n", id[op], count,
 			   count ? total / count : 0, max);
diff --git a/drivers/misc/sgi-gru/grutables.h b/drivers/misc/sgi-gru/grutables.h
index 5c3ce24..56740c4 100644
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
+	atomic_long_wrap_t vdata_alloc;
+	atomic_long_wrap_t vdata_free;
+	atomic_long_wrap_t gts_alloc;
+	atomic_long_wrap_t gts_free;
+	atomic_long_wrap_t gms_alloc;
+	atomic_long_wrap_t gms_free;
+	atomic_long_wrap_t gts_double_allocate;
+	atomic_long_wrap_t assign_context;
+	atomic_long_wrap_t assign_context_failed;
+	atomic_long_wrap_t free_context;
+	atomic_long_wrap_t load_user_context;
+	atomic_long_wrap_t load_kernel_context;
+	atomic_long_wrap_t lock_kernel_context;
+	atomic_long_wrap_t unlock_kernel_context;
+	atomic_long_wrap_t steal_user_context;
+	atomic_long_wrap_t steal_kernel_context;
+	atomic_long_wrap_t steal_context_failed;
+	atomic_long_wrap_t nopfn;
+	atomic_long_wrap_t asid_new;
+	atomic_long_wrap_t asid_next;
+	atomic_long_wrap_t asid_wrap;
+	atomic_long_wrap_t asid_reuse;
+	atomic_long_wrap_t intr;
+	atomic_long_wrap_t intr_cbr;
+	atomic_long_wrap_t intr_tfh;
+	atomic_long_wrap_t intr_spurious;
+	atomic_long_wrap_t intr_mm_lock_failed;
+	atomic_long_wrap_t call_os;
+	atomic_long_wrap_t call_os_wait_queue;
+	atomic_long_wrap_t user_flush_tlb;
+	atomic_long_wrap_t user_unload_context;
+	atomic_long_wrap_t user_exception;
+	atomic_long_wrap_t set_context_option;
+	atomic_long_wrap_t check_context_retarget_intr;
+	atomic_long_wrap_t check_context_unload;
+	atomic_long_wrap_t tlb_dropin;
+	atomic_long_wrap_t tlb_preload_page;
+	atomic_long_wrap_t tlb_dropin_fail_no_asid;
+	atomic_long_wrap_t tlb_dropin_fail_upm;
+	atomic_long_wrap_t tlb_dropin_fail_invalid;
+	atomic_long_wrap_t tlb_dropin_fail_range_active;
+	atomic_long_wrap_t tlb_dropin_fail_idle;
+	atomic_long_wrap_t tlb_dropin_fail_fmm;
+	atomic_long_wrap_t tlb_dropin_fail_no_exception;
+	atomic_long_wrap_t tfh_stale_on_fault;
+	atomic_long_wrap_t mmu_invalidate_range;
+	atomic_long_wrap_t mmu_invalidate_page;
+	atomic_long_wrap_t flush_tlb;
+	atomic_long_wrap_t flush_tlb_gru;
+	atomic_long_wrap_t flush_tlb_gru_tgh;
+	atomic_long_wrap_t flush_tlb_gru_zero_asid;
+
+	atomic_long_wrap_t copy_gpa;
+	atomic_long_wrap_t read_gpa;
+
+	atomic_long_wrap_t mesq_receive;
+	atomic_long_wrap_t mesq_receive_none;
+	atomic_long_wrap_t mesq_send;
+	atomic_long_wrap_t mesq_send_failed;
+	atomic_long_wrap_t mesq_noop;
+	atomic_long_wrap_t mesq_send_unexpected_error;
+	atomic_long_wrap_t mesq_send_lb_overflow;
+	atomic_long_wrap_t mesq_send_qlimit_reached;
+	atomic_long_wrap_t mesq_send_amo_nacked;
+	atomic_long_wrap_t mesq_send_put_nacked;
+	atomic_long_wrap_t mesq_page_overflow;
+	atomic_long_wrap_t mesq_qf_locked;
+	atomic_long_wrap_t mesq_qf_noop_not_full;
+	atomic_long_wrap_t mesq_qf_switch_head_failed;
+	atomic_long_wrap_t mesq_qf_unexpected_error;
+	atomic_long_wrap_t mesq_noop_unexpected_error;
+	atomic_long_wrap_t mesq_noop_lb_overflow;
+	atomic_long_wrap_t mesq_noop_qlimit_reached;
+	atomic_long_wrap_t mesq_noop_amo_nacked;
+	atomic_long_wrap_t mesq_noop_put_nacked;
+	atomic_long_wrap_t mesq_noop_page_overflow;
 
 };
 
@@ -251,8 +251,8 @@ enum mcs_op {cchop_allocate, cchop_start, cchop_interrupt, cchop_interrupt_sync,
 	tghop_invalidate, mcsop_last};
 
 struct mcs_op_statistic {
-	atomic_long_t	count;
-	atomic_long_t	total;
+	atomic_long_wrap_t	count;
+	atomic_long_wrap_t	total;
 	unsigned long	max;
 };
 
@@ -275,7 +275,7 @@ extern struct mcs_op_statistic mcs_op_statistics[mcsop_last];
 
 #define STAT(id)	do {						\
 				if (gru_options & OPT_STATS)		\
-					atomic_long_inc(&gru_stats.id);	\
+					atomic_long_inc_wrap(&gru_stats.id); \
 			} while (0)
 
 #ifdef CONFIG_SGI_GRU_DEBUG
diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index f4fbcb5..4edfb71 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -160,7 +160,7 @@ struct rndis_device {
 
 	enum rndis_device_state state;
 	bool link_state;
-	atomic_t new_req_id;
+	atomic_wrap_t new_req_id;
 
 	spinlock_t request_lock;
 	struct list_head req_list;
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9195d5d..5abf832c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -101,7 +101,7 @@ static struct rndis_request *get_rndis_request(struct rndis_device *dev,
 	 * template
 	 */
 	set = &rndis_msg->msg.set_req;
-	set->req_id = atomic_inc_return(&dev->new_req_id);
+	set->req_id = atomic_inc_return_wrap(&dev->new_req_id);
 
 	/* Add to the request list */
 	spin_lock_irqsave(&dev->request_lock, flags);
@@ -881,7 +881,7 @@ static void rndis_filter_halt_device(struct rndis_device *dev)
 
 	/* Setup the rndis set */
 	halt = &request->request_msg.msg.halt_req;
-	halt->req_id = atomic_inc_return(&dev->new_req_id);
+	halt->req_id = atomic_inc_return_wrap(&dev->new_req_id);
 
 	/* Ignore return since this msg is optional. */
 	rndis_filter_send_request(dev, request);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e0341af..1d37dc1 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -208,7 +208,7 @@ struct gendisk {
 	struct kobject *slave_dir;
 
 	struct timer_rand_state *random;
-	atomic_t sync_io;		/* RAID */
+	atomic_wrap_t sync_io;		/* RAID */
 	struct disk_events *ev;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct kobject integrity_kobj;
diff --git a/include/media/v4l2-device.h b/include/media/v4l2-device.h
index 8ffa940..1fe714a 100644
--- a/include/media/v4l2-device.h
+++ b/include/media/v4l2-device.h
@@ -139,7 +139,7 @@ int __must_check v4l2_device_register(struct device *dev,
  * then the name will be set to cx18-0 since cx180 would look really odd.
  */
 int v4l2_device_set_name(struct v4l2_device *v4l2_dev, const char *basename,
-			 atomic_t *instance);
+			 atomic_wrap_t *instance);
 
 /**
  * v4l2_device_disconnect - Change V4L2 device state to disconnected.
-- 
2.7.4
