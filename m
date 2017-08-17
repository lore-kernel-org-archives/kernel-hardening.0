MIME-Version: 1.0
In-Reply-To: <CAGXu5jJprvbsa2o_Tazw3XNO1QQQw2d_XcDfzZhkDcXR9BfFew@mail.gmail.com>
References: <20170815201544.8479-1-ard.biesheuvel@linaro.org> <CAGXu5jJprvbsa2o_Tazw3XNO1QQQw2d_XcDfzZhkDcXR9BfFew@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 17 Aug 2017 20:22:28 +0100
Message-ID: <CAKv+Gu-g+0E=b1G+0mfZOHP0iEsD14VMCtJy0fXnbhwoOc-8oA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH] ARM: decompressor: implement autonomous KASLR offset calculation
To: Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>, Russell King <linux@armlinux.org.uk>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 15 August 2017 at 21:29, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Aug 15, 2017 at 1:15 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> This enables KASLR for environments that are not KASLR-aware, or only
>> to a limited extent. The decompressor collects information about the
>> placement of the zImage, DTB and initrd, and parses the /memory DT
>> node and the /memreserve/s and /reserved-memory node, and combines this
>> information to select a suitable KASLR offset, and proceeds to decompress
>> the kernel at this offset in physical memory. It then invoked the kernel
>> proper while passing on this information, so that it can be taken into
>> account to create the virtual mapping.
>>
>> This code shuffles some registers together to create a poor man's seed,
>> which will be superseded by the value of /chosen/kaslr-seed if present.
>>
[...]
>
> Without kaslr-seed, perhaps also include build-time entropy (as I did
> in x86's decompressor with build_str):
>
> static unsigned long get_boot_seed(void)
> {
>         unsigned long hash = 0;
>
>         hash = rotate_xor(hash, build_str, sizeof(build_str));
>         hash = rotate_xor(hash, boot_params, sizeof(*boot_params));
>
>         return hash;
> }
>

Shouldn't we use something with better diffusion than rotate and xor?
If we can afford to decompress ~10 MB worth of vmlinux, I'm sure we
can afford to crc() the device tree blob.

> You're effectively starting with hash == r3. This could be further
> enhanced with a __latent_entropy string when that plugin is enabled:
>
> static u8 compile_time_entropy[32] __latent_entropy;
>
> ...
>
> seed = rotate_xor(seed, compile_time_entropy, sizeof(compile_time_entropy));
>
> And toss in the fdt too? (I have no idea if this is the correct way to
> do this....)
>
> seed = rotate_xor(seed, fdt, fdt_totalsize(fdt));
>

As mentioned by several people, this is a nice way to add
/chosen/kaslr-seed to the mix if it is there, and still have some
pseudo=entropy otherwise, especially given the fact (as Daniel figured
out) that Android puts device serials and some boot timing related
variables on the kernel command line.
