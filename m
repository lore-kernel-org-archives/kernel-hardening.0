Date: Fri, 2 Jun 2017 14:07:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20170602140743.274b9babba6118bfd12c7a26@linux-foundation.org>
In-Reply-To: <20170526095404.20439-1-danielmicay@gmail.com>
References: <20170526095404.20439-1-danielmicay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>, Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 26 May 2017 05:54:04 -0400 Daniel Micay <danielmicay@gmail.com> wrote:

> This adds support for compiling with a rough equivalent to the glibc
> _FORTIFY_SOURCE=1 feature, providing compile-time and runtime buffer
> overflow checks for string.h functions when the compiler determines the
> size of the source or destination buffer at compile-time. Unlike glibc,
> it covers buffer reads in addition to writes.

Did we find a bug in drivers/infiniband/sw/rxe/rxe_resp.c?

i386 allmodconfig:

In file included from ./include/linux/bitmap.h:8:0,
                 from ./include/linux/cpumask.h:11,
                 from ./include/linux/mm_types_task.h:13,
                 from ./include/linux/mm_types.h:4,
                 from ./include/linux/kmemcheck.h:4,
                 from ./include/linux/skbuff.h:18,
                 from drivers/infiniband/sw/rxe/rxe_resp.c:34:
In function 'memcpy',
    inlined from 'send_atomic_ack.constprop' at drivers/infiniband/sw/rxe/rxe_resp.c:998:2,
    inlined from 'acknowledge' at drivers/infiniband/sw/rxe/rxe_resp.c:1026:3,
    inlined from 'rxe_responder' at drivers/infiniband/sw/rxe/rxe_resp.c:1286:10:
./include/linux/string.h:309:4: error: call to '__read_overflow2' declared with attribute error: detected read beyond size of object passed as 2nd parameter
    __read_overflow2();


If so, can you please interpret this for the infiniband developers?
