MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-2-glider@google.com>
 <CAGXu5j+TsBgf0jw+05p8L_APKJ4+wnfPxL6hGmoHrddt-KuHuw@mail.gmail.com>
In-Reply-To: <CAGXu5j+TsBgf0jw+05p8L_APKJ4+wnfPxL6hGmoHrddt-KuHuw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 26 Apr 2019 14:12:46 +0200
Message-ID: <CAG_fn=UvdcBykSLvvz9Gc3Psq-JvdtzPdK6WR-Fs-rgB+FFztw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 23, 2019 at 9:00 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Apr 18, 2019 at 8:42 AM Alexander Potapenko <glider@google.com> w=
rote:
> > This option adds the possibility to initialize newly allocated pages an=
d
> > heap objects with zeroes. This is needed to prevent possible informatio=
n
> > leaks and make the control-flow bugs that depend on uninitialized value=
s
> > more deterministic.
> >
> > Initialization is done at allocation time at the places where checks fo=
r
> > __GFP_ZERO are performed. We don't initialize slab caches with
> > constructors to preserve their semantics. To reduce runtime costs of
> > checking cachep->ctor we replace a call to memset with a call to
> > cachep->poison_fn, which is only executed if the memory block needs to
> > be initialized.
> >
> > For kernel testing purposes filling allocations with a nonzero pattern
> > would be more suitable, but may require platform-specific code. To have
> > a simple baseline we've decided to start with zero-initialization.
>
> The memory tagging future may be worth mentioning here too. We'll
> always need an allocation-time hook. What we do in that hook (tag,
> zero, poison) can be manage from there.
Shall we factor out the allocation hook in this patch? Note that I'll
be probably dropping this poison_fn() stuff, as it should be enough to
just call memset() under a static branch.
> > No performance optimizations are done at the moment to reduce double
> > initialization of memory regions.
>
> Isn't this addressed in later patches?
Agreed.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Kostya Serebryany <kcc@google.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Sandeep Patil <sspatil@android.com>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Qian Cai <cai@lca.pw>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: linux-mm@kvack.org
> > Cc: linux-security-module@vger.kernel.org
> > Cc: kernel-hardening@lists.openwall.com
> > ---
> >  drivers/infiniband/core/uverbs_ioctl.c |  2 +-
> >  include/linux/mm.h                     |  8 ++++++++
> >  include/linux/slab_def.h               |  1 +
> >  include/linux/slub_def.h               |  1 +
> >  kernel/kexec_core.c                    |  2 +-
> >  mm/dmapool.c                           |  2 +-
> >  mm/page_alloc.c                        | 18 +++++++++++++++++-
> >  mm/slab.c                              | 12 ++++++------
> >  mm/slab.h                              |  1 +
> >  mm/slab_common.c                       | 15 +++++++++++++++
> >  mm/slob.c                              |  2 +-
> >  mm/slub.c                              |  8 ++++----
> >  net/core/sock.c                        |  2 +-
> >  13 files changed, 58 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniban=
d/core/uverbs_ioctl.c
> > index e1379949e663..f31234906be2 100644
> > --- a/drivers/infiniband/core/uverbs_ioctl.c
> > +++ b/drivers/infiniband/core/uverbs_ioctl.c
> > @@ -127,7 +127,7 @@ __malloc void *_uverbs_alloc(struct uverbs_attr_bun=
dle *bundle, size_t size,
> >         res =3D (void *)pbundle->internal_buffer + pbundle->internal_us=
ed;
> >         pbundle->internal_used =3D
> >                 ALIGN(new_used, sizeof(*pbundle->internal_buffer));
> > -       if (flags & __GFP_ZERO)
> > +       if (want_init_memory(flags))
> >                 memset(res, 0, size);
> >         return res;
> >  }
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 76769749b5a5..b38b71a5efaa 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2597,6 +2597,14 @@ static inline void kernel_poison_pages(struct pa=
ge *page, int numpages,
> >                                         int enable) { }
> >  #endif
> >
> > +DECLARE_STATIC_KEY_FALSE(init_allocations);
>
> I'd like a CONFIG to control this default. We can keep the boot-time
> option to change it, but I think a CONFIG is warranted here.
Ok, will do.
> > +static inline bool want_init_memory(gfp_t flags)
> > +{
> > +       if (static_branch_unlikely(&init_allocations))
> > +               return true;
> > +       return flags & __GFP_ZERO;
> > +}
> > +
> >  #ifdef CONFIG_DEBUG_PAGEALLOC
> >  extern bool _debug_pagealloc_enabled;
> >  extern void __kernel_map_pages(struct page *page, int numpages, int en=
able);
> > diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
> > index 9a5eafb7145b..9dfe9eb639d7 100644
> > --- a/include/linux/slab_def.h
> > +++ b/include/linux/slab_def.h
> > @@ -37,6 +37,7 @@ struct kmem_cache {
> >
> >         /* constructor func */
> >         void (*ctor)(void *obj);
> > +       void (*poison_fn)(struct kmem_cache *c, void *object);
> >
> >  /* 4) cache creation/removal */
> >         const char *name;
> > diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
> > index d2153789bd9f..afb928cb7c20 100644
> > --- a/include/linux/slub_def.h
> > +++ b/include/linux/slub_def.h
> > @@ -99,6 +99,7 @@ struct kmem_cache {
> >         gfp_t allocflags;       /* gfp flags to use on each alloc */
> >         int refcount;           /* Refcount for slab cache destroy */
> >         void (*ctor)(void *);
> > +       void (*poison_fn)(struct kmem_cache *c, void *object);
> >         unsigned int inuse;             /* Offset to metadata */
> >         unsigned int align;             /* Alignment */
> >         unsigned int red_left_pad;      /* Left redzone padding size */
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index d7140447be75..be84f5f95c97 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_ma=
sk, unsigned int order)
> >                 arch_kexec_post_alloc_pages(page_address(pages), count,
> >                                             gfp_mask);
> >
> > -               if (gfp_mask & __GFP_ZERO)
> > +               if (want_init_memory(gfp_mask))
> >                         for (i =3D 0; i < count; i++)
> >                                 clear_highpage(pages + i);
> >         }
> > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > index 76a160083506..796e38160d39 100644
> > --- a/mm/dmapool.c
> > +++ b/mm/dmapool.c
> > @@ -381,7 +381,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t m=
em_flags,
> >  #endif
> >         spin_unlock_irqrestore(&pool->lock, flags);
> >
> > -       if (mem_flags & __GFP_ZERO)
> > +       if (want_init_memory(mem_flags))
> >                 memset(retval, 0, pool->size);
> >
> >         return retval;
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d96ca5bc555b..e2a21d866ac9 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -133,6 +133,22 @@ unsigned long totalcma_pages __read_mostly;
> >
> >  int percpu_pagelist_fraction;
> >  gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT_MASK;
> > +bool want_init_allocations __read_mostly;
>
> This can be a stack variable in early_init_allocations() -- it's never
> used again.
Ack.
> > +EXPORT_SYMBOL(want_init_allocations);
> > +DEFINE_STATIC_KEY_FALSE(init_allocations);
> > +
> > +static int __init early_init_allocations(char *buf)
> > +{
> > +       int ret;
> > +
> > +       if (!buf)
> > +               return -EINVAL;
> > +       ret =3D kstrtobool(buf, &want_init_allocations);
> > +       if (want_init_allocations)
> > +               static_branch_enable(&init_allocations);
>
> With the CONFIG, this should have a _disable on an "else" here...
Ack.
> > +       return ret;
> > +}
> > +early_param("init_allocations", early_init_allocations);
>
> Does early_init_allocations() get called before things like
> prep_new_page() are up and running to call want_init_memory()?
Yes, IIUC early params are initialized before the memory subsystem is
initialized.

