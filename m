Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 22 Dec 2015 12:08:17 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <56798851.60906@intel.com>
Message-ID: <alpine.DEB.2.20.1512221207230.14406@east.gentwo.org>
References: <1450755641-7856-1-git-send-email-laura@labbott.name> <1450755641-7856-7-git-send-email-laura@labbott.name> <567964F3.2020402@intel.com> <alpine.DEB.2.20.1512221023550.2748@east.gentwo.org> <567986E7.50107@intel.com> <alpine.DEB.2.20.1512221124230.14335@east.gentwo.org>
 <56798851.60906@intel.com>
Content-Type: text/plain; charset=US-ASCII
Subject: Re: [kernel-hardening] [RFC][PATCH 6/7] mm: Add Kconfig option for
 slab sanitization
To: Dave Hansen <dave.hansen@intel.com>
Cc: kernel-hardening@lists.openwall.com, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Laura Abbott <laura@labbott.name>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 22 Dec 2015, Dave Hansen wrote:

> > Why would you use zeros? The point is just to clear the information right?
> > The regular poisoning does that.
>
> It then allows you to avoid the zeroing at allocation time.

Well much of the code is expecting a zeroed object from the allocator and
its zeroed at that time. Zeroing makes the object cache hot which is an
important performance aspect.
