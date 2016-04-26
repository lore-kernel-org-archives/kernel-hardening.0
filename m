Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Apr 2016 09:19:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1461616763-60246-1-git-send-email-thgarnie@google.com>
Message-ID: <alpine.DEB.2.20.1604260916230.24585@east.gentwo.org>
References: <1461616763-60246-1-git-send-email-thgarnie@google.com>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] mm: SLAB freelist randomization
To: Thomas Garnier <thgarnie@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, gthelen@google.com, labbott@fedoraproject.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Apr 2016, Thomas Garnier wrote:

> To generate entropy, we use get_random_bytes_arch because 0 bits of
> entropy is available in the boot stage. In the worse case this function
> will fallback to the get_random_bytes sub API. We also generate a shift
> random number to shift pre-computed freelist for each new set of pages.
>
> The config option name is not specific to the SLAB as this approach will
> be extended to other allocators like SLUB.
>
> Performance results highlighted no major changes:

Ok. alloc/free tests are not affected since this exercises the per cpu
objects. And the other ones as well since most of the overhead occurs on
slab page initialization.

> Before:
> 10000 times kmalloc(1024) -> 393 cycles kfree -> 251 cycles
> 10000 times kmalloc(2048) -> 649 cycles kfree -> 228 cycles
> 10000 times kmalloc(4096) -> 806 cycles kfree -> 370 cycles
> 10000 times kmalloc(8192) -> 814 cycles kfree -> 411 cycles
> 10000 times kmalloc(16384) -> 892 cycles kfree -> 455 cycles
>
> After:
> 10000 times kmalloc(1024) -> 342 cycles kfree -> 157 cycles
> 10000 times kmalloc(2048) -> 701 cycles kfree -> 238 cycles
> 10000 times kmalloc(4096) -> 803 cycles kfree -> 364 cycles
> 10000 times kmalloc(8192) -> 835 cycles kfree -> 404 cycles
> 10000 times kmalloc(16384) -> 896 cycles kfree -> 441 cycles

And there is some slight regression with the larger objects. Not sure if
we are really hitting the slab page initialization too much there either.
Pretty minimal in synthetic tests. Can you run something like hackbench
too?

Otherwise this looks ok.

Acked-by: Christoph Lameter <cl@linux.com>
