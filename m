From: Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH] x86: entry: flush the cache if syscall error
Date: Thu, 11 Oct 2018 11:54:58 -0700
Message-Id: <20181011185458.10186-1-kristen@linux.intel.com>
Cc: kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch aims to make it harder to perform cache timing attacks on data
left behind by system calls. If we have an error returned from a syscall,
flush the L1 cache.

It's important to note that this patch is not addressing any specific
exploit, nor is it intended to be a complete defense against anything.
It is intended to be a low cost way of eliminating some of side effects
of a failed system call.

A performance test using sysbench on one hyperthread and a script which
attempts to repeatedly access files it does not have permission to access
on the other hyperthread found no significant performance impact.

Suggested-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/Kconfig        |  9 +++++++++
 arch/x86/entry/common.c | 18 ++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1a0be022f91d..bde978eb3b4e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -445,6 +445,15 @@ config RETPOLINE
 	  code are eliminated. Since this includes the syscall entry path,
 	  it is not entirely pointless.
 
+config SYSCALL_FLUSH
+	bool "Clear L1 Cache on syscall errors"
+	default n
+	help
+	  Selecting 'y' allows the L1 cache to be cleared upon return of
+	  an error code from a syscall if the CPU supports "flush_l1d".
+	  This may reduce the likelyhood of speculative execution style
+	  attacks on syscalls.
+
 config INTEL_RDT
 	bool "Intel Resource Director Technology support"
 	default n
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 3b2490b81918..26de8ea71293 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -268,6 +268,20 @@ __visible inline void syscall_return_slowpath(struct pt_regs *regs)
 	prepare_exit_to_usermode(regs);
 }
 
+__visible inline void l1_cache_flush(struct pt_regs *regs)
+{
+	if (IS_ENABLED(CONFIG_SYSCALL_FLUSH) &&
+	    static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
+		if (regs->ax == 0 || regs->ax == -EAGAIN ||
+		    regs->ax == -EEXIST || regs->ax == -ENOENT ||
+		    regs->ax == -EXDEV || regs->ax == -ETIMEDOUT ||
+		    regs->ax == -ENOTCONN || regs->ax == -EINPROGRESS)
+			return;
+
+		wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+	}
+}
+
 #ifdef CONFIG_X86_64
 __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
@@ -290,6 +304,8 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 		regs->ax = sys_call_table[nr](regs);
 	}
 
+	l1_cache_flush(regs);
+
 	syscall_return_slowpath(regs);
 }
 #endif
@@ -338,6 +354,8 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 #endif /* CONFIG_IA32_EMULATION */
 	}
 
+	l1_cache_flush(regs);
+
 	syscall_return_slowpath(regs);
 }
 
-- 
2.14.4
