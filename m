MIME-Version: 1.0
In-Reply-To: <20180328181809.24505-1-labbott@redhat.com>
References: <20180328181809.24505-1-labbott@redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 30 Mar 2018 17:33:55 +0300
Message-ID: <CAHp75VdZOiJgzt3nhdeqwTXC=jsbndLWOV3eF_XmgFU-eHjYSg@mail.gmail.com>
Subject: Re: [PATCHv3] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 9:18 PM, Laura Abbott <labbott@redhat.com> wrote:
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621) to eventually
> turn on -Wvla.
>
> Using a kmalloc array is the easy way to fix this but kmalloc is still
> more expensive than stack allocation. Introduce a fast path with a
> fixed size stack array to cover most chip with gpios below some fixed
> amount. The slow path dynamically allocates an array to cover those
> chips with a large number of gpios.

> +               ret = gpiod_set_array_value_complex(false,
>                                               true,
>                                               lh->numdescs,
>                                               lh->descs,
>                                               vals);
> +               if (ret)
> +                       return ret;
> +
>                 return 0;

Can't we

return gpiod_set_array_value_complex(); ?


> +                       slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
> +                                          sizeof(*slowpath),
> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);


> +                       if (slowpath)
> +                               kfree(slowpath);

> +               if (slowpath)
> +                       kfree(slowpath);

Since slowpath is a pointer, conditionals above are redundant.

> +                       slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
> +                                          sizeof(*slowpath),
> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);

> +               if (slowpath)
> +                       kfree(slowpath);

Ditto.

-- 
With Best Regards,
Andy Shevchenko
