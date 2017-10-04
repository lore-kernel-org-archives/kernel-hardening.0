From: Thomas Garnier <thgarnie@google.com>
Date: Wed,  4 Oct 2017 14:19:56 -0700
Message-Id: <20171004212003.28296-21-thgarnie@google.com>
In-Reply-To: <20171004212003.28296-1-thgarnie@google.com>
References: <20171004212003.28296-1-thgarnie@google.com>
Subject: [kernel-hardening] [RFC v3 20/27] x86/ftrace: Adapt function tracing for PIE support
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Garnier <thgarnie@google.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, Chris Metcalf <cmetcalf@mellanox.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <mawilcox@microsoft.com>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, Rob Landley <rob@landley.net>, "H . J . Lu" <hjl.tools@gmail.com>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

When using -fPIE/PIC with function tracing, the compiler generates a
call through the GOT (call *__fentry__@GOTPCREL). This instruction
takes 6 bytes instead of 5 on the usual relative call.

With this change, function tracing supports 6 bytes on traceable
function and can still replace relative calls on the ftrace assembly
functions.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/ftrace.h   |  23 +++++-
 arch/x86/include/asm/sections.h |   4 +
 arch/x86/kernel/ftrace.c        | 168 ++++++++++++++++++++++++++--------------
 arch/x86/kernel/module.lds      |   3 +
 4 files changed, 139 insertions(+), 59 deletions(-)
 create mode 100644 arch/x86/kernel/module.lds

diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
index eccd0ac6bc38..b8bbcc7fad7f 100644
--- a/arch/x86/include/asm/ftrace.h
+++ b/arch/x86/include/asm/ftrace.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_X86_FTRACE_H
 #define _ASM_X86_FTRACE_H
 
+
 #ifdef CONFIG_FUNCTION_TRACER
 #ifdef CC_USING_FENTRY
 # define MCOUNT_ADDR		((unsigned long)(__fentry__))
@@ -8,7 +9,19 @@
 # define MCOUNT_ADDR		((unsigned long)(mcount))
 # define HAVE_FUNCTION_GRAPH_FP_TEST
 #endif
-#define MCOUNT_INSN_SIZE	5 /* sizeof mcount call */
+
+#define MCOUNT_RELINSN_SIZE	5 /* sizeof relative (call or jump) */
+#define MCOUNT_GOTCALL_SIZE	6 /* sizeof call *got */
+
+/*
+ * MCOUNT_INSN_SIZE is the highest size of instructions based on the
+ * configuration.
+ */
+#ifdef CONFIG_X86_PIE
+#define MCOUNT_INSN_SIZE	MCOUNT_GOTCALL_SIZE
+#else
+#define MCOUNT_INSN_SIZE	MCOUNT_RELINSN_SIZE
+#endif
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 #define ARCH_SUPPORTS_FTRACE_OPS 1
@@ -17,6 +30,8 @@
 #define HAVE_FUNCTION_GRAPH_RET_ADDR_PTR
 
 #ifndef __ASSEMBLY__
+#include <asm/sections.h>
+
 extern void mcount(void);
 extern atomic_t modifying_ftrace_code;
 extern void __fentry__(void);
@@ -24,9 +39,11 @@ extern void __fentry__(void);
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
 {
 	/*
-	 * addr is the address of the mcount call instruction.
-	 * recordmcount does the necessary offset calculation.
+	 * addr is the address of the mcount call instruction. PIE has always a
+	 * byte added to the start of the function.
 	 */
+	if (IS_ENABLED(CONFIG_X86_PIE))
+		addr -= 1;
 	return addr;
 }
 
diff --git a/arch/x86/include/asm/sections.h b/arch/x86/include/asm/sections.h
index 2f75f30cb2f6..6b2d496cf1aa 100644
--- a/arch/x86/include/asm/sections.h
+++ b/arch/x86/include/asm/sections.h
@@ -11,4 +11,8 @@ extern struct exception_table_entry __stop___ex_table[];
 extern char __end_rodata_hpage_align[];
 #endif
 
