Date: Wed, 15 Feb 2017 12:57:35 +0530
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Message-ID: <20170215125735.17920d58@kaiwan-T460>
In-Reply-To: <CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460>
	<90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
	<20170203101949.4c6908be@kaiwan-T460>
	<CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
	<20170209090714.63ce6333@kaiwan-T460>
	<CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
	<CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
	<CAGXu5jLPrxc5dcB3HYF+D7WceQEJA8BrSn5py-o1NDzsRJR9ZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Okay, I've incorporated your suggestions. 
Of course, the printk's are temporary. 

Pl see:
- the updated patch, and
- a 'truth table' enumerating some basic testing with these configs,
below:

---
diff --git a/init/main.c b/init/main.c
index ef47035..ba44574 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1028,6 +1028,11 @@ static noinline void __init kernel_init_freeable(void)
 
 	do_basic_setup();
 
+#ifdef CONFIG_MEMORY_SANITIZE
+	pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
+		page_poisoning_enabled() ? "yes" : "no");
+#endif
+
 	/* Open the /dev/console on the rootfs, this should never fail */
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
 		pr_err("Warning: unable to open an initial console.\n");
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 3e5eada..fbb4290 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -97,3 +97,24 @@ config DEBUG_RODATA_TEST
     ---help---
       This option enables a testcase for the setting rodata read-only.
 
+config MEMORY_SANITIZE
+    bool "Enable memory sanitization features"
+    select SLUB_DEBUG
+    select PAGE_POISONING
+    select PAGE_POISONING_NO_SANITY
+    ---help---
+       This option enables memory sanitization features. Particularly,
+       when you turn on this option, it auto-enables:
+       - SLUB debug
+       - page poisoning
+       - page poisoning no sanity.
+
+       Implication: turning this option on _will_ implicitly enable:
+       - the SLUB_DEBUG switch to the equivalent of the kernel command-line
+         'slub_debug=p' ; (where p=PAGE_POISON),
+       - page poisoning, equivalent to passing the kernel command-line option
+         'page_poison=on',
+       irrespective of whether the options are explicitly passed or not.
+
+       If unsure, say N.
+
diff --git a/mm/page_poison.c b/mm/page_poison.c
index 2e647c6..8d1e883 100644
--- a/mm/page_poison.c
+++ b/mm/page_poison.c
@@ -49,6 +49,17 @@ struct page_ext_operations page_poisoning_ops = {
 	.init = init_page_poisoning,
 };
 
