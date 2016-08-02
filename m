Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Tue, 02 Aug 2016 02:38:21 +0200
Message-ID: <1771166.6Dy2cXd33p@vostro.rjw.lan>
In-Reply-To: <1470071280-78706-3-git-send-email-thgarnie@google.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <1470071280-78706-3-git-send-email-thgarnie@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] Re: [PATCH v1 2/2] x86/power/64: Fix __PAGE_OFFSET usage on restore
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>, x86@kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Monday, August 01, 2016 10:08:00 AM Thomas Garnier wrote:
> When KASLR memory randomization is used, __PAGE_OFFSET is a global
> variable changed during boot. The assembly code was using the variable
> as an immediate value to calculate the cr3 physical address. The
> physical address was incorrect resulting to a GP fault.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/power/hibernate_asm_64.S | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
> index 8eee0e9..8db4905 100644
> --- a/arch/x86/power/hibernate_asm_64.S
> +++ b/arch/x86/power/hibernate_asm_64.S
> @@ -23,6 +23,16 @@
>  #include <asm/processor-flags.h>
>  #include <asm/frame.h>
>  
> +/*
> + * A global variable holds the page_offset when KASLR memory randomization
> + * is enabled.
> + */
> +#ifdef CONFIG_RANDOMIZE_MEMORY
> +#define __PAGE_OFFSET_REF __PAGE_OFFSET
> +#else
> +#define __PAGE_OFFSET_REF $__PAGE_OFFSET
> +#endif
> +
>  ENTRY(swsusp_arch_suspend)
>  	movq	$saved_context, %rax
>  	movq	%rsp, pt_regs_sp(%rax)
> @@ -72,7 +82,7 @@ ENTRY(restore_image)
>  	/* code below has been relocated to a safe page */
>  ENTRY(core_restore_code)
>  	/* switch to temporary page tables */
> -	movq	$__PAGE_OFFSET, %rcx
> +	movq	__PAGE_OFFSET_REF, %rcx
>  	subq	%rcx, %rax
>  	movq	%rax, %cr3
>  	/* flush TLB */
> 

I'm not particularly liking the #ifdefs and they won't be really
necessary if the subtraction is carried out by the C code IMO.

What about the patch below instead?

---
 arch/x86/power/hibernate_64.c     |   18 +++++++++---------
 arch/x86/power/hibernate_asm_64.S |    2 --
 2 files changed, 9 insertions(+), 11 deletions(-)

Index: linux-pm/arch/x86/power/hibernate_asm_64.S
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_asm_64.S
+++ linux-pm/arch/x86/power/hibernate_asm_64.S
@@ -72,8 +72,6 @@ ENTRY(restore_image)
 	/* code below has been relocated to a safe page */
 ENTRY(core_restore_code)
 	/* switch to temporary page tables */
-	movq	$__PAGE_OFFSET, %rcx
-	subq	%rcx, %rax
 	movq	%rax, %cr3
 	/* flush TLB */
 	movq	%rbx, %rcx
Index: linux-pm/arch/x86/power/hibernate_64.c
===================================================================
--- linux-pm.orig/arch/x86/power/hibernate_64.c
+++ linux-pm/arch/x86/power/hibernate_64.c
@@ -37,11 +37,11 @@ unsigned long jump_address_phys;
  */
 unsigned long restore_cr3 __visible;
 
-pgd_t *temp_level4_pgt __visible;
+unsigned long temp_level4_pgt __visible;
 
 unsigned long relocated_restore_code __visible;
 
-static int set_up_temporary_text_mapping(void)
+static int set_up_temporary_text_mapping(pgd_t *pgd)
 {
 	pmd_t *pmd;
 	pud_t *pud;
@@ -71,7 +71,7 @@ static int set_up_temporary_text_mapping
 		__pmd((jump_address_phys & PMD_MASK) | __PAGE_KERNEL_LARGE_EXEC));
 	set_pud(pud + pud_index(restore_jump_address),
 		__pud(__pa(pmd) | _KERNPG_TABLE));
-	set_pgd(temp_level4_pgt + pgd_index(restore_jump_address),
+	set_pgd(pgd + pgd_index(restore_jump_address),
 		__pgd(__pa(pud) | _KERNPG_TABLE));
 
 	return 0;
@@ -90,15 +90,16 @@ static int set_up_temporary_mappings(voi
 		.kernel_mapping = true,
 	};
 	unsigned long mstart, mend;
+	pgd_t *pgd;
 	int result;
 	int i;
 
-	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
-	if (!temp_level4_pgt)
+	pgd = (pgd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pgd)
 		return -ENOMEM;
 
 	/* Prepare a temporary mapping for the kernel text */
-	result = set_up_temporary_text_mapping();
+	result = set_up_temporary_text_mapping(pgd);
 	if (result)
 		return result;
 
@@ -107,13 +108,12 @@ static int set_up_temporary_mappings(voi
 		mstart = pfn_mapped[i].start << PAGE_SHIFT;
 		mend   = pfn_mapped[i].end << PAGE_SHIFT;
 
-		result = kernel_ident_mapping_init(&info, temp_level4_pgt,
-						   mstart, mend);
-
+		result = kernel_ident_mapping_init(&info, pgd, mstart, mend);
 		if (result)
 			return result;
 	}
 
+	temp_level4_pgt = (unsigned long)pgd - __PAGE_OFFSET;
 	return 0;
 }
 
