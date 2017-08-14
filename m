MIME-Version: 1.0
In-Reply-To: <20170814164227.GJ20805@n2100.armlinux.org.uk>
References: <20170814125411.22604-1-ard.biesheuvel@linaro.org>
 <20170814125411.22604-3-ard.biesheuvel@linaro.org> <20170814152950.GT6321@e103592.cambridge.arm.com>
 <CAKv+Gu87G93X36TdAEiMC46Uz_PqXEi_4LSftnUdkQ8HRCxWiA@mail.gmail.com>
 <20170814155002.GV6321@e103592.cambridge.arm.com> <alpine.LFD.2.20.1708141217150.17016@knanqh.ubzr>
 <CAKv+Gu_3gb4K_2=igLWMjtXuEcdhnqeoVgaW7Lvqx56AQU-VZg@mail.gmail.com> <20170814164227.GJ20805@n2100.armlinux.org.uk>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 14 Aug 2017 17:56:13 +0100
Message-ID: <CAKv+Gu8SQMLM68W00UH_Vw+vwnTqSsM8v211KshuOEo06gkGww@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 02/30] ARM: assembler: introduce adr_l, ldr_l and str_l macros
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <marc.zyngier@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Tony Lindgren <tony@atomide.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Thomas Garnier <thgarnie@google.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-ID: <kernel-hardening.lists.openwall.com>

On 14 August 2017 at 17:42, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Mon, Aug 14, 2017 at 05:22:39PM +0100, Ard Biesheuvel wrote:
>> On 14 August 2017 at 17:18, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>> > On Mon, 14 Aug 2017, Dave Martin wrote:
>> >
>> >> On Mon, Aug 14, 2017 at 04:38:02PM +0100, Ard Biesheuvel wrote:
>> >> > That's a trick, actually, which I failed to add a comment for.
>> >
>> > Shame shame shame !
>> >
>> >> > We use .arm sections in the thumb2 kernel, and using these macros
>> >> > there would result in the wrong offset to be used. Adding the .w
>> >> > suffix forces an error in the assembler which even results in a fairly
>> >> > meaningful error message complaining about using .w in ARM code.
>> >>
>> >> Ewww... I think it'd be best to add a comment explaining that.
>> >
>> > Absolutely!
>> >
>>
>> Yeah, mea culpa.
>>
>> But if people have better ideas how to avoid this situation, I am all ears.
>
> Have you tested building an ARMv7M kernel with your patches - ARMv7M is
> Thumb only, so can't contain any ARM code.  If not, please try
> mps2_defconfig.
>

mps2_defconfig builds without error with these patches. I don't have
the hardware so I can't boot it, unfortunately.
