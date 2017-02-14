From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 14 Feb 2017 20:52:37 +0000
Message-Id: <1487105558-21897-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 4/5] arm64: mmu: map .text as read-only from the outset
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, keescook@chromium.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Now that alternatives patching code no longer relies on the primary
mapping of .text being writable, we can remove the code that removes
the writable permissions post-init time, and map it read-only from
the outset.

To preserve the existing behavior under rodata=off, which is relied
upon by external debuggers to manage software breakpoints (as pointed
out by Mark), add an early_param() check for rodata=, and use RWX
permissions if it set to 'off'.

Reviewed-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b7ce0b9ad096..70a492b36fe7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -442,9 +442,6 @@ void mark_rodata_ro(void)
 {
 	unsigned long section_size;
 
-	section_size = (unsigned long)_etext - (unsigned long)_text;
-	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
-			    section_size, PAGE_KERNEL_ROX);
 	/*
 	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
 	 * to cover NOTES and EXCEPTION_TABLE.
@@ -477,6 +474,12 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
 	vm_area_add_early(vma);
 }
 
+static int __init parse_rodata(char *arg)
+{
+	return strtobool(arg, &rodata_enabled);
+}
+early_param("rodata", parse_rodata);
+
 /*
  * Create fine-grained mappings for the kernel.
  */
@@ -484,7 +487,9 @@ static void __init map_kernel(pgd_t *pgd)
 {
 	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
 
-	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
+	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
+
+	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
 	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
 	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
 			   &vmlinux_init);
-- 
2.7.4
