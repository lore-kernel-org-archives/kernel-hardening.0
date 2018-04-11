Date: Wed, 11 Apr 2018 17:03:00 +0200
From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCHv4] gpio: Remove VLA from gpiolib
Message-ID: <20180411150300.GA32719@wunner.de>
References: <20180411010352.17929-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180411010352.17929-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 10, 2018 at 06:03:52PM -0700, Laura Abbott wrote:
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -61,6 +61,11 @@ static struct bus_type gpio_bus_type = {
>  	.name = "gpio",
>  };
>  
> +/*
> + * Number of GPIOs to use for the fast path in set array
> + */
> +#define FASTPATH_NGPIO 256

Hm, this has regressed from 384 back to 256 since v3.


> @@ -2653,6 +2661,7 @@ static int gpio_chip_get_multiple(struct gpio_chip *chip,
>  	return -EIO;
>  }
>  
> +
>  int gpiod_get_array_value_complex(bool raw, bool can_sleep,

Spurious newline.  (In v3 this was the place where FASTPATH_NGPIO was
defined, this is a leftover from when you moved it further up.)

I've given this another quick test with gpio-hammer and it worked fine,
so this is still
Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>

Thanks a lot!

Lukas
