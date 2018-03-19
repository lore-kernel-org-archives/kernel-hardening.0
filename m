MIME-Version: 1.0
In-Reply-To: <20180319070043.GA25474@wunner.de>
References: <20180310001021.6437-1-labbott@redhat.com> <20180310001021.6437-2-labbott@redhat.com>
 <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk> <20180317082509.GA2579@wunner.de>
 <20180318142327.GA23761@wunner.de> <0f17eb05-c183-bec9-0076-5ddd00d70f15@rasmusvillemoes.dk>
 <20180319070043.GA25474@wunner.de>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Mon, 19 Mar 2018 17:09:54 +0200
Message-ID: <CAHp75VeJ5WQeEFaoExCCrFBuuKUX+17vC5JOdMW8V4KNvniT-Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Lukas Wunner <lukas@wunner.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Laura Abbott <labbott@redhat.com>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 19, 2018 at 9:00 AM, Lukas Wunner <lukas@wunner.de> wrote:
> On Sun, Mar 18, 2018 at 09:34:12PM +0100, Rasmus Villemoes wrote:
>> On 2018-03-18 15:23, Lukas Wunner wrote:

>> > Actually, scratch that.  If ngpio is usually smallish, we can just
>> > allocate reasonably sized space for mask and bits on the stack,
>> > and fall back to the kcalloc slowpath only if chip->ngpio exceeds
>> > that limit.

>> Well, I'd suggest not adding that fallback code now, but simply add a
>> check in gpiochip_add_data_with_key to ensure ngpio is sane (and refuse
>> to register the chip otherwise), at least if we know that every
>> currently supported/known chip is covered by the 256 (?).
>
> The number 256 was arbitrarily chosen.  I really wouldn't be surprised
> if gpiochips with more pins exist, but they're probably rare, so using
> the slowpath seems fine, but dropping support for them completely would
> be a regression.

All modern Intel SoCs have GPIO count in between of ~230-380.
Though, few of them are split to communities by (much) less than 256
pin in each when there is a 1:1 mapping between community and
gpiochip.

OTOH, the function you are fixing is most likely is not used together
with the drivers for x86.

-- 
With Best Regards,
Andy Shevchenko
