From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:35 -0800
Message-ID: <151571805555.27429.728109914195885407.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 13/19] udf: prevent bounds-check bypass via speculative
 execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Jan Kara <jack@suse.com>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'eahd->appAttrLocation' and
'eahd->impAttrLocation' may be a user controlled values that are used as
data dependencies for calculating source and destination buffers for
memmove operations. In order to avoid potential leaks of kernel memory
values, block speculative execution of the instruction stream that could
issue further reads based on invalid 'aal' or 'ial' values.

Based on an original patch by Elena Reshetova.

Cc: Jan Kara <jack@suse.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/udf/misc.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 401e64cde1be..693e24699928 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -22,6 +22,7 @@
 #include "udfdecl.h"
 
 #include <linux/fs.h>
+#include <linux/nospec.h>
 #include <linux/string.h>
 #include <linux/crc-itu-t.h>
 
@@ -51,6 +52,8 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 	int offset;
 	uint16_t crclen;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	uint8_t *ea_dst, *ea_src;
+	uint32_t aal, ial;
 
 	ea = iinfo->i_ext.i_data;
 	if (iinfo->i_lenEAttr) {
@@ -100,33 +103,34 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 
 		offset = iinfo->i_lenEAttr;
 		if (type < 2048) {
-			if (le32_to_cpu(eahd->appAttrLocation) <
-					iinfo->i_lenEAttr) {
-				uint32_t aal =
-					le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size],
-					&ea[aal], offset - aal);
+			aal = le32_to_cpu(eahd->appAttrLocation);
+			ea_dst = array_ptr(ea, offset - aal + size,
+					iinfo->i_lenEAttr);
+			ea_src = array_ptr(ea, aal, iinfo->i_lenEAttr);
+			if (ea_dst && ea_src) {
+				memmove(ea_dst, ea_src, offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation =
 						cpu_to_le32(aal + size);
 			}
-			if (le32_to_cpu(eahd->impAttrLocation) <
-					iinfo->i_lenEAttr) {
-				uint32_t ial =
-					le32_to_cpu(eahd->impAttrLocation);
-				memmove(&ea[offset - ial + size],
-					&ea[ial], offset - ial);
+
+			ial = le32_to_cpu(eahd->impAttrLocation);
+			ea_dst = array_ptr(ea, offset - ial + size,
+					iinfo->i_lenEAttr);
+			ea_src = array_ptr(ea, ial, iinfo->i_lenEAttr);
+			if (ea_dst && ea_src) {
+				memmove(ea_dst, ea_src, offset - ial);
 				offset -= ial;
 				eahd->impAttrLocation =
 						cpu_to_le32(ial + size);
 			}
 		} else if (type < 65536) {
-			if (le32_to_cpu(eahd->appAttrLocation) <
-					iinfo->i_lenEAttr) {
-				uint32_t aal =
-					le32_to_cpu(eahd->appAttrLocation);
-				memmove(&ea[offset - aal + size],
-					&ea[aal], offset - aal);
+			aal = le32_to_cpu(eahd->appAttrLocation);
+			ea_dst = array_ptr(ea, offset - aal + size,
+					iinfo->i_lenEAttr);
+			ea_src = array_ptr(ea, aal, iinfo->i_lenEAttr);
+			if (ea_dst && ea_src) {
+				memmove(ea_dst, ea_src, offset - aal);
 				offset -= aal;
 				eahd->appAttrLocation =
 						cpu_to_le32(aal + size);
