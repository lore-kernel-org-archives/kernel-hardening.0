MIME-Version: 1.0
References: <20190617151050.92663-1-glider@google.com> <20190617151050.92663-2-glider@google.com>
 <20190621070905.GA3429@dhcp22.suse.cz> <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
In-Reply-To: <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 21 Jun 2019 16:10:19 +0200
Message-ID: <CAG_fn=W90HNeZ0UcUctnbUBzJ=_b+gxMGdUoDyO3JPoyy4dGSg@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 21, 2019 at 10:57 AM Alexander Potapenko <glider@google.com> wr=
ote:
>
> On Fri, Jun 21, 2019 at 9:09 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 17-06-19 17:10:49, Alexander Potapenko wrote:
> > > The new options are needed to prevent possible information leaks and
> > > make control-flow bugs that depend on uninitialized values more
> > > deterministic.
> > >
> > > init_on_alloc=3D1 makes the kernel initialize newly allocated pages a=
nd heap
> > > objects with zeroes. Initialization is done at allocation time at the
> > > places where checks for __GFP_ZERO are performed.
> > >
> > > init_on_free=3D1 makes the kernel initialize freed pages and heap obj=
ects
> > > with zeroes upon their deletion. This helps to ensure sensitive data
> > > doesn't leak via use-after-free accesses.
> > >
> > > Both init_on_alloc=3D1 and init_on_free=3D1 guarantee that the alloca=
tor
> > > returns zeroed memory. The two exceptions are slab caches with
> > > constructors and SLAB_TYPESAFE_BY_RCU flag. Those are never
> > > zero-initialized to preserve their semantics.
> > >
> > > Both init_on_alloc and init_on_free default to zero, but those defaul=
ts
> > > can be overridden with CONFIG_INIT_ON_ALLOC_DEFAULT_ON and
> > > CONFIG_INIT_ON_FREE_DEFAULT_ON.
> > >
> > > Slowdown for the new features compared to init_on_free=3D0,
> > > init_on_alloc=3D0:
> > >
> > > hackbench, init_on_free=3D1:  +7.62% sys time (st.err 0.74%)
> > > hackbench, init_on_alloc=3D1: +7.75% sys time (st.err 2.14%)
> > >
> > > Linux build with -j12, init_on_free=3D1:  +8.38% wall time (st.err 0.=
39%)
> > > Linux build with -j12, init_on_free=3D1:  +24.42% sys time (st.err 0.=
52%)
> > > Linux build with -j12, init_on_alloc=3D1: -0.13% wall time (st.err 0.=
42%)
> > > Linux build with -j12, init_on_alloc=3D1: +0.57% sys time (st.err 0.4=
0%)
> > >
> > > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to the
> > > baseline is within the standard error.
> > >
> > > The new features are also going to pave the way for hardware memory
> > > tagging (e.g. arm64's MTE), which will require both on_alloc and on_f=
ree
> > > hooks to set the tags for heap objects. With MTE, tagging will have t=
he
> > > same cost as memory initialization.
> > >
> > > Although init_on_free is rather costly, there are paranoid use-cases =
where
> > > in-memory data lifetime is desired to be minimized. There are various
> > > arguments for/against the realism of the associated threat models, bu=
t
> > > given that we'll need the infrastructre for MTE anyway, and there are
> > > people who want wipe-on-free behavior no matter what the performance =
cost,
> > > it seems reasonable to include it in this series.
> >
> > Thanks for reworking the original implemenation. This looks much better=
!
> >
> > > Signed-off-by: Alexander Potapenko <glider@google.com>
> > > Acked-by: Kees Cook <keescook@chromium.org>
> > > To: Andrew Morton <akpm@linux-foundation.org>
> > > To: Christoph Lameter <cl@linux.com>
> > > To: Kees Cook <keescook@chromium.org>
> > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Cc: James Morris <jmorris@namei.org>
> > > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Kostya Serebryany <kcc@google.com>
> > > Cc: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Sandeep Patil <sspatil@android.com>
> > > Cc: Laura Abbott <labbott@redhat.com>
> > > Cc: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: Jann Horn <jannh@google.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: Marco Elver <elver@google.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-security-module@vger.kernel.org
> > > Cc: kernel-hardening@lists.openwall.com
> >
> > Acked-by: Michal Hocko <mhocko@suse.cz> # page allocator parts.
> >
> > kmalloc based parts look good to me as well but I am not sure I fill
> > qualified to give my ack there without much more digging and I do not
> > have much time for that now.
> >
> > [...]
> > > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > > index fd5c95ff9251..2f75dd0d0d81 100644
> > > --- a/kernel/kexec_core.c
> > > +++ b/kernel/kexec_core.c
> > > @@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_=
mask, unsigned int order)
> > >               arch_kexec_post_alloc_pages(page_address(pages), count,
> > >                                           gfp_mask);
> > >
> > > -             if (gfp_mask & __GFP_ZERO)
> > > +             if (want_init_on_alloc(gfp_mask))
> > >                       for (i =3D 0; i < count; i++)
> > >                               clear_highpage(pages + i);
> > >       }
> >
> > I am not really sure I follow here. Why do we want to handle
> > want_init_on_alloc here? The allocated memory comes from the page
> > allocator and so it will get zeroed there. arch_kexec_post_alloc_pages
> > might touch the content there but is there any actual risk of any kind
> > of leak?
> You're right, we don't want to initialize this memory if init_on_alloc is=
 on.
> We need something along the lines of:
>   if (!static_branch_unlikely(&init_on_alloc))
>     if (gfp_mask & __GFP_ZERO)
>       // clear the pages
>
> Another option would be to disable initialization in alloc_pages() using =
a flag.
> >
> > > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > > index 8c94c89a6f7e..e164012d3491 100644
> > > --- a/mm/dmapool.c
> > > +++ b/mm/dmapool.c
> > > @@ -378,7 +378,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t=
 mem_flags,
> > >  #endif
> > >       spin_unlock_irqrestore(&pool->lock, flags);
> > >
> > > -     if (mem_flags & __GFP_ZERO)
> > > +     if (want_init_on_alloc(mem_flags))
> > >               memset(retval, 0, pool->size);
> > >
> > >       return retval;
> >
> > Don't you miss dma_pool_free and want_init_on_free?
> Agreed.
> I'll fix this and add tests for DMA pools as well.
This doesn't seem to be easy though. One needs a real DMA-capable
device to allocate using DMA pools.
On the other hand, what happens to a DMA pool when it's destroyed,
isn't it wiped by pagealloc?

I'm inclined towards not touching mm/dmapool.c in this patch series,
as it is probably orthogonal to the idea of hardening the
heap/pagealloc.
> > --
> > Michal Hocko
> > SUSE Labs
>
>
>
> --
> Alexander Potapenko
> Software Engineer
>
> Google Germany GmbH
> Erika-Mann-Stra=C3=9Fe, 33
> 80636 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> Registergericht und -nummer: Hamburg, HRB 86891
> Sitz der Gesellschaft: Hamburg



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
