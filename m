Subject: Re: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-4-labbott@redhat.com>
 <CAMuHMdUfGp_rn_fMWdOfWxPvyE1Y9oemm2piXszFTvBi9sQ5Eg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <90ca44b5-52d0-be74-f36c-55d6f4a9bf25@redhat.com>
Date: Wed, 28 Mar 2018 10:27:09 -0700
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUfGp_rn_fMWdOfWxPvyE1Y9oemm2piXszFTvBi9sQ5Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 03/28/2018 12:27 AM, Geert Uytterhoeven wrote:
> Hi Laura,
> 
> On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:
>> The new challenge is to remove VLAs from the kernel
>> (see https://lkml.org/lkml/2018/3/7/621)
>>
>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
> 
> Thanks for your patch!
> 
>> --- a/drivers/gpio/gpio-xra1403.c
>> +++ b/drivers/gpio/gpio-xra1403.c
>> @@ -126,11 +126,16 @@ static void xra1403_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>>   {
>>          int reg;
>>          struct xra1403 *xra = gpiochip_get_data(chip);
>> -       int value[xra1403_regmap_cfg.max_register];
> 
> Apparently xra1403_regmap_cfg.max_register is always 0x15?
> 
> What about adding
> 
>          #define XRA_LAST 15
> 
> at the top, and replacing both "XRA_IFR | 0x01" and
> xra1403_regmap_cfg.max_register by XRA_LAST instead?
> That would avoid doing yet another memory allocation over and over.
> 
> Gr{oetje,eeting}s,
> 
>                          Geert
> 

I'm okay with making the change but I think Linus already picked
up the patch into his gpio trees. Linus, do you want a patch on
top of your -devel branch or should I just send a new patch?

Thanks,
Laura
