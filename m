Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 16 Feb 2016 10:33:42 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1455561864-4217-5-git-send-email-labbott@fedoraproject.org>
Message-ID: <alpine.DEB.2.20.1602161033260.4158@east.gentwo.org>
References: <1455561864-4217-1-git-send-email-labbott@fedoraproject.org> <1455561864-4217-5-git-send-email-labbott@fedoraproject.org>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCHv2 4/4] slub: Relax CMPXCHG consistency restrictions
To: Laura Abbott <labbott@fedoraproject.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 15 Feb 2016, Laura Abbott wrote:

> When debug options are enabled, cmpxchg on the page is disabled. This is
> because the page must be locked to ensure there are no false positives
> when performing consistency checks. Some debug options such as poisoning
> and red zoning only act on the object itself. There is no need to
> protect other CPUs from modification on only the object. Allow cmpxchg
> to happen with poisoning and red zoning are set on a slab.

Acked-by: Christoph Lameter <cl@linux.com>
