Date: Fri, 2 Feb 2018 12:43:25 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
In-Reply-To: <48fde114-d063-cfbf-e1b6-262411fcd963@huawei.com>
Message-ID: <alpine.DEB.2.20.1802021240370.31548@nuc-kabylake>
References: <20180130151446.24698-1-igor.stoppa@huawei.com> <20180130151446.24698-4-igor.stoppa@huawei.com> <alpine.DEB.2.20.1801311758340.21272@nuc-kabylake> <48fde114-d063-cfbf-e1b6-262411fcd963@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 1 Feb 2018, Igor Stoppa wrote:

> > Would it not be better to use compound page allocations here?
> > page_head(whatever) gets you the head page where you can store all sorts
> > of information about the chunk of memory.
>
> Can you please point me to this function/macro? I don't seem to be able
> to find it, at least not in 4.15

Ok its compound_head(). See also the use in the SLAB and SLUB allocator.

> During hardened user copy permission check, I need to confirm if the
> memory range that would be exposed to userspace is a legitimate
> sub-range of a pmalloc allocation.

If you save the size in the head page struct then you could do that pretty
fast.

> I cannot comment on your proposal because I do not know where to find
> the reference you made, or maybe I do not understand what you mean :-(

compund pages are higher order pages that are handled as a single page by
the VM. See https://lwn.net/Articles/619514/
