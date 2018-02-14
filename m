Date: Wed, 14 Feb 2018 05:51:41 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC] Limit mappings to ten per page per process
Message-ID: <20180214135141.GA16215@bombadil.infradead.org>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
 <20180208185648.GB9524@bombadil.infradead.org>
 <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
 <20180208194235.GA3424@bombadil.infradead.org>
 <CA+DvKQKba0iU+tydbmGkAJsxCxazORDnuoe32sy-2nggyagUxQ@mail.gmail.com>
 <20180208202100.GB3424@bombadil.infradead.org>
 <20180208213743.GC3424@bombadil.infradead.org>
 <20180209042609.wi6zho24wmmdkg6i@node.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180209042609.wi6zho24wmmdkg6i@node.shutemov.name>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Daniel Micay <danielmicay@gmail.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 09, 2018 at 07:26:09AM +0300, Kirill A. Shutemov wrote:
> On Thu, Feb 08, 2018 at 01:37:43PM -0800, Matthew Wilcox wrote:
> > On Thu, Feb 08, 2018 at 12:21:00PM -0800, Matthew Wilcox wrote:
> > > Now that I think about it, though, perhaps the simplest solution is not
> > > to worry about checking whether _mapcount has saturated, and instead when
> > > adding a new mmap, check whether this task already has it mapped 10 times.
> > > If so, refuse the mapping.
> > 
> > That turns out to be quite easy.  Comments on this approach?
> 
> This *may* break some remap_file_pages() users.

We have some?!  ;-)  I don't understand the use case where they want to
map the same page of a file multiple times into the same process.  I mean,
yes, of course, they might ask for it, but I don't understand why they would.
Do you have any insight here?

> And it may be rather costly for popular binaries. Consider libc.so.

We already walk this tree to insert the mapping; this just adds a second
walk of the tree to check which overlapping mappings exist.  I would
expect it to just make the tree cache-hot.
