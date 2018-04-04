Subject: Re: [PATCHv3] gpio: Remove VLA from gpiolib
References: <20180328181809.24505-1-labbott@redhat.com>
 <CAHp75VdZOiJgzt3nhdeqwTXC=jsbndLWOV3eF_XmgFU-eHjYSg@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <2c191bd2-9df5-ecc1-1bf3-5ad19bea9138@redhat.com>
Date: Wed, 4 Apr 2018 11:31:41 -0700
MIME-Version: 1.0
In-Reply-To: <CAHp75VdZOiJgzt3nhdeqwTXC=jsbndLWOV3eF_XmgFU-eHjYSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/30/2018 07:33 AM, Andy Shevchenko wrote:
> On Wed, Mar 28, 2018 at 9:18 PM, Laura Abbott <labbott@redhat.com> wrote:
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
>> +               ret = gpiod_set_array_value_complex(false,
>>                                                true,
>>                                                lh->numdescs,
>>                                                lh->descs,
>>                                                vals);
>> +               if (ret)
>> +                       return ret;
>> +
>>                  return 0;
> 
> Can't we
> 
> return gpiod_set_array_value_complex(); ?
> 
> 

Yeah I'll clean that up for v4.

>> +                       slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
>> +                                          sizeof(*slowpath),
>> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> 
> 
>> +                       if (slowpath)
>> +                               kfree(slowpath);
> 
>> +               if (slowpath)
>> +                       kfree(slowpath);
> 
> Since slowpath is a pointer, conditionals above are redundant.
> 
>> +                       slowpath = kcalloc(2 * BITS_TO_LONGS(chip->ngpio),
>> +                                          sizeof(*slowpath),
>> +                                          can_sleep ? GFP_KERNEL : GFP_ATOMIC);
> 
>> +               if (slowpath)
>> +                       kfree(slowpath);
> 
> Ditto.
> 

This was caught by a coccinelle script via 0-day but I think the request
was to not do it. I'll add a comment explaining why we are going against
style.

Thanks,
Laura
