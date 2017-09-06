MIME-Version: 1.0
In-Reply-To: <20170906163100.GJ5024@atomide.com>
References: <20170903120757.14968-1-ard.biesheuvel@linaro.org>
 <20170905164547.GA5024@atomide.com> <CAKv+Gu_eT_eK9Tj4JvWSsK+iW9juGG6xYDO15umu6jBkoun8ew@mail.gmail.com>
 <20170905193754.GD5024@atomide.com> <CAKv+Gu9c_j0qriRazSTmq8eD9icCu4Wuzw1z-LF7bubLVLQd7Q@mail.gmail.com>
 <20170905212742.GG5024@atomide.com> <CAKv+Gu8uZH5PFVBwEGAK1hjGMTJD1a1KN0dVUjw=M3GPsps1FQ@mail.gmail.com>
 <CAKv+Gu8qROYaQFSxChoz8cmS0S1wwqDmUvduXC_reQn1L7gFKg@mail.gmail.com>
 <20170906162222.GI5024@atomide.com> <CAKv+Gu__-WeHKDGwg4rNM9Dw8V471wNQX=J3mfz_AUKHVUza_g@mail.gmail.com>
 <20170906163100.GJ5024@atomide.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 6 Sep 2017 17:35:36 +0100
Message-ID: <CAKv+Gu-HGM6T6cV25bo6_bBcZaV-x3qpc9XoYUA4AEx68Joz=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 00/29] implement KASLR for ARM
To: Tony Lindgren <tony@atomide.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dave Martin <dave.martin@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 6 September 2017 at 17:31, Tony Lindgren <tony@atomide.com> wrote:
> * Ard Biesheuvel <ard.biesheuvel@linaro.org> [170906 09:26]:
>> On 6 September 2017 at 17:22, Tony Lindgren <tony@atomide.com> wrote:
>> > Sure was not able to reproduce it so far on BBB. But here's
>> > failed boot output from logicpd-torpedo-37xx-devkit. Will
>> > try some more booting on BBB too.
> ...
>> > 8< -------------------
>> > Kernel image @ 0x81000000 [ 0x000000 - 0x426810 ]
>> > ## Flattened Device Tree blob at 84000000
>> >    Booting using the fdt blob at 0x84000000
>> >    Loading Device Tree to 86feb000, end 86fff2d5 ... OK
>> >
>> > Starting kernel ...
>> >
>> > regions.image_size:00e00000
>> > regions.pa_start:80000000
>> > regions.pa_end:88000000
>> > regions.zimage_start:81000000
>> > regions.zimage_size:00437830
>> > regions.dtb_start:86feb000
>> > regions.dtb_size:00012000
>> > regions.initrd_start:00000000
>> > regions.initrd_size:00000000
>> > num:0000002f
>> > num:00000029
>> > *kaslr_offset:07400000
>> > Uncompressing Linux...
>>
>> Is that all? Does it hang while decompressing the kernel?
>
> Yeah so it seems. If we had uncompress overwriting something
> because of the increase in size it should happen on every
> boot though, not once every five boots or so.
>

Turns out I am calculating the top of DRAM incorrectly for boards
where less memory is present than the size of the lowmem region.

Could you try this please? (Apologies for the whitespace)

diff --git a/arch/arm/boot/compressed/kaslr.c b/arch/arm/boot/compressed/kaslr.c
index d43c0be9b47b..e9c86809c857 100644
--- a/arch/arm/boot/compressed/kaslr.c
+++ b/arch/arm/boot/compressed/kaslr.c
@@ -339,8 +339,7 @@ u32 kaslr_early_init(u32 *kaslr_offset, u32
image_base, u32 image_size,

        regions.image_size = round_up(image_size, SZ_2M);
        regions.pa_start = round_down(image_base, SZ_128M);
-       regions.pa_end = lowmem_top - PAGE_OFFSET + regions.pa_start -
-                        regions.image_size;
+       regions.pa_end = lowmem_top - PAGE_OFFSET + regions.pa_start;
        regions.zimage_start = zimage_start;
        regions.zimage_size = zimage_end - zimage_start;
        regions.dtb_start = (u32)fdt;
@@ -391,7 +390,8 @@ u32 kaslr_early_init(u32 *kaslr_offset, u32
image_base, u32 image_size,
        }

        /* check the memory nodes for the size of the lowmem region */
-       regions.pa_end = min(regions.pa_end, get_memory_end(fdt));
+       regions.pa_end = min(regions.pa_end, get_memory_end(fdt)) -
+                        regions.image_size;

        puthex32(regions.image_size);
        puthex32(regions.pa_start);
