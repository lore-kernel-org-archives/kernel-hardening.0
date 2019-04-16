MIME-Version: 1.0
References: <20190412124501.132678-1-glider@google.com> <0100016a26c711be-b99971ca-49f5-482c-9028-962ee471f733-000000@email.amazonses.com>
In-Reply-To: <0100016a26c711be-b99971ca-49f5-482c-9028-962ee471f733-000000@email.amazonses.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Apr 2019 18:01:38 +0200
Message-ID: <CAG_fn=U6aWfBXdkcWs0_1pqggAC16Yg8Q6rxLiVeiO83q1hOCw@mail.gmail.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 16, 2019 at 5:32 PM Christopher Lameter <cl@linux.com> wrote:
>
> On Fri, 12 Apr 2019, Alexander Potapenko wrote:
>
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 43ac818b8592..4bb10af0031b 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -167,6 +167,16 @@ static inline slab_flags_t kmem_cache_flags(unsign=
ed int object_size,
> >                             SLAB_TEMPORARY | \
> >                             SLAB_ACCOUNT)
> >
> > +/*
> > + * Do we need to initialize this allocation?
> > + * Always true for __GFP_ZERO, CONFIG_INIT_HEAP_ALL enforces initializ=
ation
> > + * of caches without constructors and RCU.
> > + */
> > +#define SLAB_WANT_INIT(cache, gfp_flags) \
> > +     ((GFP_INIT_ALWAYS_ON && !(cache)->ctor && \
> > +       !((cache)->flags & SLAB_TYPESAFE_BY_RCU)) || \
> > +      (gfp_flags & __GFP_ZERO))
>
> This is another complex thing to maintain when adding flags to the slab
> allocator.
>
> > +config INIT_HEAP_ALL
> > +     bool "Initialize kernel heap allocations"
>
> "Zero pages and objects allocated in the kernel"
>
> > +     default n
> > +     help
> > +       Enforce initialization of pages allocated from page allocator
> > +       and objects returned by kmalloc and friends.
> > +       Allocated memory is initialized with zeroes, preventing possibl=
e
> > +       information leaks and making the control-flow bugs that depend
> > +       on uninitialized values more deterministic.
>
> Hmmm... But we already have debugging options that poison objects and
> pages?
Laura Abbott mentioned in one of the previous threads
(https://marc.info/?l=3Dkernel-hardening&m=3D155474181528491&w=3D2) that:

"""
I've looked at doing something similar in the past (failing to find
the thread this morning...) and while this will work, it has pretty
serious performance issues. It's not actually the poisoning which
is expensive but that turning on debugging removes the cpu slab
which has significant performance penalties.

I'd rather go back to the proposal of just poisoning the slab
at alloc/free without using SLAB_POISON.
"""
, so slab poisoning is probably off the table.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
