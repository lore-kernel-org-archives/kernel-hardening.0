Subject: Re: [RFC PATCH] arm64/mm: unmap the linear alias of module
 allocations
References: <20180626165455.22636-1-ard.biesheuvel@linaro.org>
 <06b7ea07-53e2-690a-b670-d1fc41d133c3@redhat.com>
 <CAKv+Gu9uiqerCd54upWHxPBKcX1ga1oTwpYctEqbhhQGZOq6XA@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <76b00e4f-e6fd-f0e9-379c-e31e85d5258d@redhat.com>
Date: Tue, 26 Jun 2018 18:15:22 -0700
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9uiqerCd54upWHxPBKcX1ga1oTwpYctEqbhhQGZOq6XA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, YaoJun <yaojun8558363@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 06/26/2018 03:11 PM, Ard Biesheuvel wrote:
> Hi Laura,
> 
> Thanks for taking a look.
> 
> On 26 June 2018 at 23:28, Laura Abbott <labbott@redhat.com> wrote:
>> On 06/26/2018 09:54 AM, Ard Biesheuvel wrote:
>>>
>>> When CONFIG_STRICT_KERNEL_RXW=y [which is the default on arm64], we
>>> take great care to ensure that the mappings of modules in the vmalloc
>>> space are locked down as much as possible, i.e., executable code is
>>> mapped read-only, read-only data is mapped read-only and non-executable,
>>> and read-write data is mapped non-executable as well.
>>>
>>> However, due to the way we map the linear region [aka the kernel direct
>>> mapping], those module regions are aliased by read-write mappings, and
>>> it is possible for an attacker to modify code or data that was assumed
>>> to be immutable in this configuration.
>>>
>>> So let's ensure that the linear alias of module memory is unmapped upon
>>> allocation and remapped when it is freed. The latter requires some
>>> special handling involving a workqueue due to the fact that it may be
>>> called in softirq context at which time calling find_vm_area() is unsafe.
>>>
>>> Note that this requires the entire linear region to be mapped down to
>>> pages, which may result in a performance regression in some
>>> configurations.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>> For this RFC, I simply reused set_memory_valid() to do the unmap/remap,
>>> but I am aware that this likely breaks hibernation, and perhaps some
>>> other things as well, so we should probably remap r/o instead.
>>>
>>
>> This fixes modules but doesn't fix the set_memory_*
>> uses like in bpf. Is it worth trying to fix it for those
>> cases as well?
>>
> 
> AIUI bpf uses set_memory_* on the vmalloc region only, and is
> oblivious to the fact that there exists a linear alias in the first
> place. But due to the fact that it actually uses module_alloc() to
> allocate the regions, this patch affects the linear aliases of those
> regions as well.
> 
> Does that answer your question at all?
> 

Ah! I didn't realize bpf used module_alloc. That makes sense for
that case, yes.

