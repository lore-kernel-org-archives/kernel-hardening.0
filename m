From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Jun 2017 11:06:30 -0700
Message-Id: <1498154792-49952-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1498154792-49952-1-git-send-email-keescook@chromium.org>
References: <1498154792-49952-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 2/4] arm64: Reduce ELF_ET_DYN_BASE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Pratyush Anand <panand@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region,
position PIE binaries lower in the address space to avoid possible
collisions with mmap or stack regions. For 64-bit, align to 4GB to
allow runtimes to use the entire 32-bit address space for 32-bit
pointers.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/include/asm/elf.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 5d1700425efe..f742af8f7c42 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -113,12 +113,13 @@
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
+#define ELF_ET_DYN_BASE		(test_thread_flag(TIF_32BIT) ?	\
+					0x000400000UL :		\
+					0x100000000UL)
 
 #ifndef __ASSEMBLY__
 
@@ -173,8 +174,6 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
-
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
 typedef unsigned int			compat_elf_greg_t;
-- 
2.7.4
