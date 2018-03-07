From: "Tobin C. Harding" <me@tobin.cc>
Subject: [RFC 2/2] lustre: use VLA_SAFE
Date: Wed,  7 Mar 2018 16:27:31 +1100
Message-Id: <1520400451-11475-3-git-send-email-me@tobin.cc>
In-Reply-To: <1520400451-11475-1-git-send-email-me@tobin.cc>
References: <1520400451-11475-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Tycho Andersen <tycho@tycho.ws>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>, James Simmons <jsimmons@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently lustre uses a VLA to store a string on the stack.  We can use
the newly define VLA_SAFE macro to make this declaration safer.

Use VLA_SAFE to declare VLA.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/staging/lustre/lustre/llite/xattr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 532384c91447..6f4099cd4afa 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -36,6 +36,7 @@
 #include <linux/mm.h>
 #include <linux/xattr.h>
 #include <linux/selinux.h>
+#include <linux/vla.h>
 
 #define DEBUG_SUBSYSTEM S_LLITE
 
@@ -87,12 +88,13 @@ ll_xattr_set_common(const struct xattr_handler *handler,
 		    const char *name, const void *value, size_t size,
 		    int flags)
 {
-	char fullname[strlen(handler->prefix) + strlen(name) + 1];
 	struct ll_sb_info *sbi = ll_i2sbi(inode);
 	struct ptlrpc_request *req = NULL;
 	const char *pv = value;
 	__u64 valid;
 	int rc;
+	int size = strlen(handler->prefix) + strlen(name) + 1;
+	VLA_SAFE(char, fullname, size, VLA_DEFAULT_MAX);
 
 	if (flags == XATTR_REPLACE) {
 		ll_stats_ops_tally(ll_i2sbi(inode), LPROC_LL_REMOVEXATTR, 1);
-- 
2.7.4
