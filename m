From: Kees Cook <keescook@chromium.org>
Date: Fri, 23 Jun 2017 13:59:57 -0700
Message-Id: <1498251600-132458-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1498251600-132458-1-git-send-email-keescook@chromium.org>
References: <1498251600-132458-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 2/5] arm: Move ELF_ET_DYN_BASE to 4MB
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, stable@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>, Rik van Riel <riel@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Daniel Micay <danielmicay@gmail.com>, Qualys Security Advisory <qsa@qualys.com>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Pratyush Anand <panand@redhat.com>, James Hogan <james.hogan@imgtec.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Grzegorz Andrejczuk <grzegorz.andrejczuk@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region, we
have more freedom to decide where we position PIE binaries in the address
space to avoid possible collisions with mmap or stack regions.

4MB is chosen here mainly to have parity with x86, where this is the
traditional minimum load location, likely to avoid historically requiring
a 4MB page table entry when only a portion of the first 4MB would be used
(since the NULL address is avoided). For ARM the position could be 0x8000,
the standard ET_EXEC load address, but that is needlessly close to the
NULL address, and anyone running PIE on 32-bit ARM will have an MMU, so
the tight mapping is not needed.

Cc: stable@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm/include/asm/elf.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/elf.h b/arch/arm/include/asm/elf.h
index d2315ffd8f12..f13ae153fb24 100644
--- a/arch/arm/include/asm/elf.h
+++ b/arch/arm/include/asm/elf.h
@@ -112,12 +112,8 @@ int dump_task_regs(struct task_struct *t, elf_gregset_t *elfregs);
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
-/* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
-   use of this is to invoke "./ld.so someprog" to test out a new version of
-   the loader.  We need to make sure that it is out of the way of the program
-   that it will "exec", and that there is sufficient room for the brk.  */
-
-#define ELF_ET_DYN_BASE	(TASK_SIZE / 3 * 2)
+/* This is the base location for PIE (ET_DYN with INTERP) loads. */
+#define ELF_ET_DYN_BASE		0x400000UL
 
 /* When the program starts, a1 contains a pointer to a function to be 
    registered with atexit, as per the SVR4 ABI.  A value of 0 means we 
-- 
2.7.4
