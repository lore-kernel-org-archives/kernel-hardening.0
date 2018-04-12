MIME-Version: 1.0
In-Reply-To: <20180411010352.17929-1-labbott@redhat.com>
References: <20180411010352.17929-1-labbott@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 12 Apr 2018 10:38:43 +0200
Message-ID: <CACRpkdb04=5eHW3xR-qmY6UzOUcAC35mV4eDgHaFn9nQEL_eEw@mail.gmail.com>
Subject: Re: [PATCHv4] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 11, 2018 at 3:03 AM, Laura Abbott <labbott@redhat.com> wrote:

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
> ---
> v4: Changed some local variables to avoid coccinelle warnings. Added a
> warning if the number of GPIOs exceeds the current fast path define.
>
> Lukas, I kept your Tested-by because the changes were pretty minimal.
> Let me know if you want to run the tests again.

This patch is starting to look really good.

> +/*
> + * Number of GPIOs to use for the fast path in set array
> + */
> +#define FASTPATH_NGPIO 256

There is still some comment about this.

And now that I am also tryint to think I wonder about it, we
have a global ARCH_NR_GPIOS that is typically 512.
Some archs set it up.

This define is something of an abomination, in the ARM
case it comes from arch/arm/include/asm/gpio.h
where #define ARCH_NR_GPIOS CONFIG_ARCH_NR_GPIO
where the latter is a Kconfig option that is mostly 512 for
most ARM systems.

Well, ARM looks like this:

config ARCH_NR_GPIO
        int
        default 2048 if ARCH_SOCFPGA
        default 1024 if ARCH_BRCMSTB || ARCH_SHMOBILE || ARCH_TEGRA || \
                ARCH_ZYNQ
        default 512 if ARCH_EXYNOS || ARCH_KEYSTONE || SOC_OMAP5 || \
                SOC_DRA7XX || ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
        default 416 if ARCH_SUNXI
        default 392 if ARCH_U8500
        default 352 if ARCH_VT8500
        default 288 if ARCH_ROCKCHIP
        default 264 if MACH_H4700
        default 0
        help
          Maximum number of GPIOs in the system.

          If unsure, leave the default value.

So if FASTPATH_NGPIO should be anything else than
ARCH_NR_GPIO this has to be established somewhere
as a floor or half or something, but I would just set it as
the same as ARCH_NR_GPIOS...

The main reason this define exist is for this function
from <linux/gpio/consumer.h>:

/* Convert between the old gpio_ and new gpiod_ interfaces */
struct gpio_desc *gpio_to_desc(unsigned gpio);

Nowadays that fact is a bit obscured since the variable is
only used when assigning the base (in the global GPIO
number space, which is what we want to get rid of but
sigh) in gpiochip_find_base() where it attempts to place
a newly allocated gpiochip in the higher region of this
numberspace since the embedded SoC GPIO base tends
to be 0, on old platforms.

So I don't know about this.

Can't we just use ARCH_NR_GPIOS?

Very few systems have more than 512 assigned global
GPIO numbers and those are FPGA experimental machines.

In the long run obviously I want to get rid of these defines
altogether and only allocate GPIO descriptos dynamically
so as you see I am reluctant to add new numberspace weirdness
around here.

Yours,
Linus Walleij
