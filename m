Subject: Re: [PATCHv4] gpio: Remove VLA from gpiolib
References: <20180411010352.17929-1-labbott@redhat.com>
 <CACRpkdb04=5eHW3xR-qmY6UzOUcAC35mV4eDgHaFn9nQEL_eEw@mail.gmail.com>
 <c618af81-2dbb-1aff-212a-e87e56caa7eb@electromag.com.au>
 <0aea6c90-ba94-708c-5cad-836c50dadfe6@redhat.com>
From: Phil Reid <preid@electromag.com.au>
Message-ID: <20968086-4e27-6f71-707a-3c1b3d48390a@electromag.com.au>
Date: Sat, 14 Apr 2018 18:55:44 +0800
MIME-Version: 1.0
In-Reply-To: <0aea6c90-ba94-708c-5cad-836c50dadfe6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>
Cc: Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 14/04/2018 05:10, Laura Abbott wrote:
> On 04/12/2018 05:39 PM, Phil Reid wrote:
>> On 12/04/2018 16:38, Linus Walleij wrote:
>>> On Wed, Apr 11, 2018 at 3:03 AM, Laura Abbott <labbott@redhat.com> wrote:
>>>
>>>> The new challenge is to remove VLAs from the kernel
>>>> (see https://lkml.org/lkml/2018/3/7/621) to eventually
>>>> turn on -Wvla.
>>>>
>>>> Using a kmalloc array is the easy way to fix this but kmalloc is still
>>>> more expensive than stack allocation. Introduce a fast path with a
>>>> fixed size stack array to cover most chip with gpios below some fixed
>>>> amount. The slow path dynamically allocates an array to cover those
>>>> chips with a large number of gpios.
>>>>
>>>> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
>>>> Signed-off-by: Lukas Wunner <lukas@wunner.de>
>>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>>> ---
>>>> v4: Changed some local variables to avoid coccinelle warnings. Added a
>>>> warning if the number of GPIOs exceeds the current fast path define.
>>>>
>>>> Lukas, I kept your Tested-by because the changes were pretty minimal.
>>>> Let me know if you want to run the tests again.
>>>
>>> This patch is starting to look really good.
>>>
>>>> +/*
>>>> + * Number of GPIOs to use for the fast path in set array
>>>> + */
>>>> +#define FASTPATH_NGPIO 256
>>>
>>> There is still some comment about this.
>>>
>>> And now that I am also tryint to think I wonder about it, we
>>> have a global ARCH_NR_GPIOS that is typically 512.
>>> Some archs set it up.
>>>
>>> This define is something of an abomination, in the ARM
>>> case it comes from arch/arm/include/asm/gpio.h
>>> where #define ARCH_NR_GPIOS CONFIG_ARCH_NR_GPIO
>>> where the latter is a Kconfig option that is mostly 512 for
>>> most ARM systems.
>>>
>>> Well, ARM looks like this:
>>>
>>> config ARCH_NR_GPIO
>>>          int
>>>          default 2048 if ARCH_SOCFPGA
>>>          default 1024 if ARCH_BRCMSTB || ARCH_SHMOBILE || ARCH_TEGRA || \
>>>                  ARCH_ZYNQ
>>>          default 512 if ARCH_EXYNOS || ARCH_KEYSTONE || SOC_OMAP5 || \
>>>                  SOC_DRA7XX || ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210
>>>          default 416 if ARCH_SUNXI
>>>          default 392 if ARCH_U8500
>>>          default 352 if ARCH_VT8500
>>>          default 288 if ARCH_ROCKCHIP
>>>          default 264 if MACH_H4700
>>>          default 0
>>>          help
>>>            Maximum number of GPIOs in the system.
>>>
>>>            If unsure, leave the default value.
>>>
>>> So if FASTPATH_NGPIO should be anything else than
>>> ARCH_NR_GPIO this has to be established somewhere
>>> as a floor or half or something, but I would just set it as
>>> the same as ARCH_NR_GPIOS...
>>>
>>> The main reason this define exist is for this function
>>> from <linux/gpio/consumer.h>:
>>>
>>> /* Convert between the old gpio_ and new gpiod_ interfaces */
>>> struct gpio_desc *gpio_to_desc(unsigned gpio);
>>>
>>> Nowadays that fact is a bit obscured since the variable is
>>> only used when assigning the base (in the global GPIO
>>> number space, which is what we want to get rid of but
>>> sigh) in gpiochip_find_base() where it attempts to place
>>> a newly allocated gpiochip in the higher region of this
>>> numberspace since the embedded SoC GPIO base tends
>>> to be 0, on old platforms.
>>>
>>> So I don't know about this.
>>>
>>> Can't we just use ARCH_NR_GPIOS?
>>>
>>> Very few systems have more than 512 assigned global
>>> GPIO numbers and those are FPGA experimental machines.
>>>
>>> In the long run obviously I want to get rid of these defines
>>> altogether and only allocate GPIO descriptos dynamically
>>> so as you see I am reluctant to add new numberspace weirdness
>>> around here.
>> Isn't that for total GPIO's in the system?
>> And the arrays just need to cater for max per chip?
>>  From what I can understand of the code which is admittedly limited.
>>
>>
> 
> Yeah the switch back to 256 was a mistake on my end (I think I
> grabbed an incorrect version for my base). ARCH_NR_GPIOs
> is the total number in the system which may be multiple
> chips so yes we would be possibly allocating more space
> than necessary.
> 
> unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)]
> 
> unsigned long fastpath[2 * BITS_TO_LONGS(512)]
> unsigned long fastpath[2 * DIV_ROUND_UP(512, 8 * sizeof(long))]
> 
> so we end up with 128 bytes on the stack total assuming I
> can do math correctly. I think this a fairly reasonable
> amount though, even if we are over-estimating if there are
> multiple chips.
> 

Yeah that's not too bad.
My system is a SOCFPGA so it'd be 2048 / 8 = 512.
Still not unreasonable.

But the system doesn't have a single gpio close to that.
The largest chip is 32.


-- 
Regards
Phil Reid
