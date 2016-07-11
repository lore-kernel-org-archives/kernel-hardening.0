Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:53:50 -0700
Message-Id: <2a53fd4c1f6c0e1f71d01ef46372df7f99edc4c2.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 17/32] x86: Move addr_limit to thread_struct
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

thread_info is a legacy mess.  To prepare for its partial removal,
move addr_limit out.

As an added benefit, this way is simpler.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/include/asm/checksum_32.h |  3 +--
 arch/x86/include/asm/processor.h   | 17 ++++++++++-------
 arch/x86/include/asm/thread_info.h |  7 -------
 arch/x86/include/asm/uaccess.h     |  6 +++---
 arch/x86/kernel/asm-offsets.c      |  4 +++-
 arch/x86/lib/copy_user_64.S        |  8 ++++----
 arch/x86/lib/csum-wrappers_64.c    |  1 +
 arch/x86/lib/getuser.S             | 20 ++++++++++----------
 arch/x86/lib/putuser.S             | 10 +++++-----
 arch/x86/lib/usercopy_64.c         |  2 +-
 drivers/pnp/isapnp/proc.c          |  2 +-
 lib/bitmap.c                       |  2 +-
 12 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 532f85e6651f..7b53743ed267 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -2,8 +2,7 @@
 #define _ASM_X86_CHECKSUM_32_H
 
 #include <linux/in6.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /*
  * computes the checksum of a memory block at buff, length len,
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index f53ae57bd985..a2e20d6d01fe 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -371,6 +371,10 @@ extern unsigned int xstate_size;
 
 struct perf_event;
 
