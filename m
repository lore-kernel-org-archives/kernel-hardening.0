Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 10:50:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214185052.GC4939@kroah.com>
References: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185000.GA3930@kroah.com>
Subject: [kernel-hardening] [PATCH 3/4] Make static usermode helper binaries constant
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


There are a number of usermode helper binaries that are "hard coded" in
the kernel today, so mark them as "const" to make it harder for someone
to change where the variables point to.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/macintosh/windfarm_core.c          | 2 +-
 drivers/net/hamradio/baycom_epp.c          | 2 +-
 drivers/pnp/pnpbios/core.c                 | 5 +++--
 drivers/staging/greybus/svc_watchdog.c     | 4 ++--
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c | 6 +++---
 fs/nfsd/nfs4layouts.c                      | 6 ++++--
 security/keys/request_key.c                | 7 ++++---
 7 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/macintosh/windfarm_core.c b/drivers/macintosh/windfarm_core.c
index 465d770ab0bb..1b317cbb73cf 100644
--- a/drivers/macintosh/windfarm_core.c
+++ b/drivers/macintosh/windfarm_core.c
@@ -74,7 +74,7 @@ static inline void wf_notify(int event, void *param)
 
 static int wf_critical_overtemp(void)
 {
-	static char * critical_overtemp_path = "/sbin/critical_overtemp";
+	static const char * critical_overtemp_path = "/sbin/critical_overtemp";
 	char *argv[] = { critical_overtemp_path, NULL };
 	static char *envp[] = { "HOME=/",
 				"TERM=linux",
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 78dbc44540f6..321cffa8dbe4 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -299,7 +299,7 @@ static inline void baycom_int_freq(struct baycom_state *bc)
  *    eppconfig_path should be setable  via /proc/sys.
  */
 
-static char eppconfig_path[256] = "/usr/sbin/eppfpga";
+static const char eppconfig_path[256] = "/usr/sbin/eppfpga";
 
 static char *envp[] = { "HOME=/", "TERM=linux", "PATH=/usr/bin:/bin", NULL };
 
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index c38a5b9733c8..614aae6fcc0f 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -98,6 +98,7 @@ static struct completion unload_sem;
  */
 static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 {
+	static const char *sbin_pnpbios = "/sbin/pnpbios";
 	char *argv[3], **envp, *buf, *scratch;
 	int i = 0, value;
 
@@ -112,7 +113,7 @@ static int pnp_dock_event(int dock, struct pnp_docking_station_info *info)
 	 * integrated into the driver core and use the usual infrastructure
 	 * like sysfs and uevents
 	 */
-	argv[0] = "/sbin/pnpbios";
+	argv[0] = sbin_pnpbios;
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
index 3729460fb954..db32ec0f0e80 100644
--- a/drivers/staging/greybus/svc_watchdog.c
+++ b/drivers/staging/greybus/svc_watchdog.c
@@ -44,14 +44,14 @@ static int svc_watchdog_pm_notifier(struct notifier_block *notifier,
 
 static void greybus_reset(struct work_struct *work)
 {
-	static char start_path[256] = "/system/bin/start";
+	static const char start_path[256] = "/system/bin/start";
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
index 9bc284812c30..5f0c2cdf32d1 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -268,7 +268,7 @@ void rtl92e_dm_watchdog(struct net_device *dev)
 static void _rtl92e_dm_check_ac_dc_power(struct net_device *dev)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	static char *ac_dc_script = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
+	static const char *ac_dc_script = "/etc/acpi/wireless-rtl-ac-dc-power.sh";
 	char *argv[] = {ac_dc_script, DRV_NAME, NULL};
 	static char *envp[] = {"HOME=/",
 			"TERM=linux",
@@ -1823,7 +1823,7 @@ static void _rtl92e_dm_check_rf_ctrl_gpio(void *data)
 	enum rt_rf_power_state eRfPowerStateToSet;
 	bool bActuallySet = false;
 	char *argv[3];
-	static char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
+	static const char *RadioPowerPath = "/etc/acpi/events/RadioPower.sh";
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
index 42aace4fc4c8..4ce019b9d5a9 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -613,6 +613,7 @@ nfsd4_cb_layout_fail(struct nfs4_layout_stateid *ls)
 {
 	struct nfs4_client *clp = ls->ls_stid.sc_client;
 	char addr_str[INET6_ADDRSTRLEN];
+	static const char *nfsd_recall_failed = "/sbin/nfsd-recall-failed";
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
index 43affcf10b22..e79cdcd704b5 100644
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
+	static const char *request_key = "/sbin/request-key";
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
2.10.2
