From: Ruslan Nikolaev <nruslan_devel@yahoo.com>
Subject: [PATCH v1 03/06]: Export individual Xen hypercalls
Message-ID: <2d406c4a-8a37-fe1a-acd5-0e2758e234b2@yahoo.com>
Date: Tue, 15 Jan 2019 13:59:52 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: kernel-hardening@lists.openwall.com
Cc: thgarnie@google.com, x86@kernel.org, kstewart@linuxfoundation.org, gregkh@linuxfoundation.org, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Export individual Xen hypercalls

The patch is by Hassan Nadeem and Ruslan Nikolaev. This extends
the prior PIE kernel patch (by Thomas Garnier) to also support
position-independent modules that can be placed anywhere in the
48/64-bit address space (for better KASLR).

Signed-off-by: Ruslan Nikolaev <nruslan_devel@yahoo.com>
---
  xen-head.S |    2 ++
  1 file changed, 2 insertions(+)

diff -uprN a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S	2019-01-15 11:20:45.279168462 -0500
+++ b/arch/x86/xen/xen-head.S	2019-01-15 11:28:54.676189964 -0500
@@ -13,6 +13,7 @@
  #include <asm/page_types.h>
  #include <asm/percpu.h>
  #include <asm/unwind_hints.h>
+#include <asm/export.h>

  #include <xen/interface/elfnote.h>
  #include <xen/interface/features.h>
@@ -66,6 +67,7 @@ ENTRY(hypercall_page)
  	.endr

  #define HYPERCALL(n) \
+	EXPORT_SYMBOL_GPL(xen_hypercall_##n); \
  	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
  	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
  #include <asm/xen-hypercalls.h>
