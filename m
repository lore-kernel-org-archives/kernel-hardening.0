MIME-Version: 1.0
In-Reply-To: <20170524155751.424-5-riel@redhat.com>
References: <20170524155751.424-1-riel@redhat.com> <20170524155751.424-5-riel@redhat.com>
From: Kees Cook <keescook@google.com>
Date: Wed, 24 May 2017 09:16:51 -0700
Message-ID: <CAGXu5j+b2UfdPs1yoweAy=jAFj9UQMGYYy1EjQUCi3JNjZD90A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 4/5] arm64: ascii armor the arm64 boot init stack canary
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
>  arch/arm64/include/asm/stackprotector.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/include/asm/stackprotector.h b/arch/arm64/include/asm/stackprotector.h
> index fe5e287dc56b..b86a0865ddf1 100644
> --- a/arch/arm64/include/asm/stackprotector.h
> +++ b/arch/arm64/include/asm/stackprotector.h
> @@ -30,6 +30,7 @@ static __always_inline void boot_init_stack_canary(void)
>         /* Try to get a semi random initial value. */
>         get_random_bytes(&canary, sizeof(canary));
>         canary ^= LINUX_VERSION_CODE;
> +       canary &= CANARY_MASK;
>
>         current->stack_canary = canary;
>         __stack_chk_guard = current->stack_canary;
> --
> 2.9.3
>



-- 
Kees Cook
Pixel Security
