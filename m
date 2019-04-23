MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com>
In-Reply-To: <20190418154208.131118-1-glider@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Apr 2019 11:49:05 -0700
Message-ID: <CAGXu5j+tJJbyoZ=nSpSeiihD=NHwFJ6G9Ku5c21G5nQfEiKPwQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] RFC: add init_allocations=1 boot option
Content-Type: text/plain; charset="UTF-8"
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 8:42 AM Alexander Potapenko <glider@google.com> wrote:
>
> Following the recent discussions here's another take at initializing
> pages and heap objects with zeroes. This is needed to prevent possible
> information leaks and make the control-flow bugs that depend on
> uninitialized values more deterministic.
>
> The patchset introduces a new boot option, init_allocations, which
> makes page allocator and SL[AOU]B initialize newly allocated memory.
> init_allocations=0 doesn't (hopefully) add any overhead to the
> allocation fast path (no noticeable slowdown on hackbench).

I continue to prefer to have a way to both at-allocation
initialization _and_ poison-on-free, so let's not redirect this to
doing it only at free time. We're going to need both hooks when doing
Memory Tagging, so let's just get it in place now. The security
benefits on tagging, IMO, easily justify a 1-2% performance hit. And
likely we'll see this improve with new hardware.

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

Any idea why thes two went _up_?

>  - 0.12% (stdev 0.6%) on hackbench

Well that's quite an improvement. :)

-- 
Kees Cook
