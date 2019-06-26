Return-Path: 
 <kernel-hardening-return-16252-ydroneaud=opteya.com@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com>
In-Reply-To: <20190626121943.131390-1-glider@google.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 26 Jun 2019 14:26:57 +0200
Message-ID: <CAG_fn=V5o-wt5PQ4LSarpXrEGfbrdbtSFqOOag=nmMrxf4gfnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [PATCH v8 0/3] add init_on_alloc/init_on_free boot options
Content-Transfer-Encoding: 8bit
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>

On Wed, Jun 26, 2019 at 2:19 PM Alexander Potapenko <glider@google.com> wrote:
>
> Provide init_on_alloc and init_on_free boot options.
akpm: May I kindly ask you to replace the two patches from this series
in the -mm tree with their newer versions?

> These are aimed at preventing possible information leaks and making the
> control-flow bugs that depend on uninitialized values more deterministic.
>
> Enabling either of the options guarantees that the memory returned by the
> page allocator and SL[AU]B is initialized with zeroes.
> SLOB allocator isn't supported at the moment, as its emulation of kmem
> caches complicates handling of SLAB_TYPESAFE_BY_RCU caches correctly.
>
> Enabling init_on_free also guarantees that pages and heap objects are
> initialized right after they're freed, so it won't be possible to access
> stale data by using a dangling pointer.
>
> As suggested by Michal Hocko, right now we don't let the heap users to
> disable initialization for certain allocations. There's not enough
> evidence that doing so can speed up real-life cases, and introducing
> ways to opt-out may result in things going out of control.
>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Christoph Lameter <cl@linux.com>
> To: Kees Cook <keescook@chromium.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
>
> Alexander Potapenko (2):
>   mm: security: introduce init_on_alloc=1 and init_on_free=1 boot
>     options
>   mm: init: report memory auto-initialization features at boot time
>
>  .../admin-guide/kernel-parameters.txt         |  9 +++
>  drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
>  include/linux/mm.h                            | 22 ++++++
>  init/main.c                                   | 24 +++++++
>  mm/dmapool.c                                  |  4 +-
>  mm/page_alloc.c                               | 71 +++++++++++++++++--
>  mm/slab.c                                     | 16 ++++-
>  mm/slab.h                                     | 19 +++++
>  mm/slub.c                                     | 43 +++++++++--
>  net/core/sock.c                               |  2 +-
>  security/Kconfig.hardening                    | 29 +++++++++
>  12 files changed, 204 insertions(+), 19 deletions(-)
> ---
>  v3: dropped __GFP_NO_AUTOINIT patches
>  v5: dropped support for SLOB allocator, handle SLAB_TYPESAFE_BY_RCU
>  v6: changed wording in boot-time message
>  v7: dropped the test_meminit.c patch (picked by Andrew Morton already),
>      minor wording changes
>  v8: fixes for interoperability with other heap debugging features
> --
> 2.22.0.410.gd8fdbe21b5-goog
>


-- 
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Straße, 33
80636 München

Geschäftsführer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
