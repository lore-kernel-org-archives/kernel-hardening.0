Message-ID: <1518634058.3678.15.camel@perches.com>
Subject: Re: [PATCH 0/2] Add kvzalloc_struct to complement kvzalloc_array
From: Joe Perches <joe@perches.com>
Date: Wed, 14 Feb 2018 10:47:38 -0800
In-Reply-To: <20180214182618.14627-1-willy@infradead.org>
References: <20180214182618.14627-1-willy@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2018-02-14 at 10:26 -0800, Matthew Wilcox wrote:
> From: Matthew Wilcox <mawilcox@microsoft.com>
> 
> We all know the perils of multiplying a value provided from userspace
> by a constant and then allocating the resulting number of bytes.  That's
> why we have kvmalloc_array(), so we don't have to think about it.
> This solves the same problem when we embed one of these arrays in a
> struct like this:
> 
> struct {
> 	int n;
> 	unsigned long array[];
> };

I think expanding the number of allocation functions
is not necessary.
