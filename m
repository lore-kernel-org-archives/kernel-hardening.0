Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAPDLWs_82o5cQ24=pSO6hT8KtQHkNGz5S-gUf5e647QUX+t2QA@mail.gmail.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
 <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com>
 <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com>
 <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
 <CAPDLWs8dMyk3CGpt49w0Nyd59ZDDOSMz87vkm5k7NkObAZNzog@mail.gmail.com>
 <20170112073746.GA23596@kroah.com> <CAPDLWs_aUbt3Vdg1avkoSq_Gpr19TQ2hhrhA1G6-THAXUP07jQ@mail.gmail.com>
 <CAPDLWs_82o5cQ24=pSO6hT8KtQHkNGz5S-gUf5e647QUX+t2QA@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Tue, 17 Jan 2017 13:14:06 +0530
Message-ID: <CAPDLWs_XPxVQU7YtNXpAu4zo_BJ0CH3HtF8Wh70rX2EOBCGwYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Also, I just wanted to say, I do realize that the above is not in the
_correct_ / acceptable patch format (email type / signed-off-by not
done /etc).

It's really not meant to be a patch at all - just for me to obtain
feedback if am proceeding in the right direction (if not manner) :-)
So apologies in advance to anyone offended by the 'dirty' patch!

Regards,
Kaiwan.

Kaiwan N Billimoria
=E2=9C=89 kaiwan@kaiwantech.com
=E2=9C=89 kaiwan.billimoria@gmail.com

kaiwanTECH
http://kaiwantech.in
Do visit our enhanced website.

4931, 11th Floor, Highpoint IV, 45 Palace Road, Bangalore 560 001.
=E2=98=8E +91.9845016788 (M)
=E2=98=8E TeleFax: +91.80.22389396 | Alt. Tel: +91.80.64500257

LinkedIn: https://in.linkedin.com/in/kaiwanbillimoria

I blog here:
Tech : http://kaiwantech.wordpress.com  |
Running : http://kaiwanbill.blogspot.in/

"Don't be afraid that your life will end,
be afraid that it will never begin."


