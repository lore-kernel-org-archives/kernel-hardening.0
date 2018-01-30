Subject: [PATCH v6 09/13] x86: sanitize syscall table de-references under
 speculation
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:02:59 -0800
Message-ID: <151727417984.33451.1216731042505722161.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, x86@kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

The syscall table base is a user controlled function pointer in kernel
space. Use array_index_nospec() to prevent any out of bounds
speculation. While retpoline prevents speculating into a userspace
directed target it does not stop the pointer de-reference, the concern
is leaking memory relative to the syscall table base, by observing
instruction cache behavior.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/entry/common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 03505ffbe1b6..390abbc4c915 100644
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
@@ -284,7 +285,8 @@ __visible void do_syscall_64(struct pt_regs *regs)
 	 * regs->orig_ax, which changes the behavior of some syscalls.
 	 */
 	if (likely((nr & __SYSCALL_MASK) < NR_syscalls)) {
-		regs->ax = sys_call_table[nr & __SYSCALL_MASK](
+		nr = array_index_nospec(nr & __SYSCALL_MASK, NR_syscalls);
+		regs->ax = sys_call_table[nr](
 			regs->di, regs->si, regs->dx,
 			regs->r10, regs->r8, regs->r9);
 	}
@@ -320,6 +322,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 	}
 
 	if (likely(nr < IA32_NR_syscalls)) {
+		nr = array_index_nospec(nr, IA32_NR_syscalls);
 		/*
 		 * It's possible that a 32-bit syscall implementation
 		 * takes a 64-bit parameter but nonetheless assumes that
