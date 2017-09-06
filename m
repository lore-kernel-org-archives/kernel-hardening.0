Date: Wed, 6 Sep 2017 09:31:01 -0700
From: Tony Lindgren <tony@atomide.com>
Message-ID: <20170906163100.GJ5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170905164547.GA5024@atomide.com>
 <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
 <20170905193754.GD5024@atomide.com>
 <CAKv+Gu9c_j0qriRazSTmq8eD9icCu4Wuzw1z-LF7bubLVLQd7Q@mail.gmail.com>
 <20170905212742.GG5024@atomide.com>
 <CAKv+Gu8uZH5PFVBwEGAK1hjGMTJD1a1KN0dVUjw=M3GPsps1FQ@mail.gmail.com>
 <CAKv+Gu8qROYaQFSxChoz8cmS0S1wwqDmUvduXC_reQn1L7gFKg@mail.gmail.com>
 <20170906162222.GI5024@atomide.com>
 <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

* Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 09:26]:
> On 6 September 2017 at 17:22, Tony Lindgren <tony@atomide.com> wrote:
> > Sure was not able to reproduce it so far on BBB. But here's
> > failed boot output from logicpd-torpedo-37xx-devkit. Will
> > try some more booting on BBB too.
...
> > 8< -------------------
> > Kernel image @ 0x81000000 [ 0x000000 - 0x426810 ]
> > ## Flattened Device Tree blob at 84000000
> >    Booting using the fdt blob at 0x84000000
> >    Loading Device Tree to 86feb000, end 86fff2d5 ... OK
> >
> > Starting kernel ...
> >
> > regions.image_size:00e00000
> > regions.pa_start:80000000
> > regions.pa_end:88000000
> > regions.zimage_start:81000000
> > regions.zimage_size:00437830
> > regions.dtb_start:86feb000
> > regions.dtb_size:00012000
> > regions.initrd_start:00000000
> > regions.initrd_size:00000000
> > num:0000002f
> > num:00000029
> > *kaslr_offset:07400000
> > Uncompressing Linux...
> 
> Is that all? Does it hang while decompressing the kernel?

Yeah so it seems. If we had uncompress overwriting something
because of the increase in size it should happen on every
boot though, not once every five boots or so.

Regards,

TOny
