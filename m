Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 10:50:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214185040.GB4939@kroah.com>
References: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185000.GA3930@kroah.com>
Subject: [kernel-hardening] [PATCH 2/4] drbd: rename "usermode_helper" to "drbd_usermode_helper"
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Nothing like having a very generic global variable in a tiny driver
subsystem to make a mess of the global namespace...

Anyway, clean it up in anticipation of making drbd_usermode_helper
read-only in a future patch.

Note, there are many other "generic" named global variables in the drbd
subsystem, someone should fix those up one day before they hit a linking
error.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/drbd/drbd_int.h  |  2 +-
 drivers/block/drbd/drbd_main.c |  4 ++--
 drivers/block/drbd/drbd_nl.c   | 20 ++++++++++----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4cb8f21ff4ef..a139a34f1f1e 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -75,7 +75,7 @@ extern int fault_rate;
 extern int fault_devs;
 #endif
 
-extern char usermode_helper[];
+extern char drbd_usermode_helper[];
 
 
 /* This is used to stop/restart our threads.
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 83482721bc01..8f51eccc8de7 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -108,9 +108,9 @@ int proc_details;       /* Detail level in proc drbd*/
 
 /* Module parameter for setting the user mode helper program
  * to run. Default is /sbin/drbdadm */
-char usermode_helper[80] = "/sbin/drbdadm";
+char drbd_usermode_helper[80] = "/sbin/drbdadm";
 
-module_param_string(usermode_helper, usermode_helper, sizeof(usermode_helper), 0644);
+module_param_string(usermode_helper, drbd_usermode_helper, sizeof(drbd_usermode_helper), 0644);
 
 /* in 2.6.x, our device mapping and config info contains our virtual gendisks
  * as member "struct gendisk *vdisk;"
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index f35db29cac76..9edc6fb95f19 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -344,7 +344,7 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 			 (char[60]) { }, /* address */
 			NULL };
 	char mb[14];
-	char *argv[] = {usermode_helper, cmd, mb, NULL };
+	char *argv[] = {drbd_usermode_helper, cmd, mb, NULL };
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	struct sib_info sib;
 	int ret;
@@ -359,19 +359,19 @@ int drbd_khelper(struct drbd_device *device, char *cmd)
 	 * write out any unsynced meta data changes now */
 	drbd_md_sync(device);
 
-	drbd_info(device, "helper command: %s %s %s\n", usermode_helper, cmd, mb);
+	drbd_info(device, "helper command: %s %s %s\n", drbd_usermode_helper, cmd, mb);
 	sib.sib_reason = SIB_HELPER_PRE;
 	sib.helper_name = cmd;
 	drbd_bcast_event(device, &sib);
 	notify_helper(NOTIFY_CALL, device, connection, cmd, 0);
-	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
+	ret = call_usermodehelper(drbd_usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
 		drbd_warn(device, "helper command: %s %s %s exit code %u (0x%x)\n",
-				usermode_helper, cmd, mb,
+				drbd_usermode_helper, cmd, mb,
 				(ret >> 8) & 0xff, ret);
 	else
 		drbd_info(device, "helper command: %s %s %s exit code %u (0x%x)\n",
-				usermode_helper, cmd, mb,
+				drbd_usermode_helper, cmd, mb,
 				(ret >> 8) & 0xff, ret);
 	sib.sib_reason = SIB_HELPER_POST;
 	sib.helper_exit_code = ret;
@@ -396,24 +396,24 @@ enum drbd_peer_state conn_khelper(struct drbd_connection *connection, char *cmd)
 			 (char[60]) { }, /* address */
 			NULL };
 	char *resource_name = connection->resource->name;
-	char *argv[] = {usermode_helper, cmd, resource_name, NULL };
+	char *argv[] = {drbd_usermode_helper, cmd, resource_name, NULL };
 	int ret;
 
 	setup_khelper_env(connection, envp);
 	conn_md_sync(connection);
 
-	drbd_info(connection, "helper command: %s %s %s\n", usermode_helper, cmd, resource_name);
+	drbd_info(connection, "helper command: %s %s %s\n", drbd_usermode_helper, cmd, resource_name);
 	/* TODO: conn_bcast_event() ?? */
 	notify_helper(NOTIFY_CALL, NULL, connection, cmd, 0);
 
-	ret = call_usermodehelper(usermode_helper, argv, envp, UMH_WAIT_PROC);
+	ret = call_usermodehelper(drbd_usermode_helper, argv, envp, UMH_WAIT_PROC);
 	if (ret)
 		drbd_warn(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, resource_name,
+			  drbd_usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	else
 		drbd_info(connection, "helper command: %s %s %s exit code %u (0x%x)\n",
-			  usermode_helper, cmd, resource_name,
+			  drbd_usermode_helper, cmd, resource_name,
 			  (ret >> 8) & 0xff, ret);
 	/* TODO: conn_bcast_event() ?? */
 	notify_helper(NOTIFY_RESPONSE, NULL, connection, cmd, ret);
-- 
2.10.2
