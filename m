MIME-Version: 1.0
In-Reply-To: <20171201201000.GA44539@beast>
References: <20171201201000.GA44539@beast>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 19 Dec 2017 13:33:20 +0000
Message-ID: <CAKv+Gu8Q-ui9pf_HVo0LcGBQ5fRD++NzEiQ9cEzp9k9FNXL3hQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH] Kconfig: Make STRICT_DEVMEM default-y
 on x86 and arm64
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 1 December 2017 at 20:10, Kees Cook <keescook@chromium.org> wrote:
> Distros have been shipping with CONFIG_STRICT_DEVMEM=y for years now. It
> is probably time to flip this default for x86 and arm64.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  lib/Kconfig.debug | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 947d3e2ed5c2..39b123d04a36 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1985,7 +1985,7 @@ config STRICT_DEVMEM
>         bool "Filter access to /dev/mem"
>         depends on MMU && DEVMEM
>         depends on ARCH_HAS_DEVMEM_IS_ALLOWED
> -       default y if TILE || PPC
> +       default y if TILE || PPC || X86 || ARM64
>         ---help---
>           If this option is disabled, you allow userspace (root) access to all
>           of memory, including kernel and userspace memory. Accidental
> --
> 2.7.4
>
>
> --
> Kees Cook
> Pixel Security
