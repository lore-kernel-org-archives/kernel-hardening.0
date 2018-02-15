Date: Thu, 15 Feb 2018 09:55:11 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
In-Reply-To: <20180214201400.GD20627@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1802150953080.1902@nuc-kabylake>
References: <20180214182618.14627-1-willy@infradead.org> <20180214182618.14627-3-willy@infradead.org> <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake> <20180214201400.GD20627@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 14 Feb 2018, Matthew Wilcox wrote:

> > Uppercase like the similar KMEM_CACHE related macros in
> > include/linux/slab.h?>
>
> Do you think that would look better in the users?  Compare:

Does looking matter? I thought we had the convention that macros are
uppercase. There are some tricks going on with the struct. Uppercase shows
that something special is going on.

> Making it look like a function is more pleasing to my eye, but I'll
> change it if that's the only thing keeping it from being merged.

This should be consistent throughout the source.
