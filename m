Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: yhlu.kernel@gmail.com
In-Reply-To: <1365797627-20874-7-git-send-email-keescook@chromium.org>
References: <1365797627-20874-1-git-send-email-keescook@chromium.org>
	<1365797627-20874-7-git-send-email-keescook@chromium.org>
Date: Sat, 13 Apr 2013 17:37:20 -0700
Message-ID: <CAE9FiQXGjJCDAo41jxpy9bZJ2svKy8YY-zX7O4YDZPhKo7M43g@mail.gmail.com>
From: Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 6/6] x86: kaslr: relocate base offset at boot
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 12, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
[...]
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index c1d383d..fc37910 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -59,7 +59,7 @@ ENTRY(startup_32)
>  1:
>
>  /*
> - * Calculate the delta between where we were compiled to run
> + * Calculate the delta between where we were linked to load
>   * at and where we were actually loaded at.  This can only be done
>   * with a short local call on x86.  Nothing  else will tell us what
>   * address we are running at.  The reserved chunk of the real-mode
> @@ -78,10 +78,10 @@ ENTRY(startup_32)
>
>         call    verify_cpu
>         testl   %eax, %eax
> -       jnz     no_longmode
> +       jnz     hang
>
>  /*
> - * Compute the delta between where we were compiled to run at
> + * Compute the delta between where we were linked to load at
>   * and where the code will actually run at.
>   *
>   * %ebp contains the address we are loaded at by the boot loader and %ebx
> @@ -90,15 +90,32 @@ ENTRY(startup_32)
>   */
>
>  #ifdef CONFIG_RELOCATABLE
> +#ifdef CONFIG_RANDOMIZE_BASE
> +       call    select_aslr_address /* Select ASLR offset */
> +       movl    %eax, %ebx
> +       /* LOAD_PHYSICAL_ADDR is the minimum safe address we can
> +        * decompress at */
> +       cmpl    $LOAD_PHYSICAL_ADDR, %ebx
> +       jae     1f
> +       movl    $LOAD_PHYSICAL_ADDR, %ebx
> +#else /* CONFIG_RANDOMIZE_BASE */
>         movl    %ebp, %ebx
>         movl    BP_kernel_alignment(%esi), %eax
>         decl    %eax
>         addl    %eax, %ebx
>         notl    %eax
>         andl    %eax, %ebx
> -#else
> +#endif /* CONFIG_RANDOMIZE_BASE */
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +1:     movl    %ebx, %eax
> +       subl    $LOAD_PHYSICAL_ADDR, %eax
> +        movl   %eax, aslr_offset(%ebp)
> +       incl    aslr_in_32bit(%ebp) /* say 32 bit code ran */
> +#endif /* CONFIG_RANDOMIZE_BASE */
> +#else /* CONFIG_RELOCATABLE */
>         movl    $LOAD_PHYSICAL_ADDR, %ebx
> -#endif
> +#endif /* CONFIG_RELOCATABLE */
>
>         /* Target address to relocate to for decompression */
>         addl    $z_extract_offset, %ebx
> @@ -266,14 +283,30 @@ preferred_addr:
>         /* Start with the delta to where the kernel will run at. */
>  #ifdef CONFIG_RELOCATABLE
>         leaq    startup_32(%rip) /* - $startup_32 */, %rbp
> +#ifdef CONFIG_RANDOMIZE_BASE
> +       leaq    boot_stack_end(%rip), %rsp
> +       testl   $1, aslr_in_32bit(%rip)
> +       jne     1f
> +       call    select_aslr_address
> +       movq    %rax, %rbp

select_aslr_address only play %ebp, so you assume bzImage is loaded under 4G?

can you just run slect_aslr_address in 64bit only?

> +       jmp     2f
> +1:     movl    aslr_offset(%rip), %eax
> +       addq    %rax, %rbp
> +       /* LOAD_PHYSICAL_ADDR is the minimum safe address we can
> +        * decompress at. */
> +       cmpq    $LOAD_PHYSICAL_ADDR, %rbp
> +       jae     2f
> +       movq    $LOAD_PHYSICAL_ADDR, %rbp

