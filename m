Date: Mon, 11 Sep 2017 08:02:04 -0700
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170911150204.nn5v5olbxyzfafou@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <23e5bac9-329a-3a32-049e-7e7c9751abd0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23e5bac9-329a-3a32-049e-7e7c9751abd0@huawei.com>
Subject: [kernel-hardening] Re: [PATCH v6 00/11] Add support for eXclusive Page Frame Ownership
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Yisheng,

On Mon, Sep 11, 2017 at 06:34:45PM +0800, Yisheng Xie wrote:
> Hi Tycho ,
> 
> On 2017/9/8 1:35, Tycho Andersen wrote:
> > Hi all,
> > 
> > Here is v6 of the XPFO set; see v5 discussion here:
> > https://lkml.org/lkml/2017/8/9/803
> > 
> > Changelogs are in the individual patch notes, but the highlights are:
> > * add primitives for ensuring memory areas are mapped (although these are quite
> >   ugly, using stack allocation; I'm open to better suggestions)
> > * instead of not flushing caches, re-map pages using the above
> > * TLB flushing is much more correct (i.e. we're always flushing everything
> >   everywhere). I suspect we may be able to back this off in some cases, but I'm
> >   still trying to collect performance numbers to prove this is worth doing.
> > 
> > I have no TODOs left for this set myself, other than fixing whatever review
> > feedback people have. Thoughts and testing welcome!
> 
> According to the paper of Vasileios P. Kemerlis et al, the mainline kernel
> will not set the Pro. of physmap(direct map area) to RW(X), so do we really
> need XPFO to protect from ret2dir attack?

I guess you're talking about section 4.3? They mention that that x86
only gets rw, but that aarch64 is rwx still.

But in either case this still provides access protection, similar to
SMAP. Also, if I understand things correctly the protections are
unmanaged, so a page that had the +x bit set at some point, it could
be used for ret2dir.

Cheers,

Tycho
