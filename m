From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: [stable 4.4 15/29] x86/syscall: Sanitize syscall table de-references under speculation
Date: Fri, 23 Feb 2018 11:42:04 +0100
Message-Id: <1519382538-15143-16-git-send-email-jinpu.wangl@profitbricks.com>
In-Reply-To: <1519382538-15143-1-git-send-email-jinpu.wangl@profitbricks.com>
References: <1519382538-15143-1-git-send-email-jinpu.wangl@profitbricks.com>
To: gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, alan@linux.intel.com, David Woodhouse <dwmw@amazon.co.uk>, Jack Wang <jinpu.wang@profitbricks.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dan Williams <dan.j.williams@intel.com>

(cherry picked from commit 2fbd7af5af8665d18bcefae3e9700be07e22b681)

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
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[jwang: port to 4.4, no syscall_64]
Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 arch/x86/entry/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 1a4477c..b5eb1cc 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -20,6 +20,7 @@
 #include <linux/export.h>
 #include <linux/context_tracking.h>
 #include <linux/user-return-notifier.h>
+#include <linux/nospec.h>
 #include <linux/uprobes.h>
 
 #include <asm/desc.h>
@@ -381,6 +382,7 @@ __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 	}
 
 	if (likely(nr < IA32_NR_syscalls)) {
+		nr = array_index_nospec(nr, IA32_NR_syscalls);
 		/*
 		 * It's possible that a 32-bit syscall implementation
 		 * takes a 64-bit parameter but nonetheless assumes that
-- 
2.7.4
