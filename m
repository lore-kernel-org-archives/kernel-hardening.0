From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 44/64] x86/syscall: Sanitize syscall table de-references under speculation
Date: Mon,  5 Feb 2018 10:23:03 -0800
Message-Id: <20180205182140.385565178@linuxfoundation.org>
In-Reply-To: <20180205182138.571333346@linuxfoundation.org>
References: <20180205182138.571333346@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams dan.j.williams@intel.com

commit 2fbd7af5af8665d18bcefae3e9700be07e22b681

The syscall table base is a user controlled function pointer in kernel
space. Use array_index_nospec() to prevent any out of bounds speculation.

While retpoline prevents speculating into a userspace directed target it
does not stop the pointer de-reference, the concern is leaking memory
relative to the syscall table base, by observing instruction cache
behavior.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727417984.33451.1216731042505722161.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/entry/common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

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
@@ -284,7 +285,8 @@ __visible void do_syscall_64(struct pt_r
 	 * regs->orig_ax, which changes the behavior of some syscalls.
 	 */
 	if (likely((nr & __SYSCALL_MASK) < NR_syscalls)) {
-		regs->ax = sys_call_table[nr & __SYSCALL_MASK](
+		nr = array_index_nospec(nr & __SYSCALL_MASK, NR_syscalls);
+		regs->ax = sys_call_table[nr](
 			regs->di, regs->si, regs->dx,
 			regs->r10, regs->r8, regs->r9);
 	}
@@ -320,6 +322,7 @@ static __always_inline void do_syscall_3
 	}
 
 	if (likely(nr < IA32_NR_syscalls)) {
+		nr = array_index_nospec(nr, IA32_NR_syscalls);
 		/*
 		 * It's possible that a 32-bit syscall implementation
 		 * takes a 64-bit parameter but nonetheless assumes that
