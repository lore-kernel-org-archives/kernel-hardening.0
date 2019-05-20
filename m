MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-3-thgarnie@chromium.org>
In-Reply-To: <20190520231948.49693-3-thgarnie@chromium.org>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 20 May 2019 16:23:58 -0700
Message-ID: <CAJcbSZEJBYOME2JqFdUxTVnb7F8uSY7PSaTDMEHf7vbEscUnbg@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] x86: Use symbol name in jump table for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, Michael Ellerman <mpe@ellerman.id.au>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 20, 2019 at 4:20 PM Thomas Garnier <thgarnie@chromium.org> wrote:
>
> From: Thomas Garnier <thgarnie@google.com>
>
> Replace the %c constraint with %P. The %c is incompatible with PIE
> because it implies an immediate value whereas %P reference a symbol.
> Change the _ASM_PTR reference to .long for expected relocation size and
> add a long padding to ensure entry alignment.
>
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/include/asm/jump_label.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index 65191ce8e1cf..e47fad8ee632 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -25,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 ".long 1b - ., %l[l_yes] - . \n\t"
> -               _ASM_PTR "%c0 + %c1 - .\n\t"
> +               _ASM_PTR "%P0 - .\n\t"
>                 ".popsection \n\t"
> -               : :  "i" (key), "i" (branch) : : l_yes);
> +               : :  "X" (&((char *)key)[branch]) : : l_yes);
>
>         return false;
>  l_yes:
> @@ -42,9 +42,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 ".long 1b - ., %l[l_yes] - . \n\t"
> -               _ASM_PTR "%c0 + %c1 - .\n\t"
> +               _ASM_PTR "%P0 - .\n\t"
>                 ".popsection \n\t"
> -               : :  "i" (key), "i" (branch) : : l_yes);
> +               : : "X" (&((char *)key)[branch]) : : l_yes);
>
>         return false;
>  l_yes:
> --
> 2.21.0.1020.gf2820cf01a-goog
>

Realized I forgot to address a feedback from the previous iteration on
this specific patch. Ignore it I will work to check if it can be
remove on the next iteration.


-- 
Thomas
