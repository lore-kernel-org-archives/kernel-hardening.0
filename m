Date: Tue, 5 Sep 2017 12:37:55 -0700
From: Tony Lindgren <tony@atomide.com>
Message-ID: <20170905193754.GD5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170905164547.GA5024@atomide.com>
 <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170905 09:49]:
> On 5 September 2017 at 17:45, Tony Lindgren <tony@atomide.com> wrote:
> > I did see boot attempts fail with randomize enable where no output
> > was produced. It seems this is happening for me maybe 1 out of 5 boots.
> > Enabling DEBUG_LL did not show anything either.
> >
> 
> Yes. I am looking into a couple of kernelci boot reports that look
> suspicious, but it is rather difficult to reproduce, for obvious
> reasons :-)
> 
> Which hardware are you testing this on?

For testing on omap3, I'm mostly using logicpd torpedo devkit as
it works out of box with PM with mainline Linux and has NFSroot
usable too.

> > Then loading modules with CONFIG_RANDOMIZE_BASE=y seems to fail with:
> >
> > $ sudo modprobe rtc-twl
> > rtc_twl: disagrees about version of symbol module_layout
> > modprobe: ERROR: could not insert 'rtc_twl': Exec format error
> >
> 
> Is this with CONFIG_MODVERSIONS enabled?

Yes, but disabling that did not seem to make any difference
based on just one test.

Regards,

Tony
