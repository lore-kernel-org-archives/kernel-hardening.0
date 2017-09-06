MIME-Version: 1.0
In-Reply-To: <20170906182247.GM5024@atomide.com>
References: <CAKv+Gu8uZH5PFVBwEGAK1hjGMTJD1a1KN0dVUjw=M3GPsps1FQ@mail.gmail.com>
 <CAKv+Gu8qROYaQFSxChoz8cmS0S1wwqDmUvduXC_reQn1L7gFKg@mail.gmail.com>
 <20170906162222.GI5024@atomide.com> <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
 <20170906163100.GJ5024@atomide.com> <CAKv+Gu-HGM6T6cV25bo6_bBcZaV-x3qpc9XoYUA4AEx68Joz=A@mail.gmail.com>
 <20170906171253.GK5024@atomide.com> <CAKv+Gu8ngWMvkmNr77SzL8fEvSc5K-OntoZQ53vgWVLHhAajaw@mail.gmail.com>
 <20170906175308.GL5024@atomide.com> <CAKv+Gu8qd8oz4wuEjAaR1E3ZUxt4Xr-j4NcLidRrNisVFefzCQ@mail.gmail.com>
 <20170906182247.GM5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 6 Sep 2017 19:25:14 +0100
Message-ID: <CAKv+Gu8N_cjm_5aH=kWt6EKc6sGgQoWDVmdVAVw1Ru_xz1UWEw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 September 2017 at 19:22, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 11:05]:
>> On 6 September 2017 at 18:53, Tony Lindgren <tony@atomide.com> wrote:
>> > * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 10:31]:
>> >> On 6 September 2017 at 18:12, Tony Lindgren <tony@atomide.com> wrote:
>> >> > Kernel image @ 0x81000000 [ 0x000000 - 0x426300 ]
>> >> > ## Flattened Device Tree blob at 84000000
>> >> >    Booting using the fdt blob at 0x84000000
>> >> >    Loading Device Tree to 86feb000, end 86fff2d5 ... OK
>> >> >
>> >> > Starting kernel ...
>> >> >
>> >> > regions.image_size:00e00000
>> >> > regions.pa_start:80000000
>> >> > regions.pa_end:87200000
>> >> > regions.zimage_start:81000000
>> >> > regions.zimage_size:00437320
>> >> > regions.dtb_start:86feb000
>> >> > regions.dtb_size:00012000
>> >> > regions.initrd_start:00000000
>> >> > regions.initrd_size:00000000
>> >> > num:00000028
>> >> > num:00000025
>> >> > *kaslr_offset:05e00000
>> >> > Uncompressing Linux... done, booting the kernel.
>> >> > Warning: Neither atags nor dtb found
>> >>
>> >> OK, so in this case, 80000000 + 00e00000 + 05e00000 == 86c00000, which
>> >> is still below the DTB, but apparently, it has corrupted it anyway.
>> >>
>> >> I will try to figure out what's going on here.
>> >
>> > Do you need to have kaslr_offset beyond the uncompressed
>> > kernel size maybe?
>> >
>>
>> I think the problem is in the rounding of region.pa_start.
>>
>> I have now changed this to
>>
>> regions.image_size = image_base % SZ_128M + round_up(image_size, SZ_2M);
>> regions.pa_start = round_down(image_base, SZ_128M);
> ...
>
>> I have updated my arm-kaslr-v3 with all the fixes from this discussion
>> (and more)
>
> Looks like your branch at commit 5221c86ad2e7 still failed
> after boot attempt #4, see below. Is that the right commit?
>

It should be, yes.

> 8< -----------------
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

Did you capture the image_size and pa_start/pa_end as well?

In any case, this is the exact same offset that failed before, so the
rounding of pa_start wasn't the problem.
