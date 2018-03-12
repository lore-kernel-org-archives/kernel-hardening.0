Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 12 Mar 2018 03:03:34 +0000
Message-ID: <lsq.1520823814.357571797@decadent.org.uk>
Subject: [PATCH 3.2 088/104] vfs, fdtable: Prevent bounds-check bypass via
 speculative execution
In-Reply-To: <lsq.1520823814.606620518@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, gregkh@linuxfoundation.org, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, torvalds@linux-foundation.org, kernel-hardening@lists.openwall.com, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

3.2.101-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
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
@@ -85,8 +86,10 @@ static inline struct file * fcheck_files
 	struct file * file = NULL;
 	struct fdtable *fdt = files_fdtable(files);
 
-	if (fd < fdt->max_fds)
+	if (fd < fdt->max_fds) {
+		fd = array_index_nospec(fd, fdt->max_fds);
 		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
+	}
 	return file;
 }
 
