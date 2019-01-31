From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 18/27] xen: Adapt assembly for PIE support
Date: Thu, 31 Jan 2019 11:24:25 -0800
Message-Id: <20190131192533.34130-19-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Stefano Stabellini <sstabellini@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Thomas Garnier <thgarnie@google.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joerg Roedel <jroedel@suse.de>, "H.J. Lu" <hjl.tools@gmail.com>, Jordan Borgner <mail@jordan-borgner.de>, xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use the new _ASM_MOVABS macro which get a
symbol reference while being PIE compatible. Adapt the relocation tool
to ignore 32-bit Xen code.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/platform/pvh/head.S | 14 ++++++++++----
 arch/x86/tools/relocs.c      | 16 +++++++++++++++-
 arch/x86/xen/xen-head.S      | 11 ++++++-----
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/pvh/head.S b/arch/x86/platform/pvh/head.S
index 1f8825bbaffb..e52d8b31e01d 100644
--- a/arch/x86/platform/pvh/head.S
+++ b/arch/x86/platform/pvh/head.S
@@ -103,8 +103,8 @@ ENTRY(pvh_start_xen)
 	call xen_prepare_pvh
 
 	/* startup_64 expects boot_params in %rsi. */
-	mov $_pa(pvh_bootparams), %rsi
-	mov $_pa(startup_64), %rax
+	movabs $_pa(pvh_bootparams), %rsi
+	movabs $_pa(startup_64), %rax
 	jmp *%rax
 
 #else /* CONFIG_X86_64 */
@@ -150,10 +150,16 @@ END(pvh_start_xen)
 
 	.section ".init.data","aw"
 	.balign 8
+	/*
+	 * Use an ASM_PTR (quad on x64) for _pa(gdt_start) because PIE requires
+	 * a pointer size storage value before applying the relocation. On
+	 * 32-bit _ASM_PTR will be a long which is aligned the space needed for
+	 * relocation.
+	 */
 gdt:
 	.word gdt_end - gdt_start
-	.long _pa(gdt_start)
-	.word 0
+	_ASM_PTR _pa(gdt_start)
+	.balign 8
 gdt_start:
 	.quad 0x0000000000000000            /* NULL descriptor */
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 2a3c703218cc..1b5ee38446b6 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -837,6 +837,16 @@ static int is_percpu_sym(ElfW(Sym) *sym, const char *symname)
 		strncmp(symname, "init_per_cpu_", 13);
 }
 
+/*
+ * Check if the 32-bit relocation is within the xenpvh 32-bit code.
+ * If so, ignores it.
+ */
+static int is_in_xenpvh_assembly(Elf_Addr offset)
+{
+	Elf_Sym *sym = sym_lookup("pvh_start_xen");
+	return sym && (offset >= sym->st_value) &&
+		(offset < (sym->st_value + sym->st_size));
+}
 
 static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		      const char *symname)
@@ -909,8 +919,12 @@ static int do_reloc64(struct section *sec, Elf_Rel *rel, ElfW(Sym) *sym,
 		 * the relocations are processed.
 		 * Make sure that the offset will fit.
 		 */
-		if (r_type != R_X86_64_64 && (int32_t)offset != (int64_t)offset)
+		if (r_type != R_X86_64_64 &&
+		    (int32_t)offset != (int64_t)offset) {
+			if (is_in_xenpvh_assembly(offset))
+				break;
 			die("Relocation offset doesn't fit in 32 bits\n");
+		}
 
 		if (r_type == R_X86_64_64)
 			add_reloc(&relocs64, offset);
diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 5077ead5e59c..4418ff0a1d96 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -28,14 +28,15 @@ ENTRY(startup_xen)
 
 	/* Clear .bss */
 	xor %eax,%eax
-	mov $__bss_start, %_ASM_DI
-	mov $__bss_stop, %_ASM_CX
+	_ASM_MOVABS $__bss_start, %_ASM_DI
+	_ASM_MOVABS $__bss_stop, %_ASM_CX
 	sub %_ASM_DI, %_ASM_CX
 	shr $__ASM_SEL(2, 3), %_ASM_CX
 	rep __ASM_SIZE(stos)
 
-	mov %_ASM_SI, xen_start_info
-	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
+	_ASM_MOVABS $xen_start_info, %_ASM_AX
+	_ASM_MOV %_ASM_SI, (%_ASM_AX)
+	_ASM_MOVABS $init_thread_union+THREAD_SIZE, %_ASM_SP
 
 #ifdef CONFIG_X86_64
 	/* Set up %gs.
@@ -46,7 +47,7 @@ ENTRY(startup_xen)
 	 * init data section till per cpu areas are set up.
 	 */
 	movl	$MSR_GS_BASE,%ecx
-	movq	$INIT_PER_CPU_VAR(irq_stack_union),%rax
+	movabsq	$INIT_PER_CPU_VAR(irq_stack_union),%rax
 	cdq
 	wrmsr
 #endif
-- 
2.20.1.495.gaa96b0ce6b-goog
