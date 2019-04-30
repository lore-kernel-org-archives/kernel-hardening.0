Date: Tue, 30 Apr 2019 04:24:09 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-0a203df5cf0eb709be4f190314e262b72d7e5b76@git.kernel.org>
In-Reply-To: <20190426001143.4983-14-namit@vmware.com>
References: <20190426001143.4983-14-namit@vmware.com>
Subject: [tip:x86/mm] x86/alternatives: Remove the return value of
 text_poke_*()
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: mhiramat@kernel.org, torvalds@linux-foundation.org, kernel-hardening@lists.openwall.com, tglx@linutronix.de, rick.p.edgecombe@intel.com, ard.biesheuvel@linaro.org, will.deacon@arm.com, linux-kernel@vger.kernel.org, hpa@zytor.com, kristen@linux.intel.com, akpm@linux-foundation.org, linux_dti@icloud.com, dave.hansen@intel.com, deneen.t.dock@intel.com, namit@vmware.com, riel@surriel.com, mingo@kernel.org, luto@kernel.org, keescook@chromium.org, peterz@infradead.org, bp@alien8.de
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  0a203df5cf0eb709be4f190314e262b72d7e5b76
Gitweb:     https://git.kernel.org/tip/0a203df5cf0eb709be4f190314e262b72d7e5b76
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:33 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:56 +0200

x86/alternatives: Remove the return value of text_poke_*()

The return value of text_poke_early() and text_poke_bp() is useless.
Remove it.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-14-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/text-patching.h |  4 ++--
 arch/x86/kernel/alternative.c        | 11 ++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index a75eed841eed..c90678fd391a 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -18,7 +18,7 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
@@ -37,7 +37,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern void text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 extern __ro_after_init struct mm_struct *poking_mm;
 extern __ro_after_init unsigned long poking_addr;
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3d2b6b6fb20c..18f959975ea0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -265,7 +265,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-void *text_poke_early(void *addr, const void *opcode, size_t len);
+void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Are we looking at a near JMP with a 1 or 4-byte displacement.
@@ -667,8 +667,8 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-void *__init_or_module text_poke_early(void *addr, const void *opcode,
-				       size_t len)
+void __init_or_module text_poke_early(void *addr, const void *opcode,
+				      size_t len)
 {
 	unsigned long flags;
 
@@ -691,7 +691,6 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 		 * that causes hangs on some VIA CPUs.
 		 */
 	}
-	return addr;
 }
 
 __ro_after_init struct mm_struct *poking_mm;
@@ -893,7 +892,7 @@ NOKPROBE_SYMBOL(poke_int3_handler);
  *	  replacing opcode
  *	- sync cores
  */
-void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+void text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 {
 	unsigned char int3 = 0xcc;
 
@@ -935,7 +934,5 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 * the writing of the new instruction.
 	 */
 	bp_patching_in_progress = false;
-
-	return addr;
 }
 
