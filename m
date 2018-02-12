MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180212165301.17933-1-igor.stoppa@huawei.com>
References: <20180212165301.17933-1-igor.stoppa@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 12 Feb 2018 15:32:36 -0800
Message-ID: <CAGXu5j+ZNFX17Vxd37rPnkahFepFn77Fi9zEy+OL8nNd_2bjqQ@mail.gmail.com>
Subject: Re: [RFC PATCH v16 0/6] mm: security: ro protection for dynamic data
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@huawei.com>, Dave Chinner <dchinner@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Jerome Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@infradead.org>, Christoph Lameter <cl@linux.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 12, 2018 at 8:52 AM, Igor Stoppa <igor.stoppa@huawei.com> wrote:
> This patch-set introduces the possibility of protecting memory that has
> been allocated dynamically.
>
> The memory is managed in pools: when a memory pool is turned into R/O,
> all the memory that is part of it, will become R/O.
>
> A R/O pool can be destroyed, to recover its memory, but it cannot be
> turned back into R/W mode.
>
> This is intentional. This feature is meant for data that doesn't need
> further modifications after initialization.

This series came up in discussions with Dave Chinner (and Matthew
Wilcox, already part of the discussion, and others) at LCA. I wonder
if XFS would make a good initial user of this, as it could allocate
all the function pointers and other const information about a
superblock in pmalloc(), keeping it separate from the R/W portions?
Could other filesystems do similar things?

Do you have other immediate users in mind for pmalloc? Adding those to
the series could really help both define the API and clarify the
usage.

-Kees

>
> However the data might need to be released, for example as part of module
> unloading.
> To do this, the memory must first be freed, then the pool can be destroyed.
>
> An example is provided, in the form of self-testing.
>
> Changes since v15:
> [http://www.openwall.com/lists/kernel-hardening/2018/02/11/4]
>
> - Fixed remaining broken comments
> - Fixed remaining broken "Returns" instead of "Return:" in kernel-doc
> - Converted "Return:" values to lists
> - Fixed SPDX license statements
>
> Igor Stoppa (6):
>   genalloc: track beginning of allocations
>   genalloc: selftest
>   struct page: add field for vm_struct
>   Protectable Memory
>   Pmalloc: self-test
>   Documentation for Pmalloc
>
>  Documentation/core-api/index.rst   |   1 +
>  Documentation/core-api/pmalloc.rst | 114 +++++++
>  include/linux/genalloc-selftest.h  |  26 ++
>  include/linux/genalloc.h           |   7 +-
>  include/linux/mm_types.h           |   1 +
>  include/linux/pmalloc.h            | 242 ++++++++++++++
>  include/linux/vmalloc.h            |   1 +
>  init/main.c                        |   2 +
>  lib/Kconfig                        |  15 +
>  lib/Makefile                       |   1 +
>  lib/genalloc-selftest.c            | 400 ++++++++++++++++++++++
>  lib/genalloc.c                     | 658 +++++++++++++++++++++++++++----------
>  mm/Kconfig                         |  15 +
>  mm/Makefile                        |   2 +
>  mm/pmalloc-selftest.c              |  64 ++++
>  mm/pmalloc-selftest.h              |  24 ++
>  mm/pmalloc.c                       | 501 ++++++++++++++++++++++++++++
>  mm/usercopy.c                      |  33 ++
>  mm/vmalloc.c                       |  18 +-
>  19 files changed, 1950 insertions(+), 175 deletions(-)
>  create mode 100644 Documentation/core-api/pmalloc.rst
>  create mode 100644 include/linux/genalloc-selftest.h
>  create mode 100644 include/linux/pmalloc.h
>  create mode 100644 lib/genalloc-selftest.c
>  create mode 100644 mm/pmalloc-selftest.c
>  create mode 100644 mm/pmalloc-selftest.h
>  create mode 100644 mm/pmalloc.c
>
> --
> 2.14.1
>



-- 
Kees Cook
Pixel Security
