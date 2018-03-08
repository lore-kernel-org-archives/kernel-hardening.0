Date: Thu, 8 Mar 2018 07:24:47 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
In-Reply-To: <20180308025812.GA9082@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1803080722300.3754@hadrien>
References: <20180214182618.14627-1-willy@infradead.org> <20180214182618.14627-3-willy@infradead.org> <CAGXu5jL9hqQGe672CmvFwqNbtTr=qu7WRwHuS4Vy7o5sX_UTgg@mail.gmail.com> <alpine.DEB.2.20.1803072212160.2814@hadrien>
 <20180308025812.GA9082@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, cocci@systeme.lip6.fr, Himanshu Jha <himanshujha199640@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>



On Wed, 7 Mar 2018, Matthew Wilcox wrote:

> On Wed, Mar 07, 2018 at 10:18:21PM +0100, Julia Lawall wrote:
> > > Otherwise, yes, please. We could build a coccinelle rule for
> > > additional replacements...
> >
> > A potential semantic patch and the changes it generates are attached
> > below.  Himanshu Jha helped with its development.  Working on this
> > uncovered one bug, where the allocated array is too large, because the
> > size provided for it was a structure size, but actually only pointers to
> > that structure were to be stored in it.
>
> This is cool!  Thanks for doing the coccinelle patch!  Diffstat:
>
>  50 files changed, 81 insertions(+), 124 deletions(-)
>
> I find that pretty compelling.  I'll repost the kvmalloc_struct patch
> imminently.

Thanks.  So it's OK to replace kmalloc and kzalloc, even though they
didn't previously consider vmalloc and even though kmalloc doesn't zero?

There are a few other cases that use GFP_NOFS and GFP_NOWAIT, but I didn't
transform those because the comment says that the flags should be
GFP_KERNEL based.  Should those be transformed too?

julia
