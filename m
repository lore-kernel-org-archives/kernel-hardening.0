Date: Tue, 26 Feb 2019 15:45:30 -0800
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2] lkdtm: Check for SMEP clearing protections
Message-ID: <20190226234530.GA9209@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226233647.28547-1-keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This adds an x86-specific test for pinned cr4 bits. A successful test
will validate pinning and check the ROP-style call-middle-of-function
defense, if needed. For example, in the case of native_write_cr4()
looking like this:

ffffffff8171bce0 <native_write_cr4>:
ffffffff8171bce0:       48 8b 35 79 46 f2 00    mov    0xf24679(%rip),%rsi
ffffffff8171bce7:       48 09 f7                or     %rsi,%rdi
ffffffff8171bcea:       0f 22 e7                mov    %rdi,%cr4
...
ffffffff8171bd5a:       c3                      retq

The UNSET_SMEP test will jump to ffffffff8171bcea (the mov to cr4)
instead of ffffffff8171bce0 (native_write_cr4() entry) to simulate a
direct-call bypass attempt.

Expected successful results:

  # echo UNSET_SMEP > /sys/kernel/debug/provoke-crash/DIRECT
  # dmesg
  [   79.594433] lkdtm: Performing direct entry UNSET_SMEP
  [   79.596459] lkdtm: trying to clear SMEP normally
  [   79.598406] lkdtm: ok: SMEP did not get cleared
  [   79.599981] lkdtm: trying to clear SMEP with call gadget
  [   79.601810] ------------[ cut here ]------------
  [   79.603421] Attempt to unpin cr4 bits: 100000; bypass attack?!
  ...
  [   79.650170] ---[ end trace 2452ca0f6126242e ]---
  [   79.650937] lkdtm: ok: SMEP removal was reverted

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: fix 64 vs 256 loop-end comparison, use a #define instead
---
 drivers/misc/lkdtm/bugs.c  | 61 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 3 files changed, 63 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 7eebbdfbcacd..6176384b4f85 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -255,3 +255,64 @@ void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
 
 	pr_err("FAIL: accessed page after stack!\n");
 }
+
+void lkdtm_UNSET_SMEP(void)
+{
+#ifdef CONFIG_X86_64
+#define MOV_CR4_DEPTH	64
+	void (*direct_write_cr4)(unsigned long val);
+	unsigned char *insn;
+	unsigned long cr4;
+	int i;
+
+	cr4 = native_read_cr4();
+
+	if ((cr4 & X86_CR4_SMEP) != X86_CR4_SMEP) {
+		pr_err("FAIL: SMEP not in use\n");
+		return;
+	}
+	cr4 &= ~(X86_CR4_SMEP);
+
+	pr_info("trying to clear SMEP normally\n");
+	native_write_cr4(cr4);
+	if (cr4 == native_read_cr4()) {
+		pr_err("FAIL: pinning SMEP failed!\n");
+		cr4 |= X86_CR4_SMEP;
+		pr_info("restoring SMEP\n");
+		native_write_cr4(cr4);
+		return;
+	}
+	pr_info("ok: SMEP did not get cleared\n");
+
+	/*
+	 * To test the post-write pinning verification we need to call
+	 * directly into the the middle of native_write_cr4() where the
+	 * cr4 write happens, skipping the pinning. This searches for
+	 * the cr4 writing instruction.
+	 */
+	insn = (unsigned char *)native_write_cr4;
+	for (i = 0; i < MOV_CR4_DEPTH; i++) {
+		/* mov %rdi, %cr4 */
+		if (insn[i] == 0x0f && insn[i+1] == 0x22 && insn[i+2] == 0xe7)
+			break;
+	}
+	if (i >= MOV_CR4_DEPTH) {
+		pr_info("ok: cannot locate cr4 writing call gadget\n");
+		return;
+	}
+	direct_write_cr4 = (void *)(insn + i);
+
+	pr_info("trying to clear SMEP with call gadget\n");
+	direct_write_cr4(cr4);
+	if (native_read_cr4() & X86_CR4_SMEP) {
+		pr_info("ok: SMEP removal was reverted\n");
+	} else {
+		pr_err("FAIL: cleared SMEP not detected!\n");
+		cr4 |= X86_CR4_SMEP;
+		pr_info("restoring SMEP\n");
+		native_write_cr4(cr4);
+	}
+#else
+	pr_err("FAIL: this test is x86_64-only\n");
+#endif
+}
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 2837dc77478e..fd668776414b 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -132,6 +132,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(CORRUPT_USER_DS),
+	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(CORRUPT_STACK_STRONG),
 	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 3c6fd327e166..9c78d7e21c13 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -26,6 +26,7 @@ void lkdtm_CORRUPT_LIST_DEL(void);
 void lkdtm_CORRUPT_USER_DS(void);
 void lkdtm_STACK_GUARD_PAGE_LEADING(void);
 void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
+void lkdtm_UNSET_SMEP(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
-- 
2.17.1


-- 
Kees Cook
