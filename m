From: Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH 2/2] x86/modules: Make x86 allocs to flush when free
Date: Tue, 27 Nov 2018 16:07:54 -0800
Message-Id: <20181128000754.18056-3-rick.p.edgecombe@intel.com>
In-Reply-To: <20181128000754.18056-1-rick.p.edgecombe@intel.com>
References: <20181128000754.18056-1-rick.p.edgecombe@intel.com>
To: akpm@linux-foundation.org, luto@kernel.org, will.deacon@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, naveen.n.rao@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net, mhiramat@kernel.org, rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org, daniel@iogearbox.net, jeyu@kernel.org, netdev@vger.kernel.org, ard.biesheuvel@linaro.org, jannh@google.com
Cc: kristen@linux.intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Change the module allocations to flush before freeing the pages.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/module.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b052e883dd8c..1694daf256b3 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -87,8 +87,8 @@ void *module_alloc(unsigned long size)
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
-				    __builtin_return_address(0));
+				    PAGE_KERNEL_EXEC, VM_IMMEDIATE_UNMAP,
+				    NUMA_NO_NODE, __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
 		vfree(p);
 		return NULL;
-- 
2.17.1
