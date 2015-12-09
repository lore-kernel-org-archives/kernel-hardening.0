Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Wed,  9 Dec 2015 13:43:17 -0800
Message-Id: <1449697404-21076-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1449697404-21076-1-git-send-email-keescook@chromium.org>
References: <1449697404-21076-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v3 1/8] asm-generic: consolidate mark_rodata_ro()
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Instead of defining mark_rodata_ro() in each architecture, consolidate it.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/arm/include/asm/cacheflush.h    | 1 -
 arch/arm64/include/asm/cacheflush.h  | 4 ----
 arch/parisc/include/asm/cacheflush.h | 4 ----
 arch/x86/include/asm/cacheflush.h    | 1 -
 include/asm-generic/cacheflush.h     | 4 ++++
 5 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index d5525bfc7e3e..9156fc303afd 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -491,7 +491,6 @@ static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
 #endif
 
 #ifdef CONFIG_DEBUG_RODATA
-void mark_rodata_ro(void);
 void set_kernel_text_rw(void);
 void set_kernel_text_ro(void);
 #else
diff --git a/arch/arm64/include/asm/cacheflush.h b/arch/arm64/include/asm/cacheflush.h
index 54efedaf331f..ca3b7841e1c6 100644
--- a/arch/arm64/include/asm/cacheflush.h
+++ b/arch/arm64/include/asm/cacheflush.h
@@ -155,8 +155,4 @@ int set_memory_rw(unsigned long addr, int numpages);
 int set_memory_x(unsigned long addr, int numpages);
 int set_memory_nx(unsigned long addr, int numpages);
 
-#ifdef CONFIG_DEBUG_RODATA
-void mark_rodata_ro(void);
-#endif
-
 #endif
diff --git a/arch/parisc/include/asm/cacheflush.h b/arch/parisc/include/asm/cacheflush.h
index 845272ce9cc5..7bd69bd43a01 100644
--- a/arch/parisc/include/asm/cacheflush.h
+++ b/arch/parisc/include/asm/cacheflush.h
@@ -121,10 +121,6 @@ flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vma
 	}
 }
 
-#ifdef CONFIG_DEBUG_RODATA
-void mark_rodata_ro(void);
-#endif
-
 #include <asm/kmap_types.h>
 
 #define ARCH_HAS_KMAP
diff --git a/arch/x86/include/asm/cacheflush.h b/arch/x86/include/asm/cacheflush.h
index e63aa38e85fb..c8cff75c5b21 100644
--- a/arch/x86/include/asm/cacheflush.h
+++ b/arch/x86/include/asm/cacheflush.h
@@ -92,7 +92,6 @@ void clflush_cache_range(void *addr, unsigned int size);
 #define mmio_flush_range(addr, size) clflush_cache_range(addr, size)
 
 #ifdef CONFIG_DEBUG_RODATA
-void mark_rodata_ro(void);
 extern const int rodata_test_data;
 extern int kernel_set_to_readonly;
 void set_kernel_text_rw(void);
diff --git a/include/asm-generic/cacheflush.h b/include/asm-generic/cacheflush.h
index 87bc536ccde3..1225497ce3bf 100644
--- a/include/asm-generic/cacheflush.h
+++ b/include/asm-generic/cacheflush.h
@@ -31,4 +31,8 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
+#ifdef CONFIG_DEBUG_RODATA
+void mark_rodata_ro(void);
+#endif
+
 #endif /* __ASM_CACHEFLUSH_H */
-- 
1.9.1
