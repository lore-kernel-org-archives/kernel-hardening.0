Subject: Re: [PATCHv3] gpio: Remove VLA from gpiolib
References: <20180328181809.24505-1-labbott@redhat.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <e359dc22-ee4c-4ca8-c953-df7d6a4b4062@rasmusvillemoes.dk>
Date: Thu, 5 Apr 2018 09:41:03 +0200
MIME-Version: 1.0
In-Reply-To: <20180328181809.24505-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-28 20:18, Laura Abbott wrote:
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
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Split out from the series since patches have been picked up
> independently. Fold in patch from Lukas Wunner to introduce slow/fast
> paths. I took his suggestions to go with 384 as the maximum number of
> gpios. Also fixed one 0-day bot issue where I forgot to change the
> return type.
>  
>  	while (i < array_size) {
>  		struct gpio_chip *chip = desc_array[i]->gdev->chip;
> -		unsigned long mask[BITS_TO_LONGS(chip->ngpio)];
> -		unsigned long bits[BITS_TO_LONGS(chip->ngpio)];
> +		unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
> +		unsigned long *slowpath = NULL, *mask, *bits;
>  		int first, j, ret;
>  
> +		if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
> +			memset(fastpath, 0, sizeof(fastpath));
> +			mask = fastpath;
> +			bits = fastpath + BITS_TO_LONGS(FASTPATH_NGPIO);
> +		} else {
> +			slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
> +					   sizeof(*slowpath),
> +					   can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> +			if (!slowpath)
> +				return -ENOMEM;
> +			mask = slowpath;
> +			bits = slowpath + BITS_TO_LONGS(chip->ngpio);
> +		}
> +

To avoid the static analysis complaints about the "if (slowpath)
kfree(slowpath)" pattern, I'd suggest getting rid of the slowpath
variable and simply assign the kcalloc directly to mask. Then the
condition becomes "if (mask != fastpath) kfree(mask)". A comment won't
silence subsequenct coccicheck runs, and unfortunately probably won't
prevent certain individuals from sending auto-generated patches.

Maybe also pull out the "bits = mask + BITS_TO_LONGS(chip->ngpio)" to
the common path.

Another thing: Maybe a pr_warn or at least a pr_info would be in order
when a gpio chip with > FASTPATH_NGPIO lines is registered? And if that
triggers for a lot of different SoCs, one could consider changing it to
a CONFIG_ thing, or just bumping it to 512 if that would seem to cover
all the reports.

Rasmus
