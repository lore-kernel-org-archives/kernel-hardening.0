Subject: Re: [PATCH 1/4] gpio: Remove VLA from gpiolib
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-2-labbott@redhat.com>
 <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <301ecaf7-62a4-14af-3a5b-7bd76a49c4f6@redhat.com>
Date: Mon, 12 Mar 2018 16:40:50 -0700
MIME-Version: 1.0
In-Reply-To: <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Lukas Wunner <lukas@wunner.de>, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/12/2018 08:00 AM, Rasmus Villemoes wrote:
> On 2018-03-10 01:10, Laura Abbott wrote:
>>   		/* collect all inputs belonging to the same chip */
>>   		first = i;
>> -		memset(mask, 0, sizeof(mask));
>> +		memset(mask, 0, sizeof(*mask));
> 
> see below
> 
>> @@ -2887,14 +2909,30 @@ void gpiod_set_array_value_complex(bool raw, bool can_sleep,
>>   
>>   	while (i < array_size) {
>>   		struct gpio_chip *chip = desc_array[i]->gdev->chip;
>> -		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
>> -		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
>> +		unsigned long *mask;
>> +		unsigned long *bits;
>>   		int count = 0;
>>   
>> +		mask = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
>> +				sizeof(*mask),
>> +				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
>> +
>> +		if (!mask)
>> +			return;
>> +
>> +		bits = kmalloc_array(BITS_TO_LONGS(chip->ngpio),
>> +				sizeof(*bits),
>> +				can_sleep ? GFP_KERNEL : GFP_ATOMIC);
>> +
>> +		if (!bits) {
>> +			kfree(mask);
>> +			return;
>> +		}
>> +
>>   		if (!can_sleep)
>>   			WARN_ON(chip->can_sleep);
>>   
>> -		memset(mask, 0, sizeof(mask));
>> +		memset(mask, 0, sizeof(*mask));
> 
> Hm, it seems you're now only clearing the first word of mask, not the
> entire allocation. Why not just use kcalloc() instead of kmalloc_array
> to have it automatically cleared?
> 

Bleh, I didn't think through that carefully. I'll just switch
to kcalloc, especially since it calls kmalloc_array.

> Other random thoughts: maybe two allocations for each loop iteration is
> a bit much. Maybe do a first pass over the array and collect the maximal
> chip->ngpio, do the memory allocation and freeing outside the loop (then
> you'd of course need to preserve the memset() with appropriate length
> computed). And maybe even just do one allocation, making bits point at
> the second half.
> 

I was trying to make minimal changes and match the existing code. Is this
likely to be an actual hot path to optimize?

> Does the set function need to be updated to return an int to be able to
> inform the caller that memory allocation failed?
> 

That would involve changing the public API. I don't have a problem
doing so if that's what you want.

> Rasmus
> 

Thanks,
Laura
