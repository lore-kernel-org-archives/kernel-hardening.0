MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180228143037.GA3150@pjb1027-Latitude-E5410>
References: <20180228143037.GA3150@pjb1027-Latitude-E5410>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 28 Feb 2018 08:54:48 -0800
Message-ID: <CAGXu5j+OUHmviXLeZGzLH3q9F-z1s6-8epG-y1ZusgOyGEy24Q@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH 2/2] arm: Kconfig: Add ARCH_HAS_FORTIFY_SOURCE
Content-Type: text/plain; charset="UTF-8"
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Philippe Ombredanne <pombredanne@nexb.co>, Greg KH <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kate Stewart <kstewart@linuxfoundation.org>, Andy Lutomirski <luto@amacapital.net>, Dmitry Safonov <dsafonov@virtuozzo.com>, Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 28, 2018 at 6:30 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> CONFIG_FORTIFY_SOURCE detects various overflows at compile-time.
> (6974f0c4555e ("include/linux/string.h:
> add the option of fortified string.h functions)
>
> ARCH_HAS_FORTIFY_SOURCE means that the architecture can be built and
> run with CONFIG_FORTIFY_SOURCE.
>
> Since ARM can be built and run with that flag like other architectures,
> select ARCH_HAS_FORTIFY_SOURCE as default.
>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 7e3d535..3765336 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -7,6 +7,7 @@ config ARM
>         select ARCH_HAS_DEBUG_VIRTUAL if MMU
>         select ARCH_HAS_DEVMEM_IS_ALLOWED
>         select ARCH_HAS_ELF_RANDOMIZE
> +       select ARCH_HAS_FORTIFY_SOURCE
>         select ARCH_HAS_SET_MEMORY
>         select ARCH_HAS_PHYS_TO_DMA
>         select ARCH_HAS_STRICT_KERNEL_RWX if MMU && !XIP_KERNEL
> --
> 1.9.1
>



-- 
Kees Cook
Pixel Security
