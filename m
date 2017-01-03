Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 Jan 2017 14:58:31 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170103225831.GA113525@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@coreos.com>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Garrett <mjg59@coreos.com>

Various attacks are made possible due to the large attack surface of
kernel drivers and the easy availability of hotpluggable hardware that can
be programmed to mimic arbitrary devices. This allows attackers to find a
single vulnerable driver and then produce a device that can exploit it by
plugging into a hotpluggable bus (such as PCI or USB). This violates user
assumptions about unattended systems being secure as long as the screen
is locked.

The kernel already has support for deferring driver binding in order
to avoid problems over suspend/resume. By exposing this to userspace we
can disable probing when the screen is locked and simply reenable it on
unlock.

This is not a complete solution - since this still permits device
creation and simply blocks driver binding, it won't stop userspace
drivers from attaching to devices and it won't protect against any kernel
vulnerabilities in the core bus code. However, it should be sufficient to
block attacks like Poisontap (https://samy.pl/poisontap/).

Signed-off-by: Matthew Garrett <mjg59@coreos.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../ABI/testing/sysfs-kernel-disable-device-probe  | 10 ++++++++
 drivers/base/base.h                                |  2 --
 drivers/base/dd.c                                  | 10 ++++++++
 drivers/base/power/main.c                          | 16 ++++++++++---
 include/linux/device.h                             |  4 ++++
 kernel/ksysfs.c                                    | 28 ++++++++++++++++++++++
 6 files changed, 65 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-disable-device-probe

diff --git a/Documentation/ABI/testing/sysfs-kernel-disable-device-probe b/Documentation/ABI/testing/sysfs-kernel-disable-device-probe
new file mode 100644
index 000000000000..1ca6c2d11d8b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-disable-device-probe
@@ -0,0 +1,10 @@
+What:		/sys/kernel/disable_device_probe
+Date:		December 2016
+KernelVersion:	4.11
+Contact:	Matthew Garrett <mjg59@srcf.ucam.org>
+Description
+		Disables automatic driver probing of any newly added devices.
+		If "1", driver probing is disabled - any newly added devices
+		will not have a driver bound to them. If "0", newly added
+		devices will be probed, along with any devices connected while
+		"1" was set.
diff --git a/drivers/base/base.h b/drivers/base/base.h
index ada9dce34e6d..7bee2e4e38ce 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -134,8 +134,6 @@ extern void device_remove_groups(struct device *dev,
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
 extern int devres_release_all(struct device *dev);
-extern void device_block_probing(void);
-extern void device_unblock_probing(void);
 
 /* /sys/devices directory */
 extern struct kset *devices_kset;
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index a8b258e5407b..4d70fa41132c 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -191,6 +191,16 @@ static void driver_deferred_probe_trigger(void)
 }
 
 /**
+ * device_probing_deferred() - Get the current state of device probing
+ *
+ *	Returns whether or not device probing is currently deferred
+ */
+bool device_probing_deferred(void)
+{
+	return defer_all_probes;
+}
+
+/**
  * device_block_probing() - Block/defere device's probes
  *
  *	It will disable probing of devices and defer their probes instead.
diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 249e0304597f..b566e7a6140c 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -59,6 +59,8 @@ struct suspend_stats suspend_stats;
 static DEFINE_MUTEX(dpm_list_mtx);
 static pm_message_t pm_transition;
 
+static bool probing_deferred;
+
 static int async_error;
 
 static char *pm_verb(int event)
@@ -1024,8 +1026,12 @@ void dpm_complete(pm_message_t state)
 	list_splice(&list, &dpm_list);
 	mutex_unlock(&dpm_list_mtx);
 
-	/* Allow device probing and trigger re-probing of deferred devices */
-	device_unblock_probing();
+	/*
+	 * Allow device probing and trigger re-probing of deferred devices
+	 * unless userspace has explicitly disabled probing
+	 */
+	if (!probing_deferred)
+		device_unblock_probing();
 	trace_suspend_resume(TPS("dpm_complete"), state.event, false);
 }
 
@@ -1714,8 +1720,12 @@ int dpm_prepare(pm_message_t state)
 	 * hibernation and system behavior will be unpredictable in this case.
 	 * So, let's prohibit device's probing here and defer their probes
 	 * instead. The normal behavior will be restored in dpm_complete().
+	 * Skip this if probing is already deferred, otherwise we'll override
+	 * explicitly configured state.
 	 */
-	device_block_probing();
+	probing_deferred = device_probing_deferred();
+	if (!probing_deferred)
+		device_block_probing();
 
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_list)) {
diff --git a/include/linux/device.h b/include/linux/device.h
index 491b4c0ca633..e7ca593605f6 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -43,6 +43,10 @@ struct iommu_ops;
 struct iommu_group;
 struct iommu_fwspec;
 
+extern bool device_probing_deferred(void);
+extern void device_block_probing(void);
+extern void device_unblock_probing(void);
+
 struct bus_attribute {
 	struct attribute	attr;
 	ssize_t (*show)(struct bus_type *bus, char *buf);
diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index ee1bc1bb8feb..22276140b47c 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -19,6 +19,7 @@
 #include <linux/sched.h>
 #include <linux/capability.h>
 #include <linux/compiler.h>
+#include <linux/device.h>
 
 #include <linux/rcupdate.h>	/* rcu_expedited and rcu_normal */
 
@@ -144,6 +145,32 @@ static ssize_t fscaps_show(struct kobject *kobj,
 }
 KERNEL_ATTR_RO(fscaps);
 
+/* Disable/reenable device probing*/
+static ssize_t disable_device_probe_show(struct kobject *kobj,
+					 struct kobj_attribute *attr,
+					 char *buf)
+{
+	return sprintf(buf, "%d\n", device_probing_deferred());
+}
+
+static ssize_t disable_device_probe_store(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  const char *buf, size_t count)
+{
+	bool disable_probing;
+
+	if (kstrtobool(buf, &disable_probing))
+		return -EINVAL;
+
+	if (disable_probing)
+		device_block_probing();
+	else
+		device_unblock_probing();
+
+	return count;
+}
+KERNEL_ATTR_RW(disable_device_probe);
+
 #ifndef CONFIG_TINY_RCU
 int rcu_expedited;
 static ssize_t rcu_expedited_show(struct kobject *kobj,
@@ -225,6 +252,7 @@ static struct attribute * kernel_attrs[] = {
 	&rcu_expedited_attr.attr,
 	&rcu_normal_attr.attr,
 #endif
+	&disable_device_probe_attr.attr,
 	NULL
 };
 
-- 
2.7.4


-- 
Kees Cook
Nexus Security
