Date: Wed, 14 Feb 2018 12:28:35 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 3/8] Convert virtio_console to kvzalloc_struct
Message-ID: <20180214202835.GE20627@bombadil.infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
 <20180214201154.10186-4-willy@infradead.org>
 <1518639587.3678.25.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1518639587.3678.25.camel@perches.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 14, 2018 at 12:19:47PM -0800, Joe Perches wrote:
> On Wed, 2018-02-14 at 12:11 -0800, Matthew Wilcox wrote:
> >  	 */
> > -	buf = kmalloc(sizeof(*buf) + sizeof(struct scatterlist) * pages,
> > -		      GFP_KERNEL);
> > +	buf = kvzalloc_struct(buf, sg, pages, GFP_KERNEL);
> >  	if (!buf)
> 
> kvfree?

Yes, that would also need to be done.  The point of these last six
patches was to show the API in use, not for applying.
