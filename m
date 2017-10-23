References: <20171020232525.7387-1-pbonzini@redhat.com>
From: David Hildenbrand <david@redhat.com>
Message-ID: <f13340f5-4027-181b-7e41-e9bc434b195c@redhat.com>
Date: Mon, 23 Oct 2017 11:52:51 +0200
MIME-Version: 1.0
In-Reply-To: <20171020232525.7387-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 0/2] KVM: fixes for the kernel-hardening tree
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 21.10.2017 01:25, Paolo Bonzini wrote:
> Two KVM ioctls (KVM_GET/SET_CPUID2) directly access the cpuid_entries
> field of struct kvm_vcpu_arch.  Therefore, the new usercopy hardening
> work in linux-next, which forbids copies from and to slab objects
> unless they are from kmalloc or explicitly whitelisted, breaks KVM
> completely.
> 
> This series fixes it by adding the two new usercopy arguments
> to kvm_init (more precisely to a new function kvm_init_usercopy,
> while kvm_init passes zeroes as a default).
> 
> There's also another broken ioctl, KVM_XEN_HVM_CONFIG, but it is
> obsolete and not a big deal at all.
> 
> I'm Ccing all submaintainers in case they have something similar
> going on in their kvm_arch and kvm_vcpu_arch structs.  KVM has a
> pretty complex userspace API, so thorough with linux-next is highly
> recommended.

I assume on s390x, at least

kvm_arch_vcpu_ioctl_get_one_reg() and
kvm_arch_vcpu_ioctl_set_one_reg()

have to be fixed.

Christian, are you already looking into this?

> 
> Many thanks to Thomas Gleixner for reporting this to me.
> 
> Paolo
> 
> Paolo Bonzini (2):
>   KVM: allow setting a usercopy region in struct kvm_vcpu
>   KVM: fix KVM_XEN_HVM_CONFIG ioctl
> 
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/svm.c              |  4 ++--
>  arch/x86/kvm/vmx.c              |  4 ++--
>  arch/x86/kvm/x86.c              | 17 ++++++++++++++---
>  include/linux/kvm_host.h        | 13 +++++++++++--
>  virt/kvm/kvm_main.c             | 13 ++++++++-----
>  6 files changed, 40 insertions(+), 14 deletions(-)
> 


-- 

Thanks,

David
