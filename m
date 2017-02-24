Date: Fri, 24 Feb 2017 15:08:24 +0530
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Message-ID: <20170224150824.7a05de6d@kaiwan-T460>
In-Reply-To: <CAGXu5jKTkN82UKY8HQKoKTCvqztksOraX43MKm=JXPKgpM1Bcw@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460>
	<90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
	<20170203101949.4c6908be@kaiwan-T460>
	<CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
	<20170209090714.63ce6333@kaiwan-T460>
	<CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
	<CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
	<CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com>
	<20170215125735.17920d58@kaiwan-T460>
	<CAGXu5jLRyDQ9M209JyNQRm3M+4ZtzdE9W0=7S7aXqSMavFZi1A@mail.gmail.com>
	<CAPDLWs_aEURmQ2Drz_AWsPXC-Xi2Q36HG4p-ZTVmx5+ZX4bdHA@mail.gmail.com>
	<CAGXu5jKTkN82UKY8HQKoKTCvqztksOraX43MKm=JXPKgpM1Bcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 21 Feb 2017 15:26:03 -0800
Kees Cook <keescook@chromium.org> wrote:

> I think mem_sanitize should likely follow the logic used by
> pax_sanitize_slab. i.e CONFIG_MEMORIZE_SANITIZE as suggested above,
> then a mem_sanitize= option for "off" and "full". (i.e.
> CONFIG_MEMORIZE_SANITIZE implies "on")
> 
> -Kees
> 

Okay. So, while I found that the (pseudo)code you quickly mentioned did not 
exactly work out, I have (hopefully) implemented the idea. 

A qs: currently, the slub_debug option gets set to 'p' as long as MEMORY_SANITIZE 
is enabled, even if the user passes 'slub_debug=-' on the command line. Is this ok?

Pl review the patch below:

diff --git a/init/main.c b/init/main.c
index 63d640e..4397a11 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1027,6 +1027,11 @@ static noinline void __init kernel_init_freeable(void)
 
	 do_basic_setup();
 
+#ifdef CONFIG_MEMORY_SANITIZE
+    pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
+   	 page_poisoning_enabled() ? "yes" : "no");
+#endif
+
	 /* Open the /dev/console on the rootfs, this should never fail */
	 if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
		 pr_err("Warning: unable to open an initial console.\n");
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 3c88b7e..e8aa61d 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -97,3 +97,25 @@ config DEBUG_RODATA_TEST
 	---help---
   	This option enables a testcase for the setting rodata read-only.
 
+config MEMORY_SANITIZE
+	bool "Enable memory sanitization features"
+	select SLUB_DEBUG
+	select PAGE_POISONING
+	select PAGE_POISONING_NO_SANITY
+	---help---
+   	This option enables memory sanitization features. Particularly,
+   	when you turn on this option, it auto-enables:
+   	- SLUB debug
+   	- page poisoning
+   	- page poisoning no sanity.
+
+   	Implication: turning this option on _will_ implicitly enable:
+   	- the SLUB_DEBUG switch to the equivalent of the kernel command-line
+     	'slub_debug=p' ; (where p=SLAB_POISON),
+   	- page poisoning, equivalent to passing the kernel command-line option
+     	'page_poison=on'.
+    Of course, kernel command-line options 'page_poison' and 'slub_debug'
+    are still honoured (except that slub-debug will always have the 'p' set).
+
+   	If unsure, say N.
+
diff --git a/mm/page_poison.c b/mm/page_poison.c
index 2e647c6..0ca3bc5 100644
--- a/mm/page_poison.c
+++ b/mm/page_poison.c
@@ -7,7 +7,8 @@
 #include <linux/ratelimit.h>
 
 static bool __page_poisoning_enabled __read_mostly;
-static bool want_page_poisoning __read_mostly;
+static bool want_page_poisoning __read_mostly =
+   	 IS_ENABLED(CONFIG_MEMORY_SANITIZE);
 
 static int early_page_poison_param(char *buf)
 {
@@ -49,6 +50,17 @@ struct page_ext_operations page_poisoning_ops = {
	 .init = init_page_poisoning,
 };
 
+static int __init memory_sanitize_pagepoison_init(void)
+{
+     */
+    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE) && !want_page_poisoning)
+   	 __page_poisoning_enabled = false;
+    return 0;
+}
+early_initcall(memory_sanitize_pagepoison_init);
+
 static inline void set_page_poison(struct page *page)
 {
	 struct page_ext *page_ext;
diff --git a/mm/slub.c b/mm/slub.c
index 7f4bc70..76abcec 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -450,15 +450,30 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
 /*
  * Debug settings:
  */
-#if defined(CONFIG_SLUB_DEBUG_ON)
-static int slub_debug = DEBUG_DEFAULT_FLAGS;
-#else
 static int slub_debug;
-#endif
 
 static char *slub_debug_slabs;
 static int disable_higher_order_debug;
 
+static int __init memory_sanitize_slubdebug_init(void)
+{
+/* With MEMORY_SANITIZE On, slub_debug Must be set to 'p' */
+    if (IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
+     	IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
+   	 slub_debug |= SLAB_POISON;
+    } else if (!IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
+     	IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
+   	 slub_debug = SLAB_POISON;
+    } else if (IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
+     	!IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
+   	 slub_debug = DEBUG_DEFAULT_FLAGS;
+    } else { /* both disabled */
+   	 slub_debug = 0;
+    }
+    return 0;
+}
+early_initcall(memory_sanitize_slubdebug_init);
+
 /*
  * slub is about to manipulate internal object metadata.  This memory lies
  * outside the range of the allocated object, so accessing it would normally
@@ -5755,6 +5770,11 @@ static int __init slab_sysfs_init(void)
	 struct kmem_cache *s;
	 int err;
 
+#ifdef CONFIG_MEMORY_SANITIZE
+    pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug = P? %s [0x%x]\n",
+   	 slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
+#endif
+
	 mutex_lock(&slab_mutex);
 
	 slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);


Thanks,
Kaiwan.
