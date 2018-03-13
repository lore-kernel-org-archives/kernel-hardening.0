MIME-Version: 1.0
In-Reply-To: <20180310001021.6437-1-labbott@redhat.com>
References: <20180310001021.6437-1-labbott@redhat.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 13 Mar 2018 10:42:51 +0100
Message-ID: <CACRpkdaJz-GL_XdkEv-6FpUkjhNKdp27P8p2KFtriVY8GMkrCQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] VLA removal from the GPIO subsystem
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Lukas Wunner <lukas@wunner.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Mathias Duckeck <m.duckeck@kunbus.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2018 at 1:10 AM, Laura Abbott <labbott@redhat.com> wrote:

> For those who haven't seen it, there's an effort to remove VLAs from the
> kernel so we can turn on -Wvla in the name of security. See
> https://lkml.org/lkml/2018/3/7/621 for more details and discussion.

OK I read up on it, I'm on board! Less is more.

> This is a series to remove a few VLAs from the gpio subsystem. These are
> compile tested only so I'd appreciate reviews and tests from
> maintainers. When these get Acked, I expect these to just go through the
> GPIO tree like usual.

Sure I will just queue it up with ACKs, or if I just think it looks nice
and reliable.

Thank you for doing this!

Yours,
Linus Walleij
