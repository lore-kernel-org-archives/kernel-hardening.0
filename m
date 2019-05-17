Date: Fri, 17 May 2019 16:01:08 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v2 3/4] gfp: mm: introduce __GFP_NO_AUTOINIT
Message-ID: <20190517140108.GK6836@dhcp22.suse.cz>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-4-glider@google.com>
 <20190517125916.GF1825@dhcp22.suse.cz>
 <CAG_fn=VG6vrCdpEv0g73M-Au4wW07w8g0uydEiHA96QOfcCVhA@mail.gmail.com>
 <20190517132542.GJ6836@dhcp22.suse.cz>
 <CAG_fn=Ve88z2ezFjV6CthufMUhJ-ePNMT2=3m6J3nHWh9iSgsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=Ve88z2ezFjV6CthufMUhJ-ePNMT2=3m6J3nHWh9iSgsg@mail.gmail.com>
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Souptick Joarder <jrdr.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri 17-05-19 15:37:14, Alexander Potapenko wrote:
> On Fri, May 17, 2019 at 3:25 PM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Fri 17-05-19 15:18:19, Alexander Potapenko wrote:
> > > On Fri, May 17, 2019 at 2:59 PM Michal this flag Hocko
> > > <mhocko@kernel.org> wrote:
> > > >
> > > > [It would be great to keep people involved in the previous version in the
> > > > CC list]
> > > Yes, I've been trying to keep everyone in the loop, but your email
> > > fell through the cracks.
> > > Sorry about that.
> >
> > No problem
> >
> > > > On Tue 14-05-19 16:35:36, Alexander Potapenko wrote:
> > > > > When passed to an allocator (either pagealloc or SL[AOU]B),
> > > > > __GFP_NO_AUTOINIT tells it to not initialize the requested memory if the
> > > > > init_on_alloc boot option is enabled. This can be useful in the cases
> > > > > newly allocated memory is going to be initialized by the caller right
> > > > > away.
> > > > >
> > > > > __GFP_NO_AUTOINIT doesn't affect init_on_free behavior, except for SLOB,
> > > > > where init_on_free implies init_on_alloc.
> > > > >
> > > > > __GFP_NO_AUTOINIT basically defeats the hardening against information
> > > > > leaks provided by init_on_alloc, so one should use it with caution.
> > > > >
> > > > > This patch also adds __GFP_NO_AUTOINIT to alloc_pages() calls in SL[AOU]B.
> > > > > Doing so is safe, because the heap allocators initialize the pages they
> > > > > receive before passing memory to the callers.
> > > >
> > > > I still do not like the idea of a new gfp flag as explained in the
> > > > previous email. People will simply use it incorectly or arbitrarily.
> > > > We have that juicy experience from the past.
> > >
> > > Just to preserve some context, here's the previous email:
> > > https://patchwork.kernel.org/patch/10907595/
> > > (plus the patch removing GFP_TEMPORARY for the curious ones:
> > > https://lwn.net/Articles/729145/)
> >
> > Not only. GFP_REPEAT being another one and probably others I cannot
> > remember from the top of my head.
> >
> > > > Freeing a memory is an opt-in feature and the slab allocator can already
> > > > tell many (with constructor or GFP_ZERO) do not need it.
> > > Sorry, I didn't understand this piece. Could you please elaborate?
> >
> > The allocator can assume that caches with a constructor will initialize
> > the object so additional zeroying is not needed. GFP_ZERO should be self
> > explanatory.
> Ah, I see. We already do that, see the want_init_on_alloc()
> implementation here: https://patchwork.kernel.org/patch/10943087/
> > > > So can we go without this gfp thing and see whether somebody actually
> > > > finds a performance problem with the feature enabled and think about
> > > > what can we do about it rather than add this maint. nightmare from the
> > > > very beginning?
> > >
> > > There were two reasons to introduce this flag initially.
> > > The first was double initialization of pages allocated for SLUB.
> >
> > Could you elaborate please?
> When the kernel allocates an object from SLUB, and SLUB happens to be
> short on free pages, it requests some from the page allocator.
> Those pages are initialized by the page allocator

... when the feature is enabled ...

> and split into objects. Finally SLUB initializes one of the available
> objects and returns it back to the kernel.
> Therefore the object is initialized twice for the first time (when it
> comes directly from the page allocator).
> This cost is however amortized by SLUB reusing the object after it's been freed.

OK, I see what you mean now. Is there any way to special case the page
allocation for this feature? E.g. your implementation tries to make this
zeroying special but why cannot you simply do this


struct page *
____alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
							nodemask_t *nodemask)
{
	//current implementation
}

struct page *
__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
							nodemask_t *nodemask)
{
	if (your_feature_enabled)
		gfp_mask |= __GFP_ZERO;
	return ____alloc_pages_nodemask(gfp_mask, order, preferred_nid,
					nodemask);
}

and use ____alloc_pages_nodemask from the slab or other internal
allocators?
-- 
Michal Hocko
SUSE Labs
