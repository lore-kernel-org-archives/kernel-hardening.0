Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Fri, 19 Feb 2016 00:24:22 +0100
Message-Id: <1455837862-24189-3-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1455837862-24189-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1455837862-24189-1-git-send-email-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 2/2] compiler.h: add __format_template
To: kernel-hardening@lists.openwall.com
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

Most format strings in the kernel are explicit string literals at the
use site and can thus be checked by gcc and other static
checkers. There are cases, however, where the format string comes from
some struct member and is implicitly assumed to contain certain
specifiers.

A gcc plugin provides the attribute format_template for that case. One
attaches the attribute to the struct member in question, providing a
template consisting of the expected format specifiers. The plugin then
checks that all static initializations of that struct member is
consistent with the template; moreover, when the format string in a
printf-like function call comes from such an annotated struct member,
one cannot do static analysis of the actual runtime string, but one
can check that the template is consistent with the actual arguments.

Apply the attribute to a few struct members:

struct smp_hotplug_thread::thread_comm
struct usb_class_driver::name
struct applesmc_node_group::format
struct num_var_t::synth_fmt

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/hwmon/applesmc.c            | 2 +-
 drivers/staging/speakup/spk_types.h | 2 +-
 include/linux/compiler.h            | 7 +++++++
 include/linux/smpboot.h             | 2 +-
 include/linux/usb.h                 | 2 +-
 5 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 0af7fd311979..44fb97e5cfcd 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -110,7 +110,7 @@ struct applesmc_dev_attr {
 
 /* Dynamic device node group */
 struct applesmc_node_group {
-	char *format;				/* format string */
+	char *format __format_template("%d");	/* format string */
 	void *show;				/* show function */
 	void *store;				/* store function */
 	int option;				/* function argument */
diff --git a/drivers/staging/speakup/spk_types.h b/drivers/staging/speakup/spk_types.h
index e8ff5d7d6419..55a479cd5868 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -109,7 +109,7 @@ struct st_var_header {
 };
 
 struct num_var_t {
-	char *synth_fmt;
+	char *synth_fmt __format_template("%d");
 	int default_val;
 	int low;
 	int high;
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 48f5aab117ae..85d2ddee88d5 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -552,4 +552,11 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 # define __kprobes
 # define nokprobe_inline	inline
 #endif
+
+#ifdef HAVE_ATTRIBUTE_FORMAT_TEMPLATE
+#define __format_template(x) __attribute__((__format_template__(x)))
+#else
+#define __format_template(x)
+#endif
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 12910cf19869..4c02dcec37d5 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -41,7 +41,7 @@ struct smp_hotplug_thread {
 	void				(*unpark)(unsigned int cpu);
 	cpumask_var_t			cpumask;
 	bool				selfparking;
-	const char			*thread_comm;
+	const char			*thread_comm __format_template("foobar/%u");
 };
 
 int smpboot_register_percpu_thread_cpumask(struct smp_hotplug_thread *plug_thread,
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 89533ba38691..af3ca313fd03 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1162,7 +1162,7 @@ extern struct bus_type usb_bus_type;
  * parameters used for them.
  */
 struct usb_class_driver {
-	char *name;
+	char *name __format_template("foobar_%d");
 	char *(*devnode)(struct device *dev, umode_t *mode);
 	const struct file_operations *fops;
 	int minor_base;
-- 
2.1.4
