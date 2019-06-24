Message-ID: <d69f8b447b263a491283993d35a5a3817916a3cf.camel@bootlin.com>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date: Mon, 24 Jun 2019 15:31:00 +0200
In-Reply-To: <20190622014238.3231cdb4@primarylaptop.localdomain>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
	 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
	 <20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
	 <20190614201434.3fa4bb6d@primarylaptop.localdomain>
	 <deb847beb643d43e6617f52eae7b15ee368d7ff8.camel@bootlin.com>
	 <20190622014238.3231cdb4@primarylaptop.localdomain>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
Cc: Russell King - ARM Linux admin <linux@armlinux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sat, 2019-06-22 at 01:42 +0200, Denis 'GNUtoo' Carikli wrote:
> On Sat, 15 Jun 2019 12:13:15 +0200
> Paul Kocialkowski <paul.kocialkowski@bootlin.com> wrote:
> > Other than that, we can probably manage keeping a tree around (at the
> > Replicant project) with mainline and this patch (enabled through a
> > dedicated config option). As long as it's not horrible to rebase, it
> > can work well enough for us.
> I've managed to buy a new Galaxy SIII 4G (I9305) and I've tried u-boot
> on it, and it works flawlessly without any patches and it does also
> work with CONFIG_STACKPROTECTOR_PER_TASK=y.

That's good to know, maybe they realized that they got it wrong later
on. Hopefully this can indicate that future models are not affected.

> Merely rebasing that arm decompressor patch over time should not be an
> issue. However I really want to find a way to avoid having to look
> again and again over time for commits that incidentally broke booting,
> because, the bootloader doesn't do what it's supposed to do.

I don't think there are many more areas where the bootloader can
misbehave to a point where it will influence Linux (of course, that's
without mention of software running in the "secure" world, which can be
totally out of control as you know).

> > Maybe we could also consider having a shim that is executed before the
> > kernel in order to sanitize things and allow booting a mainline
> > kernel, which would be less invasive than a full U-Boot port.
> If I understand correctly, that isn't a solution either as it
> would also be affected by the issues mentioned by Russell King.

It is definitely a solution, but it comes with the constraint that it
must be able to run and act as a trampoline between the bootloader and
Linux. This means that the code must be able to deal with MMU and cache
enabled.

> More specifically I would need to do more research to find if the
> bootloader(s) shipped on such smartphones properly cleans and
> invalidates the caches before jumping to the first instruction.
> 
> Doing that research probably requires decompiling the bootloader,
> which in turn would require me to get legal advise to understand if it's
> possible to do it, and if so how to do it while respecting the laws
> involved, and still being able to work on free and open
> source bootloaders without creating issues for the projects.

I would rather try to just write minimal code and make sure it
generally works. We can't really have any hard guarantee, but a program
that was shown to run over and over again without faulting is probably
good enough, since it would be very small.

> Another alternative to that would be to make users use u-boot but
> this is not possible either because:
> - The bootloader is signed. So the bootrom checks the signature of the
>   first bootloader (BL1), which in turn checks the second bootloader
>   (S-Boot) in which the MMU setup probably happens. So I can't merely
>   replace S-Boot like that.
> - Fortunately for that system on a chip, there is at least one BL1 that
>   is signed but that doesn't check subsequent signatures[1]. The issue
>   is that it's not redistributable[2].
> 
> If that BL1 had not been published I would always need to use additional
> patches to test the patch I send, which is very problematic in many
> ways:
> - The additional patches would need to be mentioned in most or all of
>   the commits I send upstream.
> - If not, the maintainers and readers of the patch would be unaware
>   that it would require another patch on top to work.
> 
> So thanks to that, I'm at least able to test the patches I send in
> Linux without requiring additional patches on top, but I'm still not
> able to ship something usable to end users.
> 
> This means that the work to complete the support for the affected devices will
> be way less useful, as there would be no guarantee of users still being
> able to use the device with newer Linux kernels. 

I agree and while a U-Boot port is desirable, it's not the easiest
solution users to bootstrap mainline Linux on the device.

> Are there other (Android) smartphones affected by similar bootloader
> issues? If so is it even possible to replace part of the bootloader?
> Did some people found a way to deal with that kind of bootloader issue?

As far as I know, the few Android devices supported by mainline Linux
don't have similar issues (e.g. OMAP phones/tablets) so the situation
probably hasn't occured much.

Cheers,

Paul

> References:
> -----------
> [1]https://wiki.odroid.com/_media/en/boot.tar.gz
> [2]https://github.com/hardkernel/u-boot_firmware/issues/1
> 
> Denis.
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com
