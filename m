Message-ID: <1555078584.26196.50.camel@lca.pw>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
From: Qian Cai <cai@lca.pw>
Date: Fri, 12 Apr 2019 10:16:24 -0400
In-Reply-To: <20190412124501.132678-1-glider@google.com>
References: <20190412124501.132678-1-glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org, ndesaulniers@google.com, kcc@google.com, dvyukov@google.com, keescook@chromium.org, sspatil@android.com, labbott@redhat.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2019-04-12 at 14:45 +0200, Alexander Potapenko wrote:
> This config option adds the possibility to initialize newly allocated
> pages and heap objects with zeroes. This is needed to prevent possible
> information leaks and make the control-flow bugs that depend on
> uninitialized values more deterministic.
> 
> Initialization is done at allocation time at the places where checks for
> __GFP_ZERO are performed. We don't initialize slab caches with
> constructors or SLAB_TYPESAFE_BY_RCU to preserve their semantics.
> 
> For kernel testing purposes filling allocations with a nonzero pattern
> would be more suitable, but may require platform-specific code. To have
> a simple baseline we've decided to start with zero-initialization.
> 
> No performance optimizations are done at the moment to reduce double
> initialization of memory regions.

Sounds like this has already existed in some degree, i.e.,

CONFIG_PAGE_POISONING_ZERO
