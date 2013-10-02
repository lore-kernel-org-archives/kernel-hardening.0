Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524B6AEE.90301@jp.fujitsu.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<1380656245-29975-7-git-send-email-keescook@chromium.org>
	<524B6AEE.90301@jp.fujitsu.com>
Date: Wed, 2 Oct 2013 00:48:53 -0700
Message-ID: <CAGXu5jLVt13p2X2e1C3ha1izg6U6wbmgSyYW1wa+X4cW8aCFug@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 1, 2013 at 5:38 PM, HATAYAMA Daisuke
<d.hatayama@jp.fujitsu.com> wrote:
> (2013/10/02 4:37), Kees Cook wrote:
>> When the system panics, include the kernel offset in the report to assist
>> in debugging.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/x86/kernel/setup.c |   26 ++++++++++++++++++++++++++
>>   1 file changed, 26 insertions(+)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index f0de629..1708862 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -824,6 +824,20 @@ static void __init trim_low_memory_range(void)
>>   }
>>
>>   /*
>> + * Dump out kernel offset information on panic.
>> + */
>> +static int
>> +dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
>> +{
>> +     pr_emerg("Kernel Offset: 0x%lx from 0x%lx "
>> +              "(relocation range: 0x%lx-0x%lx)\n",
>> +              (unsigned long)&_text - __START_KERNEL, __START_KERNEL,
>> +              __START_KERNEL_map, MODULES_VADDR-1);
>
> Using phys_base seems better.

phys_base is not changed during relocation. For example, if I print
out phys_base during this pr_emerg call, it remains 0x0, even though
the random offset was 0xa200000.

>> +
>> +     return 0;
>> +}
>> +
>> +/*
>>    * Determine if we were loaded by an EFI loader.  If so, then we have also been
>>    * passed the efi memmap, systab, etc., so we should use these data structures
>>    * for initialization.  Note, the efi init code path is determined by the
>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>   }
>>
>>   #endif /* CONFIG_X86_32 */
>> +
>> +static struct notifier_block kernel_offset_notifier = {
>> +     .notifier_call = dump_kernel_offset
>> +};
>> +
>> +static int __init register_kernel_offset_dumper(void)
>> +{
>> +     atomic_notifier_chain_register(&panic_notifier_list,
>> +                                     &kernel_offset_notifier);
>> +     return 0;
>> +}
>> +__initcall(register_kernel_offset_dumper);
>>
>
> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
> kdump? Anyway, kdump related tools now calculate phys_base from memory map
> information passed as ELF PT_LOAD entries like below.

Correct, we are not currently using kdump.

> $ LANG=C readelf -l vmcore-rhel6up4
>
> Elf file type is CORE (Core file)
> Entry point 0x0
> There are 5 program headers, starting at offset 64
>
> Program Headers:
>   Type           Offset             VirtAddr           PhysAddr
>                  FileSiz            MemSiz              Flags  Align
>   NOTE           0x0000000000000158 0x0000000000000000 0x0000000000000000
>                  0x0000000000000b08 0x0000000000000b08         0
>   LOAD           0x0000000000000c60 0xffffffff81000000 0x0000000001000000
>                  0x000000000103b000 0x000000000103b000  RWE    0
>   LOAD           0x000000000103bc60 0xffff880000001000 0x0000000000001000
>                  0x000000000009cc00 0x000000000009cc00  RWE    0
>   LOAD           0x00000000010d8860 0xffff880000100000 0x0000000000100000
>                  0x0000000002f00000 0x0000000002f00000  RWE    0
>   LOAD           0x0000000003fd8860 0xffff880013000000 0x0000000013000000
>                  0x000000002cffd000 0x000000002cffd000  RWE    0
>
> Each PT_LOAD entry is assigned to virtual and physical address. In this case,
> 1st PT_LOAD entry belongs to kernel text mapping region, from which we can
> calculate phys_base value.

It seems like all the information you need would still be available?
The virtual address is there, so it should be trivial to see the
offset, IIUC.

> Therefore, we already have phys_base information even in case of kdump, and
> as long as using kdump-related tools such as crash utility, we don't need
> to see ELF PT_LOAD headers as I explain here because they calculate the process
> I explain here automatically.
>
> Another idea is to add phys_base value in VMCOREINFO information that is debugging
> information for user-land tools to filter crash dump. This is simple string information
> so you can see the values contained in some crash dump by using strings command to it.
> For example,

Sure, though not phys_base, but rather the offset? I think this is
similar to coredumps of PIE binaries end up with, though I haven't
looked very closely at that in a while.

-Kees

-- 
Kees Cook
Chrome OS Security
