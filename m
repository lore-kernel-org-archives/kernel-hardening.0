Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 21 Oct 2017 01:25:24 +0200
Message-Id: <20171020232525.7387-2-pbonzini@redhat.com>
In-Reply-To: <20171020232525.7387-1-pbonzini@redhat.com>
References: <20171020232525.7387-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH 1/2] KVM: allow setting a usercopy region in struct kvm_vcpu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Cornelia Huck <cohuck@redhat.com>, James Hogan <james.hogan@imgtec.com>, Paul Mackerras <paulus@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

On x86, struct kvm_vcpu has a usercopy region corresponding to the CPUID
entries.  The area is read and written by the KVM_GET/SET_CPUID2 ioctls.
Without this patch, KVM is completely broken on x86 with usercopy
hardening enabled.

Define kvm_init in terms of a more generic function that allows setting
a usercopy region.  Because x86 has separate kvm_init callers for Intel and
AMD, another variant called kvm_init_x86 passes the region corresponding
to the cpuid_entries array.

Reported-by: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Cornelia Huck <cohuck@redhat.com>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	The patch is on top of linux-next.

 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/svm.c              |  4 ++--
 arch/x86/kvm/vmx.c              |  4 ++--
 arch/x86/kvm/x86.c              | 10 ++++++++++
 include/linux/kvm_host.h        | 13 +++++++++++--
 virt/kvm/kvm_main.c             | 13 ++++++++-----
 6 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6b8f937ca398..bb8243d413d0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1420,6 +1420,9 @@ static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
 
+int kvm_init_x86(struct kvm_x86_ops *kvm_x86_ops, unsigned vcpu_size,
+	         unsigned vcpu_align, struct module *module);
+
 static inline int kvm_cpu_get_apicid(int mps_cpu)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ff94552f85d0..457433c3a703 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5594,8 +5594,8 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 
 static int __init svm_init(void)
 {
-	return kvm_init(&svm_x86_ops, sizeof(struct vcpu_svm),
-			__alignof__(struct vcpu_svm), THIS_MODULE);
+	return kvm_init_x86(&svm_x86_ops, sizeof(struct vcpu_svm),
+			    __alignof__(struct vcpu_svm), THIS_MODULE);
 }
 
 static void __exit svm_exit(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index c460b0b439d3..6e78530df6a8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -12106,8 +12106,8 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 
 static int __init vmx_init(void)
 {
-	int r = kvm_init(&vmx_x86_ops, sizeof(struct vcpu_vmx),
-                     __alignof__(struct vcpu_vmx), THIS_MODULE);
+	int r = kvm_init_x86(&vmx_x86_ops, sizeof(struct vcpu_vmx),
+			     __alignof__(struct vcpu_vmx), THIS_MODULE);
 	if (r)
 		return r;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5669af09b732..415529a78c37 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8181,6 +8181,16 @@ void kvm_arch_sync_events(struct kvm *kvm)
 	kvm_free_pit(kvm);
 }
 
+int kvm_init_x86(struct kvm_x86_ops *kvm_x86_ops, unsigned vcpu_size,
+		 unsigned vcpu_align, struct module *module)
+{
+	return kvm_init_usercopy(kvm_x86_ops, vcpu_size, vcpu_align,
+				 offsetof(struct kvm_vcpu_arch, cpuid_entries),
+				 sizeof_field(struct kvm_vcpu_arch, cpuid_entries),
+				 module);
+}
+EXPORT_SYMBOL_GPL(kvm_init_x86);
+
 int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 {
 	int i, r;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6882538eda32..21e19658b086 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -561,8 +561,17 @@ static inline void kvm_irqfd_exit(void)
 {
 }
 #endif
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-		  struct module *module);
+
+int kvm_init_usercopy(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+		      unsigned vcpu_usercopy_start, unsigned vcpu_usercopy_size,
+		      struct module *module);
+
+static inline int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+			   struct module *module)
+{
+	return kvm_init_usercopy(opaque, vcpu_size, vcpu_align, 0, 0, module);
+}
+
 void kvm_exit(void);
 
 void kvm_get_kvm(struct kvm *kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 261c782a688f..ac889b28bb54 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3959,8 +3959,9 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 	kvm_arch_vcpu_put(vcpu);
 }
 
-int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
-		  struct module *module)
+int kvm_init_usercopy(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
+		      unsigned vcpu_arch_usercopy_start, unsigned vcpu_arch_usercopy_size,
+		      struct module *module)
 {
 	int r;
 	int cpu;
@@ -4006,8 +4007,10 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	/* A kmem cache lets us meet the alignment requirements of fx_save. */
 	if (!vcpu_align)
 		vcpu_align = __alignof__(struct kvm_vcpu);
-	kvm_vcpu_cache = kmem_cache_create("kvm_vcpu", vcpu_size, vcpu_align,
-					   SLAB_ACCOUNT, NULL);
+	kvm_vcpu_cache = kmem_cache_create_usercopy("kvm_vcpu", vcpu_size, vcpu_align,
+						    SLAB_ACCOUNT,
+						    offsetof(struct kvm_vcpu, arch) + vcpu_arch_usercopy_start,
+						    vcpu_arch_usercopy_size, NULL);
 	if (!kvm_vcpu_cache) {
 		r = -ENOMEM;
 		goto out_free_3;
@@ -4065,7 +4068,7 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 out_fail:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_init);
+EXPORT_SYMBOL_GPL(kvm_init_usercopy);
 
 void kvm_exit(void)
 {
-- 
2.14.2
