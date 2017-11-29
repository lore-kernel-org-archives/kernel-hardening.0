From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 29 Nov 2017 13:05:04 +1100
Message-Id: <1511921105-3647-5-git-send-email-me@tobin.cc>
In-Reply-To: <1511921105-3647-1-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V11 4/5] vsprintf: add printk specifier %px
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

printk specifier %p now hashes all addresses before printing. Sometimes
we need to see the actual unmodified address. This can be achieved using
%lx but then we face the risk that if in future we want to change the
way the Kernel handles printing of pointers we will have to grep through
the already existent 50 000 %lx call sites. Let's add specifier %px as a
clear, opt-in, way to print a pointer and maintain some level of
isolation from all the other hex integer output within the Kernel.

Add printk specifier %px to print the actual unmodified address.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 Documentation/printk-formats.txt | 18 +++++++++++++++++-
 lib/vsprintf.c                   | 18 ++++++++++++++++++
 scripts/checkpatch.pl            |  2 +-
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index b4e668ac4fe3..aa0a776c817a 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -49,7 +49,8 @@ Pointer Types
 
 Pointers printed without a specifier extension (i.e unadorned %p) are
 hashed to give a unique identifier without leaking kernel addresses to user
-space. On 64 bit machines the first 32 bits are zeroed.
+space. On 64 bit machines the first 32 bits are zeroed. If you _really_
+want the address see %px below.
 
 ::
 
@@ -106,6 +107,21 @@ For printing kernel pointers which should be hidden from unprivileged
 users. The behaviour of ``%pK`` depends on the ``kptr_restrict sysctl`` - see
 Documentation/sysctl/kernel.txt for more details.
 
+Unmodified Addresses
+====================
+
+::
+
+	%px	01234567 or 0123456789abcdef
+
+For printing pointers when you _really_ want to print the address. Please
+consider whether or not you are leaking sensitive information about the
+Kernel layout in memory before printing pointers with %px. %px is
+functionally equivalent to %lx. %px is preferred to %lx because it is more
+uniquely grep'able. If, in the future, we need to modify the way the Kernel
+handles printing pointers it will be nice to be able to find the call
+sites.
+
 Struct Resources
 ================
 
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d69452a0f2fa..d960aead0336 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1646,6 +1646,20 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
+static noinline_for_stack
+char *pointer_string(char *buf, char *end, const void *ptr,
+		     struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(ptr);
+		spec.flags |= ZEROPAD;
+	}
+
+	return number(buf, end, (unsigned long int)ptr, spec);
+}
+
 static bool have_filled_random_ptr_key __read_mostly;
 static siphash_key_t ptr_key __read_mostly;
 
@@ -1818,6 +1832,8 @@ static char *ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec)
  *                        c major compatible string
  *                        C full compatible string
  *
+ * - 'x' For printing the address. Equivalent to "%lx".
+ *
  * ** Please update also Documentation/printk-formats.txt when making changes **
  *
  * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
@@ -1940,6 +1956,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		case 'F':
 			return device_node_string(buf, end, ptr, spec, fmt + 1);
 		}
+	case 'x':
+		return pointer_string(buf, end, ptr, spec);
 	}
 
 	/* default is to _not_ leak addresses, hash before printing */
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 95cda3ecc66b..040aa79e1d9d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5753,7 +5753,7 @@ sub process {
 		        for (my $count = $linenr; $count <= $lc; $count++) {
 				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
 				$fmt =~ s/%%//g;
-				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNO]).)/) {
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGNOx]).)/) {
 					$bad_extension = $1;
 					last;
 				}
-- 
2.7.4
