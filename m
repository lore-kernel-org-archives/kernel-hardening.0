Date: Thu, 15 Feb 2018 08:23:03 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
Message-ID: <20180215162303.GC12360@bombadil.infradead.org>
References: <20180214182618.14627-1-willy@infradead.org>
 <20180214182618.14627-3-willy@infradead.org>
 <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake>
 <20180214201400.GD20627@bombadil.infradead.org>
 <alpine.DEB.2.20.1802150953080.1902@nuc-kabylake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802150953080.1902@nuc-kabylake>
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 15, 2018 at 09:55:11AM -0600, Christopher Lameter wrote:
> On Wed, 14 Feb 2018, Matthew Wilcox wrote:
> 
> > > Uppercase like the similar KMEM_CACHE related macros in
> > > include/linux/slab.h?>
> >
> > Do you think that would look better in the users?  Compare:
> 
> Does looking matter? I thought we had the convention that macros are
> uppercase. There are some tricks going on with the struct. Uppercase shows
> that something special is going on.

  12) Macros, Enums and RTL
  -------------------------

  Names of macros defining constants and labels in enums are capitalized.

  .. code-block:: c

          #define CONSTANT 0x12345

  Enums are preferred when defining several related constants.

  CAPITALIZED macro names are appreciated but macros resembling functions
  may be named in lower case.

I dunno.  Yes, there's macro trickery going on here, but it certainly
resembles a function.  It doesn't fail any of the rules laid out in that
chapter of coding-style about unacceptable uses of macros.
