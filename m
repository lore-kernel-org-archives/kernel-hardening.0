From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Sat,  4 Mar 2017 14:30:47 +0000
Message-Id: <1488637848-13588-6-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1488637848-13588-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v4 5/6] arm64: mmu: apply strict permissions to .init.text and .init.data
To: linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, keescook@chromium.org, andre.przywara@arm.com, james.morse@arm.com, suzuki.poulose@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

To avoid having mappings that are writable and executable at the same
time, split the init region into a .init.text region that is mapped
read-only, and a .init.data region that is mapped non-executable.

This is possible now that the alternative patching occurs via the linear
mapping, and the linear alias of the init region is always mapped writable
(but never executable).

Since the alternatives descriptions themselves are read-only data, move
those into the .init.text region.

Reviewed-by: Laura Abbott <labbott@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/sections.h |  3 ++-
 arch/arm64/kernel/vmlinux.lds.S   | 25 +++++++++++++-------
 arch/arm64/mm/mmu.c               | 12 ++++++----
 3 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/sections.h
index 4e7e7067afdb..22582819b2e5 100644
--- a/arch/arm64/include/asm/sections.h
+++ b/arch/arm64/include/asm/sections.h
@@ -24,7 +24,8 @@ extern char __hibernate_exit_text_start[], __hibernate_exit_text_end[];
 extern char __hyp_idmap_text_start[], __hyp_idmap_text_end[];
 extern char __hyp_text_start[], __hyp_text_end[];
 extern char __idmap_text_start[], __idmap_text_end[];
+extern char __initdata_begin[], __initdata_end[];
+extern char __inittext_begin[], __inittext_end[];
 extern char __irqentry_text_start[], __irqentry_text_end[];
 extern char __mmuoff_data_start[], __mmuoff_data_end[];
-
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index b8deffa9e1bf..2c93d259046c 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -143,12 +143,27 @@ SECTIONS
 
 	. = ALIGN(SEGMENT_ALIGN);
 	__init_begin = .;
+	__inittext_begin = .;
 
 	INIT_TEXT_SECTION(8)
 	.exit.text : {
 		ARM_EXIT_KEEP(EXIT_TEXT)
 	}
 
+	. = ALIGN(4);
+	.altinstructions : {
+		__alt_instructions = .;
+		*(.altinstructions)
+		__alt_instructions_end = .;
+	}
+	.altinstr_replacement : {
+		*(.altinstr_replacement)
+	}
+
+	. = ALIGN(PAGE_SIZE);
+	__inittext_end = .;
+	__initdata_begin = .;
+
 	.init.data : {
 		INIT_DATA
 		INIT_SETUP(16)
@@ -164,15 +179,6 @@ SECTIONS
 
 	PERCPU_SECTION(L1_CACHE_BYTES)
 
-	. = ALIGN(4);
-	.altinstructions : {
-		__alt_instructions = .;
-		*(.altinstructions)
-		__alt_instructions_end = .;
-	}
-	.altinstr_replacement : {
-		*(.altinstr_replacement)
-	}
 	.rela : ALIGN(8) {
 		*(.rela .rela*)
 	}
@@ -181,6 +187,7 @@ SECTIONS
 	__rela_size	= SIZEOF(.rela);
 
 	. = ALIGN(SEGMENT_ALIGN);
+	__initdata_end = .;
 	__init_end = .;
 
 	_data = .;
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index edd982f88714..0612573ef869 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -459,14 +459,18 @@ early_param("rodata", parse_rodata);
  */
 static void __init map_kernel(pgd_t *pgd)
 {
-	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_init, vmlinux_data;
+	static struct vm_struct vmlinux_text, vmlinux_rodata, vmlinux_inittext,
+				vmlinux_initdata, vmlinux_data;
 
 	pgprot_t text_prot = rodata_enabled ? PAGE_KERNEL_ROX : PAGE_KERNEL_EXEC;
 
 	map_kernel_segment(pgd, _text, _etext, text_prot, &vmlinux_text);
-	map_kernel_segment(pgd, __start_rodata, __init_begin, PAGE_KERNEL, &vmlinux_rodata);
-	map_kernel_segment(pgd, __init_begin, __init_end, PAGE_KERNEL_EXEC,
-			   &vmlinux_init);
+	map_kernel_segment(pgd, __start_rodata, __inittext_begin, PAGE_KERNEL,
+			   &vmlinux_rodata);
+	map_kernel_segment(pgd, __inittext_begin, __inittext_end, text_prot,
+			   &vmlinux_inittext);
+	map_kernel_segment(pgd, __initdata_begin, __initdata_end, PAGE_KERNEL,
+			   &vmlinux_initdata);
 	map_kernel_segment(pgd, _data, _end, PAGE_KERNEL, &vmlinux_data);
 
 	if (!pgd_val(*pgd_offset_raw(pgd, FIXADDR_START))) {
-- 
2.7.4