+#if defined(CONFIG_X86_PIE)
+extern char __start_got[], __end_got[];
+#endif
+
 #endif	/* _ASM_X86_SECTIONS_H */
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9bef1bbeba63..41d8c4c4306d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -58,12 +58,17 @@ static int ftrace_calc_offset(long ip, long addr)
 	return (int)(addr - ip);
 }
 
-static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
+static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr,
+					  unsigned int size)
 {
 	static union ftrace_code_union calc;
 
+	/* On PIE, fill the rest of the buffer with nops */
+	if (IS_ENABLED(CONFIG_X86_PIE))
+		memset(calc.code, ideal_nops[1][0], sizeof(calc.code));
+
 	calc.e8		= 0xe8;
-	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
+	calc.offset	= ftrace_calc_offset(ip + MCOUNT_RELINSN_SIZE, addr);
 
 	/*
 	 * No locking needed, this must be called via kstop_machine
@@ -72,6 +77,44 @@ static unsigned char *ftrace_call_replace(unsigned long ip, unsigned long addr)
 	return calc.code;
 }
 
+#ifdef CONFIG_X86_PIE
+union ftrace_code_got_union {
+	char code[MCOUNT_INSN_SIZE];
+	struct {
+		unsigned short ff15;
+		int offset;
+	} __attribute__((packed));
+};
+
+/* Used to identify a mcount GOT call on PIE */
+static unsigned char *ftrace_original_call(struct module* mod, unsigned long ip,
+					   unsigned long addr,
+					   unsigned int size)
+{
+	static union ftrace_code_got_union calc;
+	unsigned long gotaddr;
+
+	calc.ff15 = 0x15ff;
+
+	gotaddr = module_find_got_entry(mod, addr);
+	if (!gotaddr) {
+		pr_err("Failed to find GOT entry for 0x%lx\n", addr);
+		return NULL;
+	}
+
+	calc.offset = ftrace_calc_offset(ip + MCOUNT_GOTCALL_SIZE, gotaddr);
+	return calc.code;
+}
+#else
+static unsigned char *ftrace_original_call(struct module* mod, unsigned long ip,
+					   unsigned long addr,
+					   unsigned int size)
+{
+	return ftrace_call_replace(ip, addr, size);
+}
+
+#endif
+
 static inline int
 within(unsigned long addr, unsigned long start, unsigned long end)
 {
@@ -94,16 +137,18 @@ static unsigned long text_ip_addr(unsigned long ip)
 	return ip;
 }
 
-static const unsigned char *ftrace_nop_replace(void)
+static const unsigned char *ftrace_nop_replace(unsigned int size)
 {
-	return ideal_nops[NOP_ATOMIC5];
+	return ideal_nops[size == 5 ? NOP_ATOMIC5 : size];
 }
 
 static int
-ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
-		   unsigned const char *new_code)
+ftrace_modify_code_direct(struct dyn_ftrace *rec, unsigned const char *old_code,
+			  unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
+	unsigned long ip = rec->ip;
+	unsigned int size = MCOUNT_INSN_SIZE;
 
 	ftrace_expected = old_code;
 
@@ -116,17 +161,17 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 	 */
 
 	/* read the text we want to modify */
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (probe_kernel_read(replaced, (void *)ip, size))
 		return -EFAULT;
 
 	/* Make sure it is what we expect it to be */
-	if (memcmp(replaced, old_code, MCOUNT_INSN_SIZE) != 0)
+	if (memcmp(replaced, old_code, size) != 0)
 		return -EINVAL;
 
 	ip = text_ip_addr(ip);
 
 	/* replace the text with the new text */
-	if (probe_kernel_write((void *)ip, new_code, MCOUNT_INSN_SIZE))
+	if (probe_kernel_write((void *)ip, new_code, size))
 		return -EPERM;
 
 	sync_core();
@@ -139,9 +184,7 @@ int ftrace_make_nop(struct module *mod,
 {
 	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
-
-	old = ftrace_call_replace(ip, addr);
-	new = ftrace_nop_replace();
+	unsigned int size = MCOUNT_INSN_SIZE;
 
 	/*
 	 * On boot up, and when modules are loaded, the MCOUNT_ADDR
@@ -151,14 +194,20 @@ int ftrace_make_nop(struct module *mod,
 	 * We do not want to use the breakpoint version in this case,
 	 * just modify the code directly.
 	 */
-	if (addr == MCOUNT_ADDR)
-		return ftrace_modify_code_direct(rec->ip, old, new);
+	if (addr != MCOUNT_ADDR) {
+		ftrace_expected = NULL;
 
-	ftrace_expected = NULL;
+		/* Normal cases use add_brk_on_nop */
+		WARN_ONCE(1, "invalid use of ftrace_make_nop");
+		return -EINVAL;
+	}
 
-	/* Normal cases use add_brk_on_nop */
-	WARN_ONCE(1, "invalid use of ftrace_make_nop");
-	return -EINVAL;
+	old = ftrace_original_call(mod, ip, addr, size);
+	if (!old)
+		return -EINVAL;
+	new = ftrace_nop_replace(size);
+
+	return ftrace_modify_code_direct(rec, old, new);
 }
 
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
@@ -166,11 +215,11 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned const char *new, *old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_nop_replace();
-	new = ftrace_call_replace(ip, addr);
+	old = ftrace_nop_replace(MCOUNT_INSN_SIZE);
+	new = ftrace_call_replace(ip, addr, MCOUNT_INSN_SIZE);
 
 	/* Should only be called when module is loaded */
-	return ftrace_modify_code_direct(rec->ip, old, new);
+	return ftrace_modify_code_direct(rec, old, new);
 }
 
 /*
@@ -233,7 +282,7 @@ static int update_ftrace_func(unsigned long ip, void *new)
 	unsigned char old[MCOUNT_INSN_SIZE];
 	int ret;
 
-	memcpy(old, (void *)ip, MCOUNT_INSN_SIZE);
+	memcpy(old, (void *)ip, MCOUNT_RELINSN_SIZE);
 
 	ftrace_update_func = ip;
 	/* Make sure the breakpoints see the ftrace_update_func update */
@@ -255,13 +304,14 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	unsigned char *new;
 	int ret;
 
-	new = ftrace_call_replace(ip, (unsigned long)func);
+	new = ftrace_call_replace(ip, (unsigned long)func, MCOUNT_RELINSN_SIZE);
 	ret = update_ftrace_func(ip, new);
 
 	/* Also update the regs callback function */
 	if (!ret) {
 		ip = (unsigned long)(&ftrace_regs_call);
-		new = ftrace_call_replace(ip, (unsigned long)func);
+		new = ftrace_call_replace(ip, (unsigned long)func,
+					  MCOUNT_RELINSN_SIZE);
 		ret = update_ftrace_func(ip, new);
 	}
 
@@ -309,18 +359,18 @@ static int ftrace_write(unsigned long ip, const char *val, int size)
 	return 0;
 }
 
