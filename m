Subject: Re: [PATCHv5] gpio: Remove VLA from gpiolib
From: Phil Reid <preid@electromag.com.au>
References: <20180413212427.18261-1-labbott@redhat.com>
 <b325f426-b491-4f95-f89d-1189f91d97f5@electromag.com.au>
 <9ddf5ebe-3bc1-2ddd-c36e-79d8ee1034e0@electromag.com.au>
Message-ID: <2e6fd701-45db-3374-b673-446e4d94241c@electromag.com.au>
Date: Mon, 16 Apr 2018 13:31:25 +0800
MIME-Version: 1.0
In-Reply-To: <9ddf5ebe-3bc1-2ddd-c36e-79d8ee1034e0@electromag.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 16/04/2018 13:19, Phil Reid wrote:
> G'day Laura,
> 
> One more comment.
> On 16/04/2018 12:41, Phil Reid wrote:
>> G'day Laura,
>>
>> On 14/04/2018 05:24, Laura Abbott wrote:
>>> The new challenge is to remove VLAs from the kernel
>>> (see https://lkml.org/lkml/2018/3/7/621) to eventually
>>> turn on -Wvla.
>>>
>>> Using a kmalloc array is the easy way to fix this but kmalloc is still
>>> more expensive than stack allocation. Introduce a fast path with a
>>> fixed size stack array to cover most chip with gpios below some fixed
>>> amount. The slow path dynamically allocates an array to cover those
>>> chips with a large number of gpios.
>>>
>>> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
>>> Signed-off-by: Lukas Wunner <lukas@wunner.de>
>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>> ---
>>> v5: Dropped some outdated comments and extra whitespace. Switched to
>>> ARCH_NR_GPIOS per suggestion of Linus Walleij.
>>> ---
>>>   drivers/gpio/gpiolib.c        | 76 +++++++++++++++++++++++++++++++++----------
>>>   drivers/gpio/gpiolib.h        |  2 +-
>>>   include/linux/gpio/consumer.h | 10 +++---
>>>   3 files changed, 66 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>>> index d66de67ef307..79ec7a29b684 100644
>>> --- a/drivers/gpio/gpiolib.c
>>> +++ b/drivers/gpio/gpiolib.c
>>> @@ -61,6 +61,11 @@ static struct bus_type gpio_bus_type = {
>>>       .name = "gpio",
>>>   };
>>> +/*
>>> + * Number of GPIOs to use for the fast path in set array
>>> + */
>>> +#define FASTPATH_NGPIO ARCH_NR_GPIOS
> 
> Also wouldn't this mean that fast path will never be triggered now...
Just to be clearer. That this will always be true. (chip->ngpio <= FASTPATH_NGPIO)
> 
> 
>>> +
>>>   /* gpio_lock prevents conflicts during gpio_desc[] table updates.
>>>    * While any GPIO is requested, its gpio_chip is not removable;
>>>    * each GPIO's "requested" flag serves as a lock and refcount.
>>> @@ -399,12 +404,11 @@ static long linehandle_ioctl(struct file *filep, unsigned int cmd,
>>>               vals[i] = !!ghd.values[i];
>>>           /* Reuse the array setting function */
>>> -        gpiod_set_array_value_complex(false,
>>> +        return gpiod_set_array_value_complex(false,
>>>                             true,
>>>                             lh->numdescs,
>>>                             lh->descs,
>>>                             vals);
>>> -        return 0;
>>>       }
>>>       return -EINVAL;
>>>   }
>>> @@ -1192,6 +1196,10 @@ int gpiochip_add_data_with_key(struct gpio_chip *chip, void *data,
>>>           goto err_free_descs;
>>>       }
>>> +    if (chip->ngpio > FASTPATH_NGPIO)
>>> +        chip_warn(chip, "line cnt %d is greater than fast path cnt %d\n",
>>> +        chip->ngpio, FASTPATH_NGPIO);
>>> +
>>>       gdev->label = kstrdup_const(chip->label ?: "unknown", GFP_KERNEL);
>>>       if (!gdev->label) {
>>>           status = -ENOMEM;
>>> @@ -2662,16 +2670,28 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>>>       while (i < array_size) {
>>>           struct gpio_chip *chip = desc_array[i]->gdev->chip;
>>> -        unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
>>> -        unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
>>> +        unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
>>> +        unsigned long *mask, *bits;
>>>           int first, j, ret;
>>> +        if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
>>> +            memset(fastpath, 0, sizeof(fastpath));
>>> +            mask = fastpath;
>>> +            bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
>> Previously it looks like just mask was zeroed.
>> So could this just be:
>>    memset(mask, 0, BITS_TO_LONGS(chip->ngpio));
>>
>> I'm guessing it's not a huge additional overhead as it is, but it's more in line with what was there.
>>
>>
>>> +        } else {
>>> +            mask = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
>>> +                       sizeof(*mask),
>>> +                       can_sleep ? GFP_KERNEL : GFP_ATOMIC);
>>> +            if (!mask)
>>> +                return -ENOMEM;
>>> +            bits = mask + BITS_TO_LONGS(chip->ngpio);
>>> +        }
>>> +
>>>           if (!can_sleep)
>>>               WARN_ON(chip->can_sleep);
>>>           /* collect all inputs belonging to the same chip */
>>>           first = i;
>>> -        memset(mask, 0, sizeof(mask));
>>>           do {
>>>               const struct gpio_desc *desc = desc_array[i];
>>>               int hwgpio = gpio_chip_hwgpio(desc);
>>> @@ -2682,8 +2702,11 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>>>                (desc_array[i]->gdev->chip == chip));
>>>           ret = gpio_chip_get_multiple(chip, mask, bits);
>>> -        if (ret)
>>> +        if (ret) {
>>> +            if (mask != fastpath)
>>> +                kfree(mask);
>>>               return ret;
>>> +        }
>>>           for (j = first; j < i; j++) {
>>>               const struct gpio_desc *desc = desc_array[j];
>>> @@ -2695,6 +2718,9 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>>>               value_array[j] = value;
>>>               trace_gpio_value(desc_to_gpio(desc), 1, value);
>>>           }
>>> +
>>> +        if (mask != fastpath)
>>> +            kfree(mask);
>>>       }
>>>       return 0;
>>>   }
>>> @@ -2878,7 +2904,7 @@ static void gpio_chip_set_multiple(struct gpio_chip *chip,
>>>       }
>>>   }
>>> -void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>> +int gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>>                      unsigned int array_size,
>>>                      struct gpio_desc **desc_array,
>>>                      int *value_array)
>>> @@ -2887,14 +2913,26 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>>       while (i < array_size) {
>>>           struct gpio_chip *chip = desc_array[i]->gdev->chip;
>>> -        unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
>>> -        unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
>>> +        unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
>>> +        unsigned long *mask, *bits;
>>>           int count = 0;
>>> +        if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
>>> +            memset(fastpath, 0, sizeof(fastpath));
>>> +            mask = fastpath;
>>> +            bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
>>> +        } else {
>>> +            mask = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
>>> +                       sizeof(*mask),
>>> +                       can_sleep ? GFP_KERNEL : GFP_ATOMIC);
>>> +            if (!mask)
>>> +                return -ENOMEM;
>>> +            bits = mask + BITS_TO_LONGS(chip->ngpio);
>>> +        }
>>> +
>>>           if (!can_sleep)
>>>               WARN_ON(chip->can_sleep);
>>> -        memset(mask, 0, sizeof(mask));
>>>           do {
>>>               struct gpio_desc *desc = desc_array[i];
>>>               int hwgpio = gpio_chip_hwgpio(desc);
>>> @@ -2925,7 +2963,11 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>>           /* push collected bits to outputs */
>>>           if (count != 0)
>>>               gpio_chip_set_multiple(chip, mask, bits);
>>> +
>>> +        if (mask != fastpath)
>>> +            kfree(mask);
>>>       }
>>> +    return 0;
>>>   }
>>>   /**
>>> @@ -3000,13 +3042,13 @@ EXPORT_SYMBOL_GPL(gpiod_set_value);
>>>    * This function should be called from contexts where we cannot sleep, and will
>>>    * complain if the GPIO chip functions potentially sleep.
>>>    */
>>> -void gpiod_set_raw_array_value(unsigned int array_size,
>>> +int gpiod_set_raw_array_value(unsigned int array_size,
>>>                struct gpio_desc **desc_array, int *value_array)
>>>   {
>>>       if (!desc_array)
>>> -        return;
>>> -    gpiod_set_array_value_complex(true, false, array_size, desc_array,
>>> -                      value_array);
>>> +        return -EINVAL;
>>> +    return gpiod_set_array_value_complex(true, false, array_size,
>>> +                    desc_array, value_array);
>>>   }
>>>   EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value);
>>> @@ -3326,14 +3368,14 @@ EXPORT_SYMBOL_GPL(gpiod_set_value_cansleep);
>>>    *
>>>    * This function is to be called from contexts that can sleep.
>>>    */
>>> -void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>> +int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>>                       struct gpio_desc **desc_array,
>>>                       int *value_array)
>>>   {
>>>       might_sleep_if(extra_checks);
>>>       if (!desc_array)
>>> -        return;
>>> -    gpiod_set_array_value_complex(true, true, array_size, desc_array,
>>> +        return -EINVAL;
>>> +    return gpiod_set_array_value_complex(true, true, array_size, desc_array,
>>>                         value_array);
>>>   }
>>>   EXPORT_SYMBOL_GPL(gpiod_set_raw_array_value_cansleep);
>>> diff --git a/drivers/gpio/gpiolib.h b/drivers/gpio/gpiolib.h
>>> index b17ec6795c81..b64813e3876e 100644
>>> --- a/drivers/gpio/gpiolib.h
>>> +++ b/drivers/gpio/gpiolib.h
>>> @@ -188,7 +188,7 @@ int gpiod_get_array_value_complex(bool raw, bool can_sleep,
>>>                     unsigned int array_size,
>>>                     struct gpio_desc **desc_array,
>>>                     int *value_array);
>>> -void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>> +int gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>>                      unsigned int array_size,
>>>                      struct gpio_desc **desc_array,
>>>                      int *value_array);
>>> diff --git a/include/linux/gpio/consumer.h b/include/linux/gpio/consumer.h
>>> index dbd065963296..243112c7fa7d 100644
>>> --- a/include/linux/gpio/consumer.h
>>> +++ b/include/linux/gpio/consumer.h
>>> @@ -116,7 +116,7 @@ int gpiod_get_raw_array_value(unsigned int array_size,
>>>                     struct gpio_desc **desc_array,
>>>                     int *value_array);
>>>   void gpiod_set_raw_value(struct gpio_desc *desc, int value);
>>> -void gpiod_set_raw_array_value(unsigned int array_size,
>>> +int gpiod_set_raw_array_value(unsigned int array_size,
>>>                      struct gpio_desc **desc_array,
>>>                      int *value_array);
>>> @@ -134,7 +134,7 @@ int gpiod_get_raw_array_value_cansleep(unsigned int array_size,
>>>                          struct gpio_desc **desc_array,
>>>                          int *value_array);
>>>   void gpiod_set_raw_value_cansleep(struct gpio_desc *desc, int value);
>>> -void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>> +int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>>                       struct gpio_desc **desc_array,
>>>                       int *value_array);
>>> @@ -369,12 +369,13 @@ static inline void gpiod_set_raw_value(struct gpio_desc *desc, int value)
>>>       /* GPIO can never have been requested */
>>>       WARN_ON(1);
>>>   }
>>> -static inline void gpiod_set_raw_array_value(unsigned int array_size,
>>> +static inline int gpiod_set_raw_array_value(unsigned int array_size,
>>>                            struct gpio_desc **desc_array,
>>>                            int *value_array)
>>>   {
>>>       /* GPIO can never have been requested */
>>>       WARN_ON(1);
>>> +    return 0;
>>>   }
>>>   static inline int gpiod_get_value_cansleep(const struct gpio_desc *desc)
>>> @@ -423,12 +424,13 @@ static inline void gpiod_set_raw_value_cansleep(struct gpio_desc *desc,
>>>       /* GPIO can never have been requested */
>>>       WARN_ON(1);
>>>   }
>>> -static inline void gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>> +static inline int gpiod_set_raw_array_value_cansleep(unsigned int array_size,
>>>                           struct gpio_desc **desc_array,
>>>                           int *value_array)
>>>   {
>>>       /* GPIO can never have been requested */
>>>       WARN_ON(1);
>>> +    return 0;
>>>   }
>>>   static inline int gpiod_set_debounce(struct gpio_desc *desc, unsigned debounce)
>>>
>>
>>
> 
> 


-- 
Regards
Phil Reid

ElectroMagnetic Imaging Technology Pty Ltd
Development of Geophysical Instrumentation & Software
www.electromag.com.au

3 The Avenue, Midland WA 6056, AUSTRALIA
Ph: +61 8 9250 8100
Fax: +61 8 9250 7100
Email: preid@electromag.com.au
