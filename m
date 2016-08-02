Reply-To: kernel-hardening@lists.openwall.com
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Date: Wed, 03 Aug 2016 01:19:26 +0200
Message-ID: <2464745.UmGP58NeXC@vostro.rjw.lan>
In-Reply-To: <CAJZ5v0hiZwugdV6OjA7hAHAv5jhjgJM1vPAW-RHUHud0F=5KsQ@mail.gmail.com>
References: <1470071280-78706-1-git-send-email-thgarnie@google.com> <CAJcbSZFC-qeEySJYO9DFs=HfE087QHROW=opDRCmZo2WXB1gqw@mail.gmail.com> <CAJZ5v0hiZwugdV6OjA7hAHAv5jhjgJM1vPAW-RHUHud0F=5KsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Subject: [kernel-hardening] [PATCH] x86/power/64: Do not refer to __PAGE_OFFSET from assembly code
To: the arch/x86 maintainers <x86@kernel.org>, Linux PM list <linux-pm@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Yinghai Lu <yinghai@kernel.org>, Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

When CONFIG_RANDOMIZE_MEMORY is set on x86-64, __PAGE_OFFSET becomes
a variable and using it as a symbol in the image memory restoration
assembly code under core_restore_code is not correct any more.

To avoid that problem, modify set_up_temporary_mappings() to compute
the physical address of the temporary page tables and store it in
temp_level4_pgt, so that the value of that variable is ready to be
written into CR3.  Then, the assembly code doesn't have to worry
about converting that value into a physical address and things work
regardless of whether or not CONFIG_RANDOMIZE_MEMORY is set.

Reported-and-tested-by: Thomas Garnier <thgarnie@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

I'm going to queue this up, so if there are any objections/concerns about it,
please let me know ASAP.

Thanks,
Rafael

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
 
