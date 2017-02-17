MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170216182917.19637-3-james.morse@arm.com>
References: <20170216182917.19637-1-james.morse@arm.com> <20170216182917.19637-3-james.morse@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 16 Feb 2017 16:47:33 -0800
Message-ID: <CAGXu5jJaywA3xC418G4h=EXHU-rovHW27wwQs3yUb-Jj+75_2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 2/3] arm64: Add arch_within_stack_frames() for hardened usercopy
To: James Morse <james.morse@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Pratyush Anand <panand@redhat.com>, keun-o.park@darkmatter.ae
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 16, 2017 at 10:29 AM, James Morse <james.morse@arm.com> wrote:
> Hardened usercopy tests that an object being copied to/from userspace
> doesn't overlap multiple stack frames.
>
> Add arch_within_stack_frames() to do this using arm64's stackwalker. The
> callback looks for 'fp' appearing with the range occupied by the object.
>
> (This isn't enough to trip the lkdtm tests on arm64)
>
> CC: Sahara <keun-o.park@darkmatter.ae>
> Based-on-a-patch-from: Sahara <keun-o.park@darkmatter.ae>
> Signed-off-by: James Morse <james.morse@arm.com>
> ---
>  arch/arm64/Kconfig                   |  1 +
>  arch/arm64/include/asm/thread_info.h |  7 ++++-
>  arch/arm64/kernel/stacktrace.c       | 54 ++++++++++++++++++++++++++++++++++--
>  3 files changed, 58 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 111742126897..378caa9c0563 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -67,6 +67,7 @@ config ARM64
>         select HAVE_ARCH_TRACEHOOK
>         select HAVE_ARCH_TRANSPARENT_HUGEPAGE
>         select HAVE_ARM_SMCCC
> +       select HAVE_ARCH_WITHIN_STACK_FRAMES
>         select HAVE_EBPF_JIT
>         select HAVE_C_RECORDMCOUNT
>         select HAVE_CC_STACKPROTECTOR
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index 46c3b93cf865..3540c46027fc 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -68,7 +68,12 @@ struct thread_info {
>  #define thread_saved_fp(tsk)   \
>         ((unsigned long)(tsk->thread.cpu_context.fp))
>
> -#endif
> +
> +extern enum stack_type arch_within_stack_frames(const void * const stack,
> +                                               const void * const stackend,
> +                                               const void *obj,
> +                                               unsigned long len);

The caller of arch_within_stack_frames expects this to be inlined...
could that be changed and then move the special stack check from the
third patch into check_stack_object() directly?

Regardless, I'm fine with reusing the existing walker. I just want to
avoid special cases in the uaccess code (so we can consolidate it in
the future).

-Kees

-- 
Kees Cook
Pixel Security
