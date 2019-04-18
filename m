Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot
 option
References: <20190418154208.131118-1-glider@google.com>
 <20190418154208.131118-2-glider@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ff1f408b-cf37-7df0-2393-7bc2078f6c63@infradead.org>
Date: Thu, 18 Apr 2019 15:08:37 -0700
MIME-Version: 1.0
In-Reply-To: <20190418154208.131118-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org, cl@linux.com, dvyukov@google.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> This option adds the possibility to initialize newly allocated pages and
> heap objects with zeroes. This is needed to prevent possible information
> leaks and make the control-flow bugs that depend on uninitialized values
> more deterministic.
> 
> Initialization is done at allocation time at the places where checks for
> __GFP_ZERO are performed. We don't initialize slab caches with
> constructors to preserve their semantics. To reduce runtime costs of
> checking cachep->ctor we replace a call to memset with a call to
> cachep->poison_fn, which is only executed if the memory block needs to
> be initialized.
> 
> For kernel testing purposes filling allocations with a nonzero pattern
> would be more suitable, but may require platform-specific code. To have
> a simple baseline we've decided to start with zero-initialization.
> 
> No performance optimizations are done at the moment to reduce double
> initialization of memory regions.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> ---
>  drivers/infiniband/core/uverbs_ioctl.c |  2 +-
>  include/linux/mm.h                     |  8 ++++++++
>  include/linux/slab_def.h               |  1 +
>  include/linux/slub_def.h               |  1 +
>  kernel/kexec_core.c                    |  2 +-
>  mm/dmapool.c                           |  2 +-
>  mm/page_alloc.c                        | 18 +++++++++++++++++-
>  mm/slab.c                              | 12 ++++++------
>  mm/slab.h                              |  1 +
>  mm/slab_common.c                       | 15 +++++++++++++++
>  mm/slob.c                              |  2 +-
>  mm/slub.c                              |  8 ++++----
>  net/core/sock.c                        |  2 +-
>  13 files changed, 58 insertions(+), 16 deletions(-)
> 

Hi,
Please document init_allocations=N in Documentation/admin-guide/kernel-parameters.txt.

thanks.
-- 
~Randy
