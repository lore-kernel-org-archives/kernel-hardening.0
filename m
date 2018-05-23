MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180328175957.23904-1-labbott@redhat.com>
References: <20180328175957.23904-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 23 May 2018 15:51:48 -0700
Message-ID: <CAGXu5jJwPbUHherfpPbyN8o9NntKN_CYY_TRyvrd+K_LSvZMFw@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: Remove VLA from stmpe driver
Content-Type: text/plain; charset="UTF-8"
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Laura Abbott <labbott@redhat.com>, Patrice Chotard <patrice.chotard@st.com>, linux-gpio@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 10:59 AM, Laura Abbott <labbott@redhat.com> wrote:
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
>
> The number of GPIOs on the supported chips is fairly small
> so stack allocate to a known upper bound and spit out a warning
> if any new chips have more gpios.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Linus, I think this patch is still needed and got missed? Can you take
it as well?

Thanks!

-Kees

> ---
> v3: Split this off from the rest of the series since some of the
> patches had been picked up. Switched to just hardcoding an upper
> bound for the stack array since it's only a few extra bytes
> of stack space.
> ---
>  drivers/gpio/gpio-stmpe.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-stmpe.c b/drivers/gpio/gpio-stmpe.c
> index f8d7d1cd8488..8d6a5a7e612d 100644
> --- a/drivers/gpio/gpio-stmpe.c
> +++ b/drivers/gpio/gpio-stmpe.c
> @@ -363,13 +363,15 @@ static struct irq_chip stmpe_gpio_irq_chip = {
>         .irq_set_type           = stmpe_gpio_irq_set_type,
>  };
>
> +#define MAX_GPIOS 24
> +
>  static irqreturn_t stmpe_gpio_irq(int irq, void *dev)
>  {
>         struct stmpe_gpio *stmpe_gpio = dev;
>         struct stmpe *stmpe = stmpe_gpio->stmpe;
>         u8 statmsbreg;
>         int num_banks = DIV_ROUND_UP(stmpe->num_gpios, 8);
> -       u8 status[num_banks];
> +       u8 status[DIV_ROUND_UP(MAX_GPIOS, 8)];
>         int ret;
>         int i;
>
> @@ -434,6 +436,11 @@ static int stmpe_gpio_probe(struct platform_device *pdev)
>         struct stmpe_gpio *stmpe_gpio;
>         int ret, irq;
>
> +       if (stmpe->num_gpios > MAX_GPIOS) {
> +               dev_err(&pdev->dev, "Need to increase maximum GPIO number\n");
> +               return -EINVAL;
> +       }
> +
>         stmpe_gpio = kzalloc(sizeof(*stmpe_gpio), GFP_KERNEL);
>         if (!stmpe_gpio)
>                 return -ENOMEM;
> --
> 2.14.3
>



-- 
Kees Cook
Pixel Security
