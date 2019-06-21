MIME-Version: 1.0
References: <20190617151050.92663-1-glider@google.com> <20190617151050.92663-2-glider@google.com>
 <1561120576.5154.35.camel@lca.pw>
In-Reply-To: <1561120576.5154.35.camel@lca.pw>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 21 Jun 2019 15:31:33 +0200
Message-ID: <CAG_fn=XKK5+nC5LErJ+zo7dt3N-cO7zToz=bN2R891dMG_rncA@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Qian Cai <cai@lca.pw>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 21, 2019 at 2:36 PM Qian Cai <cai@lca.pw> wrote:
>
> On Mon, 2019-06-17 at 17:10 +0200, Alexander Potapenko wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d66bc8abe0af..50a3b104a491 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -136,6 +136,48 @@ unsigned long totalcma_pages __read_mostly;
> >
> >  int percpu_pagelist_fraction;
> >  gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOOT_MASK;
> > +#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
> > +DEFINE_STATIC_KEY_TRUE(init_on_alloc);
> > +#else
> > +DEFINE_STATIC_KEY_FALSE(init_on_alloc);
> > +#endif
> > +#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
> > +DEFINE_STATIC_KEY_TRUE(init_on_free);
> > +#else
> > +DEFINE_STATIC_KEY_FALSE(init_on_free);
> > +#endif
> > +
>
> There is a problem here running kernels built with clang,
>
> [    0.000000] static_key_disable(): static key 'init_on_free+0x0/0x4' us=
ed
> before call to jump_label_init()
> [    0.000000] WARNING: CPU: 0 PID: 0 at ./include/linux/jump_label.h:314
> early_init_on_free+0x1c0/0x200
> [    0.000000] Modules linked in:
> [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 5.2.0-rc5-next-201=
90620+
> #11
> [    0.000000] pstate: 60000089 (nZCv daIf -PAN -UAO)
> [    0.000000] pc : early_init_on_free+0x1c0/0x200
> [    0.000000] lr : early_init_on_free+0x1c0/0x200
> [    0.000000] sp : ffff100012c07df0
> [    0.000000] x29: ffff100012c07e20 x28: ffff1000110a01ec
> [    0.000000] x27: 0000000000000001 x26: ffff100011716f88
> [    0.000000] x25: ffff100010d367ae x24: ffff100010d367a5
> [    0.000000] x23: ffff100010d36afd x22: ffff100011716758
> [    0.000000] x21: 0000000000000000 x20: 0000000000000000
> [    0.000000] x19: 0000000000000000 x18: 000000000000002e
> [    0.000000] x17: 000000000000000f x16: 0000000000000040
> [    0.000000] x15: 0000000000000000 x14: 6d756a206f74206c
> [    0.000000] x13: 6c61632065726f66 x12: 6562206465737520
> [    0.000000] x11: 0000000000000000 x10: 0000000000000000
> [    0.000000] x9 : 0000000000000000 x8 : 0000000000000000
> [    0.000000] x7 : 73203a2928656c62 x6 : ffff1000144367ad
> [    0.000000] x5 : ffff100012c07b28 x4 : 000000000000000f
> [    0.000000] x3 : ffff1000101b36ec x2 : 0000000000000001
> [    0.000000] x1 : 0000000000000001 x0 : 000000000000005d
> [    0.000000] Call trace:
> [    0.000000]  early_init_on_free+0x1c0/0x200
> [    0.000000]  do_early_param+0xd0/0x104
> [    0.000000]  parse_args+0x204/0x54c
> [    0.000000]  parse_early_param+0x70/0x8c
> [    0.000000]  setup_arch+0xa8/0x268
> [    0.000000]  start_kernel+0x80/0x588
> [    0.000000] random: get_random_bytes called from __warn+0x164/0x208 wi=
th
> crng_init=3D0
>
> > diff --git a/mm/slub.c b/mm/slub.c
> > index cd04dbd2b5d0..9c4a8b9a955c 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -1279,6 +1279,12 @@ static int __init setup_slub_debug(char *str)
> >       if (*str =3D=3D ',')
> >               slub_debug_slabs =3D str + 1;
> >  out:
> > +     if ((static_branch_unlikely(&init_on_alloc) ||
> > +          static_branch_unlikely(&init_on_free)) &&
> > +         (slub_debug & SLAB_POISON)) {
> > +             pr_warn("disabling SLAB_POISON: can't be used together wi=
th
> > memory auto-initialization\n");
> > +             slub_debug &=3D ~SLAB_POISON;
> > +     }
> >       return 1;
> >  }
>
> I don't think it is good idea to disable SLAB_POISON here as if people ha=
ve
> decided to enable SLUB_DEBUG later already, they probably care more to ma=
ke sure
> those additional checks with SLAB_POISON are still running to catch memor=
y
> corruption.
The problem is that freed buffers can't be both poisoned and zeroed at
the same time.
Do you think we need to disable memory initialization in that case instead?


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
