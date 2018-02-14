Date: Wed, 14 Feb 2018 13:55:59 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
In-Reply-To: <20180214182618.14627-3-willy@infradead.org>
Message-ID: <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake>
References: <20180214182618.14627-1-willy@infradead.org> <20180214182618.14627-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 14 Feb 2018, Matthew Wilcox wrote:

> +#define kvzalloc_struct(p, member, n, gfp)				\
> +	(typeof(p))kvzalloc_ab_c(n,					\
> +		sizeof(*(p)->member) + __must_be_array((p)->member),	\
> +		offsetof(typeof(*(p)), member), gfp)
> +

Uppercase like the similar KMEM_CACHE related macros in
include/linux/slab.h?>
