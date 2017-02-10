From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 10 Feb 2017 17:16:42 +0000
Message-Id: <1486747005-15973-2-git-send-email-ard.biesheuvel@linaro.org>
In-Reply-To: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1486747005-15973-1-git-send-email-ard.biesheuvel@linaro.org>
Subject: [kernel-hardening] [PATCH 1/4] arm: kvm: move kvm_vgic_global_state out of .text section
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, keescook@chromium.org, labbott@fedoraproject.org, james.morse@arm.com
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org, kernel-hardening@lists.openwall.com, andre.przywara@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kvm_vgic_global_state struct contains a static key which is
written to by jump_label_init() at boot time. So in preparation of
making .text regions truly (well, almost truly) read-only, mark
kvm_vgic_global_state __ro_after_init so it moves to the .rodata
section instead.

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
