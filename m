MIME-Version: 1.0
In-Reply-To: <20180521175707.6653-1-labbott@redhat.com>
References: <20180521175707.6653-1-labbott@redhat.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 21 May 2018 23:34:26 +0300
Message-ID: <CAHp75VcQNS694ZD1iQpMSNruNU=vT_p+SXcepC_noRW8TKUzcA@mail.gmail.com>
Subject: Re: [PATCHv9] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>, Geert Uytterhoeven <geert@linux-m68k.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 21, 2018 at 8:57 PM, Laura Abbott <labbott@redhat.com> wrote:
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

LGTM

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Phil Reid <preid@electromag.com.au>
> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v9: switch to bitmap_zero
> ---
>  drivers/gpio/Kconfig          | 12 ++++++
>  drivers/gpio/gpiolib.c        | 76 +++++++++++++++++++++++++++--------
>  drivers/gpio/gpiolib.h        |  2 +-
>  include/linux/gpio/consumer.h | 10 +++--
>  4 files changed, 78 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index b960f6f35abd..71c0ab46f216 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -22,6 +22,18 @@ menuconfig GPIOLIB
>
>  if GPIOLIB
>
> +config GPIOLIB_FASTPATH_LIMIT
> +       int "Maximum number of GPIOs for fast path"
> +       range 32 512
> +       default 512
> +       help
> +          This adjusts the point at which certain APIs will switch from
> +          using a stack allocated buffer to a dynamically allocated buffer.
> +
> +          You shouldn't need to change this unless you really need to
> +          optimize either stack space or performance. Change this carefully
> +          since setting an incorrect value could cause stack corruption.
> +
>  config OF_GPIO
>         def_bool y
>         depends on OF
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index d8ccb500872f..982f19d62496 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -61,6 +61,11 @@ static struct bus_type gpio_bus_type = {
>         .name = "gpio",
>  };
>
> +/*
> + * Number of GPIOs to use for the fast path in set array
> + */
> +#define FASTPATH_NGPIO CONFIG_GPIOLIB_FASTPATH_LIMIT
> +
>  /* gpio_lock prevents conflicts during gpio_desc[] table updates.
>   * While any GPIO is requested, its gpio_chip is not removable;
>   * each GPIO's "requested" flag serves as a lock and refcount.
> @@ -450,12 +455,11 @@ static long linehandle_ioctl(struct file *filep, unsigned int cmd,
>                         vals[i] = !!ghd.values[i];
>
>                 /* Reuse the array setting function */
> -               gpiod_set_array_value_complex(false,
> +               return gpiod_set_array_value_complex(false,
>                                               true,
>                                               lh->numdescs,
>                                               lh->descs,
>                                               vals);
> -               return 0;
>         }
>         return -EINVAL;
>  }
> @@ -1244,6 +1248,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
>                 goto err_free_descs;
>         }
>
> +       if (chip->ngpio > FASTPATH_NGPIO)
> +               chip_warn(chip, "line cnt %u is greater than fast path cnt %u\n",
> +               chip->ngpio, FASTPATH_NGPIO);
> +
>         gdev->label = kstrdup_const(chip->label ?: "unknown", GFP_KERNEL);
>         if (!gdev->label) {
>                 status = -ENOMEM;
> @@ -2719,16 +2727,28 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
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
> +                       mask = fastpath;
> +               } else {
> +                       mask = kmalloc_array(2 * BITS_TO_LONGS(chip->ngpio),
> +                                          sizeof(*mask),
> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> +                       if (!mask)
> +                               return -ENOMEM;
> +               }
> +
> +               bits = mask + BITS_TO_LONGS(chip->ngpio);
> +               bitmap_zero(mask, chip->ngpio);
> +
>                 if (!can_sleep)
>                         WARN_ON(chip->can_sleep);
>
>                 /* collect all inputs belonging to the same chip */
>                 first = i;
> -               memset(mask, 0, sizeof(mask));
>                 do {
>                         const struct gpio_desc *desc = desc_array[i];
>                         int hwgpio = gpio_chip_hwgpio(desc);
> @@ -2739,8 +2759,11 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>                          (desc_array[i]->gdev->chip == chip));
>
>                 ret = gpio_chip_get_multiple(chip, mask, bits);
> -               if (ret)
> +               if (ret) {
> +                       if (mask != fastpath)
> +                               kfree(mask);
>                         return ret;
> +               }
>
>                 for (j = first; j < i; j++) {
>                         const struct gpio_desc *desc = desc_array[j];
> @@ -2752,6 +2775,9 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>                         value_array[j] = value;
>                         trace_gpio_value(desc_to_gpio(desc), 1, value);
>                 }
> +
> +               if (mask != fastpath)
> +                       kfree(mask);
>         }
>         return 0;
>  }
> @@ -2935,7 +2961,7 @@ static void gpio_chip_set_multiple(struct gpio_chip *chip,
>         }
>  }
>
> -void gpiod_set_array_value_complex(bool raw, bool can_sleep,
> +int gpiod_set_array_value_complex(bool raw, bool can_sleep,
>                                    unsigned int array_size,
>                                    struct gpio_desc **desc_array,
>                                    int *value_array)
> @@ -2944,14 +2970,26 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>
>         while (i < array_size) {
>                 struct gpio_chip *chip = desc_array[i]->gdev->chip;
> -               unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
> -               unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
> +               unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
> +               unsigned long *mask, *bits;
>                 int count = 0;
>
> +               if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
> +                       mask = fastpath;
> +               } else {
> +                       mask = kmalloc_array(2 * BITS_TO_LONGS(chip->ngpio),
> +                                          sizeof(*mask),
> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> +                       if (!mask)
> +                               return -ENOMEM;
> +               }
> +
> +               bits = mask + BITS_TO_LONGS(chip->ngpio);
> +               bitmap_zero(mask, chip->ngpio);
> +
>                 if (!can_sleep)
>                         WARN_ON(chip->can_sleep);
>
> -               memset(mask, 0, sizeof(mask));
>                 do {
>                         struct gpio_desc *desc = desc_array[i];
>                         int hwgpio = gpio_chip_hwgpio(desc);
> @@ -2982,7 +3020,11 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>                 /* push collected bits to outputs */
>                 if (count != 0)
>                         gpio_chip_set_multiple(chip, mask, bits);
> +
> +               if (mask != fastpath)
> +                       kfree(mask);
>         }
> +       return 0;
>  }
>
>  /**
> @@ -3057,13 +3099,13 @@ EXPORT_SYMBOL_GPL(gpiod_set_value);
>   * This function should be called from contexts where we cannot sleep, and will
>   * complain if the GPIO chip functions potentially sleep.
>   */
> -void gpiod_set_raw_array_value(unsigned int array_size,
> +int gpiod_set_raw_array_value(unsigned int array_size,
>                          struct gpio_desc **desc_array, int *value_array)
>  {
>         if (!desc_array)
> -               return;
> -       gpiod_set_array_value_complex(true, false, array_size, desc_array,
> -                                     value_array);
> +               return -EINVAL;
> +       return gpiod_set_array_value_complex(true, false, array_size,
> +                                       desc_array, value_array);
>  }
>  EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value);
>
> @@ -3383,14 +3425,14 @@ EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
>   *
>   * This function is to be called from contexts that can sleep.
>   */
> -void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
> +int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>                                         struct gpio_desc **desc_array,
>                                         int *value_array)
>  {
>         might_sleep_if(extra_checks);
>         if (!desc_array)
> -               return;
> -       gpiod_set_array_value_complex(true, true, array_size, desc_array,
> +               return -EINVAL;
> +       return gpiod_set_array_value_complex(true, true, array_size, desc_array,
>                                       value_array);
>  }
>  EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value_cansleep);
> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
> index ad456b6f9d8b..1a8e20363861 100644
> --- a/drivers/gpio/gpiolib.h
> +++ b/drivers/gpio/gpiolib.h
> @@ -188,7 +188,7 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>                                   unsigned int array_size,
>                                   struct gpio_desc **desc_array,
>                                   int *value_array);
> -void gpiod_set_array_value_complex(bool raw, bool can_sleep,
> +int gpiod_set_array_value_complex(bool raw, bool can_sleep,
>                                    unsigned int array_size,
>                                    struct gpio_desc **desc_array,
>                                    int *value_array);
> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
> index dbd065963296..243112c7fa7d 100644
> --- a/include/linux/gpio/consumer.h
> +++ b/include/linux/gpio/consumer.h
> @@ -116,7 +116,7 @@ int gpiod_get_raw_array_value(unsigned int array_size,
>                               struct gpio_desc **desc_array,
>                               int *value_array);
>  void gpiod_set_raw_value(struct gpio_desc *desc, int value);
> -void gpiod_set_raw_array_value(unsigned int array_size,
> +int gpiod_set_raw_array_value(unsigned int array_size,
>                                struct gpio_desc **desc_array,
>                                int *value_array);
>
> @@ -134,7 +134,7 @@ int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
>                                        struct gpio_desc **desc_array,
>                                        int *value_array);
>  void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
> -void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
> +int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>                                         struct gpio_desc **desc_array,
>                                         int *value_array);
>
> @@ -369,12 +369,13 @@ static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
>         /* GPIO can never have been requested */
>         WARN_ON(1);
>  }
> -static inline void gpiod_set_raw_array_value(unsigned int array_size,
> +static inline int gpiod_set_raw_array_value(unsigned int array_size,
>                                              struct gpio_desc **desc_array,
>                                              int *value_array)
>  {
>         /* GPIO can never have been requested */
>         WARN_ON(1);
> +       return 0;
>  }
>
>  static inline int gpiod_get_value_cansleep(const struct gpio_desc *desc)
> @@ -423,12 +424,13 @@ static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
>         /* GPIO can never have been requested */
>         WARN_ON(1);
>  }
> -static inline void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
> +static inline int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>                                                 struct gpio_desc **desc_array,
>                                                 int *value_array)
>  {
>         /* GPIO can never have been requested */
>         WARN_ON(1);
> +       return 0;
>  }
>
>  static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
> --
> 2.17.0
>



-- 
With Best Regards,
Andy Shevchenko
