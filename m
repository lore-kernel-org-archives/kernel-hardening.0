MIME-Version: 1.0
References: <20190118105807.26425-1-ard.biesheuvel@linaro.org> <CAGXu5jKa6Tzea9SyTi5aOZusnb+1+yTJhMNaz-Ha8sjR7oCWsw@mail.gmail.com>
In-Reply-To: <CAGXu5jKa6Tzea9SyTi5aOZusnb+1+yTJhMNaz-Ha8sjR7oCWsw@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sun, 20 Jan 2019 16:43:22 +0100
Message-ID: <CAKv+Gu_VBQOfV7Z=PfAoBhUbyNtYg8tHumOciN7Yxa8RuQ06XQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] gcc-plugins: fixes for arm_ssp_per_task_plugin
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, 20 Jan 2019 at 02:51, Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Jan 18, 2019 at 2:58 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > A couple of fixes to permit newer versions of GCC to use the stack
> > protector plugin for ARM.
> >
> > Ard Biesheuvel (2):
> >   gcc-plugins: arm_ssp_per_task_plugin: sign extend the SP mask
> >   gcc-plugins: arm_ssp_per_task_plugin: fix for GCC 9+
>
> Nice; thanks! It seems like these should go into -rc4, yes? I'll get
> them queued up for Linus...
>

Yes, given that it is new code anyway, let's merge it as fixes.
