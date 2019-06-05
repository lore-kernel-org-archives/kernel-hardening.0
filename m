MIME-Version: 1.0
References: <201906042224.42A2CCB2BE@keescook>
In-Reply-To: <201906042224.42A2CCB2BE@keescook>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 5 Jun 2019 08:20:44 +0200
Message-ID: <CAKv+Gu8m=6BgqfjrvrGEjX1Z3=W-YJhv-jrDXhC5+EoRuOG3qA@mail.gmail.com>
Subject: Re: [PATCH] lib/test_stackinit: Handle Clang auto-initialization pattern
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 5 Jun 2019 at 07:25, Kees Cook <keescook@chromium.org> wrote:
>
> While the gcc plugin for automatic stack variable initialization (i.e.
> CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) performs initialization with
> 0x00 bytes, the Clang automatic stack variable initialization (i.e.
> CONFIG_INIT_STACK_ALL) uses various type-specific patterns that are
> typically 0xAA. Therefore the stackinit selftest has been fixed to check
> that bytes are no longer the test fill pattern of 0xFF (instead of looking
> for bytes that have become 0x00). This retains the test coverage for the
> 0x00 pattern of the gcc plugin while adding coverage for the mostly 0xAA
> pattern of Clang.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  lib/test_stackinit.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
> index e97dc54b4fdf..2d7d257a430e 100644
> --- a/lib/test_stackinit.c
> +++ b/lib/test_stackinit.c
> @@ -12,7 +12,7 @@
>
>  /* Exfiltration buffer. */
>  #define MAX_VAR_SIZE   128
> -static char check_buf[MAX_VAR_SIZE];
> +static u8 check_buf[MAX_VAR_SIZE];
>
>  /* Character array to trigger stack protector in all functions. */
>  #define VAR_BUFFER      32
> @@ -106,9 +106,18 @@ static noinline __init int test_ ## name (void)                    \
>                                                                 \
>         /* Fill clone type with zero for per-field init. */     \
>         memset(&zero, 0x00, sizeof(zero));                      \
> +       /* Clear entire check buffer for 0xFF overlap test. */  \
> +       memset(check_buf, 0x00, sizeof(check_buf));             \
>         /* Fill stack with 0xFF. */                             \
>         ignored = leaf_ ##name((unsigned long)&ignored, 1,      \
>                                 FETCH_ARG_ ## which(zero));     \
> +       /* Verify all bytes overwritten with 0xFF. */           \
> +       for (sum = 0, i = 0; i < target_size; i++)              \
> +               sum += (check_buf[i] != 0xFF);                  \
> +       if (sum) {                                              \
> +               pr_err(#name ": leaf fill was not 0xFF!?\n");   \
> +               return 1;                                       \
> +       }                                                       \
>         /* Clear entire check buffer for later bit tests. */    \
>         memset(check_buf, 0x00, sizeof(check_buf));             \
>         /* Extract stack-defined variable contents. */          \
> @@ -126,9 +135,9 @@ static noinline __init int test_ ## name (void)                     \
>                 return 1;                                       \
>         }                                                       \
>                                                                 \
> -       /* Look for any set bits in the check region. */        \
> -       for (i = 0; i < sizeof(check_buf); i++)                 \
> -               sum += (check_buf[i] != 0);                     \
> +       /* Look for any bytes still 0xFF in check region. */    \
> +       for (sum = 0, i = 0; i < target_size; i++)              \
> +               sum += (check_buf[i] == 0xFF);                  \
>                                                                 \
>         if (sum == 0)                                           \
>                 pr_info(#name " ok\n");                         \
> @@ -162,13 +171,13 @@ static noinline __init int leaf_ ## name(unsigned long sp,        \
>          * Keep this buffer around to make sure we've got a     \
>          * stack frame of SOME kind...                          \
>          */                                                     \
> -       memset(buf, (char)(sp && 0xff), sizeof(buf));           \
> +       memset(buf, (char)(sp & 0xff), sizeof(buf));            \
>         /* Fill variable with 0xFF. */                          \
>         if (fill) {                                             \
>                 fill_start = &var;                              \
>                 fill_size = sizeof(var);                        \
>                 memset(fill_start,                              \
> -                      (char)((sp && 0xff) | forced_mask),      \
> +                      (char)((sp & 0xff) | forced_mask),       \
>                        fill_size);                              \
>         }                                                       \
>                                                                 \
> --
> 2.17.1
>
>
> --
> Kees Cook
