Date: Fri, 3 Feb 2017 10:19:49 +0530
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Message-ID: <20170203101949.4c6908be@kaiwan-T460>
In-Reply-To: <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
References: <20170118095155.5e3bf976@kaiwan-T460>
	<90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Laura Abbott <labbott@redhat.com>
Cc: kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Pl bear with me, am trying to understand this correctly.
=46rom what I gather, we look to create a new config directive, say,
CONFIG_MEMORY_SANITIZE .

It will turn ON :
 CONFIG_DEBUG_PAGEALLOC=20
   (which internally turns ON CONFIG_PAGE_EXTENSION), and
 CONFIG_PAGE_POISONING
   (similar internal turn-ons :).

The new config now enables the CONFIG_PAX_MEMORY_SANITIZE code (my prev=20
email patch), correct? (leaving out the stuff we cannot get without the=20
full grsec implementation).
-Would include the 'new' poison / sanitize values of 0xfe and 0xff for slab
(64 and 32-bit resp), etc etc.


Even if this is (somewhat) correct, my thinking is - correct me I'm totally=
=20
wrong here - that the whole purpose of the exercise is to improve _security=
_;
hence, tying this code into the "debug features" of the kernel isn't really=
=20
what we want, yes?
Most folks would only use debug during development, if at all - given all t=
he=20
concerns regarding performance. Here, the objective is to enable a powerful=
=20
security feature set. Hence, the config directives should come under the=20
'Security Options' menu.

Regards,
Kaiwan.

On Wed, 18 Jan 2017 11:44:47 -0800
Laura Abbott <labbott@redhat.com> wrote:

