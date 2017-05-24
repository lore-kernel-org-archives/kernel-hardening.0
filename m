MIME-Version: 1.0
In-Reply-To: <20170524155751.424-4-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com> <20170524155751.424-4-riel@redhat.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 09:16:24 -0700
Message-ID: <CAGXu5jJYML2C36ucNjzuTpzmWdwwTmTsvttvJvFS1Ok6XJUcBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/5] x86: ascii armor the x86_64 boot init stack canary
To: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Daniel Micay <danielmicay@gmail.com>, Ted Ts'o <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-sh <linux-sh@vger.kernel.org>, Yoshinori Sato <ysato@users.sourceforge.jp>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 24, 2017 at 8:57 AM,  <riel@redhat.com> wrote:
> From: Rik van Riel <riel@redhat.com>
>
> Use the ascii-armor canary to prevent unterminated C string overflows
> from being able to successfully overwrite the canary, even if they
> somehow obtain the canary value.
>
> Inspired by execshield ascii-armor and Daniel Micay's linux-hardened tree.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/include/asm/stackprotector.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
> index dcbd9bcce714..8abedf1d650e 100644
> --- a/arch/x86/include/asm/stackprotector.h
> +++ b/arch/x86/include/asm/stackprotector.h
> @@ -74,6 +74,7 @@ static __always_inline void boot_init_stack_canary(void)
>         get_random_bytes(&canary, sizeof(canary));
>         tsc = rdtsc();
>         canary += tsc + (tsc << 32UL);
> +       canary &= CANARY_MASK;
>
>         current->stack_canary = canary;
>  #ifdef CONFIG_X86_64
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
