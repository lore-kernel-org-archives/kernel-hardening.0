From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH 3/5] x86/vsyscall: Document odd #PF's error code for vsyscalls
Date: Mon, 10 Jun 2019 13:25:29 -0700
Message-Id: <d28856fff74a385f88c493dafb9d96d2c38d91a2.1560198181.git.luto@kernel.org>
In-Reply-To: <cover.1560198181.git.luto@kernel.org>
References: <cover.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

Even if vsyscall=none, we report uer page faults on the vsyscall
page as though the PROT bit in the error code was set.  Add a
comment explaining why this is probably okay and display the value
in the test case.

While we're at it, explain why our behavior is correct with respect
to PKRU.

If anyone really cares about more accurate emulation, we could
change the behavior.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/fault.c                         | 7 +++++++
 tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 46df4c6aae46..1b18819e8e11 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -710,6 +710,10 @@ static void set_signal_archinfo(unsigned long address,
 	 * To avoid leaking information about the kernel page
 	 * table layout, pretend that user-mode accesses to
 	 * kernel addresses are always protection faults.
+	 *
+	 * NB: This means that failed vsyscalls with vsyscall=none
+	 * will have the PROT bit.  This doesn't leak any
+	 * information and does not appear to cause any problems.
 	 */
 	if (address >= TASK_SIZE_MAX)
 		error_code |= X86_PF_PROT;
@@ -1376,6 +1380,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 *
 	 * The vsyscall page does not have a "real" VMA, so do this
 	 * emulation before we go searching for VMAs.
+	 *
+	 * PKRU never rejects instruction fetches, so we don't need
+	 * to consider the PF_PK bit.
 	 */
 	if ((hw_error_code & X86_PF_INSTR) && is_vsyscall_vaddr(address)) {
 		if (emulate_vsyscall(regs, address))
diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index 0b4f1cc2291c..4c9a8d76dba0 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -183,9 +183,13 @@ static inline long sys_getcpu(unsigned * cpu, unsigned * node,
 }
 
 static jmp_buf jmpbuf;
+static volatile unsigned long segv_err;
 
 static void sigsegv(int sig, siginfo_t *info, void *ctx_void)
 {
+	ucontext_t *ctx = (ucontext_t *)ctx_void;
+
+	segv_err =  ctx->uc_mcontext.gregs[REG_ERR];
 	siglongjmp(jmpbuf, 1);
 }
 
@@ -416,8 +420,11 @@ static int test_vsys_r(void)
 	} else if (!can_read && should_read_vsyscall) {
 		printf("[FAIL]\tWe don't have read access, but we should\n");
 		return 1;
+	} else if (can_read) {
+		printf("[OK]\tWe have read access\n");
 	} else {
-		printf("[OK]\tgot expected result\n");
+		printf("[OK]\tWe do not have read access: #PF(0x%lx)\n",
+		       segv_err);
 	}
 #endif
 
-- 
2.21.0