-static int add_break(unsigned long ip, const char *old)
+static int add_break(unsigned long ip, const char *old, unsigned int size)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 	unsigned char brk = BREAKPOINT_INSTRUCTION;
 
-	if (probe_kernel_read(replaced, (void *)ip, MCOUNT_INSN_SIZE))
+	if (probe_kernel_read(replaced, (void *)ip, size))
 		return -EFAULT;
 
 	ftrace_expected = old;
 
 	/* Make sure it is what we expect it to be */
-	if (memcmp(replaced, old, MCOUNT_INSN_SIZE) != 0)
+	if (memcmp(replaced, old, size) != 0)
 		return -EINVAL;
 
 	return ftrace_write(ip, &brk, 1);
@@ -330,20 +380,22 @@ static int add_brk_on_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned const char *old;
 	unsigned long ip = rec->ip;
+	unsigned int size = MCOUNT_INSN_SIZE;
 
-	old = ftrace_call_replace(ip, addr);
+	old = ftrace_call_replace(ip, addr, size);
 
-	return add_break(rec->ip, old);
+	return add_break(rec->ip, old, size);
 }
 
 
 static int add_brk_on_nop(struct dyn_ftrace *rec)
 {
 	unsigned const char *old;
+	unsigned int size = MCOUNT_INSN_SIZE;
 
-	old = ftrace_nop_replace();
+	old = ftrace_nop_replace(size);
 
-	return add_break(rec->ip, old);
+	return add_break(rec->ip, old, size);
 }
 
 static int add_breakpoints(struct dyn_ftrace *rec, int enable)
