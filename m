Subject: Re: [PATCHv5] gpio: Remove VLA from gpiolib
References: <20180413212427.18261-1-labbott@redhat.com>
 <CAMuHMdWDysLemM3PNNjC-Aircpu=Y-z=e79zgG8LPzvGCSEetg@mail.gmail.com>
 <067d073f-556c-9df0-37f8-fd63fcdc7eb9@redhat.com>
 <CAMuHMdX2LrSRuk-H__HLHJkoNWc1u-seTsR63dzFsXLLOwypGg@mail.gmail.com>
From: Phil Reid <preid@electromag.com.au>
Message-ID: <0f48484b-9c01-b79b-5b2b-e0da1b312ebc@electromag.com.au>
Date: Tue, 15 May 2018 15:30:09 +0800
MIME-Version: 1.0
In-Reply-To: <CAMuHMdX2LrSRuk-H__HLHJkoNWc1u-seTsR63dzFsXLLOwypGg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Geert Uytterhoeven <geert@linux-m68k.org>, Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 15/05/2018 15:10, Geert Uytterhoeven wrote:
> Hi Laura,
> 
> On Tue, May 15, 2018 at 12:49 AM, Laura Abbott <labbott@redhat.com> wrote:
>> On 04/20/2018 02:02 AM, Geert Uytterhoeven wrote:
>>> On Fri, Apr 13, 2018 at 11:24 PM, Laura Abbott <labbott@redhat.com> wrote:
>>>> The new challenge is to remove VLAs from the kernel
>>>> (see https://lkml.org/lkml/2018/3/7/621) to eventually
>>>> turn on -Wvla.
>>>>
>>>> Using a kmalloc array is the easy way to fix this but kmalloc is still
>>>> more expensive than stack allocation. Introduce a fast path with a
>>>> fixed size stack array to cover most chip with gpios below some fixed
>>>> amount. The slow path dynamically allocates an array to cover those
>>>> chips with a large number of gpios.
>>>
>>>
>>> Blindly replacing VLAs by allocated arrays is IMHO not such a good
>>> solution.
>>> On the largest systems, NR_GPIOS is 2048, so that makes 2 arrays of 256
>>> bytes. That's an uppper limit, and assumes they are all on the same
>>> gpiochip,
>>> which they probably aren't.
>>>
>>> Still, 2 x 256 bytes is a lot, so I agree it should be fixed.
>>>
>>> So, wouldn't it make more sense to not allocate memory, but just process
>>> the request in chunks (say, at most 128 gpios per chunk, i.e. 2 x
>>> 16 bytes)? The code already caters for handling chunks due to not all
>>> gpios
>>> belonging to the same gpiochip. That will probably also be faster than
>>> allocating memory, which is the main idea behind this API.
>>>
>>>> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
>>>> Signed-off-by: Lukas Wunner <lukas@wunner.de>
>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>
>>>
>>>> --- a/drivers/gpio/gpiolib.c
>>>> +++ b/drivers/gpio/gpiolib.c
>>>
>>>
>>>> @@ -1192,6 +1196,10 @@ int gpiochip_add_data_with_key(struct gpio_chip
>>>> *chip, void *data,
>>>>                   goto err_free_descs;
>>>>           }
>>>>
>>>> +       if (chip->ngpio > FASTPATH_NGPIO)
>>>> +               chip_warn(chip, "line cnt %d is greater than fast path
>>>> cnt %d\n",
>>>> +               chip->ngpio, FASTPATH_NGPIO);
>>>
>>>
>>> FWIW, can this warning be triggered from userspace?
>>>
>>>> @@ -2662,16 +2670,28 @@ int gpiod_get_array_value_complex(bool raw, bool
>>>> can_sleep,
>>>>
>>>>           while (i < array_size) {
>>>>                   struct gpio_chip *chip = desc_array[i]->gdev->chip;
>>>> -               unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
>>>> -               unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
>>>
>>>
>>> Hence just use a fixed size here...
>>>
>>>> +               unsigned long fastpath[2 *
>>>> BITS_TO_LONGS(FASTPATH_NGPIO)];
>>>> +               unsigned long *mask, *bits;
>>>>                   int first, j, ret;
>>>>
>>>> +               if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
>>>> +                       memset(fastpath, 0, sizeof(fastpath));
>>>> +                       mask = fastpath;
>>>> +                       bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
>>>> +               } else {
>>>> +                       mask = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
>>>> +                                          sizeof(*mask),
>>>> +                                          can_sleep ? GFP_KERNEL :
>>>> GFP_ATOMIC);
>>>> +                       if (!mask)
>>>> +                               return -ENOMEM;
>>>> +                       bits = mask + BITS_TO_LONGS(chip->ngpio);
>>>> +               }
>>>> +
>>>>                   if (!can_sleep)
>>>>                           WARN_ON(chip->can_sleep);
>>>>
>>>>                   /* collect all inputs belonging to the same chip */
>>>>                   first = i;
>>>> -               memset(mask, 0, sizeof(mask));
>>>>                   do {
>>>>                           const struct gpio_desc *desc = desc_array[i];
>>>>                           int hwgpio = gpio_chip_hwgpio(desc);
>>>
>>>
>>> Out-of-context, the code does:
>>>
>>> |                       __set_bit(hwgpio, mask);
>>> |                       i++;
>>> |                 } while ((i < array_size) &&
>>>
>>> ... and change this limit to "(i < min(array_size, first +
>>> ARRAY_SIZE(mask) * BITS_PER_BYTE))"
>>>
>>> |                         (desc_array[i]->gdev->chip == chip));
>>>
>>> ... and you're done?
>>>
>> I don't think this approach will work since gpio_chip_{get,set}_multiple
>> expect to be working on arrays for the entire chip. There doesn't seem
>> to be a nice way to work on a subset of GPIOs without defeating the point
>> of the multiple API.
> 
> You're right, sorry for missing that.
> 
>> is 2*256 = 512 bytes really too much stack space? I guess we could
>> switch to a Kconfig to allow for better bounds.
> 
> That's a good question.
> 
> As long as a VLA is used, it's probably fine, as chip->ngpio is quite small.
> If you would change it to an array that can accommodate NR_GPIOS bits, you
> have to start caring about recursion (e.g. gpio-74x164 driven from spi-gpio,
> where I can extend the chain to increase the level of recursion arbitrarily).
> 

I think a config option for FASTPATH_NGPIO is preferable.

As I've mentioned ARCH_NR_GPIOS is much greater than any chip->ngpio on
my platform.
It's at least one order of magnitude, almost 2.


-- 
Regards
Phil Reid
