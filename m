Date: Wed, 15 Feb 2017 14:58:24 +0100
From: Borislav Petkov <bp@suse.de>
Message-ID: <20170215135824.tflwuf3esu2npwwo@pd.tnic>
References: <20170214194259.75960-1-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170214194259.75960-1-thgarnie@google.com>
Subject: [kernel-hardening] Re: [PATCH v3 1/4] x86/mm: Adapt MODULES_END based on Fixmap section
 size
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-pm@vger.kernel.org, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 11:42:56AM -0800, Thomas Garnier wrote:
> This patch aligns MODULES_END to the beginning of the Fixmap section.
> It optimizes the space available for both sections. The address is
> pre-computed based on the number of pages required by the Fixmap
> section.
> 
> It will allow GDT remapping in the Fixmap section. The current
> MODULES_END static address does not provide enough space for the kernel
> to support a large number of processors.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
> Based on next-20170213
> ---
>  arch/x86/include/asm/fixmap.h           | 8 ++++++++
>  arch/x86/include/asm/pgtable_64_types.h | 3 ---
>  arch/x86/kernel/module.c                | 1 +
>  arch/x86/mm/dump_pagetables.c           | 1 +
>  arch/x86/mm/kasan_init_64.c             | 1 +
>  5 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
> index 8554f960e21b..20231189e0e3 100644
> --- a/arch/x86/include/asm/fixmap.h
> +++ b/arch/x86/include/asm/fixmap.h
> @@ -132,6 +132,14 @@ enum fixed_addresses {
>  
>  extern void reserve_top_address(unsigned long reserve);
>  
> +/* On 64-bit, the module sections ends with the start of the fixmap */
> +#ifdef CONFIG_X86_64
> +#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
> +#define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
> +#define MODULES_LEN   (MODULES_END - MODULES_VADDR)
> +#endif /* CONFIG_X86_64 */

JFYI: so there's another patchset which adds KERNEL_MAPPING_SIZE:

https://lkml.kernel.org/r/1486040077-3719-1-git-send-email-bhe@redhat.com

and makes it a 1G, i.e., the KASLR default. I guess the above will have
to be KERNEL_MAPPING_SIZE then.

And why are you moving those to fixmap.h? What's wrong with
including fixmap.h into pgtable_64_types.h so that you can get
__end_of_fixed_addresses?

FWIW, I didn't even have to add any includes with my .config, i.e., that builds:

---
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 3a264200c62f..eda7fa856fa9 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -67,7 +67,7 @@ typedef struct { pteval_t pte; } pte_t;
 #endif /* CONFIG_RANDOMIZE_MEMORY */
 #define VMALLOC_END	(VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
 #define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
-#define MODULES_END      _AC(0xffffffffff000000, UL)
+#define MODULES_END   __fix_to_virt(__end_of_fixed_addresses + 1)
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 #define ESPFIX_PGD_ENTRY _AC(-2, UL)
 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
---

but I wouldn't be surprised if some strange configuration would need it.

>  #define FIXADDR_SIZE	(__end_of_permanent_fixed_addresses << PAGE_SHIFT)
>  #define FIXADDR_START		(FIXADDR_TOP - FIXADDR_SIZE)
>  
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 3a264200c62f..de8bace10200 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -66,9 +66,6 @@ typedef struct { pteval_t pte; } pte_t;
>  #define VMEMMAP_START	__VMEMMAP_BASE
>  #endif /* CONFIG_RANDOMIZE_MEMORY */
>  #define VMALLOC_END	(VMALLOC_START + _AC((VMALLOC_SIZE_TB << 40) - 1, UL))
> -#define MODULES_VADDR    (__START_KERNEL_map + KERNEL_IMAGE_SIZE)
> -#define MODULES_END      _AC(0xffffffffff000000, UL)

How much of an ABI breakage would that be? See
Documentation/x86/x86_64/mm.txt.

With my .config MODULES_END becomes 0xffffffffff1fe000 and it'll remain
dynamic depending on .config. No idea how much in userspace relies on
MODULES_END being static 0xffffffffff000000...

Hmm.

-- 
Regards/Gruss,
    Boris.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
-- 
