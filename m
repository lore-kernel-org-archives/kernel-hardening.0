Date: Sat, 10 Mar 2018 14:34:50 -0800
From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] rslib: Remove VLAs by setting upper bound on nroots
Message-ID: <20180310223450.GA37999@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Segher Boessenkool <segher@kernel.crashing.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Avoid stack VLAs[1] by always allocating the upper bound of stack space
needed. The existing users of rslib appear to max out at 24 roots[2],
so use that as the upper bound until we have a reason to change it.

Alternative considered: make init_rs() a true caller-instance and
pre-allocate the workspaces. This would possibly need locking and
a refactoring of the returned structure.

Using kmalloc in this path doesn't look great, especially since at
least one caller (pstore) is sensitive to allocations during rslib
usage (it expects to run it during an Oops, for example).

[1] https://lkml.org/lkml/2018/3/7/621
[2] https://lkml.org/lkml/2018/3/9/838

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/reed_solomon/decode_rs.c    | 7 ++++---
 lib/reed_solomon/reed_solomon.c | 5 ++++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/lib/reed_solomon/decode_rs.c b/lib/reed_solomon/decode_rs.c
index 0ec3f257ffdf..3e3becb836a6 100644
--- a/lib/reed_solomon/decode_rs.c
+++ b/lib/reed_solomon/decode_rs.c
@@ -31,9 +31,10 @@
 	 * of nroots is 8. So the necessary stack size will be about
 	 * 220 bytes max.
 	 */
-	uint16_t lambda[nroots + 1], syn[nroots];
-	uint16_t b[nroots + 1], t[nroots + 1], omega[nroots + 1];
-	uint16_t root[nroots], reg[nroots + 1], loc[nroots];
+	uint16_t lambda[RS_MAX_ROOTS + 1], syn[RS_MAX_ROOTS];
+	uint16_t b[RS_MAX_ROOTS + 1], t[RS_MAX_ROOTS + 1];
+	uint16_t omega[RS_MAX_ROOTS + 1], root[RS_MAX_ROOTS];
+	uint16_t reg[RS_MAX_ROOTS + 1], loc[RS_MAX_ROOTS];
 	int count = 0;
 	uint16_t msk = (uint16_t) rs->nn;
 
diff --git a/lib/reed_solomon/reed_solomon.c b/lib/reed_solomon/reed_solomon.c
index 06d04cfa9339..3e218e70ac2e 100644
--- a/lib/reed_solomon/reed_solomon.c
+++ b/lib/reed_solomon/reed_solomon.c
@@ -51,6 +51,9 @@ static LIST_HEAD (rslist);
 /* Protection for the list */
 static DEFINE_MUTEX(rslistlock);
 
+/* Ultimately controls the upper bounds of the on-stack buffers. */
+#define RS_MAX_ROOTS	24
+
 /**
  * rs_init - Initialize a Reed-Solomon codec
  * @symsize:	symbol size, bits (1-8)
@@ -210,7 +213,7 @@ static struct rs_control *init_rs_internal(int symsize, int gfpoly,
     		return NULL;
 	if (prim <= 0 || prim >= (1<<symsize))
     		return NULL;
-	if (nroots < 0 || nroots >= (1<<symsize))
+	if (nroots < 0 || nroots >= (1<<symsize) || nroots > RS_MAX_ROOTS)
 		return NULL;
 
 	mutex_lock(&rslistlock);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
