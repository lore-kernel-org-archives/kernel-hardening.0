From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 1/2] vla: define new safe vla macros
Date: Wed,  7 Mar 2018 16:27:30 +1100
Message-Id: <1520400451-11475-2-git-send-email-me@tobin.cc>
In-Reply-To: <1520400451-11475-1-git-send-email-me@tobin.cc>
References: <1520400451-11475-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

We would like to get rid of VLAs all together but in the mean time we
can make their usage safer.

Define a macro to use for declaring a VLA.  Macro includes requested
'size' and 'max' allowed.  Macro allocates storage for an array
equivalent to

	int array[min(size, max)];

We also define a macro to check whether maximum size was reached.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 include/linux/vla.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 include/linux/vla.h

diff --git a/include/linux/vla.h b/include/linux/vla.h
new file mode 100644
index 000000000000..ca0510d5e416
--- /dev/null
+++ b/include/linux/vla.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VLA_H
+#define _LINUX_VLA_H
+
+#define VLA_DEFAULT_MAX 256
+
+/* evaluates 'size' and 'max' twice */
+#define VLA_SAFE(type, vla, size, max) type vla[(size) < (max) ? (size) : (max)]
+
+#define VLA_WARN_OVERSIZE(vla, size)				\
+do {								\
+	WARN(sizeof(vla) < size, "vla maximum exceeded\n");	\
+} while (0)
+
+#endif	/* _LINUX_VLA_H */
-- 
2.7.4
