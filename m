Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <56DD7B66.7010807@de.ibm.com>
References: <1455748879-21872-1-git-send-email-keescook@chromium.org>
	<1455748879-21872-5-git-send-email-keescook@chromium.org>
	<56DD7B66.7010807@de.ibm.com>
Date: Mon, 7 Mar 2016 16:16:20 -0800
Message-ID: <CAGXu5jLWm2poPQFCj3GYOrcyzGOpdv0UK_9aU8Z6mOhwbqEHmw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 4/7] introduce post-init read-only memory
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Brown <david.brown@linaro.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 7, 2016 at 5:00 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 02/17/2016 11:41 PM, Kees Cook wrote:
>> One of the easiest ways to protect the kernel from attack is to reduce
>> the internal attack surface exposed when a "write" flaw is available. By
>> making as much of the kernel read-only as possible, we reduce the
>> attack surface.
>>
>> Many things are written to only during __init, and never changed
>> again. These cannot be made "const" since the compiler will do the wrong
>> thing (we do actually need to write to them). Instead, move these items
>> into a memory region that will be made read-only during mark_rodata_ro()
>> which happens after all kernel __init code has finished.
>>
>> This introduces __ro_after_init as a way to mark such memory, and adds
>> some documentation about the existing __read_mostly marking.
>>
>> Based on work by PaX Team and Brad Spengler.
>
> This seems to crash in the lkdtm module on s390, if the module
> is compiled in.
>
> [    0.360571] Unable to handle kernel pointer dereference in virtual kernel address space
> [    0.360574] Failing address: 0000000000996000 TEID: 0000000000996407
> [    0.360575] Fault in home space mode while using kernel ASCE.
> [    0.360577] AS:0000000000cac007 R3:000000003ffd1007 S:0000000000901600
> [    0.360665] Oops: 0004 ilc:3 [#1] SMP
> [    0.360668] Modules linked in:
> [    0.360674] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.5.0-rc6-next-20160304+ #165
> [    0.360676] task: 000000003de40000 ti: 000000003de48000 task.ti: 000000003de48000
> [    0.360678] Krnl PSW : 0704d00180000000 0000000000c480e8 (lkdtm_module_init+0x28/0x278)
> [    0.360680]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:1 PM:0 RI:0 EA:3
> Krnl GPRS: ffffffffffffffee 0000000055aa55aa 00000000016503a0 00000000000004ef
> [    0.360682]            00000000001001ca 00000000000004f0 0000000000c93370 0000000000000000
> [    0.360683]            0000000000c57008 000000000000006a 0000000000000002 0000000000000000
> [    0.360685]            0000000000c480c0 0000000001650380 000000003de4bd88 000000003de4bd28
> [    0.360698] Krnl Code: 0000000000c480d8: a51b00aa            oill    %r1,170
>            0000000000c480dc: e3f0ffa0ff71       lay     %r15,-96(%r15)
>           #0000000000c480e2: e3e0f0980024       stg     %r14,152(%r15)
>           >0000000000c480e8: c41bffea76c8       stgrl   %r1,996e78
>            0000000000c480ee: c020ffe95e5c       larl    %r2,973da6
>            0000000000c480f4: a7390000           lghi    %r3,0
>            0000000000c480f8: c0d0ffdee974       larl    %r13,8253e0
>            0000000000c480fe: a7c90009           lghi    %r12,9
> [    0.360710] Call Trace:
> [    0.360713] ([<000000003de4be28>] 0x3de4be28)
> [    0.360718] ([<00000000001001da>] do_one_initcall+0xa2/0x1b0)
> [    0.360724] ([<0000000000c0dcf4>] kernel_init_freeable+0x1e4/0x298)
> [    0.360729] ([<00000000007b3cda>] kernel_init+0x2a/0x128)
> [    0.360731] ([<00000000007bcc8e>] kernel_thread_starter+0x6/0xc)
> [    0.360733] ([<00000000007bcc88>] kernel_thread_starter+0x0/0xc)
> [    0.360733] Last Breaking-Event-Address:
> [    0.360735]  [<00000000001001d8>] do_one_initcall+0xa0/0x1b0
> [    0.360735]
> [    0.360738] Kernel panic - not syncing: Fatal exception: panic_on_oops
>
>
> The code in question is
>         /* Make sure we can write to __ro_after_init values during __init */
>         ro_after_init |= 0xAA;
>
>
> The problem is that s390 does not call mark_rodata_ro, instead sections are
> marked read-only earlier. Maybe we should change that. Heiko, Martin?

Since you've got rodata starting life as rodata, perhaps s390 could
use a different section for __ro_after_init and only mark that section
as RO during mark_rodata_ro()? It'd be nice to have that level of
granularity, actually.

I'll send an utterly untested patch... :P

-Kees

>
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/parisc/include/asm/cache.h   |  3 +++
>>  include/asm-generic/vmlinux.lds.h |  1 +
>>  include/linux/cache.h             | 14 ++++++++++++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
>> index 3d0e17bcc8e9..df0f52bd18b4 100644
>> --- a/arch/parisc/include/asm/cache.h
>> +++ b/arch/parisc/include/asm/cache.h
>> @@ -22,6 +22,9 @@
>>
>>  #define __read_mostly __attribute__((__section__(".data..read_mostly")))
>>
>> +/* Read-only memory is marked before mark_rodata_ro() is called. */
>> +#define __ro_after_init      __read_mostly
>> +
>>  void parisc_cache_init(void);        /* initializes cache-flushing */
>>  void disable_sr_hashing_asm(int); /* low level support for above */
>>  void disable_sr_hashing(void);   /* turns off space register hashing */
>> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
>> index e9a81a6a109f..8f5a12ab2f2b 100644
>> --- a/include/asm-generic/vmlinux.lds.h
>> +++ b/include/asm-generic/vmlinux.lds.h
>> @@ -255,6 +255,7 @@
>>       .rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {           \
>>               VMLINUX_SYMBOL(__start_rodata) = .;                     \
>>               *(.rodata) *(.rodata.*)                                 \
>> +             *(.data..ro_after_init) /* Read only after init */      \
>>               *(__vermagic)           /* Kernel version magic */      \
>>               . = ALIGN(8);                                           \
>>               VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;         \
>> diff --git a/include/linux/cache.h b/include/linux/cache.h
>> index 17e7e82d2aa7..1be04f8c563a 100644
>> --- a/include/linux/cache.h
>> +++ b/include/linux/cache.h
>> @@ -12,10 +12,24 @@
>>  #define SMP_CACHE_BYTES L1_CACHE_BYTES
>>  #endif
>>
>> +/*
>> + * __read_mostly is used to keep rarely changing variables out of frequently
>> + * updated cachelines. If an architecture doesn't support it, ignore the
>> + * hint.
>> + */
>>  #ifndef __read_mostly
>>  #define __read_mostly
>>  #endif
>>
>> +/*
>> + * __ro_after_init is used to mark things that are read-only after init (i.e.
>> + * after mark_rodata_ro() has been called). These are effectively read-only,
>> + * but may get written to during init, so can't live in .rodata (via "const").
>> + */
>> +#ifndef __ro_after_init
>> +#define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
>> +#endif
>> +
>>  #ifndef ____cacheline_aligned
>>  #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
>>  #endif
>>
>



-- 
Kees Cook
Chrome OS & Brillo Security
