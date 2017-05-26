From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:06 -0700
Message-Id: <1495829844-69341-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 02/20] gcc-plugins: Detail c-common.h location for GCC 4.6
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The c-common.h file moved in stock gcc 4.7, not gcc 4.6. However, most
people building plugins with gcc 4.6 are using the Debian or Ubuntu
version, which includes a patch to move the headers to the 4.7 location.
In case anyone trips over this with a stock gcc 4.6, add a pointer to the
patch used by Debian/Ubuntu.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/gcc-common.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
index b232ab15624c..918953ca4527 100644
--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -63,6 +63,13 @@
 #endif
 
 #if BUILDING_GCC_VERSION >= 4006
+/*
+ * The c-family headers were moved into a subdirectory in GCC version
+ * 4.7, but most plugin-building users of GCC 4.6 are using the Debian
+ * or Ubuntu package, which has an out-of-tree patch to move this to the
+ * same location as found in 4.7 and later:
+ * https://sources.debian.net/src/gcc-4.6/4.6.3-14/debian/patches/pr45078.diff/
+ */
 #include "c-family/c-common.h"
 #else
 #include "c-common.h"
-- 
2.7.4
