From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 19 Dec 2017 14:28:13 +1100
Message-Id: <1513654094-16832-3-git-send-email-me@tobin.cc>
In-Reply-To: <1513654094-16832-1-git-send-email-me@tobin.cc>
References: <1513654094-16832-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 2/3] vsprintf: print <no-symbol> if symbol not found
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Depends on: commit 40eee173a35e ("kallsyms: don't leak address when
symbol not found")

Currently vsprintf for specifiers %p[SsB] relies on the behaviour of
kallsyms (sprint_symbol()) and prints the actual address if a symbol is
not found. Previous patch changes this behaviour so that sprint_symbol()
returns an error if symbol not found. With this patch in place we can
print a sanitized message '<symbol not found>' instead of leaking the
address.

Print '<symbol not found>' for printk specifier %p[sSB] if symbol look
up fails.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 lib/vsprintf.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 01c3957b2de6..820ed4fe6e6c 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -674,6 +674,8 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
+	const char *sym_not_found = "<symbol not found>";
+	int ret;
 #endif
 
 	if (fmt[1] == 'R')
@@ -682,11 +684,14 @@ char *symbol_string(char *buf, char *end, void *ptr,
 
 #ifdef CONFIG_KALLSYMS
 	if (*fmt == 'B')
-		sprint_backtrace(sym, value);
+		ret = sprint_backtrace(sym, value);
 	else if (*fmt != 'f' && *fmt != 's')
-		sprint_symbol(sym, value);
+		ret = sprint_symbol(sym, value);
 	else
-		sprint_symbol_no_offset(sym, value);
+		ret = sprint_symbol_no_offset(sym, value);
+
+	if (ret == -1)
+		strcpy(sym, sym_not_found);
 
 	return string(buf, end, sym, spec);
 #else
-- 
2.7.4
