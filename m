From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 3/6] lib/string: Use correct docstring format
Date: Tue, 19 Feb 2019 10:23:05 +1100
Message-Id: <20190218232308.11241-4-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently the docstring comments for strscpy() are not in the correct
format.  Prior to working on this file fix up the docstring.

Use correct docstring format for strscpy().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/string.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 7f1d72db53c5..65969cf32f5d 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -159,11 +159,9 @@ EXPORT_SYMBOL(strlcpy);
  * @src: Where to copy the string from
  * @count: Size of destination buffer
  *
- * Copy the string, or as much of it as fits, into the dest buffer.
- * The routine returns the number of characters copied (not including
- * the trailing NUL) or -E2BIG if the destination buffer wasn't big enough.
- * The behavior is undefined if the string buffers overlap.
- * The destination buffer is always NUL terminated, unless it's zero-sized.
+ * Copy the string, or as much of it as fits, into the dest buffer.  The
+ * behavior is undefined if the string buffers overlap.  The destination
+ * buffer is always NUL terminated, unless it's zero-sized.
  *
  * Preferred to strlcpy() since the API doesn't require reading memory
  * from the src string beyond the specified "count" bytes, and since
@@ -175,6 +173,9 @@ EXPORT_SYMBOL(strlcpy);
  * doesn't unnecessarily force the tail of the destination buffer to be
  * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
  * check the return size, then just memset() the tail of the dest buffer.
+ *
+ * Return: The number of characters copied (not including the trailing
+ *         NUL) or -E2BIG if the destination buffer wasn't big enough.
  */
 ssize_t strscpy(char *dest, const char *src, size_t count)
 {
-- 
2.20.1
