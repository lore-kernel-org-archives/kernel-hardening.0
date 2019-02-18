From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Date: Tue, 19 Feb 2019 10:23:07 +1100
Message-Id: <20190218232308.11241-6-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Current function documentation for strncpy_from_user() is incorrect.  If
@count (size of destination buffer) is less than the length of the user
string the function does _not_ return @count but rather returns -EFAULT.

Document correctly the function return value, also add note that string
may be left non-null terminated.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/strncpy_from_user.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 58eacd41526c..11fe9a4a00fd 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -82,22 +82,19 @@ static inline long do_strncpy_from_user(char *dst, const char __user *src, long
 }
 
 /**
- * strncpy_from_user: - Copy a NUL terminated string from userspace.
+ * strncpy_from_user() - Copy a NUL terminated string from userspace.
  * @dst:   Destination address, in kernel space.  This buffer must be at
  *         least @count bytes long.
  * @src:   Source address, in user space.
- * @count: Maximum number of bytes to copy, including the trailing NUL.
+ * @count: Maximum number of bytes to copy, including the trailing %NUL.
  *
  * Copies a NUL-terminated string from userspace to kernel space.
  *
- * On success, returns the length of the string (not including the trailing
- * NUL).
- *
- * If access to userspace fails, returns -EFAULT (some data may have been
- * copied).
- *
- * If @count is smaller than the length of the string, copies @count bytes
- * and returns @count.
+ * Return: If access to userspace fails, returns -EFAULT.  Otherwise,
+ *         return the number of characters copied excluding the trailing
+ *         %NUL, if the length of the user string exceeds @count return
+ *         -EFAULT (in which case @dst will be left without a %NUL
+ *         terminator).
  */
 long strncpy_from_user(char *dst, const char __user *src, long count)
 {
-- 
2.20.1
