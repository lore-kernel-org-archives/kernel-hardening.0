Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Dec 2016 10:51:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161214185110.GD4939@kroah.com>
References: <20161214185000.GA3930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161214185000.GA3930@kroah.com>
Subject: [kernel-hardening] [RFC 4/4] Introduce CONFIG_READONLY_USERMODEHELPER
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

If you can write to kernel memory, an "easy" way to get the kernel to
run any application is to change the pointer of one of the usermode
helper program names.  To try to mitigate this, create a new config
option, CONFIG_READONLY_USERMODEHELPER.

This option only allows "predefined" binaries to be called.  A number of
drivers and subsystems allow for the name of the binary to be changed,
and this config option disables that capability, so be aware of that.

Note:  Still a proof-of-concept at this point in time, doesn't cover all
of the call_usermodehelper() calls just yet, including the "fun" of
coredumps, it's still a work in progress.

Not-Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c | 12 ++++++++----
 drivers/block/drbd/drbd_int.h    |  6 +++++-
 drivers/block/drbd/drbd_main.c   |  5 +++++
 drivers/video/fbdev/uvesafb.c    | 19 ++++++++++++++-----
 fs/nfs/cache_lib.c               | 12 ++++++++++--
 include/linux/reboot.h           |  2 ++
 kernel/ksysfs.c                  |  6 +++++-
 kernel/reboot.c                  |  3 +++
 kernel/sysctl.c                  |  4 ++++
 lib/kobject_uevent.c             |  3 +++
 security/Kconfig                 | 17 +++++++++++++++++
 11 files changed, 76 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 00ef43233e03..92a2ef8ffe3e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2337,15 +2337,16 @@ static ssize_t set_bank(struct device *s, struct device_attribute *attr,
 }
 
 static ssize_t
-show_trigger(struct device *s, struct device_attribute *attr, char *buf)
+trigger_show(struct device *s, struct device_attribute *attr, char *buf)
 {
 	strcpy(buf, mce_helper);
 	strcat(buf, "\n");
 	return strlen(mce_helper) + 1;
 }
 
