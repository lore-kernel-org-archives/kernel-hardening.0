MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 14 Aug 2017 17:30:55 +0200
Message-ID: <CAK8P3a1zJPsHphvoOitQbTaY-7rzFndGKatM2=aeUphkG+3T_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 00/30] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 14, 2017 at 2:53 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> This series implements randomization of the placement of the core ARM kernel
> inside the lowmem region. It consists of the following parts:
>
> - changes that allow us to build vmlinux as a PIE executable which retains
>   the metadata required to fix up all absolute symbol references at runtime
> - changes that eliminate absolute references from low-level code that may
>   execute with the MMU off: this removes the need to perform explicit cache
>   maintenance after the absolute references have been fixed up at runtime with
>   the caches enabled
> - changes to the core kernel startup code to take the physical offset into
>   account when creating the virtual mapping (the pa-to-va mapping remains
>   unchanged)
> - changes to the decompressor to take the KASLR offset into account when
>   placing the kernel in physical memory
> - changes to the UEFI stub code to choose the KASLR offset and communicate
>   it to the decompressor

Would it make sense to also randomize the pa-to-va mapping on top of this?
That can certainly be a later follow-up, I'm just trying to think of the options
we have, given that the kernel is now relocatable and we can support arbitrary
pa-to-va mappings already.

Can you explain how the random seed is passed from the bootloader
to the kernel when we don't use EFI? Is this implemented at all? I see
that you add a seed to "/chosen/kaslr-seed" in the EFI stub when using
the EFI boot services, but I don't see where that value gets read again
when we relocate the kernel.

      Arnd
