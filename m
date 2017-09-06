MIME-Version: 1.0
In-Reply-To: <20170906162222.GI5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170905164547.GA5024@atomide.com> <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
 <20170905193754.GD5024@atomide.com> <CAKv+Gu9c_j0qriRazSTmq8eD9icCu4Wuzw1z-LF7bubLVLQd7Q@mail.gmail.com>
 <20170905212742.GG5024@atomide.com> <CAKv+Gu8uZH5PFVBwEGAK1hjGMTJD1a1KN0dVUjw=M3GPsps1FQ@mail.gmail.com>
 <CAKv+Gu8qROYaQFSxChoz8cmS0S1wwqDmUvduXC_reQn1L7gFKg@mail.gmail.com> <20170906162222.GI5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 6 Sep 2017 17:25:37 +0100
Message-ID: <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 September 2017 at 17:22, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 03:41]:
>> On 5 September 2017 at 22:31, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > On 5 September 2017 at 22:27, Tony Lindgren <tony@atomide.com> wrote:
>> >> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170905 12:43]:
>> >>> Right. Well, I will try to reproduce with the BB white I have.
>> >>
>> >> Yeah that should be reproducable, I got it to happen on BBB here
>> >> after about 5 boots.
>> >>
>>
>> Unfortunately, my BB white boots happily every time.
>>
>> I have added DEBUG_UNCOMPRESS support to mach-omap2, and added some
>> debug output to the kaslr init routine
>
> OK. FYI, the DEBUG_UNCOMPRESS support works in Linux next as
> it's now using the generic 8250 debug_ll code.
>
>> For example,
>>
>> Starting kernel ...
>>
>> regions.image_size:00e00000
>> regions.pa_start:80000000
>> regions.pa_end:90000000
>> regions.zimage_start:80200000
>> regions.zimage_size:00430228
>> regions.dtb_start:82000000
>> regions.dtb_size:00009000
>> num:00000016
>> *kaslr_offset:04400000
>> Uncompressing Linux... done, booting the kernel.
>> [    0.000000] Booting Linux on physical CPU 0x0
>>  ....
>> [    0.000000] Virtual kernel memory layout:
>> [    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>> [    0.000000]     fixmap  : 0xffc00000 - 0xfff00000   (3072 kB)
>> [    0.000000]     vmalloc : 0xd0000000 - 0xff800000   ( 760 MB)
>> [    0.000000]     lowmem  : 0xc0000000 - 0xcfe00000   ( 254 MB)
>> [    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
>> [    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
>> [    0.000000]       .text : 0xc4408000 - 0xc4d00000   (9184 kB)
>> [    0.000000]       .init : 0xc5000000 - 0xc5100000   (1024 kB)
>> [    0.000000]       .data : 0xc5100000 - 0xc5149df0   ( 296 kB)
>> [    0.000000]        .bss : 0xc51cb000 - 0xc59a9a8c   (8059 kB)
>>
>> I have pushed the changes to my arm-kaslr-v3 branch. If you are
>> willing to spend more cycles on this, could you please run it with
>> DEBUG_LL enabled, and capture the output of the failed boots?
>
> Sure was not able to reproduce it so far on BBB. But here's
> failed boot output from logicpd-torpedo-37xx-devkit. Will
> try some more booting on BBB too.
>

Thanks Tony.

> 8< -------------------
> Kernel image @ 0x81000000 [ 0x000000 - 0x426810 ]
> ## Flattened Device Tree blob at 84000000
>    Booting using the fdt blob at 0x84000000
>    Loading Device Tree to 86feb000, end 86fff2d5 ... OK
>
> Starting kernel ...
>
> regions.image_size:00e00000
> regions.pa_start:80000000
> regions.pa_end:88000000
> regions.zimage_start:81000000
> regions.zimage_size:00437830
> regions.dtb_start:86feb000
> regions.dtb_size:00012000
> regions.initrd_start:00000000
> regions.initrd_size:00000000
> num:0000002f
> num:00000029
> *kaslr_offset:07400000
> Uncompressing Linux...

Is that all? Does it hang while decompressing the kernel?
