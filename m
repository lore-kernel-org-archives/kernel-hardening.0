Date: Fri, 21 Jun 2019 17:54:55 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <20190621155455.GG3429@dhcp22.suse.cz>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190621070905.GA3429@dhcp22.suse.cz>
 <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
 <CAG_fn=W90HNeZ0UcUctnbUBzJ=_b+gxMGdUoDyO3JPoyy4dGSg@mail.gmail.com>
 <20190621151210.GF3429@dhcp22.suse.cz>
 <CAG_fn=W2fm5zkAUW8PcTYpfH57H89ukFGAoBHUOmyM-S1agdZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=W2fm5zkAUW8PcTYpfH57H89ukFGAoBHUOmyM-S1agdZg@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 21-06-19 17:24:21, Alexander Potapenko wrote:
> On Fri, Jun 21, 2019 at 5:12 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 21-06-19 16:10:19, Alexander Potapenko wrote:
> > > On Fri, Jun 21, 2019 at 10:57 AM Alexander Potapenko <glider@google.com> wrote:
> > [...]
> > > > > > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > > > > > index 8c94c89a6f7e..e164012d3491 100644
> > > > > > --- a/mm/dmapool.c
> > > > > > +++ b/mm/dmapool.c
> > > > > > @@ -378,7 +378,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
> > > > > >  #endif
> > > > > >       spin_unlock_irqrestore(&pool->lock, flags);
> > > > > >
> > > > > > -     if (mem_flags & __GFP_ZERO)
> > > > > > +     if (want_init_on_alloc(mem_flags))
> > > > > >               memset(retval, 0, pool->size);
> > > > > >
> > > > > >       return retval;
> > > > >
> > > > > Don't you miss dma_pool_free and want_init_on_free?
> > > > Agreed.
> > > > I'll fix this and add tests for DMA pools as well.
> > > This doesn't seem to be easy though. One needs a real DMA-capable
> > > device to allocate using DMA pools.
> > > On the other hand, what happens to a DMA pool when it's destroyed,
> > > isn't it wiped by pagealloc?
> >
> > Yes it should be returned to the page allocator AFAIR. But it is when we
> > are returning an object to the pool when you want to wipe the data, no?
> My concern was that dma allocation is something orthogonal to heap and
> page allocator.
> I also don't know how many other allocators are left overboard, e.g.
> we don't do anything to lib/genalloc.c yet.

Well, that really depends what would you like to achieve by this
functionality. There are likely to be all sorts of allocators on top of
the core ones (e.g. mempool allocator). The question is whether you
really want to cover them all. Are they security relevant?

> > Why cannot you do it along the already existing poisoning?
> I can sure keep these bits.
> Any idea how the correct behavior of dma_pool_alloc/free can be tested?

Well, I would say that you have to rely on the review process here more
than any specific testing. In any case other allocators can be handled
incrementally. This is not all or nothing kinda stuff. I have pointed
out dma_pool because it only addresses one half of the work and it was
not clear why. If you want to drop dma_pool then this will be fine by
me. As this is a hardening feature you want to get coverage as large as
possible rather than 100%.

-- 
Michal Hocko
SUSE Labs
