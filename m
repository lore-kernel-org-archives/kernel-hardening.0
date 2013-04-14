Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <1365797627-20874-6-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-6-git-send-email-keescook@chromium.org>
Date: Sat, 13 Apr 2013 17:11:56 -0700
Message-ID: <CAE9FiQWXH42Q4Ckhs3sx82MHGNNb_N3GpmWWp3UCgJCMbf7ZMg@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 5/6] x86: kaslr: routines to choose random base offset
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 12, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
> This provides routines for selecting a randomized kernel base offset,
> bounded by the e820 entries. It tries to use RDRAND and falls back to
> RDTSC. If "noaslr" is on the kernel command line, no offset will be used.
>
> Heavily based on work by Dan Rosenberg and Neill Clift.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: Eric Northup <digitaleric@google.com>
> ---
>  arch/x86/boot/compressed/Makefile |    2 +-
>  arch/x86/boot/compressed/aslr.S   |  228 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 229 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/boot/compressed/aslr.S
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 0dac175..feaf203 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -26,7 +26,7 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
>
>  VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>         $(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
> -       $(obj)/piggy.o
> +       $(obj)/piggy.o $(obj)/aslr.o
>
>  $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
>
> diff --git a/arch/x86/boot/compressed/aslr.S b/arch/x86/boot/compressed/aslr.S
> new file mode 100644
> index 0000000..37cdef4
> --- /dev/null
> +++ b/arch/x86/boot/compressed/aslr.S
> @@ -0,0 +1,228 @@
> +/*
> + *  arch/x86/boot/compressed/aslr.S
> + *
> + * Support routine for Kernel Address Space Layout Randomization used by both
> + * the 32 and 64 bit boot code.
> + *
> + */
> +       .text
> +
> +#include <asm/boot.h>
> +#include <asm/asm-offsets.h>
> +#include <asm/cpufeature.h>
> +#include <asm/processor-flags.h>
> +#include <asm/e820.h>
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +
> +       .globl  select_aslr_address
> +       .code32
> +
> +/*
> + * Get the physical memory limit for the run from the physical load position of
> + * the kernel. The kernel loads at LOAD_PHYSICAL_ADDR and we need to know how
> + * much physical memory is available for use after that point to make sure the
> + * relocated kernel will fit. Returns the limit in eax.
> + */
> +get_physical_run_end:
> +       pushl   %edi
> +       pushl   %esi
> +       pushl   %ebx
> +       pushl   %edx
> +       pushl   %ecx
> +       movzbl  BP_e820_entries(%esi), %edi
> +       leal    BP_e820_map(%esi), %esi
> +       testl   %edi, %edi
> +       jz      5f
> +1:     cmpl    $E820_RAM, E820_type(%esi)
> +       jnz     4f
> +       movl    E820_addr(%esi), %eax
> +       movl    E820_addr+4(%esi), %edx
> +       testl   %edx, %edx /* Start address is too big for 32 bit */
> +       jnz     4f
> +       cmpl    $LOAD_PHYSICAL_ADDR, %eax
> +       ja      4f
> +       movl    E820_size(%esi), %ecx
> +       movl    E820_size+4(%esi), %ebx
> +       addl    %eax, %ecx
> +       adcl    %edx, %ebx
> +       jz      2f /* end address not beyond 32bit*/
> +/* For a large run set the limit as 2^32-1 */
> +       xorl    %ecx, %ecx
> +       decl    %ecx
> +       jmp     3f
> +2:     cmpl    $LOAD_PHYSICAL_ADDR, %ecx
> +       jb      4f
> +3:
> +       movl    %ecx, %eax
> +       jmp     6f
> +
> +4:     addl    $E820_entry_size, %esi
> +       decl    %edi
> +       jnz     1b
> +5:     xorl    %eax, %eax /* Fail */
> +6:     popl    %ecx
> +       popl    %edx
> +       popl    %ebx
> +       popl    %esi
> +       popl    %edi
> +       ret
> +
> +/*
> + * Get a random value to be used for the ASLR kernel offset.
> + * Returns the value in eax.
> + */
> +get_aslr_offset:
> +       pushl   %ebx
> +       pushl   %edx
> +       pushl   %ecx
> +       call    find_cmdline_option
> +       testl   %eax, %eax
> +       jne     4f
> +       /* Standard check for cpuid */
> +       pushfl  /* Push original flags */
> +       pushfl
> +       popl    %eax
> +       movl    %eax, %ebx
> +       xorl    $X86_EFLAGS_ID, %eax
> +       pushl   %eax
> +       popfl
> +       pushfl
> +       popl    %eax
> +       popfl   /* Pop original flags */
> +       cmpl    %eax, %ebx
> +       /* Say zero offset if we can't change the flag */
> +       movl    $0, %eax
> +       je      4f
> +
> +       /* Check for cpuid 1 */
> +       cpuid
> +       cmpl    $0x1, %eax
> +       jb      4f
> +
> +       movl    $0x1, %eax
> +       cpuid
> +       xor     %eax, %eax
> +
> +       /* RDRAND is bit 30 */
> +       btl     $(X86_FEATURE_RDRAND & 31), %ecx
> +       jc      1f
> +
> +       /* RDTSC is bit 4 */
> +       btl     $(X86_FEATURE_TSC & 31), %edx
> +       jc      3f
> +
> +       /* Nothing is supported */
> +       jmp     4f
> +1:
> +       /*
> +        * RDRAND sets carry bit on success, otherwise we should try
> +        * again up to 16 times.
> +        */
> +       movl    $0x10, %ecx
> +2:
> +       /* rdrand %eax */
> +       .byte   0x0f, 0xc7, 0xf0
> +       jc      4f
> +       loop    2b
> +
> +       /* Fall through: if RDRAND is supported but fails, use RDTSC,
> +        * which is guaranteed to be supported.
> +        */
> +3:
> +       rdtsc
> +       /*
> +        * Since this is time related get some of the least significant bits
> +        * past the alignment mask
> +       */
> +       shll    $0x0c, %eax
> +       /* Fix the maximal offset allowed */
> +4:     andl    $CONFIG_RANDOMIZE_BASE_MAX_OFFSET-1, %eax
> +       popl    %ecx
> +       popl    %edx
> +       popl    %ebx
> +       ret
> +
> +/*
> + * Select the ASLR address to use. We can get called once either in 32
> + * or 64 bit mode. The latter if we have a 64 bit loader.
> + * Uses ebp as the input base and returns the result in eax.
> + */
> +select_aslr_address:
> +       pushl   %edx
> +       pushl   %ebx
> +       pushl   %ecx
> +       pushl   %edi
> +       call    get_aslr_offset
> +       pushl   %eax
> +       call    get_physical_run_end
> +       movl    %eax, %edx
> +       popl    %eax
> +1:     movl    %ebp, %ebx
> +       addl    %eax, %ebx
> +       movl    BP_kernel_alignment(%esi), %edi
> +       decl    %edi
> +       addl    %edi, %ebx
> +       notl    %edi
> +       andl    %edi, %ebx
> +       /* Make sure we don't copy beyond run */
> +       leal    boot_stack_end(%ebx), %ecx
> +       leal    z_extract_offset(%ecx), %ecx
> +       cmpl    %edx, %ecx
> +       jb      2f
> +       shrl    $1, %eax /* Shink offset */
> +       jne     1b /* Move on if offset zero */
> +       mov     %ebp, %ebx
> +2:     movl    %ebx, %eax
> +       popl    %edi
> +       popl    %ecx
> +       popl    %ebx
> +       popl    %edx
> +       ret

So the code could run when it is 64bit and bzImage64 is loaded above 4G?

Thanks

Yinghai
