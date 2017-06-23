From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Jun 2017 13:59:58 -0700
Message-Id: <1498251600-132458-4-git-send-email-keescook@chromium.org>
In-Reply-To: <1498251600-132458-1-git-send-email-keescook@chromium.org>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 3/5] arm64: Move ELF_ET_DYN_BASE to 4GB / 4MB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, stable@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Rik van Riel <riel@redhat.com>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers. On 32-bit use 4MB, to match ARM. This
could be 0x8000, the standard ET_EXEC load address, but that is needlessly
close to the NULL address, and anyone running arm compat PIE will have an
MMU, so the tight mapping is not needed.

Cc: stable@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/include/asm/elf.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 5d1700425efe..8790fb09f689 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -113,12 +113,11 @@
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
 /*
- * This is the location that an ET_DYN program is loaded if exec'ed.  Typical
- * use of this is to invoke "./ld.so someprog" to test out a new version of
- * the loader.  We need to make sure that it is out of the way of the program
- * that it will "exec", and that there is sufficient room for the brk.
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
  */
-#define ELF_ET_DYN_BASE	(2 * TASK_SIZE_64 / 3)
+#define ELF_ET_DYN_BASE		0x100000000UL
 
 #ifndef __ASSEMBLY__
 
@@ -173,7 +172,8 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+/* PIE load location for compat arm. Must match ARM ELF_ET_DYN_BASE. */
+#define COMPAT_ELF_ET_DYN_BASE		0x000400000UL
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
-- 
2.7.4
