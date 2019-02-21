From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 4/7] powerpc/64: Setup KUP on secondary CPUs
Date: Thu, 21 Feb 2019 20:35:58 +1100
Message-Id: <20190221093601.27920-5-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
References: <20190221093601.27920-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

Some platforms (i.e. Radix MMU) need per-CPU initialisation for KUP.

Any platforms that only want to do KUP initialisation once
globally can just check to see if they're running on the boot CPU, or
check if whatever setup they need has already been performed.

Note that this is only for 64-bit.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/kernel/setup_64.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 771f280a6bf6..17921ee7f3a0 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -390,6 +390,9 @@ void early_setup_secondary(void)
 	/* Initialize the hash table or TLB handling */
 	early_init_mmu_secondary();
 
+	/* Perform any KUP setup that is per-cpu */
+	setup_kup();
+
 	/*
 	 * At this point, we can let interrupts switch to virtual mode
 	 * (the MMU has been setup), so adjust the MSR in the PACA to
-- 
2.20.1
