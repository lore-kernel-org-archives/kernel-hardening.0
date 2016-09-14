Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 14 Sep 2016 09:52:29 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160914085159.GA13121@leverpostej>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com>
 <1473788797-10879-4-git-send-email-catalin.marinas@arm.com>
 <CAGXu5jJETdRtuonhtkSxMf+sgCdBj2t2_U8yW2cDwcoGY=qvJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJETdRtuonhtkSxMf+sgCdBj2t2_U8yW2cDwcoGY=qvJw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 3/7] arm64: Introduce uaccess_{disable,enable}
 functionality based on TTBR0_EL1
To: Kees Cook <keescook@chromium.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 01:45:21PM -0700, Kees Cook wrote:
> On Tue, Sep 13, 2016 at 10:46 AM, Catalin Marinas
> > +static inline bool system_uses_ttbr0_pan(void)
> > +{
> > +       return IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
> > +               !cpus_have_cap(ARM64_HAS_PAN);
> > +}
> > +

[...]

> >  #define __uaccess_enable(alt)                                          \
> >  do {                                                                   \
> > -       asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,                  \
> > -                       CONFIG_ARM64_PAN));                             \
> > +       if (system_uses_ttbr0_pan())                                    \
> > +               uaccess_ttbr0_enable();                                 \
> > +       else                                                            \
> > +               asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,          \
> > +                               CONFIG_ARM64_PAN));                     \
> >  } while (0)
> 
> Does this mean that with CONFIG_ARM64_SW_TTBR0_PAN, even with ARMv8.1,
> a cpu capability bitmask check is done each time we go through
> __uaccess_{en,dis}able?

Catalin reworked cpus_have_cap() to use static keys [1], and that's
queued in the arm64 for-next/core branch [2].

So this should expand to a single branch or nop that we patch when we
detect the presence/absence of PAN. There should be no bitmap check.

Thanks,
Mark.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2016-September/454025.html
[2] https://git.kernel.org/cgit/linux/kernel/git/arm64/linux.git/log/?h=for-next/core
