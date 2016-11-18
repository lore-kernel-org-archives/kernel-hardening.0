Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 18 Nov 2016 11:47:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au>
Message-ID: <alpine.DEB.2.20.1611181146330.26818@east.gentwo.org>
References: <1479376267-18486-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v2] slab: Add POISON_POINTER_DELTA to ZERO_SIZE_PTR
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: akpm@linux-foundation.org, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 17 Nov 2016, Michael Ellerman wrote:

> Currently ZERO_OR_NULL_PTR() uses a trick of doing a single check that
> x <= ZERO_SIZE_PTR, and ignoring the fact that it also matches 1-15.

Well yes that was done so we do not add too many branches all over the
kernel.....


> That no longer really works once we add the poison delta, so split it
> into two checks. Assign x to a temporary to avoid evaluating it
> twice (suggested by Kees Cook).

And now you are doing just that.
