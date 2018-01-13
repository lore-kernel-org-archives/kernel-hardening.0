From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 13 Jan 2018 10:18:16 -0800
Message-ID: <151586749581.5820.10884753209923259828.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151586744180.5820.13215059696964205856.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 9/9] vfs,
 fdtable: prevent bounds-check bypass via speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, gregkh@linuxfoundation.org, Al Viro <viro@zeniv.linux.org.uk>, tglx@linutronix.de, torvalds@linux-foundation.org, akpm@linux-foundation.org, alan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Expectedly, static analysis reports that 'fd' is a user controlled value
that is used as a data dependency to read from the 'fdt->fd' array.  In
order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue reads
based on an invalid 'file *' returned from __fcheck_files.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/fdtable.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 1c65817673db..9731f1a255db 100644
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
@@ -81,9 +82,11 @@ struct dentry;
 static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+	struct file __rcu **fdp;
 
-	if (fd < fdt->max_fds)
-		return rcu_dereference_raw(fdt->fd[fd]);
+	fdp = array_ptr(fdt->fd, fd, fdt->max_fds);
+	if (fdp)
+		return rcu_dereference_raw(*fdp);
 	return NULL;
 }
 
