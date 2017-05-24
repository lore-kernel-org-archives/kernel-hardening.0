MIME-Version: 1.0
In-Reply-To: <20170524155751.424-2-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com> <20170524155751.424-2-riel@redhat.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 09:15:34 -0700
Message-ID: <CAGXu5jKVTga05PqHKaZ_gEqjSYc4sfaD7Cy9eZeDaZSowJ_v3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 1/5] random,stackprotect: introduce get_random_canary function
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, Ted Ts'o <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-sh <linux-sh@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 24, 2017 at 8:57 AM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> Introduce the get_random_canary function, which provides a random
> unsigned long canary value with the first byte zeroed out on 64
> bit architectures, in order to mitigate non-terminated C string
> overflows.
>
> The null byte both prevents C string functions from reading the
> canary, and from writing it if the canary value were guessed or
> obtained through some other means.
>
> Reducing the entropy by 8 bits is acceptable on 64-bit systems,
> which will still have 56 bits of entropy left, but not on 32
> bit systems, so the "ascii armor" canary is only implemented on
> 64-bit systems.
>
> Inspired by the "ascii armor" code in the old execshield patches,
> and Daniel Micay's linux-hardened tree.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Since the other recent canary fix went via -mm, perhaps these should
go that way too? If not, I can take them via my KSPP tree.

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  include/linux/random.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/include/linux/random.h b/include/linux/random.h
> index ed5c3838780d..1fa0dc880bd7 100644
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> @@ -57,6 +57,27 @@ static inline unsigned long get_random_long(void)
>  #endif
>  }
>
> +/*
> + * On 64-bit architectures, protect against non-terminated C string overflows
> + * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
> + */
> +#ifdef CONFIG_64BIT
> +# ifdef __LITTLE_ENDIAN
> +#  define CANARY_MASK 0xffffffffffffff00UL
> +# else /* big endian, 64 bits: */
> +#  define CANARY_MASK 0x00ffffffffffffffUL
> +# endif
> +#else /* 32 bits: */
> +# define CANARY_MASK 0xffffffffUL
> +#endif
> +
> +static inline unsigned long get_random_canary(void)
> +{
> +       unsigned long val = get_random_long();
> +
> +       return val & CANARY_MASK;
> +}
> +
>  unsigned long randomize_page(unsigned long start, unsigned long range);
>
>  u32 prandom_u32(void);
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
