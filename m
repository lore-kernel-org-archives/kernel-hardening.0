Reply-To: kernel-hardening@lists.openwall.com
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Date: Wed,  2 Nov 2016 22:32:49 +0530
Message-Id: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
Subject: [kernel-hardening] [RFC PATCH] lib: Harden csum_partial_copy_from_user
To: kernel-hardening@lists.openwall.com
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

The routine csum_partial_copy_from_user is same as csum_partial_copy
but it copies from user space for the checksumming. In other respects
it is identical, and can be used to copy an arbitrarily large buffer
from userspace into the kernel. Conceptually this exposes a similar
attack surface like copy_from_user. So, to validate the given address
we should call check_object_size here.

Note that in the absence of hardened usercopy this will have no impact.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
---
 lib/checksum.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/checksum.c b/lib/checksum.c
index d3ec93f..2e0fec8 100644
--- a/lib/checksum.c
+++ b/lib/checksum.c
@@ -33,6 +33,7 @@
  kills, so most of the assembly has to go. */
 
 #include <linux/export.h>
+#include <linux/thread_info.h>
 #include <net/checksum.h>
 
 #include <asm/byteorder.h>
@@ -158,6 +159,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
 {
 	int missing;
 
+	check_object_size(dst, len, false);
 	missing = __copy_from_user(dst, src, len);
 	if (missing) {
 		memset(dst + len - missing, 0, missing);
-- 
2.1.4