+typedef struct {
+	unsigned long		seg;
+} mm_segment_t;
+
 struct thread_struct {
 	/* Cached TLS descriptors: */
 	struct desc_struct	tls_array[GDT_ENTRY_TLS_ENTRIES];
@@ -419,6 +423,8 @@ struct thread_struct {
 	/* Max allowed port in the bitmap, in bytes: */
 	unsigned		io_bitmap_max;
 
+	mm_segment_t		addr_limit;
+
 	unsigned int		sig_on_uaccess_error:1;
 	unsigned int		uaccess_err:1;	/* uaccess failed */
 
@@ -493,11 +499,6 @@ static inline void load_sp0(struct tss_struct *tss,
 #define set_iopl_mask native_set_iopl_mask
 #endif /* CONFIG_PARAVIRT */
 
-typedef struct {
-	unsigned long		seg;
-} mm_segment_t;
-
-
 /* Free all resources held by a thread. */
 extern void release_thread(struct task_struct *);
 
@@ -719,6 +720,7 @@ static inline void spin_lock_prefetch(const void *x)
 	.sp0			= TOP_OF_INIT_STACK,			  \
 	.sysenter_cs		= __KERNEL_CS,				  \
 	.io_bitmap_ptr		= NULL,					  \
+	.addr_limit		= KERNEL_DS,				  \
 }
 
 extern unsigned long thread_saved_pc(struct task_struct *tsk);
@@ -768,8 +770,9 @@ extern unsigned long thread_saved_pc(struct task_struct *tsk);
 #define STACK_TOP		TASK_SIZE
 #define STACK_TOP_MAX		TASK_SIZE_MAX
 
-#define INIT_THREAD  { \
-	.sp0 = TOP_OF_INIT_STACK \
+#define INIT_THREAD  {						\
+	.sp0			= TOP_OF_INIT_STACK,		\
+	.addr_limit		= KERNEL_DS,			\
 }
 
 /*
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 7c47bb659ecd..89bff044a6f5 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -57,7 +57,6 @@ struct thread_info {
 	__u32			flags;		/* low level flags */
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
-	mm_segment_t		addr_limit;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
@@ -65,7 +64,6 @@ struct thread_info {
 	.task		= &tsk,			\
 	.flags		= 0,			\
 	.cpu		= 0,			\
-	.addr_limit	= KERNEL_DS,		\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
@@ -184,11 +182,6 @@ static inline unsigned long current_stack_pointer(void)
 # define cpu_current_top_of_stack (cpu_tss + TSS_sp0)
 #endif
 
-/* Load thread_info address into "reg" */
-#define GET_THREAD_INFO(reg) \
-	_ASM_MOV PER_CPU_VAR(cpu_current_top_of_stack),reg ; \
-	_ASM_SUB $(THREAD_SIZE),reg ;
-
 /*
  * ASM operand which evaluates to a 'thread_info' address of
  * the current task, if it is known that "reg" is exactly "off"
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 4d2a726e8e6d..0eb18b4ac492 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -29,12 +29,12 @@
 #define USER_DS 	MAKE_MM_SEG(TASK_SIZE_MAX)
 
 #define get_ds()	(KERNEL_DS)
-#define get_fs()	(current_thread_info()->addr_limit)
-#define set_fs(x)	(current_thread_info()->addr_limit = (x))
+#define get_fs()	(current->thread.addr_limit)
+#define set_fs(x)	(current->thread.addr_limit = (x))
 
 #define segment_eq(a, b)	((a).seg == (b).seg)
 
-#define user_addr_max() (current_thread_info()->addr_limit.seg)
+#define user_addr_max() (current->thread.addr_limit.seg)
 #define __addr_ok(addr) 	\
 	((unsigned long __force)(addr) < user_addr_max())
 
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 674134e9f5e5..2bd5c6ff7ee7 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -31,7 +31,9 @@ void common(void) {
 	BLANK();
 	OFFSET(TI_flags, thread_info, flags);
 	OFFSET(TI_status, thread_info, status);
-	OFFSET(TI_addr_limit, thread_info, addr_limit);
+
+	BLANK();
+	OFFSET(TASK_addr_limit, task_struct, thread.addr_limit);
 
 	BLANK();
 	OFFSET(crypto_tfm_ctx_offset, crypto_tfm, __crt_ctx);
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 2b0ef26da0bd..bf603ebbfd8e 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -17,11 +17,11 @@
 
 /* Standard copy_to_user with segment limit checking */
 ENTRY(_copy_to_user)
-	GET_THREAD_INFO(%rax)
+	mov PER_CPU_VAR(current_task), %rax
 	movq %rdi,%rcx
 	addq %rdx,%rcx
 	jc bad_to_user
-	cmpq TI_addr_limit(%rax),%rcx
+	cmpq TASK_addr_limit(%rax),%rcx
 	ja bad_to_user
 	ALTERNATIVE_2 "jmp copy_user_generic_unrolled",		\
 		      "jmp copy_user_generic_string",		\
@@ -32,11 +32,11 @@ ENDPROC(_copy_to_user)
 
 /* Standard copy_from_user with segment limit checking */
 ENTRY(_copy_from_user)
-	GET_THREAD_INFO(%rax)
+	mov PER_CPU_VAR(current_task), %rax
 	movq %rsi,%rcx
 	addq %rdx,%rcx
 	jc bad_from_user
-	cmpq TI_addr_limit(%rax),%rcx
+	cmpq TASK_addr_limit(%rax),%rcx
 	ja bad_from_user
 	ALTERNATIVE_2 "jmp copy_user_generic_unrolled",		\
 		      "jmp copy_user_generic_string",		\
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index 28a6654f0d08..b6fcb9a9ddbc 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -6,6 +6,7 @@
  */
 #include <asm/checksum.h>
 #include <linux/module.h>
+#include <linux/uaccess.h>
 #include <asm/smap.h>
 
 /**
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index 46668cda4ffd..0ef5128c2de8 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -35,8 +35,8 @@
 
 	.text
 ENTRY(__get_user_1)
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	mov PER_CPU_VAR(current_task), %_ASM_DX
+	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
 1:	movzbl (%_ASM_AX),%edx
@@ -48,8 +48,8 @@ ENDPROC(__get_user_1)
 ENTRY(__get_user_2)
 	add $1,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	mov PER_CPU_VAR(current_task), %_ASM_DX
+	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
 2:	movzwl -1(%_ASM_AX),%edx
@@ -61,8 +61,8 @@ ENDPROC(__get_user_2)
 ENTRY(__get_user_4)
 	add $3,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	mov PER_CPU_VAR(current_task), %_ASM_DX
+	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
 3:	movl -3(%_ASM_AX),%edx
@@ -75,8 +75,8 @@ ENTRY(__get_user_8)
 #ifdef CONFIG_X86_64
 	add $7,%_ASM_AX
 	jc bad_get_user
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	mov PER_CPU_VAR(current_task), %_ASM_DX
+	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user
 	ASM_STAC
 4:	movq -7(%_ASM_AX),%rdx
@@ -86,8 +86,8 @@ ENTRY(__get_user_8)
 #else
 	add $7,%_ASM_AX
 	jc bad_get_user_8
-	GET_THREAD_INFO(%_ASM_DX)
-	cmp TI_addr_limit(%_ASM_DX),%_ASM_AX
+	mov PER_CPU_VAR(current_task), %_ASM_DX
+	cmp TASK_addr_limit(%_ASM_DX),%_ASM_AX
 	jae bad_get_user_8
 	ASM_STAC
 4:	movl -7(%_ASM_AX),%edx
diff --git a/arch/x86/lib/putuser.S b/arch/x86/lib/putuser.S
index e0817a12d323..c891ece81e5b 100644
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -29,14 +29,14 @@
  * as they get called from within inline assembly.
  */
 
-#define ENTER	GET_THREAD_INFO(%_ASM_BX)
+#define ENTER	mov PER_CPU_VAR(current_task), %_ASM_BX
 #define EXIT	ASM_CLAC ;	\
 		ret
 
 .text
 ENTRY(__put_user_1)
 	ENTER
-	cmp TI_addr_limit(%_ASM_BX),%_ASM_CX
+	cmp TASK_addr_limit(%_ASM_BX),%_ASM_CX
 	jae bad_put_user
 	ASM_STAC
 1:	movb %al,(%_ASM_CX)
@@ -46,7 +46,7 @@ ENDPROC(__put_user_1)
 
 ENTRY(__put_user_2)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $1,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
@@ -58,7 +58,7 @@ ENDPROC(__put_user_2)
 
 ENTRY(__put_user_4)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $3,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
@@ -70,7 +70,7 @@ ENDPROC(__put_user_4)
 
 ENTRY(__put_user_8)
 	ENTER
-	mov TI_addr_limit(%_ASM_BX),%_ASM_BX
+	mov TASK_addr_limit(%_ASM_BX),%_ASM_BX
 	sub $7,%_ASM_BX
 	cmp %_ASM_BX,%_ASM_CX
 	jae bad_put_user
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 0a42327a59d7..9f760cdcaf40 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -6,7 +6,7 @@
  * Copyright 2002 Andi Kleen <ak@suse.de>
  */
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 /*
  * Zero Userspace
diff --git a/drivers/pnp/isapnp/proc.c b/drivers/pnp/isapnp/proc.c
index 5edee645d890..262285e48a09 100644
--- a/drivers/pnp/isapnp/proc.c
+++ b/drivers/pnp/isapnp/proc.c
@@ -21,7 +21,7 @@
 #include <linux/isapnp.h>
 #include <linux/proc_fs.h>
 #include <linux/init.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 extern struct pnp_protocol isapnp_protocol;
 
diff --git a/lib/bitmap.c b/lib/bitmap.c
index c66da508cbf7..eca88087fa8a 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -14,9 +14,9 @@
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
+#include <linux/uaccess.h>
 
 #include <asm/page.h>
-#include <asm/uaccess.h>
 
 /*
  * bitmaps provide an array of bits, implemented using an an
-- 
2.7.4