> >
> >  /*
> >   * A cached value of the page's pageblock's migratetype, used when the=
 page is
> > @@ -2014,7 +2030,7 @@ static void prep_new_page(struct page *page, unsi=
gned int order, gfp_t gfp_flags
> >
> >         post_alloc_hook(page, order, gfp_flags);
> >
> > -       if (!free_pages_prezeroed() && (gfp_flags & __GFP_ZERO))
> > +       if (!free_pages_prezeroed() && want_init_memory(gfp_flags))
> >                 for (i =3D 0; i < (1 << order); i++)
> >                         clear_highpage(page + i);
> >
> > diff --git a/mm/slab.c b/mm/slab.c
> > index 47a380a486ee..dcc5b73cf767 100644
> > --- a/mm/slab.c
> > +++ b/mm/slab.c
> > @@ -3331,8 +3331,8 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t =
flags, int nodeid,
> >         local_irq_restore(save_flags);
> >         ptr =3D cache_alloc_debugcheck_after(cachep, flags, ptr, caller=
);
> >
> > -       if (unlikely(flags & __GFP_ZERO) && ptr)
> > -               memset(ptr, 0, cachep->object_size);
> > +       if (unlikely(want_init_memory(flags)) && ptr)
> > +               cachep->poison_fn(cachep, ptr);
>
> So... this _must_ zero when __GFP_ZERO is present, so I'm not sure
> "poison_fn" is the right name, and it likely needs to take the "flags"
> argument.
I'll rework this part, as it had been pointed out that an empty
indirect call still costs something.
We're basically choosing between two options:
 - flags & __GFP_ZERO when initialization is disabled;
 - and cachep->ctr when it's enabled
A static branch should be enough to switch between those without
introducing extra checks or indirections.
>
> >
> >         slab_post_alloc_hook(cachep, flags, 1, &ptr);
> >         return ptr;
> > @@ -3388,8 +3388,8 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags=
, unsigned long caller)
> >         objp =3D cache_alloc_debugcheck_after(cachep, flags, objp, call=
er);
> >         prefetchw(objp);
> >
> > -       if (unlikely(flags & __GFP_ZERO) && objp)
> > -               memset(objp, 0, cachep->object_size);
> > +       if (unlikely(want_init_memory(flags)) && objp)
> > +               cachep->poison_fn(cachep, objp);
>
> Same.
>
> >
> >         slab_post_alloc_hook(cachep, flags, 1, &objp);
> >         return objp;
> > @@ -3596,9 +3596,9 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, g=
fp_t flags, size_t size,
> >         cache_alloc_debugcheck_after_bulk(s, flags, size, p, _RET_IP_);
> >
> >         /* Clear memory outside IRQ disabled section */
> > -       if (unlikely(flags & __GFP_ZERO))
> > +       if (unlikely(want_init_memory(flags)))
> >                 for (i =3D 0; i < size; i++)
> > -                       memset(p[i], 0, s->object_size);
> > +                       s->poison_fn(s, p[i]);
>
> Same.
>
> >
> >         slab_post_alloc_hook(s, flags, size, p);
> >         /* FIXME: Trace call missing. Christoph would like a bulk varia=
nt */
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 43ac818b8592..3b541e8970ee 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -27,6 +27,7 @@ struct kmem_cache {
> >         const char *name;       /* Slab name for sysfs */
> >         int refcount;           /* Use counter */
> >         void (*ctor)(void *);   /* Called on object slot creation */
> > +       void (*poison_fn)(struct kmem_cache *c, void *object);
>
> How about naming it just "initialize"?
DItto.
> >         struct list_head list;  /* List of all slab caches on the syste=
m */
> >  };
> >
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 58251ba63e4a..37810114b2ea 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -360,6 +360,16 @@ struct kmem_cache *find_mergeable(unsigned int siz=
e, unsigned int align,
> >         return NULL;
> >  }
> >
> > +static void poison_zero(struct kmem_cache *c, void *object)
> > +{
> > +       memset(object, 0, c->object_size);
> > +}
> > +
> > +static void poison_dont(struct kmem_cache *c, void *object)
> > +{
> > +       /* Do nothing. Use for caches with constructors. */
> > +}
> > +
> >  static struct kmem_cache *create_cache(const char *name,
> >                 unsigned int object_size, unsigned int align,
> >                 slab_flags_t flags, unsigned int useroffset,
> > @@ -381,6 +391,10 @@ static struct kmem_cache *create_cache(const char =
*name,
> >         s->size =3D s->object_size =3D object_size;
> >         s->align =3D align;
> >         s->ctor =3D ctor;
> > +       if (ctor)
> > +               s->poison_fn =3D poison_dont;
> > +       else
> > +               s->poison_fn =3D poison_zero;
>
> As mentioned, we must still always zero when __GFP_ZERO is present.
This part will be gone, but in general __GFP_ZERO is incompatible with
constructors, see a check in new_slab_objects().
I don't think we must support erroneous behaviour.

> >         s->useroffset =3D useroffset;
> >         s->usersize =3D usersize;
> >
> > @@ -974,6 +988,7 @@ void __init create_boot_cache(struct kmem_cache *s,=
 const char *name,
> >         s->align =3D calculate_alignment(flags, ARCH_KMALLOC_MINALIGN, =
size);
> >         s->useroffset =3D useroffset;
> >         s->usersize =3D usersize;
> > +       s->poison_fn =3D poison_zero;
> >
> >         slab_init_memcg_params(s);
> >
> > diff --git a/mm/slob.c b/mm/slob.c
> > index 307c2c9feb44..18981a71e962 100644
> > --- a/mm/slob.c
> > +++ b/mm/slob.c
> > @@ -330,7 +330,7 @@ static void *slob_alloc(size_t size, gfp_t gfp, int=
 align, int node)
> >                 BUG_ON(!b);
> >                 spin_unlock_irqrestore(&slob_lock, flags);
> >         }
> > -       if (unlikely(gfp & __GFP_ZERO))
> > +       if (unlikely(want_init_memory(gfp)))
> >                 memset(b, 0, size);
> >         return b;
> >  }
> > diff --git a/mm/slub.c b/mm/slub.c
> > index d30ede89f4a6..e4efb6575510 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -2750,8 +2750,8 @@ static __always_inline void *slab_alloc_node(stru=
ct kmem_cache *s,
> >                 stat(s, ALLOC_FASTPATH);
> >         }
> >
> > -       if (unlikely(gfpflags & __GFP_ZERO) && object)
> > -               memset(object, 0, s->object_size);
> > +       if (unlikely(want_init_memory(gfpflags)) && object)
> > +               s->poison_fn(s, object);
> >
> >         slab_post_alloc_hook(s, gfpflags, 1, &object);
> >
> > @@ -3172,11 +3172,11 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s,=
 gfp_t flags, size_t size,
> >         local_irq_enable();
> >
> >         /* Clear memory outside IRQ disabled fastpath loop */
> > -       if (unlikely(flags & __GFP_ZERO)) {
> > +       if (unlikely(want_init_memory(flags))) {
> >                 int j;
> >
> >                 for (j =3D 0; j < i; j++)
> > -                       memset(p[j], 0, s->object_size);
> > +                       s->poison_fn(s, p[j]);
> >         }
> >
> >         /* memcg and kmem_cache debug support */
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 782343bb925b..99b288a19b39 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1601,7 +1601,7 @@ static struct sock *sk_prot_alloc(struct proto *p=
rot, gfp_t priority,
> >                 sk =3D kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
> >                 if (!sk)
> >                         return sk;
> > -               if (priority & __GFP_ZERO)
> > +               if (want_init_memory(priority))
> >                         sk_prot_clear_nulls(sk, prot->obj_size);
> >         } else
> >                 sk =3D kmalloc(prot->obj_size, priority);
> > --
> > 2.21.0.392.gf8f6787159e-goog
> >
>
> Looking good. :) Thanks for working on this!
>
> --
> Kees Cook



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
