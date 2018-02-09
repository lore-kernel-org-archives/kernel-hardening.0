Date: Fri, 9 Feb 2018 07:26:09 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC] Limit mappings to ten per page per process
Message-ID: <20180209042609.wi6zho24wmmdkg6i@node.shutemov.name>
References: <20180208021112.GB14918@bombadil.infradead.org>
 <CAG48ez2-MTJ2YrS5fPZi19RY6P_6NWuK1U5CcQpJ25=xrGSy_A@mail.gmail.com>
 <CA+DvKQLHDR0s=6r4uiHL8kw2_PnfJcwYfPxgQOmuLbc=5k39+g@mail.gmail.com>
 <20180208185648.GB9524@bombadil.infradead.org>
 <CA+DvKQLHcFc3+kW_SnD6hs53yyD5Zi+uAeSgDMm1tRzxqy-Opg@mail.gmail.com>
 <20180208194235.GA3424@bombadil.infradead.org>
 <CA+DvKQKba0iU+tydbmGkAJsxCxazORDnuoe32sy-2nggyagUxQ@mail.gmail.com>
 <20180208202100.GB3424@bombadil.infradead.org>
 <20180208213743.GC3424@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180208213743.GC3424@bombadil.infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Daniel Micay <danielmicay@gmail.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 08, 2018 at 01:37:43PM -0800, Matthew Wilcox wrote:
> On Thu, Feb 08, 2018 at 12:21:00PM -0800, Matthew Wilcox wrote:
> > Now that I think about it, though, perhaps the simplest solution is not
> > to worry about checking whether _mapcount has saturated, and instead when
> > adding a new mmap, check whether this task already has it mapped 10 times.
> > If so, refuse the mapping.
> 
> That turns out to be quite easy.  Comments on this approach?

This *may* break some remap_file_pages() users.

And it may be rather costly for popular binaries. Consider libc.so.

-- 
 Kirill A. Shutemov
