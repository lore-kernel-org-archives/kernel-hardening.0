Date: Mon, 12 Feb 2018 13:43:11 +0200
From: Mike Rapoport <rppt@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/6] Protectable Memory
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-5-igor.stoppa@huawei.com>
 <20180211123743.GC13931@rapoport-lnx>
 <e7ea02b4-3d43-9543-3d14-61c27e155042@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ea02b4-3d43-9543-3d14-61c27e155042@huawei.com>
Message-Id: <20180212114310.GD20737@rapoport-lnx>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: willy@infradead.org, rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 12, 2018 at 01:26:28PM +0200, Igor Stoppa wrote:
> On 11/02/18 14:37, Mike Rapoport wrote:
> > On Sun, Feb 11, 2018 at 05:19:18AM +0200, Igor Stoppa wrote:
> 
> >> + * Return: 0 if the object does not belong to pmalloc, 1 if it belongs to
> >> + * pmalloc, -1 if it partially overlaps pmalloc meory, but incorectly.
> > 
> > typo:                                            ^ memory
> 
> thanks :-(
> 
> [...]
> 
> >> +/**
> >> + * When the sysfs is ready to receive registrations, connect all the
> >> + * pools previously created. Also enable further pools to be connected
> >> + * right away.
> >> + */
> > 
> > This does not seem as kernel-doc comment. Please either remove the second *
> > from the opening comment mark or reformat the comment.
> 
> For this too, I thought I had caught them all, but I was wrong ...
> 
> I didn't find any mention of automated checking for comments.
> Is there such tool?

I don't know if there is a tool. I couldn't find anything in scripts, maybe
somebody have such tool out of tree.

For now, I've added mm-api.rst that includes all mm .c files and run 'make
htmldocs' which spits plenty of warnings and errors.

> --
> thanks, igor
> 

-- 
Sincerely yours,
Mike.
