Date: Fri, 14 Jun 2019 17:28:11 +0100
From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <20190614162811.o33yeq65ythjumrh@shell.armlinux.org.uk>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
To: Jann Horn <jannh@google.com>
Cc: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Paul Kocialkowski <paul.kocialkowski@bootlin.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 14, 2019 at 06:05:19PM +0200, Jann Horn wrote:
> +32-bit ARM folks
> 
> On Fri, Jun 14, 2019 at 5:10 PM Denis 'GNUtoo' Carikli
> <GNUtoo@cyberdimension.org> wrote:
> > On a Galaxy SIII (I9300), the patch mentioned below broke boot:
> > - The display still had the bootloader logo, while with this
> >   patch, the 4 Tux logo appears.
> > - No print appeared on the serial port anymore after the kernel
> >   was loaded, whereas with this patch, we have the serial
> >   console working, and the device booting.
> >
> > Booting was broken by the following commit:
> >   9f671e58159a ("security: Create "kernel hardening" config area")
> >
> > As the bootloader of this device enables the MMU, I had the following
> > patch applied during the tests:
> >   Author: Arve Hjønnevåg <arve@android.com>
> >   Date:   Fri Nov 30 17:05:40 2012 -0800
> >
> >       ANDROID: arm: decompressor: Flush tlb before swiching domain 0 to client mode
> >
> >       If the bootloader used a page table that is incompatible with domain 0
> >       in client mode, and boots with the mmu on, then swithing domain 0 to
> >       client mode causes a fault if we don't flush the tlb after updating
> >       the page table pointer.
> >
> >       v2: Add ISB before loading dacr.

I'm wondering whether this is sloppy wording or whether the author is
really implying that they call the kernel decompressor with the MMU
enabled, against the express instructions in Documentation/arm/Booting.

If they are going against the express instructions, all bets are off.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
