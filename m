MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170522231025.30463-1-danielmicay@gmail.com>
References: <20170522231025.30463-1-danielmicay@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 May 2017 20:40:28 -0700
Message-ID: <CAGXu5jJQpiSHVw-6OeS92i2UU+QFDeXN9Wrs-V_8YKD_fHuqNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kernel <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 22, 2017 at 4:10 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
> index 733bae07fb29..3c5b26e07b85 100644
> --- a/arch/x86/include/asm/string_64.h
> +++ b/arch/x86/include/asm/string_64.h
> @@ -77,6 +77,11 @@ int strcmp(const char *cs, const char *ct);
>  #define memcpy(dst, src, len) __memcpy(dst, src, len)
>  #define memmove(dst, src, len) __memmove(dst, src, len)
>  #define memset(s, c, n) __memset(s, c, n)
> +
> +#ifndef __NO_FORTIFY
> +#define __NO_FORTIFY /* FORTIFY_SOURCE uses __builtin_memcpy, etc. */
> +#endif
> +
>  #endif
>
>  #define __HAVE_ARCH_MEMCPY_MCSAFE 1

Ah-ha, this same KASAN exclusion is missing for string_32.h, which is
what I think akpm tripped over in build tests.

-Kees

-- 
Kees Cook
Pixel Security
