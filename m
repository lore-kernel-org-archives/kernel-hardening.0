Date: Tue, 24 Apr 2018 07:44:04 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 7/9] Pmalloc Rare Write: modify selected pools
Message-ID: <20180424144404.GF26636@bombadil.infradead.org>
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
 <20180424115050.GD26636@bombadil.infradead.org>
 <eb23fbd9-1b9e-8633-b0eb-241b8ad24d95@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb23fbd9-1b9e-8633-b0eb-241b8ad24d95@gmail.com>
To: lazytyped <lazytyped@gmail.com>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov, mhocko@kernel.org, corbet@lwn.net, labbott@redhat.com, linux-cc=david@fromorbit.com, --cc=rppt@linux.vnet.ibm.com, --security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>, Carlos Chinea Perez <carlos.chinea.perez@huawei.com>, Remi Denis Courmont <remi.denis.courmont@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 24, 2018 at 02:32:36PM +0200, lazytyped wrote:
> On 4/24/18 1:50 PM, Matthew Wilcox wrote:
> > struct modifiable_data {
> > 	struct immutable_data *d;
> > 	...
> > };
> >
> > Then allocate a new pool, change d and destroy the old pool.
> 
> With the above, you have just shifted the target of the arbitrary write
> from the immutable data itself to the pointer to the immutable data, so
> got no security benefit.

There's always a pointer to the immutable data.  How do you currently
get to the selinux context?  file->f_security.  You can't make 'file'
immutable, so file->f_security is the target of the arbitrary write.
All you can do is make life harder, and reduce the size of the target.

> The goal of the patch is to reduce the window when stuff is writeable,
> so that an arbitrary write is likely to hit the time when data is read-only.

Yes, reducing the size of the target in time as well as bytes.  This patch
gives attackers a great roadmap (maybe even gadget) to unprotecting
a pool.
