Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:06:12 +0000
Message-ID: <lsq.1520823972.494230946@decadent.org.uk>
Subject: [PATCH 3.16 57/76] vfs, fdtable: Prevent bounds-check bypass via
 speculative execution
In-Reply-To: <lsq.1520823971.5976735@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, linux-arch@vger.kernel.org, alan@linux.intel.com, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

3.16.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 56c30ba7b348b90484969054d561f711ba196507 upstream.

'fd' is a user controlled value that is used as a data dependency to
read from the 'fdt->fd' array.  In order to avoid potential leaks of
kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid 'file *' returned from
__fcheck_files.

Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
Cc: gregkh@linuxfoundation.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: torvalds@linux-foundation.org
Cc: alan@linux.intel.com
Link: https://lkml.kernel.org/r/151727418500.33451.17392199002892248656.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/fdtable.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/nospec.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -76,8 +77,10 @@ static inline struct file *__fcheck_file
 {
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
 
-	if (fd < fdt->max_fds)
+	if (fd < fdt->max_fds) {
+		fd = array_index_nospec(fd, fdt->max_fds);
 		return rcu_dereference_raw(fdt->fd[fd]);
+	}
 	return NULL;
 }
 
