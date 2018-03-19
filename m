Date: Mon, 19 Mar 2018 15:38:51 +0100
From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCHv2 2/4] gpio: Remove VLA from MAX3191X driver
Message-ID: <20180319143851.GA24209@wunner.de>
References: <20180315180030.20001-1-labbott@redhat.com>
 <20180315180030.20001-3-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180315180030.20001-3-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 15, 2018 at 11:00:28AM -0700, Laura Abbott wrote:
> 
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
> 
> This patch replaces several a VLA with an appropriate call to
> kmalloc_array.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>

This one isn't a hotpath, so the kmalloc overhead is negligible.
Did a quick test on a single-chip MAX31913 with no apparent issues.

> ---
> v2: No changes
> ---
>  drivers/gpio/gpio-max3191x.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-max3191x.c b/drivers/gpio/gpio-max3191x.c
> index f74b1072e84b..b5b9cb1fda50 100644
> --- a/drivers/gpio/gpio-max3191x.c
> +++ b/drivers/gpio/gpio-max3191x.c
> @@ -315,12 +315,17 @@ static void gpiod_set_array_single_value_cansleep(unsigned int ndescs,
>  						  struct gpio_desc **desc,
>  						  int value)
>  {
> -	int i, values[ndescs];
> +	int i, *values;
> +
> +	values = kmalloc_array(ndescs, sizeof(*values), GFP_KERNEL);
> +	if (!values)
> +		return;
>  
>  	for (i = 0; i < ndescs; i++)
>  		values[i] = value;
>  
>  	gpiod_set_array_value_cansleep(ndescs, desc, values);
> +	kfree(values);
>  }
>  
>  static struct gpio_descs *devm_gpiod_get_array_optional_count(
> -- 
> 2.14.3
> 
