From: valdis.kletnieks@vt.edu
Subject: [PATCH 1/2] GCC release 8 support for gcc-plugins
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 04 Feb 2018 12:01:43 -0500
Message-ID: <119189.1517763703@turing-police.cc.vt.edu>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

GCC requires another #include to get the gcc-plugins to build cleanly.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index ffd1dfaa1cc1..f46750053377 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -97,6 +97,10 @@
 #include "predict.h"
 #include "ipa-utils.h"
 
+#if BUILDING_GCC_VERSION >= 8000
+#include "stringpool.h"
+#endif
+
 #if BUILDING_GCC_VERSION >= 4009
 #include "attribs.h"
 #include "varasm.h"
