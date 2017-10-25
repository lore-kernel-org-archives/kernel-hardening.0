References: <20171020232525.7387-1-pbonzini@redhat.com>
 <f13340f5-4027-181b-7e41-e9bc434b195c@redhat.com>
 <20171023143918.21112222.cohuck@redhat.com>
 <6fbcdbac-a717-def4-1864-6426d58986fc@redhat.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <f942d9b4-6fde-267d-aa04-a64218b1391f@redhat.com>
Date: Wed, 25 Oct 2017 11:45:21 +0200
MIME-Version: 1.0
In-Reply-To: <6fbcdbac-a717-def4-1864-6426d58986fc@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 0/2] KVM: fixes for the kernel-hardening tree
To: Paolo Bonzini <pbonzini@redhat.com>, Cornelia Huck <cohuck@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 23.10.2017 16:15, Paolo Bonzini wrote:
> On 23/10/2017 14:39, Cornelia Huck wrote:
>> On Mon, 23 Oct 2017 11:52:51 +0200
>> David Hildenbrand <david@redhat.com> wrote:
>>
>>> On 21.10.2017 01:25, Paolo Bonzini wrote:
>>>> Two KVM ioctls (KVM_GET/SET_CPUID2) directly access the cpuid_entries
>>>> field of struct kvm_vcpu_arch.  Therefore, the new usercopy hardening
>>>> work in linux-next, which forbids copies from and to slab objects
>>>> unless they are from kmalloc or explicitly whitelisted, breaks KVM
>>>> completely.
>>>>
>>>> This series fixes it by adding the two new usercopy arguments
>>>> to kvm_init (more precisely to a new function kvm_init_usercopy,
>>>> while kvm_init passes zeroes as a default).
>>>>
>>>> There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
>>>> obsolete and not a big deal at all.
>>>>
>>>> I'm Ccing all submaintainers in case they have something similar
>>>> going on in their kvm_arch and kvm_vcpu_arch structs.  KVM has a
>>>> pretty complex userspace API, so thorough with linux-next is highly
>>>> recommended.  
>>>
>>> I assume on s390x, at least
>>>
>>> kvm_arch_vcpu_ioctl_get_one_reg() and
>>> kvm_arch_vcpu_ioctl_set_one_reg()
>>>
>>> have to be fixed.
>>
>> At a glance, seems like it.
>>
>>>
>>> Christian, are you already looking into this?
>>
>> I'm afraid I'm also busy with travel preparation/travel, so I'd be glad
>> for any takers.
> 
> Let's do a generic fix now, so that we don't need to rush the switch to
> explicit whitelisting.

You mean a arch specific fix (allow writes/reads to arch) or even more
generic?

Otherwise I can you send a patch to fix these two functions.

> 
> Paolo
> 


-- 

Thanks,

David
