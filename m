MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20180310001021.6437-4-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com> <20180310001021.6437-4-labbott@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 28 Mar 2018 09:27:22 +0200
Message-ID: <CAMuHMdUfGp_rn_fMWdOfWxPvyE1Y9oemm2piXszFTvBi9sQ5Eg@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
>
> This patch replaces a VLA with an appropriate call to kmalloc_array.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Thanks for your patch!

> --- a/drivers/gpio/gpio-xra1403.c
> +++ b/drivers/gpio/gpio-xra1403.c
> @@ -126,11 +126,16 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  {
>         int reg;
>         struct xra1403 *xra = gpiochip_get_data(chip);
> -       int value[xra1403_regmap_cfg.max_register];

Apparently xra1403_regmap_cfg.max_register is always 0x15?

What about adding

        #define XRA_LAST 15

at the top, and replacing both "XRA_IFR | 0x01" and
xra1403_regmap_cfg.max_register by XRA_LAST instead?
That would avoid doing yet another memory allocation over and over.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
