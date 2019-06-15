Date: Fri, 14 Jun 2019 20:08:42 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <201906142002.833D224C6F@keescook>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
 <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>, Emese Revfy <re.emese@gmail.com>, Paul Kocialkowski <paul.kocialkowski@bootlin.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, Russell King <linux@armlinux.org.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 14, 2019 at 06:05:19PM +0200, Jann Horn wrote:
> On Fri, Jun 14, 2019 at 5:10 PM Denis 'GNUtoo' Carikli
> <GNUtoo@cyberdimension.org> wrote:
> > Booting was broken by the following commit:
> >   9f671e58159a ("security: Create "kernel hardening" config area")
> 
> I don't think GCC_PLUGINS alone is supposed to generate any code? It
> just makes it possible to enable a bunch of other kconfig flags that
> can generate code.
> 
> STACKPROTECTOR_PER_TASK defaults to y and depends on GCC_PLUGINS, so
> is that perhaps what broke? Can you try whether disabling just that
> works for you?

Yes, this has come up before: the option you want to disable is as Jann
mentions: CONFIG_STACKPROTECTOR_PER_TASK.

> My guess is that maybe there is some early boot code that needs to
> have the stack protector disabled, or something like that.

Right, though I'm not sure what portion would be specific to that
device. You can turn off SSP on a per-file basis with:

CFLAGS_target.o += $(DISABLE_ARM_SSP_PER_TASK_PLUGIN)

or per-Makefile, as in arch/arm/boot/compressed/Makefile.

-- 
Kees Cook
