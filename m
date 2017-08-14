MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.20.1708141333540.17016@knanqh.ubzr>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <CAK8P3a1zJPsHphvoOitQbTaY-7rzFndGKatM2=aeUphkG+3T_A@mail.gmail.com>
 <CAKv+Gu_-O5ZW=SzXe=0nRExfYWjyMWoJ3eObaZiiftPVNojibw@mail.gmail.com>
 <CAK8P3a1rV5yXm0CSZOx0ZVUiLENe=gBtn-9XUdHQmC2mPRwXOA@mail.gmail.com>
 <alpine.LFD.2.20.1708141220540.17016@knanqh.ubzr> <CAKv+Gu_he5AFct0MzNcbZT-ynp_NRSkRpmNTpbfk1BuUS9+aGw@mail.gmail.com>
 <alpine.LFD.2.20.1708141333540.17016@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 19:08:54 +0100
Message-ID: <CAKv+Gu8ve0h1zgo6XVu+a0n49u+i2ONNv9hS-Dymvt366X=gbw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 00/30] implement KASLR for ARM
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 August 2017 at 19:01, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> On Mon, 14 Aug 2017, Ard Biesheuvel wrote:
>
>> On 14 August 2017 at 17:28, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>> > On Mon, 14 Aug 2017, Arnd Bergmann wrote:
>> >
>> >> On Mon, Aug 14, 2017 at 5:49 PM, Ard Biesheuvel
>> >> <ard.biesheuvel@linaro.org> wrote:
>> >> > On 14 August 2017 at 16:30, Arnd Bergmann <arnd@arndb.de> wrote:
>> >>
>> >>
>> >> >> Can you explain how the random seed is passed from the bootloader
>> >> >> to the kernel when we don't use EFI? Is this implemented at all? I see
>> >> >> that you add a seed to "/chosen/kaslr-seed" in the EFI stub when using
>> >> >> the EFI boot services, but I don't see where that value gets read again
>> >> >> when we relocate the kernel.
>> >>
>> >> > To allow other bootloaders to do the same, the kaslr metadata is
>> >> > exposed via a zImage header, containing the values of PAGE_OFFSET, the
>> >> > base of the vmalloc area and the randomization granularity. A
>> >> > bootloader can read these values, and taking the size of DRAM and the
>> >> > placement of initrd and DTB into account, it can choose a value for
>> >> > kaslr offset and write it back into the zImage header.
>> >> >
>> >> > This is a bit involved, but it is really difficult to make these
>> >> > things backward compatible, i.e., passing something in a register is
>> >> > not possible if that register was not mandated to be zero initially.
>> >> >
>> >> > Similarly, the decompressor passed the kaslr offset to the startup
>> >> > code in the core kernel. It does so by passing it in r3 and jumping 4
>> >> > bytes past the entry point. This way, we are backward compatible with
>> >> > configurations where the decompressor is not used, because in that
>> >> > case, you always jump to the first instruction, which zeroes r3.
>> >>
>> >> There are two ideas we discussed in the past (but never implemented
>> >> them obviously):
>> >>
>> >> - instead of reading the "kaslr-seed" in the decompressor, it could
>> >>   simply hash all of the DT blob to get the seed. This way the bootloader
>> >>   can put the random see anywhere it likes, and as an added bonus,
>> >>   we also get a little bit more random behavior on machines that have
>> >>   no entropy source at all but that do have things like a serial number or
>> >>   mac address in DT. Obviously those would be constant across boots
>> >>   but different between machines. The OS can also store a random
>> >>   seed during shutdown in a location that the bootloader uses to
>> >>   initialize /chosen/kaslr-seed or another property that we use to seed
>> >>   the kernel PRNG at boot time.
>> >>
>> >> - If we have a random number at boot but no way to pass it through
>> >>   the DT, I think we actually /can/ pass it through registers: the
>> >>   register state is undefined, so in the worst case using the XOR of
>> >>   all registers gives us the same number on each boot, but the
>> >>   if the loader is modified to store a random 32-bit number in any
>> >>   of the registers that don't pass other information, we can use that
>> >>   to calculate the kaslr-base.
>> >
>> > I really like the later. This way there is no hard protocol to define
>> > and follow. The bootloader may exploit any source of randomness it can
>> > find, including the RTC in addition to the serial number for example. So
>> > doing both on the kernel side might actually be the best approach,
>> > giving the boot environment all the flexibility it wants and being
>> > compatible with all of them.
>> >
>>
>> Finding a source of entropy is not trivial, but it is not the difficult part.
>>
>> So when we pass some random seed to the decompressor, what will it do
>> with it? In order to find a suitable KASLR offset, it needs to know
>> the size of DRAM, the placement of the DT and potentially an initrd,
>> and the size of the vmalloc region in order to decide where it can put
>> the kernel.
>>
>> In my implementation, the decompressor simply receives the offset from
>> the bootloader, and exposes the value of PAGE_OFFSET, the base of  the
>> vmalloc region and the kaslr granularity supported by the kernel. The
>> bootloader should already know the size of DRAM and where it loaded
>> the DT and initrd, so it can roll the dice in an informed manner.
>>
>> Note that my UEFI stub implementation essentially does the same, which
>> was trivial to implement because UEFI already keeps track of all
>> allocations in DRAM. Note that this version simply disables KASLR if
>> it encounters a vmalloc= command line argument, given that it affects
>> the size of the lowmem region. We could enhance that to actually parse
>> the value, but I kept it simple for now.
>
> What I dislike about such an arrangement (and I've brought up this
> argument forward in a different context before) is that you create a lot
> of additional dependencies between the kernel and the boot environment.
> The kernel is no longer self-sufficient and all this boot preparation
> has to be duplicated in all boot environments from UEFI to U-Boot to
> qemu. The fact that the bootloader now has to care about very Linux
> internal concepts such as vmalloc_start makes it rather inelegant to me.
>
> I'm even wondering if, design wise, the best solution wouldn't be for
> the actual kernel to move itself during the boot process and reboot
> itself without any external help. Not necessarily go as far as the full
> kexec danse , but boot far enough to parse the DT, initialize the
> bootmem allocator, then find a new location for itself, move it there,
> do the relocs and restart the boot process.  For this to work well, you
> would have to make a copy of the .data section so to reboot again with a
> pristine version except for one flag indicating that the move has been
> done.
>
> Doing it this way gives you a full kernel environment to work from and
> be completely self-sufficient with zero reliance on any boot
> environment. This would even make it compatible with Image i.e. the
> compressor-less kernel. And if the DT and/or initrd is in the way then
> you could even go as far as moving them away if you wanted.
>

Interestingly, this is essentially how I implemented it for arm64. It
boots to the point where it can retrieve the kaslr-seed from the DT
(and the 'nokaslr' command line argument), and either proceeds (if
there is no seed or nokaslr is passed), or it returns to the startup
code and remaps the kernel at a randomized offset.

However, the configurations are very different. The arm64 kernel
mappings are disjoint from the kernel's direct mapping, and the
physical offset is under the control of the bootloader anyway. So when
it returns to the startup code, it only updates the virtual mapping
not the physical placement.

> This would add some boot latency of course, but certainly in the
> sub-second range. That is negligible for those systems where KASLR is
> most relevant.
>

I will try to come up with something that makes it more self contained.
