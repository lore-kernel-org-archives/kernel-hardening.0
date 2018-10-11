From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2 7/7] s390/modules: Add rlimit checking for s390 modules
Date: Thu, 11 Oct 2018 16:31:17 -0700
Message-Id: <20181011233117.7883-8-rick.p.edgecombe@intel.com>
In-Reply-To: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
References: <20181011233117.7883-1-rick.p.edgecombe@intel.com>
To: kernel-hardening@lists.openwall.com, daniel@iogearbox.net, keescook@chromium.org, catalin.marinas@arm.com, will.deacon@arm.com, davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org, arnd@arndb.de, jeyu@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This adds in the rlimit checking for the s390 module allocator.

This has not been tested.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/s390/kernel/module.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index d298d3cb46d0..6c2356a72b63 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -32,12 +32,22 @@
 
 void *module_alloc(unsigned long size)
 {
+	void *p;
+
 	if (PAGE_ALIGN(size) > MODULES_LEN)
 		return NULL;
-	return __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
+
+	if (check_inc_mod_rlimit(size))
+		return NULL;
+
+	p = __vmalloc_node_range(size, 1, MODULES_VADDR, MODULES_END,
 				    GFP_KERNEL, PAGE_KERNEL_EXEC,
 				    0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
+
+	update_mod_rlimit(p, size);
+
+	return p;
 }
 
 void module_arch_freeing_init(struct module *mod)
-- 
2.17.1
