MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20180517223222.8468-1-labbott@redhat.com>
References: <20180517223222.8468-1-labbott@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 18 May 2018 08:51:09 +0200
Message-ID: <CAMuHMdU_66+NPYQpMSLhs533YVQZnDMTUMw4vZ9rJAvkHSRkNA@mail.gmail.com>
Subject: Re: [PATCHv7] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Fri, May 18, 2018 at 12:32 AM, Laura Abbott <labbott@redhat.com> wrote:
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
> Reviewed-by: Phil Reid <preid@electromag.com.au>
> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v7: Tweaked the Kconfig text to clarify the wording. Also fixed a few
> other comments from Geert, including the earlier suggestion to reduce
> the zeroing since I was wrong about that.

Thanks for the update!

With the minor nit below resolved:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -22,6 +22,18 @@ menuconfig GPIOLIB
>
>  if GPIOLIB
>
> +config GPIOLIB_FASTPATH_LIMIT
> +       int "Maximum number of GPIOs for fast path"
> +       range 16 512

While you can indeed fit 2 * 16 bits in a long, a lower limit of 16 doesn't
make much sense, as you will use 2 longs (mask + bits) anyway.
So please increase it to 32.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
