Reply-To: kernel-hardening@lists.openwall.com
From: David Windsor <dwindsor@gmail.com>
Date: Sat, 29 Oct 2016 12:19:53 -0400
Message-Id: <1477757996-22468-3-git-send-email-dwindsor@gmail.com>
In-Reply-To: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
References: <1477757996-22468-1-git-send-email-dwindsor@gmail.com>
Subject: [kernel-hardening][RFC PATCH 2/5] tty: add overflow protection to struct tty_port.count
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, elena.reshetova@intel.com, ishkamiel@gmail.com, takahiro.akashi@linaro.org, colin@cvidal.org, dwindsor@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

Change type of struct struct tty_port.count to atomic_t.  This enables
overflow protection: when CONFIG_HARDENED_ATOMIC is enabled, atomic_t
variables cannot be overflowed.

The copyright for the original PAX_REFCOUNT code:
  - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
  - various false positive fixes: Mathias Krause <minipli@googlemail.com>
---
 arch/um/drivers/line.c                 |  2 +-
 drivers/char/pcmcia/synclink_cs.c      | 16 ++++++++--------
 drivers/isdn/gigaset/interface.c       |  8 ++++----
 drivers/isdn/i4l/isdn_tty.c            | 22 +++++++++++-----------
 drivers/net/usb/hso.c                  | 22 +++++++++++-----------
 drivers/s390/char/tty3270.c            |  2 +-
 drivers/staging/gdm724x/gdm_tty.c      |  2 +-
 drivers/tty/amiserial.c                |  4 ++--
 drivers/tty/bfin_jtag_comm.c           |  4 ++--
 drivers/tty/cyclades.c                 |  8 ++++----
 drivers/tty/hvc/hvc_console.c          | 14 +++++++-------
 drivers/tty/hvc/hvcs.c                 | 20 ++++++++++----------
 drivers/tty/hvc/hvsi.c                 | 10 +++++-----
 drivers/tty/ipwireless/tty.c           | 26 +++++++++++++-------------
 drivers/tty/moxa.c                     |  2 +-
 drivers/tty/n_gsm.c                    |  2 +-
 drivers/tty/rocket.c                   |  8 ++++----
 drivers/tty/serial/crisv10.c           | 34 +++++++++++++++++-----------------
 drivers/tty/serial/serial_core.c       |  4 ++--
 drivers/tty/synclink.c                 | 32 ++++++++++++++++----------------
 drivers/tty/synclink_gt.c              | 28 ++++++++++++++--------------
 drivers/tty/synclinkmp.c               | 34 +++++++++++++++++-----------------
 drivers/tty/tty_port.c                 | 22 +++++++++++-----------
 drivers/usb/gadget/function/u_serial.c | 22 +++++++++++-----------
 drivers/usb/serial/console.c           |  6 +++---
 include/linux/tty.h                    |  4 ++--
 net/bluetooth/rfcomm/tty.c             |  4 ++--
 net/irda/ircomm/ircomm_tty.c           | 18 +++++++++---------
 28 files changed, 190 insertions(+), 190 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 6208702..00292c8 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -377,7 +377,7 @@ int setup_one_line(struct line *lines, int n, char *init,
 	struct tty_driver *driver = line->driver->driver;
 	int err = -EINVAL;
 
-	if (line->port.count) {
+	if (atomic_read(&line->port.count)) {
 		*error_out = "Device is already open";
 		goto out;
 	}
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index d28922d..3c343d6 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2333,7 +2333,7 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) entry, count=%d\n",
-			 __FILE__, __LINE__, info->device_name, port->count);
+			 __FILE__, __LINE__, info->device_name, atomic_read(&port->count));
 
 	if (tty_port_close_start(port, tty, filp) == 0)
 		goto cleanup;
@@ -2351,7 +2351,7 @@ static void mgslpc_close(struct tty_struct *tty, struct file * filp)
 cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_close(%s) exit, count=%d\n", __FILE__, __LINE__,
-			tty->driver->name, port->count);
+			tty->driver->name, atomic_read(&port->count));
 }
 
 /* Wait until the transmitter is empty.
@@ -2493,7 +2493,7 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_open(%s), old ref count = %d\n",
-			 __FILE__, __LINE__, tty->driver->name, port->count);
+			 __FILE__, __LINE__, tty->driver->name, atomic_read(&port->count));
 
 	port->low_latency = (port->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
@@ -2504,11 +2504,11 @@ static int mgslpc_open(struct tty_struct *tty, struct file * filp)
 		goto cleanup;
 	}
 	spin_lock(&port->lock);
-	port->count++;
+	atomic_inc(&port->count);
 	spin_unlock(&port->lock);
 	spin_unlock_irqrestore(&info->netlock, flags);
 
-	if (port->count == 1) {
+	if (atomic_read(&port->count) == 1) {
 		/* 1st open on this device, init hardware */
 		retval = startup(info, tty);
 		if (retval < 0)
@@ -3897,7 +3897,7 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 	unsigned short new_crctype;
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	switch (encoding)
@@ -4001,7 +4001,7 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* arbitrate between network and tty opens */
 	spin_lock_irqsave(&info->netlock, flags);
-	if (info->port.count != 0 || info->netcount != 0) {
+	if (atomic_read(&info->port.count) != 0 || info->netcount != 0) {
 		printk(KERN_WARNING "%s: hdlc_open returning busy\n", dev->name);
 		spin_unlock_irqrestore(&info->netlock, flags);
 		return -EBUSY;
@@ -4091,7 +4091,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		printk("%s:hdlcdev_ioctl(%s)\n", __FILE__, dev->name);
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	if (cmd != SIOCWANDEV)
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 600c79b..3752bab 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -130,9 +130,9 @@ static int if_open(struct tty_struct *tty, struct file *filp)
 	}
 	tty->driver_data = cs;
 
-	++cs->port.count;
+	atomic_inc(&cs->port.count);
 
-	if (cs->port.count == 1) {
+	if (atomic_read(&cs->port.count) == 1) {
 		tty_port_tty_set(&cs->port, tty);
 		cs->port.low_latency = 1;
 	}
@@ -156,9 +156,9 @@ static void if_close(struct tty_struct *tty, struct file *filp)
 
 	if (!cs->connected)
 		gig_dbg(DEBUG_IF, "not connected");	/* nothing to do */
-	else if (!cs->port.count)
+	else if (!atomic_read(&cs->port.count))
 		dev_warn(cs->dev, "%s: device not opened\n", __func__);
-	else if (!--cs->port.count)
+	else if (!atomic_dec_return(&cs->port.count))
 		tty_port_tty_set(&cs->port, NULL);
 
 	mutex_unlock(&cs->mutex);
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 63eaa0a..00a663c 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1499,9 +1499,9 @@ isdn_tty_open(struct tty_struct *tty, struct file *filp)
 
 #ifdef ISDN_DEBUG_MODEM_OPEN
 	printk(KERN_DEBUG "isdn_tty_open %s, count = %d\n", tty->name,
-	       port->count);
+	       atomic_read(&port->count));
 #endif
-	port->count++;
+	atomic_inc(&port->count);
 	port->tty = tty;
 	/*
 	 * Start up serial port
@@ -1545,7 +1545,7 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 #endif
 		return;
 	}
-	if ((tty->count == 1) && (port->count != 1)) {
+	if ((tty->count == 1) && (atomic_read(&port->count) != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -1554,15 +1554,15 @@ isdn_tty_close(struct tty_struct *tty, struct file *filp)
 		 * serial port won't be shutdown.
 		 */
 		printk(KERN_ERR "isdn_tty_close: bad port count; tty->count is 1, "
-		       "info->count is %d\n", port->count);
-		port->count = 1;
+		       "info->count is %d\n", atomic_read(&port->count));
+		atomic_set(&port->count, 1);
 	}
