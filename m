Date: Tue, 30 Apr 2019 04:13:48 -0700
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-e836673c9b4966bc78e38aeda25f7022c57f0e90@git.kernel.org>
In-Reply-To: <20190426001143.4983-2-namit@vmware.com>
References: <20190426001143.4983-2-namit@vmware.com>
Subject: [tip:x86/mm] x86/alternatives: Add text_poke_kgdb() to not assert
 the lock when debugging
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
To: linux-tip-commits@vger.kernel.org
Cc: tglx@linutronix.de, hpa@zytor.com, akpm@linux-foundation.org, luto@kernel.org, bp@alien8.de, mhiramat@kernel.org, riel@surriel.com, ard.biesheuvel@linaro.org, linux-kernel@vger.kernel.org, namit@vmware.com, linux_dti@icloud.com, will.deacon@arm.com, dave.hansen@intel.com, kristen@linux.intel.com, kernel-hardening@lists.openwall.com, peterz@infradead.org, rick.p.edgecombe@intel.com, mingo@kernel.org, keescook@chromium.org, deneen.t.dock@intel.com, jkosina@suse.cz, torvalds@linux-foundation.org
List-ID: <kernel-hardening.lists.openwall.com>

Commit-ID:  e836673c9b4966bc78e38aeda25f7022c57f0e90
Gitweb:     https://git.kernel.org/tip/e836673c9b4966bc78e38aeda25f7022c57f0e90
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:21 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:47 +0200

x86/alternatives: Add text_poke_kgdb() to not assert the lock when debugging

text_mutex is currently expected to be held before text_poke() is
called, but kgdb does not take the mutex, and instead *supposedly*
ensures the lock is not taken and will not be acquired by any other core
while text_poke() is running.

The reason for the "supposedly" comment is that it is not entirely clear
that this would be the case if gdb_do_roundup is zero.

Create two wrapper functions, text_poke() and text_poke_kgdb(), which do
or do not run the lockdep assertion respectively.

While we are at it, change the return code of text_poke() to something
meaningful. One day, callers might actually respect it and the existing
BUG_ON() when patching fails could be removed. For kgdb, the return
value can actually be used.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Jiri Kosina <jkosina@suse.cz>
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
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Fixes: 9222f606506c ("x86/alternatives: Lockdep-enforce text_mutex in text_poke*()")
Link: https://lkml.kernel.org/r/20190426001143.4983-2-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/text-patching.h |  1 +
 arch/x86/kernel/alternative.c        | 52 ++++++++++++++++++++++++++----------
 arch/x86/kernel/kgdb.c               | 11 ++++----
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e85ff65c43c3..f8fc8e86cf01 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -35,6 +35,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
  * inconsistent instruction while you patch.
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 9a79c7808f9c..0a814d73547a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -679,18 +679,7 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 	return addr;
 }
 
-/**
- * text_poke - Update instructions on a live kernel
- * @addr: address to modify
- * @opcode: source of the copy
- * @len: length to copy
- *
- * Only atomic text poke/set should be allowed when not doing early patching.
- * It means the size must be writable atomically and the address must be aligned
- * in a way that permits an atomic write. It also makes sure we fit on a single
- * page.
- */
-void *text_poke(void *addr, const void *opcode, size_t len)
+static void *__text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
 	char *vaddr;
@@ -703,8 +692,6 @@ void *text_poke(void *addr, const void *opcode, size_t len)
 	 */
 	BUG_ON(!after_bootmem);
 
-	lockdep_assert_held(&text_mutex);
-
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
@@ -733,6 +720,43 @@ void *text_poke(void *addr, const void *opcode, size_t len)
 	return addr;
 }
 
+/**
+ * text_poke - Update instructions on a live kernel
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Only atomic text poke/set should be allowed when not doing early patching.
+ * It means the size must be writable atomically and the address must be aligned
+ * in a way that permits an atomic write. It also makes sure we fit on a single
+ * page.
+ */
+void *text_poke(void *addr, const void *opcode, size_t len)
+{
+	lockdep_assert_held(&text_mutex);
+
+	return __text_poke(addr, opcode, len);
+}
+
+/**
+ * text_poke_kgdb - Update instructions on a live kernel by kgdb
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Only atomic text poke/set should be allowed when not doing early patching.
+ * It means the size must be writable atomically and the address must be aligned
+ * in a way that permits an atomic write. It also makes sure we fit on a single
+ * page.
+ *
+ * Context: should only be used by kgdb, which ensures no other core is running,
+ *	    despite the fact it does not hold the text_mutex.
+ */
+void *text_poke_kgdb(void *addr, const void *opcode, size_t len)
+{
+	return __text_poke(addr, opcode, len);
+}
+
 static void do_sync_core(void *info)
 {
 	sync_core();
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 4ff6b4cdb941..2b203ee5b879 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -759,13 +759,13 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 	if (!err)
 		return err;
 	/*
-	 * It is safe to call text_poke() because normal kernel execution
+	 * It is safe to call text_poke_kgdb() because normal kernel execution
 	 * is stopped on all cores, so long as the text_mutex is not locked.
 	 */
 	if (mutex_is_locked(&text_mutex))
 		return -EBUSY;
-	text_poke((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
-		  BREAK_INSTR_SIZE);
+	text_poke_kgdb((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
+		       BREAK_INSTR_SIZE);
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (err)
 		return err;
@@ -784,12 +784,13 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 	if (bpt->type != BP_POKE_BREAKPOINT)
 		goto knl_write;
 	/*
-	 * It is safe to call text_poke() because normal kernel execution
+	 * It is safe to call text_poke_kgdb() because normal kernel execution
 	 * is stopped on all cores, so long as the text_mutex is not locked.
 	 */
 	if (mutex_is_locked(&text_mutex))
 		goto knl_write;
-	text_poke((void *)bpt->bpt_addr, bpt->saved_instr, BREAK_INSTR_SIZE);
+	text_poke_kgdb((void *)bpt->bpt_addr, bpt->saved_instr,
+		       BREAK_INSTR_SIZE);
 	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
 	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
 		goto knl_write;
