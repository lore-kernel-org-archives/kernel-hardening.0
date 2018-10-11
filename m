From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 2/7] x86/modules: Add rlimit checking for x86 modules
Date: Thu, 11 Oct 2018 16:31:12 -0700
Message-Id: <20181011233117.7883-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
References: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds in the rlimit checking for the x86 module allocator.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgtable_32_types.h | 3 +++
 arch/x86/include/asm/pgtable_64_types.h | 2 ++
 arch/x86/kernel/module.c                | 7 ++++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable_32_types.h b/arch/x86/include/asm/pgtable_32_types.h
index b0bc0fff5f1f..185e382fa8c3 100644
--- a/arch/x86/include/asm/pgtable_32_types.h
+++ b/arch/x86/include/asm/pgtable_32_types.h
@@ -68,6 +68,9 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #define MODULES_END	VMALLOC_END
 #define MODULES_LEN	(MODULES_VADDR - MODULES_END)
 
+/* Half of 128MB vmalloc space */
+#define MODSPACE_LIMIT (1 << 25)
+
 #define MAXMEM	(VMALLOC_END - PAGE_OFFSET - __VMALLOC_RESERVE)
 
 #endif /* _ASM_X86_PGTABLE_32_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 04edd2d58211..c256931f4667 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -143,6 +143,8 @@ extern unsigned int ptrs_per_p4d;
 #define MODULES_END		_AC(0xffffffffff000000, UL)
 #define MODULES_LEN		(MODULES_END - MODULES_VADDR)
 
+#define MODSPACE_LIMIT 		(MODULES_LEN / 2)
+
 #define ESPFIX_PGD_ENTRY	_AC(-2, UL)
 #define ESPFIX_BASE_ADDR	(ESPFIX_PGD_ENTRY << P4D_SHIFT)
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index f58336af095c..5eb3f9c5a976 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -84,16 +84,21 @@ void *module_alloc(unsigned long size)
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
 
+	if (check_inc_mod_rlimit(size))
+		return NULL;
+
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL,
 				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
-		vfree(p);
+		module_memfree(p);
 		return NULL;
 	}
 
+	update_mod_rlimit(p, size);
+
 	return p;
 }
 
-- 
2.17.1
