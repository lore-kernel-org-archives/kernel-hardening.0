Reply-To: kernel-hardening@lists.openwall.com
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 16 Dec 2016 10:00:22 +0100
Message-Id: <20161216090033.2007806-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] [PATCH] gcc-plugin: include memmodel.h and tree_vrp.h for gcc-7
To: Kees Cook <keescook@chromium.org>
Cc: Kugan <kugan.vivekanandarajah@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org, Emese Revfy <re.emese@gmail.com>, Michal Marek <mmarek@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Building our gcc plugins currently fails with the gcc-7 snapshots,
due to some slightly modified header interfaces:

In file included from /git/arm-soc/scripts/gcc-plugins/gcc-common.h:42:0,
                 from <stdin>:1:
/home/arnd/cross-gcc/lib/gcc/x86_64-linux/7.0.0/plugin/include/emit-rtl.h:371:41: error: use of enum ‘memmodel’ without previous declaration
 extern bool need_atomic_barrier_p (enum memmodel, bool);
                                         ^
In file included from /git/arm-soc/scripts/gcc-plugins/gcc-common.h:94:0,
                 from <stdin>:1:
/home/arnd/cross-gcc/lib/gcc/x86_64-linux/7.0.0/plugin/include/tree-ssanames.h:70:40: error: use of enum ‘value_range_type’ without previous declaration
 extern void set_range_info (tree, enum value_range_type, const wide_int_ref &,

This makes it work again, which will be important once we turn
the plugins on in allmodconfig by default. It probably also
makes sense to backport these to v4.9 and v4.8, which
added the header file originally.

Cc: stable@vger.kernel.org
Suggested-by: Kugan <kugan.vivekanandarajah@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 scripts/gcc-plugins/gcc-common.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index 950fd2e64bb7..cb4a9518b58a 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -18,6 +18,9 @@
 
 #include "tree-inline.h"
 #include "version.h"
+#if BUILDING_GCC_VERSION >= 7000
+#include "memmodel.h"
+#endif
 #include "rtl.h"
 #include "tm_p.h"
 #include "flags.h"
@@ -66,6 +69,9 @@
 #include "tree-flow.h"
 #else
 #include "tree-cfgcleanup.h"
+#if BUILDING_GCC_VERSION >= 7000
+#include "tree-vrp.h"
+#endif
 #include "tree-ssa-operands.h"
 #include "tree-into-ssa.h"
 #endif
-- 
2.9.0
