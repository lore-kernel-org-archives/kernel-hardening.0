Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 22 Dec 2015 10:25:00 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <567964F3.2020402@intel.com>
Message-ID: <alpine.DEB.2.20.1512221023550.2748@east.gentwo.org>
References: <1450755641-7856-1-git-send-email-laura@labbott.name> <1450755641-7856-7-git-send-email-laura@labbott.name> <567964F3.2020402@intel.com>
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Dave Hansen <dave.hansen@intel.com>
Cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <laura@labbott.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 22 Dec 2015, Dave Hansen wrote:

> On 12/21/2015 07:40 PM, Laura Abbott wrote:
> > +	  The tradeoff is performance impact. The noticible impact can vary
> > +	  and you are advised to test this feature on your expected workload
> > +	  before deploying it
>
> What if instead of writing SLAB_MEMORY_SANITIZE_VALUE, we wrote 0's?
> That still destroys the information, but it has the positive effect of
> allowing a kzalloc() call to avoid zeroing the slab object.  It might
> mitigate some of the performance impact.

We already write zeros in many cases or the object is initialized in a
different. No one really wants an uninitialized object. The problem may be
that a freed object is having its old content until reused. Which is
something that poisoning deals with.
