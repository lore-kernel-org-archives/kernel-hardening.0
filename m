From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:29 -0800
Message-ID: <151571804955.27429.6378685761369089453.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 12/19] userns: prevent bounds-check bypass via
 speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, tglx@linutronix.de, Elena Reshetova <elena.reshetova@intel.com>, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'pos' may be a user controlled value that
is used as a data dependency determining which extent to return out of
'map'. In order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue further
reads based on an invalid speculative result from 'm_start()'.

Based on an original patch by Elena Reshetova.

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/user_namespace.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 246d4d4ce5c7..8c803eae186f 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -20,6 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/nospec.h>
 #include <linux/ctype.h>
 #include <linux/projid.h>
 #include <linux/fs_struct.h>
@@ -648,15 +649,13 @@ static void *m_start(struct seq_file *seq, loff_t *ppos,
 {
 	loff_t pos = *ppos;
 	unsigned extents = map->nr_extents;
-	smp_rmb();
 
-	if (pos >= extents)
-		return NULL;
+	/* paired with smp_wmb in map_write */
+	smp_rmb();
 
 	if (extents <= UID_GID_MAP_MAX_BASE_EXTENTS)
-		return &map->extent[pos];
-
-	return &map->forward[pos];
+		return array_ptr(map->extent, pos, extents);
+	return array_ptr(map->forward, pos, extents);
 }
 
 static void *uid_m_start(struct seq_file *seq, loff_t *ppos)
