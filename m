MIME-Version: 1.0
In-Reply-To: <20170821103708.GD3028@leverpostej>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-30-ard.biesheuvel@linaro.org> <20170821103708.GD3028@leverpostej>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 21 Aug 2017 11:39:15 +0100
Message-ID: <CAKv+Gu-=U_f16vcz5GxgQ1FxiWTcGjXhjVau5y0CKgUOJzJrcA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 29/30] efi/libstub: arm: reserve bootloader supplied
 initrd in memory map
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Tony Lindgren <tony@atomide.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 21 August 2017 at 11:37, Mark Rutland <mark.rutland@arm.com> wrote:
> On Mon, Aug 14, 2017 at 01:54:10PM +0100, Ard Biesheuvel wrote:
>> Under KASLR, the EFI stub may allocate the kernel anywhere in the
>> physical address space, which could be right on top of an initrd
>> if it was supplied by the bootloader (i.e., GRUB) in /chosen rather
>> than passed via the initrd= command line option. So allocate the
>> pages explicitly, this ensures that the random memory allocation
>> routine will disregard the region.
>
> I'm a little confused. Shouldn't the bootloader have allocated that
> memory, leaving it reserved?
>
> If it hasn't, then that region could be allcoated by anything else at
> any time (e.g. by the code which loads the kernel, or some EFI timer
> callback), so that sounds like a bootloader bug that we can't fix.
>

Yeah, thinko on my part. Thanks for spotting that.
