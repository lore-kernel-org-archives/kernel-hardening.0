MIME-Version: 1.0
In-Reply-To: <20180521175707.6653-1-labbott@redhat.com>
References: <20180521175707.6653-1-labbott@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 23 May 2018 14:03:02 +0200
Message-ID: <CACRpkdZNGSd+1Z=GAC1d3sdemM_WG8KztHELtBerwAHUrUvXUA@mail.gmail.com>
Subject: Re: [PATCHv9] gpio: Remove VLA from gpiolib
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Andy Shevchenko <andy.shevchenko@gmail.com>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Phil Reid <preid@electromag.com.au>, Geert Uytterhoeven <geert@linux-m68k.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 21, 2018 at 7:57 PM, Laura Abbott <labbott@redhat.com> wrote:

> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621) to eventually
> turn on -Wvla.
>
> Using a kmalloc array is the easy way to fix this but kmalloc is still
> more expensive than stack allocation. Introduce a fast path with a
> fixed size stack array to cover most chip with gpios below some fixed
> amount. The slow path dynamically allocates an array to cover those
> chips with a large number of gpios.
>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Reviewed-by: Phil Reid <preid@electromag.com.au>
> Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v9: switch to bitmap_zero

This v9 applied with Andy's review tag on top and pushed to
the servers for testing!

THANKS A LOT for your tireless work on this, it looks really
really good now, and as it seems we cleaned up some other
code on the way.

Yours,
Linus Walleij
