From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 2/6] lib/string: Fix erroneous 'overflow' documentation
Date: Tue, 19 Feb 2019 10:23:04 +1100
Message-Id: <20190218232308.11241-3-tobin@kernel.org>
In-Reply-To: <20190218232308.11241-1-tobin@kernel.org>
References: <20190218232308.11241-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Current documentation uses 'overflow' to describe a situation where less
data is written to a buffer than buffer size not more.  'overflow' is
the wrong word here - since we don't typically say 'underflow' change
the whole sentence.

Fix erroneous 'overflow' documentation for under filled buffer.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 lib/string.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 38e4ca08e757..7f1d72db53c5 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -173,8 +173,8 @@ EXPORT_SYMBOL(strlcpy);
  *
  * Preferred to strncpy() since it always returns a valid string, and
  * doesn't unnecessarily force the tail of the destination buffer to be
- * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy()
- * with an overflow test, then just memset() the tail of the dest buffer.
+ * zeroed.  If the zeroing is desired, it's likely cleaner to use strscpy(),
+ * check the return size, then just memset() the tail of the dest buffer.
  */
 ssize_t strscpy(char *dest, const char *src, size_t count)
 {
-- 
2.20.1
