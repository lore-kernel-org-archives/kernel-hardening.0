From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 21:52:02 +0100
Message-Id: <1489092729-16871-5-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489092729-16871-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v6 04/11] arm64: mmu: map .text as read-only from the outset
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index df377fbe464e..300e98e8cd63 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -416,9 +416,6 @@ void mark_rodata_ro(void)
 {
 	unsigned long section_size;
 
-	section_size = (unsigned long)_etext - (unsigned long)_text;
-	update_mapping_prot(__pa_symbol(_text), (unsigned long)_text,
-			    section_size, PAGE_KERNEL_ROX);
 	/*
 	 * mark .rodata as read only. Use __init_begin rather than __end_rodata
 	 * to cover NOTES and EXCEPTION_TABLE.
@@ -451,6 +448,12 @@ static void __init map_kernel_segment(pgd_t *pgd, void *va_start, void *va_end,
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
@@ -458,7 +461,14 @@ static void __init map_kernel(pgd_t *pgd)
 {
 	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
 
-	map_kernel_segment(pgd, _text, _etext, PAGE_KERNEL_EXEC, &vmlinux_text);
+	/*
+	 * External debuggers may need to write directly to the text
+	 * mapping to install SW breakpoints. Allow this (only) when
+	 * explicitly requested with rodata=off.
+	 */
+	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
+
+	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
 	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
 	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
 			   &vmlinux_init);
-- 
2.7.4
