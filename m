Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 3 Jan 2017 15:07:20 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170103230720.GA115084@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Matthew Garrett <mjg59@coreos.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Garrett <mjg59@coreos.com>

Userspace may wish to make a policy decision to allow certain devices
to be attached, such as keyboards. Add a force_probe sysfs node to each
device, which if written will trigger a probe even if defer_all_probes is
currently true.

Signed-off-by: Matthew Garrett <mjg59@coreos.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 .../ABI/testing/sysfs-devices-force_probe          | 10 +++++
 drivers/base/base.h                                |  4 +-
 drivers/base/bus.c                                 |  2 +-
 drivers/base/core.c                                |  7 ++-
 drivers/base/dd.c                                  | 51 ++++++++++++++++++----
 5 files changed, 62 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-force_probe

diff --git a/Documentation/ABI/testing/sysfs-devices-force_probe b/Documentation/ABI/testing/sysfs-devices-force_probe
new file mode 100644
index 000000000000..3a69b9e3b86b
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-force_probe
@@ -0,0 +1,10 @@
+What:		/sys/devices/.../force_probe
+Date:		December 2016
+KernelVersion:	4.11
+Contact:	Matthew Garrett <mjg59@srcf.ucam.org>
+Description:
+		The /sys/devices/.../force_probe attribute is
+		present for all devices. If deferred probing is globally
+		enabled and the device has no driver bound, a write to this
+		node will trigger probing. This attribute reads as 1 if the
+		device currently has a driver bound, and 0 otherwise.
diff --git a/drivers/base/base.h b/drivers/base/base.h
index 7bee2e4e38ce..787ab5b9a16f 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -112,7 +112,8 @@ extern void device_release_driver_internal(struct device *dev,
 					   struct device *parent);
 
 extern void driver_detach(struct device_driver *drv);
-extern int driver_probe_device(struct device_driver *drv, struct device *dev);
+extern int driver_probe_device(struct device_driver *drv, struct device *dev,
+			       bool force);
 extern void driver_deferred_probe_del(struct device *dev);
 static inline int driver_match_device(struct device_driver *drv,
 				      struct device *dev)
@@ -140,6 +141,7 @@ extern struct kset *devices_kset;
 extern void devices_kset_move_last(struct device *dev);
 
 extern struct device_attribute dev_attr_deferred_probe;
+extern struct device_attribute dev_attr_force_probe;
 
 #if defined(CONFIG_MODULES) && defined(CONFIG_SYSFS)
 extern void module_add_driver(struct module *mod, struct device_driver *drv);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 6470eb8088f4..0d4a771abdd9 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -216,7 +216,7 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 		if (dev->parent)	/* Needed for USB */
 			device_lock(dev->parent);
 		device_lock(dev);
-		err = driver_probe_device(drv, dev);
+		err = driver_probe_device(drv, dev, true);
 		device_unlock(dev);
 		if (dev->parent)
 			device_unlock(dev->parent);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 020ea7f05520..0c6469c57de6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1064,8 +1064,13 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_online;
 
-	return 0;
+	error = device_create_file(dev, &dev_attr_force_probe);
+	if (error)
+		goto err_remove_deferred_probe;
 
+	return 0;
+ err_remove_deferred_probe:
+	device_remove_file(dev, &dev_attr_deferred_probe);
  err_remove_online:
 	device_remove_file(dev, &dev_attr_online);
  err_remove_dev_groups:
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4d70fa41132c..8270348b9dc7 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -344,14 +344,15 @@ EXPORT_SYMBOL_GPL(device_bind_driver);
 static atomic_t probe_count = ATOMIC_INIT(0);
 static DECLARE_WAIT_QUEUE_HEAD(probe_waitqueue);
 
-static int really_probe(struct device *dev, struct device_driver *drv)
+static int really_probe(struct device *dev, struct device_driver *drv,
+			bool force)
 {
 	int ret = -EPROBE_DEFER;
 	int local_trigger_count = atomic_read(&deferred_trigger_count);
 	bool test_remove = IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE) &&
 			   !drv->suppress_bind_attrs;
 
-	if (defer_all_probes) {
+	if (defer_all_probes && !force) {
 		/*
 		 * Value of defer_all_probes can be set only by
 		 * device_defer_all_probes_enable() which, in turn, will call
@@ -527,7 +528,8 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  *
  * If the device has a parent, runtime-resume the parent before driver probing.
  */
-int driver_probe_device(struct device_driver *drv, struct device *dev)
+int driver_probe_device(struct device_driver *drv, struct device *dev,
+			bool force)
 {
 	int ret = 0;
 
@@ -542,7 +544,7 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 		pm_runtime_get_sync(dev->parent);
 
 	pm_runtime_barrier(dev);
-	ret = really_probe(dev, drv);
+	ret = really_probe(dev, drv, force);
 	pm_request_idle(dev);
 
 	if (dev->parent)
@@ -600,6 +602,12 @@ struct device_attach_data {
 	 * driver, we'll encounter one that requests asynchronous probing.
 	 */
 	bool have_async;
+
+	/*
+	 * Indicate whether probing should be forced even if defer_all_probes
+	 * is set
+	 */
+	bool force;
 };
 
 static int __device_attach_driver(struct device_driver *drv, void *_data)
@@ -638,7 +646,7 @@ static int __device_attach_driver(struct device_driver *drv, void *_data)
 	if (data->check_async && async_allowed != data->want_async)
 		return 0;
 
-	return driver_probe_device(drv, dev);
+	return driver_probe_device(drv, dev, data->force);
 }
 
 static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
@@ -648,6 +656,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 		.dev		= dev,
 		.check_async	= true,
 		.want_async	= true,
+		.force		= false,
 	};
 
 	device_lock(dev);
@@ -668,7 +677,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 	put_device(dev);
 }
 
-static int __device_attach(struct device *dev, bool allow_async)
+static int __device_attach(struct device *dev, bool allow_async, bool force)
 {
 	int ret = 0;
 
@@ -690,6 +699,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			.dev = dev,
 			.check_async = allow_async,
 			.want_async = false,
+			.force = force,
 		};
 
 		if (dev->parent)
@@ -736,13 +746,36 @@ static int __device_attach(struct device *dev, bool allow_async)
  */
 int device_attach(struct device *dev)
 {
-	return __device_attach(dev, false);
+	return __device_attach(dev, false, false);
 }
 EXPORT_SYMBOL_GPL(device_attach);
 
+/*
+ * Allow userspace to trigger the probing of a device even if driver probing
+ * is currently forcibly deferred
+ */
+static ssize_t force_probe_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int ret;
+
+	ret = __device_attach(dev, false, true);
+	if (ret < 0)
+		return ret;
+	return count;
+}
+
+static ssize_t force_probe_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", device_is_bound(dev));
+}
+DEVICE_ATTR_RW(force_probe);
+
 void device_initial_probe(struct device *dev)
 {
-	__device_attach(dev, true);
+	__device_attach(dev, true, false);
 }
 
 static int __driver_attach(struct device *dev, void *data)
@@ -776,7 +809,7 @@ static int __driver_attach(struct device *dev, void *data)
 		device_lock(dev->parent);
 	device_lock(dev);
 	if (!dev->driver)
-		driver_probe_device(drv, dev);
+		driver_probe_device(drv, dev, false);
 	device_unlock(dev);
 	if (dev->parent)
 		device_unlock(dev->parent);
-- 
2.7.4


-- 
Kees Cook
Nexus Security