On Tue, Jan 17, 2017 at 1:08 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Hi Kees,
>
> I've made a start. Hopefully, in the right direction too!
>
> So, basically what I've done so far is:
>  - pulled in the linux-next tree, and setup my own branch
> - taken the grsecurity patch (for 4.8.17) and merged those portions of
> the code encompassing the  CONFIG_PAX_MEMORY_SANITIZE directive
> - done small fixups where required
>
> [More on this:
> 1. fs/dcache.c
>   kmem_cache_create_usercopy() unavailable (for now at least).
> Probably part of other grsec infrastructure..
>  So am just adding the SLAB_NO_SANITIZE flag to the usual
> kmem_cache_create() call.
>
> 2. mm/slab_common.c
> Compile failure:
> enum pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE_SLA=
B_FAST;
>
> ?? -above orig statement from the grsec-4.8.17 patch fails compile with:
> mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=
=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
> =E2=80=98__attribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
>
> So I've just removed the "__read_only" attribute for now.
> What's the actual approach?
>
> 3. mm/slub.c
> Compile failure:
> #ifdef CONFIG_PAX_MEMORY_SANITIZE
>  &sanitize_attr.attr,
>  * ?? -above statement from the grsec-4.8.17 patch fails compile with:
>  mm/slub.c:5337:3: error: =E2=80=98sanitize_attr=E2=80=99 undeclared here=
 (not in a function)
>   &sanitize_attr.attr,
>
> Just commented this out for now.
> ]
>
> Below pl find the initial patch reg the work done so far:
>
> ---
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 28484b3..b524eda 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3511,7 +3511,7 @@ void __init buffer_init(void)
>   bh_cachep =3D kmem_cache_create("buffer_head",
>   sizeof(struct buffer_head), 0,
>   (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
> - SLAB_MEM_SPREAD),
> + SLAB_MEM_SPREAD|SLAB_NO_SANITIZE),
>   NULL);
>
>   /*
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 95d71ed..77abd2f 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -3616,8 +3616,16 @@ void __init vfs_caches_init_early(void)
>
>  void __init vfs_caches_init(void)
>  {
> +/**
> + names_cachep =3D kmem_cache_create_usercopy("names_cache", PATH_MAX, 0,
> + SLAB_HWCACHE_ALIGN|SLAB_PANIC| SLAB_NO_SANITIZE,
> + 0, PATH_MAX, NULL);
> + kmem_cache_create_usercopy() unavailable for now at least.
> + So just adding the SLAB_NO_SANITIZE flag to the usual call below..
> + */
>   names_cachep =3D kmem_cache_create("names_cache", PATH_MAX, 0,
> - SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> + SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NO_SANITIZE, NULL);
> +
>
>   dcache_init();
>   inode_init();
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index bb3f329..9daed55 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -190,6 +190,18 @@ static inline void clear_highpage(struct page *page)
>   kunmap_atomic(kaddr);
>  }
>
> +static inline void sanitize_highpage(struct page *page)
> +{
> + void *kaddr;
> + unsigned long flags;
> +
> + local_irq_save(flags);
> + kaddr =3D kmap_atomic(page);
> + clear_page(kaddr);
> + kunmap_atomic(kaddr);
> + local_irq_restore(flags);
> +}
> +
>  static inline void zero_user_segments(struct page *page,
>   unsigned start1, unsigned end1,
>   unsigned start2, unsigned end2)
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 4c53635..334bd89 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -23,6 +23,13 @@
>  #define SLAB_CONSISTENCY_CHECKS 0x00000100UL /* DEBUG: Perform
> (expensive) checks on alloc/free */
>  #define SLAB_RED_ZONE 0x00000400UL /* DEBUG: Red zone objs in a cache */
>  #define SLAB_POISON 0x00000800UL /* DEBUG: Poison objects */
> +
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> +#define SLAB_NO_SANITIZE 0x00001000UL /* PaX: Do not sanitize objs on fr=
ee */
> +#else
> +#define SLAB_NO_SANITIZE 0x00000000UL
> +#endif
> +
>  #define SLAB_HWCACHE_ALIGN 0x00002000UL /* Align objs on cache lines */
>  #define SLAB_CACHE_DMA 0x00004000UL /* Use GFP_DMA memory */
>  #define SLAB_STORE_USER 0x00010000UL /* DEBUG: Store the last owner
> for bug hunting */
> diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> index 4ad2c5a..a30bbd2 100644
> --- a/include/linux/slab_def.h
> +++ b/include/linux/slab_def.h
> @@ -60,6 +60,10 @@ struct kmem_cache {
>   atomic_t allocmiss;
>   atomic_t freehit;
>   atomic_t freemiss;
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + atomic_unchecked_t sanitized;
> + atomic_unchecked_t not_sanitized;
> +#endif
>  #ifdef CONFIG_DEBUG_SLAB_LEAK
>   atomic_t store_user_clean;
>  #endif
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 7da33cb..24404a6 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2098,7 +2098,7 @@ void __init proc_caches_init(void)
>   sizeof(struct mm_struct), ARCH_MIN_MMSTRUCT_ALIGN,
>   SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT,
>   NULL);
> - vm_area_cachep =3D KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACCOUNT);
> + vm_area_cachep =3D KMEM_CACHE(vm_area_struct,
> SLAB_PANIC|SLAB_ACCOUNT|SLAB_NO_SANITIZE);
>   mmap_init();
>   nsproxy_cache_init();
>  }
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index afcc550..ed3f097 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -10,6 +10,7 @@ config PAGE_EXTENSION
>  config DEBUG_PAGEALLOC
>   bool "Debug page memory allocations"
>   depends on DEBUG_KERNEL
> + depends on !PAX_MEMORY_SANITIZE
>   depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC && !PPC && !SP=
ARC
>   depends on !KMEMCHECK
>   select PAGE_EXTENSION
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 21ea508..d7b3d95 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -994,6 +994,10 @@ static __always_inline bool
> free_pages_prepare(struct page *page,
>  {
>   int bad =3D 0;
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + unsigned long index =3D 1UL << order;
> +#endif
> +
>   VM_BUG_ON_PAGE(PageTail(page), page);
>
>   trace_mm_page_free(page, order);
> @@ -1040,6 +1044,12 @@ static __always_inline bool
> free_pages_prepare(struct page *page,
>   debug_check_no_obj_freed(page_address(page),
>     PAGE_SIZE << order);
>   }
> +
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + for (; index; --index)
> + sanitize_highpage(page + index - 1);
> +#endif
> +
>   arch_free_page(page, order);
>   kernel_poison_pages(page, 1 << order, 0);
>   kernel_map_pages(page, 1 << order, 0);
> @@ -1696,8 +1706,9 @@ static inline int check_new_page(struct page *page)
>
>  static inline bool free_pages_prezeroed(bool poisoned)
>  {
> - return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
> - page_poisoning_enabled() && poisoned;
> + return IS_ENABLED(CONFIG_PAX_MEMORY_SANITIZE) ||
> + (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) && page_poisoning_enabled()
> && poisoned);
> +
>  }
>
>  #ifdef CONFIG_DEBUG_VM
> @@ -1753,11 +1764,13 @@ static void prep_new_page(struct page *page,
> unsigned int order, gfp_t gfp_flags
>   int i;
>   bool poisoned =3D true;
>
> +#ifndef CONFIG_PAX_MEMORY_SANITIZE
>   for (i =3D 0; i < (1 << order); i++) {
>   struct page *p =3D page + i;
>   if (poisoned)
>   poisoned &=3D page_is_poisoned(p);
>   }
> +#endif
>
>   post_alloc_hook(page, order, gfp_flags);
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 91619fd..c97da9e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -428,10 +428,10 @@ static void anon_vma_ctor(void *data)
>  void __init anon_vma_init(void)
>  {
>   anon_vma_cachep =3D kmem_cache_create("anon_vma", sizeof(struct anon_vm=
a),
> - 0, SLAB_DESTROY_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
> + 0, SLAB_DESTROY_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT|SLAB_NO_SANITIZE,
>   anon_vma_ctor);
>   anon_vma_chain_cachep =3D KMEM_CACHE(anon_vma_chain,
> - SLAB_PANIC|SLAB_ACCOUNT);
> + SLAB_PANIC|SLAB_ACCOUNT|SLAB_NO_SANITIZE);
>  }
>
>  /*
> diff --git a/mm/slab.c b/mm/slab.c
> index 4f2ec6b..6dc9f4a 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -3511,6 +3511,20 @@ void ___cache_free(struct kmem_cache *cachep, void=
 *objp,
>   struct array_cache *ac =3D cpu_cache_get(cachep);
>
>   check_irq_off();
> +
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + if (cachep->flags & (SLAB_POISON | SLAB_NO_SANITIZE))
> + STATS_INC_NOT_SANITIZED(cachep);
> + else {
> + memset(objp, PAX_MEMORY_SANITIZE_VALUE, cachep->object_size);
> +
> + if (cachep->ctor)
> + cachep->ctor(objp);
> +
> + STATS_INC_SANITIZED(cachep);
> + }
> +#endif
> +
>   kmemleak_free_recursive(objp, cachep->flags);
>   objp =3D cache_free_debugcheck(cachep, objp, caller);
>
> @@ -4157,6 +4171,14 @@ void slabinfo_show_stats(struct seq_file *m,
> struct kmem_cache *cachep)
>   seq_printf(m, " : cpustat %6lu %6lu %6lu %6lu",
>     allochit, allocmiss, freehit, freemiss);
>   }
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + {
> + unsigned long sanitized =3D atomic_read_unchecked(&cachep->sanitized);
> + unsigned long not_sanitized =3D atomic_read_unchecked(&cachep->not_sani=
tized);
> +
> + seq_printf(m, " : pax %6lu %6lu", sanitized, not_sanitized);
> + }
> +#endif
>  #endif
>  }
>
> diff --git a/mm/slab.h b/mm/slab.h
> index de6579d..e982e3b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -71,6 +71,35 @@ extern struct list_head slab_caches;
>  /* The slab cache that manages slab cache information */
>  extern struct kmem_cache *kmem_cache;
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> +#ifdef CONFIG_X86_64
> +#define PAX_MEMORY_SANITIZE_VALUE '\xfe'
> +#else
> +#define PAX_MEMORY_SANITIZE_VALUE '\xff'
> +#endif
> +enum pax_sanitize_mode {
> + PAX_SANITIZE_SLAB_OFF =3D 0,
> + PAX_SANITIZE_SLAB_FAST,
> + PAX_SANITIZE_SLAB_FULL,
> +};
> +
> +extern enum pax_sanitize_mode pax_sanitize_slab;
> +
> +static inline unsigned long pax_sanitize_slab_flags(unsigned long flags)
> +{
> + if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_OFF || (flags &
> SLAB_DESTROY_BY_RCU))
> + flags |=3D SLAB_NO_SANITIZE;
> + else if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_FULL)
> + flags &=3D ~SLAB_NO_SANITIZE;
> + return flags;
> +}
> +#else
> +static inline unsigned long pax_sanitize_slab_flags(unsigned long flags)
> +{
> + return flags;
> +}
> +#endif
> +
>  unsigned long calculate_alignment(unsigned long flags,
>   unsigned long align, unsigned long size);
>
> @@ -120,7 +149,7 @@ static inline unsigned long
> kmem_cache_flags(unsigned long object_size,
>
>  /* Legal flag mask for kmem_cache_create(), for various configurations *=
/
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | SLAB_PANI=
C | \
> - SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
> + SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS | SLAB_NO_SANITIZE)
>
>  #if defined(CONFIG_DEBUG_SLAB)
>  #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1dfc209..80bf59e 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -30,6 +30,37 @@ LIST_HEAD(slab_caches);
>  DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> +/**
> +enum pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE_SL=
AB_FAST;
> +
> +?? -above orig statement from the grsec-4.8.17 patch fails compile with:
> +mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98=
,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
> =E2=80=98__attribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
> + pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE_SLAB_F=
AST;
> +*/
> +enum pax_sanitize_mode pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> +static int __init pax_sanitize_slab_setup(char *str)
> +{
> + if (!str)
> + return 0;
> +
> + if (!strcmp(str, "0") || !strcmp(str, "off")) {
> + pr_info("PaX slab sanitization: %s\n", "disabled");
> + pax_sanitize_slab =3D PAX_SANITIZE_SLAB_OFF;
> + } else if (!strcmp(str, "1") || !strcmp(str, "fast")) {
> + pr_info("PaX slab sanitization: %s\n", "fast");
> + pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> + } else if (!strcmp(str, "full")) {
> + pr_info("PaX slab sanitization: %s\n", "full");
> + pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FULL;
> + } else
> + pr_err("PaX slab sanitization: unsupported option '%s'\n", str);
> +
> + return 0;
> +}
> +early_param("pax_sanitize_slab", pax_sanitize_slab_setup);
> +#endif
> +
>  /*
>   * Set of flags that will prevent slab merging
>   */
> @@ -1136,6 +1167,9 @@ static void print_slabinfo_header(struct seq_file *=
m)
>  #ifdef CONFIG_DEBUG_SLAB
>   seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown> <reaped>
> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow>");
>   seq_puts(m, " : cpustat <allochit> <allocmiss> <freehit> <freemiss>");
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + seq_puts(m, " : pax <sanitized> <not_sanitized>");
> +#endif
>  #endif
>   seq_putc(m, '\n');
>  }
> diff --git a/mm/slob.c b/mm/slob.c
> index eac04d43..f455845 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -365,6 +365,11 @@ static void slob_free(void *block, int size)
>   return;
>   }
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + if (pax_sanitize_slab && !(c && (c->flags & SLAB_NO_SANITIZE)))
> + memset(block, PAX_MEMORY_SANITIZE_VALUE, size);
> +#endif
> +
>   if (!slob_page_free(sp)) {
>   /* This slob page is about to become partially free. Easy! */
>   sp->units =3D units;
> diff --git a/mm/slub.c b/mm/slub.c
> index 067598a..9253eb6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2911,6 +2911,23 @@ static __always_inline void do_slab_free(struct
> kmem_cache *s,
>   void *tail_obj =3D tail ? : head;
>   struct kmem_cache_cpu *c;
>   unsigned long tid;
> +
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + if (!(s->flags & SLAB_NO_SANITIZE)) {
> + int offset =3D s->offset ? 0 : sizeof(void *);
> + void *x =3D head;
> +
> + while (1) {
> + memset(x + offset, PAX_MEMORY_SANITIZE_VALUE, s->object_size - offset);
> + if (s->ctor)
> + s->ctor(x);
> + if (x =3D=3D tail_obj)
> + break;
> + x =3D get_freepointer(s, x);
> + }
> + }
> +#endif
> +
>  redo:
>   /*
>   * Determine the currently cpus per cpu slab.
> @@ -5316,6 +5333,15 @@ static struct attribute *slab_attrs[] =3D {
>  #ifdef CONFIG_ZONE_DMA
>   &cache_dma_attr.attr,
>  #endif
> +/**
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> + &sanitize_attr.attr,
> + * ?? -above statement from the grsec-4.8.17 patch fails compile with:
> + mm/slub.c:5337:3: error: =E2=80=98sanitize_attr=E2=80=99 undeclared her=
e (not in a function)
> +  &sanitize_attr.attr,
> +  ...
> +#endif
> + */
>  #ifdef CONFIG_NUMA
>   &remote_node_defrag_ratio_attr.attr,
>  #endif
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 7ad67d7..dde2364 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3453,12 +3453,14 @@ void __init skb_init(void)
>   skbuff_head_cache =3D kmem_cache_create("skbuff_head_cache",
>        sizeof(struct sk_buff),
>        0,
> -      SLAB_HWCACHE_ALIGN|SLAB_PANIC,
> +      SLAB_HWCACHE_ALIGN|SLAB_PANIC|
> +      SLAB_NO_SANITIZE,
>        NULL);
>   skbuff_fclone_cache =3D kmem_cache_create("skbuff_fclone_cache",
>   sizeof(struct sk_buff_fclones),
>   0,
> - SLAB_HWCACHE_ALIGN|SLAB_PANIC,
> + SLAB_HWCACHE_ALIGN|SLAB_PANIC|
> + SLAB_NO_SANITIZE,
>   NULL);
>  }
>
> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..3ad5110 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -4,6 +4,46 @@
>
>  menu "Security options"
>
> +menu "Miscellaneous hardening features"
> +
> +config PAX_MEMORY_SANITIZE
> + bool "Sanitize all freed memory"
> + default y if (GRKERNSEC_CONFIG_AUTO && GRKERNSEC_CONFIG_PRIORITY_SECURI=
TY)
> + help
> +  By saying Y here the kernel will erase memory pages and slab objects
> +  as soon as they are freed.  This in turn reduces the lifetime of data
> +  stored in them, making it less likely that sensitive information such
> +  as passwords, cryptographic secrets, etc stay in memory for too long.
> +
> +  This is especially useful for programs whose runtime is short, long
> +  lived processes and the kernel itself benefit from this as long as
> +  they ensure timely freeing of memory that may hold sensitive
> +  information.
> +
> +  A nice side effect of the sanitization of slab objects is the
> +  reduction of possible info leaks caused by padding bytes within the
> +  leaky structures.  Use-after-free bugs for structures containing
> +  pointers can also be detected as dereferencing the sanitized pointer
> +  will generate an access violation.
> +
> +  The tradeoff is performance impact, on a single CPU system kernel
> +  compilation sees a 3% slowdown, other systems and workloads may vary
> +  and you are advised to test this feature on your expected workload
> +  before deploying it.
> +
> +  The slab sanitization feature excludes a few slab caches per default
> +  for performance reasons.  To extend the feature to cover those as
> +  well, pass "pax_sanitize_slab=3Dfull" as kernel command line parameter=
.
> +
> +  To reduce the performance penalty by sanitizing pages only, albeit
> +  limiting the effectiveness of this feature at the same time, slab
> +  sanitization can be disabled with the kernel command line parameter
> +  "pax_sanitize_slab=3Doff".
> +
> +  Note that this feature does not protect data stored in live pages,
> +  e.g., process memory swapped to disk may stay there for a long time.
> +endmenu
> +
>  source security/keys/Kconfig
>
>  config SECURITY_DMESG_RESTRICT
>
> ---
>
> Am pretty sure it's definitely imperfect, just hope it's not horribly
> wrong! - pl let me know.
> What should I change, etc...
> TIA,
>
> Regards,
> Kaiwan.
>
>
> On Thu, Jan 12, 2017 at 3:34 PM, Kaiwan N Billimoria
> <kaiwan@kaiwantech.com> wrote:
>> Thanks Greg.
>> Will do..
>>
>>
>> Regards,
>> Kaiwan.
>>
>> Kaiwan N Billimoria
>> =E2=9C=89 kaiwan@kaiwantech.com
>> =E2=9C=89 kaiwan.billimoria@gmail.com
>>
>> kaiwanTECH
>> http://kaiwantech.in
>> Do visit our enhanced website.
>>
>> 4931, 11th Floor, Highpoint IV, 45 Palace Road, Bangalore 560 001.
>> +91.9845016788 (M)
>> TeleFax: +91.80.22389396 | Alt. Tel: +91.80.64500257
>>
>> LinkedIn: https://in.linkedin.com/in/kaiwanbillimoria
>>
>> I blog here:
>> Tech : http://kaiwantech.wordpress.com  |
>> Running : http://kaiwanbill.blogspot.in/
>>
>> "Don't be afraid that your life will end,
>> be afraid that it will never begin."
>>
>> On Thu, Jan 12, 2017 at 1:07 PM, Greg KH <gregkh@linuxfoundation.org> wr=
ote:
>>>
>>> On Thu, Jan 12, 2017 at 09:01:05AM +0530, Kaiwan N Billimoria wrote:
>>> > Okay, thanks, I see it better now :)
>>> >
>>> > Forgive my silly qs:
>>> > so as I understand it, the objective is to start merging in some of t=
he
>>> > grsec
>>> > code into mainline, yes? So, which kernel do we work on? the latest r=
c
>>> > or do I
>>> > work on the one where the above patch applies (i.e. 4.8.17)?
>>>
>>> You can't go back in time and get stuff merged into an old patch, so
>>> always work on the latest kernel tree.  Use linux-next so you don't end
>>> up duplicating any effort that people have already done.
>>>
>>> I suggest reading Documentation/development_process/ as a summary of ho=
w
>>> all of this works.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
