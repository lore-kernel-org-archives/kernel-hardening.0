Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 24 Nov 2015 13:38:33 -0800
Message-Id: <1448401114-24650-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1448401114-24650-1-git-send-email-keescook@chromium.org>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/2] x86: introduce post-init read-only memory
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

One of the easiest ways to protect the kernel from attack is to reduce
the internal attack surface exposed when a "write" flaw is available. By
making as much of the kernel read-only as possible, we reduce the
attack surface.

Many things are written to only during __init, and never changed
again. These cannot be made "const" since the compiler will do the wrong
thing (we do actually need to write to them). Instead, move these items
into a memory region that will be made read-only during mark_rodata_ro()
which happens after all kernel __init code has finished.

This introduces __read_only as a way to mark such memory, and adds some
documentation about the existing __read_mostly marking.

Based on work by PaX Team and Brad Spengler.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/cache.h      |  1 +
 include/asm-generic/vmlinux.lds.h |  1 +
 include/linux/cache.h             | 15 +++++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/cache.h b/arch/x86/include/asm/cache.h
index 48f99f15452e..982b21c5eb1f 100644
--- a/arch/x86/include/asm/cache.h
+++ b/arch/x86/include/asm/cache.h
@@ -8,6 +8,7 @@
 #define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
 
 #define __read_mostly __attribute__((__section__(".data..read_mostly")))
+#define __read_only __attribute__((__section__(".data..read_only")))
 
 #define INTERNODE_CACHE_SHIFT CONFIG_X86_INTERNODE_CACHE_SHIFT
 #define INTERNODE_CACHE_BYTES (1 << INTERNODE_CACHE_SHIFT)
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c4bd0e2c173c..998a09d7731c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -256,6 +256,7 @@
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
+		*(.data..read_only)	/* Read only after init */	\
 		*(__vermagic)		/* Kernel version magic */	\
 		. = ALIGN(8);						\
 		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 17e7e82d2aa7..b2967e711a75 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -12,10 +12,25 @@
 #define SMP_CACHE_BYTES L1_CACHE_BYTES
 #endif
 
+/*
+ * __read_mostly is used to keep rarely changing variables out of frequently
+ * updated cachelines. If an architecture doesn't support it, ignore the
+ * hint.
+ */
 #ifndef __read_mostly
 #define __read_mostly
 #endif
 
+/*
+ * __read_only is used to mark things that are read-only after init (i.e.
+ * after mark_rodata_ro() has been called). These are effectively read-only,
+ * but may get written to during init, so can't live in .rodata (via "const").
+ * Hint to __read_mostly if the architecture hasn't wired this up.
+ */
+#ifndef __read_only
+#define __read_only __read_mostly
+#endif
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
-- 
1.9.1
