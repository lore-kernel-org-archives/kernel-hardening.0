Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 16:03:20 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Message-ID: <20160126070320.GB28254@js1304-P5Q-DELUXE>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] Re: [RFC][PATCH 0/3] Speed up SLUB poisoning + disable checks
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 25, 2016 at 05:15:10PM -0800, Laura Abbott wrote:
> Hi,
> 
> Based on the discussion from the series to add slab sanitization
> (lkml.kernel.org/g/<1450755641-7856-1-git-send-email-laura@labbott.name>)
> the existing SLAB_POISON mechanism already covers similar behavior.
> The performance of SLAB_POISON isn't very good. With hackbench -g 20 -l 1000
> on QEMU with one cpu:

I doesn't follow up that discussion, but, I think that reusing
SLAB_POISON for slab sanitization needs more changes. I assume that
completeness and performance is matter for slab sanitization.

1) SLAB_POISON isn't applied to specific kmem_cache which has
constructor or SLAB_DESTROY_BY_RCU flag. For debug, it's not necessary
to be applied, but, for slab sanitization, it is better to apply it to
all caches.

2) SLAB_POISON makes object size bigger so natural alignment will be
broken. For example, kmalloc(256) cache's size is 256 in normal
case but it would be 264 when SLAB_POISON is enabled. This causes
memory waste.

In fact, I'd prefer not reusing SLAB_POISON. It would make thing
simpler. But, it's up to Christoph.

Thanks.
