Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Tue,  9 Aug 2016 10:11:05 -0700
Message-Id: <1470762665-88032-2-git-send-email-thgarnie@google.com>
In-Reply-To: <1470762665-88032-1-git-send-email-thgarnie@google.com>
References: <1470762665-88032-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 2/2] x86/KASLR: Increase BRK pages for KASLR memory randomization
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Default implementation expects 6 pages maximum are needed for low page
allocations. If KASLR memory randomization is enabled, the worse case
of e820 layout would require 12 pages (no large pages). It is due to the
PUD level randomization and the variable e820 memory layout.

This bug was found while doing extensive testing of KASLR memory
randomization on different type of hardware.

Fixes: 021182e52fe0 ("Enable KASLR for physical mapping memory regions")
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160805
---
 arch/x86/mm/init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6209289..796e7af 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -122,8 +122,18 @@ __ref void *alloc_low_pages(unsigned int num)
 	return __va(pfn << PAGE_SHIFT);
 }
 
-/* need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS */
-#define INIT_PGT_BUF_SIZE	(6 * PAGE_SIZE)
+/*
+ * By default need 3 4k for initial PMD_SIZE,  3 4k for 0-ISA_END_ADDRESS.
+ * With KASLR memory randomization, depending on the machine e820 memory
+ * and the PUD alignment. We may need twice more pages when KASLR memory
+ * randomization is enabled.
+ */
+#ifndef CONFIG_RANDOMIZE_MEMORY
+#define INIT_PGD_PAGE_COUNT      6
+#else
+#define INIT_PGD_PAGE_COUNT      12
+#endif
+#define INIT_PGT_BUF_SIZE	(INIT_PGD_PAGE_COUNT * PAGE_SIZE)
 RESERVE_BRK(early_pgt_alloc, INIT_PGT_BUF_SIZE);
 void  __init early_alloc_pgt_buf(void)
 {
-- 
2.8.0.rc3.226.g39d4020
