Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 09:01:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <20160126070320.GB28254@js1304-P5Q-DELUXE>
Message-ID: <alpine.DEB.2.20.1601260900370.27338@east.gentwo.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org> <20160126070320.GB28254@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC][PATCH 0/3] Speed up SLUB poisoning + disable checks
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 26 Jan 2016, Joonsoo Kim wrote:

> I doesn't follow up that discussion, but, I think that reusing
> SLAB_POISON for slab sanitization needs more changes. I assume that
> completeness and performance is matter for slab sanitization.
>
> 1) SLAB_POISON isn't applied to specific kmem_cache which has
> constructor or SLAB_DESTROY_BY_RCU flag. For debug, it's not necessary
> to be applied, but, for slab sanitization, it is better to apply it to
> all caches.

Those slabs can be legitimately accessed after the objects were freed. You
cannot sanitize nor poison.
