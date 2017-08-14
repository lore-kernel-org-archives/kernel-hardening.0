MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAKv+Gu_-O5ZW=SzXe=0nRExfYWjyMWoJ3eObaZiiftPVNojibw@mail.gmail.com>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <CAK8P3a1zJPsHphvoOitQbTaY-7rzFndGKatM2=aeUphkG+3T_A@mail.gmail.com> <CAKv+Gu_-O5ZW=SzXe=0nRExfYWjyMWoJ3eObaZiiftPVNojibw@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 14 Aug 2017 18:03:48 +0200
Message-ID: <CAK8P3a1rV5yXm0CSZOx0ZVUiLENe=gBtn-9XUdHQmC2mPRwXOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 00/30] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 5:49 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 14 August 2017 at 16:30, Arnd Bergmann <arnd@arndb.de> wrote:


>> Can you explain how the random seed is passed from the bootloader
>> to the kernel when we don't use EFI? Is this implemented at all? I see
>> that you add a seed to "/chosen/kaslr-seed" in the EFI stub when using
>> the EFI boot services, but I don't see where that value gets read again
>> when we relocate the kernel.

> To allow other bootloaders to do the same, the kaslr metadata is
> exposed via a zImage header, containing the values of PAGE_OFFSET, the
> base of the vmalloc area and the randomization granularity. A
> bootloader can read these values, and taking the size of DRAM and the
> placement of initrd and DTB into account, it can choose a value for
> kaslr offset and write it back into the zImage header.
>
> This is a bit involved, but it is really difficult to make these
> things backward compatible, i.e., passing something in a register is
> not possible if that register was not mandated to be zero initially.
>
> Similarly, the decompressor passed the kaslr offset to the startup
> code in the core kernel. It does so by passing it in r3 and jumping 4
> bytes past the entry point. This way, we are backward compatible with
> configurations where the decompressor is not used, because in that
> case, you always jump to the first instruction, which zeroes r3.

There are two ideas we discussed in the past (but never implemented
them obviously):

- instead of reading the "kaslr-seed" in the decompressor, it could
  simply hash all of the DT blob to get the seed. This way the bootloader
  can put the random see anywhere it likes, and as an added bonus,
  we also get a little bit more random behavior on machines that have
  no entropy source at all but that do have things like a serial number or
  mac address in DT. Obviously those would be constant across boots
  but different between machines. The OS can also store a random
  seed during shutdown in a location that the bootloader uses to
  initialize /chosen/kaslr-seed or another property that we use to seed
  the kernel PRNG at boot time.

- If we have a random number at boot but no way to pass it through
  the DT, I think we actually /can/ pass it through registers: the
  register state is undefined, so in the worst case using the XOR of
  all registers gives us the same number on each boot, but the
  if the loader is modified to store a random 32-bit number in any
  of the registers that don't pass other information, we can use that
  to calculate the kaslr-base.

         Arnd
