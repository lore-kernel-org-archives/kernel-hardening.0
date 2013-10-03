Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524CBB70.2060809@jp.fujitsu.com>
Date: Thu, 03 Oct 2013 09:33:52 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
MIME-Version: 1.0
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>	<1380656245-29975-7-git-send-email-keescook@chromium.org>	<524B6AEE.90301@jp.fujitsu.com> <CAGXu5jLVt13p2X2e1C3ha1izg6U6wbmgSyYW1wa+X4cW8aCFug@mail.gmail.com> <524BE3C5.2070302@jp.fujitsu.com>
In-Reply-To: <524BE3C5.2070302@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 6/7] x86, kaslr: report kernel offset on panic
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, "H. Peter Anvin" <hpa@zytor.com>, Dave Anderson <anderson@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

(2013/10/02 18:13), HATAYAMA Daisuke wrote:
> (2013/10/02 16:48), Kees Cook wrote:
<cut>
>>>> +
>>>> +     return 0;
>>>> +}
>>>> +
>>>> +/*
>>>>     * Determine if we were loaded by an EFI loader.  If so, then we have also been
>>>>     * passed the efi memmap, systab, etc., so we should use these data structures
>>>>     * for initialization.  Note, the efi init code path is determined by the
>>>> @@ -1242,3 +1256,15 @@ void __init i386_reserve_resources(void)
>>>>    }
>>>>
>>>>    #endif /* CONFIG_X86_32 */
>>>> +
>>>> +static struct notifier_block kernel_offset_notifier = {
>>>> +     .notifier_call = dump_kernel_offset
>>>> +};
>>>> +
>>>> +static int __init register_kernel_offset_dumper(void)
>>>> +{
>>>> +     atomic_notifier_chain_register(&panic_notifier_list,
>>>> +                                     &kernel_offset_notifier);
>>>> +     return 0;
>>>> +}
>>>> +__initcall(register_kernel_offset_dumper);
>>>>
>>>
>>> Panic notifier is not executed if kdump is enabled. Maybe, Chrome OS doesn't use
>>> kdump? Anyway, kdump related tools now calculate phys_base from memory map
>>> information passed as ELF PT_LOAD entries like below.
>>
>> Correct, we are not currently using kdump.
>>
>>> $ LANG=C readelf -l vmcore-rhel6up4
>>>
>>> Elf file type is CORE (Core file)
>>> Entry point 0x0
>>> There are 5 program headers, starting at offset 64
>>>
>>> Program Headers:
>>>    Type           Offset             VirtAddr           PhysAddr
>>>                   FileSiz            MemSiz              Flags  Align
>>>    NOTE           0x0000000000000158 0x0000000000000000 0x0000000000000000
>>>                   0x0000000000000b08 0x0000000000000b08         0
>>>    LOAD           0x0000000000000c60 0xffffffff81000000 0x0000000001000000
>>>                   0x000000000103b000 0x000000000103b000  RWE    0
>>>    LOAD           0x000000000103bc60 0xffff880000001000 0x0000000000001000
>>>                   0x000000000009cc00 0x000000000009cc00  RWE    0
>>>    LOAD           0x00000000010d8860 0xffff880000100000 0x0000000000100000
>>>                   0x0000000002f00000 0x0000000002f00000  RWE    0
>>>    LOAD           0x0000000003fd8860 0xffff880013000000 0x0000000013000000
>>>                   0x000000002cffd000 0x000000002cffd000  RWE    0
>>>
>>> Each PT_LOAD entry is assigned to virtual and physical address. In this case,
>>> 1st PT_LOAD entry belongs to kernel text mapping region, from which we can
>>> calculate phys_base value.
>>
>> It seems like all the information you need would still be available?
>> The virtual address is there, so it should be trivial to see the
>> offset, IIUC.
>>
>
> Partially yes. I think OK to analyze crash dump by crash utility, a gdb-based
> symbolic debugger for kernel, since phys_base absorbs kernel offset caused by
> relocation and phys_base is available in the way I explained above.
>
> However, the gained phys_base is not correct one, exactly
> phys_base + offset_by_relocation.
> When analyzing crash dump by crash utility, we use debug information generated
> during kernel build, which we install as kernel-debuginfo on RHEL for example.
> Symbols in debuginfo have statically assigned addresses at build so we see
> the statically assigned addresses during debugging and we see
> phys_base + offset_by_relocation as phys_base. This would be problematic
> if failure on crash dump is relevant to the relocated addresses, though I don't
> immediately come up with crash senario where relocated symbol is defitely
> necessary.
>
> Still we can get relocated addresses if kallsyms is enabled on the kernel,
> but kallsyms and relocatable kernels are authogonal. I don't think it natural
> to rely on kallsyms. It seems natural to export relocation information newly
> as debugging information.
>

I was confused yesterday. As I said above, kdump related tools now don't support
relocation on x86_64, phys_base only. kdump related tools think of present kernel
offset as phys_base. Then, they reflect kernel offset caused by relocation in
physical addresses only, not in virtual addresses. This obviously affects the tools.

BTW, relocation looks more sophisticated than phys_base one. Is it possible to
switch from phys_base one to relocation on x86_64? On x86, relocation is used so
I guess x86_64 can work in the same way. Is there something missing?
Is there what phys_base can but relocation cannot on x86_64?

And, Dave, is there feature for crash utility to treat relocation now?

-- 
Thanks.
HATAYAMA, Daisuke
