References: <07063abd-2f5d-20d9-a182-8ae9ead26c3c@huawei.com>
 <20170802170848.GA3240@redhat.com>
 <8e82639c-40db-02ce-096a-d114b0436d3c@huawei.com>
 <20170803114844.GO12521@dhcp22.suse.cz>
 <c3a250a6-ad4d-d24d-d0bf-4c43c467ebe6@huawei.com>
 <20170803135549.GW12521@dhcp22.suse.cz>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <836b82ae-0d01-af73-d6fd-00343bb2a5b7@huawei.com>
Date: Thu, 3 Aug 2017 17:41:24 +0300
MIME-Version: 1.0
In-Reply-To: <20170803135549.GW12521@dhcp22.suse.cz>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] Tagging of vmalloc pages for supporting the pmalloc
 allocator
To: Michal Hocko <mhocko@kernel.org>
Cc: Jerome Glisse <jglisse@redhat.com>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@google.com>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/17 16:55, Michal Hocko wrote:
> On Thu 03-08-17 15:20:31, Igor Stoppa wrote:
>> On 03/08/17 14:48, Michal Hocko wrote:
>>> On Thu 03-08-17 13:11:45, Igor Stoppa wrote:

[...]

>>>> But, to reply more specifically to your advice, yes, I think I could add
>>>> a flag to vm_struct and then retrieve its value, for the address being
>>>> processed, by passing through find_vm_area().
>>>
>>> ... and you can store vm_struct pointer to the struct page there 
>>
>> "there" as in the new field of the union?
>> btw, what would be a meaningful name, since "private" is already taken?
>>
>> For simplicity, I'll use, for now, "private2"
> 
> why not explicit vm_area?

ok :-)

>>> and you won't need to do the slow find_vm_area. I haven't checked
>> very closely
>>> but this should be possible in principle. I guess other callers might
>>> benefit from this as well.
>>
>> I am confused about this: if "private2" is a pointer, but when I get an
>> address, I do not even know if the address represents a valid pmalloc
>> page, how can i know when it's ok to dereference "private2"?
> 
> because you can make all pages which back vmalloc mappings have vm_area
> pointer set.

Ah, now I see, I had missed that the field would be set for *all* pages
backed by vmalloc.

So, given a pointer, I still have to figure out if it refers to a
vmalloc area or not.

However, that is something I need to do anyway, to get the reference to
the corresponding page struct, in case it is indeed a vmalloc address.

--
thanks, igor
