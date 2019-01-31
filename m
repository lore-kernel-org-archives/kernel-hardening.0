From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 19/27] kvm: Adapt assembly for PIE support
Date: Thu, 31 Jan 2019 11:24:26 -0800
Message-Id: <20190131192533.34130-20-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible. The new __ASM_MOVABS macro is used to
get the address of a symbol on both 32 and 64-bit with PIE support.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++--
 arch/x86/kernel/kvm.c           | 6 ++++--
 arch/x86/kvm/svm.c              | 4 ++--
 arch/x86/kvm/vmx/vmx.c          | 2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4660ce90de7f..fdb3307d5fe1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1498,9 +1498,13 @@ asmlinkage void kvm_spurious_fault(void);
 	".pushsection .fixup, \"ax\" \n" \
 	"667: \n\t" \
 	cleanup_insn "\n\t"		      \
-	"cmpb $0, kvm_rebooting \n\t"	      \
+	"cmpb $0, kvm_rebooting" __ASM_SEL(, (%%rip)) " \n\t" \
 	"jne 668b \n\t"      		      \
-	__ASM_SIZE(push) " $666b \n\t"	      \
+	__ASM_SIZE(push) "$0 \n\t"		\
+	__ASM_SIZE(push) "%%" _ASM_AX " \n\t"		\
+	_ASM_MOVABS " $666b, %%" _ASM_AX "\n\t"	\
+	_ASM_MOV " %%" _ASM_AX ", " __ASM_SEL(4, 8) "(%%" _ASM_SP ") \n\t" \
+	__ASM_SIZE(pop) "%%" _ASM_AX " \n\t"		\
 	"jmp kvm_spurious_fault \n\t"	      \
 	".popsection \n\t" \
 	_ASM_EXTABLE(666b, 667b)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5c93a65ee1e5..f6eb02004e43 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -826,8 +826,10 @@ asm(
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
index f13a3a24d360..26abb82b1b67 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -706,12 +706,12 @@ static u32 svm_msrpm_offset(u32 msr)
 
 static inline void clgi(void)
 {
-	asm volatile (__ex("clgi"));
+	asm volatile (__ex("clgi") : :);
 }
 
 static inline void stgi(void)
 {
-	asm volatile (__ex("stgi"));
+	asm volatile (__ex("stgi") : :);
 }
 
 static inline void invlpga(unsigned long addr, u32 asid)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4341175339f3..3275761a7375 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2161,7 +2161,7 @@ static void vmclear_local_loaded_vmcss(void)
  */
 static void kvm_cpu_vmxoff(void)
 {
-	asm volatile (__ex("vmxoff"));
+	asm volatile (__ex("vmxoff") :::);
 
 	intel_pt_handle_vmx(0);
 	cr4_clear_bits(X86_CR4_VMXE);
-- 
2.20.1.495.gaa96b0ce6b-goog