-static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
-				const char *buf, size_t siz)
+#ifndef CONFIG_READONLY_USERMODEHELPER
+static ssize_t trigger_store(struct device *s, struct device_attribute *attr,
+			     const char *buf, size_t siz)
 {
 	char *p;
 
@@ -2358,6 +2359,10 @@ static ssize_t set_trigger(struct device *s, struct device_attribute *attr,
 
 	return strlen(mce_helper) + !!p;
 }
+static DEVICE_ATTR_RW(trigger);
+#else
+static DEVICE_ATTR_RO(trigger);
+#endif
 
 static ssize_t set_ignore_ce(struct device *s,
 			     struct device_attribute *attr,
@@ -2415,7 +2420,6 @@ static ssize_t store_int_with_restart(struct device *s,
 	return ret;
 }
 
-static DEVICE_ATTR(trigger, 0644, show_trigger, set_trigger);
 static DEVICE_INT_ATTR(tolerant, 0644, mca_cfg.tolerant);
 static DEVICE_INT_ATTR(monarch_timeout, 0644, mca_cfg.monarch_timeout);
 static DEVICE_BOOL_ATTR(dont_log_ce, 0644, mca_cfg.dont_log_ce);
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a139a34f1f1e..e21ab2bcc482 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -75,7 +75,11 @@ extern int fault_rate;
 extern int fault_devs;
 #endif
 
-extern char drbd_usermode_helper[];
+extern
+#ifdef CONFIG_READONLY_USERMODEHELPER
+       const
+#endif
+             char drbd_usermode_helper[];
 
 
 /* This is used to stop/restart our threads.
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8f51eccc8de7..41c988e9cdf2 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -108,9 +108,14 @@ int proc_details;       /* Detail level in proc drbd*/
 
 /* Module parameter for setting the user mode helper program
  * to run. Default is /sbin/drbdadm */
+#ifdef CONFIG_READONLY_USERMODEHELPER
+const
+#endif
 char drbd_usermode_helper[80] = "/sbin/drbdadm";
 
+#ifndef CONFIG_READONLY_USERMODEHELPER
 module_param_string(usermode_helper, drbd_usermode_helper, sizeof(drbd_usermode_helper), 0644);
+#endif
 
 /* in 2.6.x, our device mapping and config info contains our virtual gendisks
  * as member "struct gendisk *vdisk;"
diff --git a/drivers/video/fbdev/uvesafb.c b/drivers/video/fbdev/uvesafb.c
index 98af9e02959b..0328d70a4afb 100644
--- a/drivers/video/fbdev/uvesafb.c
+++ b/drivers/video/fbdev/uvesafb.c
@@ -30,7 +30,11 @@ static struct cb_id uvesafb_cn_id = {
 	.idx = CN_IDX_V86D,
 	.val = CN_VAL_V86D_UVESAFB
 };
+#ifdef CONFIG_READONLY_USERMODEHELPER
+static const char v86d_path[PATH_MAX] = "/sbin/v86d";
+#else
 static char v86d_path[PATH_MAX] = "/sbin/v86d";
+#endif
 static char v86d_started;	/* has v86d been started by uvesafb? */
 
 static const struct fb_fix_screeninfo uvesafb_fix = {
@@ -114,7 +118,7 @@ static int uvesafb_helper_start(void)
 	};
 
 	char *argv[] = {
-		v86d_path,
+		(char *)v86d_path,
 		NULL,
 	};
 
@@ -1883,19 +1887,22 @@ static int uvesafb_setup(char *options)
 }
 #endif /* !MODULE */
 
-static ssize_t show_v86d(struct device_driver *dev, char *buf)
+static ssize_t v86d_show(struct device_driver *dev, char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n", v86d_path);
 }
 
-static ssize_t store_v86d(struct device_driver *dev, const char *buf,
+#ifndef CONFIG_READONLY_USERMODEHELPER
+static ssize_t v86d_store(struct device_driver *dev, const char *buf,
 		size_t count)
 {
 	strncpy(v86d_path, buf, PATH_MAX);
 	return count;
 }
-
-static DRIVER_ATTR(v86d, S_IRUGO | S_IWUSR, show_v86d, store_v86d);
+static DRIVER_ATTR_RW(v86d);
+#else
+static DRIVER_ATTR_RO(v86d);
+#endif
 
 static int uvesafb_init(void)
 {
@@ -2017,8 +2024,10 @@ MODULE_PARM_DESC(mode_option,
 module_param(vbemode, ushort, 0);
 MODULE_PARM_DESC(vbemode,
 	"VBE mode number to set, overrides the 'mode' option");
+#ifndef CONFIG_READONLY_USERMODEHELPER
 module_param_string(v86d, v86d_path, PATH_MAX, 0660);
 MODULE_PARM_DESC(v86d, "Path to the v86d userspace helper.");
+#endif
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Januszewski <spock@gentoo.org>");
diff --git a/fs/nfs/cache_lib.c b/fs/nfs/cache_lib.c
index 6de15709d024..32a739e909d2 100644
--- a/fs/nfs/cache_lib.c
+++ b/fs/nfs/cache_lib.c
@@ -20,13 +20,20 @@
 #define NFS_CACHE_UPCALL_PATHLEN 256
 #define NFS_CACHE_UPCALL_TIMEOUT 15
 
+#ifdef CONFIG_READONLY_USERMODEHELPER
+static const char nfs_cache_getent_prog[NFS_CACHE_UPCALL_PATHLEN] =
+#else
 static char nfs_cache_getent_prog[NFS_CACHE_UPCALL_PATHLEN] =
+#endif
 				"/sbin/nfs_cache_getent";
 static unsigned long nfs_cache_getent_timeout = NFS_CACHE_UPCALL_TIMEOUT;
 
+#ifndef CONFIG_READONLY_USERMODEHELPER
 module_param_string(cache_getent, nfs_cache_getent_prog,
 		sizeof(nfs_cache_getent_prog), 0600);
 MODULE_PARM_DESC(cache_getent, "Path to the client cache upcall program");
+#endif
+
 module_param_named(cache_getent_timeout, nfs_cache_getent_timeout, ulong, 0600);
 MODULE_PARM_DESC(cache_getent_timeout, "Timeout (in seconds) after which "
 		"the cache upcall is assumed to have failed");
@@ -39,7 +46,7 @@ int nfs_cache_upcall(struct cache_detail *cd, char *entry_name)
 		NULL
 	};
 	char *argv[] = {
-		nfs_cache_getent_prog,
+		(char *)nfs_cache_getent_prog,
 		cd->name,
 		entry_name,
 		NULL
@@ -48,7 +55,8 @@ int nfs_cache_upcall(struct cache_detail *cd, char *entry_name)
 
 	if (nfs_cache_getent_prog[0] == '\0')
 		goto out;
-	ret = call_usermodehelper(argv[0], argv, envp, UMH_WAIT_EXEC);
+	ret = call_usermodehelper(nfs_cache_getent_prog, argv, envp,
+				  UMH_WAIT_EXEC);
 	/*
 	 * Disable the upcall mechanism if we're getting an ENOENT or
 	 * EACCES error. The admin can re-enable it on the fly by using
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index a7ff409f386d..52a43b062942 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -68,7 +68,9 @@ extern int C_A_D; /* for sysctl */
 void ctrl_alt_del(void);
 
 #define POWEROFF_CMD_PATH_LEN	256
+#ifndef CONFIG_READONLY_USERMODEHELPER
 extern char poweroff_cmd[POWEROFF_CMD_PATH_LEN];
+#endif
 
 extern void orderly_poweroff(bool force);
 extern void orderly_reboot(void);
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index ee1bc1bb8feb..9158fb36cfae 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -44,6 +44,7 @@ static ssize_t uevent_helper_show(struct kobject *kobj,
 {
 	return sprintf(buf, "%s\n", uevent_helper);
 }
+#ifndef CONFIG_READONLY_USERMODEHELPER
 static ssize_t uevent_helper_store(struct kobject *kobj,
 				   struct kobj_attribute *attr,
 				   const char *buf, size_t count)
@@ -57,7 +58,10 @@ static ssize_t uevent_helper_store(struct kobject *kobj,
 	return count;
 }
 KERNEL_ATTR_RW(uevent_helper);
-#endif
+#else
+KERNEL_ATTR_RO(uevent_helper);
+#endif	/* CONFIG_READONLY_USERMODEHELPER */
+#endif	/* CONFIG_UEVENT_HELPER */
 
 #ifdef CONFIG_PROFILING
 static ssize_t profiling_show(struct kobject *kobj,
diff --git a/kernel/reboot.c b/kernel/reboot.c
index bd30a973fe94..1b1764f0eb30 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -386,6 +386,9 @@ void ctrl_alt_del(void)
 		kill_cad_pid(SIGINT, 1);
 }
 
+#ifdef CONFIG_READONLY_USERMODEHELPER
+static const
+#endif
 char poweroff_cmd[POWEROFF_CMD_PATH_LEN] = "/sbin/poweroff";
 static const char reboot_cmd[] = "/sbin/reboot";
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 39b3368f6de6..0b75e1aa8d82 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -662,6 +662,7 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 #ifdef CONFIG_UEVENT_HELPER
+#ifndef CONFIG_READONLY_USERMODEHELPER
 	{
 		.procname	= "hotplug",
 		.data		= &uevent_helper,
@@ -670,6 +671,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dostring,
 	},
 #endif
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 	{
 		.procname	= "sg-big-buff",
@@ -1079,6 +1081,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifndef CONFIG_READONLY_USERMODEHELPER
 	{
 		.procname	= "poweroff_cmd",
 		.data		= &poweroff_cmd,
@@ -1086,6 +1089,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dostring,
 	},
+#endif
 #ifdef CONFIG_KEYS
 	{
 		.procname	= "keys",
diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 9a2b811966eb..a8f087d7687d 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -29,6 +29,9 @@
 
 u64 uevent_seqnum;
 #ifdef CONFIG_UEVENT_HELPER
+#ifdef CONFIG_READONLY_USERMODEHELPER
+const
+#endif
 char uevent_helper[UEVENT_HELPER_PATH_LEN] = CONFIG_UEVENT_HELPER_PATH;
 #endif
 #ifdef CONFIG_NET
diff --git a/security/Kconfig b/security/Kconfig
index 118f4549404e..47e8011c6261 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -158,6 +158,23 @@ config HARDENED_USERCOPY_PAGESPAN
 	  been removed. This config is intended to be used only while
 	  trying to find such users.
 
+config READONLY_USERMODEHELPER
+	bool "Make User Mode Helper program names read-only"
+	default N
+	help
+	  Some user mode helper program names can be changed at runtime
+	  by userspace programs.  Prevent this from happening by "hard
+	  coding" all user mode helper program names at kernel build
+	  time, moving the names into read-only memory, making it harder
+	  for any arbritrary program to be run as root if something were
+	  to go wrong.
+
+	  Note, some subsystems and drivers allow their user mode helper
+	  binary to be changed with a module parameter, sysctl, sysfs
+	  file, or some combination of these.  Enabling this option
+	  prevents the binary name to be changed, which might not be
+	  good for some systems.
+
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
-- 
2.10.2