+static int __init memory_sanitize_pagepoison_init(void)
+{
+	/* With 'memory sanitize' On, page poisoning Must be turned on */
+	if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
+		want_page_poisoning = true;
+		__page_poisoning_enabled = true;
+	}
+	return 0;
+}
+early_initcall(memory_sanitize_pagepoison_init);
+
 static inline void set_page_poison(struct page *page)
 {
 	struct page_ext *page_ext;
diff --git a/mm/slub.c b/mm/slub.c
index d24e1ce..62de543 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -457,6 +457,17 @@ static int slub_debug;
 static char *slub_debug_slabs;
 static int disable_higher_order_debug;
 
+static int __init memory_sanitize_slubdebug_init(void)
+{
+/* With 'memory sanitize' On, slub_debug Must be set to 'p' */
+	if (IS_ENABLED(CONFIG_SLUB_DEBUG_ON) &&
+	     IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
+		slub_debug |= SLAB_POISON;
+	}
+	return 0;
+}
+early_initcall(memory_sanitize_slubdebug_init);
+
 /*
  * slub is about to manipulate internal object metadata.  This memory lies
  * outside the range of the allocated object, so accessing it would normally
@@ -5675,6 +5686,11 @@ static int __init slab_sysfs_init(void)
 	struct kmem_cache *s;
 	int err;
 
+#ifdef CONFIG_MEMORY_SANITIZE
+	pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug = P? %s [0x%x]\n",
+		slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
+#endif
+
 	mutex_lock(&slab_mutex);
 
 	slab_kset = kset_create_and_add("slab", &slab_uevent_ops, kernel_kobj);

---
(Minimal) Testing done so far:
-------------------------------+----------------------+-----------------------
|         Kconfig              |     kernel cmdline   |        Result*       |
|--------------+---------------+----------------------+----------------------|
SLUB_DEBUG[_ON]|MEMORY_SANITIZE|page_poison|slub_debug|page_poison|slub_debug|
|--------------+---------------+----------------------+----------------------|
      Y        |         Y     |     np[1] |    np    |     on    |     p    |
      Y        |         Y     |     np[1] |    =p    |     on    |     p    |
      Y        |         Y     |     np[1] |    =fzu  |     on    |     p    |
      Y        |         Y     |     np[1] |    =fzup |     on    |     p    |
      Y        |         Y     |     np[1] |    =     |     on    |     p    |
|--------------+---------------+----------------------+----------------------|
      Y        |         Y     |     =off  |    np    |     on    |     p    |
      Y        |         Y     |     =off  |    =p    |     on    |     p    |
      Y        |         Y     |     =off  |    =fzu  |     on    |     p    |
      Y        |         Y     |     =off  |    =     |     on    |     p    |
|--------------+---------------+----------------------+----------------------|
      Y        |         Y     |     =on   |    np    |     on    |     p    |
      Y        |         Y     |     =on   |    =p    |     on    |     p    |
      Y        |         Y     |     =on   |    =fzu  |     on    |     p    |
      Y        |         Y     |     =on   |    =     |     on    |     p    |
|--------------+---------------+----------------------+----------------------|
[1] np = not passed
* Result: MEMORY_SANITIZE='y' => page_poison should be 'on' and slub_debug='p'
  (implying SLAB_POISON bit set).
So far, all tests passed..

Thanks,
Kaiwan.

On Tue, 14 Feb 2017 09:19:27 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Feb 13, 2017 at 7:01 PM, Kaiwan N Billimoria
> <kaiwan@kaiwantech.com> wrote:
> > Thanks for your response...  
> >>
> >>
> >>  
> >> > +config MEMORY_SANITIZE
> >> > +       bool "Enable memory sanitization features"
> >> > +       select SLUB_DEBUG
> >> > +       select PAGE_POISONING
> >> > +       select PAGE_POISONING_NO_SANITY if HIBERNATION
> >> > +       ---help---
> >> > +       This option enables ...  
> >>
> >> Good start! Why the "if HIBERNATION" bit? It seems like sanity
> >> checks are very expensive, so we'd not want it as part of this
> >> config? 
> > Okay, I wasn't sure. So would it be (more) correct to retain the
> > first two configs plus
> > PAGE_POISONING_NO_SANITY (without the if)?  
> 
> I think so, yes. We may need to tweak it in the future, but I think
> that's the correct config for now.
> 
> >> >  #if defined(CONFIG_SLUB_DEBUG_ON)
> >> > +#if defined(CONFIG_MEMORY_SANITIZE)
> >> > +/* With 'memory sanitize' On, slub_debug should be 'P' */
> >> > +static int slub_debug = SLAB_POISON;
> >> > +#else
> >> >  static int slub_debug = DEBUG_DEFAULT_FLAGS;
> >> > +#endif /* CONFIG_MEMORY_SANITIZE */
> >> >  #else
> >> >  static int slub_debug;
> >> > -#endif
> >> > +#endif /* CONFIG_SLUB_DEBUG_ON */  
> >>
> >> Could the definition of DEBUG_DEFAULT_FLAGS be adjusted instead of
> >> doing the ifdefs here in the .c file? Or, perhaps do a slub_debug
> >> |= SLAB_POISON in memory_sanitize_init()?
> >>  
> > Yes, the latter sounds good but the init function is in
> > mm/page_poison.c and the slub_debug var is a static in mm/slub.c .
> > Any suggestions?  
> 
> Perhaps add another early_init like you did the page_poison.c?
> 
> -Kees
> 
