From: Thomas Garnier <thgarnie@google.com>
Date: Tue,  4 Apr 2017 10:47:27 -0700
Message-Id: <20170404174727.35478-4-thgarnie@google.com>
In-Reply-To: <20170404174727.35478-1-thgarnie@google.com>
References: <20170404174727.35478-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v6 4/4] arm64/syscalls: Specific usage of verify_pre_usermode_state
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, David Howells <dhowells@redhat.com>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Kees Cook <keescook@chromium.org>, Rik van Riel <riel@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm64.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170404
---
 arch/arm64/Kconfig        |  1 +
 arch/arm64/kernel/entry.S | 15 +++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f2b0b528037d..0e86d87259f4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -24,6 +24,7 @@ config ARM64
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
 	select ARCH_WANT_FRAME_POINTERS
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
+	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
 	select ARM_AMBA
 	select ARM_ARCH_TIMER
 	select ARM_GIC
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 43512d4d7df2..6d598e7051c3 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -744,6 +744,10 @@ ENDPROC(cpu_switch_to)
 ret_fast_syscall:
 	disable_irq				// disable interrupts
 	str	x0, [sp, #S_X0]			// returned x0
+	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
+	mov	x1, #TASK_SIZE_64
+	cmp	x2, x1
+	b.ne	addr_limit_fail
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
 	and	x2, x1, #_TIF_SYSCALL_WORK
 	cbnz	x2, ret_fast_syscall_trace
@@ -771,6 +775,11 @@ work_pending:
  */
 ret_to_user:
 	disable_irq				// disable interrupts
+	ldr	x2, [tsk, #TSK_TI_ADDR_LIMIT]	// check addr limit change
+	mov	x1, #TASK_SIZE_64
+	cmp	x2, x1
+	b.ne	addr_limit_fail
+
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
 	cbnz	x2, work_pending
@@ -779,6 +788,12 @@ finish_ret_to_user:
 	kernel_exit 0
 ENDPROC(ret_to_user)
 
+addr_limit_fail:
+	stp	x0, lr, [sp,#-16]!
+	bl	asm_verify_pre_usermode_state
+	ldp	x0, lr, [sp],#16
+	ret	lr
+
 /*
  * This is how we return from a fork.
  */
-- 
2.12.2.715.g7642488e1d-goog
