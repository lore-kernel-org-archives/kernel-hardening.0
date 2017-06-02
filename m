From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:09 -0400
Message-Id: <20170602152010.2064-6-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 5/6] arm64: move COMPAT_ELF_ET_DYN_BASE lower in the address space
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, lwoodman@redhat.com, mhocko@suse.de, danielmicay@gmail.com, will.deacon@arm.com, benh@kernel.crashing.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

When setting up mmap_base, we take care to start the mmap base
below the maximum extent to which the stack will grow. However,
we take no such precautions with PIE binaries, which are placed
at 2/3 of TASK_SIZE plus a random offset. As a result, 32 bit PIE
binaries can end up smack in the middle of where the stack (which
is randomized down) is supposed to go.

That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE
at 256MB, which is a value linux-hardened and grsecurity have used
for a long time now without any known (to me) bug reports.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Daniel Micay <danielmicay@gmail.com>
---
 arch/arm64/include/asm/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index 5d1700425efe..88808a761816 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -173,7 +173,7 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 #ifdef CONFIG_COMPAT
 
-#define COMPAT_ELF_ET_DYN_BASE		(2 * TASK_SIZE_32 / 3)
+#define COMPAT_ELF_ET_DYN_BASE		(0x10000000UL)
 
 /* AArch32 registers. */
 #define COMPAT_ELF_NGREG		18
-- 
2.9.3
