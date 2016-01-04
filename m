Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <568A5163.2050402@arm.com>
Date: Mon, 04 Jan 2016 11:02:59 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
MIME-Version: 1.0
References: <1451489172-17420-1-git-send-email-ard.biesheuvel@linaro.org>	<1451489172-17420-6-git-send-email-ard.biesheuvel@linaro.org>	<568A4482.3010700@arm.com> <CAKv+Gu_B3WXRh6ERGrWgAA-iz-dkaTSROs2mcTFZd47vRZeL-g@mail.gmail.com>
In-Reply-To: <CAKv+Gu_B3WXRh6ERGrWgAA-iz-dkaTSROs2mcTFZd47vRZeL-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 05/13] arm64: kvm: deal with kernel symbols outside
 of linear mapping
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, kernel-hardening@lists.openwall.com, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stuart Yoder <stuart.yoder@freescale.com>, Sharma Bhupesh <bhupesh.sharma@freescale.com>, Arnd Bergmann <arnd@arndb.de>, Christoffer Dall <christoffer.dall@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/01/16 10:31, Ard Biesheuvel wrote:
> On 4 January 2016 at 11:08, Marc Zyngier <marc.zyngier@arm.com> wrote:
>> Hi Ard,
>>
>> On 30/12/15 15:26, Ard Biesheuvel wrote:
>>> KVM on arm64 uses a fixed offset between the linear mapping at EL1 and
>>> the HYP mapping at EL2. Before we can move the kernel virtual mapping
>>> out of the linear mapping, we have to make sure that references to kernel
>>> symbols that are accessed via the HYP mapping are translated to their
>>> linear equivalent.
>>>
>>> To prevent inadvertent direct references from sneaking in later, change
>>> the type of all extern declarations to HYP kernel symbols to the opaque
>>> 'struct kvm_ksym', which does not decay to a pointer type like char arrays
>>> and function references. This is not bullet proof, but at least forces the
>>> user to take the address explicitly rather than referencing it directly.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> This looks good to me, a few comments below.
>>
>>> ---
>>>  arch/arm/include/asm/kvm_asm.h   |  2 ++
>>>  arch/arm/include/asm/kvm_mmu.h   |  2 ++
>>>  arch/arm/kvm/arm.c               |  9 +++++----
>>>  arch/arm/kvm/mmu.c               | 12 +++++------
>>>  arch/arm64/include/asm/kvm_asm.h | 21 +++++++++++---------
>>>  arch/arm64/include/asm/kvm_mmu.h |  2 ++
>>>  arch/arm64/include/asm/virt.h    |  4 ----
>>>  arch/arm64/kernel/vmlinux.lds.S  |  4 ++--
>>>  arch/arm64/kvm/debug.c           |  4 +++-
>>>  virt/kvm/arm/vgic-v3.c           |  2 +-
>>>  10 files changed, 34 insertions(+), 28 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
>>> index 194c91b610ff..484ffdf7c70b 100644
>>> --- a/arch/arm/include/asm/kvm_asm.h
>>> +++ b/arch/arm/include/asm/kvm_asm.h
>>> @@ -99,6 +99,8 @@ extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>>>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
>>>
>>>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>>> +
>>> +extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
>>>  #endif
>>>
>>>  #endif /* __ARM_KVM_ASM_H__ */
>>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>>> index 405aa1883307..412b363f79e9 100644
>>> --- a/arch/arm/include/asm/kvm_mmu.h
>>> +++ b/arch/arm/include/asm/kvm_mmu.h
>>> @@ -30,6 +30,8 @@
>>>  #define HYP_PAGE_OFFSET              PAGE_OFFSET
>>>  #define KERN_TO_HYP(kva)     (kva)
>>>
>>> +#define kvm_ksym_ref(kva)    (kva)
>>> +
>>>  /*
>>>   * Our virtual mapping for the boot-time MMU-enable code. Must be
>>>   * shared across all the page-tables. Conveniently, we use the vectors
>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>> index e06fd299de08..014b542ea658 100644
>>> --- a/arch/arm/kvm/arm.c
>>> +++ b/arch/arm/kvm/arm.c
>>> @@ -427,7 +42You can use it, but you don't have to, since yo7,7 @@ static void update_vttbr(struct kvm *kvm)
>>>                * shareable domain to make sure all data structures are
>>>                * clean.
>>>                */
>>> -             kvm_call_hyp(__kvm_flush_vm_context);
>>> +             kvm_call_hyp(kvm_ksym_ref(__kvm_flush_vm_context));
>>>       }
>>>
>>>       kvm->arch.vmid_gen = atomic64_read(&kvm_vmid_gen);
>>> @@ -600,7 +600,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>               __kvm_guest_enter();
>>>               vcpu->mode = IN_GUEST_MODE;
>>>
>>> -             ret = kvm_call_hyp(__kvm_vcpu_run, vcpu);
>>> +             ret = kvm_call_hyp(kvm_ksym_ref(__kvm_vcpu_run), vcpu);
>>>
>>>               vcpu->mode = OUTSIDE_GUEST_MODE;
>>>               /*
>>> @@ -969,7 +969,7 @@ static void cpu_init_hyp_mode(void *dummy)
>>>       pgd_ptr = kvm_mmu_get_httbr();
>>>       stack_page = __this_cpu_read(kvm_arm_hyp_stack_page);
>>>       hyp_stack_ptr = stack_page + PAGE_SIZE;
>>> -     vector_ptr = (unsigned long)__kvm_hyp_vector;
>>> +     vector_ptr = (unsigned long)kvm_ksym_ref(__kvm_hyp_vector);
>>>
>>>       __cpu_init_hyp_mode(boot_pgd_ptr, pgd_ptr, hyp_stack_ptr, vector_ptr);
>>>
>>> @@ -1061,7 +1061,8 @@ static int init_hyp_mode(void)
>>>       /*
>>>        * Map the Hyp-code called directly from the host
>>>        */
>>> -     err = create_hyp_mappings(__kvm_hyp_code_start, __kvm_hyp_code_end);
>>> +     err = create_hyp_mappings(kvm_ksym_ref(__kvm_hyp_code_start),
>>> +                               kvm_ksym_ref(__kvm_hyp_code_end));
>>>       if (err) {
>>>               kvm_err("Cannot map world-switch code\n");
>>>               goto out_free_mappings;
>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>> index 7dace909d5cf..7c448b943e3a 100644
>>> --- a/arch/arm/kvm/mmu.c
>>> +++ b/arch/arm/kvm/mmu.c
>>> @@ -31,8 +31,6 @@
>>>
>>>  #include "trace.h"
>>>
>>> -extern char  __hyp_idmap_text_start[], __hyp_idmap_text_end[];
>>> -
>>>  static pgd_t *boot_hyp_pgd;
>>>  static pgd_t *hyp_pgd;
>>>  static pgd_t *merged_hyp_pgd;
>>> @@ -63,7 +61,7 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>>>   */
>>>  void kvm_flush_remote_tlbs(struct kvm *kvm)
>>>  {
>>> -     kvm_call_hyp(__kvm_tlb_flush_vmid, kvm);
>>> +     kvm_call_hyp(kvm_ksym_ref(__kvm_tlb_flush_vmid), kvm);
>>
>> Any chance we could bury kvm_ksym_ref in kvm_call_hyp? It may make the
>> change more readable, but I have the feeling it would require an
>> intermediate #define...
>>
> 
> Yes, we'd have to rename the actual kvm_call_hyp definition so we can
> wrap it in a macro
> 
> And the call in __cpu_init_hyp_mode() would need to omit the macro,
> since it passes a pointer into the linear mapping, not a kernel
> symbol.
> So if you think that's ok, I'm happy to change that.

That'd be great, thanks.

	M.
-- 
Jazz is not dead. It just smells funny...
