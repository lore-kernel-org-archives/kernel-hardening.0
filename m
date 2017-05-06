Date: Fri, 5 May 2017 21:07:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20170506040759.GG32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170506040641.GA32707@kroah.com>
Subject: [kernel-hardening] [RFC 6/6] drivers: uio: Un-restrict sysfs pointers for UIO
To: kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Chris Fries <cfries@google.com>

The addr and size on the UIO devices are required by userspace to function
properly.  Let's unrestrict these by adding the 'P' modifier to %p and %pa.

Cc: William Roberts <william.c.roberts@intel.com>
Cc: Dave Weinstein <olorin@google.com>
Signed-off-by: Chris Fries <cfries@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 60ce7fd54e89..d9eae52519f4 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -56,12 +56,12 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "%pa\n", &mem->addr);
+	return sprintf(buf, "%paP\n", &mem->addr);
 }
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "%pa\n", &mem->size);
+	return sprintf(buf, "%paP\n", &mem->size);
 }
 
 static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
-- 
2.12.2
