MIME-Version: 1.0
In-Reply-To: <CAMuHMdX878Vun9oCrECA+uW-ErEgzRx8Gp2wLkoLdKXR0nNKAw@mail.gmail.com>
References: <20180518175304.20414-1-labbott@redhat.com> <CAHp75VciKgqYV_DB=h+zaVkk2+dmKJDhT02M4K8T1VGJA6KM0g@mail.gmail.com>
 <CAMuHMdX878Vun9oCrECA+uW-ErEgzRx8Gp2wLkoLdKXR0nNKAw@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sat, 19 May 2018 00:12:10 +0300
Message-ID: <CAHp75VezhMm9R64y2A6mobQVqbLMLUKtzxQHp7uRDTBTMMzpRw@mail.gmail.com>
Subject: Re: [PATCHv8] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, May 19, 2018 at 12:05 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Fri, May 18, 2018 at 10:07 PM, Andy Shevchenko
> <andy.shevchenko@gmail.com> wrote:
>> On Fri, May 18, 2018 at 8:53 PM, Laura Abbott <labbott@redhat.com> wrote:

>>> +               bits = mask + BITS_TO_LONGS(chip->ngpio);
>>> +               memset(mask, 0, BITS_TO_LONGS(chip->ngpio) * sizeof(*mask));
>>
>> Wouldn't be better
>>
>> bitmap_zero(mask, chip->ngpio);
>>
>> ?
>
> chip->ngpio is never const, so bitmap_zero() would always fall back to
> plain memset().

Yes. But it also much more readable and understandable here.

-- 
With Best Regards,
Andy Shevchenko
