Subject: Re: [PATCH 1/4] gpio: Remove VLA from gpiolib
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-2-labbott@redhat.com>
 <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk>
 <20180317082509.GA2579@wunner.de> <20180318142327.GA23761@wunner.de>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <0f17eb05-c183-bec9-0076-5ddd00d70f15@rasmusvillemoes.dk>
Date: Sun, 18 Mar 2018 21:34:12 +0100
MIME-Version: 1.0
In-Reply-To: <20180318142327.GA23761@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-18 15:23, Lukas Wunner wrote:
>>>
>>> Other random thoughts: maybe two allocations for each loop iteration is
>>> a bit much. Maybe do a first pass over the array and collect the maximal
>>> chip->ngpio, do the memory allocation and freeing outside the loop (then
>>> you'd of course need to preserve the memset() with appropriate length
>>> computed). And maybe even just do one allocation, making bits point at
>>> the second half.
>>
>> I think those are great ideas because the function is kind of a hotpath
>> and usage of VLAs was motivated by the desire to make it fast.
>>
>> I'd go one step further and store the maximum ngpio of all registered
>> chips in a global variable (and update it in gpiochip_add_data_with_key()),
>> then allocate 2 * max_ngpio once before entering the loop (as you've
>> suggested).  That would avoid the first pass to determine the maximum
>> chip->ngpio.  In most systems max_ngpio will be < 64, so one or two
>> unsigned longs depending on the arch's bitness.
> 
> Actually, scratch that.  If ngpio is usually smallish, we can just
> allocate reasonably sized space for mask and bits on the stack,

Yes.

> and fall back to the kcalloc slowpath only if chip->ngpio exceeds
> that limit.

Well, I'd suggest not adding that fallback code now, but simply add a
check in gpiochip_add_data_with_key to ensure ngpio is sane (and refuse
to register the chip otherwise), at least if we know that every
currently supported/known chip is covered by the 256 (?). That keeps the
code simple and fast, and then if somebody has a chip with 40000 gpio
lines, we can add a fallback path. Or we could consider alternative
solutions, to avoid a 10000 byte GFP_ATOMIC allocation (maybe hang a
pre-allocation off the gpio_chip; that's only two more bits per
descriptor, and there's already a whole gpio_desc for each - but not
sure about the locking in that case).

Rasmus
