Date: Mon, 7 Aug 2017 13:34:29 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170807113428.GF32434@dhcp22.suse.cz>
References: <8e82639c-40db-02ce-096a-d114b0436d3c@huawei.com>
 <20170803114844.GO12521@dhcp22.suse.cz>
 <c3a250a6-ad4d-d24d-d0bf-4c43c467ebe6@huawei.com>
 <20170803135549.GW12521@dhcp22.suse.cz>
 <20170803144746.GA9501@redhat.com>
 <ab4809cd-0efc-a79d-6852-4bd2349a2b3f@huawei.com>
 <20170803151550.GX12521@dhcp22.suse.cz>
 <abe0c086-8c5a-d6fb-63c4-bf75528d0ec5@huawei.com>
 <20170804081240.GF26029@dhcp22.suse.cz>
 <7733852a-67c9-17a3-4031-cb08520b9ad2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7733852a-67c9-17a3-4031-cb08520b9ad2@huawei.com>
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon 07-08-17 14:26:21, Igor Stoppa wrote:
> On 04/08/17 11:12, Michal Hocko wrote:
> > On Fri 04-08-17 11:02:46, Igor Stoppa wrote:
> 
> [...]
> 
> >> struct page {
> >>   /* First double word block */
> >>   unsigned long flags;		/* Atomic flags, some possibly
> >> 				 * updated asynchronously */
> >> union {
> >> 	struct address_space *mapping;	/* If low bit clear, points to
> >> 					 * inode address_space, or NULL.
> >> 					 * If page mapped as anonymous
> >> 					 * memory, low bit is set, and
> >> 					 * it points to anon_vma object:
> >> 					 * see PAGE_MAPPING_ANON below.
> >> 					 */
> >> ...
> >> }
> >>
> >> mapping seems to be used exclusively in 2 ways, based on the value of
> >> its lower bit.
> > 
> > Not really. The above applies to LRU pages. Please note that Slab pages
> > use s_mem and huge pages use compound_mapcount. If vmalloc pages are
> > using none of those already you can add a new field there.
> 
> Yes, both from reading the code and some experimentation, it seems that
> vmalloc is not using either field.
> 
> I'll add a vm_area field as you advised.
> 
> Is this something I could send as standalone patch?

Yes I would start that way and also look at some find_vm_area callers
and maybe they can be simplified. The most obvious one being
task_struct::stack_vm_area but I have to confess I haven't checked that
too deeply.
-- 
Michal Hocko
SUSE Labs
