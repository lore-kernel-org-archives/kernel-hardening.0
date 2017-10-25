References: <20171020232525.7387-1-pbonzini@redhat.com>
 <f13340f5-4027-181b-7e41-e9bc434b195c@redhat.com>
 <20171023143918.21112222.cohuck@redhat.com>
 <6fbcdbac-a717-def4-1864-6426d58986fc@redhat.com>
 <f942d9b4-6fde-267d-aa04-a64218b1391f@redhat.com>
From: Christian Borntraeger <borntraeger@de.ibm.com>
Date: Wed, 25 Oct 2017 12:31:43 +0200
MIME-Version: 1.0
In-Reply-To: <f942d9b4-6fde-267d-aa04-a64218b1391f@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Message-Id: <88d8a69a-5fe6-a38f-21c1-944ed551c2ad@de.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 0/2] KVM: fixes for the kernel-hardening tree
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 10/25/2017 11:45 AM, David Hildenbrand wrote:
> On 23.10.2017 16:15, Paolo Bonzini wrote:
>> On 23/10/2017 14:39, Cornelia Huck wrote:
>>> On Mon, 23 Oct 2017 11:52:51 +0200
>>> David Hildenbrand <david@redhat.com> wrote:
>>>
>>>> On 21.10.2017 01:25, Paolo Bonzini wrote:
>>>>> Two KVM ioctls (KVM_GET/SET_CPUID2) directly access the cpuid_entries
>>>>> field of struct kvm_vcpu_arch.  Therefore, the new usercopy hardening
>>>>> work in linux-next, which forbids copies from and to slab objects
>>>>> unless they are from kmalloc or explicitly whitelisted, breaks KVM
>>>>> completely.
>>>>>
>>>>> This series fixes it by adding the two new usercopy arguments
>>>>> to kvm_init (more precisely to a new function kvm_init_usercopy,
>>>>> while kvm_init passes zeroes as a default).
>>>>>
>>>>> There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
>>>>> obsolete and not a big deal at all.
>>>>>
>>>>> I'm Ccing all submaintainers in case they have something similar
>>>>> going on in their kvm_arch and kvm_vcpu_arch structs.  KVM has a
>>>>> pretty complex userspace API, so thorough with linux-next is highly
>>>>> recommended.  
>>>>
>>>> I assume on s390x, at least
>>>>
>>>> kvm_arch_vcpu_ioctl_get_one_reg() and
>>>> kvm_arch_vcpu_ioctl_set_one_reg()
>>>>
>>>> have to be fixed.
>>>
>>> At a glance, seems like it.
>>>
>>>>
>>>> Christian, are you already looking into this?
>>>
>>> I'm afraid I'm also busy with travel preparation/travel, so I'd be glad
>>> for any takers.
>>
>> Let's do a generic fix now, so that we don't need to rush the switch to
>> explicit whitelisting.
> 
> You mean a arch specific fix (allow writes/reads to arch) or even more
> generic?

Kees,

I am somewhat worried about these changes. The onereg interface is certainly
broken right now, but newer QEMUs will not use it. So its very likely that
testing will not find the regression. I would assume that usercopy hardinging
will introduce a lot of non-obvious regressions in seldomly used code. Have you
considered some debugging aids to find "now broken" things?
> 
> Otherwise I can you send a patch to fix these two functions.

Having said that, yes if you can send a fixup for 
kvm_arch_vcpu_ioctl_get/set_one_reg that would be great.

Christian
