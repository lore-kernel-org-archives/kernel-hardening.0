Date: Mon, 27 Aug 2018 20:56:30 +0200
In-Reply-To: <20180827185631.163506-1-jannh@google.com>
Message-Id: <20180827185631.163506-7-jannh@google.com>
Mime-Version: 1.0
References: <20180827185631.163506-1-jannh@google.com>
Subject: [PATCH v2 6/7] x86: BUG() when uaccess helpers fault on kernel addresses
From: Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, kernel-hardening@lists.openwall.com, Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, jannh@google.com
Cc: linux-kernel@vger.kernel.org, dvyukov@google.com, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

There have been multiple kernel vulnerabilities that permitted userspace to
pass completely unchecked pointers through to userspace accessors:

 - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
   access_ok() checks")
 - the sg/bsg read/write APIs
 - the infiniband read/write APIs

These don't happen all that often, but when they do happen, it is hard to
test for them properly; and it is probably also hard to discover them with
fuzzing. Even when an unmapped kernel address is supplied to such buggy
code, it just returns -EFAULT instead of doing a proper BUG() or at least
WARN().

This patch attempts to make such misbehaving code a bit more visible by
refusing to do a fixup in the pagefault handler code when a userspace
accessor causes #PF on a kernel address and the current context isn't
whitelisted.

Signed-off-by: Jann Horn <jannh@google.com>
---
 arch/x86/mm/extable.c | 58 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h |  6 +++++
 mm/maccess.c          |  6 +++++
 3 files changed, 70 insertions(+)

diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 4110cca93a08..28298b4e5080 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -112,10 +112,66 @@ __visible bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 }
 EXPORT_SYMBOL_GPL(ex_handler_fprestore);
 
+/* Helper to check whether a uaccess fault indicates a kernel bug. */
+static bool bogus_uaccess(struct pt_regs *regs, int trapnr,
+			  unsigned long fault_addr)
+{
+	/* This is the normal case: #PF with a fault address in userspace. */
+	if (trapnr == X86_TRAP_PF && fault_addr < TASK_SIZE_MAX)
+		return false;
+
+	/*
+	 * This code can be reached for machine checks, but only if the #MC
+	 * handler has already decided that it looks like a candidate for fixup.
+	 * This e.g. happens when attempting to access userspace memory which
+	 * the CPU can't access because of uncorrectable bad memory.
+	 */
+	if (trapnr == X86_TRAP_MC)
+		return false;
+
+	/*
+	 * There are two remaining exception types we might encounter here:
+	 *  - #PF for faulting accesses to kernel addresses
+	 *  - #GP for faulting accesses to noncanonical addresses
+	 * Complain about anything else.
+	 */
+	if (trapnr != X86_TRAP_PF && trapnr != X86_TRAP_GP) {
+		WARN(1, "unexpected trap %d in uaccess\n", trapnr);
+		return false;
+	}
+
+	/*
+	 * This is a faulting memory access in kernel space, on a kernel
+	 * address, in a usercopy function. This can e.g. be caused by improper
+	 * use of helpers like __put_user and by improper attempts to access
+	 * userspace addresses in KERNEL_DS regions.
+	 * The one (semi-)legitimate exception are probe_kernel_{read,write}(),
+	 * which can be invoked from places like kgdb, /dev/mem (for reading)
+	 * and privileged BPF code (for reading).
+	 * The probe_kernel_*() functions set the kernel_uaccess_faults_ok flag
+	 * to tell us that faulting on kernel addresses, and even noncanonical
+	 * addresses, in a userspace accessor does not necessarily imply a
+	 * kernel bug, root might just be doing weird stuff.
+	 */
+	if (current->kernel_uaccess_faults_ok)
+		return false;
+
+	/* This is bad. Refuse the fixup so that we go into die(). */
+	if (trapnr == X86_TRAP_PF) {
+		pr_emerg("BUG: pagefault on kernel address 0x%lx in non-whitelisted uaccess\n",
+			 fault_addr);
+	} else {
+		pr_emerg("BUG: GPF in non-whitelisted uaccess (non-canonical address?)\n");
+	}
+	return true;
+}
+
 __visible bool ex_handler_uaccess(const struct exception_table_entry *fixup,
 				  struct pt_regs *regs, int trapnr,
 				  unsigned long fault_addr)
 {
+	if (bogus_uaccess(regs, trapnr, fault_addr))
+		return false;
 	regs->ip = ex_fixup_addr(fixup);
 	return true;
 }
@@ -125,6 +181,8 @@ __visible bool ex_handler_ext(const struct exception_table_entry *fixup,
 			      struct pt_regs *regs, int trapnr,
 			      unsigned long fault_addr)
 {
+	if (bogus_uaccess(regs, trapnr, fault_addr))
+		return false;
 	/* Special hack for uaccess_err */
 	current->thread.uaccess_err = 1;
 	regs->ip = ex_fixup_addr(fixup);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 00de3e950dd4..7ea3f4afc0ee 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -739,6 +739,12 @@ struct task_struct {
 	unsigned			use_memdelay:1;
 #endif
 
+	/*
+	 * May usercopy functions fault on kernel addresses?
+	 * This is not just a single bit because this can potentially nest.
+	 */
+	unsigned int			kernel_uaccess_faults_ok;
+
 	unsigned long			atomic_flags; /* Flags requiring atomic access. */
 
 	struct restart_block		restart_block;
diff --git a/mm/maccess.c b/mm/maccess.c
index ec00be51a24f..f3416632e5a4 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -30,8 +30,10 @@ long __probe_kernel_read(void *dst, const void *src, size_t size)
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
+	current->kernel_uaccess_faults_ok++;
 	ret = __copy_from_user_inatomic(dst,
 			(__force const void __user *)src, size);
+	current->kernel_uaccess_faults_ok--;
 	pagefault_enable();
 	set_fs(old_fs);
 
@@ -58,7 +60,9 @@ long __probe_kernel_write(void *dst, const void *src, size_t size)
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
+	current->kernel_uaccess_faults_ok++;
 	ret = __copy_to_user_inatomic((__force void __user *)dst, src, size);
+	current->kernel_uaccess_faults_ok--;
 	pagefault_enable();
 	set_fs(old_fs);
 
@@ -94,11 +98,13 @@ long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count)
 
 	set_fs(KERNEL_DS);
 	pagefault_disable();
+	current->kernel_uaccess_faults_ok++;
 
 	do {
 		ret = __get_user(*dst++, (const char __user __force *)src++);
 	} while (dst[-1] && ret == 0 && src - unsafe_addr < count);
 
+	current->kernel_uaccess_faults_ok--;
 	dst[-1] = '\0';
 	pagefault_enable();
 	set_fs(old_fs);
-- 
2.19.0.rc0.228.g281dcd1b4d0-goog
