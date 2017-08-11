Date: Fri, 11 Aug 2017 12:26:19 -0500 (CDT)
From: Christopher Lameter <cl@linux.com>
In-Reply-To: <1502468246-1262-1-git-send-email-alex.popov@linux.com>
Message-ID: <alpine.DEB.2.20.1708111225560.3131@nuc-kabylake>
References: <1502468246-1262-1-git-send-email-alex.popov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [linux-next][PATCH v2] mm/slub.c: add a naive detection of double
 free or corruption
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Paul E McKenney <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>, Andy Lutomirski <luto@kernel.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, linux-mm@kvack.org, Rik van Riel <riel@redhat.com>, Tycho Andersen <tycho@docker.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 11 Aug 2017, Alexander Popov wrote:

> Add an assertion similar to "fasttop" check in GNU C Library allocator
> as a part of SLAB_FREELIST_HARDENED feature. An object added to a singly
> linked freelist should not point to itself. That helps to detect some
> double free errors (e.g. CVE-2017-2636) without slub_debug and KASAN.

Acked-by: Christoph Lameter <cl@linux.com>
