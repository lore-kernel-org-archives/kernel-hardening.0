MIME-Version: 1.0
In-Reply-To: <20180310001021.6437-3-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com> <20180310001021.6437-3-labbott@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 26 Mar 2018 11:07:57 +0200
Message-ID: <CACRpkdaOJeEJTH8xtDzwbOjoONp=M7QvEfF_bO5pTQJ8KpnMdA@mail.gmail.com>
Subject: Re: [PATCH 2/4] gpio: Remove VLA from MAX3191X driver
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:

>
> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
>
> This patch replaces several a VLA with an appropriate call to
> kmalloc_array.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Patch applied.

It's very simple and straight-forward after all.

Yours,
Linus Walleij
