MIME-Version: 1.0
In-Reply-To: <20170906200805.GN5024@atomide.com>
References: <20170906162222.GI5024@atomide.com> <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
 <20170906163100.GJ5024@atomide.com> <CAKv+Gu-HGM6T6cV25bo6_bBcZaV-x3qpc9XoYUA4AEx68Joz=A@mail.gmail.com>
 <20170906171253.GK5024@atomide.com> <CAKv+Gu8ngWMvkmNr77SzL8fEvSc5K-OntoZQ53vgWVLHhAajaw@mail.gmail.com>
 <20170906175308.GL5024@atomide.com> <CAKv+Gu8qd8oz4wuEjAaR1E3ZUxt4Xr-j4NcLidRrNisVFefzCQ@mail.gmail.com>
 <20170906182247.GM5024@atomide.com> <CAKv+Gu8N_cjm_5aH=kWt6EKc6sGgQoWDVmdVAVw1Ru_xz1UWEw@mail.gmail.com>
 <20170906200805.GN5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 12 Sep 2017 07:51:06 +0100
Message-ID: <CAKv+Gu8mT_2+Rom627pZZ0x=KU=ddR8nobWgfWVNtvxC1BgZvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 September 2017 at 21:08, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 11:25]:
>> Did you capture the image_size and pa_start/pa_end as well?
>
> Sorry I guess that was an incomplete copy & paste, but here's
> another one:
>
> regions.image_size:00e08000
> regions.pa_start:80000000
> regions.pa_end:871f8000
> regions.zimage_start:81000000
> regions.zimage_size:004379e8
> regions.dtb_start:86feb000
> regions.dtb_size:00012000
> regions.initrd_start:00000000
> regions.initrd_size:00000000
> count:00000028
> num:00000025
> *kaslr_offset:05e00000
> Uncompressing Linux... done, booting the kernel.
> Warning: Neither atags nor dtb found
>
>> In any case, this is the exact same offset that failed before, so the
>> rounding of pa_start wasn't the problem.
>
> OK
>

I am pretty sure this is an issue with .bss, which is not covered by
image_size (and which is absolutely *huge* btw [8+ MB] on
omap2plus_defconfig, due to lockdep being enabled by default)
