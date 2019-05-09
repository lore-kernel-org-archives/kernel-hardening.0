MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-2-glider@google.com>
 <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
In-Reply-To: <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 9 May 2019 18:43:21 +0200
Message-ID: <CAG_fn=UDyVpZz5=oP4HHdYCB43NnXG1sLypRXopyEk9qgq471A@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Kees Cook <keescook@chromium.org>
Date: Wed, May 8, 2019 at 9:02 PM
To: Alexander Potapenko
Cc: Andrew Morton, Christoph Lameter, Kees Cook, Laura Abbott,
Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland

> On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> wr=
ote:
> > The new options are needed to prevent possible information leaks and
> > make control-flow bugs that depend on uninitialized values more
> > deterministic.
>
> I like having this available on both alloc and free. This makes it
> much more configurable for the end users who can adapt to their work
> loads, etc.
>
> > Linux build with -j12, init_on_free=3D1:  +24.42% sys time (st.err 0.52=
%)
> > [...]
> > Linux build with -j12, init_on_alloc=3D1: +0.57% sys time (st.err 0.40%=
)
>
> Any idea why there is such a massive difference here? This seems to
> high just for cache-locality effects of touching all the freed pages.
I've measured a single `make -j12` again under perf stat.

The numbers for init_on_alloc=3D1 were:

        4936513177      cache-misses              #    8.056 % of all
cache refs      (44.44%)
       61278262461      cache-references
               (44.45%)
          42844784      page-faults
     1449630221347      L1-dcache-loads
               (44.45%)
       50569965485      L1-dcache-load-misses     #    3.49% of all
L1-dcache hits    (44.44%)
      299987258588      L1-icache-load-misses
               (44.44%)
     1449857258648      dTLB-loads
               (44.45%)
         826292490      dTLB-load-misses          #    0.06% of all
dTLB cache hits   (44.44%)
       22028472701      iTLB-loads
               (44.44%)
         858451905      iTLB-load-misses          #    3.90% of all
iTLB cache hits   (44.45%)
     162.120107145 seconds time elapsed

, and for init_on_free=3D1:

        6666716777      cache-misses              #   10.862 % of all
cache refs      (44.45%)
       61378258434      cache-references
               (44.46%)
          42850913      page-faults
     1449986416063      L1-dcache-loads
               (44.45%)
       51277338771      L1-dcache-load-misses     #    3.54% of all
L1-dcache hits    (44.45%)
      298295905805      L1-icache-load-misses
               (44.44%)
     1450378031344      dTLB-loads
               (44.43%)
         807011341      dTLB-load-misses          #    0.06% of all
dTLB cache hits   (44.44%)
       22044976638      iTLB-loads
               (44.44%)
         846377845      iTLB-load-misses          #    3.84% of all
iTLB cache hits   (44.45%)
     164.427054893 seconds time elapsed


(note that we don't see the speed difference under perf)

init_on_free=3D1 causes 1.73B more cache misses than init_on_alloc=3D1.
If I'm understanding correctly, a cache miss costs 12-14 cycles on my
3GHz Skylake CPU, which can explain explain a 7-8-second difference
between the two modes.
But as I just realized this is both kernel and userspace, so while the
difference is almost correct for wall time (120s for init_on_alloc,
130s for init_on_free) this doesn't tell much about the time spent in
the kernel.

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
