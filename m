MIME-Version: 1.0
References: <20190412124501.132678-1-glider@google.com> <35935775-1c0d-6016-5bb3-0abee65a7492@suse.cz>
In-Reply-To: <35935775-1c0d-6016-5bb3-0abee65a7492@suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 16 Apr 2019 14:04:49 +0200
Message-ID: <CAG_fn=VYa0CtxDeXOV0Mpj3q_i150NJioyJWGLA3OEij3iSH1A@mail.gmail.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 16, 2019 at 10:33 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>
> On 4/12/19 2:45 PM, Alexander Potapenko wrote:
> > +config INIT_HEAP_ALL
> > +     bool "Initialize kernel heap allocations"
>
> Calling slab and page allocations together as "heap" is rather uncommon
> in the kernel I think. But I don't have a better word right now.
We can provide two separate flags for slab and page allocator to avoid this=
.
I cannot think of a situation where this level of control is necessary
though (apart from benchmarking).
> > +     default n
> > +     help
> > +       Enforce initialization of pages allocated from page allocator
> > +       and objects returned by kmalloc and friends.
> > +       Allocated memory is initialized with zeroes, preventing possibl=
e
> > +       information leaks and making the control-flow bugs that depend
> > +       on uninitialized values more deterministic.
> > +
> >  config GCC_PLUGIN_STRUCTLEAK_VERBOSE
> >       bool "Report forcefully initialized variables"
> >       depends on GCC_PLUGIN_STRUCTLEAK
> >
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
