Subject: Re: EXT: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-4-labbott@redhat.com>
From: Nandor Han <nandor.han@ge.com>
Message-ID: <2ba65a3e-3bc9-d709-caf9-f0c512d718a3@ge.com>
Date: Mon, 12 Mar 2018 08:06:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180310001021.6437-4-labbott@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Semi Malinen <semi.malinen@ge.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 10/03/18 02:10, Laura Abbott wrote:
> 
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
> 
> This patch replaces a VLA with an appropriate call to kmalloc_array.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---

This looks good to me.
Reviewed-by: Nandor Han <nandor.han@ge.com>

Nandor

>   drivers/gpio/gpio-xra1403.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-xra1403.c b/drivers/gpio/gpio-xra1403.c
> index 0230e4b7a2fb..8d4c8e99b251 100644
> --- a/drivers/gpio/gpio-xra1403.c
> +++ b/drivers/gpio/gpio-xra1403.c
> @@ -126,11 +126,16 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>   {
>   	int reg;
>   	struct xra1403 *xra = gpiochip_get_data(chip);
> -	int value[xra1403_regmap_cfg.max_register];
> +	int *value;
>   	int i;
>   	unsigned int gcr;
>   	unsigned int gsr;
>   
> +	value = kmalloc_array(xra1403_regmap_cfg.max_register, sizeof(*value),
> +				GFP_KERNEL);
> +	if (!value)
> +		return;
> +
>   	seq_puts(s, "xra reg:");
>   	for (reg = 0; reg <= xra1403_regmap_cfg.max_register; reg++)
>   		seq_printf(s, " %2.2x", reg);
> @@ -154,6 +159,7 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>   			   (gcr & BIT(i)) ? "in" : "out",
>   			   (gsr & BIT(i)) ? "hi" : "lo");
>   	}
> +	kfree(value);
>   }
>   #else
>   #define xra1403_dbg_show NULL
> 
