MIME-Version: 1.0
References: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190118105807.26425-1-ard.biesheuvel@linaro.org>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 19 Jan 2019 17:51:08 -0800
Message-ID: <CAGXu5jKa6Tzea9SyTi5aOZusnb+1+yTJhMNaz-Ha8sjR7oCWsw@mail.gmail.com>
Subject: Re: [PATCH 0/2] gcc-plugins: fixes for arm_ssp_per_task_plugin
Content-Type: text/plain; charset="UTF-8"
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 18, 2019 at 2:58 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> A couple of fixes to permit newer versions of GCC to use the stack
> protector plugin for ARM.
>
> Ard Biesheuvel (2):
>   gcc-plugins: arm_ssp_per_task_plugin: sign extend the SP mask
>   gcc-plugins: arm_ssp_per_task_plugin: fix for GCC 9+

Nice; thanks! It seems like these should go into -rc4, yes? I'll get
them queued up for Linus...

-Kees

>
>  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 23 ++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> --
> 2.20.1
>


-- 
Kees Cook
