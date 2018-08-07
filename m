Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH 1/2] x86: WARN() when uaccess helpers fault on kernel addresses
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20180807012257.20157-1-jannh@google.com>
Date: Mon, 6 Aug 2018 19:55:17 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6369CAA-CBB8-420F-97DB-7A242D9650A8@amacapital.net>
References: <20180807012257.20157-1-jannh@google.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, dvyukov@google.com
List-ID: <kernel-hardening.lists.openwall.com>



> On Aug 6, 2018, at 6:22 PM, Jann Horn <jannh@google.com> wrote:
>=20
> There have been multiple kernel vulnerabilities that permitted userspace t=
o
> pass completely unchecked pointers through to userspace accessors:
>=20
> - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>  access_ok() checks")
> - the sg/bsg read/write APIs
> - the infiniband read/write APIs
>=20
> These don't happen all that often, but when they do happen, it is hard to
> test for them properly; and it is probably also hard to discover them with=

> fuzzing. Even when an unmapped kernel address is supplied to such buggy
> code, it just returns -EFAULT instead of doing a proper BUG() or at least
> WARN().
>=20
> This patch attempts to make such misbehaving code a bit more visible by
> WARN()ing in the pagefault handler code when a userspace accessor causes
> #PF on a kernel address and the current context isn't whitelisted.

I like this a lot, and, in fact, I once wrote a patch to do something simila=
r. It was before the fancy extable code, though, so it was a mess.  Here are=
 some thoughts:

- It should be three patches. One patch to add the _UA annotations, one to i=
mprove the info passes to the handlers, and one to change behavior.

- You should pass the vector, the error code, and the address to the handler=
.

