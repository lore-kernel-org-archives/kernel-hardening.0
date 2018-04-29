Date: Sat, 28 Apr 2018 20:09:40 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 0/3] linux-next: mm: hardening: Track genalloc allocations
Message-ID: <20180429030940.GA2541@bombadil.infradead.org>
References: <20180429024542.19475-1-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180429024542.19475-1-igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: mhocko@kernel.org, akpm@linux-foundation.org, keescook@chromium.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, labbott@redhat.com, linux-kernel@vger.kernel.org, igor.stoppa@huawei.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Apr 29, 2018 at 06:45:39AM +0400, Igor Stoppa wrote:
> This patchset was created as part of an older version of pmalloc, however
> it has value per-se, as it hardens the memory management for the generic
> allocator genalloc.
> 
> Genalloc does not currently track the size of the allocations it hands out.
> 
> Either by mistake, or due to an attack, it is possible that more memory
> than what was initially allocated is freed, leaving behind dangling
> pointers, ready for an use-after-free attack.

This is a good point.  It is worth hardening genalloc.
But I still don't like the cost of the bitmap.  I've been
reading about allocators and I found Bonwick's paper from 2001:
https://www.usenix.org/legacy/event/usenix01/full_papers/bonwick/bonwick.pdf
Section 4 describes the vmem allocator which would seem to have superior
performance and lower memory overhead than the current genalloc allocator,
never mind the hardened allocator.

Maybe there's been an advnace in resource allocator technology since
then that someone more familiar with CS research can point out.
