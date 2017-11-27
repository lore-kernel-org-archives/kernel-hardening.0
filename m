From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 09:30:18 +1100
Message-Id: <1511821819-5496-3-git-send-email-me@tobin.cc>
In-Reply-To: <1511821819-5496-1-git-send-email-me@tobin.cc>
References: <1511821819-5496-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC 2/3] vsprintf: print <no-symbol> if symbol not found
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Petr Mladek <pmladek@suse.com>, Baoquan He <bhe@redhat.com>, Krzysztof Kozlowski <krzk@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Ian Abbott <abbotti@mev.co.uk>, =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>, Masahiro Yamada <yamada.masahiro@socionext.com>, Larry Finger <Larry.Finger@lwfinger.net>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Joe Perches <joe@perches.com>, William Roberts <william.c.roberts@intel.com>, Rob Herring <robh@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, Alexey Dobriyan <adobriyan@gmail.com>, Mauro Carvalho Chehab <mchehab@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Depends on: commit bd6b239cdbb2 ("kallsyms: don't leak address when
symbol not found")

Currently vsprintf for specifiers %p[SsB] relies on the behaviour of
kallsyms (sprint_symbol()) and prints the actual address if a symbol is
not found. Previous patch changes this behaviour so tha sprint_symbol()
returns an error if symbol not found. With this patch in place we can
print a sanitized message '<no-symbol>' instead of leaking the address.

Future users of vsprintf may wish to know, after a call that uses
specifier %p[sSB], whether or not a symbol was found. The actual
sanitized string should be contained (isolated) within the vsprintf.c
therefore we should provide a predicate function. This also allows the
sanitized string to be updated at a later stage with minimal risk to
calling code.

Print '<no-symbol>' for printk specifier %s[sSB] if no symbol is
found. Provide predicate function string_is_no_symbol().

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 include/linux/kernel.h |  2 ++
 lib/vsprintf.c         | 18 +++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index ce51455e2adf..89e8ce79c2d1 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -460,6 +460,8 @@ char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 extern __printf(2, 0)
 const char *kvasprintf_const(gfp_t gfp, const char *fmt, va_list args);
 
+extern int string_is_no_symbol(const char *s);
+
 extern __scanf(2, 3)
 int sscanf(const char *, const char *, ...);
 extern __scanf(2, 0)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1746bae94d41..01e18a8c63fd 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -665,6 +665,8 @@ char *bdev_name(char *buf, char *end, struct block_device *bdev,
 }
 #endif
 
+#define PRINTK_NO_SYMBOL_STR "<no-symbol>"
+
 static noinline_for_stack
 char *symbol_string(char *buf, char *end, void *ptr,
 		    struct printf_spec spec, const char *fmt)
@@ -672,6 +674,7 @@ char *symbol_string(char *buf, char *end, void *ptr,
 	unsigned long value;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
+	int ret;
 #endif
 
 	if (fmt[1] == 'R')
@@ -680,11 +683,14 @@ char *symbol_string(char *buf, char *end, void *ptr,
 
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
+		strcpy(sym, PRINTK_NO_SYMBOL_STR);
 
 	return string(buf, end, sym, spec);
 #else
@@ -692,6 +698,12 @@ char *symbol_string(char *buf, char *end, void *ptr,
 #endif
 }
 
+int string_is_no_symbol(const char *s)
+{
+	return !!strstr(s, PRINTK_NO_SYMBOL_STR);
+}
+EXPORT_SYMBOL(string_is_no_symbol);
+
 static noinline_for_stack
 char *resource_string(char *buf, char *end, struct resource *res,
 		      struct printf_spec spec, const char *fmt)
-- 
2.7.4