@@ -386,22 +438,23 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	const unsigned char *nop;
 	unsigned long ftrace_addr;
 	unsigned long ip = rec->ip;
+	unsigned int size = MCOUNT_INSN_SIZE;
 
 	/* If we fail the read, just give up */
-	if (probe_kernel_read(ins, (void *)ip, MCOUNT_INSN_SIZE))
+	if (probe_kernel_read(ins, (void *)ip, size))
 		return -EFAULT;
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != brk)
 		return 0;
 
-	nop = ftrace_nop_replace();
+	nop = ftrace_nop_replace(size);
 
 	/*
 	 * If the last 4 bytes of the instruction do not match
 	 * a nop, then we assume that this is a call to ftrace_addr.
 	 */
-	if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0) {
+	if (memcmp(&ins[1], &nop[1], size - 1) != 0) {
 		/*
 		 * For extra paranoidism, we check if the breakpoint is on
 		 * a call that would actually jump to the ftrace_addr.
@@ -409,18 +462,18 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 		 * a disaster.
 		 */
 		ftrace_addr = ftrace_get_addr_new(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
+		nop = ftrace_call_replace(ip, ftrace_addr, size);
 
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) == 0)
+		if (memcmp(&ins[1], &nop[1], size - 1) == 0)
 			goto update;
 
 		/* Check both ftrace_addr and ftrace_old_addr */
 		ftrace_addr = ftrace_get_addr_curr(rec);
-		nop = ftrace_call_replace(ip, ftrace_addr);
+		nop = ftrace_call_replace(ip, ftrace_addr, size);
 
 		ftrace_expected = nop;
 
-		if (memcmp(&ins[1], &nop[1], MCOUNT_INSN_SIZE - 1) != 0)
+		if (memcmp(&ins[1], &nop[1], size - 1) != 0)
 			return -EINVAL;
 	}
 
@@ -428,30 +481,33 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	return ftrace_write(ip, nop, 1);
 }
 
-static int add_update_code(unsigned long ip, unsigned const char *new)
+static int add_update_code(unsigned long ip, unsigned const char *new,
+			   unsigned int size)
 {
 	/* skip breakpoint */
 	ip++;
 	new++;
-	return ftrace_write(ip, new, MCOUNT_INSN_SIZE - 1);
+	return ftrace_write(ip, new, size - 1);
 }
 
 static int add_update_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned long ip = rec->ip;
+	unsigned int size = MCOUNT_INSN_SIZE;
 	unsigned const char *new;
 
-	new = ftrace_call_replace(ip, addr);
-	return add_update_code(ip, new);
+	new = ftrace_call_replace(ip, addr, size);
+	return add_update_code(ip, new, size);
 }
 
 static int add_update_nop(struct dyn_ftrace *rec)
 {
 	unsigned long ip = rec->ip;
+	unsigned int size = MCOUNT_INSN_SIZE;
 	unsigned const char *new;
 
-	new = ftrace_nop_replace();
-	return add_update_code(ip, new);
+	new = ftrace_nop_replace(size);
+	return add_update_code(ip, new, size);
 }
 
 static int add_update(struct dyn_ftrace *rec, int enable)
@@ -485,7 +541,7 @@ static int finish_update_call(struct dyn_ftrace *rec, unsigned long addr)
 	unsigned long ip = rec->ip;
 	unsigned const char *new;
 
-	new = ftrace_call_replace(ip, addr);
+	new = ftrace_call_replace(ip, addr, MCOUNT_INSN_SIZE);
 
 	return ftrace_write(ip, new, 1);
 }
@@ -495,7 +551,7 @@ static int finish_update_nop(struct dyn_ftrace *rec)
 	unsigned long ip = rec->ip;
 	unsigned const char *new;
 
-	new = ftrace_nop_replace();
+	new = ftrace_nop_replace(MCOUNT_INSN_SIZE);
 
 	return ftrace_write(ip, new, 1);
 }
