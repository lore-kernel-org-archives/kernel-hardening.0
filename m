From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 21/27] x86/ftrace: Adapt function tracing for PIE support
Date: Thu, 31 Jan 2019 11:24:28 -0800
Message-Id: <20190131192533.34130-22-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>, Thomas Garnier <thgarnie@google.com>, James Hogan <jhogan@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, nixiaoming <nixiaoming@huawei.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

When using PIE with function tracing, the compiler generates a
call through the GOT (call *__fentry__@GOTPCREL). This instruction
takes 6-bytes instead of 5-bytes with a relative call.

If PIE is enabled, replace the 6th byte of the GOT call by a 1-byte nop
so ftrace can handle the previous 5-bytes as before.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 arch/x86/kernel/ftrace.c | 51 ++++++++++++++++++++++++--
 scripts/recordmcount.c   | 78 ++++++++++++++++++++++++++--------------
 2 files changed, 101 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 8257a59704ae..82feb8c7a47e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -102,7 +102,7 @@ static const unsigned char *ftrace_nop_replace(void)
 
 static int
 ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
-		   unsigned const char *new_code)
+			  unsigned const char *new_code)
 {
 	unsigned char replaced[MCOUNT_INSN_SIZE];
 
@@ -135,6 +135,53 @@ ftrace_modify_code_direct(unsigned long ip, unsigned const char *old_code,
 	return 0;
 }
 
+/* Bytes before call GOT offset */
+static const unsigned char got_call_preinsn[] = { 0xff, 0x15 };
+
+static int
+ftrace_modify_initial_code(unsigned long ip, unsigned const char *old_code,
+			   unsigned const char *new_code)
+{
+	unsigned char replaced[MCOUNT_INSN_SIZE + 1];
+
+	/*
+	 * If PIE is not enabled default to the original approach to code
+	 * modification.
+	 */
+	if (!IS_ENABLED(CONFIG_X86_PIE))
+		return ftrace_modify_code_direct(ip, old_code, new_code);
+
+	ftrace_expected = old_code;
+
+	/* Ensure the instructions point to a call to the GOT */
+	if (probe_kernel_read(replaced, (void *)ip, sizeof(replaced))) {
+		WARN_ONCE(1, "invalid function");
+		return -EFAULT;
+	}
+
+	if (memcmp(replaced, got_call_preinsn, sizeof(got_call_preinsn))) {
+		WARN_ONCE(1, "invalid function call");
+		return -EINVAL;
+	}
+
+	/*
+	 * Build a nop slide with a 5-byte nop and 1-byte nop to keep the ftrace
+	 * hooking algorithm working with the expected 5 bytes instruction.
+	 */
+	memset(replaced, ideal_nops[1][0], sizeof(replaced));
+	memcpy(replaced, new_code, MCOUNT_INSN_SIZE);
+
+	ip = text_ip_addr(ip);
+
+	if (probe_kernel_write((void *)ip, replaced, sizeof(replaced)))
+		return -EPERM;
+
+	sync_core();
+
+	return 0;
+
+}
+
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
@@ -153,7 +200,7 @@ int ftrace_make_nop(struct module *mod,
 	 * just modify the code directly.
 	 */
 	if (addr == MCOUNT_ADDR)
-		return ftrace_modify_code_direct(rec->ip, old, new);
+		return ftrace_modify_initial_code(rec->ip, old, new);
 
 	ftrace_expected = NULL;
 
diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index a50a2aa963ad..4b8bd746ed2e 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -171,33 +171,9 @@ umalloc(size_t size)
 	return addr;
 }
 
-static unsigned char ideal_nop5_x86_64[5] = { 0x0f, 0x1f, 0x44, 0x00, 0x00 };
-static unsigned char ideal_nop5_x86_32[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
-static unsigned char *ideal_nop;
-
 static char rel_type_nop;
-
 static int (*make_nop)(void *map, size_t const offset);
-
-static int make_nop_x86(void *map, size_t const offset)
-{
-	uint32_t *ptr;
-	unsigned char *op;
-
-	/* Confirm we have 0xe8 0x0 0x0 0x0 0x0 */
-	ptr = map + offset;
-	if (*ptr != 0)
-		return -1;
-
-	op = map + offset - 1;
-	if (*op != 0xe8)
-		return -1;
-
-	/* convert to nop */
-	ulseek(fd_map, offset - 1, SEEK_SET);
-	uwrite(fd_map, ideal_nop, 5);
-	return 0;
-}
+static unsigned char *ideal_nop;
 
 static unsigned char ideal_nop4_arm_le[4] = { 0x00, 0x00, 0xa0, 0xe1 }; /* mov r0, r0 */
 static unsigned char ideal_nop4_arm_be[4] = { 0xe1, 0xa0, 0x00, 0x00 }; /* mov r0, r0 */
@@ -447,6 +423,49 @@ static void MIPS64_r_info(Elf64_Rel *const rp, unsigned sym, unsigned type)
 	}).r_info;
 }
 
