Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 25 Jun 2011 21:07:52 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110625170752.GA10458@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] acpi: constify ops structs
To: Len Brown <lenb@kernel.org>
Cc: kernel-hardening@lists.openwall.com, Shaohua Li <shaohua.li@intel.com>, Zhang Rui <rui.zhang@intel.com>, Jeff Garzik <jgarzik@pobox.com>, Jesse Barnes <jbarnes@virtuousgeek.org>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Structs battery_file, acpi_dock_ops, file_operations,
thermal_cooling_device_ops, thermal_zone_device_ops, kernel_param_ops
are not changed in runtime.  It is safe to make them const.
register_hotplug_dock_device() was altered to take const "ops" argument
to respect acpi_dock_ops' const notion.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---

 Len, I think it can be applied as a single patch to acpi tree as the
 only non-acpi thing is acpi_dock_ops in ata/ and pci/, which is really
 trivial.

 drivers/acpi/battery.c             |    2 +-
 drivers/acpi/dock.c                |    4 ++--
 drivers/acpi/ec_sys.c              |    2 +-
 drivers/acpi/fan.c                 |    2 +-
 drivers/acpi/processor_thermal.c   |    2 +-
 drivers/acpi/sysfs.c               |    4 ++--
 drivers/acpi/thermal.c             |    2 +-
 drivers/acpi/video.c               |    2 +-
 drivers/ata/libata-acpi.c          |    4 ++--
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_drivers.h        |    2 +-
 include/acpi/processor.h           |    2 +-
 12 files changed, 15 insertions(+), 15 deletions(-)

---
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index fcc13ac..746b475 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -863,7 +863,7 @@ DECLARE_FILE_FUNCTIONS(alarm);
 		}, \
 	}
 
-static struct battery_file {
+static const struct battery_file {
 	struct file_operations ops;
 	mode_t mode;
 	const char *name;
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 1864ad3..19a6113 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -77,7 +77,7 @@ struct dock_dependent_device {
 	struct list_head list;
 	struct list_head hotplug_list;
 	acpi_handle handle;
-	struct acpi_dock_ops *ops;
+	const struct acpi_dock_ops *ops;
 	void *context;
 };
 
@@ -589,7 +589,7 @@ EXPORT_SYMBOL_GPL(unregister_dock_notifier);
  * the dock driver after _DCK is executed.
  */
 int
-register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
+register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops,
 			     void *context)
 {
 	struct dock_dependent_device *dd;
diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 05b4420..22f918b 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -92,7 +92,7 @@ static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
 	return count;
 }
 
-static struct file_operations acpi_ec_io_ops = {
+static const struct file_operations acpi_ec_io_ops = {
 	.owner = THIS_MODULE,
 	.open  = acpi_ec_open_io,
 	.read  = acpi_ec_read_io,
diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index 467479f..0f0356c 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -110,7 +110,7 @@ fan_set_cur_state(struct thermal_cooling_device *cdev, unsigned long state)
 	return result;
 }
 
-static struct thermal_cooling_device_ops fan_cooling_ops = {
+static const struct thermal_cooling_device_ops fan_cooling_ops = {
 	.get_max_state = fan_get_max_state,
 	.get_cur_state = fan_get_cur_state,
 	.set_cur_state = fan_set_cur_state,
diff --git a/drivers/acpi/processor_thermal.c b/drivers/acpi/processor_thermal.c
index 79cb653..870550d 100644
--- a/drivers/acpi/processor_thermal.c
+++ b/drivers/acpi/processor_thermal.c
@@ -244,7 +244,7 @@ processor_set_cur_state(struct thermal_cooling_device *cdev,
 	return result;
 }
 
-struct thermal_cooling_device_ops processor_cooling_ops = {
+const struct thermal_cooling_device_ops processor_cooling_ops = {
 	.get_max_state = processor_get_max_state,
 	.get_cur_state = processor_get_cur_state,
 	.set_cur_state = processor_set_cur_state,
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 77255f2..c538d0e 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -149,12 +149,12 @@ static int param_get_debug_level(char *buffer, const struct kernel_param *kp)
 	return result;
 }
 
-static struct kernel_param_ops param_ops_debug_layer = {
+static const struct kernel_param_ops param_ops_debug_layer = {
 	.set = param_set_uint,
 	.get = param_get_debug_layer,
 };
 
-static struct kernel_param_ops param_ops_debug_level = {
+static const struct kernel_param_ops param_ops_debug_level = {
 	.set = param_set_uint,
 	.get = param_get_debug_level,
 };
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 2607e17..48fbc64 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -812,7 +812,7 @@ acpi_thermal_unbind_cooling_device(struct thermal_zone_device *thermal,
 				thermal_zone_unbind_cooling_device);
 }
 
-static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
+static const struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.bind = acpi_thermal_bind_cooling_device,
 	.unbind	= acpi_thermal_unbind_cooling_device,
 	.get_temp = thermal_get_temp,
diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index db39e9e..c6f9ef8 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -308,7 +308,7 @@ video_set_cur_state(struct thermal_cooling_device *cooling_dev, unsigned long st
 	return acpi_video_device_lcd_set_level(video, level);
 }
 
-static struct thermal_cooling_device_ops video_cooling_ops = {
+static const struct thermal_cooling_device_ops video_cooling_ops = {
 	.get_max_state = video_get_max_state,
 	.get_cur_state = video_get_cur_state,
 	.set_cur_state = video_set_cur_state,
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index a791b8c..993d406 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -218,12 +218,12 @@ static void ata_acpi_dev_uevent(acpi_handle handle, u32 event, void *data)
 	ata_acpi_uevent(dev->link->ap, dev, event);
 }
 
-static struct acpi_dock_ops ata_acpi_dev_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_dev_dock_ops = {
 	.handler = ata_acpi_dev_notify_dock,
 	.uevent = ata_acpi_dev_uevent,
 };
 
-static struct acpi_dock_ops ata_acpi_ap_dock_ops = {
+static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.handler = ata_acpi_ap_notify_dock,
 	.uevent = ata_acpi_ap_uevent,
 };
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index a70fa89..2202857 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -110,7 +110,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 }
 
 
-static struct acpi_dock_ops acpiphp_dock_ops = {
+static const struct acpi_dock_ops acpiphp_dock_ops = {
 	.handler = handle_hotplug_event_func,
 };
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 3090471..e49c36d 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -128,7 +128,7 @@ extern int is_dock_device(acpi_handle handle);
 extern int register_dock_notifier(struct notifier_block *nb);
 extern void unregister_dock_notifier(struct notifier_block *nb);
 extern int register_hotplug_dock_device(acpi_handle handle,
-					struct acpi_dock_ops *ops,
+					const struct acpi_dock_ops *ops,
 					void *context);
 extern void unregister_hotplug_dock_device(acpi_handle handle);
 #else
diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index ba4928c..67055f1 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -337,7 +337,7 @@ extern struct cpuidle_driver acpi_idle_driver;
 
 /* in processor_thermal.c */
 int acpi_processor_get_limit_info(struct acpi_processor *pr);
-extern struct thermal_cooling_device_ops processor_cooling_ops;
+extern const struct thermal_cooling_device_ops processor_cooling_ops;
 #ifdef CONFIG_CPU_FREQ
 void acpi_thermal_cpufreq_init(void);
 void acpi_thermal_cpufreq_exit(void);
---
-- 
Vasiliy
