From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 6/6] lib: Add function strscpy_from_user()
Date: Tue, 19 Feb 2019 10:23:08 +1100
Message-Id: <20190218232308.11241-7-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently we have strncpy_from_userspace().  If the user string is
longer than the destination kernel buffer we get an error code -EFAULT.
We are unable to recover from here because this is the same error
returned if the access to userspace fails totally.

There is no reason we cannot continue execution with the user string
truncated.

Add a function strscpy_from_user() that guarantees the string written is
null-terminated.  If user string is longer than destination buffer
truncates the string.  Returns the number of characters written
excluding the null-terminator.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/strncpy_from_user.c | 43 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 11fe9a4a00fd..6bd603ccec7a 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -120,3 +120,46 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	return -EFAULT;
 }
 EXPORT_SYMBOL(strncpy_from_user);
+
+/**
+ * strscpy_from_user() - Copy a NUL terminated string from userspace.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing %NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.  When
+ * the function returns @dst is guaranteed to be null terminated.
+ *
+ * Return: If access to userspace fails, returns -EFAULT.  Otherwise,
+ *         return the number of characters copied excluding the trailing
+ *         %NUL.
+ */
+long strscpy_from_user(char *dst, const char __user *src, long count)
+{
+	unsigned long max_addr, src_addr;
+
+	if (unlikely(count <= 0))
+		return 0;
+
+	max_addr = user_addr_max();
+	src_addr = (unsigned long)src;
+	if (likely(src_addr < max_addr)) {
+		unsigned long max = max_addr - src_addr;
+		long retval;
+
+		kasan_check_write(dst, count);
+		check_object_size(dst, count, false);
+		if (user_access_begin(src, max)) {
+			retval = do_strncpy_from_user(dst, src, count, max);
+			user_access_end();
+			if (retval == -EFAULT) {
+				dst[count-1] = '\0';
+				return count - 1;
+			}
+			return retval;
+		}
+	}
+	return -EFAULT;
+}
+EXPORT_SYMBOL(strscpy_from_user);
-- 
2.20.1
