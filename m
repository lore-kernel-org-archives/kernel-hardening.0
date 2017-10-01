From: "Tobin C. Harding" <me@tobin.cc>
Date: Sun,  1 Oct 2017 11:06:50 +1100
Message-Id: <1506816410-10230-7-git-send-email-me@tobin.cc>
In-Reply-To: <1506816410-10230-1-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2 6/6] drivers: uio: un-restrict sysfs pointers for UIO
To: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

The address and size on the UIO devices are required by userspace to
function properly.  Let's un-restrict these by adding the 'P' modifier
to %pa.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/uio/uio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index ff04b7f..728ec8f 100644
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
2.7.4
