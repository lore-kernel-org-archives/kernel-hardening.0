MIME-Version: 1.0
References: <20190412124501.132678-1-glider@google.com> <20190415190213.5831bbc17e5073690713b001@linux-foundation.org>
In-Reply-To: <20190415190213.5831bbc17e5073690713b001@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Apr 2019 14:21:59 +0200
Message-ID: <CAG_fn=W1rELLO4mx1RoM01shFVkyQjT3eU5wyqMRjprzVD5oMQ@mail.gmail.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 16, 2019 at 4:02 AM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Fri, 12 Apr 2019 14:45:01 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> > This config option adds the possibility to initialize newly allocated
> > pages and heap objects with zeroes.
>
> At what cost?  Some performance test results would help this along.
I'll make more measurements for the new implementation, but the
preliminary results are:
~0.17% sys time slowdown (~0% wall time slowdown) on hackbench (1 CPU);
1.3% sys time slowdown (0.2% wall time slowdown) when building Linux with -=
j12;
4% sys time slowdown (2.6% wall time slowdown) on af_inet_loopback benchmar=
k;
up to 100% slowdown on netperf (caused by sk buffers being initialized
multiple times; also netperf is too fast to perform any precise
measurements)

Are there any benchmarks you can recommend?
> > This is needed to prevent possible
> > information leaks and make the control-flow bugs that depend on
> > uninitialized values more deterministic.
> >
> > Initialization is done at allocation time at the places where checks fo=
r
> > __GFP_ZERO are performed. We don't initialize slab caches with
> > constructors or SLAB_TYPESAFE_BY_RCU to preserve their semantics.
> >
> > For kernel testing purposes filling allocations with a nonzero pattern
> > would be more suitable, but may require platform-specific code. To have
> > a simple baseline we've decided to start with zero-initialization.
> >
> > No performance optimizations are done at the moment to reduce double
> > initialization of memory regions.
>
> Requiring a kernel rebuild is rather user-hostile.
This is intended to be used together with other hardening measures,
like CONFIG_INIT_STACK_ALL (see a patchset by Kees).
All of those require a kernel rebuild, but we assume users don't push
and pull that lever back and forth often.

> A boot option
> (early_param()) would be much more useful and I expect that the loss in
> coverage would be small and acceptable?  Could possibly use the
> static_branch infrastructure.
I'll try that out and see if there's a notable performance difference.

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
> Is there any reason why this *must* be implemented as a macro?  If not,
> it should be written in C please.
Agreed. Even in the case we want GFP_INIT_ALWAYS_ON to be known at
compile time there's no reason for this to be a macro.
>


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
