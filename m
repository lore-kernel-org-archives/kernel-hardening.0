From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu, 30 Nov 2017 10:38:38 +1100
Message-Id: <1511998718-4158-3-git-send-email-me@tobin.cc>
In-Reply-To: <1511998718-4158-1-git-send-email-me@tobin.cc>
References: <1511998718-4158-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 2/2] printk: add specifier %pz, for zeroed address
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, David Laight <David.Laight@aculab.com>, Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Krcm=C3=A1r?= <rkrcmar@redhat.com>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently %pK [at times] zeros addresses. It would be nice to remove %pK
entirely. Printing zero addresses is useful if we want to sanitize an
address but there may be userland tools that currently rely on the
address format (i.e the correct width).

Add printk specifier %pz.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/printk-formats.txt | 11 +++++++++++
 lib/vsprintf.c                   | 18 ++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index aa0a776c817a..f88b06485378 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -122,6 +122,17 @@ uniquely grep'able. If, in the future, we need to modify the way the Kernel
 handles printing pointers it will be nice to be able to find the call
 sites.
 
+Zeroed Addresses
+================
+
+::
+
+	%pz	00000000 or 0000000000000000
+
+For printing zeroed addresses. This is useful if you are want to sanitize
+an address but there may be userland tools that depend on the correct width
+of the address for parsing.
+
 Struct Resources
 ================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 81e9ce8f52f9..ebf911618858 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1727,6 +1727,19 @@ static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
 	return number(buf, end, hashval, spec);
 }
 
+static noinline_for_stack
+char *zero_string(char *buf, char *end, struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(void *);
+		spec.flags |= ZEROPAD;
+	}
+
+	return number(buf, end, 0, spec);
+}
+
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1833,6 +1846,9 @@ static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
  *                        C full compatible string
  *
  * - 'x' For printing the address. Equivalent to "%lx".
+ * - 'z' For printing zeroed addresses. This is useful if you are want to
+ *       sanitize an address but there may be userland tools that depend on the
+ *       correct width of the address for parsing.
  *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
@@ -1960,6 +1976,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		}
 	case 'x':
 		return pointer_string(buf, end, ptr, spec);
+	case 'z':
+		return zero_string(buf, end, spec);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
-- 
2.7.4
