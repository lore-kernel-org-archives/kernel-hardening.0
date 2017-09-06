MIME-Version: 1.0
In-Reply-To: <20170906171253.GK5024@atomide.com>
References: <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
 <20170905193754.GD5024@atomide.com> <CAKv+Gu9c_j0qriRazSTmq8eD9icCu4Wuzw1z-LF7bubLVLQd7Q@mail.gmail.com>
 <20170905212742.GG5024@atomide.com> <CAKv+Gu8uZH5PFVBwEGAK1hjGMTJD1a1KN0dVUjw=M3GPsps1FQ@mail.gmail.com>
 <CAKv+Gu8qROYaQFSxChoz8cmS0S1wwqDmUvduXC_reQn1L7gFKg@mail.gmail.com>
 <20170906162222.GI5024@atomide.com> <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
 <20170906163100.GJ5024@atomide.com> <CAKv+Gu-HGM6T6cV25bo6_bBcZaV-x3qpc9XoYUA4AEx68Joz=A@mail.gmail.com>
 <20170906171253.GK5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 6 Sep 2017 18:30:55 +0100
Message-ID: <CAKv+Gu8ngWMvkmNr77SzL8fEvSc5K-OntoZQ53vgWVLHhAajaw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 September 2017 at 18:12, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 09:36]:
>> Turns out I am calculating the top of DRAM incorrectly for boards
>> where less memory is present than the size of the lowmem region.
>>
>> Could you try this please? (Apologies for the whitespace)
>
> I think for 10 or so units per year you can actually buy
> a non-mangling outgoing SMTP service if nothing else helps..
>

Yeah, you're right, apologies. I use git-send-email mostly, but not
for inline snippets like this. And it is not actually the SMTP service
but the web client that mangles the whitespace

> Anyways, you patch manually applied fixed most of the random
> boot hangs for me, but I did see a new one after 11 boot
> attempts, see below.
>
> Regards,
>
> Tony
>
> 8< --------------
> Kernel image @ 0x81000000 [ 0x000000 - 0x426300 ]
> ## Flattened Device Tree blob at 84000000
>    Booting using the fdt blob at 0x84000000
>    Loading Device Tree to 86feb000, end 86fff2d5 ... OK
>
> Starting kernel ...
>
> regions.image_size:00e00000
> regions.pa_start:80000000
> regions.pa_end:87200000
> regions.zimage_start:81000000
> regions.zimage_size:00437320
> regions.dtb_start:86feb000
> regions.dtb_size:00012000
> regions.initrd_start:00000000
> regions.initrd_size:00000000
> num:00000028
> num:00000025
> *kaslr_offset:05e00000
> Uncompressing Linux... done, booting the kernel.
> Warning: Neither atags nor dtb found

OK, so in this case, 80000000 + 00e00000 + 05e00000 == 86c00000, which
is still below the DTB, but apparently, it has corrupted it anyway.

I will try to figure out what's going on here.

Thanks again for taking the time,
Ard.
