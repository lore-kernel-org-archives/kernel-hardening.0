From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 26 Jan 2018 23:55:56 -0800
Message-ID: <151703975686.26578.8851773106290279966.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 08/12] x86: sanitize sycall table de-references under
 speculation
To: tglx@linutronix.de
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

The syscall table base is a user controlled function pointer in kernel
space. Use 'array_idx' to prevent any out of bounds speculation. While
retpoline prevents speculating into a userspace directed target it does
not stop the pointer de-reference, the concern is leaking memory
relative to the syscall table base, by observing instruction cache
behavior.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/entry/common.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 03505ffbe1b6..f78bf8bfdfae 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -21,6 +21,7 @@
 #include <linux/export.h>
 #include <linux/context_tracking.h>
 #include <linux/user-return-notifier.h>
+#include <linux/nospec.h>
 #include <linux/uprobes.h>
 #include <linux/livepatch.h>
 #include <linux/syscalls.h>
@@ -284,6 +285,7 @@ __visible void do_syscall_64(struct pt_regs *regs)
 	 * regs->orig_ax, which changes the behavior of some syscalls.
 	 */
 	if (likely((nr & __SYSCALL_MASK) < NR_syscalls)) {
+		nr = array_idx(nr & __SYSCALL_MASK, NR_syscalls);
 		regs->ax = sys_call_table[nr & __SYSCALL_MASK](
 			regs->di, regs->si, regs->dx,
 			regs->r10, regs->r8, regs->r9);
@@ -320,6 +322,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 	}
 
 	if (likely(nr < IA32_NR_syscalls)) {
+		nr = array_idx(nr, IA32_NR_syscalls);
 		/*
 		 * It's possible that a 32-bit syscall implementation
 		 * takes a 64-bit parameter but nonetheless assumes that
