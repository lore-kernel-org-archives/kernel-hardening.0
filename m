MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <CAHp75VciKgqYV_DB=h+zaVkk2+dmKJDhT02M4K8T1VGJA6KM0g@mail.gmail.com>
References: <20180518175304.20414-1-labbott@redhat.com> <CAHp75VciKgqYV_DB=h+zaVkk2+dmKJDhT02M4K8T1VGJA6KM0g@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 18 May 2018 23:05:17 +0200
Message-ID: <CAMuHMdX878Vun9oCrECA+uW-ErEgzRx8Gp2wLkoLdKXR0nNKAw@mail.gmail.com>
Subject: Re: [PATCHv8] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andy,

On Fri, May 18, 2018 at 10:07 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, May 18, 2018 at 8:53 PM, Laura Abbott <labbott@redhat.com> wrote:
>> The new challenge is to remove VLAs from the kernel
>> (see https://lkml.org/lkml/2018/3/7/621) to eventually
>> turn on -Wvla.
>>
>> Using a kmalloc array is the easy way to fix this but kmalloc is still
>> more expensive than stack allocation. Introduce a fast path with a
>> fixed size stack array to cover most chip with gpios below some fixed
>> amount. The slow path dynamically allocates an array to cover those
>> chips with a large number of gpios.
>
>> +               unsigned long fastpath[2 * BITS_TO_LONGS(FASTPATH_NGPIO)];
>> +               unsigned long *mask, *bits;
>>                 int first, j, ret;
>>
>> +               if (likely(chip->ngpio <= FASTPATH_NGPIO)) {
>> +                       mask = fastpath;
>> +               } else {
>> +                       mask = kmalloc_array(2 * BITS_TO_LONGS(chip->ngpio),
>> +                                          sizeof(*mask),
>> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
>> +                       if (!mask)
>> +                               return -ENOMEM;
>> +               }
>> +
>> +               bits = mask + BITS_TO_LONGS(chip->ngpio);
>> +               memset(mask, 0, BITS_TO_LONGS(chip->ngpio) * sizeof(*mask));
>
> Wouldn't be better
>
> bitmap_zero(mask, chip->ngpio);
>
> ?

chip->ngpio is never const, so bitmap_zero() would always fall back to
plain memset().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
