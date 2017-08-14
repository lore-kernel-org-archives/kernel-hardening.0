MIME-Version: 1.0
In-Reply-To: <CAK8P3a1zJPsHphvoOitQbTaY-7rzFndGKatM2=aeUphkG+3T_A@mail.gmail.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org> <CAK8P3a1zJPsHphvoOitQbTaY-7rzFndGKatM2=aeUphkG+3T_A@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 16:49:22 +0100
Message-ID: <CAKv+Gu_-O5ZW=SzXe=0nRExfYWjyMWoJ3eObaZiiftPVNojibw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 00/30] implement KASLR for ARM
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 August 2017 at 16:30, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Aug 14, 2017 at 2:53 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> This series implements randomization of the placement of the core ARM kernel
>> inside the lowmem region. It consists of the following parts:
>>
>> - changes that allow us to build vmlinux as a PIE executable which retains
>>   the metadata required to fix up all absolute symbol references at runtime
>> - changes that eliminate absolute references from low-level code that may
>>   execute with the MMU off: this removes the need to perform explicit cache
>>   maintenance after the absolute references have been fixed up at runtime with
>>   the caches enabled
>> - changes to the core kernel startup code to take the physical offset into
>>   account when creating the virtual mapping (the pa-to-va mapping remains
>>   unchanged)
>> - changes to the decompressor to take the KASLR offset into account when
>>   placing the kernel in physical memory
>> - changes to the UEFI stub code to choose the KASLR offset and communicate
>>   it to the decompressor
>
> Would it make sense to also randomize the pa-to-va mapping on top of this?
> That can certainly be a later follow-up, I'm just trying to think of the options
> we have, given that the kernel is now relocatable and we can support arbitrary
> pa-to-va mappings already.
>

We could randomize PAGE_OFFSET as well. That allows you to build a
3g/1g split kernel and execute it as 2g/2g split. Pretty neat!

Randomizing the VA to PA mapping while keep PAGE_OFFSET constant will
result in either memory to be thrown away (because it is virtually
mapped below PAGE_OFFSET) or lowmem space to be wasted (because there
is a hole between PAGE_OFFSET and the VA of the lowest lowmem address)

So i think there may be opportunities, but I haven't quite figured
them out myself yet.

> Can you explain how the random seed is passed from the bootloader
> to the kernel when we don't use EFI? Is this implemented at all? I see
> that you add a seed to "/chosen/kaslr-seed" in the EFI stub when using
> the EFI boot services, but I don't see where that value gets read again
> when we relocate the kernel.

/chosen/kaslr-seed is only used on arm64, not on ARM. We could add
code to the decompressor that uses /chosen/kaslr-seed, but it is a bit
fiddly because the execution environment is so constrained, and there
is no simple access to symbols defined by the core kernel's linker
script.

On UEFI systems, the kaslr offset is calculated based on the UEFI
memory map, which describes all of memory and has reservations for the
DTB, the initrd etc. The EFI stub is linked together with the
decompressor, so passing the kaslr offset simply involves setting a
variable.

To allow other bootloaders to do the same, the kaslr metadata is
exposed via a zImage header, containing the values of PAGE_OFFSET, the
base of the vmalloc area and the randomization granularity. A
bootloader can read these values, and taking the size of DRAM and the
placement of initrd and DTB into account, it can choose a value for
kaslr offset and write it back into the zImage header.

This is a bit involved, but it is really difficult to make these
things backward compatible, i.e., passing something in a register is
not possible if that register was not mandated to be zero initially.

Similarly, the decompressor passed the kaslr offset to the startup
code in the core kernel. It does so by passing it in r3 and jumping 4
bytes past the entry point. This way, we are backward compatible with
configurations where the decompressor is not used, because in that
case, you always jump to the first instruction, which zeroes r3.
