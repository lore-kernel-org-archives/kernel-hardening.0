Message-ID: <1518640239.3678.26.camel@perches.com>
Subject: Re: [PATCH v2 3/8] Convert virtio_console to kvzalloc_struct
From: Joe Perches <joe@perches.com>
Date: Wed, 14 Feb 2018 12:30:39 -0800
In-Reply-To: <20180214202835.GE20627@bombadil.infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
	 <20180214201154.10186-4-willy@infradead.org>
	 <1518639587.3678.25.camel@perches.com>
	 <20180214202835.GE20627@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2018-02-14 at 12:28 -0800, Matthew Wilcox wrote:
> On Wed, Feb 14, 2018 at 12:19:47PM -0800, Joe Perches wrote:
> > On Wed, 2018-02-14 at 12:11 -0800, Matthew Wilcox wrote:
> > >  	 */
> > > -	buf = kmalloc(sizeof(*buf) + sizeof(struct scatterlist) * pages,
> > > -		      GFP_KERNEL);
> > > +	buf = kvzalloc_struct(buf, sg, pages, GFP_KERNEL);
> > >  	if (!buf)
> > 
> > kvfree?
> 
> Yes, that would also need to be done.  The point of these last six
> patches was to show the API in use, not for applying.

That's what RFC is for...
