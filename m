From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 15 Feb 2017 15:38:00 +0000
Message-Id: <1487173081-13425-3-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487173081-13425-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [RFC PATCH 2/3] arm64: boot: align __inittext with swapper block on relocatable kernels
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The relocatable kernel needs to do a relocation pass regardless of whether
it was loaded at the virtual offset it was linked at. This means we could
completely ignore TEXT_OFFSET if we wanted to (and this is actually what
the KASLR aware image loader in the stub does already), as long as we adhere
to the segment alignment, which is at least 64 KB.

Whether the .init.text region requires a RWX mapping depends on whether it
shares a swapper block with other sections that require a writable mapping.
Since the TEXT_OFFSET field gives us control over the placement of the Image
with respect to a swapper block boundary, we can override its value with a
value that puts __inittext_begin right on a swapper block boundary as well.
This removes the need to use RWX mappings entirely, given that relocatable
kernels have at least a couple of MBs of .rela data, which sits between
the executable and the writable bits of the __init segment.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/kernel/image.h | 23 +++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index c7fcb232fe47..98e191cd97b1 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -62,13 +62,30 @@
 				 (__HEAD_FLAG_PHYS_BASE << 3))
 
 /*
+ * The relocatable kernel does not care about TEXT_OFFSET, as long as the
+ * image is loaded at the correct segment alignment. So let's tweak the
+ * effective TEXT_OFFSET header field so that __init_begin coincides with
+ * a swapper block boundary: this way, we will not need to create any RWX
+ * mappings for the kernel, even in the earliest stages. (Note that this is
+ * already guaranteed if SWAPPER_BLOCK_SIZE <= SEGMENT_ALIGN.)
+ * If it turns out that the boot loader ignores the TEXT_OFFSET field, we can
+ * happily boot as before, with the only difference being that we had to use
+ * an early RWX mapping for .init.text.
+ */
+#if defined(CONFIG_RELOCATABLE) && SWAPPER_BLOCK_SIZE > PAGE_SIZE
+__eff_text_offset = SWAPPER_BLOCK_SIZE - ((__init_begin - TEXT_OFFSET) & (SWAPPER_BLOCK_SIZE - 1));
+#else
+__eff_text_offset = TEXT_OFFSET;
+#endif
+
+/*
  * These will output as part of the Image header, which should be little-endian
  * regardless of the endianness of the kernel. While constant values could be
  * endian swapped in head.S, all are done here for consistency.
  */
-#define HEAD_SYMBOLS						\
-	DEFINE_IMAGE_LE64(_kernel_size_le, _end - _text);	\
-	DEFINE_IMAGE_LE64(_kernel_offset_le, TEXT_OFFSET);	\
+#define HEAD_SYMBOLS							\
+	DEFINE_IMAGE_LE64(_kernel_size_le, _end - _text);		\
+	DEFINE_IMAGE_LE64(_kernel_offset_le, __eff_text_offset);	\
 	DEFINE_IMAGE_LE64(_kernel_flags_le, __HEAD_FLAGS);
 
 #ifdef CONFIG_EFI
-- 
2.7.4
