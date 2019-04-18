MIME-Version: 1.0
References: <1462963502-11636-1-git-send-email-hecmargi@upv.es>
In-Reply-To: <1462963502-11636-1-git-send-email-hecmargi@upv.es>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 18 Apr 2019 02:45:22 -0500
Message-ID: <CAGXu5jLZ-DgTfokLTqUHOUphO4C1FwHgYDLTA1oB9HBHnH-a1Q@mail.gmail.com>
Subject: Re: [PATCH] x86_64: Disabling read-implies-exec when the stack is executable
Content-Type: text/plain; charset="UTF-8"
To: Hector Marco-Gisbert <hecmargi@upv.es>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, Brian Gerst <brgerst@gmail.com>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Huaitong Han <huaitong.han@intel.com>, Ismael Ripoll Ripoll <iripoll@upv.es>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Jason Gunthorpe <jgg@mellanox.com>, Andi Kleen <ak@linux.intel.com>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 11, 2016 at 5:45 AM Hector Marco-Gisbert <hecmargi@upv.es> wrote:
>
> The READ_IMPLIES_EXEC personality was removed in 2005 for 64-bit processes,
> (commit a3cc2546a54361b86b73557df5b85c4fc3fc27c3 form history.git).
>
> But it's still possible to have all readable areas with EXEC permissions by
> setting the stack as executable in 64-bit ELF executables (also in 32-bit).
>
> This is because the macro elf_read_implies_exec() does not distinguish
> between 32 and 64-bit executables: when the stack is executable then the
> read-implies-exec personality is set (enabled) to the process.
>
> We think that this is not a desirable behaviour, maybe read-implies-exec
> could be used via personality but not by setting the stack as executable in
> the ELF.
>
> For x86_64 processes, is there any reason to disable read-implies-exec
> personality and at the same time enable it when the stack is executable ?
>
> With this patch it's no longer possible to enable the read-implies-exec on
> the process by setting the stack as executable in the PT_GNU_STACK on
> x86_64 executables.
>
> Regarding 32-bits processes, is there any reason to enable
> read-implies-exec by setting the stack as executable instead of using the
> personality on X86_32 or when emulating IA32 on X86_64 ?
>
> If not, I could re-send the patch which removes this possibility.
>
>
> Signed-off-by: Hector Marco-Gisbert <hecmargi@upv.es>
> Acked-by: Ismael Ripoll Ripoll <iripoll@upv.es>
> ---
>  arch/x86/include/asm/elf.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
> index 15340e3..87fd15e 100644
> --- a/arch/x86/include/asm/elf.h
> +++ b/arch/x86/include/asm/elf.h
> @@ -271,8 +271,8 @@ extern int force_personality32;
>   * An executable for which elf_read_implies_exec() returns TRUE will
>   * have the READ_IMPLIES_EXEC personality flag set automatically.
>   */
> -#define elf_read_implies_exec(ex, executable_stack)    \
> -       (executable_stack != EXSTACK_DISABLE_X)
> +#define elf_read_implies_exec(ex, executable_stack) \
> +       (mmap_is_ia32() ? (executable_stack != EXSTACK_DISABLE_X) : 0)
>
>  struct task_struct;
>
> --
> 1.9.1
>

*thread necromancy*

I'd still like to see this get landed. READ_IMPLIES_EXEC is way too
powerful (it impacts, for example, mmap() regions of device driver
memory, forcing drivers to not be able to disallow VM_EXEC[1]).

The only case it could break is on an AMD K8 (Athlon only, I assume?),
which seems unlikely to have a modern kernel run on it. If there is
still concern, then we could just test against the NX CPU feature:

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 69c0f892e310..367cd36259a4 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -280,10 +280,12 @@ extern u32 elf_hwcap2;

 /*
  * An executable for which elf_read_implies_exec() returns TRUE will
- * have the READ_IMPLIES_EXEC personality flag set automatically.
+ * have the READ_IMPLIES_EXEC personality flag set automatically when
+ * a CPU did not support NX or is using a 32-bit memory layout.
  */
-#define elf_read_implies_exec(ex, executable_stack)    \
-       (executable_stack != EXSTACK_DISABLE_X)
+#define elf_read_implies_exec(ex, executable_stack)            \
+       (mmap_is_ia32() || !(__supported_pte_mask & _PAGE_NX) ? \
+               (executable_stack != EXSTACK_DISABLE_X) : 0)

 struct task_struct;


Additionally, I think architectures that always had NX (arm64) should
entirely remove their elf_read_implies_exec() macro (defaulting to the
removal of the stack-marking-based READ_IMPLIES_EXEC enabling):

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 6adc1a90e7e6..87c2dd468eea 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -107,8 +107,6 @@
  */
 #define elf_check_arch(x)              ((x)->e_machine == EM_AARCH64)

-#define elf_read_implies_exec(ex,stk)  (stk != EXSTACK_DISABLE_X)
-
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE      PAGE_SIZE


Thoughts?

-Kees

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com

--
Kees Cook
