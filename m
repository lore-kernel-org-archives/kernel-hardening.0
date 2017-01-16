Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 Jan 2017 17:50:31 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170116165031.GB29693@kroah.com>
References: <20170116164944.GA28984@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116164944.GA28984@kroah.com>
Subject: [kernel-hardening] [PATCH 2/3] Make static usermode helper binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Sailer <t.sailer@alumni.ethz.ch>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Johan Hovold <johan@kernel.org>, Alex Elder <elder@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, David Howells <dhowells@redhat.com>, NeilBrown <neilb@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

There are a number of usermode helper binaries that are "hard coded" in
the kernel today, so mark them as "const" to make it harder for someone
to change where the variables point to.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Sailer <t.sailer@alumni.ethz.ch>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Johan Hovold <johan@kernel.org>
Cc: Alex Elder <elder@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/macintosh/windfarm_core.c          |  4 ++--
 drivers/net/hamradio/baycom_epp.c          | 10 +++++++---
 drivers/pnp/pnpbios/core.c                 |  5 +++--
 drivers/staging/greybus/svc_watchdog.c     |  4 ++--
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c |  8 ++++----
 fs/nfsd/nfs4layouts.c                      |  6 ++++--
 security/keys/request_key.c                |  7 ++++---
 7 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 465d770ab0bb..5e013d781a74 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -74,8 +74,8 @@ static inline void wf_notify(int event, void *param)
 
 static int wf_critical_overtemp(void)
 {
-	static char * critical_overtemp_path = "/sbin/critical_overtemp";
-	char *argv[] = { critical_overtemp_path, NULL };
+	static char const critical_overtemp_path[] = "/sbin/critical_overtemp";
+	char *argv[] = { (char *)critical_overtemp_path, NULL };
 	static char *envp[] = { "HOME=/",
 				"TERM=linux",
 				"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 7d054697b199..594fa1407e29 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -299,7 +299,7 @@ static inline void baycom_int_freq(struct baycom_state *bc)
  *    eppconfig_path should be setable  via /proc/sys.
  */
 
-static char eppconfig_path[256] = "/usr/sbin/eppfpga";
+static char const eppconfig_path[] = "/usr/sbin/eppfpga";
 
 static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL };
 
@@ -308,8 +308,12 @@ static int eppconfig(struct baycom_state *bc)
 {
 	char modearg[256];
 	char portarg[16];
-        char *argv[] = { eppconfig_path, "-s", "-p", portarg, "-m", modearg,
-			 NULL };
+        char *argv[] = {
+		(char *)eppconfig_path,
+		"-s",
+		"-p", portarg,
+		"-m", modearg,
+		NULL };
 
 	/* set up arguments */
 	sprintf(modearg, "%sclk,%smodem,fclk=%d,bps=%d,divider=%d%s,extstat",
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index c38a5b9733c8..0ced908e7aa8 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -98,6 +98,7 @@ static struct completion unload_sem;
  */
 static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 {
+	static char const sbin_pnpbios[] = "/sbin/pnpbios";
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
@@ -112,7 +113,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 	 * integrated into the driver core and use the usual infrastructure
 	 * like sysfs and uevents
 	 */
-	argv[0] = "/sbin/pnpbios";
+	argv[0] = (char *)sbin_pnpbios;
 	argv[1] = "dock";
 	argv[2] = NULL;
 
@@ -139,7 +140,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 			   info->location_id, info->serial, info->capabilities);
 	envp[i] = NULL;
 
-	value = call_usermodehelper(argv [0], argv, envp, UMH_WAIT_EXEC);
+	value = call_usermodehelper(sbin_pnpbios, argv, envp, UMH_WAIT_EXEC);
 	kfree(buf);
 	kfree(envp);
 	return 0;
diff --git a/drivers/staging/greybus/svc_watchdog.c b/drivers/staging/greybus/svc_watchdog.c
index 3729460fb954..12cef5c06e27 100644
--- a/drivers/staging/greybus/svc_watchdog.c
+++ b/drivers/staging/greybus/svc_watchdog.c
@@ -44,14 +44,14 @@ static int svc_watchdog_pm_notifier(struct notifier_block *notifier,
 
 static void greybus_reset(struct work_struct *work)
 {
-	static char start_path[256] = "/system/bin/start";
+	static char const start_path[] = "/system/bin/start";
 	static char *envp[] = {
 		"HOME=/",
 		"PATH=/sbin:/vendor/bin:/system/sbin:/system/bin:/system/xbin",
 		NULL,
 	};
 	static char *argv[] = {
-		start_path,
+		(char *)start_path,
 		"unipro_reset",
 		NULL,
 	};
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 9bc284812c30..dbb58fb16482 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -268,8 +268,8 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 static void _rtl92e_dm_check_ac_dc_power(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	static char *ac_dc_script = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
-	char *argv[] = {ac_dc_script, DRV_NAME, NULL};
+	static char const ac_dc_script[] = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
+	char *argv[] = {(char *)ac_dc_script, DRV_NAME, NULL};
 	static char *envp[] = {"HOME=/",
 			"TERM=linux",
 			"PATH=/usr/bin:/bin",
@@ -1823,7 +1823,7 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 	enum rt_rf_power_state eRfPowerStateToSet;
 	bool bActuallySet = false;
 	char *argv[3];
-	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
+	static char const RadioPowerPath[] = "/etc/acpi/events/RadioPower.sh";
 	static char *envp[] = {"HOME=/", "TERM=linux", "PATH=/usr/bin:/bin",
 			       NULL};
 
@@ -1862,7 +1862,7 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 		else
 			argv[1] = "RFON";
 
-		argv[0] = RadioPowerPath;
+		argv[0] = (char *)RadioPowerPath;
 		argv[2] = NULL;
 		call_usermodehelper(RadioPowerPath, argv, envp, UMH_WAIT_PROC);
 	}
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 596205d939a1..e06a4ae5f3ad 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -613,6 +613,7 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
 {
 	struct nfs4_client *clp = ls->ls_stid.sc_client;
 	char addr_str[INET6_ADDRSTRLEN];
+	static char const nfsd_recall_failed[] = "/sbin/nfsd-recall-failed";
 	static char *envp[] = {
 		"HOME=/",
 		"TERM=linux",
@@ -628,12 +629,13 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
 		"nfsd: client %s failed to respond to layout recall. "
 		"  Fencing..\n", addr_str);
 
-	argv[0] = "/sbin/nfsd-recall-failed";
+	argv[0] = (char *)nfsd_recall_failed;
 	argv[1] = addr_str;
 	argv[2] = ls->ls_file->f_path.mnt->mnt_sb->s_id;
 	argv[3] = NULL;
 
-	error = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_PROC);
+	error = call_usermodehelper(nfsd_recall_failed, argv, envp,
+				    UMH_WAIT_PROC);
 	if (error) {
 		printk(KERN_ERR "nfsd: fence failed for client %s: %d!\n",
 			addr_str, error);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 43affcf10b22..9822e500d50d 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -72,7 +72,7 @@ static void umh_keys_cleanup(struct subprocess_info *info)
 /*
  * Call a usermode helper with a specific session keyring.
  */
-static int call_usermodehelper_keys(char *path, char **argv, char **envp,
+static int call_usermodehelper_keys(const char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
 	struct subprocess_info *info;
@@ -95,6 +95,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 				 const char *op,
 				 void *aux)
 {
+	static char const request_key[] = "/sbin/request-key";
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
 	struct key *key = cons->key, *authkey = cons->authkey, *keyring,
@@ -161,7 +162,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 
 	/* set up the argument list */
 	i = 0;
-	argv[i++] = "/sbin/request-key";
+	argv[i++] = (char *)request_key;
 	argv[i++] = (char *) op;
 	argv[i++] = key_str;
 	argv[i++] = uid_str;
@@ -172,7 +173,7 @@ static int call_sbin_request_key(struct key_construction *cons,
 	argv[i] = NULL;
 
 	/* do it */
-	ret = call_usermodehelper_keys(argv[0], argv, envp, keyring,
+	ret = call_usermodehelper_keys(request_key, argv, envp, keyring,
 				       UMH_WAIT_PROC);
 	kdebug("usermode -> 0x%x", ret);
 	if (ret >= 0) {
-- 
2.11.0