should use old value before select_alsr_addr?

> +2:
> +#endif /* CONFIG_RANDOMIZE_BASE */
>         movl    BP_kernel_alignment(%rsi), %eax
>         decl    %eax
>         addq    %rax, %rbp
>         notq    %rax
>         andq    %rax, %rbp
> -#else
> +#else /* CONFIG_RELOCATABLE */
>         movq    $LOAD_PHYSICAL_ADDR, %rbp
> -#endif
> +#endif /* CONFIG_RELOCATABLE */
>
>         /* Target address to relocate to for decompression */
>         leaq    z_extract_offset(%rbp), %rbx
> @@ -343,13 +376,85 @@ relocated:
>         call    decompress_kernel
>         popq    %rsi
>
> +#ifdef CONFIG_RANDOMIZE_BASE
> +/*
> + * Find the address of the relocations.
> + */
> +       leaq    z_output_len(%rbp), %rdi
> +
> +/*
> + * Calculate the delta between where vmlinux was linked to load
> + * and where it was actually loaded.
> + */
> +       movq    %rbp, %rbx
> +       subq    $LOAD_PHYSICAL_ADDR, %rbx
> +       je      3f      /* Nothing to be done if loaded at linked addr. */
> +/*
> + * The kernel contains a table of relocation addresses. Those addresses
> + * have the final load address of the kernel in virtual memory.
> + * We are currently working in the self map. So we need to create an
> + * adjustment for kernel memory addresses to the self map. This will
> + * involve subtracting out the base address of the kernel.
> + */
> +       movq    $-__START_KERNEL_map, %rdx /* Literal is too big for add etc */
> +       addq    %rbx, %rdx
> +/*
> + * Process relocations. 32 bit relocations first then 64 bit after.
> + * Two sets of binary relocations are added to the end of the
> + * kernel before compression. Each relocation table entry is the kernel
> + * address of the location which needs to be updated stored as a 32 bit
> + * value which is sign extended to 64 bits.
> + *
> + * Format is:
> + *
> + * kernel bits...
> + * 0 - zero terminator for 64 bit relocations
> + * 64 bit relocation repeated
> + * 0 - zero terminator for 32 bit relocations
> + * 32 bit relocation repeated
> + *
> + * So we work backwards from the end of the decompressed image.
> + */
> +1:     subq    $4, %rdi
> +       movslq  (%rdi), %rcx
> +       testq   %rcx, %rcx
> +       je      2f
> +       addq    %rdx, %rcx
> +/*
> + * Relocation can't be before the image or
> + * after the current position of the current relocation.
> + * This is a cheap bounds check. It could be more exact
> + * and limit to the end of the image prior to the relocations
> + * but allowing relocations themselves to be fixed up will not
> + * do any harm.
> + */
> +       cmpq    %rbp, %rcx
> +       jb      hang
> +       cmpq    %rdi, %rcx
> +       jae     hang
> +       addl    %ebx, (%rcx)    /* 32 bit relocation */
> +       jmp     1b
> +2:     subq    $4, %rdi
> +       movslq  (%rdi), %rcx
> +       testq   %rcx, %rcx
> +       je      3f
> +       addq    %rdx, %rcx
> +       cmpq    %rbp, %rcx
> +       jb      hang
> +       cmpq    %rdi, %rcx
> +       jae     hang
> +       addq    %rbx, (%rcx)    /* 64 bit relocation */
> +       jmp     2b
> +3:
> +#endif /* CONFIG_RANDOMIZE_BASE */

so decompress code position is changed?

You may push out bss and other data area of run-time kernel of limit
that boot loader
chose according to setup_header.init_size.
aka that make those area overlap with ram hole or other area like
boot command line or initrd....


Thanks

Yinghai