- The uaccess handler should IMO WARN if the vector is anything other than #=
PF (which mainly means warning if it=E2=80=99s #GP). I think it should pr_em=
erg() and return false if the vector is #PF and the address is too high.

- Arguably most non-uaccess fixups should at least warn for anything other t=
han #GP and #UD.

>=20
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
> This is a hacky, quickly thrown-together PoC to see what people think
> about the basic idea. Does it look like a sensible change? Or would it
> be better, for example, to instead expand the KASan hooks in the
> usercopy logic to also look at the "user" pointer if it points to
> kernelspace? That would have the advantage of also catching heap
> overflows properly...
>=20
> I'm not really happy with all the plumbing in my patch; I wonder whether
> there's a way around introducing _ASM_EXTABLE_UA() for user accessors?
>=20
> arch/x86/include/asm/asm.h          |  10 ++-
> arch/x86/include/asm/extable.h      |   3 +-
> arch/x86/include/asm/fpu/internal.h |   6 +-
> arch/x86/include/asm/futex.h        |   6 +-
> arch/x86/include/asm/uaccess.h      |  22 ++---
> arch/x86/kernel/cpu/mcheck/mce.c    |   2 +-
> arch/x86/kernel/kprobes/core.c      |   2 +-
> arch/x86/kernel/traps.c             |   6 +-
> arch/x86/lib/checksum_32.S          |   4 +-
> arch/x86/lib/copy_user_64.S         |  90 ++++++++++----------
> arch/x86/lib/csum-copy_64.S         |   6 +-
> arch/x86/lib/getuser.S              |  12 +--
> arch/x86/lib/putuser.S              |  10 +--
> arch/x86/lib/usercopy_32.c          | 126 ++++++++++++++--------------
> arch/x86/lib/usercopy_64.c          |   4 +-
> arch/x86/mm/extable.c               |  67 ++++++++++++---
> arch/x86/mm/fault.c                 |   2 +-
> include/linux/sched.h               |   2 +
> mm/maccess.c                        |   6 ++
> 19 files changed, 221 insertions(+), 165 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index 990770f9e76b..38f44a773adf 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -130,6 +130,9 @@
> # define _ASM_EXTABLE(from, to)                    \
>   _ASM_EXTABLE_HANDLE(from, to, ex_handler_default)
>=20
> +# define _ASM_EXTABLE_UA(from, to)                \
> +    _ASM_EXTABLE_HANDLE(from, to, ex_handler_uaccess)
> +
> # define _ASM_EXTABLE_FAULT(from, to)                \
>   _ASM_EXTABLE_HANDLE(from, to, ex_handler_fault)
>=20
> @@ -165,8 +168,8 @@
>   jmp copy_user_handle_tail
>   .previous
>=20
> -    _ASM_EXTABLE(100b,103b)
> -    _ASM_EXTABLE(101b,103b)
> +    _ASM_EXTABLE_UA(100b,103b)
> +    _ASM_EXTABLE_UA(101b,103b)
>   .endm
>=20
> #else
> @@ -182,6 +185,9 @@
> # define _ASM_EXTABLE(from, to)                    \
>   _ASM_EXTABLE_HANDLE(from, to, ex_handler_default)
>=20
> +# define _ASM_EXTABLE_UA(from, to)                \
> +    _ASM_EXTABLE_HANDLE(from, to, ex_handler_uaccess)
> +
> # define _ASM_EXTABLE_FAULT(from, to)                \
>   _ASM_EXTABLE_HANDLE(from, to, ex_handler_fault)
>=20
> diff --git a/arch/x86/include/asm/extable.h b/arch/x86/include/asm/extable=
.h
> index f9c3a5d502f4..93c1d28f3c73 100644
> --- a/arch/x86/include/asm/extable.h
> +++ b/arch/x86/include/asm/extable.h
> @@ -29,7 +29,8 @@ struct pt_regs;
>       (b)->handler =3D (tmp).handler - (delta);        \
>   } while (0)
>=20
> -extern int fixup_exception(struct pt_regs *regs, int trapnr);
> +extern int fixup_exception(struct pt_regs *regs, int trapnr,
> +               unsigned long pf_addr);
> extern int fixup_bug(struct pt_regs *regs, int trapnr);
> extern bool ex_has_fault_handler(unsigned long ip);
> extern void early_fixup_exception(struct pt_regs *regs, int trapnr);
> diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fp=
u/internal.h
> index a38bf5a1e37a..640e7721138c 100644
> --- a/arch/x86/include/asm/fpu/internal.h
> +++ b/arch/x86/include/asm/fpu/internal.h
> @@ -113,7 +113,7 @@ extern void fpstate_sanitize_xstate(struct fpu *fpu);
>            "3:  movl $-1,%[err]\n"                \
>            "    jmp  2b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 3b)                \
> +             _ASM_EXTABLE_UA(1b, 3b)                \
>            : [err] "=3Dr" (err), output                \
>            : "0"(0), input);                    \
>   err;                                \
> @@ -226,7 +226,7 @@ static inline void copy_fxregs_to_kernel(struct fpu *f=
pu)
>            "3: movl $-2,%[err]\n\t"                \
>            "jmp 2b\n\t"                    \
>            ".popsection\n\t"                    \
> -             _ASM_EXTABLE(1b, 3b)                \
> +             _ASM_EXTABLE_UA(1b, 3b)                \
>            : [err] "=3Dr" (err)                    \
>            : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)    \
>            : "memory")
> @@ -256,7 +256,7 @@ static inline void copy_fxregs_to_kernel(struct fpu *f=
pu)
>            "4: movl $-2, %[err]\n"                \
>            "jmp 3b\n"                        \
>            ".popsection\n"                    \
> -             _ASM_EXTABLE(661b, 4b)                \
> +             _ASM_EXTABLE_UA(661b, 4b)                \
>            : [err] "=3Dr" (err)                    \
>            : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)    \
>            : "memory")
> diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
> index de4d68852d3a..13c83fe97988 100644
> --- a/arch/x86/include/asm/futex.h
> +++ b/arch/x86/include/asm/futex.h
> @@ -20,7 +20,7 @@
>            "3:\tmov\t%3, %1\n"            \
>            "\tjmp\t2b\n"                \
>            "\t.previous\n"                \
> -             _ASM_EXTABLE(1b, 3b)            \
> +             _ASM_EXTABLE_UA(1b, 3b)            \
>            : "=3Dr" (oldval), "=3Dr" (ret), "+m" (*uaddr)    \
>            : "i" (-EFAULT), "0" (oparg), "1" (0))
>=20
> @@ -36,8 +36,8 @@
>            "4:\tmov\t%5, %1\n"            \
>            "\tjmp\t3b\n"                \
>            "\t.previous\n"                \
> -             _ASM_EXTABLE(1b, 4b)            \
> -             _ASM_EXTABLE(2b, 4b)            \
> +             _ASM_EXTABLE_UA(1b, 4b)            \
> +             _ASM_EXTABLE_UA(2b, 4b)            \
>            : "=3D&a" (oldval), "=3D&r" (ret),        \
>              "+m" (*uaddr), "=3D&r" (tem)        \
>            : "r" (oparg), "i" (-EFAULT), "1" (0))
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess=
.h
> index aae77eb8491c..b5e58cc0c5e7 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -198,8 +198,8 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0U=
L), 0ULL, 0UL))
>            "4:    movl %3,%0\n"                \
>            "    jmp 3b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 4b)                \
> -             _ASM_EXTABLE(2b, 4b)                \
> +             _ASM_EXTABLE_UA(1b, 4b)                \
> +             _ASM_EXTABLE_UA(2b, 4b)                \
>            : "=3Dr" (err)                    \
>            : "A" (x), "r" (addr), "i" (errret), "0" (err))
>=20
> @@ -340,8 +340,8 @@ do {                                    \
>            "    xorl %%edx,%%edx\n"                \
>            "    jmp 3b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 4b)                \
> -             _ASM_EXTABLE(2b, 4b)                \
> +             _ASM_EXTABLE_UA(1b, 4b)                \
> +             _ASM_EXTABLE_UA(2b, 4b)                \
>            : "=3Dr" (retval), "=3D&A"(x)                \
>            : "m" (__m(__ptr)), "m" __m(((u32 __user *)(__ptr)) + 1),    \
>              "i" (errret), "0" (retval));            \
> @@ -386,7 +386,7 @@ do {                                    \
>            "    xor"itype" %"rtype"1,%"rtype"1\n"        \
>            "    jmp 2b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 3b)                \
> +             _ASM_EXTABLE_UA(1b, 3b)                \
>            : "=3Dr" (err), ltype(x)                \
>            : "m" (__m(addr)), "i" (errret), "0" (err))
>=20
> @@ -398,7 +398,7 @@ do {                                    \
>            "3:    mov %3,%0\n"                \
>            "    jmp 2b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 3b)                \
> +             _ASM_EXTABLE_UA(1b, 3b)                \
>            : "=3Dr" (err), ltype(x)                \
>            : "m" (__m(addr)), "i" (errret), "0" (err))
>=20
> @@ -474,7 +474,7 @@ struct __large_struct { unsigned long buf[100]; };
>            "3:    mov %3,%0\n"                \
>            "    jmp 2b\n"                    \
>            ".previous\n"                    \
> -             _ASM_EXTABLE(1b, 3b)                \
> +             _ASM_EXTABLE_UA(1b, 3b)                \
>            : "=3Dr"(err)                    \
>            : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
>=20
> @@ -602,7 +602,7 @@ extern void __cmpxchg_wrong_size(void)
>           "3:\tmov     %3, %0\n"                \
>           "\tjmp     2b\n"                \
>           "\t.previous\n"                    \
> -            _ASM_EXTABLE(1b, 3b)                \
> +            _ASM_EXTABLE_UA(1b, 3b)                \
>           : "+r" (__ret), "=3Da" (__old), "+m" (*(ptr))    \
>           : "i" (-EFAULT), "q" (__new), "1" (__old)    \
>           : "memory"                    \
> @@ -618,7 +618,7 @@ extern void __cmpxchg_wrong_size(void)
>           "3:\tmov     %3, %0\n"                \
>           "\tjmp     2b\n"                \
>           "\t.previous\n"                    \
> -            _ASM_EXTABLE(1b, 3b)                \
> +            _ASM_EXTABLE_UA(1b, 3b)                \
>           : "+r" (__ret), "=3Da" (__old), "+m" (*(ptr))    \
>           : "i" (-EFAULT), "r" (__new), "1" (__old)    \
>           : "memory"                    \
> @@ -634,7 +634,7 @@ extern void __cmpxchg_wrong_size(void)
>           "3:\tmov     %3, %0\n"                \
>           "\tjmp     2b\n"                \
>           "\t.previous\n"                    \
> -            _ASM_EXTABLE(1b, 3b)                \
> +            _ASM_EXTABLE_UA(1b, 3b)                \
>           : "+r" (__ret), "=3Da" (__old), "+m" (*(ptr))    \
>           : "i" (-EFAULT), "r" (__new), "1" (__old)    \
>           : "memory"                    \
> @@ -653,7 +653,7 @@ extern void __cmpxchg_wrong_size(void)
>           "3:\tmov     %3, %0\n"                \
>           "\tjmp     2b\n"                \
>           "\t.previous\n"                    \
> -            _ASM_EXTABLE(1b, 3b)                \
> +            _ASM_EXTABLE_UA(1b, 3b)                \
>           : "+r" (__ret), "=3Da" (__old), "+m" (*(ptr))    \
>           : "i" (-EFAULT), "r" (__new), "1" (__old)    \
>           : "memory"                    \
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck=
/mce.c
> index 8c50754c09c1..e038e3f31e08 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1335,7 +1335,7 @@ void do_machine_check(struct pt_regs *regs, long err=
or_code)
>       local_irq_disable();
>       ist_end_non_atomic();
>   } else {
> -        if (!fixup_exception(regs, X86_TRAP_MC))
> +        if (!fixup_exception(regs, X86_TRAP_MC, 0))
>           mce_panic("Failed kernel mode recovery", &m, NULL);
>   }
>=20
> diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core=
.c
> index 6f4d42377fe5..5ad2639d3b8a 100644
> --- a/arch/x86/kernel/kprobes/core.c
> +++ b/arch/x86/kernel/kprobes/core.c
> @@ -1044,7 +1044,7 @@ int kprobe_fault_handler(struct pt_regs *regs, int t=
rapnr)
>        * In case the user-specified fault handler returned
>        * zero, try to fix up.
>        */
> -        if (fixup_exception(regs, trapnr))
> +        if (fixup_exception(regs, trapnr, 0))
>           return 1;
>=20
>       /*
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index e6db475164ed..0cd11b46072a 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -206,7 +206,7 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr,=
 char *str,
>   }
>=20
>   if (!user_mode(regs)) {
> -        if (fixup_exception(regs, trapnr))
> +        if (fixup_exception(regs, trapnr, 0))
>           return 0;
>=20
>       tsk->thread.error_code =3D error_code;
> @@ -551,7 +551,7 @@ do_general_protection(struct pt_regs *regs, long error=
_code)
>=20
>   tsk =3D current;
>   if (!user_mode(regs)) {
> -        if (fixup_exception(regs, X86_TRAP_GP))
> +        if (fixup_exception(regs, X86_TRAP_GP, 0))
>           return;
>=20
>       tsk->thread.error_code =3D error_code;
> @@ -838,7 +838,7 @@ static void math_error(struct pt_regs *regs, int error=
_code, int trapnr)
>   cond_local_irq_enable(regs);
>=20
>   if (!user_mode(regs)) {
> -        if (fixup_exception(regs, trapnr))
> +        if (fixup_exception(regs, trapnr, 0))
>           return;
>=20
>       task->thread.error_code =3D error_code;
> diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
> index 46e71a74e612..ad8e0906d1ea 100644
> --- a/arch/x86/lib/checksum_32.S
> +++ b/arch/x86/lib/checksum_32.S
> @@ -273,11 +273,11 @@ unsigned int csum_partial_copy_generic (const char *=
src, char *dst,
>=20
> #define SRC(y...)            \
>   9999: y;            \
> -    _ASM_EXTABLE(9999b, 6001f)
> +    _ASM_EXTABLE_UA(9999b, 6001f)
>=20
> #define DST(y...)            \
>   9999: y;            \
> -    _ASM_EXTABLE(9999b, 6002f)
> +    _ASM_EXTABLE_UA(9999b, 6002f)
>=20
> #ifndef CONFIG_X86_USE_PPRO_CHECKSUM
>=20
> diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
> index 020f75cc8cf6..80cfad666210 100644
> --- a/arch/x86/lib/copy_user_64.S
> +++ b/arch/x86/lib/copy_user_64.S
> @@ -92,26 +92,26 @@ ENTRY(copy_user_generic_unrolled)
> 60:    jmp copy_user_handle_tail /* ecx is zerorest also */
>   .previous
>=20
> -    _ASM_EXTABLE(1b,30b)
> -    _ASM_EXTABLE(2b,30b)
> -    _ASM_EXTABLE(3b,30b)
> -    _ASM_EXTABLE(4b,30b)
> -    _ASM_EXTABLE(5b,30b)
> -    _ASM_EXTABLE(6b,30b)
> -    _ASM_EXTABLE(7b,30b)
> -    _ASM_EXTABLE(8b,30b)
> -    _ASM_EXTABLE(9b,30b)
> -    _ASM_EXTABLE(10b,30b)
> -    _ASM_EXTABLE(11b,30b)
> -    _ASM_EXTABLE(12b,30b)
> -    _ASM_EXTABLE(13b,30b)
> -    _ASM_EXTABLE(14b,30b)
> -    _ASM_EXTABLE(15b,30b)
> -    _ASM_EXTABLE(16b,30b)
> -    _ASM_EXTABLE(18b,40b)
> -    _ASM_EXTABLE(19b,40b)
> -    _ASM_EXTABLE(21b,50b)
> -    _ASM_EXTABLE(22b,50b)
> +    _ASM_EXTABLE_UA(1b,30b)
> +    _ASM_EXTABLE_UA(2b,30b)
> +    _ASM_EXTABLE_UA(3b,30b)
> +    _ASM_EXTABLE_UA(4b,30b)
> +    _ASM_EXTABLE_UA(5b,30b)
> +    _ASM_EXTABLE_UA(6b,30b)
> +    _ASM_EXTABLE_UA(7b,30b)
> +    _ASM_EXTABLE_UA(8b,30b)
> +    _ASM_EXTABLE_UA(9b,30b)
> +    _ASM_EXTABLE_UA(10b,30b)
> +    _ASM_EXTABLE_UA(11b,30b)
> +    _ASM_EXTABLE_UA(12b,30b)
> +    _ASM_EXTABLE_UA(13b,30b)
> +    _ASM_EXTABLE_UA(14b,30b)
> +    _ASM_EXTABLE_UA(15b,30b)
> +    _ASM_EXTABLE_UA(16b,30b)
> +    _ASM_EXTABLE_UA(18b,40b)
> +    _ASM_EXTABLE_UA(19b,40b)
> +    _ASM_EXTABLE_UA(21b,50b)
> +    _ASM_EXTABLE_UA(22b,50b)
> ENDPROC(copy_user_generic_unrolled)
> EXPORT_SYMBOL(copy_user_generic_unrolled)
>=20
> @@ -156,8 +156,8 @@ ENTRY(copy_user_generic_string)
>   jmp copy_user_handle_tail
>   .previous
>=20
> -    _ASM_EXTABLE(1b,11b)
> -    _ASM_EXTABLE(3b,12b)
> +    _ASM_EXTABLE_UA(1b,11b)
> +    _ASM_EXTABLE_UA(3b,12b)
> ENDPROC(copy_user_generic_string)
> EXPORT_SYMBOL(copy_user_generic_string)
>=20
> @@ -189,7 +189,7 @@ ENTRY(copy_user_enhanced_fast_string)
>   jmp copy_user_handle_tail
>   .previous
>=20
> -    _ASM_EXTABLE(1b,12b)
> +    _ASM_EXTABLE_UA(1b,12b)
> ENDPROC(copy_user_enhanced_fast_string)
> EXPORT_SYMBOL(copy_user_enhanced_fast_string)
>=20
> @@ -319,27 +319,27 @@ ENTRY(__copy_user_nocache)
>   jmp copy_user_handle_tail
>   .previous
>=20
> -    _ASM_EXTABLE(1b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(2b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(3b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(4b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(5b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(6b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(7b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(8b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(9b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(10b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(11b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(12b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(13b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(14b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(15b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(16b,.L_fixup_4x8b_copy)
> -    _ASM_EXTABLE(20b,.L_fixup_8b_copy)
> -    _ASM_EXTABLE(21b,.L_fixup_8b_copy)
> -    _ASM_EXTABLE(30b,.L_fixup_4b_copy)
> -    _ASM_EXTABLE(31b,.L_fixup_4b_copy)
> -    _ASM_EXTABLE(40b,.L_fixup_1b_copy)
> -    _ASM_EXTABLE(41b,.L_fixup_1b_copy)
> +    _ASM_EXTABLE_UA(1b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(2b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(3b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(4b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(5b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(6b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(7b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(8b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(9b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(10b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(11b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(12b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(13b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(14b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(15b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(16b,.L_fixup_4x8b_copy)
> +    _ASM_EXTABLE_UA(20b,.L_fixup_8b_copy)
> +    _ASM_EXTABLE_UA(21b,.L_fixup_8b_copy)
> +    _ASM_EXTABLE_UA(30b,.L_fixup_4b_copy)
> +    _ASM_EXTABLE_UA(31b,.L_fixup_4b_copy)
> +    _ASM_EXTABLE_UA(40b,.L_fixup_1b_copy)
> +    _ASM_EXTABLE_UA(41b,.L_fixup_1b_copy)
> ENDPROC(__copy_user_nocache)
> EXPORT_SYMBOL(__copy_user_nocache)
> diff --git a/arch/x86/lib/csum-copy_64.S b/arch/x86/lib/csum-copy_64.S
> index 45a53dfe1859..969af904c74b 100644
> --- a/arch/x86/lib/csum-copy_64.S
> +++ b/arch/x86/lib/csum-copy_64.S
> @@ -31,17 +31,17 @@
>=20
>   .macro source
> 10:
> -    _ASM_EXTABLE(10b, .Lbad_source)
> +    _ASM_EXTABLE_UA(10b, .Lbad_source)
>   .endm
>=20
>   .macro dest
> 20:
> -    _ASM_EXTABLE(20b, .Lbad_dest)
> +    _ASM_EXTABLE_UA(20b, .Lbad_dest)
>   .endm
>=20
>   .macro ignore L=3D.Lignore
> 30:
> -    _ASM_EXTABLE(30b, \L)
> +    _ASM_EXTABLE_UA(30b, \L)
>   .endm
>=20
>=20
> diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
> index 49b167f73215..884fe795d9d6 100644
> --- a/arch/x86/lib/getuser.S
> +++ b/arch/x86/lib/getuser.S
> @@ -132,12 +132,12 @@ bad_get_user_8:
> END(bad_get_user_8)
> #endif
>=20
> -    _ASM_EXTABLE(1b,bad_get_user)
> -    _ASM_EXTABLE(2b,bad_get_user)
> -    _ASM_EXTABLE(3b,bad_get_user)
> +    _ASM_EXTABLE_UA(1b,bad_get_user)
> +    _ASM_EXTABLE_UA(2b,bad_get_user)
> +    _ASM_EXTABLE_UA(3b,bad_get_user)
> #ifdef CONFIG_X86_64
> -    _ASM_EXTABLE(4b,bad_get_user)
> +    _ASM_EXTABLE_UA(4b,bad_get_user)
> #else
> -    _ASM_EXTABLE(4b,bad_get_user_8)
> -    _ASM_EXTABLE(5b,bad_get_user_8)
> +    _ASM_EXTABLE_UA(4b,bad_get_user_8)
> +    _ASM_EXTABLE_UA(5b,bad_get_user_8)
> #endif
> diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
> index 96dce5fe2a35..cdcf6143d953 100644
> --- a/arch/x86/lib/putuser.S
> +++ b/arch/x86/lib/putuser.S
> @@ -94,10 +94,10 @@ bad_put_user:
>   EXIT
> END(bad_put_user)
>=20
> -    _ASM_EXTABLE(1b,bad_put_user)
> -    _ASM_EXTABLE(2b,bad_put_user)
> -    _ASM_EXTABLE(3b,bad_put_user)
> -    _ASM_EXTABLE(4b,bad_put_user)
> +    _ASM_EXTABLE_UA(1b,bad_put_user)
> +    _ASM_EXTABLE_UA(2b,bad_put_user)
> +    _ASM_EXTABLE_UA(3b,bad_put_user)
> +    _ASM_EXTABLE_UA(4b,bad_put_user)
> #ifdef CONFIG_X86_32
> -    _ASM_EXTABLE(5b,bad_put_user)
> +    _ASM_EXTABLE_UA(5b,bad_put_user)
> #endif
> diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
> index 7add8ba06887..92eb5956f2f3 100644
> --- a/arch/x86/lib/usercopy_32.c
> +++ b/arch/x86/lib/usercopy_32.c
> @@ -47,8 +47,8 @@ do {                                    \
>       "3:    lea 0(%2,%0,4),%0\n"                \
>       "    jmp 2b\n"                    \
>       ".previous\n"                        \
> -        _ASM_EXTABLE(0b,3b)                    \
> -        _ASM_EXTABLE(1b,2b)                    \
> +        _ASM_EXTABLE_UA(0b,3b)                    \
> +        _ASM_EXTABLE_UA(1b,2b)                    \
>       : "=3D&c"(size), "=3D&D" (__d0)                \
>       : "r"(size & 3), "0"(size / 4), "1"(addr), "a"(0));    \
> } while (0)
> @@ -153,44 +153,44 @@ __copy_user_intel(void __user *to, const void *from,=
 unsigned long size)
>              "101:   lea 0(%%eax,%0,4),%0\n"
>              "       jmp 100b\n"
>              ".previous\n"
> -               _ASM_EXTABLE(1b,100b)
> -               _ASM_EXTABLE(2b,100b)
> -               _ASM_EXTABLE(3b,100b)
> -               _ASM_EXTABLE(4b,100b)
> -               _ASM_EXTABLE(5b,100b)
> -               _ASM_EXTABLE(6b,100b)
> -               _ASM_EXTABLE(7b,100b)
> -               _ASM_EXTABLE(8b,100b)
> -               _ASM_EXTABLE(9b,100b)
> -               _ASM_EXTABLE(10b,100b)
> -               _ASM_EXTABLE(11b,100b)
> -               _ASM_EXTABLE(12b,100b)
> -               _ASM_EXTABLE(13b,100b)
> -               _ASM_EXTABLE(14b,100b)
> -               _ASM_EXTABLE(15b,100b)
> -               _ASM_EXTABLE(16b,100b)
> -               _ASM_EXTABLE(17b,100b)
> -               _ASM_EXTABLE(18b,100b)
> -               _ASM_EXTABLE(19b,100b)
> -               _ASM_EXTABLE(20b,100b)
> -               _ASM_EXTABLE(21b,100b)
> -               _ASM_EXTABLE(22b,100b)
> -               _ASM_EXTABLE(23b,100b)
> -               _ASM_EXTABLE(24b,100b)
> -               _ASM_EXTABLE(25b,100b)
> -               _ASM_EXTABLE(26b,100b)
> -               _ASM_EXTABLE(27b,100b)
> -               _ASM_EXTABLE(28b,100b)
> -               _ASM_EXTABLE(29b,100b)
> -               _ASM_EXTABLE(30b,100b)
> -               _ASM_EXTABLE(31b,100b)
> -               _ASM_EXTABLE(32b,100b)
> -               _ASM_EXTABLE(33b,100b)
> -               _ASM_EXTABLE(34b,100b)
> -               _ASM_EXTABLE(35b,100b)
> -               _ASM_EXTABLE(36b,100b)
> -               _ASM_EXTABLE(37b,100b)
> -               _ASM_EXTABLE(99b,101b)
> +               _ASM_EXTABLE_UA(1b,100b)
> +               _ASM_EXTABLE_UA(2b,100b)
> +               _ASM_EXTABLE_UA(3b,100b)
> +               _ASM_EXTABLE_UA(4b,100b)
> +               _ASM_EXTABLE_UA(5b,100b)
> +               _ASM_EXTABLE_UA(6b,100b)
> +               _ASM_EXTABLE_UA(7b,100b)
> +               _ASM_EXTABLE_UA(8b,100b)
> +               _ASM_EXTABLE_UA(9b,100b)
> +               _ASM_EXTABLE_UA(10b,100b)
> +               _ASM_EXTABLE_UA(11b,100b)
> +               _ASM_EXTABLE_UA(12b,100b)
> +               _ASM_EXTABLE_UA(13b,100b)
> +               _ASM_EXTABLE_UA(14b,100b)
> +               _ASM_EXTABLE_UA(15b,100b)
> +               _ASM_EXTABLE_UA(16b,100b)
> +               _ASM_EXTABLE_UA(17b,100b)
> +               _ASM_EXTABLE_UA(18b,100b)
> +               _ASM_EXTABLE_UA(19b,100b)
> +               _ASM_EXTABLE_UA(20b,100b)
> +               _ASM_EXTABLE_UA(21b,100b)
> +               _ASM_EXTABLE_UA(22b,100b)
> +               _ASM_EXTABLE_UA(23b,100b)
> +               _ASM_EXTABLE_UA(24b,100b)
> +               _ASM_EXTABLE_UA(25b,100b)
> +               _ASM_EXTABLE_UA(26b,100b)
> +               _ASM_EXTABLE_UA(27b,100b)
> +               _ASM_EXTABLE_UA(28b,100b)
> +               _ASM_EXTABLE_UA(29b,100b)
> +               _ASM_EXTABLE_UA(30b,100b)
> +               _ASM_EXTABLE_UA(31b,100b)
> +               _ASM_EXTABLE_UA(32b,100b)
> +               _ASM_EXTABLE_UA(33b,100b)
> +               _ASM_EXTABLE_UA(34b,100b)
> +               _ASM_EXTABLE_UA(35b,100b)
> +               _ASM_EXTABLE_UA(36b,100b)
> +               _ASM_EXTABLE_UA(37b,100b)
> +               _ASM_EXTABLE_UA(99b,101b)
>              : "=3D&c"(size), "=3D&D" (d0), "=3D&S" (d1)
>              :  "1"(to), "2"(from), "0"(size)
>              : "eax", "edx", "memory");
> @@ -259,26 +259,26 @@ static unsigned long __copy_user_intel_nocache(void *=
to,
>          "9:      lea 0(%%eax,%0,4),%0\n"
>          "16:     jmp 8b\n"
>          ".previous\n"
> -           _ASM_EXTABLE(0b,16b)
> -           _ASM_EXTABLE(1b,16b)
> -           _ASM_EXTABLE(2b,16b)
> -           _ASM_EXTABLE(21b,16b)
> -           _ASM_EXTABLE(3b,16b)
> -           _ASM_EXTABLE(31b,16b)
> -           _ASM_EXTABLE(4b,16b)
> -           _ASM_EXTABLE(41b,16b)
> -           _ASM_EXTABLE(10b,16b)
> -           _ASM_EXTABLE(51b,16b)
> -           _ASM_EXTABLE(11b,16b)
> -           _ASM_EXTABLE(61b,16b)
> -           _ASM_EXTABLE(12b,16b)
> -           _ASM_EXTABLE(71b,16b)
> -           _ASM_EXTABLE(13b,16b)
> -           _ASM_EXTABLE(81b,16b)
> -           _ASM_EXTABLE(14b,16b)
> -           _ASM_EXTABLE(91b,16b)
> -           _ASM_EXTABLE(6b,9b)
> -           _ASM_EXTABLE(7b,16b)
> +           _ASM_EXTABLE_UA(0b,16b)
> +           _ASM_EXTABLE_UA(1b,16b)
> +           _ASM_EXTABLE_UA(2b,16b)
> +           _ASM_EXTABLE_UA(21b,16b)
> +           _ASM_EXTABLE_UA(3b,16b)
> +           _ASM_EXTABLE_UA(31b,16b)
> +           _ASM_EXTABLE_UA(4b,16b)
> +           _ASM_EXTABLE_UA(41b,16b)
> +           _ASM_EXTABLE_UA(10b,16b)
> +           _ASM_EXTABLE_UA(51b,16b)
> +           _ASM_EXTABLE_UA(11b,16b)
> +           _ASM_EXTABLE_UA(61b,16b)
> +           _ASM_EXTABLE_UA(12b,16b)
> +           _ASM_EXTABLE_UA(71b,16b)
> +           _ASM_EXTABLE_UA(13b,16b)
> +           _ASM_EXTABLE_UA(81b,16b)
> +           _ASM_EXTABLE_UA(14b,16b)
> +           _ASM_EXTABLE_UA(91b,16b)
> +           _ASM_EXTABLE_UA(6b,9b)
> +           _ASM_EXTABLE_UA(7b,16b)
>          : "=3D&c"(size), "=3D&D" (d0), "=3D&S" (d1)
>          :  "1"(to), "2"(from), "0"(size)
>          : "eax", "edx", "memory");
> @@ -321,9 +321,9 @@ do {                                    \
>       "3:    lea 0(%3,%0,4),%0\n"                \
>       "    jmp 2b\n"                    \
>       ".previous\n"                        \
> -        _ASM_EXTABLE(4b,5b)                    \
> -        _ASM_EXTABLE(0b,3b)                    \
> -        _ASM_EXTABLE(1b,2b)                    \
> +        _ASM_EXTABLE_UA(4b,5b)                    \
> +        _ASM_EXTABLE_UA(0b,3b)                    \
> +        _ASM_EXTABLE_UA(1b,2b)                    \
>       : "=3D&c"(size), "=3D&D" (__d0), "=3D&S" (__d1), "=3Dr"(__d2)    \
>       : "3"(size), "0"(size), "1"(to), "2"(from)        \
>       : "memory");                        \
> diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> index 9c5606d88f61..c55b1f590cc4 100644
> --- a/arch/x86/lib/usercopy_64.c
> +++ b/arch/x86/lib/usercopy_64.c
> @@ -37,8 +37,8 @@ unsigned long __clear_user(void __user *addr, unsigned l=
ong size)
>       "3:    lea 0(%[size1],%[size8],8),%[size8]\n"
>       "    jmp 2b\n"
>       ".previous\n"
> -        _ASM_EXTABLE(0b,3b)
> -        _ASM_EXTABLE(1b,2b)
> +        _ASM_EXTABLE_UA(0b,3b)
> +        _ASM_EXTABLE_UA(1b,2b)
>       : [size8] "=3D&c"(size), [dst] "=3D&D" (__d0)
>       : [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr));
>   clac();
> diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
> index 45f5d6cf65ae..3fd55a03892d 100644
> --- a/arch/x86/mm/extable.c
> +++ b/arch/x86/mm/extable.c
> @@ -8,7 +8,7 @@
> #include <asm/kdebug.h>
>=20
> typedef bool (*ex_handler_t)(const struct exception_table_entry *,
> -                struct pt_regs *, int);
> +                struct pt_regs *, int, unsigned long);
>=20
> static inline unsigned long
> ex_fixup_addr(const struct exception_table_entry *x)
> @@ -22,7 +22,8 @@ ex_fixup_handler(const struct exception_table_entry *x)
> }
>=20
> __visible bool ex_handler_default(const struct exception_table_entry *fixu=
p,
> -                  struct pt_regs *regs, int trapnr)
> +                  struct pt_regs *regs, int trapnr,
> +                  unsigned long fault_addr)
> {
>   regs->ip =3D ex_fixup_addr(fixup);
>   return true;
> @@ -30,7 +31,8 @@ __visible bool ex_handler_default(const struct exception=
_table_entry *fixup,
> EXPORT_SYMBOL(ex_handler_default);
>=20
> __visible bool ex_handler_fault(const struct exception_table_entry *fixup,=

> -                struct pt_regs *regs, int trapnr)
> +                struct pt_regs *regs, int trapnr,
> +                unsigned long fault_addr)
> {
>   regs->ip =3D ex_fixup_addr(fixup);
>   regs->ax =3D trapnr;
> @@ -43,7 +45,8 @@ EXPORT_SYMBOL_GPL(ex_handler_fault);
> * result of a refcount inc/dec/add/sub.
> */
> __visible bool ex_handler_refcount(const struct exception_table_entry *fix=
up,
> -                   struct pt_regs *regs, int trapnr)
> +                   struct pt_regs *regs, int trapnr,
> +                   unsigned long fault_addr)
> {
>   /* First unconditionally saturate the refcount. */
>   *(int *)regs->cx =3D INT_MIN / 2;
> @@ -96,7 +99,8 @@ EXPORT_SYMBOL(ex_handler_refcount);
> * out all the FPU registers) if we can't restore from the task's FPU state=
.
> */
> __visible bool ex_handler_fprestore(const struct exception_table_entry *fi=
xup,
> -                    struct pt_regs *regs, int trapnr)
> +                    struct pt_regs *regs, int trapnr,
> +                    unsigned long fault_addr)
> {
>   regs->ip =3D ex_fixup_addr(fixup);
>=20
> @@ -108,18 +112,53 @@ __visible bool ex_handler_fprestore(const struct exc=
eption_table_entry *fixup,
> }
> EXPORT_SYMBOL_GPL(ex_handler_fprestore);
>=20
> +static void bogus_uaccess_check(struct pt_regs *regs, int trapnr,
> +                unsigned long fault_addr)
> +{
> +    if (trapnr !=3D X86_TRAP_PF || fault_addr < TASK_SIZE_MAX)
> +        return;
> +    /*
> +     * This is a pagefault in kernel space, on a kernel address, in a
> +     * usercopy function. This can e.g. be caused by improper use of help=
ers
> +     * like __put_user and by improper attempts to access userspace
> +     * addresses in KERNEL_DS regions. The one legitimate exception are
> +     * probe_kernel_{read,write}(), which can be invoked from places like=

> +     * kgdb, /dev/mem (for reading) and privileged BPF code (for reading)=
.
> +     * The probe_kernel_*() functions set the kernel_uaccess_faults_ok fl=
ag
> +     * to tell us that faulting on kernel addresses in a userspace access=
or
> +     * is fine.
> +     */
> +    if (current->kernel_uaccess_faults_ok)
> +        return;
> +    WARN(1, "pagefault on kernel address 0x%lx in non-whitelisted uaccess=
",
> +         fault_addr);
> +}
> +
> +__visible bool ex_handler_uaccess(const struct exception_table_entry *fix=
up,
> +                  struct pt_regs *regs, int trapnr,
> +                  unsigned long fault_addr)
> +{
> +    bogus_uaccess_check(regs, trapnr, fault_addr);
> +    regs->ip =3D ex_fixup_addr(fixup);
> +    return true;
> +}
> +EXPORT_SYMBOL(ex_handler_uaccess);
> +
> __visible bool ex_handler_ext(const struct exception_table_entry *fixup,
> -                  struct pt_regs *regs, int trapnr)
> +                  struct pt_regs *regs, int trapnr,
> +                  unsigned long fault_addr)
> {
>   /* Special hack for uaccess_err */
>   current->thread.uaccess_err =3D 1;
> +    bogus_uaccess_check(regs, trapnr, fault_addr);
>   regs->ip =3D ex_fixup_addr(fixup);
>   return true;
> }
> EXPORT_SYMBOL(ex_handler_ext);
>=20
> __visible bool ex_handler_rdmsr_unsafe(const struct exception_table_entry *=
fixup,
> -                       struct pt_regs *regs, int trapnr)
> +                       struct pt_regs *regs, int trapnr,
> +                       unsigned long fault_addr)
> {
>   if (pr_warn_once("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x=
%lx (%pF)\n",
>            (unsigned int)regs->cx, regs->ip, (void *)regs->ip))
> @@ -134,7 +173,8 @@ __visible bool ex_handler_rdmsr_unsafe(const struct ex=
ception_table_entry *fixup
> EXPORT_SYMBOL(ex_handler_rdmsr_unsafe);
>=20
> __visible bool ex_handler_wrmsr_unsafe(const struct exception_table_entry *=
fixup,
> -                       struct pt_regs *regs, int trapnr)
> +                       struct pt_regs *regs, int trapnr,
> +                       unsigned long fault_addr)
> {
>   if (pr_warn_once("unchecked MSR access error: WRMSR to 0x%x (tried to wr=
ite 0x%08x%08x) at rIP: 0x%lx (%pF)\n",
>            (unsigned int)regs->cx, (unsigned int)regs->dx,
> @@ -148,12 +188,13 @@ __visible bool ex_handler_wrmsr_unsafe(const struct e=
xception_table_entry *fixup
> EXPORT_SYMBOL(ex_handler_wrmsr_unsafe);
>=20
> __visible bool ex_handler_clear_fs(const struct exception_table_entry *fix=
up,
> -                   struct pt_regs *regs, int trapnr)
> +                   struct pt_regs *regs, int trapnr,
> +                   unsigned long fault_addr)
> {
>   if (static_cpu_has(X86_BUG_NULL_SEG))
>       asm volatile ("mov %0, %%fs" : : "rm" (__USER_DS));
>   asm volatile ("mov %0, %%fs" : : "rm" (0));
> -    return ex_handler_default(fixup, regs, trapnr);
> +    return ex_handler_default(fixup, regs, trapnr, fault_addr);
> }
> EXPORT_SYMBOL(ex_handler_clear_fs);
>=20
> @@ -170,7 +211,7 @@ __visible bool ex_has_fault_handler(unsigned long ip)
>   return handler =3D=3D ex_handler_fault;
> }
>=20
> -int fixup_exception(struct pt_regs *regs, int trapnr)
> +int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long fault=
_addr)
> {
>   const struct exception_table_entry *e;
>   ex_handler_t handler;
> @@ -194,7 +235,7 @@ int fixup_exception(struct pt_regs *regs, int trapnr)
>       return 0;
>=20
>   handler =3D ex_fixup_handler(e);
> -    return handler(e, regs, trapnr);
> +    return handler(e, regs, trapnr, fault_addr);
> }
>=20
> extern unsigned int early_recursion_flag;
> @@ -232,7 +273,7 @@ void __init early_fixup_exception(struct pt_regs *regs=
, int trapnr)
>    * Keep in mind that not all vectors actually get here.  Early
>    * fage faults, for example, are special.
>    */
> -    if (fixup_exception(regs, trapnr))
> +    if (fixup_exception(regs, trapnr, 0))
>       return;
>=20
>   if (fixup_bug(regs, trapnr))
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 2aafa6ab6103..96e3e5cf2cfc 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -710,7 +710,7 @@ no_context(struct pt_regs *regs, unsigned long error_c=
ode,
>   int sig;
>=20
>   /* Are we prepared to handle this kernel fault? */
> -    if (fixup_exception(regs, X86_TRAP_PF)) {
> +    if (fixup_exception(regs, X86_TRAP_PF, address)) {
>       /*
>        * Any interrupt that takes a fault gets the fixup. This makes
>        * the below recursive fault logic only apply to a faults from
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 43731fe51c97..b50598761ed4 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -734,6 +734,8 @@ struct task_struct {
>   /* disallow userland-initiated cgroup migration */
>   unsigned            no_cgroup_migration:1;
> #endif
> +    /* usercopy functions may fault on kernel addresses */
> +    unsigned int            kernel_uaccess_faults_ok:1;
>=20
>   unsigned long            atomic_flags; /* Flags requiring atomic access.=
 */
>=20
> diff --git a/mm/maccess.c b/mm/maccess.c
> index ec00be51a24f..e066aa8482af 100644
> --- a/mm/maccess.c
> +++ b/mm/maccess.c
> @@ -30,8 +30,10 @@ long __probe_kernel_read(void *dst, const void *src, si=
ze_t size)
>=20
>   set_fs(KERNEL_DS);
>   pagefault_disable();
> +    current->kernel_uaccess_faults_ok =3D 1;
>   ret =3D __copy_from_user_inatomic(dst,
>           (__force const void __user *)src, size);
> +    current->kernel_uaccess_faults_ok =3D 0;
>   pagefault_enable();
>   set_fs(old_fs);
>=20
> @@ -58,7 +60,9 @@ long __probe_kernel_write(void *dst, const void *src, si=
ze_t size)
>=20
>   set_fs(KERNEL_DS);
>   pagefault_disable();
> +    current->kernel_uaccess_faults_ok =3D 1;
>   ret =3D __copy_to_user_inatomic((__force void __user *)dst, src, size);
> +    current->kernel_uaccess_faults_ok =3D 0;
>   pagefault_enable();
>   set_fs(old_fs);
>=20
> @@ -94,11 +98,13 @@ long strncpy_from_unsafe(char *dst, const void *unsafe=
_addr, long count)
>=20
>   set_fs(KERNEL_DS);
>   pagefault_disable();
> +    current->kernel_uaccess_faults_ok =3D 1;
>=20
>   do {
>       ret =3D __get_user(*dst++, (const char __user __force *)src++);
>   } while (dst[-1] && ret =3D=3D 0 && src - unsafe_addr < count);
>=20
> +    current->kernel_uaccess_faults_ok =3D 0;
>   dst[-1] =3D '\0';
>   pagefault_enable();
>   set_fs(old_fs);
> --=20
> 2.18.0.597.ga71716f1ad-goog
>=20
