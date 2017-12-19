From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 20 Dec 2017 08:39:22 +1100
Message-Id: <1513719564-13249-2-git-send-email-me@tobin.cc>
In-Reply-To: <1513719564-13249-1-git-send-email-me@tobin.cc>
References: <1513719564-13249-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v3 1/3] kallsyms: don't leak address when symbol not found
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Steven Rostedt <rostedt@goodmis.org>, Tycho Andersen <tycho@tycho.ws>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Daniel Borkmann <daniel@iogearbox.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

Currently if kallsyms_lookup() fails to find the symbol then the address
is printed. This potentially leaks sensitive information but is useful
for debugging. We would like to stop the leak but keep the current
behaviour when needed for debugging. To achieve this we can add a
command-line parameter that if enabled maintains the current
behaviour. If the command-line parameter is not enabled we can return an
error instead of printing the address giving the calling code the option
of how to handle the look up failure.

Add command-line parameter 'insecure_print_all_symbols'. If parameter is
not enabled return an error value instead of printing the raw address.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 kernel/kallsyms.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index d5fa4116688a..2707cf751437 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -383,6 +383,16 @@ int lookup_symbol_attrs(unsigned long addr, unsigned long *size,
 	return lookup_module_symbol_attrs(addr, size, offset, modname, name);
 }
 
+/* Enables printing of raw address when symbol look up fails */
+static bool insecure_print_all_symbols;
+
+static int __init enable_insecure_print_all_symbols(char *unused)
+{
+	insecure_print_all_symbols = true;
+	return 0;
+}
+early_param("insecure_print_all_symbols", enable_insecure_print_all_symbols);
+
 /* Look up a kernel symbol and return it in a text buffer. */
 static int __sprint_symbol(char *buffer, unsigned long address,
 			   int symbol_offset, int add_offset)
@@ -394,8 +404,15 @@ static int __sprint_symbol(char *buffer, unsigned long address,
 
 	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
-	if (!name)
-		return sprintf(buffer, "0x%lx", address - symbol_offset);
+	if (insecure_print_all_symbols) {
+		if (!name)
+			return sprintf(buffer, "0x%lx", address - symbol_offset);
+	} else {
+		if (!name) {
+			buffer[0] = '\0';
+			return -1;
+		}
+	}
 
 	if (name != buffer)
 		strcpy(buffer, name);
@@ -417,8 +434,9 @@ static int __sprint_symbol(char *buffer, unsigned long address,
  * @address: address to lookup
  *
  * This function looks up a kernel symbol with @address and stores its name,
- * offset, size and module name to @buffer if possible. If no symbol was found,
- * just saves its @address as is.
+ * offset, size and module name to @buffer if possible. If no symbol was found
+ * returns -1 unless kernel command-line parameter 'insecure_print_all_symbols'
+ * is enabled, in which case saves @address as is to buffer.
  *
  * This function returns the number of bytes stored in @buffer.
  */
@@ -434,8 +452,9 @@ EXPORT_SYMBOL_GPL(sprint_symbol);
  * @address: address to lookup
  *
  * This function looks up a kernel symbol with @address and stores its name
- * and module name to @buffer if possible. If no symbol was found, just saves
- * its @address as is.
+ * and module name to @buffer if possible. If no symbol was found, returns -1
+ * unless kernel command-line parameter 'insecure_print_all_symbols' is enabled,
+ * in which case saves @address as is to buffer.
  *
  * This function returns the number of bytes stored in @buffer.
  */
-- 
2.7.4
