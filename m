Date: Mon, 12 Feb 2018 13:36:33 +0200
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/6] genalloc: track beginning of allocations
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-2-igor.stoppa@huawei.com>
 <20180211122444.GB13931@rapoport-lnx>
 <f0a244f2-f63a-376b-28f2-debbe914da34@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0a244f2-f63a-376b-28f2-debbe914da34@huawei.com>
Message-Id: <20180212113633.GC20737@rapoport-lnx>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 12, 2018 at 01:17:01PM +0200, Igor Stoppa wrote:
> 
> 
> On 11/02/18 14:24, Mike Rapoport wrote:
> > On Sun, Feb 11, 2018 at 05:19:15AM +0200, Igor Stoppa wrote:
> [...]
> 
> >> +/**
> >> + * mem_to_units - convert references to memory into orders of allocation
> > 
> > Documentation/doc-guide/kernel-doc.rst recommends to to include brackets
> > for function comments. I haven't noticed any difference in the resulting
> > html, so I'm not sure if the brackets are actually required.
> 
> This is what I see in the example from mailine docs:
> 
> /**
>  * foobar() - Brief description of foobar.
>  * @argument1: Description of parameter argument1 of foobar.
>  * @argument2: Description of parameter argument2 of foobar.
>  *
>  * Longer description of foobar.
>  *
>  * Return: Description of return value of foobar.
>  */
> int foobar(int argument1, char *argument2)
> 
> 
> What are you referring to?
 
I'm referring to "foobar() - brief description" vs "foobar - brief
description".

The generated html looks exactly the same in the browser, so I don't know
if the brackets are really required.

> [...]
> 
> >> + * @size: amount in bytes
> >> + * @order: power of 2 represented by each entry in the bitmap
> >> + *
> >> + * Returns the number of units representing the size.
> > 
> > Please s/Return/Return:/
> 
> :-( I thought I had fixed them all. thanks for spotting this.
> 
> [...]
> 
> >> + * Return: If two users alter the same bit, to one it will return
> >> + * remaining entries, to the other it will return 0.
> > 
> > And what if there are three or four concurrent users? ;-)
> > 
> > I believe that a more elaborate description about what happens with
> > concurrent attempts to alter the bitmap would be really helpful.
> 
> ok
> 
> --
> thanks, igor
> 

-- 
Sincerely yours,
Mike.
