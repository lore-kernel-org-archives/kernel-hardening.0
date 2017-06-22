From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Jun 2017 11:06:29 -0700
Message-Id: <1498154792-49952-2-git-send-email-keescook@chromium.org>
In-Reply-To: <1498154792-49952-1-git-send-email-keescook@chromium.org>
References: <1498154792-49952-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 1/4] arm: Reduce ELF_ET_DYN_BASE
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, James Hogan <james.hogan@imgtec.com>, Pratyush Anand <panand@redhat.com>, Ingo Molnar <mingo@kernel.org>, linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Now that explicitly executed loaders are loaded in the mmap region,
position PIE binaries lower in the address space to avoid possible
collisions with mmap or stack regions.

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
