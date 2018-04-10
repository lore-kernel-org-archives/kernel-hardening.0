MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20180409210717.3852-1-labbott@redhat.com>
References: <20180409210717.3852-1-labbott@redhat.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 10 Apr 2018 10:08:56 +0200
Message-ID: <CAMuHMdVnXc+SrUEteb-v4Kb9FtXJcaWmdK63-oTK0f2KxBThsQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: xra1403: Switch to a fixed upper bound for registers
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Nandor Han <nandor.han@ge.com>, Kees Cook <keescook@chromium.org>, Linus Walleij <linus.walleij@linaro.org>, "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Laura,

On Mon, Apr 9, 2018 at 11:07 PM, Laura Abbott <labbott@redhat.com> wrote:
> Geert Uytterhoeven pointed out that the number of register was a
> fixed upper bound so there's no need to use a dynamically allocated
> array in place of a VLA. Use the defined upper bound.
>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Thanks for your patch!

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
