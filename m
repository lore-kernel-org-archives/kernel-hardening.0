MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com>
In-Reply-To: <20190418154208.131118-1-glider@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 18 Apr 2019 17:44:20 +0200
Message-ID: <CAG_fn=WZbf8CfxHB2SXpR5OON3NP3GkfPWQ1OeooqJRBao28rQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] RFC: add init_allocations=1 boot option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 5:42 PM Alexander Potapenko <glider@google.com> wro=
te:
>
> Following the recent discussions here's another take at initializing
> pages and heap objects with zeroes. This is needed to prevent possible
> information leaks and make the control-flow bugs that depend on
> uninitialized values more deterministic.
>
> The patchset introduces a new boot option, init_allocations, which
> makes page allocator and SL[AOU]B initialize newly allocated memory.
> init_allocations=3D0 doesn't (hopefully) add any overhead to the
> allocation fast path (no noticeable slowdown on hackbench).
>
> With only the the first of the proposed patches the slowdown numbers are:
>  - 1.1% (stdev 0.2%) sys time slowdown building Linux kernel
>  - 3.1% (stdev 0.3%) sys time slowdown on af_inet_loopback benchmark
>  - 9.4% (stdev 0.5%) sys time slowdown on hackbench
>
> The second patch introduces a GFP flag that allows to disable
> initialization for certain allocations. The third page is an example of
> applying it to af_unix.c, which helps hackbench greatly.
>
> Slowdown numbers for the whole patchset are:
>  - 1.8% (stdev 0.8%) on kernel build
>  - 6.5% (stdev 0.2%) on af_inet_loopback
>  - 0.12% (stdev 0.6%) on hackbench
>
>
> Alexander Potapenko (3):
>   mm: security: introduce the init_allocations=3D1 boot option
>   gfp: mm: introduce __GFP_NOINIT
>   net: apply __GFP_NOINIT to AF_UNIX sk_buff allocations
Oops, I was hoping git send-email would pull all the Cc: tags from the
patches and actually use them.
>  drivers/infiniband/core/uverbs_ioctl.c |  2 +-
>  include/linux/gfp.h                    |  6 ++++-
>  include/linux/mm.h                     |  8 +++++++
>  include/linux/slab_def.h               |  1 +
>  include/linux/slub_def.h               |  1 +
>  include/net/sock.h                     |  5 +++++
>  kernel/kexec_core.c                    |  4 ++--
>  mm/dmapool.c                           |  2 +-
>  mm/page_alloc.c                        | 18 ++++++++++++++-
>  mm/slab.c                              | 14 ++++++------
>  mm/slab.h                              |  1 +
>  mm/slab_common.c                       | 15 +++++++++++++
>  mm/slob.c                              |  3 ++-
>  mm/slub.c                              |  9 ++++----
>  net/core/sock.c                        | 31 +++++++++++++++++++++-----
>  net/unix/af_unix.c                     | 13 ++++++-----
>  16 files changed, 104 insertions(+), 29 deletions(-)
>
> --
> 2.21.0.392.gf8f6787159e-goog
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
