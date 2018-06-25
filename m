MIME-Version: 1.0
Date: Mon, 25 Jun 2018 15:39:07 -0700
In-Reply-To: <20180625224014.134829-1-thgarnie@google.com>
Message-Id: <20180625224014.134829-20-thgarnie@google.com>
References: <20180625224014.134829-1-thgarnie@google.com>
Subject: [PATCH v5 19/27] kvm: Adapt assembly for PIE support
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset="UTF-8"
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible. The new __ASM_MOVABS macro is used to
get the address of a symbol on both 32 and 64-bit with PIE support.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++--
 arch/x86/kernel/kvm.c           | 6 ++++--
 arch/x86/kvm/svm.c              | 4 ++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c13cd28d9d1b..27370f4917a4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1390,9 +1390,13 @@ asmlinkage void kvm_spurious_fault(void);
 	".pushsection .fixup, \"ax\" \n" \
 	"667: \n\t" \
 	cleanup_insn "\n\t"		      \
-	"cmpb $0, kvm_rebooting \n\t"	      \
+	"cmpb $0, kvm_rebooting" __ASM_SEL(,(%%rip)) " \n\t" \
 	"jne 668b \n\t"      		      \
-	__ASM_SIZE(push) " $666b \n\t"	      \
+	__ASM_SIZE(push) "$0 \n\t"		\
+	__ASM_SIZE(push) "%%" _ASM_AX " \n\t"		\
+	_ASM_MOVABS " $666b, %%" _ASM_AX "\n\t"	\
+	_ASM_MOV " %%" _ASM_AX ", " __ASM_SEL(4,8) "(%%" _ASM_SP ") \n\t" \
+	__ASM_SIZE(pop) "%%" _ASM_AX " \n\t"		\
 	"call kvm_spurious_fault \n\t"	      \
 	".popsection \n\t" \
 	_ASM_EXTABLE(666b, 667b)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a37bda38d205..761157c138c9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -726,8 +726,10 @@ asm(
 ".global __raw_callee_save___kvm_vcpu_is_preempted;"
 ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
 "__raw_callee_save___kvm_vcpu_is_preempted:"
-"movq	__per_cpu_offset(,%rdi,8), %rax;"
-"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
+"leaq	__per_cpu_offset(%rip), %rax;"
+"movq	(%rax,%rdi,8), %rax;"
+"addq	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rip), %rax;"
+"cmpb	$0, (%rax);"
 "setne	%al;"
 "ret;"
 ".popsection");
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f059a73f0fd0..cb78647d6383 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -707,12 +707,12 @@ static u32 svm_msrpm_offset(u32 msr)
 
 static inline void clgi(void)
 {
-	asm volatile (__ex(SVM_CLGI));
+	asm volatile (__ex(SVM_CLGI) : :);
 }
 
 static inline void stgi(void)
 {
-	asm volatile (__ex(SVM_STGI));
+	asm volatile (__ex(SVM_STGI) : :);
 }
 
 static inline void invlpga(unsigned long addr, u32 asid)
-- 
2.18.0.rc2.346.g013aa6912e-goog
