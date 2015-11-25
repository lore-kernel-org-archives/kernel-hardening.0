Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed, 25 Nov 2015 15:31:24 -0800
Message-Id: <1448494286-16029-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1448494286-16029-1-git-send-email-keescook@chromium.org>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 2/4] introduce post-init read-only memory
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-arch <linux-arch@vger.kernel.org>
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

This introduces __ro_after_init as a way to mark such memory, and adds
some documentation about the existing __read_mostly marking.

Based on work by PaX Team and Brad Spengler.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/asm-generic/vmlinux.lds.h |  1 +
 include/linux/cache.h             | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c4bd0e2c173c..772c784ba763 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -256,6 +256,7 @@
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
+		*(.data..ro_after_init)	/* Read only after init */	\
 		*(__vermagic)		/* Kernel version magic */	\
 		. = ALIGN(8);						\
 		VMLINUX_SYMBOL(__start___tracepoints_ptrs) = .;		\
diff --git a/include/linux/cache.h b/include/linux/cache.h
index 17e7e82d2aa7..ac777fe01d92 100644
--- a/include/linux/cache.h
+++ b/include/linux/cache.h
@@ -12,10 +12,24 @@
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
+ */
+#ifndef __ro_after_init
+#define __ro_after_init __attribute__((__section__(".data..ro_after_init")))
+#endif
+
 #ifndef ____cacheline_aligned
 #define ____cacheline_aligned __attribute__((__aligned__(SMP_CACHE_BYTES)))
 #endif
-- 
1.9.1
