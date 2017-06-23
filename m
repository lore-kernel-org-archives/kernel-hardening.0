From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Jun 2017 14:00:00 -0700
Message-Id: <1498251600-132458-6-git-send-email-keescook@chromium.org>
In-Reply-To: <1498251600-132458-1-git-send-email-keescook@chromium.org>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 5/5] s390: Move ELF_ET_DYN_BASE to 4GB / 4MB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, stable@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers. On 32-bit use 4MB, which is the
traditional x86 minimum load location, likely to avoid historically
requiring a 4MB page table entry when only a portion of the first 4MB
would be used (since the NULL address is avoided). For s390 the position
could be 0x10000, but that is needlessly close to the NULL address.

Cc: stable@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/s390/include/asm/elf.h | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/elf.h b/arch/s390/include/asm/elf.h
index e8f623041769..7c58d599f91b 100644
--- a/arch/s390/include/asm/elf.h
+++ b/arch/s390/include/asm/elf.h
@@ -161,14 +161,13 @@ extern unsigned int vdso_enabled;
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk. 64-bit
-   tasks are aligned to 4GB. */
-#define ELF_ET_DYN_BASE (is_compat_task() ? \
-				(STACK_TOP / 3 * 2) : \
-				(STACK_TOP / 3 * 2) & ~((1UL << 32) - 1))
+/*
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
+ */
+#define ELF_ET_DYN_BASE		(is_compat_task() ? 0x000400000UL : \
+						    0x100000000UL)
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports. */
-- 
2.7.4
