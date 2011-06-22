Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 22 Jun 2011 13:53:41 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110622095341.GA3353@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] kernel: escape non-ASCII and control characters in printk()
To: Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>, Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch escapes all characters outside of allowed '\n' plus 0x20-0x7E
charset passed to printk().

There are numerous printk() instances with user supplied input as "%s"
data, and unprivileged user may craft log messages with substrings
containing control characters via these printk()s.  Control characters
might fool root viewing the logs via tty.

Printing non-ASCII characters is not portable since not everyone sees
the same characters after 0xFF.  If any driver use it to print some
binary data, it should be fixed.  Not fixed code will print hex codes
of the binary data.

On testing Samsung Q310 laptop there are no users of chars outside of the
restricted charset.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---

 This patch does nothing with crafted "%s" data with '\n' inside.  It
 allows unprivileged user to craft arbitrary log messages via breaking
 log lines boundaries.  It is a bit tricky to fix it compatible way.
 Limiting "%s" to one line in vscnprintf() would break legitimate users
 of the multiline feature.  Intoducing new "%S" format for single lines
 makes little sense as there are tons of printk() calls that should be
 already restricted to one line.

 Proposals about '\n' inside of '%s" are welcome.


 kernel/printk.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 3518539..1f23988 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -671,6 +671,20 @@ static void emit_log_char(char c)
 		logged_chars++;
 }
 
+static void emit_log_char_escaped(char c)
+{
+	char buffer[8];
+	int i, len;
+
+	if ((c >= ' ' && c < 127) || c == '\n')
+		emit_log_char(c);
+	else {
+		len = sprintf(buffer, "#%02x", c);
+		for (i = 0; i < len; i++)
+			emit_log_char(buffer[i]);
+	}
+}
+
 /*
  * Zap console related locks when oopsing. Only zap at most once
  * every 10 seconds, to leave time for slow consoles to print a
@@ -938,7 +952,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 				break;
 		}
 
-		emit_log_char(*p);
+		emit_log_char_escaped(*p);
 		if (*p == '\n')
 			new_text_line = 1;
 	}
-- 
1.7.0.4
