Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 18 Jun 2016 11:03:20 -0700
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160618180320.GA862@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] latent_entropy: provide userspace visibility
To: kernel-hardening@lists.openwall.com
Cc: Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

This is just a toy to look at the latent_entropy value as it changes
from userspace. Not intended for actual use...

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/ksysfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
index 152da4a48867..64aed735098a 100644
--- a/kernel/ksysfs.c
+++ b/kernel/ksysfs.c
@@ -180,6 +180,15 @@ static ssize_t rcu_normal_store(struct kobject *kobj,
 KERNEL_ATTR_RW(rcu_normal);
 #endif /* #ifndef CONFIG_TINY_RCU */
 
+#ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
+static ssize_t latent_entropy_show(struct kobject *kobj,
+				   struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%08llx\n", latent_entropy);
+}
+KERNEL_ATTR_RO(latent_entropy);
+#endif
+
 /*
  * Make /sys/kernel/notes give the raw contents of our kernel .notes section.
  */
@@ -225,6 +234,9 @@ static struct attribute * kernel_attrs[] = {
 	&rcu_expedited_attr.attr,
 	&rcu_normal_attr.attr,
 #endif
+#ifdef CONFIG_GCC_PLUGIN_LATENT_ENTROPY
+	&latent_entropy_attr.attr,
+#endif
 	NULL
 };
 
-- 
2.7.4


-- 
Kees Cook
Chrome OS & Brillo Security