@@ -619,13 +675,13 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 {
 	int ret;
 
-	ret = add_break(ip, old_code);
+	ret = add_break(ip, old_code, MCOUNT_RELINSN_SIZE);
 	if (ret)
 		goto out;
 
 	run_sync();
 
-	ret = add_update_code(ip, new_code);
+	ret = add_update_code(ip, new_code, MCOUNT_RELINSN_SIZE);
 	if (ret)
 		goto fail_update;
 
@@ -670,7 +726,7 @@ static unsigned char *ftrace_jmp_replace(unsigned long ip, unsigned long addr)
 
 	/* Jmp not a call (ignore the .e8) */
 	calc.e8		= 0xe9;
-	calc.offset	= ftrace_calc_offset(ip + MCOUNT_INSN_SIZE, addr);
+	calc.offset	= ftrace_calc_offset(ip + MCOUNT_RELINSN_SIZE, addr);
 
 	/*
 	 * ftrace external locks synchronize the access to the static variable.
@@ -766,11 +822,11 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	 * the jmp to ftrace_epilogue, as well as the address of
 	 * the ftrace_ops this trampoline is used for.
 	 */
-	trampoline = alloc_tramp(size + MCOUNT_INSN_SIZE + sizeof(void *));
+	trampoline = alloc_tramp(size + MCOUNT_RELINSN_SIZE + sizeof(void *));
 	if (!trampoline)
 		return 0;
 
-	*tramp_size = size + MCOUNT_INSN_SIZE + sizeof(void *);
+	*tramp_size = size + MCOUNT_RELINSN_SIZE + sizeof(void *);
 
 	/* Copy ftrace_caller onto the trampoline memory */
 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
@@ -783,7 +839,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	/* The trampoline ends with a jmp to ftrace_epilogue */
 	jmp = ftrace_jmp_replace(ip, (unsigned long)ftrace_epilogue);
-	memcpy(trampoline + size, jmp, MCOUNT_INSN_SIZE);
+	memcpy(trampoline + size, jmp, MCOUNT_RELINSN_SIZE);
 
 	/*
 	 * The address of the ftrace_ops that is used for this trampoline
@@ -793,7 +849,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	 * the global function_trace_op variable.
 	 */
 
-	ptr = (unsigned long *)(trampoline + size + MCOUNT_INSN_SIZE);
+	ptr = (unsigned long *)(trampoline + size + MCOUNT_RELINSN_SIZE);
 	*ptr = (unsigned long)ops;
 
 	op_offset -= start_offset;
@@ -868,7 +924,7 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 	func = ftrace_ops_get_func(ops);
 
 	/* Do a safe modify in case the trampoline is executing */
-	new = ftrace_call_replace(ip, (unsigned long)func);
+	new = ftrace_call_replace(ip, (unsigned long)func, MCOUNT_RELINSN_SIZE);
 	ret = update_ftrace_func(ip, new);
 	set_memory_ro(ops->trampoline, npages);
 
@@ -882,7 +938,7 @@ static void *addr_from_call(void *ptr)
 	union ftrace_code_union calc;
 	int ret;
 
-	ret = probe_kernel_read(&calc, ptr, MCOUNT_INSN_SIZE);
+	ret = probe_kernel_read(&calc, ptr, MCOUNT_RELINSN_SIZE);
 	if (WARN_ON_ONCE(ret < 0))
 		return NULL;
 
@@ -892,7 +948,7 @@ static void *addr_from_call(void *ptr)
 		return NULL;
 	}
 
-	return ptr + MCOUNT_INSN_SIZE + calc.offset;
+	return ptr + MCOUNT_RELINSN_SIZE + calc.offset;
 }
 
 void prepare_ftrace_return(unsigned long self_addr, unsigned long *parent,
diff --git a/arch/x86/kernel/module.lds b/arch/x86/kernel/module.lds
new file mode 100644
index 000000000000..fd6e95a4b454
--- /dev/null
+++ b/arch/x86/kernel/module.lds
@@ -0,0 +1,3 @@
+SECTIONS {
+	.got (NOLOAD) : { BYTE(0) }
+}
-- 
2.14.2.920.gcf0c67979c-goog
