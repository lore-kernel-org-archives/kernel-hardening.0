Date: Mon, 27 Aug 2018 20:56:25 +0200
In-Reply-To: <20180827185631.163506-1-jannh@google.com>
Message-Id: <20180827185631.163506-2-jannh@google.com>
Mime-Version: 1.0
References: <20180827185631.163506-1-jannh@google.com>
Subject: [PATCH v2 1/7] x86: refactor kprobes_fault() like kprobe_exceptions_notify()
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is an extension of commit b506a9d08bae ("x86: code clarification patch
to Kprobes arch code"). As that commit explains, even though
kprobe_running() can't be called with preemption enabled, you don't have to
disable preemption - if preemption is on, you can't be in a kprobe.

Also, use X86_TRAP_PF instead of 14.

Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/x86/mm/fault.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b9123c497e0a..2254a30533b9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -44,17 +44,14 @@ kmmio_fault(struct pt_regs *regs, unsigned long addr)
 
 static nokprobe_inline int kprobes_fault(struct pt_regs *regs)
 {
-	int ret = 0;
-
-	/* kprobe_running() needs smp_processor_id() */
-	if (kprobes_built_in() && !user_mode(regs)) {
-		preempt_disable();
-		if (kprobe_running() && kprobe_fault_handler(regs, 14))
-			ret = 1;
-		preempt_enable();
-	}
-
-	return ret;
+	/*
+	 * To be potentially processing a kprobe fault and to be allowed to call
+	 * kprobe_running(), we have to be non-preemptible.
+	 */
+	if (kprobes_built_in() && !user_mode(regs) && !preemptible() &&
+	    kprobe_running() && kprobe_fault_handler(regs, X86_TRAP_PF))
+		return 1;
+	return 0;
 }
 
 /*
-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
