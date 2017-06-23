From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Jun 2017 13:59:59 -0700
Message-Id: <1498251600-132458-5-git-send-email-keescook@chromium.org>
In-Reply-To: <1498251600-132458-1-git-send-email-keescook@chromium.org>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 4/5] powerpc: Move ELF_ET_DYN_BASE to 4GB / 4MB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, stable@vger.kernel.org, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

For 64-bit, align to 4GB to allow runtimes to use the entire 32-bit
address space for 32-bit pointers. On 32-bit use 4MB, which is the
traditional x86 minimum load location, likely to avoid historically
requiring a 4MB page table entry when only a portion of the first 4MB
would be used (since the NULL address is avoided).

Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
---
 arch/powerpc/include/asm/elf.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index 09bde6e34f5d..548d9a411a0d 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -23,12 +23,13 @@
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	PAGE_SIZE
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-#define ELF_ET_DYN_BASE	0x20000000
+/*
+ * This is the base location for PIE (ET_DYN with INTERP) loads. On
+ * 64-bit, this is raised to 4GB to leave the entire 32-bit address
+ * space open for things that want to use the area for 32-bit pointers.
+ */
+#define ELF_ET_DYN_BASE		(is_32bit_task() ? 0x000400000UL : \
+						   0x100000000UL)
 
 #define ELF_CORE_EFLAGS (is_elf2_task() ? 2 : 0)
 
-- 
2.7.4