>>
>>>    arch/arm64/kernel/module.c | 57 ++++++++++++++++++++
>>>    arch/arm64/mm/mmu.c        |  2 +-
>>>    2 files changed, 58 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c
>>> index 155fd91e78f4..4a1d3c7486f5 100644
>>> --- a/arch/arm64/kernel/module.c
>>> +++ b/arch/arm64/kernel/module.c
>>> @@ -26,10 +26,66 @@
>>>    #include <linux/mm.h>
>>>    #include <linux/moduleloader.h>
>>>    #include <linux/vmalloc.h>
>>> +#include <linux/workqueue.h>
>>>    #include <asm/alternative.h>
>>> +#include <asm/cacheflush.h>
>>>    #include <asm/insn.h>
>>>    #include <asm/sections.h>
>>>    +#ifdef CONFIG_STRICT_KERNEL_RWX
>>> +
>>> +static struct workqueue_struct *module_free_wq;
>>> +
>>> +static int init_workqueue(void)
>>> +{
>>> +       module_free_wq = alloc_ordered_workqueue("module_free_wq", 0);
>>> +       WARN_ON(!module_free_wq);
>>> +
>>> +       return 0;
>>> +}
>>> +pure_initcall(init_workqueue);
>>> +
>>> +static void remap_linear_module_alias(void *module_region, int enable)
>>> +{
>>> +       struct vm_struct *vm = find_vm_area(module_region);
>>> +       struct page **p;
>>> +       unsigned long size;
>>> +
>>> +       WARN_ON(!vm || !vm->pages);
>>> +
>>> +       for (p = vm->pages, size = vm->size; size > 0; size -= PAGE_SIZE)
>>> +               set_memory_valid((u64)page_address(*p++), 1, enable);
>>> +}
>>> +
>>> +static void module_free_wq_worker(struct work_struct *work)
>>> +{
>>> +       remap_linear_module_alias(work, true);
>>> +       vfree(work);
>>> +}
>>> +
>>> +void module_memfree(void *module_region)
>>> +{
>>> +       struct work_struct *work;
>>> +
>>> +       if (!module_region)
>>> +               return;
>>> +
>>> +       /*
>>> +        * At this point, module_region is a pointer to an allocation of
>>> at
>>> +        * least PAGE_SIZE bytes that is mapped read-write. So instead of
>>> +        * allocating memory for a data structure containing a work_struct
>>> +        * instance and a copy of the value of module_region, just reuse
>>> the
>>> +        * allocation directly.
>>> +        */
>>> +       work = module_region;
>>> +       INIT_WORK(work, module_free_wq_worker);
>>> +       queue_work(module_free_wq, work);
>>> +}
>>> +
>>> +#else
>>> +static void remap_linear_module_alias(void *module_region, int enable) {}
>>> +#endif
>>> +
>>>    void *module_alloc(unsigned long size)
>>>    {
>>>          gfp_t gfp_mask = GFP_KERNEL;
>>> @@ -65,6 +121,7 @@ void *module_alloc(unsigned long size)
>>>                  return NULL;
>>>          }
>>>    +     remap_linear_module_alias(p, false);
>>>          return p;
>>>    }
>>>    diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>>> index 493ff75670ff..e1057ebb672d 100644
>>> --- a/arch/arm64/mm/mmu.c
>>> +++ b/arch/arm64/mm/mmu.c
>>> @@ -432,7 +432,7 @@ static void __init map_mem(pgd_t *pgdp)
>>>          struct memblock_region *reg;
>>>          int flags = 0;
>>>    -     if (debug_pagealloc_enabled())
>>> +       if (IS_ENABLED(CONFIG_STRICT_KERNEL_RWX) ||
>>> debug_pagealloc_enabled())
>>>                  flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
>>>          /*
>>>
>>
>> I think this should be based on rodata_enabled instead of the kernel
>> configuration option.
>>
> 
> Agreed.
> 
>> This looks reasonable from the pagetable debugfs but I'm seeing
>> some intermittent weird output:
>>
>> ---[ Linear Mapping ]---
>> 0xffff800000000000-0xffff800000001000           4K PTE       RW x
>> BLK DEVICE/nGnRnE
>> 0xffff800000200000-0xffff800000280000         512K PTE       RW NX SHD AF NG
>> UXN MEM/NORMAL
>> 0xffff800000280000-0xffff800000400000        1536K PTE       ro NX SHD AF NG
>> UXN MEM/NORMAL
>> 0xffff800000400000-0xffff800001400000          16M PMD       ro NX SHD AF NG
>> BLK UXN MEM/NORMAL
>> 0xffff800001400000-0xffff800001440000         256K PTE       ro NX SHD AF NG
>> UXN MEM/NORMAL
>> 0xffff800001440000-0xffff800010000000      241408K PTE       RW NX SHD AF NG
>> UXN MEM/NORMAL
>>
>>
>> I can't tell if this is some artifact of how we do the
>> debugfs dumping or an actual bug. It doesn't seem to
>> happen on every boot either. I'll play around with this
>> to see if I find anything.
>>
> 
> This is indeed weird, but I think the ptdump code makes it look
> weirder than it actually is: the BLK attribute means bit 1 is cleared,
> and the nGnRnE device attribute means bits [4:2] are cleared, so this
> is essentially a reserved entry, although I wouldn't be able to
> explain how we ended up with one.
> 

Yes, that does make sense.

> Are the first 2 MB of DRAM made available to the kernel by the firmware?
> 

Based on what I can see, I think so? It doesn't look to be marked
as reserved in memblock and shows up in the memory regions.

Thanks,
Laura
