Subject: Re: [PATCH v3] gpio: Remove VLA from stmpe driver
References: <20180328175957.23904-1-labbott@redhat.com>
From: Phil Reid <preid@electromag.com.au>
Message-ID: <e676f8fc-e619-ac7e-a5e0-8682197c7b9b@electromag.com.au>
Date: Thu, 29 Mar 2018 08:07:05 +0800
MIME-Version: 1.0
In-Reply-To: <20180328175957.23904-1-labbott@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Patrice Chotard <patrice.chotard@st.com>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 29/03/2018 01:59, Laura Abbott wrote:
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
> 
> The number of GPIOs on the supported chips is fairly small
> so stack allocate to a known upper bound and spit out a warning
> if any new chips have more gpios.
> 
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Split this off from the rest of the series since some of the
> patches had been picked up. Switched to just hardcoding an upper
> bound for the stack array since it's only a few extra bytes
> of stack space.
> ---
>   drivers/gpio/gpio-stmpe.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index f8d7d1cd8488..8d6a5a7e612d 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -363,13 +363,15 @@ static struct irq_chip stmpe_gpio_irq_chip = {
>   	.irq_set_type		= stmpe_gpio_irq_set_type,
>   };
>   
> +#define MAX_GPIOS 24
> +
>   static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>   {
>   	struct stmpe_gpio *stmpe_gpio = dev;
>   	struct stmpe *stmpe = stmpe_gpio->stmpe;
>   	u8 statmsbreg;
>   	int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
> -	u8 status[num_banks];
> +	u8 status[DIV_ROUND_UP(MAX_GPIOS, 8)];
>   	int ret;
>   	int i;
>   
> @@ -434,6 +436,11 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
>   	struct stmpe_gpio *stmpe_gpio;
>   	int ret, irq;
>   
> +	if (stmpe->num_gpios > MAX_GPIOS) {
> +		dev_err(&pdev->dev, "Need to increase maximum GPIO number\n");
> +		return -EINVAL;
> +	}
> +
>   	stmpe_gpio = kzalloc(sizeof(*stmpe_gpio), GFP_KERNEL);
>   	if (!stmpe_gpio)
>   		return -ENOMEM;
> 
FWIW
Reviewed-by: Phil Reid <preid@electromag.com.au>

-- 
Regards
Phil Reid
