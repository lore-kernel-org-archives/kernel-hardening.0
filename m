MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-4-glider@google.com>
 <20190517125916.GF1825@dhcp22.suse.cz> <CAG_fn=VG6vrCdpEv0g73M-Au4wW07w8g0uydEiHA96QOfcCVhA@mail.gmail.com>
 <20190517132542.GJ6836@dhcp22.suse.cz> <CAG_fn=Ve88z2ezFjV6CthufMUhJ-ePNMT2=3m6J3nHWh9iSgsg@mail.gmail.com>
 <20190517140108.GK6836@dhcp22.suse.cz> <201905170925.6FD47DDFFF@keescook> <20190517171105.GT6836@dhcp22.suse.cz>
In-Reply-To: <20190517171105.GT6836@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 21 May 2019 16:18:37 +0200
Message-ID: <CAG_fn=W9Y7=RZREi5S8z-sAMg2GfPsWqrHo+UawXWiRbhrNd0Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gfp: mm: introduce __GFP_NO_AUTOINIT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Souptick Joarder <jrdr.linux@gmail.com>, Matthew Wilcox <willy@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 17, 2019 at 7:11 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 17-05-19 09:27:54, Kees Cook wrote:
> > On Fri, May 17, 2019 at 04:01:08PM +0200, Michal Hocko wrote:
> > > On Fri 17-05-19 15:37:14, Alexander Potapenko wrote:
> > > > > > > Freeing a memory is an opt-in feature and the slab allocator =
can already
> > > > > > > tell many (with constructor or GFP_ZERO) do not need it.
> > > > > > Sorry, I didn't understand this piece. Could you please elabora=
te?
> > > > >
> > > > > The allocator can assume that caches with a constructor will init=
ialize
> > > > > the object so additional zeroying is not needed. GFP_ZERO should =
be self
> > > > > explanatory.
> > > > Ah, I see. We already do that, see the want_init_on_alloc()
> > > > implementation here: https://patchwork.kernel.org/patch/10943087/
> > > > > > > So can we go without this gfp thing and see whether somebody =
actually
> > > > > > > finds a performance problem with the feature enabled and thin=
k about
> > > > > > > what can we do about it rather than add this maint. nightmare=
 from the
> > > > > > > very beginning?
> > > > > >
> > > > > > There were two reasons to introduce this flag initially.
> > > > > > The first was double initialization of pages allocated for SLUB=
.
> > > > >
> > > > > Could you elaborate please?
> > > > When the kernel allocates an object from SLUB, and SLUB happens to =
be
> > > > short on free pages, it requests some from the page allocator.
> > > > Those pages are initialized by the page allocator
> > >
> > > ... when the feature is enabled ...
> > >
> > > > and split into objects. Finally SLUB initializes one of the availab=
le
> > > > objects and returns it back to the kernel.
> > > > Therefore the object is initialized twice for the first time (when =
it
> > > > comes directly from the page allocator).
> > > > This cost is however amortized by SLUB reusing the object after it'=
s been freed.
> > >
> > > OK, I see what you mean now. Is there any way to special case the pag=
e
> > > allocation for this feature? E.g. your implementation tries to make t=
his
> > > zeroying special but why cannot you simply do this
> > >
> > >
> > > struct page *
> > > ____alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int pref=
erred_nid,
> > >                                                     nodemask_t *nodem=
ask)
> > > {
> > >     //current implementation
> > > }
> > >
> > > struct page *
> > > __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int prefer=
red_nid,
> > >                                                     nodemask_t *nodem=
ask)
> > > {
> > >     if (your_feature_enabled)
> > >             gfp_mask |=3D __GFP_ZERO;
> > >     return ____alloc_pages_nodemask(gfp_mask, order, preferred_nid,
> > >                                     nodemask);
> > > }
> > >
> > > and use ____alloc_pages_nodemask from the slab or other internal
> > > allocators?
Given that calling alloc_pages() with __GFP_NO_AUTOINIT doesn't
visibly improve the chosen benchmarks,
and the next patch in the series ("net: apply __GFP_NO_AUTOINIT to
AF_UNIX sk_buff allocations") only improves hackbench,
shall we maybe drop both patches altogether?
> > If an additional allocator function is preferred over a new GFP flag, t=
hen
> > I don't see any reason not to do this. (Though adding more "__"s seems
> > a bit unfriendly to code-documentation.) What might be better naming?
>
> The naminig is the last thing I would be worried about. Let's focus on
> the most simplistic implementation first. And means, can we really make
> it as simple as above? At least on the page allocator level.
>
> > This would mean that the skb changes later in the series would use the
> > "no auto init" version of the allocator too, then.
>
> No, this would be an internal function to MM. I would really like to
> optimize once there are numbers from _real_ workloads to base those
> optimizations.
> --
> Michal Hocko
> SUSE Labs



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
