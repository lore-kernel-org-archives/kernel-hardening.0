From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  8 Nov 2017 23:30:19 +0100
Message-Id: <20171108223020.24487-6-linux@rasmusvillemoes.dk>
In-Reply-To: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk>
Subject: [kernel-hardening] [RFC 5/6] kernel.h: implement fmtmatch() wrapper around fmtcheck()
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

I couldn't come up with a better name, suggestions welcome.

Some users may prefer to EINVAL rather than using the the template as a
fallback for printf'ing. fmtmatch() is simply a shorthand for
fmtcheck(a, b, c) == a.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 include/linux/kernel.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index d7c6f9a9c024..5eae5ecb590d 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -466,6 +466,13 @@ const char *_fmtcheck(const char *fmt, const char *tmpl, unsigned flags);
 #define FMTCHECK_SILENT        0x01
 #define FMTCHECK_NO_EXTRA_ARGS 0x02
 
+#define fmtmatch(fmt, tmpl, flags) _fmtmatch(fmt, "" tmpl "", flags)
+static inline bool
+_fmtmatch(const char *fmt, const char *tmpl, unsigned flags)
+{
+	return _fmtcheck(fmt, tmpl, flags) == fmt;
+}
+
 extern __scanf(2, 3)
 int sscanf(const char *, const char *, ...);
 extern __scanf(2, 0)
-- 
2.11.0
