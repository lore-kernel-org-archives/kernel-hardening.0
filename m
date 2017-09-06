Date: Wed, 6 Sep 2017 13:08:05 -0700
From: Tony Lindgren <tony@atomide.com>
Message-ID: <20170906200805.GN5024@atomide.com>
References: <20170906162222.GI5024@atomide.com>
 <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
 <20170906163100.GJ5024@atomide.com>
 <CAKv+Gu-HGM6T6cV25bo6_bBcZaV-x3qpc9XoYUA4AEx68Joz=A@mail.gmail.com>
 <20170906171253.GK5024@atomide.com>
 <CAKv+Gu8ngWMvkmNr77SzL8fEvSc5K-OntoZQ53vgWVLHhAajaw@mail.gmail.com>
 <20170906175308.GL5024@atomide.com>
 <CAKv+Gu8qd8oz4wuEjAaR1E3ZUxt4Xr-j4NcLidRrNisVFefzCQ@mail.gmail.com>
 <20170906182247.GM5024@atomide.com>
 <CAKv+Gu8N_cjm_5aH=kWt6EKc6sGgQoWDVmdVAVw1Ru_xz1UWEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8N_cjm_5aH=kWt6EKc6sGgQoWDVmdVAVw1Ru_xz1UWEw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 11:25]:
> Did you capture the image_size and pa_start/pa_end as well?

Sorry I guess that was an incomplete copy & paste, but here's
another one:

regions.image_size:00e08000
regions.pa_start:80000000
regions.pa_end:871f8000
regions.zimage_start:81000000
regions.zimage_size:004379e8
regions.dtb_start:86feb000
regions.dtb_size:00012000
regions.initrd_start:00000000
regions.initrd_size:00000000
count:00000028
num:00000025
*kaslr_offset:05e00000
Uncompressing Linux... done, booting the kernel.
Warning: Neither atags nor dtb found

> In any case, this is the exact same offset that failed before, so the
> rounding of pa_start wasn't the problem.

OK

Regards,

Tony
