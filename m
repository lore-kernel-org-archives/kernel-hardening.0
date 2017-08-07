From: Mark Rutland <mark.rutland@arm.com>
Date: Mon,  7 Aug 2017 19:35:58 +0100
Message-Id: <1502130965-18710-8-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
References: <1502130965-18710-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [PATCH 07/14] arm64: move SEGMENT_ALIGN to <asm/memory.h>
To: linux-arm-kernel@lists.infradead.org
Cc: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, labbott@redhat.com, linux-kernel@vger.kernel.org, luto@amacapital.net, mark.rutland@arm.com, matt@codeblueprint.co.uk, will.deacon@arm.com, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently we define SEGMENT_ALIGN directly in our vmlinux.lds.S.

This is unfortunate, as the EFI stub currently open-codes the same
number, and in future we'll want to fiddle with this.

This patch moves the definition to our <asm/memory.h>, where it can be
used by both vmlinux.lds.S and the EFI stub code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/memory.h | 19 +++++++++++++++++++
 arch/arm64/kernel/vmlinux.lds.S | 16 ----------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 1fc2453..7fa6ad4 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -113,6 +113,25 @@
 #define IRQ_STACK_SIZE		THREAD_SIZE
 
 /*
+ * Alignment of kernel segments (e.g. .text, .data).
+ */
+#if defined(CONFIG_DEBUG_ALIGN_RODATA)
+/*
+ *  4 KB granule:   1 level 2 entry
+ * 16 KB granule: 128 level 3 entries, with contiguous bit
+ * 64 KB granule:  32 level 3 entries, with contiguous bit
+ */
+#define SEGMENT_ALIGN			SZ_2M
+#else
+/*
+ *  4 KB granule:  16 level 3 entries, with contiguous bit
+ * 16 KB granule:   4 level 3 entries, without contiguous bit
+ * 64 KB granule:   1 level 3 entry
+ */
+#define SEGMENT_ALIGN			SZ_64K
+#endif
+
+/*
  * Memory types available.
  */
 #define MT_DEVICE_nGnRnE	0
diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
index 987a00e..7156538 100644
--- a/arch/arm64/kernel/vmlinux.lds.S
+++ b/arch/arm64/kernel/vmlinux.lds.S
@@ -72,22 +72,6 @@ PECOFF_FILE_ALIGNMENT = 0x200;
 #define PECOFF_EDATA_PADDING
 #endif
 
-#if defined(CONFIG_DEBUG_ALIGN_RODATA)
-/*
- *  4 KB granule:   1 level 2 entry
- * 16 KB granule: 128 level 3 entries, with contiguous bit
- * 64 KB granule:  32 level 3 entries, with contiguous bit
- */
-#define SEGMENT_ALIGN			SZ_2M
-#else
-/*
- *  4 KB granule:  16 level 3 entries, with contiguous bit
- * 16 KB granule:   4 level 3 entries, without contiguous bit
- * 64 KB granule:   1 level 3 entry
- */
-#define SEGMENT_ALIGN			SZ_64K
-#endif
-
 SECTIONS
 {
 	/*
-- 
1.9.1
