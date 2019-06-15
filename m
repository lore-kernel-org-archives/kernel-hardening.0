Message-ID: <deb847beb643d43e6617f52eae7b15ee368d7ff8.camel@bootlin.com>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date: Sat, 15 Jun 2019 12:13:15 +0200
In-Reply-To: <20190614201434.3fa4bb6d@primarylaptop.localdomain>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
	 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
	 <20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
	 <20190614201434.3fa4bb6d@primarylaptop.localdomain>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>, Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Fri, 2019-06-14 at 20:14 +0200, Denis 'GNUtoo' Carikli wrote:
> On Fri, 14 Jun 2019 17:28:11 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > I'm wondering whether this is sloppy wording or whether the author is
> > really implying that they call the kernel decompressor with the MMU
> > enabled, against the express instructions in
> > Documentation/arm/Booting.
> According to [1]
> > If they are going against the express instructions, all bets are off.
> 
> More background on the decompressor patch:
> - The "ANDROID: arm: decompressor: Flush tlb before swiching domain 0 to
>   client mode" patch is needed anyway since 3.4 in any case, and
>   according to the thread about it [1], the MMU is on at boot.
> - There is a downstream u-boot port for the Galaxy SIII and other very
>   similar devices, which doesn't setup the MMU at boot, but I'm not
>   confident enough to test in on the devices I have. To test with
>   u-boot I'd need to find a new device.
> - If I don't manage to find a new device to test on, since there is
>   already some setup code like arch/arm/boot/compressed/head-sa1100.S
>   that deal with MMU that are enabled with the bootloader, are patches
>   to add a new file like that still accepted? The big downside is that
>   using something like that is probably incompatible with
>   ARCH_MULTIPLATFORM.

Maybe we could also consider having a shim that is executed before the
kernel in order to sanitize things and allow booting a mainline kernel,
which would be less invasive than a full U-Boot port.

Other than that, we can probably manage keeping a tree around (at the
Replicant project) with mainline and this patch (enabled through a
dedicated config option). As long as it's not horrible to rebase, it
can work well enough for us. 

I'm also not sure about the state of Android support in mainline today,
but there's a chance we'll need to pick a few patches on top of
mainline anyway.

What do you think?

Cheers,

Paul

-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
