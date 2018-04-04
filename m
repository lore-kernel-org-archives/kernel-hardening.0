MIME-Version: 1.0
In-Reply-To: <90ca44b5-52d0-be74-f36c-55d6f4a9bf25@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com> <20180310001021.6437-4-labbott@redhat.com>
 <CAMuHMdUfGp_rn_fMWdOfWxPvyE1Y9oemm2piXszFTvBi9sQ5Eg@mail.gmail.com> <90ca44b5-52d0-be74-f36c-55d6f4a9bf25@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 4 Apr 2018 14:53:42 +0200
Message-ID: <CACRpkdbVAr62X9FrkS5cVpfpr+vgvnwmRfy0zKM=Vo=E+LjA9Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Kees Cook <keescook@chromium.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 7:27 PM, Laura Abbott <labbott@redhat.com> wrote:
> On 03/28/2018 12:27 AM, Geert Uytterhoeven wrote:
>>
>> Hi Laura,
>>
>> On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:
>>>
>>> The new challenge is to remove VLAs from the kernel
>>> (see https://lkml.org/lkml/2018/3/7/621)
>>>
>>> This patch replaces a VLA with an appropriate call to kmalloc_array.
>>>
>>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>>
>>
>> Thanks for your patch!
>>
>>> --- a/drivers/gpio/gpio-xra1403.c
>>> +++ b/drivers/gpio/gpio-xra1403.c
>>> @@ -126,11 +126,16 @@ static void xra1403_dbg_show(struct seq_file *s,
>>> struct gpio_chip *chip)
>>>   {
>>>          int reg;
>>>          struct xra1403 *xra = gpiochip_get_data(chip);
>>> -       int value[xra1403_regmap_cfg.max_register];
>>
>>
>> Apparently xra1403_regmap_cfg.max_register is always 0x15?
>>
>> What about adding
>>
>>          #define XRA_LAST 15
>>
>> at the top, and replacing both "XRA_IFR | 0x01" and
>> xra1403_regmap_cfg.max_register by XRA_LAST instead?
>> That would avoid doing yet another memory allocation over and over.
>>
>> Gr{oetje,eeting}s,
>>
>>                          Geert
>>
>
> I'm okay with making the change but I think Linus already picked
> up the patch into his gpio trees. Linus, do you want a patch on
> top of your -devel branch or should I just send a new patch?

Yeah a patch on top is fine, I sent my pull request to Torvalds
today so we can take this as a fix for the -rc cycle simply.

Yours,
Linus Walleij
