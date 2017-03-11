From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 10 Mar 2017 16:05:01 -0800
Message-Id: <20170311000501.46607-4-thgarnie@google.com>
In-Reply-To: <20170311000501.46607-1-thgarnie@google.com>
References: <20170311000501.46607-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v3 4/4] arm64/syscalls: Specific usage of verify_pre_usermode_state
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Hansen <dave.hansen@intel.com>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Frederic Weisbecker <fweisbec@gmail.com>, Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Dmitry Safonov <dsafonov@virtuozzo.com>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, Brian Gerst <brgerst@gmail.com>, Jan Beulich <JBeulich@suse.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Fenghua Yu <fenghua.yu@intel.com>, He Chen <he.chen@linux.intel.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, "David A . Long" <dave.long@linaro.org>, Pratyush Anand <panand@redhat.com>, Laura Abbott <labbott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Chris Metcalf <cmetcalf@mellanox.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Implement specific usage of verify_pre_usermode_state for user-mode
returns for arm64.
---
Based on next-20170308
---
 arch/arm64/Kconfig        |  1 +
 arch/arm64/kernel/entry.S | 25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 896eba61e5ed..da54774838d8 100644
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
index 43512d4d7df2..685b43771ac9 100644
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
@@ -779,6 +788,22 @@ finish_ret_to_user:
 	kernel_exit 0
 ENDPROC(ret_to_user)
 
+addr_limit_fail:
+#ifdef CONFIG_BUG_ON_DATA_CORRUPTION
+	stp	x0, lr, [sp,#-16]!
+	bl	verify_pre_usermode_state
+	ldp	x0, lr, [sp],#16
+#else
+	/*
+	 * Similar to set_fs(USER_DS) in verify_pre_usermode_state without a
+	 * warning.
+	 */
+	mov	x2, #TASK_SIZE_64
+	str	x2, [tsk, #TSK_TI_ADDR_LIMIT]
+	ALTERNATIVE(nop, SET_PSTATE_UAO(0), ARM64_HAS_UAO, CONFIG_ARM64_UAO)
+#endif
+	ret	lr
+
 /*
  * This is how we return from a fork.
  */
-- 
2.12.0.246.ga2ecc84866-goog
