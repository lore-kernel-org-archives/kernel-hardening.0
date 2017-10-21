From: Christoffer Dall <christoffer.dall@linaro.org>
Date: Sat, 21 Oct 2017 20:45:45 +0200
Message-Id: <20171021184545.2497-1-christoffer.dall@linaro.org>
MIME-Version: 1.0
In-Reply-To: <20171020232525.7387-1-pbonzini@redhat.com>
References: <20171020232525.7387-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] KVM: arm/arm64: Allow usercopy to vcpu->arch.ctxt and arm64 debug
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

We do direct useraccess copying to the kvm_cpu_context structure
embedded in the kvm_vcpu_arch structure, and to the vcpu debug register
state.  Everything else (timer, PMU, vgic) goes through a temporary
indirection.

Fixing all accesses to kvm_cpu_context is massively invasive, and we'd
like to avoid that, so we tell kvm_init_usercopy to whitelist accesses
to out context structure.

The debug system register accesses on arm64 are modified to work through
an indirection instead.

Cc: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
This fixes KVM/ARM on today's linux next with CONFIG_HARDENED_USERCOPY.

The patch is based on linux-next plus Paolo's x86 patch which introduces
kvm_init_usercopy.  Not sure how this needs to get merged, but it would
potentially make sense for Paolo to put together a set of the patches
needed for this.

Thanks,
-Christoffer

 arch/arm64/kvm/sys_regs.c | 36 ++++++++++++++++++++----------------
 virt/kvm/arm/arm.c        |  5 ++++-
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 2e070d3baf9f..cdf47a9108fe 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -293,19 +293,20 @@ static bool trap_bvr(struct kvm_vcpu *vcpu,
 static int set_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg] = r;
 	return 0;
 }
 
 static int get_bvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_bvr[rd->reg];
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 	return 0;
 }
@@ -335,10 +336,11 @@ static bool trap_bcr(struct kvm_vcpu *vcpu,
 static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg] = r;
 
 	return 0;
 }
@@ -346,9 +348,9 @@ static int set_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 static int get_bcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_bcr[rd->reg];
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 	return 0;
 }
@@ -379,19 +381,20 @@ static bool trap_wvr(struct kvm_vcpu *vcpu,
 static int set_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg] = r;
 	return 0;
 }
 
 static int get_wvr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_wvr[rd->reg];
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 	return 0;
 }
@@ -421,19 +424,20 @@ static bool trap_wcr(struct kvm_vcpu *vcpu,
 static int set_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 		const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 r;
 
-	if (copy_from_user(r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_from_user(&r, uaddr, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
+	vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg] = r;
 	return 0;
 }
 
 static int get_wcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
 	const struct kvm_one_reg *reg, void __user *uaddr)
 {
-	__u64 *r = &vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
+	__u64 r = vcpu->arch.vcpu_debug_state.dbg_wcr[rd->reg];
 
-	if (copy_to_user(uaddr, r, KVM_REG_SIZE(reg->id)) != 0)
+	if (copy_to_user(uaddr, &r, KVM_REG_SIZE(reg->id)) != 0)
 		return -EFAULT;
 	return 0;
 }
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index b9f68e4add71..639e388678ff 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1502,7 +1502,10 @@ void kvm_arch_exit(void)
 
 static int arm_init(void)
 {
-	int rc = kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+	int rc = kvm_init_usercopy(NULL, sizeof(struct kvm_vcpu), 0,
+				   offsetof(struct kvm_vcpu_arch, ctxt),
+				   sizeof_field(struct kvm_vcpu_arch, ctxt),
+				   THIS_MODULE);
 	return rc;
 }
 
-- 
2.14.2
