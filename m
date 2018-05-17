MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20180517000027.26639-1-labbott@redhat.com>
References: <20180517000027.26639-1-labbott@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 17 May 2018 09:58:26 +0200
Message-ID: <CAMuHMdXiopVBM+N+wYMY6JP7_sOJ2nncNkhpFq+aMc0pdfPtrQ@mail.gmail.com>
Subject: Re: [PATCHv6] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Thu, May 17, 2018 at 2:00 AM, Laura Abbott <labbott@redhat.com> wrote:
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621) to eventually
> turn on -Wvla.
>
> Using a kmalloc array is the easy way to fix this but kmalloc is still
> more expensive than stack allocation. Introduce a fast path with a
> fixed size stack array to cover most chip with gpios below some fixed
> amount. The slow path dynamically allocates an array to cover those
> chips with a large number of gpios.
>
> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Thanks for your patch!

> Also to other points: I don't think the warning should be triggerable
> from userspace, it should only happen on probe. I also think only
> memsetting half the array is more likely to be error prone. We can
> change it if there is significant overhead.

With the default of 512, that's a memset of 128 bytes. Not so insignificant
on embedded 32 bit.

> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -22,6 +22,16 @@ menuconfig GPIOLIB
>
>  if GPIOLIB
>
> +config GPIOLIB_FASTPATH_LIMIT
> +       int "Maximum number of GPIOs for fast path"
> +       default 512

I think you need a range here.  Else someone will pick a too large value,
causing stack overflow.

512 (128 bytes for each recursion level) sounds like a safe maximum to me.

> +       help
> +          This adjusts the point at which certain APIs will switch from
> +          using a statically allocated fixed size buffer to a dynamically

The fast path doesn't use a statically allocated buffer (it cannot, due to
recursion), but a buffer on the stack. I think you need to make that very
clear in the help text, as this has the potential of causing random crashes.

> +          allocated buffer. This is a trade-off in stackspace vs. speed.
> +          You shouldn't need to change this unless you really need to
> +          optimize one of those two.

> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c

> @@ -1192,6 +1196,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
>                 goto err_free_descs;
>         }
>
> +       if (chip->ngpio > FASTPATH_NGPIO)
> +               chip_warn(chip, "line cnt %d is greater than fast path cnt %d\n",

%u (twice)

> +               chip->ngpio, FASTPATH_NGPIO);
> +
>         gdev->label = kstrdup_const(chip->label ?: "unknown", GFP_KERNEL);
>         if (!gdev->label) {
>                 status = -ENOMEM;
> @@ -2662,16 +2670,28 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>
>         while (i < array_size) {
>                 struct gpio_chip *chip = desc_array[i]->gdev->chip;
> -               unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
> -               unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
> +               unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
> +               unsigned long *mask, *bits;
>                 int first, j, ret;
>
> +               if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
> +                       memset(fastpath, 0, sizeof(fastpath));
> +                       mask = fastpath;
> +                       bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
> +               } else {
> +                       mask = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
> +                                          sizeof(*mask),
> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> +                       if (!mask)
> +                               return -ENOMEM;
> +                       bits = mask + BITS_TO_LONGS(chip->ngpio);
> +               }

The assignment to bits could be made common, and moved out of the if/else.

Likewise for the memset, which means you would usually clear a single word
again, instead of 128 bytes (or more).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
