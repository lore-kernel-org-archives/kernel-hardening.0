From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] of: unittest: Remove VLA stack usage
Date: Mon, 12 Mar 2018 15:27:23 +1100
Message-Id: <1520828843-22289-1-git-send-email-me@tobin.cc>
To: Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  This is a
test function so the execution speed is not critical.  We can allocate
memory for this buffer instead of using a VLA.  If kmalloc() fails just
return.

Allocate buffer with kmalloc().

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

Kees is this annoying you, CC'ing you an all my VLA patches?

 drivers/of/unittest.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
index 1991fe4319f5..38cbc343b7da 100644
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -254,12 +254,18 @@ static void __init of_unittest_check_tree_linkage(void)
 static void __init of_unittest_printf_one(struct device_node *np, const char *fmt,
 					  const char *expected)
 {
-	unsigned char buf[strlen(expected)+10];
+	unsigned char *buf;
+	int buf_size;
 	int size, i;
 
+	buf_size = strlen(expected) + 10;
+	buf = kmalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return;
+
 	/* Baseline; check conversion with a large size limit */
-	memset(buf, 0xff, sizeof(buf));
-	size = snprintf(buf, sizeof(buf) - 2, fmt, np);
+	memset(buf, 0xff, buf_size);
+	size = snprintf(buf, buf_size - 2, fmt, np);
 
 	/* use strcmp() instead of strncmp() here to be absolutely sure strings match */
 	unittest((strcmp(buf, expected) == 0) && (buf[size+1] == 0xff),
@@ -270,12 +276,13 @@ static void __init of_unittest_printf_one(struct device_node *np, const char *fm
 	size++;
 	for (i = 0; i < 2; i++, size--) {
 		/* Clear the buffer, and make sure it works correctly still */
-		memset(buf, 0xff, sizeof(buf));
+		memset(buf, 0xff, buf_size);
 		snprintf(buf, size+1, fmt, np);
 		unittest(strncmp(buf, expected, size) == 0 && (buf[size+1] == 0xff),
 			"snprintf failed; size=%i fmt='%s' expected='%s' rslt='%s'\n",
 			size, fmt, expected, buf);
 	}
+	kfree(buf);
 }
 
 static void __init of_unittest_printf(void)
-- 
2.7.4