> On 01/17/2017 08:21 PM, Kaiwan N Billimoria wrote:
> > Hi Kees,
> >=20
> > So, following up on the previous discussion,  =20
> >> I'd like to see the mentioned excluded slab caches also done in the
> >> kernel, along with similar kernel command line options.
> >> Additionally, getting all the upstream stuff behind a single
> >> CONFIG (similar to CONFIG_PAX_MEMORY_SANITIZE) would be great,
> >> instead of having to set 3 CONFIGs and 2 kernel parameters. :) =20
> >=20
> > Basically what I've done so far is:
> > - pulled in the linux-next tree, and setup my own branch
> >=20
> > - taken the grsecurity patch (for 4.8.17) and merged those portions
> > of the code encompassing the  CONFIG_PAX_MEMORY_SANITIZE directive
> >=20
> > - There were some compile issues, which seem to be there mostly
> > because of other grsec infra that hasn't been merged in (yet).=20
> > For now, I've just done small fixups where required:
> > (see code in ptach below):
> >=20
> > [1. fs/dcache.c
> >   kmem_cache_create_usercopy() unavailable (for now at least).
> > Probably part of other grsec infrastructure..
> >  So am just adding the SLAB_NO_SANITIZE flag to the usual
> > kmem_cache_create() call.
> >=20
> > 2. mm/slab_common.c
> > Compile failure:
> > enum pax_sanitize_mode pax_sanitize_slab __read_only =3D
> > PAX_SANITIZE_SLAB_FAST;
> >=20
> > ?? -above orig statement from the grsec-4.8.17 patch fails compile
> > with: mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =
=E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99
> > or =E2=80=98__attribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
> >=20
> > So I've just removed the "__read_only" attribute for now.
> > What's the actual approach?
> >=20
> > 3. mm/slub.c
> > Compile failure:
> > #ifdef CONFIG_PAX_MEMORY_SANITIZE
> >  &sanitize_attr.attr,
> >  * ?? -above statement from the grsec-4.8.17 patch fails compile
> > with: mm/slub.c:5337:3: error: =E2=80=98sanitize_attr=E2=80=99 undeclar=
ed here (not
> > in a function) &sanitize_attr.attr,
> >=20
> > Just commented this out for now.
> > ] =20
>=20
> This is roughly the work I did before
> (http://www.openwall.com/lists/kernel-hardening/2015/12/22/1)
>=20
> From that discussion, the conclusion is that we need to
> use the existing slab_debug infrastructure to do sanitization.
> The part in mm/page_alloc.c has been turned into a separate
> Kconfig.
>=20
> As Kees mentioned, a good task would be to create a new Kconfig
> (CONFIG_MEMORY_SANITIZE for example) that will turn on both
> CONFIG_DEBUG_PAGEALLOC (the equivalent of CONFIG_PAX_MEMORY_SANITIZE)
> and also turn on slab poisoning.
>=20
> There's other stuff here you can do but hopefully working on
> that will give you a chance to look and explore what's already
> present vs. grsecurity.
>=20
> Thanks,
> Laura
>=20
> >=20
> >=20
> >=20
> > =3D=3D=3D
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 28484b3..b524eda 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -3511,7 +3511,7 @@ void __init buffer_init(void)
> >  	bh_cachep =3D kmem_cache_create("buffer_head",
> >  			sizeof(struct buffer_head), 0,
> >  				(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
> > -				SLAB_MEM_SPREAD),
> > +				SLAB_MEM_SPREAD|SLAB_NO_SANITIZE),
> >  				NULL);
> > =20
> >  	/*
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 95d71ed..95ed43c 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -3616,8 +3616,16 @@ void __init vfs_caches_init_early(void)
> > =20
> >  void __init vfs_caches_init(void)
> >  {
> > +/**
> > + *	names_cachep =3D kmem_cache_create_usercopy("names_cache",
> > PATH_MAX, 0,
> > + *			SLAB_HWCACHE_ALIGN|SLAB_PANIC|
> > SLAB_NO_SANITIZE,
> > + *			0, PATH_MAX, NULL);
> > + *	kmem_cache_create_usercopy() unavailable for now at
> > least.
> > + *	So just adding the SLAB_NO_SANITIZE flag to the usual
> > call below..
> > + */
> >  	names_cachep =3D kmem_cache_create("names_cache", PATH_MAX,
> > 0,
> > -			SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
> > +
> > SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NO_SANITIZE, NULL); +
> > =20
> >  	dcache_init();
> >  	inode_init();
> > diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> > index bb3f329..9daed55 100644
> > --- a/include/linux/highmem.h
> > +++ b/include/linux/highmem.h
> > @@ -190,6 +190,18 @@ static inline void clear_highpage(struct page
> > *page) kunmap_atomic(kaddr);
> >  }
> > =20
> > +static inline void sanitize_highpage(struct page *page)
> > +{
> > +	void *kaddr;
> > +	unsigned long flags;
> > +
> > +	local_irq_save(flags);
> > +	kaddr =3D kmap_atomic(page);
> > +	clear_page(kaddr);
> > +	kunmap_atomic(kaddr);
> > +	local_irq_restore(flags);
> > +}
> > +
> >  static inline void zero_user_segments(struct page *page,
> >  	unsigned start1, unsigned end1,
> >  	unsigned start2, unsigned end2)
> > diff --git a/include/linux/slab.h b/include/linux/slab.h
> > index 4c53635..334bd89 100644
> > --- a/include/linux/slab.h
> > +++ b/include/linux/slab.h
> > @@ -23,6 +23,13 @@
> >  #define SLAB_CONSISTENCY_CHECKS	0x00000100UL	/*
> > DEBUG: Perform (expensive) checks on alloc/free */ #define
> > SLAB_RED_ZONE		0x00000400UL	/* DEBUG: Red zone
> > objs in a cache */ #define SLAB_POISON
> > 0x00000800UL	/* DEBUG: Poison objects */ + +#ifdef
> > CONFIG_PAX_MEMORY_SANITIZE +#define SLAB_NO_SANITIZE
> > 0x00001000UL	/* PaX: Do not sanitize objs on free */ +#else
> > +#define SLAB_NO_SANITIZE	0x00000000UL
> > +#endif
> > +
> >  #define SLAB_HWCACHE_ALIGN	0x00002000UL	/* Align
> > objs on cache lines */ #define SLAB_CACHE_DMA
> > 0x00004000UL	/* Use GFP_DMA memory */ #define
> > SLAB_STORE_USER		0x00010000UL	/* DEBUG: Store
> > the last owner for bug hunting */ diff --git
> > a/include/linux/slab_def.h b/include/linux/slab_def.h index
> > 4ad2c5a..a30bbd2 100644 --- a/include/linux/slab_def.h +++
> > b/include/linux/slab_def.h @@ -60,6 +60,10 @@ struct kmem_cache {
> >  	atomic_t allocmiss;
> >  	atomic_t freehit;
> >  	atomic_t freemiss;
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	atomic_unchecked_t sanitized;
> > +	atomic_unchecked_t not_sanitized;
> > +#endif
> >  #ifdef CONFIG_DEBUG_SLAB_LEAK
> >  	atomic_t store_user_clean;
> >  #endif
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 7da33cb..42646d4 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -2098,7 +2098,8 @@ void __init proc_caches_init(void)
> >  			sizeof(struct mm_struct),
> > ARCH_MIN_MMSTRUCT_ALIGN,
> > SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NOTRACK|SLAB_ACCOUNT, NULL);
> > -	vm_area_cachep =3D KMEM_CACHE(vm_area_struct,
> > SLAB_PANIC|SLAB_ACCOUNT);
> > +	vm_area_cachep =3D KMEM_CACHE(vm_area_struct,
> > SLAB_PANIC|SLAB_ACCOUNT|
> > +			 SLAB_NO_SANITIZE);
> >  	mmap_init();
> >  	nsproxy_cache_init();
> >  }
> > diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> > index afcc550..ed3f097 100644
> > --- a/mm/Kconfig.debug
> > +++ b/mm/Kconfig.debug
> > @@ -10,6 +10,7 @@ config PAGE_EXTENSION
> >  config DEBUG_PAGEALLOC
> >  	bool "Debug page memory allocations"
> >  	depends on DEBUG_KERNEL
> > +	depends on !PAX_MEMORY_SANITIZE
> >  	depends on !HIBERNATION || ARCH_SUPPORTS_DEBUG_PAGEALLOC
> > && !PPC && !SPARC depends on !KMEMCHECK
> >  	select PAGE_EXTENSION
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 21ea508..3e899fa 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -994,6 +994,10 @@ static __always_inline bool
> > free_pages_prepare(struct page *page, {
> >  	int bad =3D 0;
> > =20
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	unsigned long index =3D 1UL << order;
> > +#endif
> > +
> >  	VM_BUG_ON_PAGE(PageTail(page), page);
> > =20
> >  	trace_mm_page_free(page, order);
> > @@ -1040,6 +1044,12 @@ static __always_inline bool
> > free_pages_prepare(struct page *page,
> > debug_check_no_obj_freed(page_address(page), PAGE_SIZE << order);
> >  	}
> > +
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	for (; index; --index)
> > +		sanitize_highpage(page + index - 1);
> > +#endif
> > +
> >  	arch_free_page(page, order);
> >  	kernel_poison_pages(page, 1 << order, 0);
> >  	kernel_map_pages(page, 1 << order, 0);
> > @@ -1696,8 +1706,10 @@ static inline int check_new_page(struct page
> > *page)=20
> >  static inline bool free_pages_prezeroed(bool poisoned)
> >  {
> > -	return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
> > -		page_poisoning_enabled() && poisoned;
> > +	return IS_ENABLED(CONFIG_PAX_MEMORY_SANITIZE) ||
> > +		(IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
> > +		 page_poisoning_enabled() && poisoned);
> > +
> >  }
> > =20
> >  #ifdef CONFIG_DEBUG_VM
> > @@ -1753,11 +1765,13 @@ static void prep_new_page(struct page
> > *page, unsigned int order, gfp_t gfp_flags int i;
> >  	bool poisoned =3D true;
> > =20
> > +#ifndef CONFIG_PAX_MEMORY_SANITIZE
> >  	for (i =3D 0; i < (1 << order); i++) {
> >  		struct page *p =3D page + i;
> >  		if (poisoned)
> >  			poisoned &=3D page_is_poisoned(p);
> >  	}
> > +#endif
> > =20
> >  	post_alloc_hook(page, order, gfp_flags);
> > =20
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 91619fd..e209ff6 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -428,10 +428,10 @@ static void anon_vma_ctor(void *data)
> >  void __init anon_vma_init(void)
> >  {
> >  	anon_vma_cachep =3D kmem_cache_create("anon_vma",
> > sizeof(struct anon_vma),
> > -			0,
> > SLAB_DESTROY_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
> > -			anon_vma_ctor);
> > +			0,
> > SLAB_DESTROY_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT|
> > +			SLAB_NO_SANITIZE, anon_vma_ctor);
> >  	anon_vma_chain_cachep =3D KMEM_CACHE(anon_vma_chain,
> > -			SLAB_PANIC|SLAB_ACCOUNT);
> > +			SLAB_PANIC|SLAB_ACCOUNT|SLAB_NO_SANITIZE);
> >  }
> > =20
> >  /*
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 4f2ec6b..6dc9f4a 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3511,6 +3511,20 @@ void ___cache_free(struct kmem_cache
> > *cachep, void *objp, struct array_cache *ac =3D cpu_cache_get(cachep);
> > =20
> >  	check_irq_off();
> > +
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	if (cachep->flags & (SLAB_POISON | SLAB_NO_SANITIZE))
> > +		STATS_INC_NOT_SANITIZED(cachep);
> > +	else {
> > +		memset(objp, PAX_MEMORY_SANITIZE_VALUE,
> > cachep->object_size); +
> > +		if (cachep->ctor)
> > +			cachep->ctor(objp);
> > +
> > +		STATS_INC_SANITIZED(cachep);
> > +	}
> > +#endif
> > +
> >  	kmemleak_free_recursive(objp, cachep->flags);
> >  	objp =3D cache_free_debugcheck(cachep, objp, caller);
> > =20
> > @@ -4157,6 +4171,14 @@ void slabinfo_show_stats(struct seq_file *m,
> > struct kmem_cache *cachep) seq_printf(m, " : cpustat %6lu %6lu %6lu
> > %6lu", allochit, allocmiss, freehit, freemiss);
> >  	}
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	{
> > +		unsigned long sanitized =3D
> > atomic_read_unchecked(&cachep->sanitized);
> > +		unsigned long not_sanitized =3D
> > atomic_read_unchecked(&cachep->not_sanitized); +
> > +		seq_printf(m, " : pax %6lu %6lu", sanitized,
> > not_sanitized);
> > +	}
> > +#endif
> >  #endif
> >  }
> > =20
> > diff --git a/mm/slab.h b/mm/slab.h
> > index de6579d..2965ebe 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -71,6 +71,36 @@ extern struct list_head slab_caches;
> >  /* The slab cache that manages slab cache information */
> >  extern struct kmem_cache *kmem_cache;
> > =20
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +#ifdef CONFIG_X86_64
> > +#define PAX_MEMORY_SANITIZE_VALUE	'\xfe'
> > +#else
> > +#define PAX_MEMORY_SANITIZE_VALUE	'\xff'
> > +#endif
> > +enum pax_sanitize_mode {
> > +	PAX_SANITIZE_SLAB_OFF =3D 0,
> > +	PAX_SANITIZE_SLAB_FAST,
> > +	PAX_SANITIZE_SLAB_FULL,
> > +};
> > +
> > +extern enum pax_sanitize_mode pax_sanitize_slab;
> > +
> > +static inline unsigned long pax_sanitize_slab_flags(unsigned long
> > flags) +{
> > +	if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_OFF ||
> > +	    (flags & SLAB_DESTROY_BY_RCU))
> > +		flags |=3D SLAB_NO_SANITIZE;
> > +	else if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_FULL)
> > +		flags &=3D ~SLAB_NO_SANITIZE;
> > +	return flags;
> > +}
> > +#else
> > +static inline unsigned long pax_sanitize_slab_flags(unsigned long
> > flags) +{
> > +	return flags;
> > +}
> > +#endif
> > +
> >  unsigned long calculate_alignment(unsigned long flags,
> >  		unsigned long align, unsigned long size);
> > =20
> > @@ -120,7 +150,8 @@ static inline unsigned long
> > kmem_cache_flags(unsigned long object_size,=20
> >  /* Legal flag mask for kmem_cache_create(), for various
> > configurations */ #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN |
> > SLAB_CACHE_DMA | SLAB_PANIC | \
> > -			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS )
> > +			 SLAB_DESTROY_BY_RCU | SLAB_DEBUG_OBJECTS
> > | \
> > +			 SLAB_NO_SANITIZE)
> > =20
> >  #if defined(CONFIG_DEBUG_SLAB)
> >  #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON |
> > SLAB_STORE_USER) diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 1dfc209..0a0851f 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -30,6 +30,37 @@ LIST_HEAD(slab_caches);
> >  DEFINE_MUTEX(slab_mutex);
> >  struct kmem_cache *kmem_cache;
> > =20
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +/**
> > + * enum pax_sanitize_mode pax_sanitize_slab __read_only =3D
> > PAX_SANITIZE_SLAB_FAST;
> > + *
> > + * ?? -above orig statement from the grsec-4.8.17 patch fails
> > compile with:
> > + * mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =E2=
=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
> > =E2=80=98__attribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
> > + *  pax_sanitize_mode pax_sanitize_slab __read_only =3D
> > PAX_SANITIZE_SLAB_FAST;
> > + */
> > +enum pax_sanitize_mode pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> > +static int __init pax_sanitize_slab_setup(char *str)
> > +{
> > +	if (!str)
> > +		return 0;
> > +
> > +	if (!strcmp(str, "0") || !strcmp(str, "off")) {
> > +		pr_info("PaX slab sanitization: %s\n", "disabled");
> > +		pax_sanitize_slab =3D PAX_SANITIZE_SLAB_OFF;
> > +	} else if (!strcmp(str, "1") || !strcmp(str, "fast")) {
> > +		pr_info("PaX slab sanitization: %s\n", "fast");
> > +		pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> > +	} else if (!strcmp(str, "full")) {
> > +		pr_info("PaX slab sanitization: %s\n", "full");
> > +		pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FULL;
> > +	} else
> > +		pr_err("PaX slab sanitization: unsupported option
> > '%s'\n", str); +
> > +	return 0;
> > +}
> > +early_param("pax_sanitize_slab", pax_sanitize_slab_setup);
> > +#endif
> > +
> >  /*
> >   * Set of flags that will prevent slab merging
> >   */
> > @@ -1136,6 +1167,9 @@ static void print_slabinfo_header(struct
> > seq_file *m) #ifdef CONFIG_DEBUG_SLAB
> >  	seq_puts(m, " : globalstat <listallocs> <maxobjs> <grown>
> > <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees>
> > <alienoverflow>"); seq_puts(m, " : cpustat <allochit> <allocmiss>
> > <freehit> <freemiss>"); +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	seq_puts(m, " : pax <sanitized> <not_sanitized>");
> > +#endif
> >  #endif
> >  	seq_putc(m, '\n');
> >  }
> > diff --git a/mm/slob.c b/mm/slob.c
> > index eac04d43..f455845 100644
> > --- a/mm/slob.c
> > +++ b/mm/slob.c
> > @@ -365,6 +365,11 @@ static void slob_free(void *block, int size)
> >  		return;
> >  	}
> > =20
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	if (pax_sanitize_slab && !(c && (c->flags &
> > SLAB_NO_SANITIZE)))
> > +		memset(block, PAX_MEMORY_SANITIZE_VALUE, size);
> > +#endif
> > +
> >  	if (!slob_page_free(sp)) {
> >  		/* This slob page is about to become partially
> > free. Easy! */ sp->units =3D units;
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 067598a..cead7ee 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2911,6 +2911,24 @@ static __always_inline void
> > do_slab_free(struct kmem_cache *s, void *tail_obj =3D tail ? : head;
> >  	struct kmem_cache_cpu *c;
> >  	unsigned long tid;
> > +
> > +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> > +	if (!(s->flags & SLAB_NO_SANITIZE)) {
> > +		int offset =3D s->offset ? 0 : sizeof(void *);
> > +		void *x =3D head;
> > +
> > +		while (1) {
> > +			memset(x + offset,
> > PAX_MEMORY_SANITIZE_VALUE,
> > +					s->object_size - offset);
> > +			if (s->ctor)
> > +				s->ctor(x);
> > +			if (x =3D=3D tail_obj)
> > +				break;
> > +			x =3D get_freepointer(s, x);
> > +		}
> > +	}
> > +#endif
> > +
> >  redo:
> >  	/*
> >  	 * Determine the currently cpus per cpu slab.
> > @@ -5316,6 +5334,15 @@ static struct attribute *slab_attrs[] =3D {
> >  #ifdef CONFIG_ZONE_DMA
> >  	&cache_dma_attr.attr,
> >  #endif
> > +/**
> > + * #ifdef CONFIG_PAX_MEMORY_SANITIZE
> > + *	&sanitize_attr.attr,
> > + * ?? -above statement from the grsec-4.8.17 patch fails compile
> > with:
> > + * mm/slub.c:5337:3: error: =E2=80=98sanitize_attr=E2=80=99 undeclared=
 here (not
> > in a function)
> > + *   &sanitize_attr.attr,
> > + *  ...
> > + * #endif
> > + */
> >  #ifdef CONFIG_NUMA
> >  	&remote_node_defrag_ratio_attr.attr,
> >  #endif
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 7ad67d7..2e60366 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -3453,12 +3453,14 @@ void __init skb_init(void)
> >  	skbuff_head_cache =3D kmem_cache_create("skbuff_head_cache",
> >  					      sizeof(struct
> > sk_buff), 0,
> > -
> > SLAB_HWCACHE_ALIGN|SLAB_PANIC,
> > +					      SLAB_HWCACHE_ALIGN |
> > SLAB_PANIC |
> > +					      SLAB_NO_SANITIZE,
> >  					      NULL);
> >  	skbuff_fclone_cache =3D
> > kmem_cache_create("skbuff_fclone_cache", sizeof(struct
> > sk_buff_fclones), 0,
> > -
> > SLAB_HWCACHE_ALIGN|SLAB_PANIC,
> > +						SLAB_HWCACHE_ALIGN
> > | SLAB_PANIC |
> > +						SLAB_NO_SANITIZE,
> >  						NULL);
> >  }
> > =20
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 118f454..3ad5110 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -4,6 +4,46 @@
> > =20
> >  menu "Security options"
> > =20
> > +menu "Miscellaneous hardening features"
> > +
> > +config PAX_MEMORY_SANITIZE
> > +	bool "Sanitize all freed memory"
> > +	default y if (GRKERNSEC_CONFIG_AUTO &&
> > GRKERNSEC_CONFIG_PRIORITY_SECURITY)
> > +	help
> > +	  By saying Y here the kernel will erase memory pages and
> > slab objects
> > +	  as soon as they are freed.  This in turn reduces the
> > lifetime of data
> > +	  stored in them, making it less likely that sensitive
> > information such
> > +	  as passwords, cryptographic secrets, etc stay in memory
> > for too long. +
> > +	  This is especially useful for programs whose runtime is
> > short, long
> > +	  lived processes and the kernel itself benefit from this
> > as long as
> > +	  they ensure timely freeing of memory that may hold
> > sensitive
> > +	  information.
> > +
> > +	  A nice side effect of the sanitization of slab objects
> > is the
> > +	  reduction of possible info leaks caused by padding bytes
> > within the
> > +	  leaky structures.  Use-after-free bugs for structures
> > containing
> > +	  pointers can also be detected as dereferencing the
> > sanitized pointer
> > +	  will generate an access violation.
> > +
> > +	  The tradeoff is performance impact, on a single CPU
> > system kernel
> > +	  compilation sees a 3% slowdown, other systems and
> > workloads may vary
> > +	  and you are advised to test this feature on your
> > expected workload
> > +	  before deploying it.
> > +
> > +	  The slab sanitization feature excludes a few slab caches
> > per default
> > +	  for performance reasons.  To extend the feature to cover
> > those as
> > +	  well, pass "pax_sanitize_slab=3Dfull" as kernel command
> > line parameter. +
> > +	  To reduce the performance penalty by sanitizing pages
> > only, albeit
> > +	  limiting the effectiveness of this feature at the same
> > time, slab
> > +	  sanitization can be disabled with the kernel command
> > line parameter
> > +	  "pax_sanitize_slab=3Doff".
> > +
> > +	  Note that this feature does not protect data stored in
> > live pages,
> > +	  e.g., process memory swapped to disk may stay there for
> > a long time. +endmenu
> > +
> >  source security/keys/Kconfig
> > =20
> >  config SECURITY_DMESG_RESTRICT
> >  =20
>=20
>=20
