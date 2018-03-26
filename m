MIME-Version: 1.0
In-Reply-To: <20180310001021.6437-4-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com> <20180310001021.6437-4-labbott@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Mon, 26 Mar 2018 11:09:16 +0200
Message-ID: <CACRpkdbahPzpDpruGz3zrGvG-xskjp_YnVAadkqS1iPU=1NAXw@mail.gmail.com>
Subject: Re: [PATCH 3/4] gpio: Remove VLA from xra1403 driver
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:

> The new challenge is to remove VLAs from the kernel
> (see https://lkml.org/lkml/2018/3/7/621)
>
> This patch replaces a VLA with an appropriate call to kmalloc_array.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Patch applied with Nandor's review tag.

Yours,
Linus Walleij
