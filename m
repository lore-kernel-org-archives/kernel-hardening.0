Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Feb 2016 10:32:19 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1455561864-4217-4-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1602161031540.4158@east.gentwo.org>
References: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org> <1455561864-4217-4-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCHv2 3/4] slub: Convert SLAB_DEBUG_FREE to
 SLAB_CONSISTENCY_CHECKS
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 15 Feb 2016, Laura Abbott wrote:

> SLAB_DEBUG_FREE allows expensive consistency checks at free
> to be turned on or off. Expand its use to be able to turn
> off all consistency checks. This gives a nice speed up if
> you only want features such as poisoning or tracing.

Acked-by: Christoph Lameter <cl@linux.com>
