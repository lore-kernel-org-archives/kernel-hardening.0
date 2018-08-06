MIME-Version: 1.0
In-Reply-To: <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com>
References: <20180802132133.23999-1-ard.biesheuvel@linaro.org> <7529eedf-af56-2e94-261e-bc5c86abadaa@arm.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 6 Aug 2018 16:04:09 +0200
Message-ID: <CAKv+Gu9X1CDpy+XvrmbSdjBjMb45eBW7JVsvsK_JQdUt2Dbvgw@mail.gmail.com>
Subject: Re: [RFC/PoC PATCH 0/3] arm64: basic ROP mitigation
Content-Type: text/plain; charset="UTF-8"
To: Robin Murphy <robin.murphy@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Laura Abbott <labbott@fedoraproject.org>, Julien Thierry <julien.thierry@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 August 2018 at 15:55, Robin Murphy <robin.murphy@arm.com> wrote:
> On 02/08/18 14:21, Ard Biesheuvel wrote:
>>
>> This is a proof of concept I cooked up, primarily to trigger a discussion
>> about whether there is a point to doing anything like this, and if there
>> is, what the pitfalls are. Also, while I am not aware of any similar
>> implementations, the idea is so simple that I would be surprised if nobody
>> else thought of the same thing way before I did.
>
>
> So, "TTBR0 PAN: Pointer Auth edition"? :P
>
>> The idea is that we can significantly limit the kernel's attack surface
>> for ROP based attacks by clearing the stack pointer's sign bit before
>> returning from a function, and setting it again right after proceeding
>> from the [expected] return address. This should make it much more
>> difficult
>> to return to arbitrary gadgets, given that they rely on being chained to
>> the next via a return address popped off the stack, and this is difficult
>> when the stack pointer is invalid.
>>
>> Of course, 4 additional instructions per function return is not exactly
>> for free, but they are just movs and adds, and leaf functions are
>> disregarded unless they allocate a stack frame (this comes for free
>> because simple_return insns are disregarded by the plugin)
>>
>> Please shoot, preferably with better ideas ...
>
>
> Actually, on the subject of PAN, shouldn't this at least have a very hard
> dependency on that? AFAICS without PAN clearing bit 55 of SP is effectively
> giving userspace direct control of the kernel stack (thanks to TBI). Ouch.
>

How's that? Bits 52 .. 54 will still be set, so SP will never contain
a valid userland address in any case. Or am I missing something?

> I wonder if there's a little  more mileage in using "{add,sub} sp, sp, #1"
> sequences to rely on stack alignment exceptions instead, with the added
> bonus that that's about as low as the instruction-level overhead can get.
>

Good point. I did consider that, but couldn't convince myself that it
isn't easier to defeat: loads via x29 occur reasonably often, and you
can simply offset your doctored stack frame by a single byte.


>>
>> Ard Biesheuvel (3):
>>    arm64: use wrapper macro for bl/blx instructions from asm code
>>    gcc: plugins: add ROP shield plugin for arm64
>>    arm64: enable ROP protection by clearing SP bit #55 across function
>>      returns
>>
>>   arch/Kconfig                                  |   4 +
>>   arch/arm64/Kconfig                            |  10 ++
>>   arch/arm64/include/asm/assembler.h            |  21 +++-
>>   arch/arm64/kernel/entry-ftrace.S              |   6 +-
>>   arch/arm64/kernel/entry.S                     | 104 +++++++++-------
>>   arch/arm64/kernel/head.S                      |   4 +-
>>   arch/arm64/kernel/probes/kprobes_trampoline.S |   2 +-
>>   arch/arm64/kernel/sleep.S                     |   6 +-
>>   drivers/firmware/efi/libstub/Makefile         |   3 +-
>>   scripts/Makefile.gcc-plugins                  |   7 ++
>>   scripts/gcc-plugins/arm64_rop_shield_plugin.c | 116 ++++++++++++++++++
>>   11 files changed, 228 insertions(+), 55 deletions(-)
>>   create mode 100644 scripts/gcc-plugins/arm64_rop_shield_plugin.c
>>
>
