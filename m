Date: Thu, 10 Aug 2017 09:14:05 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170810071404.GD23863@dhcp22.suse.cz>
References: <ab4809cd-0efc-a79d-6852-4bd2349a2b3f@huawei.com>
 <20170803151550.GX12521@dhcp22.suse.cz>
 <abe0c086-8c5a-d6fb-63c4-bf75528d0ec5@huawei.com>
 <20170804081240.GF26029@dhcp22.suse.cz>
 <7733852a-67c9-17a3-4031-cb08520b9ad2@huawei.com>
 <20170807133107.GA16616@redhat.com>
 <555dc453-3028-199a-881a-3ddeb41e4d6d@huawei.com>
 <20170807191235.GE16616@redhat.com>
 <c06fdd1a-fb18-8e17-b4fb-ea73ccd93f90@huawei.com>
 <20170808231535.GA20840@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170808231535.GA20840@redhat.com>
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Jerome Glisse <jglisse@redhat.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue 08-08-17 19:15:36, Jerome Glisse wrote:
> On Tue, Aug 08, 2017 at 03:59:36PM +0300, Igor Stoppa wrote:
> > On 07/08/17 22:12, Jerome Glisse wrote:
> > > On Mon, Aug 07, 2017 at 05:13:00PM +0300, Igor Stoppa wrote:
> > 
> > [...]
> > 
> > >> I have an updated version of the old proposal:
> > >>
> > >> * put a magic number in the private field, during initialization of
> > >> pmalloc pages
> > >>
> > >> * during hardened usercopy verification, when I have to assess if a page
> > >> is of pmalloc type, compare the private field against the magic number
> > >>
> > >> * if and only if the private field matches the magic number, then invoke
> > >> find_vm_area(), so that the slowness affects only a possibly limited
> > >> amount of false positives.
> > > 
> > > This all sounds good to me.
> > 
> > ok, I still have one doubt wrt defining the flag.
> > Where should I do it?
> > 
> > vmalloc.h has the following:
> > 
> > /* bits in flags of vmalloc's vm_struct below */
> > #define VM_IOREMAP		0x00000001	/* ioremap() and friends
> > 						*/
> > #define VM_ALLOC		0x00000002	/* vmalloc() */
> > #define VM_MAP			0x00000004	/* vmap()ed pages */
> > #define VM_USERMAP		0x00000008	/* suitable for
> > 						   remap_vmalloc_range
> > 						*/
> > #define VM_UNINITIALIZED	0x00000020	/* vm_struct is not
> > 						   fully initialized */
> > #define VM_NO_GUARD		0x00000040      /* don't add guard page
> > 						*/
> > #define VM_KASAN		0x00000080      /* has allocated kasan
> > 						shadow memory */
> > /* bits [20..32] reserved for arch specific ioremap internals */
> > 
> > 
> > 
> > I am tempted to add
> > 
> > #define VM_PMALLOC		0x00000100
> > 
> > But would it be acceptable, to mention pmalloc into vmalloc?
> > 
> > Should I name it VM_PRIVATE bit, instead?
> > 
> > Using VM_PRIVATE would avoid contaminating vmalloc with something that
> > depends on it (like VM_PMALLOC would do).
> > 
> > But using VM_PRIVATE will likely add tracking issues, if someone else
> > wants to use the same bit and it's not clear who is the user, if any.
> 
> VM_PMALLOC sounds fine to me also adding a comment there pointing to
> pmalloc documentation would be a good thing to do. The above are flags
> that are use only inside vmalloc context and so there is no issue
> here of conflicting with other potential user.

Yes I agree. VM_PRIVATE just calls for the issues you are dealing with
at struct page level where you simply do not know who might be (ab)using
mapping and what not because the naming is just too generic...
-- 
Michal Hocko
SUSE Labs
