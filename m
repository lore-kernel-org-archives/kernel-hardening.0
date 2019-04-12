MIME-Version: 1.0
References: <20190412124501.132678-1-glider@google.com> <1555078584.26196.50.camel@lca.pw>
In-Reply-To: <1555078584.26196.50.camel@lca.pw>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Apr 2019 17:23:15 +0200
Message-ID: <CAG_fn=UrF6+yvXrok0Ca3dP2WZK7EOqE0NB24sR9WgMb=UuR-Q@mail.gmail.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Qian Cai <cai@lca.pw>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 12, 2019 at 4:16 PM Qian Cai <cai@lca.pw> wrote:
>
> On Fri, 2019-04-12 at 14:45 +0200, Alexander Potapenko wrote:
> > This config option adds the possibility to initialize newly allocated
> > pages and heap objects with zeroes. This is needed to prevent possible
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
> Sounds like this has already existed in some degree, i.e.,
>
> CONFIG_PAGE_POISONING_ZERO
Note that CONFIG_PAGE_POISONING[_ZERO] initializes freed pages,
whereas the proposed patch initializes newly allocated pages.
It's debatable whether initializing pages on kmalloc()/alloc_pages()
is better or worse than doing so in kfree()/free_pages() from the
security perspective.
But the approach proposed in the patch makes it possible to use a
special GFP flag to request uninitialized memory from the underlying
allocator, so that we don't wipe it twice.
This will be harder to do in the functions that free memory, because
they don't accept GFP flags.




--
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
