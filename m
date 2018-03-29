Date: Thu, 29 Mar 2018 16:25:33 +0200
From: Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCHv3] gpio: Remove VLA from gpiolib
Message-ID: <20180329142533.GA15478@wunner.de>
References: <20180328181809.24505-1-labbott@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180328181809.24505-1-labbott@redhat.com>
To: Laura Abbott <labbott@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 28, 2018 at 11:18:09AM -0700, Laura Abbott wrote:
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
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v3: Split out from the series since patches have been picked up
> independently. Fold in patch from Lukas Wunner to introduce slow/fast
> paths. I took his suggestions to go with 384 as the maximum number of
> gpios. Also fixed one 0-day bot issue where I forgot to change the
> return type.

I've just given this a whirl with gpio-hammer and it works nicely, so FWIW:

Reviewed-and-tested-by: Lukas Wunner <lukas@wunner.de>

Thanks a lot for doing this Laura, and most of all thanks for the
proverbial "dogged persistence and patience"!
(https://lwn.net/Articles/697029/)

Lukas