-	if (--port->count < 0) {
+	if (atomic_dec_return(&port->count) < 0) {
 		printk(KERN_ERR "isdn_tty_close: bad port count for ttyi%d: %d\n",
-		       info->line, port->count);
-		port->count = 0;
+		       info->line, atomic_read(&port->count));
+		atomic_set(&port->count, 0);
 	}
-	if (port->count) {
+	if (atomic_read(&port->count)) {
 #ifdef ISDN_DEBUG_MODEM_OPEN
 		printk(KERN_DEBUG "isdn_tty_close after info->count != 0\n");
 #endif
@@ -1617,7 +1617,7 @@ isdn_tty_hangup(struct tty_struct *tty)
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_hangup"))
 		return;
 	isdn_tty_shutdown(info);
-	port->count = 0;
+	atomic_set(&port->count, 0);
 	tty_port_set_active(port, 0);
 	port->tty = NULL;
 	wake_up_interruptible(&port->open_wait);
@@ -1962,7 +1962,7 @@ isdn_tty_find_icall(int di, int ch, setup_parm *setup)
 	for (i = 0; i < ISDN_MAX_CHANNELS; i++) {
 		modem_info *info = &dev->mdm.info[i];
 
-		if (info->port.count == 0)
+		if (atomic_read(&info->port.count) == 0)
 			continue;
 		if ((info->emu.mdmreg[REG_SI1] & si2bit[si1]) &&  /* SI1 is matching */
 		    (info->emu.mdmreg[REG_SI2] == si2))	{         /* SI2 is matching */
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index e7b5163..25e095a 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1175,7 +1175,7 @@ static void put_rxbuf_data_and_resubmit_ctrl_urb(struct hso_serial *serial)
 	struct urb *urb;
 
 	urb = serial->rx_urb[0];
-	if (serial->port.count > 0) {
+	if (atomic_read(&serial->port.count) > 0) {
 		count = put_rxbuf_data(urb, serial);
 		if (count == -1)
 			return;
@@ -1213,7 +1213,7 @@ static void hso_std_serial_read_bulk_callback(struct urb *urb)
 	DUMP1(urb->transfer_buffer, urb->actual_length);
 
 	/* Anyone listening? */
-	if (serial->port.count == 0)
+	if (atomic_read(&serial->port.count) == 0)
 		return;
 
 	if (serial->parent->port_spec & HSO_INFO_CRC_BUG)
@@ -1274,8 +1274,8 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 	tty_port_tty_set(&serial->port, tty);
 
 	/* check for port already opened, if not set the termios */
-	serial->port.count++;
-	if (serial->port.count == 1) {
+	atomic_inc(&serial->port.count);
+	if (atomic_read(&serial->port.count) == 1) {
 		serial->rx_state = RX_IDLE;
 		/* Force default termio settings */
 		_hso_serial_set_termios(tty, NULL);
@@ -1285,7 +1285,7 @@ static int hso_serial_open(struct tty_struct *tty, struct file *filp)
 		result = hso_start_serial_device(serial->parent, GFP_KERNEL);
 		if (result) {
 			hso_stop_serial_device(serial->parent);
-			serial->port.count--;
+			atomic_dec(&serial->port.count);
 		} else {
 			kref_get(&serial->parent->ref);
 		}
@@ -1323,10 +1323,10 @@ static void hso_serial_close(struct tty_struct *tty, struct file *filp)
 
 	/* reset the rts and dtr */
 	/* do the actual close */
-	serial->port.count--;
+	atomic_dec(&serial->port.count);
 
-	if (serial->port.count <= 0) {
-		serial->port.count = 0;
+	if (atomic_read(&serial->port.count) <= 0) {
+		atomic_read(&serial->port.count) = 0;
 		tty_port_tty_set(&serial->port, NULL);
 		if (!usb_gone)
 			hso_stop_serial_device(serial->parent);
@@ -1409,7 +1409,7 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	/* the actual setup */
 	spin_lock_irqsave(&serial->serial_lock, flags);
-	if (serial->port.count)
+	if (atomic_read(&serial->port.count))
 		_hso_serial_set_termios(tty, old);
 	else
 		tty->termios = *old;
@@ -1884,7 +1884,7 @@ static void intr_callback(struct urb *urb)
 					i);
 				spin_lock(&serial->serial_lock);
 				if (serial->rx_state == RX_IDLE &&
-					serial->port.count > 0) {
+					atomic_read(&serial->port.count) > 0) {
 					/* Setup and send a ctrl req read on
 					 * port i */
 					if (!serial->rx_urb_filled[0]) {
@@ -3041,7 +3041,7 @@ static int hso_resume(struct usb_interface *iface)
 	/* Start all serial ports */
 	for (i = 0; i < HSO_SERIAL_TTY_MINORS; i++) {
 		if (serial_table[i] && (serial_table[i]->interface == iface)) {
-			if (dev2ser(serial_table[i])->port.count) {
+			if (atomic_read(&dev2ser(serial_table[i])->port.count)) {
 				result =
 				    hso_start_serial_device(serial_table[i], GFP_NOIO);
 				hso_kick_transmit(dev2ser(serial_table[i]));
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index 272cb6c..43eaab9 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -1035,7 +1035,7 @@ tty3270_open(struct tty_struct *tty, struct file *filp)
 	struct tty3270 *tp = tty->driver_data;
 	struct tty_port *port = &tp->port;
 
-	port->count++;
+	atomic_inc(&port->count);
 	tty_port_tty_set(port, tty);
 	return 0;
 }
diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index ae39663..a288273 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -44,7 +44,7 @@
 #define gdm_tty_send_control(n, r, v, d, l) (\
 	n->tty_dev->send_control(n->tty_dev->priv_dev, r, v, d, l))
 
-#define GDM_TTY_READY(gdm) (gdm && gdm->tty_dev && gdm->port.count)
+#define GDM_TTY_READY(gdm) (gdm && gdm->tty_dev && atomic_read(&gdm->port.count))
 
 static struct tty_driver *gdm_driver[TTY_MAX_COUNT];
 static struct gdm *gdm_table[TTY_MAX_COUNT][GDM_TTY_MINOR];
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 208f573..32c03b7 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1489,7 +1489,7 @@ static void rs_hangup(struct tty_struct *tty)
 
 	rs_flush_buffer(tty);
 	shutdown(tty, info);
-	info->tport.count = 0;
+	atomic_set(&info->tport.count, 0);
 	tty_port_set_active(&info->tport, 0);
 	info->tport.tty = NULL;
 	wake_up_interruptible(&info->tport.open_wait);
@@ -1507,7 +1507,7 @@ static int rs_open(struct tty_struct *tty, struct file * filp)
 	struct tty_port *port = &info->tport;
 	int retval;
 
-	port->count++;
+	atomic_inc(&port->count);
 	port->tty = tty;
 	tty->driver_data = info;
 	tty->port = port;
diff --git a/drivers/tty/bfin_jtag_comm.c b/drivers/tty/bfin_jtag_comm.c
index ce24182..5c0069e 100644
--- a/drivers/tty/bfin_jtag_comm.c
+++ b/drivers/tty/bfin_jtag_comm.c
@@ -143,7 +143,7 @@ bfin_jc_open(struct tty_struct *tty, struct file *filp)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port.lock, flags);
-	port.count++;
+	atomic_inc(&port.count);
 	spin_unlock_irqrestore(&port.lock, flags);
 	tty_port_tty_set(&port, tty);
 	wake_up_process(bfin_jc_kthread);
@@ -157,7 +157,7 @@ bfin_jc_close(struct tty_struct *tty, struct file *filp)
 	bool last;
 
 	spin_lock_irqsave(&port.lock, flags);
-	last = --port.count == 0;
+	last = atomic_dec_return(&port.count) == 0;
 	spin_unlock_irqrestore(&port.lock, flags);
 	if (last)
 		tty_port_tty_set(&port, NULL);
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index 5e4fa92..4a5b883 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1566,12 +1566,12 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 
 #ifdef CY_DEBUG_OPEN
 	printk(KERN_DEBUG "cyc:cy_open ttyC%d, count = %d\n", info->line,
-			info->port.count);
+			atomic_read(&info->port.count));
 #endif
-	info->port.count++;
+	atomic_inc(&info->port.count);
 #ifdef CY_DEBUG_COUNT
 	printk(KERN_DEBUG "cyc:cy_open (%d): incrementing count to %d\n",
-		current->pid, info->port.count);
+		current->pid, atomic_read(&info->port.count));
 #endif
 
 	/*
@@ -3947,7 +3947,7 @@ static int cyclades_proc_show(struct seq_file *m, void *v)
 		for (j = 0; j < cy_card[i].nports; j++) {
 			info = &cy_card[i].ports[j];
 
-			if (info->port.count) {
+			if (atomic_read(&info->port.count)) {
 				/* XXX is the ldisc num worth this? */
 				struct tty_struct *tty;
 				struct tty_ldisc *ld;
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index ce86487..b5d085f 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -343,7 +343,7 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 
 	spin_lock_irqsave(&hp->port.lock, flags);
 	/* Check and then increment for fast path open. */
-	if (hp->port.count++ > 0) {
+	if (atomic_inc_return(&hp->port.count) > 0) {
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 		hvc_kick();
 		return 0;
@@ -398,7 +398,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 
 	spin_lock_irqsave(&hp->port.lock, flags);
 
-	if (--hp->port.count == 0) {
+	if (atomic_dec_return(&hp->port.count) == 0) {
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 		/* We are done with the tty pointer now. */
 		tty_port_tty_set(&hp->port, NULL);
@@ -420,9 +420,9 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
 	} else {
-		if (hp->port.count < 0)
+		if (atomic_read(&hp->port.count) < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
-				hp->vtermno, hp->port.count);
+				hp->vtermno, atomic_read(&hp->port.count));
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 	}
 }
@@ -452,12 +452,12 @@ static void hvc_hangup(struct tty_struct *tty)
 	 * open->hangup case this can be called after the final close so prevent
 	 * that from happening for now.
 	 */
-	if (hp->port.count <= 0) {
+	if (atomic_read(&hp->port.count) <= 0) {
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 		return;
 	}
 
-	hp->port.count = 0;
+	atomic_set(&hp->port.count, 0);
 	spin_unlock_irqrestore(&hp->port.lock, flags);
 	tty_port_tty_set(&hp->port, NULL);
 
@@ -505,7 +505,7 @@ static int hvc_write(struct tty_struct *tty, const unsigned char *buf, int count
 		return -EPIPE;
 
 	/* FIXME what's this (unprotected) check for? */
-	if (hp->port.count <= 0)
+	if (atomic_read(&hp->port.count) <= 0)
 		return -EIO;
 
 	spin_lock_irqsave(&hp->lock, flags);
diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index 3c4d7c2..5249438 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -416,7 +416,7 @@ static ssize_t hvcs_vterm_state_store(struct device *dev, struct device_attribut
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
 
-	if (hvcsd->port.count > 0) {
+	if (atomic_read(&hvcsd->port.count) > 0) {
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
 		printk(KERN_INFO "HVCS: vterm state unchanged.  "
 				"The hvcs device node is still in use.\n");
@@ -1127,7 +1127,7 @@ static int hvcs_install(struct tty_driver *driver, struct tty_struct *tty)
 		}
 	}
 
-	hvcsd->port.count = 0;
+	atomic_set(&hvcsd->port.count, 0);
 	hvcsd->port.tty = tty;
 	tty->driver_data = hvcsd;
 
@@ -1180,7 +1180,7 @@ static int hvcs_open(struct tty_struct *tty, struct file *filp)
 	unsigned long flags;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	hvcsd->port.count++;
+	atomic_inc(&hvcsd->port.count);
 	hvcsd->todo_mask |= HVCS_SCHED_READ;
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
 
@@ -1216,7 +1216,7 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 	hvcsd = tty->driver_data;
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
-	if (--hvcsd->port.count == 0) {
+	if (atomic_dec_and_test(&hvcsd->port.count)) {
 
 		vio_disable_interrupts(hvcsd->vdev);
 
@@ -1241,10 +1241,10 @@ static void hvcs_close(struct tty_struct *tty, struct file *filp)
 
 		free_irq(irq, hvcsd);
 		return;
-	} else if (hvcsd->port.count < 0) {
+	} else if (atomic_read(&hvcsd->port.count) < 0) {
 		printk(KERN_ERR "HVCS: vty-server@%X open_count: %d"
 				" is missmanaged.\n",
-		hvcsd->vdev->unit_address, hvcsd->port.count);
+		hvcsd->vdev->unit_address, atomic_read(&hvcsd->port.count));
 	}
 
 	spin_unlock_irqrestore(&hvcsd->lock, flags);
@@ -1266,7 +1266,7 @@ static void hvcs_hangup(struct tty_struct * tty)
 
 	spin_lock_irqsave(&hvcsd->lock, flags);
 	/* Preserve this so that we know how many kref refs to put */
-	temp_open_count = hvcsd->port.count;
+	temp_open_count = atomic_read(&hvcsd->port.count);
 
 	/*
 	 * Don't kref put inside the spinlock because the destruction
@@ -1281,7 +1281,7 @@ static void hvcs_hangup(struct tty_struct * tty)
 	tty->driver_data = NULL;
 	hvcsd->port.tty = NULL;
 
-	hvcsd->port.count = 0;
+	atomic_set(&hvcsd->port.count, 0);
 
 	/* This will drop any buffered data on the floor which is OK in a hangup
 	 * scenario. */
@@ -1352,7 +1352,7 @@ static int hvcs_write(struct tty_struct *tty,
 	 * the middle of a write operation?  This is a crummy place to do this
 	 * but we want to keep it all in the spinlock.
 	 */
-	if (hvcsd->port.count <= 0) {
+	if (atomic_read(&hvcsd->port.count) <= 0) {
 		spin_unlock_irqrestore(&hvcsd->lock, flags);
 		return -ENODEV;
 	}
@@ -1426,7 +1426,7 @@ static int hvcs_write_room(struct tty_struct *tty)
 {
 	struct hvcs_struct *hvcsd = tty->driver_data;
 
-	if (!hvcsd || hvcsd->port.count <= 0)
+	if (!hvcsd || atomic_read(&hvcsd->port.count) <= 0)
 		return 0;
 
 	return HVCS_BUFF_LEN - hvcsd->chars_in_buffer;
diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index c05b32e..670bdf9 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -727,7 +727,7 @@ static int hvsi_open(struct tty_struct *tty, struct file *filp)
 
 	tty_port_tty_set(&hp->port, tty);
 	spin_lock_irqsave(&hp->lock, flags);
-	hp->port.count++;
+	atomic_inc(&hp->port.count);
 	atomic_set(&hp->seqno, 0);
 	h_vio_signal(hp->vtermno, VIO_IRQ_ENABLE);
 	spin_unlock_irqrestore(&hp->lock, flags);
@@ -784,7 +784,7 @@ static void hvsi_close(struct tty_struct *tty, struct file *filp)
 
 	spin_lock_irqsave(&hp->lock, flags);
 
-	if (--hp->port.count == 0) {
+	if (atomic_dec_and_return(&hp->port.count) == 0) {
 		tty_port_tty_set(&hp->port, NULL);
 		hp->inbuf_end = hp->inbuf; /* discard remaining partial packets */
 
@@ -817,9 +817,9 @@ static void hvsi_close(struct tty_struct *tty, struct file *filp)
 
 			spin_lock_irqsave(&hp->lock, flags);
 		}
-	} else if (hp->port.count < 0)
+	} else if (atomic_read(&hp->port.count) < 0)
 		printk(KERN_ERR "hvsi_close %lu: oops, count is %d\n",
-		       hp - hvsi_ports, hp->port.count);
+		       hp - hvsi_ports, atomic_read(&hp->port.count));
 
 	spin_unlock_irqrestore(&hp->lock, flags);
 }
@@ -834,7 +834,7 @@ static void hvsi_hangup(struct tty_struct *tty)
 	tty_port_tty_set(&hp->port, NULL);
 
 	spin_lock_irqsave(&hp->lock, flags);
-	hp->port.count = 0;
+	atomic_sec(&hp->port.count, 0);
 	hp->n_outbuf = 0;
 	spin_unlock_irqrestore(&hp->lock, flags);
 }
diff --git a/drivers/tty/ipwireless/tty.c b/drivers/tty/ipwireless/tty.c
index 2685d59..469d71d 100644
--- a/drivers/tty/ipwireless/tty.c
+++ b/drivers/tty/ipwireless/tty.c
@@ -93,10 +93,10 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 		return -ENODEV;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	if (tty->port.count == 0)
+	if (atomic_read(&tty->port.count) == 0)
 		tty->tx_bytes_queued = 0;
 
-	tty->port.count++;
+	atomic_inc(&tty->port.count);
 
 	tty->port.tty = linux_tty;
 	linux_tty->driver_data = tty;
@@ -112,9 +112,9 @@ static int ipw_open(struct tty_struct *linux_tty, struct file *filp)
 
 static void do_ipw_close(struct ipw_tty *tty)
 {
-	tty->port.count--;
+	atomic_dec(&tty->port.count);
 
-	if (tty->port.count == 0) {
+	if (atomic_read(&tty->port.count) == 0) {
 		struct tty_struct *linux_tty = tty->port.tty;
 
 		if (linux_tty != NULL) {
@@ -135,7 +135,7 @@ static void ipw_hangup(struct tty_struct *linux_tty)
 		return;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	if (tty->port.count == 0) {
+	if (atomic_read(&tty->port.count) == 0) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return;
 	}
@@ -158,7 +158,7 @@ void ipwireless_tty_received(struct ipw_tty *tty, unsigned char *data,
 
 	mutex_lock(&tty->ipw_tty_mutex);
 
-	if (!tty->port.count) {
+	if (!atomic_read(&tty->port.count)) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return;
 	}
@@ -197,7 +197,7 @@ static int ipw_write(struct tty_struct *linux_tty,
 		return -ENODEV;
 
 	mutex_lock(&tty->ipw_tty_mutex);
-	if (!tty->port.count) {
+	if (!atomic_read(&tty->port.count)) {
 		mutex_unlock(&tty->ipw_tty_mutex);
 		return -EINVAL;
 	}
@@ -237,7 +237,7 @@ static int ipw_write_room(struct tty_struct *linux_tty)
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->port.count)
+	if (!atomic_read(&tty->port.count))
 		return -EINVAL;
 
 	room = IPWIRELESS_TX_QUEUE_SIZE - tty->tx_bytes_queued;
@@ -270,7 +270,7 @@ static int ipw_chars_in_buffer(struct tty_struct *linux_tty)
 	if (!tty)
 		return 0;
 
-	if (!tty->port.count)
+	if (!atomic_read(&tty->port.count))
 		return 0;
 
 	return tty->tx_bytes_queued;
@@ -351,7 +351,7 @@ static int ipw_tiocmget(struct tty_struct *linux_tty)
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->port.count)
+	if (!atomic_read(&tty->port.count))
 		return -EINVAL;
 
 	return get_control_lines(tty);
@@ -367,7 +367,7 @@ ipw_tiocmset(struct tty_struct *linux_tty,
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->port.count)
+	if (!atomic_read(&tty->port.count))
 		return -EINVAL;
 
 	return set_control_lines(tty, set, clear);
@@ -381,7 +381,7 @@ static int ipw_ioctl(struct tty_struct *linux_tty,
 	if (!tty)
 		return -ENODEV;
 
-	if (!tty->port.count)
+	if (!atomic_read(&tty->port.count))
 		return -EINVAL;
 
 	/* FIXME: Exactly how is the tty object locked here .. */
@@ -537,7 +537,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 				 * are gone */
 				mutex_lock(&ttyj->ipw_tty_mutex);
 			}
-			while (ttyj->port.count)
+			while (atomic_read(&ttyj->port.count))
 				do_ipw_close(ttyj);
 			ipwireless_disassociate_network_ttys(network,
 							     ttyj->channel_idx);
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 60d37b2..3d222ca 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1188,7 +1188,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	}
 
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
-	ch->port.count++;
+	atomic_inc(&ch->port.count);
 	tty->driver_data = ch;
 	tty_port_tty_set(&ch->port, tty);
 	mutex_lock(&ch->port.mutex);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 54cab59..83560c9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2943,7 +2943,7 @@ static int gsmtty_open(struct tty_struct *tty, struct file *filp)
 	struct gsm_dlci *dlci = tty->driver_data;
 	struct tty_port *port = &dlci->port;
 
-	port->count++;
+	atomic_inc(&port->count);
 	tty_port_tty_set(port, tty);
 
 	dlci->modem_rx = 0;
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index b0cc47c..daeb183 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -906,7 +906,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = info;
 	tty_port_tty_set(port, tty);
 
-	if (port->count++ == 0) {
+	if (atomic_inc_return(&port->count) == 1) {
 		atomic_inc(&rp_num_ports_open);
 
 #ifdef ROCKET_DEBUG_OPEN
@@ -915,7 +915,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 #endif
 	}
 #ifdef ROCKET_DEBUG_OPEN
-	printk(KERN_INFO "rp_open ttyR%d, count=%d\n", info->line, info->port.count);
+	printk(KERN_INFO "rp_open ttyR%d, count=%d\n", info->line, atomic_read(&info->port.count));
 #endif
 
 	/*
@@ -992,7 +992,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 		return;
 
 #ifdef ROCKET_DEBUG_OPEN
-	printk(KERN_INFO "rp_close ttyR%d, count = %d\n", info->line, info->port.count);
+	printk(KERN_INFO "rp_close ttyR%d, count = %d\n", info->line, atomic_read(&info->port.count));
 #endif
 
 	if (tty_port_close_start(port, tty, filp) == 0)
@@ -1500,7 +1500,7 @@ static void rp_hangup(struct tty_struct *tty)
 #endif
 	rp_flush_buffer(tty);
 	spin_lock_irqsave(&info->port.lock, flags);
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		atomic_dec(&rp_num_ports_open);
 	clear_bit((info->aiop * 8) + info->chan, (void *) &xmit_flags[info->board]);
 	spin_unlock_irqrestore(&info->port.lock, flags);
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 315c849..3053ec3 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3255,7 +3255,7 @@ set_serial_info(struct e100_serial *info,
 		goto check_and_exit;
 	}
 
-	if (info->port.count > 1)
+	if (atomic_read(&info->port.count) > 1)
 		return -EBUSY;
 
 	/*
@@ -3588,7 +3588,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	printk("[%d] rs_close ttyS%d, count = %d\n", current->pid,
 	       info->line, info->count);
 #endif
-	if ((tty->count == 1) && (info->port.count != 1)) {
+	if ((tty->count == 1) && (atomic_read(&info->port.count) != 1)) {
 		/*
 		 * Uh, oh.  tty->count is 1, which means that the tty
 		 * structure will be freed.  Info->count should always
@@ -3598,15 +3598,15 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		 */
 		printk(KERN_ERR
 		       "rs_close: bad serial port count; tty->count is 1, "
-		       "info->count is %d\n", info->port.count);
-		info->port.count = 1;
+		       "info->count is %d\n", atomic_read(&info->port.count));
+		atomic_set(&info->port.count, 1);
 	}
-	if (--info->port.count < 0) {
+	if (atomic_dec_return(&info->port.count) < 0) {
 		printk(KERN_ERR "rs_close: bad serial port count for ttyS%d: %d\n",
-		       info->line, info->port.count);
-		info->port.count = 0;
+		       info->line, atomic_read(&info->port.count));
+		atomic_set(&info->port.count, 0);
 	}
-	if (info->port.count) {
+	if (atomic_read(&info->port.count)) {
 		local_irq_restore(flags);
 		return;
 	}
@@ -3731,7 +3731,7 @@ rs_hangup(struct tty_struct *tty)
 	rs_flush_buffer(tty);
 	shutdown(info);
 	info->event = 0;
-	info->port.count = 0;
+	atomic_set(&info->port.count, 0);
 	tty_port_set_active(&info->port, 0);
 	info->port.tty = NULL;
 	wake_up_interruptible(&info->port.open_wait);
@@ -3774,10 +3774,10 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	add_wait_queue(&info->port.open_wait, &wait);
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready before block: ttyS%d, count = %d\n",
-	       info->line, info->port.count);
+	       info->line, atomic_read(&info->port.count));
 #endif
 	local_irq_save(flags);
-	info->port.count--;
+	atomic_dec(&info->port.count);
 	local_irq_restore(flags);
 	info->port.blocked_open++;
 	while (1) {
@@ -3807,7 +3807,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		}
 #ifdef SERIAL_DEBUG_OPEN
 		printk("block_til_ready blocking: ttyS%d, count = %d\n",
-		       info->line, info->port.count);
+		       info->line, atomic_read(&info->port.count));
 #endif
 		tty_unlock(tty);
 		schedule();
@@ -3816,11 +3816,11 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&info->port.open_wait, &wait);
 	if (!tty_hung_up_p(filp))
-		info->port.count++;
+		atomic_inc(&info->port.count);
 	info->port.blocked_open--;
 #ifdef SERIAL_DEBUG_OPEN
 	printk("block_til_ready after blocking: ttyS%d, count = %d\n",
-	       info->line, info->port.count);
+	       info->line, atomic_inc(&info->port.count));
 #endif
 	if (retval)
 		return retval;
@@ -3858,10 +3858,10 @@ rs_open(struct tty_struct *tty, struct file * filp)
 
 #ifdef SERIAL_DEBUG_OPEN
         printk("[%d] rs_open %s, count = %d\n", current->pid, tty->name,
- 	       info->port.count);
+ 	       atomic_read(&info->port.count));
 #endif
 
-	info->port.count++;
+	atomic_inc(&info->port.count);
 	tty->driver_data = info;
 	info->port.tty = tty;
 
@@ -3870,7 +3870,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	/*
 	 * If DMA is enabled try to allocate the irq's.
 	 */
-	if (info->port.count == 1) {
+	if (atomic_read(&info->port.count) == 1) {
 		allocated_resources = 1;
 		if (info->dma_in_enabled) {
 			if (request_irq(info->dma_in_irq_nbr,
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6e4f636..2f70dc0 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1468,7 +1468,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 		state = drv->state + tty->index;
 		port = &state->port;
 		spin_lock_irq(&port->lock);
-		--port->count;
+		atomic_dec(&port->count);
 		spin_unlock_irq(&port->lock);
 		return;
 	}
@@ -1589,7 +1589,7 @@ static void uart_hangup(struct tty_struct *tty)
 		uart_flush_buffer(tty);
 		uart_shutdown(tty, state);
 		spin_lock_irqsave(&port->lock, flags);
-		port->count = 0;
+		atomic_set(&port->count, 0);
 		spin_unlock_irqrestore(&port->lock, flags);
 		tty_port_set_active(port, 0);
 		tty_port_tty_set(port, NULL);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index c13e27e..d61d064 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -3075,7 +3075,7 @@ static void mgsl_close(struct tty_struct *tty, struct file * filp)
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_close(%s) entry, count=%d\n",
-			 __FILE__,__LINE__, info->device_name, info->port.count);
+			 __FILE__,__LINE__, info->device_name, atomic_read(&info->port.count));
 
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
@@ -3093,7 +3093,7 @@ static void mgsl_close(struct tty_struct *tty, struct file * filp)
 cleanup:			
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_close(%s) exit, count=%d\n", __FILE__,__LINE__,
-			tty->driver->name, info->port.count);
+			tty->driver->name, atomic_read(&info->port.count));
 			
 }	/* end of mgsl_close() */
 
@@ -3193,7 +3193,7 @@ static void mgsl_hangup(struct tty_struct *tty)
 	mgsl_flush_buffer(tty);
 	shutdown(info);
 	
-	info->port.count = 0;	
+	atomic_set(&info->port.count, 0);	
 	tty_port_set_active(&info->port, 0);
 	info->port.tty = NULL;
 
@@ -3281,10 +3281,10 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready before block on %s count=%d\n",
-			 __FILE__,__LINE__, tty->driver->name, port->count );
+			 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 
 	spin_lock_irqsave(&info->irq_spinlock, flags);
-	port->count--;
+	atomic_dec(&port->count);
 	spin_unlock_irqrestore(&info->irq_spinlock, flags);
 	port->blocked_open++;
 
@@ -3311,7 +3311,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):block_til_ready blocking on %s count=%d\n",
-				 __FILE__,__LINE__, tty->driver->name, port->count );
+				 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 				 
 		tty_unlock(tty);
 		schedule();
@@ -3323,12 +3323,12 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	
 	/* FIXME: Racy on hangup during close wait */
 	if (!tty_hung_up_p(filp))
-		port->count++;
+		atomic_inc(&port->count);
 	port->blocked_open--;
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):block_til_ready after blocking on %s count=%d\n",
-			 __FILE__,__LINE__, tty->driver->name, port->count );
+			 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 			 
 	if (!retval)
 		tty_port_set_active(port, 1);
@@ -3380,7 +3380,7 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 		
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_open(%s), old ref count = %d\n",
-			 __FILE__,__LINE__,tty->driver->name, info->port.count);
+			 __FILE__,__LINE__,tty->driver->name, atomic_read(&info->port.count));
 
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
@@ -3390,10 +3390,10 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 		spin_unlock_irqrestore(&info->netlock, flags);
 		goto cleanup;
 	}
-	info->port.count++;
+	atomic_inc(&info->port.count);
 	spin_unlock_irqrestore(&info->netlock, flags);
 
-	if (info->port.count == 1) {
+	if (atomic_read(&info->port.count) == 1) {
 		/* 1st open on this device, init hardware */
 		retval = startup(info);
 		if (retval < 0)
@@ -3417,8 +3417,8 @@ static int mgsl_open(struct tty_struct *tty, struct file * filp)
 	if (retval) {
 		if (tty->count == 1)
 			info->port.tty = NULL; /* tty layer will release tty struct */
-		if(info->port.count)
-			info->port.count--;
+		if(atomic_read(&info->port.count))
+			atomic_dec(&info->port.count);
 	}
 	
 	return retval;
@@ -7637,7 +7637,7 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 	unsigned short new_crctype;
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	switch (encoding)
@@ -7733,7 +7733,7 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* arbitrate between network and tty opens */
 	spin_lock_irqsave(&info->netlock, flags);
-	if (info->port.count != 0 || info->netcount != 0) {
+	if (atomic_read(&info->port.count) != 0 || info->netcount != 0) {
 		printk(KERN_WARNING "%s: hdlc_open returning busy\n", dev->name);
 		spin_unlock_irqrestore(&info->netlock, flags);
 		return -EBUSY;
@@ -7819,7 +7819,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		printk("%s:hdlcdev_ioctl(%s)\n",__FILE__,dev->name);
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	if (cmd != SIOCWANDEV)
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 7aca2d4..45a7121 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -670,7 +670,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = info;
 	info->port.tty = tty;
 
-	DBGINFO(("%s open, old ref count = %d\n", info->device_name, info->port.count));
+	DBGINFO(("%s open, old ref count = %d\n", info->device_name, atomic_read(&info->port.count)));
 
 	mutex_lock(&info->port.mutex);
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
@@ -682,10 +682,10 @@ static int open(struct tty_struct *tty, struct file *filp)
 		mutex_unlock(&info->port.mutex);
 		goto cleanup;
 	}
-	info->port.count++;
+	atomic_inc(&info->port.count);
 	spin_unlock_irqrestore(&info->netlock, flags);
 
-	if (info->port.count == 1) {
+	if (atomic_read(&info->port.count) == 1) {
 		/* 1st open on this device, init hardware */
 		retval = startup(info);
 		if (retval < 0) {
@@ -706,8 +706,8 @@ static int open(struct tty_struct *tty, struct file *filp)
 	if (retval) {
 		if (tty->count == 1)
 			info->port.tty = NULL; /* tty layer will release tty struct */
-		if(info->port.count)
-			info->port.count--;
+		if(atomic_read(&info->port.count))
+			atomic_dec(&info->port.count);
 	}
 
 	DBGINFO(("%s open rc=%d\n", info->device_name, retval));
@@ -720,7 +720,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 
 	if (sanity_check(info, tty->name, "close"))
 		return;
-	DBGINFO(("%s close entry, count=%d\n", info->device_name, info->port.count));
+	DBGINFO(("%s close entry, count=%d\n", info->device_name, atomic_read(&info->port.count)));
 
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
@@ -737,7 +737,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 	tty_port_close_end(&info->port, tty);
 	info->port.tty = NULL;
 cleanup:
-	DBGINFO(("%s close exit, count=%d\n", tty->driver->name, info->port.count));
+	DBGINFO(("%s close exit, count=%d\n", tty->driver->name, atomic_read(&info->port.count)));
 }
 
 static void hangup(struct tty_struct *tty)
@@ -755,7 +755,7 @@ static void hangup(struct tty_struct *tty)
 	shutdown(info);
 
 	spin_lock_irqsave(&info->port.lock, flags);
-	info->port.count = 0;
+	atomic_set(&info->port.count, 0);
 	info->port.tty = NULL;
 	spin_unlock_irqrestore(&info->port.lock, flags);
 	tty_port_set_active(&info->port, 0);
@@ -1435,7 +1435,7 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 	unsigned short new_crctype;
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	DBGINFO(("%s hdlcdev_attach\n", info->device_name));
@@ -1531,7 +1531,7 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* arbitrate between network and tty opens */
 	spin_lock_irqsave(&info->netlock, flags);
-	if (info->port.count != 0 || info->netcount != 0) {
+	if (atomic_read(&info->port.count) != 0 || info->netcount != 0) {
 		DBGINFO(("%s hdlc_open busy\n", dev->name));
 		spin_unlock_irqrestore(&info->netlock, flags);
 		return -EBUSY;
@@ -1616,7 +1616,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	DBGINFO(("%s hdlcdev_ioctl\n", dev->name));
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	if (cmd != SIOCWANDEV)
@@ -2403,7 +2403,7 @@ static irqreturn_t slgt_interrupt(int dummy, void *dev_id)
 		if (port == NULL)
 			continue;
 		spin_lock(&port->lock);
-		if ((port->port.count || port->netcount) &&
+		if ((atomic_read(&port->port.count) || port->netcount) &&
 		    port->pending_bh && !port->bh_running &&
 		    !port->bh_requested) {
 			DBGISR(("%s bh queued\n", port->device_name));
@@ -3282,7 +3282,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	add_wait_queue(&port->open_wait, &wait);
 
 	spin_lock_irqsave(&info->lock, flags);
-	port->count--;
+	atomic_dec(&port->count);
 	spin_unlock_irqrestore(&info->lock, flags);
 	port->blocked_open++;
 
@@ -3317,7 +3317,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	remove_wait_queue(&port->open_wait, &wait);
 
 	if (!tty_hung_up_p(filp))
-		port->count++;
+		atomic_inc(&port->count);
 	port->blocked_open--;
 
 	if (!retval)
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index dec1565..bbf9fcc 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -750,7 +750,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s open(), old ref count = %d\n",
-			 __FILE__,__LINE__,tty->driver->name, info->port.count);
+			 __FILE__,__LINE__,tty->driver->name, atomic_read(&info->port.count));
 
 	info->port.low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
@@ -760,10 +760,10 @@ static int open(struct tty_struct *tty, struct file *filp)
 		spin_unlock_irqrestore(&info->netlock, flags);
 		goto cleanup;
 	}
-	info->port.count++;
+	atomic_inc(&info->port.count);
 	spin_unlock_irqrestore(&info->netlock, flags);
 
-	if (info->port.count == 1) {
+	if (atomic_read(&info->port.count) == 1) {
 		/* 1st open on this device, init hardware */
 		retval = startup(info);
 		if (retval < 0)
@@ -787,8 +787,8 @@ static int open(struct tty_struct *tty, struct file *filp)
 	if (retval) {
 		if (tty->count == 1)
 			info->port.tty = NULL; /* tty layer will release tty struct */
-		if(info->port.count)
-			info->port.count--;
+		if(atomic_read(&info->port.count))
+			atomic_dec(&info->port.count);
 	}
 
 	return retval;
@@ -806,7 +806,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s close() entry, count=%d\n",
-			 __FILE__,__LINE__, info->device_name, info->port.count);
+			 __FILE__,__LINE__, info->device_name, atomic_read(&info->port.count));
 
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
@@ -825,7 +825,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 cleanup:
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s close() exit, count=%d\n", __FILE__,__LINE__,
-			tty->driver->name, info->port.count);
+			tty->driver->name, atomic_read(&info->port.count));
 }
 
 /* Called by tty_hangup() when a hangup is signaled.
@@ -848,7 +848,7 @@ static void hangup(struct tty_struct *tty)
 	shutdown(info);
 
 	spin_lock_irqsave(&info->port.lock, flags);
-	info->port.count = 0;
+	atomic_set(&info->port.count, 0);
 	info->port.tty = NULL;
 	spin_unlock_irqrestore(&info->port.lock, flags);
 	tty_port_set_active(&info->port, 1);
@@ -1551,7 +1551,7 @@ static int hdlcdev_attach(struct net_device *dev, unsigned short encoding,
 	unsigned short new_crctype;
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	switch (encoding)
@@ -1647,7 +1647,7 @@ static int hdlcdev_open(struct net_device *dev)
 
 	/* arbitrate between network and tty opens */
 	spin_lock_irqsave(&info->netlock, flags);
-	if (info->port.count != 0 || info->netcount != 0) {
+	if (atomic_read(&info->port.count) != 0 || info->netcount != 0) {
 		printk(KERN_WARNING "%s: hdlc_open returning busy\n", dev->name);
 		spin_unlock_irqrestore(&info->netlock, flags);
 		return -EBUSY;
@@ -1733,7 +1733,7 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		printk("%s:hdlcdev_ioctl(%s)\n",__FILE__,dev->name);
 
 	/* return error if TTY interface open */
-	if (info->port.count)
+	if (atomic_read(&info->port.count))
 		return -EBUSY;
 
 	if (cmd != SIOCWANDEV)
@@ -2610,7 +2610,7 @@ static irqreturn_t synclinkmp_interrupt(int dummy, void *dev_id)
 		 * do not request bottom half processing if the
 		 * device is not open in a normal mode.
 		 */
-		if ( port && (port->port.count || port->netcount) &&
+		if ( port && (atomic_read(&port->port.count) || port->netcount) &&
 		     port->pending_bh && !port->bh_running &&
 		     !port->bh_requested ) {
 			if ( debug_level >= DEBUG_LEVEL_ISR )
@@ -3300,10 +3300,10 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s block_til_ready() before block, count=%d\n",
-			 __FILE__,__LINE__, tty->driver->name, port->count );
+			 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 
 	spin_lock_irqsave(&info->lock, flags);
-	port->count--;
+	atomic_dec(&port->count);
 	spin_unlock_irqrestore(&info->lock, flags);
 	port->blocked_open++;
 
@@ -3330,7 +3330,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 
 		if (debug_level >= DEBUG_LEVEL_INFO)
 			printk("%s(%d):%s block_til_ready() count=%d\n",
-				 __FILE__,__LINE__, tty->driver->name, port->count );
+				 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 
 		tty_unlock(tty);
 		schedule();
@@ -3340,12 +3340,12 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp))
-		port->count++;
+		atomic_inc(&port->count);
 	port->blocked_open--;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s block_til_ready() after, count=%d\n",
-			 __FILE__,__LINE__, tty->driver->name, port->count );
+			 __FILE__,__LINE__, tty->driver->name, atomic_read(&port->count));
 
 	if (!retval)
 		tty_port_set_active(port, 1);
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index c3f9d93..f81070c 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -236,7 +236,7 @@ void tty_port_hangup(struct tty_port *port)
 	unsigned long flags;
 
 	spin_lock_irqsave(&port->lock, flags);
-	port->count = 0;
+	atomic_set(&port->count, 0);
 	tty = port->tty;
 	if (tty)
 		set_bit(TTY_IO_ERROR, &tty->flags);
@@ -388,7 +388,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* The port lock protects the port counts */
 	spin_lock_irqsave(&port->lock, flags);
-	port->count--;
+	atomic_dec(&port->count);
 	port->blocked_open++;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -429,7 +429,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 	   we must not mess that up further */
 	spin_lock_irqsave(&port->lock, flags);
 	if (!tty_hung_up_p(filp))
-		port->count++;
+		atomic_inc(&port->count);
 	port->blocked_open--;
 	spin_unlock_irqrestore(&port->lock, flags);
 	if (retval == 0)
@@ -462,18 +462,18 @@ int tty_port_close_start(struct tty_port *port,
 		return 0;
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (tty->count == 1 && port->count != 1) {
+	if (tty->count == 1 && atomic_read(&port->count) != 1) {
 		tty_warn(tty, "%s: tty->count = 1 port count = %d\n", __func__,
-			 port->count);
-		port->count = 1;
+			 atomic_read(&port->count));
+		atomic_set(&port->count, 1);
 	}
-	if (--port->count < 0) {
+	if (atomic_dec_return(&port->count) < 0) {
 		tty_warn(tty, "%s: bad port count (%d)\n", __func__,
-			 port->count);
-		port->count = 0;
+			 atomic_read(&port->count));
+		atomic_set(&port->count, 0);
 	}
 
-	if (port->count) {
+	if (atomic_read(&port->count)) {
 		spin_unlock_irqrestore(&port->lock, flags);
 		return 0;
 	}
@@ -567,7 +567,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 							struct file *filp)
 {
 	spin_lock_irq(&port->lock);
-	++port->count;
+	atomic_inc(&port->count);
 	spin_unlock_irq(&port->lock);
 	tty_port_tty_set(port, tty);
 
diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
index e0cd1e4..0a41c55 100644
--- a/drivers/usb/gadget/function/u_serial.c
+++ b/drivers/usb/gadget/function/u_serial.c
@@ -752,9 +752,9 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 			spin_lock_irq(&port->port_lock);
 
 			/* already open?  Great. */
-			if (port->port.count) {
+			if (atomic_read(&port->port.count)) {
 				status = 0;
-				port->port.count++;
+				atomic_inc(&port->port.count);
 
 			/* currently opening/closing? wait ... */
 			} else if (port->openclose) {
@@ -813,7 +813,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	tty->driver_data = port;
 	port->port.tty = tty;
 
-	port->port.count = 1;
+	atomic_set(&port->port.count, 1);
 	port->openclose = false;
 
 	/* if connected, start the I/O stream */
@@ -855,11 +855,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	spin_lock_irq(&port->port_lock);
 
-	if (port->port.count != 1) {
-		if (port->port.count == 0)
+	if (atomic_read(&port->port.count) != 1) {
+		if (atomic_read(&port->port.count) == 0)
 			WARN_ON(1);
 		else
-			--port->port.count;
+			atomic_dec(&port->port.count);
 		goto exit;
 	}
 
@@ -869,7 +869,7 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 	 * and sleep if necessary
 	 */
 	port->openclose = true;
-	port->port.count = 0;
+	atomic_set(&port->port.count, 0);
 
 	gser = port->port_usb;
 	if (gser && gser->disconnect)
@@ -1324,7 +1324,7 @@ static int gs_closed(struct gs_port *port)
 	int cond;
 
 	spin_lock_irq(&port->port_lock);
-	cond = (port->port.count == 0) && !port->openclose;
+	cond = (atomic_read(&port->port.count) == 0) && !port->openclose;
 	spin_unlock_irq(&port->port_lock);
 	return cond;
 }
@@ -1469,7 +1469,7 @@ int gserial_connect(struct gserial *gser, u8 port_num)
 	/* if it's already open, start I/O ... and notify the serial
 	 * protocol about open/close status (connect/disconnect).
 	 */
-	if (port->port.count) {
+	if (atomic_read(&port->port.count)) {
 		pr_debug("gserial_connect: start ttyGS%d\n", port->port_num);
 		gs_start_io(port);
 		if (gser->connect)
@@ -1516,7 +1516,7 @@ void gserial_disconnect(struct gserial *gser)
 
 	port->port_usb = NULL;
 	gser->ioport = NULL;
-	if (port->port.count > 0 || port->openclose) {
+	if (atomic_read(&port->port.count) > 0 || port->openclose) {
 		wake_up_interruptible(&port->drain_wait);
 		if (port->port.tty)
 			tty_hangup(port->port.tty);
@@ -1529,7 +1529,7 @@ void gserial_disconnect(struct gserial *gser)
 
 	/* finally, free any unused/unusable I/O buffers */
 	spin_lock_irqsave(&port->port_lock, flags);
-	if (port->port.count == 0 && !port->openclose)
+	if (atomic_read(&port->port.count) == 0 && !port->openclose)
 		gs_buf_free(&port->port_write_buf);
 	gs_free_requests(gser->out, &port->read_pool, NULL);
 	gs_free_requests(gser->out, &port->read_queue, NULL);
diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index 8967715..071c97d 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -126,7 +126,7 @@ static int usb_console_setup(struct console *co, char *options)
 
 	info->port = port;
 
-	++port->port.count;
+	atomic_inc(&port->port.count);
 	if (!tty_port_initialized(&port->port)) {
 		if (serial->type->set_termios) {
 			/*
@@ -172,7 +172,7 @@ static int usb_console_setup(struct console *co, char *options)
 	}
 	/* Now that any required fake tty operations are completed restore
 	 * the tty port count */
-	--port->port.count;
+	atomic_dec(&port->port.count);
 	/* The console is special in terms of closing the device so
 	 * indicate this port is now acting as a system console. */
 	port->port.console = 1;
@@ -184,7 +184,7 @@ static int usb_console_setup(struct console *co, char *options)
 	tty_port_tty_set(&port->port, NULL);
 	tty_kref_put(tty);
  reset_open_count:
-	port->port.count = 0;
+	atomic_set(&port->port.count, 0);
 	usb_autopm_put_interface(serial->interface);
  error_get_interface:
 	usb_serial_put(serial);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 40144f3..16d35cf 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -225,7 +225,7 @@ struct tty_port {
 	const struct tty_port_operations *ops;	/* Port operations */
 	spinlock_t		lock;		/* Lock protecting tty field */
 	int			blocked_open;	/* Waiting to open */
-	int			count;		/* Usage count */
+	atomic_t			count;		/* Usage count */
 	wait_queue_head_t	open_wait;	/* Open waiters */
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* User TTY flags ASYNC_ */
@@ -646,7 +646,7 @@ extern int tty_port_open(struct tty_port *port,
 				struct tty_struct *tty, struct file *filp);
 static inline int tty_port_users(struct tty_port *port)
 {
-	return port->count + port->blocked_open;
+	return atomic_read(&port->count) + port->blocked_open;
 }
 
 extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 8e385a0..a5bdd8e 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -752,7 +752,7 @@ static int rfcomm_tty_open(struct tty_struct *tty, struct file *filp)
 	BT_DBG("tty %p id %d", tty, tty->index);
 
 	BT_DBG("dev %p dst %pMR channel %d opened %d", dev, &dev->dst,
-	       dev->channel, dev->port.count);
+	       dev->channel, atomic_read(&dev->port.count));
 
 	err = tty_port_open(&dev->port, tty, filp);
 	if (err)
@@ -775,7 +775,7 @@ static void rfcomm_tty_close(struct tty_struct *tty, struct file *filp)
 	struct rfcomm_dev *dev = (struct rfcomm_dev *) tty->driver_data;
 
 	BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc,
-						dev->port.count);
+						atomic_read(&dev->port.count));
 
 	tty_port_close(&dev->port, tty, filp);
 }
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 873c4b7..eb751e0 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -311,10 +311,10 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	add_wait_queue(&port->open_wait, &wait);
 
 	pr_debug("%s(%d):block_til_ready before block on %s open_count=%d\n",
-		 __FILE__, __LINE__, tty->driver->name, port->count);
+		 __FILE__, __LINE__, tty->driver->name, atomic_read(&port->count));
 
 	spin_lock_irqsave(&port->lock, flags);
-	port->count--;
+	atomic_dec(&port->count);
 	port->blocked_open++;
 	spin_unlock_irqrestore(&port->lock, flags);
 
@@ -347,7 +347,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 		}
 
 		pr_debug("%s(%d):block_til_ready blocking on %s open_count=%d\n",
-			 __FILE__, __LINE__, tty->driver->name, port->count);
+			 __FILE__, __LINE__, tty->driver->name, atomic_read(&port->count));
 
 		schedule();
 	}
@@ -357,12 +357,12 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 
 	spin_lock_irqsave(&port->lock, flags);
 	if (!tty_hung_up_p(filp))
-		port->count++;
+		atomic_inc(&port->count);
 	port->blocked_open--;
 	spin_unlock_irqrestore(&port->lock, flags);
 
 	pr_debug("%s(%d):block_til_ready after blocking on %s open_count=%d\n",
-		 __FILE__, __LINE__, tty->driver->name, port->count);
+		 __FILE__, __LINE__, tty->driver->name, atomic_read(&port->count));
 
 	if (!retval)
 		tty_port_set_active(port, 1);
@@ -432,12 +432,12 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 
 	/* ++ is not atomic, so this should be protected - Jean II */
 	spin_lock_irqsave(&self->port.lock, flags);
-	self->port.count++;
+	atomic_inc(&self->port.count);
 	spin_unlock_irqrestore(&self->port.lock, flags);
 	tty_port_tty_set(&self->port, tty);
 
 	pr_debug("%s(), %s%d, count = %d\n", __func__ , tty->driver->name,
-		 self->line, self->port.count);
+		 self->line, atomic_read(&self->port.count));
 
 	/* Not really used by us, but lets do it anyway */
 	self->port.low_latency = (self->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
@@ -931,7 +931,7 @@ static void ircomm_tty_hangup(struct tty_struct *tty)
 		tty_kref_put(port->tty);
 	}
 	port->tty = NULL;
-	port->count = 0;
+	atomic_set(&port->count, 0);
 	spin_unlock_irqrestore(&port->lock, flags);
 	tty_port_set_active(port, 0);
 
@@ -1275,7 +1275,7 @@ static void ircomm_tty_line_info(struct ircomm_tty_cb *self, struct seq_file *m)
 	seq_putc(m, '\n');
 
 	seq_printf(m, "Role: %s\n", self->client ? "client" : "server");
-	seq_printf(m, "Open count: %d\n", self->port.count);
+	seq_printf(m, "Open count: %d\n", atomic_read(&self->port.count));
 	seq_printf(m, "Max data size: %d\n", self->max_data_size);
 	seq_printf(m, "Max header size: %d\n", self->max_header_size);
 
-- 
2.7.4
