From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:32 -0700
Message-Id: <1491513513-84351-18-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 17/18] sgi-xp: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

To avoid casting, this implements dummy functions with full function
prototypes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/sgi-xp/xp.h      |  2 +-
 drivers/misc/sgi-xp/xp_main.c | 59 ++++++++++++++++++++++++++++---------------
 2 files changed, 40 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index a23a373d8707..c862cd4583cc 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -288,7 +288,7 @@ struct xpc_interface {
 					xpc_notify_func, void *);
 	void (*received) (short, int, void *);
 	enum xp_retval (*partid_to_nasids) (short, void *);
-} __no_randomize_layout;
+};
 
 extern struct xpc_interface xpc_interface;
 
diff --git a/drivers/misc/sgi-xp/xp_main.c b/drivers/misc/sgi-xp/xp_main.c
index 01be66d02ca8..bb47f9d9b68a 100644
--- a/drivers/misc/sgi-xp/xp_main.c
+++ b/drivers/misc/sgi-xp/xp_main.c
@@ -71,20 +71,44 @@ EXPORT_SYMBOL_GPL(xpc_registrations);
 /*
  * Initialize the XPC interface to indicate that XPC isn't loaded.
  */
-static enum xp_retval
-xpc_notloaded(void)
+static void xpc_notloaded_connect(int ch_number)
+{ }
+
+static void xpc_notloaded_disconnect(int ch_number)
+{ }
+
+static enum xp_retval xpc_notloaded_send(short partid, int ch_number,
+					 u32 flags, void *payload,
+					 u16 payload_size)
+{
+	return xpNotLoaded;
+}
+
+static enum xp_retval xpc_notloaded_send_notify(short partid, int ch_number,
+						u32 flags, void *payload,
+						u16 payload_size,
+						xpc_notify_func func,
+						void *key)
+{
+	return xpNotLoaded;
+}
+
+static void xpc_notloaded_received(short partid, int ch_number, void *payload)
+{ }
+
+static enum xp_retval xpc_notloaded_partid_to_nasids(short partid,
+						     void *nasid_mask)
 {
 	return xpNotLoaded;
 }
 
 struct xpc_interface xpc_interface = {
-	(void (*)(int))xpc_notloaded,
-	(void (*)(int))xpc_notloaded,
-	(enum xp_retval(*)(short, int, u32, void *, u16))xpc_notloaded,
-	(enum xp_retval(*)(short, int, u32, void *, u16, xpc_notify_func,
-			   void *))xpc_notloaded,
-	(void (*)(short, int, void *))xpc_notloaded,
-	(enum xp_retval(*)(short, void *))xpc_notloaded
+	.connect = xpc_notloaded_connect,
+	.disconnect = xpc_notloaded_disconnect,
+	.send = xpc_notloaded_send,
+	.send_notify = xpc_notloaded_send_notify,
+	.received = xpc_notloaded_received,
+	.partid_to_nasids = xpc_notloaded_partid_to_nasids
 };
 EXPORT_SYMBOL_GPL(xpc_interface);
 
@@ -115,17 +139,12 @@ EXPORT_SYMBOL_GPL(xpc_set_interface);
 void
 xpc_clear_interface(void)
 {
-	xpc_interface.connect = (void (*)(int))xpc_notloaded;
-	xpc_interface.disconnect = (void (*)(int))xpc_notloaded;
-	xpc_interface.send = (enum xp_retval(*)(short, int, u32, void *, u16))
-	    xpc_notloaded;
-	xpc_interface.send_notify = (enum xp_retval(*)(short, int, u32, void *,
-						       u16, xpc_notify_func,
-						       void *))xpc_notloaded;
-	xpc_interface.received = (void (*)(short, int, void *))
-	    xpc_notloaded;
-	xpc_interface.partid_to_nasids = (enum xp_retval(*)(short, void *))
-	    xpc_notloaded;
+	xpc_interface.connect = xpc_notloaded_connect;
+	xpc_interface.disconnect = xpc_notloaded_disconnect;
+	xpc_interface.send = xpc_notloaded_send;
+	xpc_interface.send_notify = xpc_notloaded_send_notify;
+	xpc_interface.received = xpc_notloaded_received;
+	xpc_interface.partid_to_nasids = xpc_notloaded_partid_to_nasids;
 }
 EXPORT_SYMBOL_GPL(xpc_clear_interface);
 
-- 
2.7.4
