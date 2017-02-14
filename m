From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 14 Feb 2017 20:52:34 +0000
Message-Id: <1487105558-21897-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1487105558-21897-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH v3 1/5] arm: kvm: move kvm_vgic_global_state out of .text section
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, labbott@fedoraproject.org
Cc: kernel-hardening@lists.openwall.com, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, andre.przywara@arm.com, suzuki.poulose@arm.com, james.morse@arm.com, keescook@chromium.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
index 6440b56ec90e..2f373455ed4e 100644
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
