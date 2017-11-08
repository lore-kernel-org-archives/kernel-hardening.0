From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  8 Nov 2017 23:30:16 +0100
Message-Id: <20171108223020.24487-3-linux@rasmusvillemoes.dk>
In-Reply-To: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 2/6] compiler.h: add __format_template
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
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

Modifying kernel/softirq.c slightly, this is what one gets if one
violates the template:

kernel/softirq.c:751:1: error: initializer string 'ksoftirqd/%u+%d' contains extra format specifier '%d' compared to format template 'foobar/%u'

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/hwmon/applesmc.c            | 2 +-
 drivers/staging/speakup/spk_types.h | 2 +-
 include/linux/compiler.h            | 6 ++++++
 include/linux/smpboot.h             | 2 +-
 include/linux/usb.h                 | 2 +-
 5 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 5c677ba44014..9e6d23cba23e 100644
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
index c50de6035a9a..156000c0c4d3 100644
--- a/drivers/staging/speakup/spk_types.h
+++ b/drivers/staging/speakup/spk_types.h
@@ -108,7 +108,7 @@ struct st_var_header {
 };
 
 struct num_var_t {
-	char *synth_fmt;
+	char *synth_fmt __format_template("%d");
 	int default_val;
 	int low;
 	int high;
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 202710420d6d..478914ad280b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -625,4 +625,10 @@ static __always_inline void __write_once_size(volatile void *p, void *res, int s
 	(_________p1); \
 })
 
+#ifdef HAVE_ATTRIBUTE_FORMAT_TEMPLATE
+#define __format_template(x) __attribute__((__format_template__(x)))
+#else
+#define __format_template(x)
+#endif
+
 #endif /* __LINUX_COMPILER_H */
diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index c174844cf663..967285b9637d 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -42,7 +42,7 @@ struct smp_hotplug_thread {
 	void				(*unpark)(unsigned int cpu);
 	cpumask_var_t			cpumask;
 	bool				selfparking;
-	const char			*thread_comm;
+	const char			*thread_comm __format_template("foobar/%u");
 };
 
 int smpboot_register_percpu_thread_cpumask(struct smp_hotplug_thread *plug_thread,
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 9c63792a8134..8d48c0cd1c01 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -1236,7 +1236,7 @@ extern struct bus_type usb_bus_type;
  * parameters used for them.
  */
 struct usb_class_driver {
-	char *name;
+	char *name __format_template("foobar_%d");
 	char *(*devnode)(struct device *dev, umode_t *mode);
 	const struct file_operations *fops;
 	int minor_base;
-- 
2.11.0
