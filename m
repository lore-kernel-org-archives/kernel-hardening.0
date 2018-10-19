From: Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 2/2] seq_buf: Use size_t for len in seq_buf_puts()
Date: Fri, 19 Oct 2018 15:21:09 +1100
Message-Id: <20181019042109.8064-2-mpe@ellerman.id.au>
In-Reply-To: <20181019042109.8064-1-mpe@ellerman.id.au>
References: <20181019042109.8064-1-mpe@ellerman.id.au>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, jannh@google.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Jann Horn points out that we're using unsigned int for len in
seq_buf_puts(), which could potentially overflow if we're passed a
UINT_MAX sized string.

The rest of the code already uses size_t, so we should also use that
in seq_buf_puts() to avoid any issues.

Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 lib/seq_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v2: New in v2.

diff --git a/lib/seq_buf.c b/lib/seq_buf.c
index 6aabb609dd87..bd807f545a9d 100644
--- a/lib/seq_buf.c
+++ b/lib/seq_buf.c
@@ -140,7 +140,7 @@ int seq_buf_bprintf(struct seq_buf *s, const char *fmt, const u32 *binary)
  */
 int seq_buf_puts(struct seq_buf *s, const char *str)
 {
-	unsigned int len = strlen(str);
+	size_t len = strlen(str);
 
 	WARN_ON(s->size == 0);
 
-- 
2.17.2
