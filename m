From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v7 05/12] x86/entry/64: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:30 -0700
Message-Id: <20190520231948.49693-6-thgarnie@chromium.org>
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Thomas Garnier <thgarnie@google.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/entry/entry_64.S | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 20e45d9b4e15..e99b3438aa9b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1268,7 +1268,8 @@ ENTRY(error_entry)
 	movl	%ecx, %eax			/* zero extend */
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
-	cmpq	$.Lgs_change, RIP+8(%rsp)
+	leaq	.Lgs_change(%rip), %rcx
+	cmpq	%rcx, RIP+8(%rsp)
 	jne	.Lerror_entry_done
 
 	/*
@@ -1465,10 +1466,10 @@ ENTRY(nmi)
 	 * resume the outer NMI.
 	 */
 
-	movq	$repeat_nmi, %rdx
+	leaq	repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	1f
-	movq	$end_repeat_nmi, %rdx
+	leaq	end_repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	nested_nmi_out
 1:
@@ -1522,7 +1523,8 @@ nested_nmi:
 	pushq	%rdx
 	pushfq
 	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
+	leaq	repeat_nmi(%rip), %rdx
+	pushq	%rdx
 
 	/* Put stack back */
 	addq	$(6*8), %rsp
@@ -1561,7 +1563,11 @@ first_nmi:
 	addq	$8, (%rsp)	/* Fix up RSP */
 	pushfq			/* RFLAGS */
 	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
+	pushq	$0		/* Futur return address */
+	pushq	%rax		/* Save RAX */
+	leaq	1f(%rip), %rax	/* RIP */
+	movq    %rax, 8(%rsp)   /* Put 1f on return address */
+	popq	%rax		/* Restore RAX */
 	iretq			/* continues at repeat_nmi below */
 	UNWIND_HINT_IRET_REGS
 1:
-- 
2.21.0.1020.gf2820cf01a-goog
