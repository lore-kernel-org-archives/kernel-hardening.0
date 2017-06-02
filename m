From: riel@redhat.com
Date: Fri,  2 Jun 2017 11:20:06 -0400
Message-Id: <20170602152010.2064-3-riel@redhat.com>
In-Reply-To: <20170602152010.2064-1-riel@redhat.com>
References: <20170602152010.2064-1-riel@redhat.com>
Subject: [kernel-hardening] [PATCH 2/6] x86/elf: move 32 bit ELF_ET_DYN_BASE to 256MB
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, akpm@linux-foundation.org, mingo@kernel.org, oleg@redhat.com, lwoodman@redhat.com, mhocko@suse.de, danielmicay@gmail.com, will.deacon@arm.com, benh@kernel.crashing.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Rik van Riel <riel@redhat.com>

When setting up mmap_base, we take care to start the mmap base
below the maximum extent to which the stack will grow. However,
we take no such precautions with PIE binaries, which are placed
at 5/6 of TASK_SIZE plus a random offset. As a result, 32 bit PIE
binaries can end up smack in the middle of where the stack (which
is randomized down) is supposed to go.

That problem can be avoided by putting the 32 bit ELF_ET_DYN_BASE
at 256MB, which is a value linux-hardened and grsecurity have used
for a long time now without any known (to me) bug reports.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 arch/x86/include/asm/elf.h | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index e8ab9a46bc68..dafa098cc05a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -245,12 +245,23 @@ extern int force_personality32;
 #define CORE_DUMP_USE_REGSET
 #define ELF_EXEC_PAGESIZE	4096
 
+/*
+ * True on X86_32 or when emulating IA32 on X86_64
+ */
+static inline int mmap_is_ia32(void)
+{
+	return IS_ENABLED(CONFIG_X86_32) ||
+	       (IS_ENABLED(CONFIG_COMPAT) &&
+		test_thread_flag(TIF_ADDR32));
+}
+
 /* This is the location that an ET_DYN program is loaded if exec'ed.  Typical
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
 
-#define ELF_ET_DYN_BASE		(TASK_SIZE / 3 * 2)
+#define ELF_ET_DYN_BASE		(mmap_is_ia32() ? 0x10000000UL : \
+				(TASK_SIZE / 3 * 2))
 
 /* This yields a mask that user programs can use to figure out what
    instruction set this CPU supports.  This could be done in user space,
@@ -293,16 +304,6 @@ do {									\
 	}								\
 } while (0)
 
-/*
- * True on X86_32 or when emulating IA32 on X86_64
- */
-static inline int mmap_is_ia32(void)
-{
-	return IS_ENABLED(CONFIG_X86_32) ||
-	       (IS_ENABLED(CONFIG_COMPAT) &&
-		test_thread_flag(TIF_ADDR32));
-}
-
 extern unsigned long tasksize_32bit(void);
 extern unsigned long tasksize_64bit(void);
 extern unsigned long get_mmap_base(int is_legacy);
-- 
2.9.3
