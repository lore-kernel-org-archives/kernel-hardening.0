From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [RFC PATCH v5 02/12] __wr_after_init: linker section and attribute
Date: Thu, 14 Feb 2019 00:41:31 +0200
Message-Id: <c4c7df22ab55956bd8b0fee8bb38c3f543b478a0.1550097697.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1550097697.git.igor.stoppa@huawei.com>
References: <cover.1550097697.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Introduce a linker section and a matching attribute for statically
allocated write rare data. The attribute is named "__wr_after_init".
After the init phase is completed, this section will be modifiable only by
invoking write rare functions.
The section occupies a set of full pages, since the granularity
available for write protection is of one memory page.

The functionality is automatically activated by any architecture that sets
CONFIG_ARCH_HAS_PRMEM

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>

CC: Andy Lutomirski <luto@amacapital.net>
CC: Nadav Amit <nadav.amit@gmail.com>
CC: Matthew Wilcox <willy@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Kees Cook <keescook@chromium.org>
CC: Dave Hansen <dave.hansen@linux.intel.com>
CC: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Thiago Jung Bauermann <bauerman@linux.ibm.com>
CC: Ahmed Soliman <ahmedsoliman@mena.vt.edu>
CC: linux-integrity@vger.kernel.org
CC: kernel-hardening@lists.openwall.com
CC: linux-mm@kvack.org
CC: linux-kernel@vger.kernel.org
---
 arch/Kconfig                      | 15 +++++++++++++++
 include/asm-generic/vmlinux.lds.h | 25 +++++++++++++++++++++++++
 include/linux/cache.h             | 21 +++++++++++++++++++++
 init/main.c                       |  3 +++
 4 files changed, 64 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 4cfb6de48f79..b0b6d176f1c1 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -808,6 +808,21 @@ config VMAP_STACK
 	  the stack to map directly to the KASAN shadow map using a formula
 	  that is incorrect if the stack is in vmalloc space.
 
+config ARCH_HAS_PRMEM
+	def_bool n
+	help
+	  architecture specific symbol stating that the architecture provides
+	  a back-end function for the write rare operation.
+
+config PRMEM
+	bool "Write protect critical data that doesn't need high write speed."
+	depends on ARCH_HAS_PRMEM
+	default y
+	help
+	  If the architecture supports it, statically allocated data which
+	  has been selected for hardening becomes (mostly) read-only.
+	  The selection happens by labelling the data "__wr_after_init".
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 3d7a6a9c2370..ddb1fd608490 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -311,6 +311,30 @@
 	KEEP(*(__jump_table))						\
 	__stop___jump_table = .;
 
+/*
+ * Allow architectures to handle wr_after_init data on their
+ * own by defining an empty WR_AFTER_INIT_DATA.
+ * However, it's important that pages containing WR_RARE data do not
+ * hold anything else, to avoid both accidentally unprotecting something
+ * that is supposed to stay read-only all the time and also to protect
+ * something else that is supposed to be writeable all the time.
+ */
+#ifndef WR_AFTER_INIT_DATA
+#ifdef CONFIG_PRMEM
+#define WR_AFTER_INIT_DATA(align)					\
+	. = ALIGN(PAGE_SIZE);						\
+	__start_wr_after_init = .;					\
+	. = ALIGN(align);						\
+	*(.data..wr_after_init)						\
+	. = ALIGN(PAGE_SIZE);						\
+	__end_wr_after_init = .;					\
+	. = ALIGN(align);
+#else
+#define WR_AFTER_INIT_DATA(align)					\
+	. = ALIGN(align);
+#endif
+#endif
+
 /*
  * Allow architectures to handle ro_after_init data on their
  * own by defining an empty RO_AFTER_INIT_DATA.
@@ -332,6 +356,7 @@
 		__start_rodata = .;					\
 		*(.rodata) *(.rodata.*)					\
 		RO_AFTER_INIT_DATA	/* Read only after init */	\
+		WR_AFTER_INIT_DATA(align) /* wr after init */	\
 		KEEP(*(__vermagic))	/* Kernel version magic */	\
 		. = ALIGN(8);						\
 		__start___tracepoints_ptrs = .;				\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 750621e41d1c..09bd0b9284b6 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -31,6 +31,27 @@
 #define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
 #endif
 
+/*
+ * __wr_after_init is used to mark objects that cannot be modified
+ * directly after init (i.e. after mark_rodata_ro() has been called).
+ * These objects become effectively read-only, from the perspective of
+ * performing a direct write, like a variable assignment.
+ * However, they can be altered through a dedicated function.
+ * It is intended for those objects which are occasionally modified after
+ * init, however they are modified so seldomly, that the extra cost from
+ * the indirect modification is either negligible or worth paying, for the
+ * sake of the protection gained.
+ */
+#ifndef __wr_after_init
+#ifdef CONFIG_PRMEM
+#define __wr_after_init \
+		__attribute__((__section__(".data..wr_after_init")))
+#else
+#define __wr_after_init
+#endif
+#endif
+
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
diff --git a/init/main.c b/init/main.c
index c86a1c8f19f4..965e9fbc5452 100644
--- a/init/main.c
+++ b/init/main.c
@@ -496,6 +496,8 @@ void __init __weak thread_stack_cache_init(void)
 
 void __init __weak mem_encrypt_init(void) { }
 
+void __init __weak wr_init(void) { }
+
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -713,6 +715,7 @@ asmlinkage __visible void __init start_kernel(void)
 	cred_init();
 	fork_init();
 	proc_caches_init();
+	wr_init();
 	uts_ns_init();
 	buffer_init();
 	key_init();
-- 
2.19.1
