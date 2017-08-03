Date: Thu, 3 Aug 2017 17:15:50 +0200
From: Michal Hocko <mhocko@kernel.org>
Message-ID: <20170803151550.GX12521@dhcp22.suse.cz>
References: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
 <20170802170848.GA3240@redhat.com>
 <8e82639c-40db-02ce-096a-d114b0436d3c@huawei.com>
 <20170803114844.GO12521@dhcp22.suse.cz>
 <c3a250a6-ad4d-d24d-d0bf-4c43c467ebe6@huawei.com>
 <20170803135549.GW12521@dhcp22.suse.cz>
 <20170803144746.GA9501@redhat.com>
 <ab4809cd-0efc-a79d-6852-4bd2349a2b3f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4809cd-0efc-a79d-6852-4bd2349a2b3f@huawei.com>
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Jerome Glisse <jglisse@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu 03-08-17 18:06:11, Igor Stoppa wrote:
> 
> 
> On 03/08/17 17:47, Jerome Glisse wrote:
> > On Thu, Aug 03, 2017 at 03:55:50PM +0200, Michal Hocko wrote:
> >> On Thu 03-08-17 15:20:31, Igor Stoppa wrote:
> 
> [...]
> 
> >>> I am confused about this: if "private2" is a pointer, but when I get an
> >>> address, I do not even know if the address represents a valid pmalloc
> >>> page, how can i know when it's ok to dereference "private2"?
> >>
> >> because you can make all pages which back vmalloc mappings have vm_area
> >> pointer set.
> > 
> > Note that i think this might break some device driver that use vmap()
> > i think some of them use private field to store device driver specific
> > informations. But there likely is an unuse field in struct page that
> > can be use for that.
> 
> This increases the unease from my side ... it looks like there is no way
> to fully understand if a field is really used or not, without having
> deep intimate knowledge of lots of code that is only marginally involved :-/

welcome to the struct page heaven...
 
> Similarly, how would I be able to specify what would be the correct way
> to decide the member of the union to use for handling the field?

I would check the one where we have mapping. It is rather unlikely
vmalloc users would touch this one.
-- 
Michal Hocko
SUSE Labs
