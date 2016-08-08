Reply-To: kernel-hardening@lists.openwall.com
From: Thomas Garnier <thgarnie@google.com>
Date: Mon,  8 Aug 2016 11:40:07 -0700
Message-Id: <1470681607-36883-2-git-send-email-thgarnie@google.com>
In-Reply-To: <1470681607-36883-1-git-send-email-thgarnie@google.com>
References: <1470681607-36883-1-git-send-email-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v1 2/2] x86/KASLR: Increase BRK pages for KASLR memory randomization
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Thomas Garnier <thgarnie@google.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Default implementation expects 6 pages maximum are needed for low page
allocations. If KASLR memory randomization is enabled, the worse case
of e820 layout would require 12 pages (no large pages). It is due to the
PUD level randomization and the variable e820 memory layout.

This bug was found while doing extensive testing of KASLR memory
randomization on different type of hardware.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20160805
---
 arch/x86/mm/init.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6209289..3a27e6a 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -130,6 +130,14 @@ void  __init early_alloc_pgt_buf(void)
 	unsigned long tables = INIT_PGT_BUF_SIZE;
 	phys_addr_t base;
 
+	/*
+	 * Depending on the machine e860 memory layout and the PUD alignement.
+	 * We may need twice more pages when KASLR memoy randomization is
+	 * enabled.
+	 */
+	if (IS_ENABLED(CONFIG_RANDOMIZE_MEMORY))
+		tables *= 2;
+
 	base = __pa(extend_brk(tables, PAGE_SIZE));
 
 	pgt_buf_start = base >> PAGE_SHIFT;
-- 
2.8.0.rc3.226.g39d4020
