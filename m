MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180104122801.GA3038@pjb1027-Latitude-E5410>
References: <20180104122801.GA3038@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 4 Jan 2018 10:32:46 -0800
Message-ID: <CAGXu5j+YsB1FWvZHEjnixU8RMpk-DLDYLXXmxfQjsU_gy64ZDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] arm: Always use REFCOUNT_FULL
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Will Deacon <will.deacon@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 4, 2018 at 4:28 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> arm prefers to use REFCOUNT_FULL by default.
> This enables it for arm.
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 3d349b4..ec80270 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -100,6 +100,7 @@ config ARM
>         select OLD_SIGACTION
>         select OLD_SIGSUSPEND3
>         select PERF_USE_VMALLOC
> +       select REFCOUNT_FULL
>         select RTC_LIB
>         select SYS_SUPPORTS_APM_EMULATION
>         # Above selects are sorted alphabetically; please add new ones
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
