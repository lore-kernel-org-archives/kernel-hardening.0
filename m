From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu,  9 Mar 2017 09:25:03 +0100
Message-Id: <1489047912-642-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v5 01/10] arm: kvm: move kvm_vgic_global_state out of .text section
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, will.deacon@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kvm_vgic_global_state struct contains a static key which is
written to by jump_label_init() at boot time. So in preparation of
making .text regions truly (well, almost truly) read-only, mark
kvm_vgic_global_state __ro_after_init so it moves to the .rodata
section instead.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Laura Abbott <labbott@redhat.com>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 654dfd40e449..7713d96e85b7 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -29,7 +29,9 @@
 #define DEBUG_SPINLOCK_BUG_ON(p)
 #endif
 
-struct vgic_global __section(.hyp.text) kvm_vgic_global_state = {.gicv3_cpuif = STATIC_KEY_FALSE_INIT,};
+struct vgic_global kvm_vgic_global_state __ro_after_init = {
+	.gicv3_cpuif = STATIC_KEY_FALSE_INIT,
+};
 
 /*
  * Locking order is always:
-- 
2.7.4
