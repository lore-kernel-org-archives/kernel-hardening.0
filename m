Subject: Re: [PATCH 7/9] Pmalloc Rare Write: modify selected pools
References: <20180423125458.5338-1-igor.stoppa@huawei.com>
 <20180423125458.5338-8-igor.stoppa@huawei.com>
 <20180424115050.GD26636@bombadil.infradead.org>
 <eb23fbd9-1b9e-8633-b0eb-241b8ad24d95@gmail.com>
 <20180424144404.GF26636@bombadil.infradead.org>
From: lazytyped <lazytyped@gmail.com>
Message-ID: <b1efb813-3629-518c-4eeb-7d15eb5e7319@gmail.com>
Date: Tue, 24 Apr 2018 17:03:25 +0200
MIME-Version: 1.0
In-Reply-To: <20180424144404.GF26636@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, keescook@chromium.org, paul@paul-moore.com, sds@tycho.nsa.gov, mhocko@kernel.org, corbet@lwn.net, labbott@redhat.com, linux-cc=david@fromorbit.com, --cc=rppt@linux.vnet.ibm.com, --security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Igor Stoppa <igor.stoppa@huawei.com>, Carlos Chinea Perez <carlos.chinea.perez@huawei.com>, Remi Denis Courmont <remi.denis.courmont@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 4/24/18 4:44 PM, Matthew Wilcox wrote:
> On Tue, Apr 24, 2018 at 02:32:36PM +0200, lazytyped wrote:
>> On 4/24/18 1:50 PM, Matthew Wilcox wrote:
>>> struct modifiable_data {
>>> 	struct immutable_data *d;
>>> 	...
>>> };
>>>
>>> Then allocate a new pool, change d and destroy the old pool.
>> With the above, you have just shifted the target of the arbitrary write
>> from the immutable data itself to the pointer to the immutable data, so
>> got no security benefit.
> There's always a pointer to the immutable data.  How do you currently
> get to the selinux context?  file->f_security.  You can't make 'file'
> immutable, so file->f_security is the target of the arbitrary write.
> All you can do is make life harder, and reduce the size of the target.

So why adding an extra pointer/indirection helps here? It adds attacking
surface.
>
>> The goal of the patch is to reduce the window when stuff is writeable,
>> so that an arbitrary write is likely to hit the time when data is read-only.
> Yes, reducing the size of the target in time as well as bytes.  This patch
> gives attackers a great roadmap (maybe even gadget) to unprotecting
> a pool.

I don't think this is relevant to the threat model this patch addresses.
If the attacker can already execute code, it doesn't matter whether this
specific piece of code exists or not. In general, if an attacker got to
the point of using gadgets, you've lost.

On the contrary, it opens the road to design trusted paths that can
write to or access data that would generally be read-only or not
accessible (with, of course, all the complexity, limitations and
penalties of doing this purely in software on a page sized basis).


            -   Enrico
