Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 26 Jan 2016 10:19:08 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1453770913-32287-2-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1601261018500.27338@east.gentwo.org>
References: <1453770913-32287-1-git-send-email-labbott@fedoraproject.org> <1453770913-32287-2-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC][PATCH 1/3] slub: Drop lock at the end of
 free_debug_processing
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 25 Jan 2016, Laura Abbott wrote:

> Currently, free_debug_processing has a comment "Keep node_lock to preserve
> integrity until the object is actually freed". In actuallity,
> the lock is dropped immediately in __slab_free. Rather than wait until
> __slab_free and potentially throw off the unlikely marking, just drop
> the lock in __slab_free. This also lets free_debug_processing take
> its own copy of the spinlock flags rather than trying to share the ones
> from __slab_free. Since there is no use for the node afterwards, change
> the return type of free_debug_processing to return an int like
> alloc_debug_processing.

Acked-by: Christoph Lameter <cl@linux.com>\
