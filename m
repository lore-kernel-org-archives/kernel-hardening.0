Subject: [PATCH v6 10/13] vfs,
 fdtable: prevent bounds-check bypass via speculative execution
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 29 Jan 2018 17:03:05 -0800
Message-ID: <151727418500.33451.17392199002892248656.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151727412964.33451.17213780323040673404.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, mingo@kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, torvalds@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

'fd' is a user controlled value that is used as a data dependency to
read from the 'fdt->fd' array.  In order to avoid potential leaks of
kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid 'file *' returned from
__fcheck_files.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/fdtable.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 1c65817673db..41615f38bcff 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -10,6 +10,7 @@
 #include <linux/compiler.h>
 #include <linux/spinlock.h>
 #include <linux/rcupdate.h>
+#include <linux/nospec.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/fs.h>
@@ -82,8 +83,10 @@ static inline struct file *__fcheck_files(struct files_struct *files, unsigned i
 {
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
 
-	if (fd < fdt->max_fds)
+	if (fd < fdt->max_fds) {
+		fd = array_index_nospec(fd, fdt->max_fds);
 		return rcu_dereference_raw(fdt->fd[fd]);
+	}
 	return NULL;
 }
 
