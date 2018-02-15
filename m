Date: Thu, 15 Feb 2018 11:06:54 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
In-Reply-To: <20180215162303.GC12360@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1802151104140.2970@nuc-kabylake>
References: <20180214182618.14627-1-willy@infradead.org> <20180214182618.14627-3-willy@infradead.org> <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake> <20180214201400.GD20627@bombadil.infradead.org> <alpine.DEB.2.20.1802150953080.1902@nuc-kabylake>
 <20180215162303.GC12360@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 15 Feb 2018, Matthew Wilcox wrote:

> I dunno.  Yes, there's macro trickery going on here, but it certainly
> resembles a function.  It doesn't fail any of the rules laid out in that
> chapter of coding-style about unacceptable uses of macros.

It sure looks like a function but does magic things with the struct
parameter. So its not working like a function and the capitalization makes
one aware of that.