+static unsigned char ideal_nop5_x86_64[5] = { 0x0f, 0x1f, 0x44, 0x00, 0x00 };
+static unsigned char ideal_nop6_x86_64[6] = { 0x66, 0x0f, 0x1f, 0x44, 0x00, 0x00 };
+static unsigned char ideal_nop5_x86_32[5] = { 0x3e, 0x8d, 0x74, 0x26, 0x00 };
+static size_t ideal_nop_x86_size;
+
+static unsigned char stub_default_x86[2] = { 0xe8, 0x00 };   /* call relative */
+static unsigned char stub_got_x86[3] = { 0xff, 0x15, 0x00 }; /* call .got */
+static unsigned char *stub_x86;
+static size_t stub_x86_size;
+
+static int make_nop_x86(void *map, size_t const offset)
+{
+	uint32_t *ptr;
+	size_t stub_offset = offset - stub_x86_size;
+
+	/* confirm we have the expected stub */
+	ptr = map + stub_offset;
+	if (memcmp(ptr, stub_x86, stub_x86_size))
+		return -1;
+
+	/* convert to nop */
+	ulseek(fd_map, stub_offset, SEEK_SET);
+	uwrite(fd_map, ideal_nop, ideal_nop_x86_size);
+	return 0;
+}
+
+/* Swap the stub and nop for a got call if the binary is built with PIE */
+static int is_fake_mcount_x86_x64(Elf64_Rel const *rp)
+{
+	if (ELF64_R_TYPE(rp->r_info) == R_X86_64_GOTPCREL) {
+		ideal_nop = ideal_nop6_x86_64;
+		ideal_nop_x86_size = sizeof(ideal_nop6_x86_64);
+		stub_x86 = stub_got_x86;
+		stub_x86_size = sizeof(stub_got_x86);
+		mcount_adjust_64 = 1 - stub_x86_size;
+	}
+
+	/* Once the relocation was checked, rollback to default */
+	is_fake_mcount64 = fn_is_fake_mcount64;
+	return is_fake_mcount64(rp);
+}
+
+
 static void
 do_file(char const *const fname)
 {
@@ -509,6 +528,9 @@ do_file(char const *const fname)
 		rel_type_nop = R_386_NONE;
 		make_nop = make_nop_x86;
 		ideal_nop = ideal_nop5_x86_32;
+		ideal_nop_x86_size = sizeof(ideal_nop5_x86_32);
+		stub_x86 = stub_default_x86;
+		stub_x86_size = sizeof(stub_default_x86);
 		mcount_adjust_32 = -1;
 		break;
 	case EM_ARM:	 reltype = R_ARM_ABS32;
@@ -533,9 +555,13 @@ do_file(char const *const fname)
 	case EM_X86_64:
 		make_nop = make_nop_x86;
 		ideal_nop = ideal_nop5_x86_64;
+		ideal_nop_x86_size = sizeof(ideal_nop5_x86_64);
+		stub_x86 = stub_default_x86;
+		stub_x86_size = sizeof(stub_default_x86);
 		reltype = R_X86_64_64;
 		rel_type_nop = R_X86_64_NONE;
-		mcount_adjust_64 = -1;
+		is_fake_mcount64 = is_fake_mcount_x86_x64;
+		mcount_adjust_64 = 1 - stub_x86_size;
 		break;
 	}  /* end switch */
 
-- 
2.20.1.495.gaa96b0ce6b-goog
