Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1473788797-10879-4-git-send-email-catalin.marinas@arm.com>
References: <1473788797-10879-1-git-send-email-catalin.marinas@arm.com> <1473788797-10879-4-git-send-email-catalin.marinas@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 13 Sep 2016 13:45:21 -0700
Message-ID: <CAGXu5jJETdRtuonhtkSxMf+sgCdBj2t2_U8yW2cDwcoGY=qvJw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 3/7] arm64: Introduce uaccess_{disable,enable}
 functionality based on TTBR0_EL1
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 13, 2016 at 10:46 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> This patch adds the uaccess macros/functions to disable access to user
> space by setting TTBR0_EL1 to a reserved zeroed page. Since the value
> written to TTBR0_EL1 must be a physical address, for simplicity this
> patch introduces a reserved_ttbr0 page at a constant offset from
> swapper_pg_dir. The uaccess_disable code uses the ttbr1_el1 value
> adjusted by the reserved_ttbr0 offset.
>
> Enabling access to user is done by restoring TTBR0_EL1 with the value
> from the struct thread_info ttbr0 variable. Interrupts must be disabled
> during the uaccess_ttbr0_enable code to ensure the atomicity of the
> thread_info.ttbr0 read and TTBR0_EL1 write. This patch also moves the
> get_thread_info asm macro from entry.S to assembler.h for reuse in the
> uaccess_ttbr0_* macros.
>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: James Morse <james.morse@arm.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> [...]
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index 7099f26e3702..042d49c7b231 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -216,6 +216,12 @@ static inline bool system_supports_mixed_endian_el0(void)
>         return id_aa64mmfr0_mixed_endian_el0(read_system_reg(SYS_ID_AA64MMFR0_EL1));
>  }
>
> +static inline bool system_uses_ttbr0_pan(void)
> +{
> +       return IS_ENABLED(CONFIG_ARM64_SW_TTBR0_PAN) &&
> +               !cpus_have_cap(ARM64_HAS_PAN);
> +}
> +
>  #endif /* __ASSEMBLY__ */
>
>  #endif
> [...]
> diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> index cc6c32d4dcc4..115b5fa8dc3f 100644
> --- a/arch/arm64/include/asm/uaccess.h
> +++ b/arch/arm64/include/asm/uaccess.h
> [...]
> @@ -116,16 +117,57 @@ static inline void set_fs(mm_segment_t fs)
> [...]
>  #define __uaccess_disable(alt)                                         \
>  do {                                                                   \
> -       asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,                  \
> -                       CONFIG_ARM64_PAN));                             \
> +       if (system_uses_ttbr0_pan())                                    \
> +               uaccess_ttbr0_disable();                                \
> +       else                                                            \
> +               asm(ALTERNATIVE("nop", SET_PSTATE_PAN(1), alt,          \
> +                               CONFIG_ARM64_PAN));                     \
>  } while (0)
>
>  #define __uaccess_enable(alt)                                          \
>  do {                                                                   \
> -       asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,                  \
> -                       CONFIG_ARM64_PAN));                             \
> +       if (system_uses_ttbr0_pan())                                    \
> +               uaccess_ttbr0_enable();                                 \
> +       else                                                            \
> +               asm(ALTERNATIVE("nop", SET_PSTATE_PAN(0), alt,          \
> +                               CONFIG_ARM64_PAN));                     \
>  } while (0)

Does this mean that with CONFIG_ARM64_SW_TTBR0_PAN, even with ARMv8.1,
a cpu capability bitmask check is done each time we go through
__uaccess_{en,dis}able?

Could the alternative get moved around slightly to avoid this, or am I
misunderstanding something here?

-Kees

-- 
Kees Cook
Nexus Security
