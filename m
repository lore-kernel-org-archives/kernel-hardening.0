From: Russell Currey <ruscur@russell.cc>
Subject: [PATCH 2/4] powerpc/64: Setup KUP before feature fixups
Date: Fri, 23 Nov 2018 01:04:14 +1100
Message-Id: <20181122140416.3447-3-ruscur@russell.cc>
In-Reply-To: <20181122140416.3447-1-ruscur@russell.cc>
References: <20181122140416.3447-1-ruscur@russell.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, kernel-hardening@lists.openwall.com, christophe.leroy@c-s.fr, Russell Currey <ruscur@russell.cc>
List-ID: <kernel-hardening.lists.openwall.com>

The subsequent implementation of KUAP for radix makes use of a MMU
feature in order to patch out assembly when KUAP is disabled or
unsupported.  This won't work unless there's an entry point for
KUP support before the feature magic happens, so relocate
setup_kup() earlier in setup.

Signed-off-by: Russell Currey <ruscur@russell.cc>
---
 arch/powerpc/kernel/setup_64.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 0f4e06ab70a5..cc20dc3e7b69 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -331,6 +331,12 @@ void __init early_setup(unsigned long dt_ptr)
 	 */
 	configure_exceptions();
 
+	/*
+	 * Configure Kernel Userspace Protection. This needs to happen before
+	 * feature fixups for platforms that implement this using features.
+	 */
+	setup_kup();
+
 	/* Apply all the dynamic patching */
 	apply_feature_fixups();
 	setup_feature_keys();
@@ -372,7 +378,6 @@ void __init early_setup(unsigned long dt_ptr)
 	 */
 	btext_map();
 #endif /* CONFIG_PPC_EARLY_DEBUG_BOOTX */
-	setup_kup();
 }
 
 #ifdef CONFIG_SMP
-- 
2.19.1
