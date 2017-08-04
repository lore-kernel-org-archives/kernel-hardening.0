References: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
 <20170802170848.GA3240@redhat.com>
 <8e82639c-40db-02ce-096a-d114b0436d3c@huawei.com>
 <20170803114844.GO12521@dhcp22.suse.cz>
 <c3a250a6-ad4d-d24d-d0bf-4c43c467ebe6@huawei.com>
 <20170803135549.GW12521@dhcp22.suse.cz> <20170803144746.GA9501@redhat.com>
 <ab4809cd-0efc-a79d-6852-4bd2349a2b3f@huawei.com>
 <20170803151550.GX12521@dhcp22.suse.cz>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <abe0c086-8c5a-d6fb-63c4-bf75528d0ec5@huawei.com>
Date: Fri, 4 Aug 2017 11:02:46 +0300
MIME-Version: 1.0
In-Reply-To: <20170803151550.GX12521@dhcp22.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Michal Hocko <mhocko@kernel.org>
Cc: Jerome Glisse <jglisse@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/17 18:15, Michal Hocko wrote:

> I would check the one where we have mapping. It is rather unlikely
> vmalloc users would touch this one.

That was also the initial recommendation from Jerome Glisse, but it
seemed unusable, because of the related comment.

I should have asked for clarifications back then :-(

But it's never too late ...


struct page {
  /* First double word block */
  unsigned long flags;		/* Atomic flags, some possibly
				 * updated asynchronously */
union {
	struct address_space *mapping;	/* If low bit clear, points to
					 * inode address_space, or NULL.
					 * If page mapped as anonymous
					 * memory, low bit is set, and
					 * it points to anon_vma object:
					 * see PAGE_MAPPING_ANON below.
					 */
...
}

mapping seems to be used exclusively in 2 ways, based on the value of
its lower bit.

Therefore I discarded it as valid option ("private", otoh was far more
alluring), but maybe I could wrap it inside a union, together with vm_area?

---
thanks, igor
