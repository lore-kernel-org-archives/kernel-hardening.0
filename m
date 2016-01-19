Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Tue, 19 Jan 2016 10:08:36 -0800
Message-Id: <1453226922-16831-3-git-send-email-keescook@chromium.org>
In-Reply-To: <1453226922-16831-1-git-send-email-keescook@chromium.org>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v4 2/8] lib: add "on" and "off" to strtobool
To: Ingo Molnar <mingo@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Several places in the kernel expect to use "on" and "off" for their
boolean signifiers, so add them to strtobool.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 lib/string.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 0323c0d5629a..091570708db7 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -635,12 +635,15 @@ EXPORT_SYMBOL(sysfs_streq);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
- * Otherwise it will return -EINVAL.  Value pointed to by res is
- * updated upon finding a match.
+ * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
+ * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
+ * pointed to by res is updated upon finding a match.
  */
 int strtobool(const char *s, bool *res)
 {
+	if (!s)
+		return -EINVAL;
+
 	switch (s[0]) {
 	case 'y':
 	case 'Y':
@@ -652,6 +655,21 @@ int strtobool(const char *s, bool *res)
 	case '0':
 		*res = false;
 		break;
+	case 'o':
+	case 'O':
+		switch (s[1]) {
+		case 'n':
+		case 'N':
+			*res = true;
+			break;
+		case 'f':
+		case 'F':
+			*res = false;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.6.3
