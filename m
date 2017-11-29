From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed, 29 Nov 2017 13:05:02 +1100
Message-Id: <1511921105-3647-3-git-send-email-me@tobin.cc>
In-Reply-To: <1511921105-3647-1-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH V11 2/5] vsprintf: refactor %pK code out of pointer()
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently code to handle %pK is all within the switch statement in
pointer(). This is the wrong level of abstraction. Each of the other switch
clauses call a helper function, pK should do the same.

Refactor code out of pointer() to new function restricted_pointer().

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 lib/vsprintf.c | 97 ++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 54 insertions(+), 43 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1746bae94d41..8dc5cf85cef4 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1343,6 +1343,59 @@ char *uuid_string(char *buf, char *end, const u8 *addr,
 	return string(buf, end, uuid, spec);
 }
 
+int kptr_restrict __read_mostly;
+
+static noinline_for_stack
+char *restricted_pointer(char *buf, char *end, const void *ptr,
+			 struct printf_spec spec)
+{
+	spec.base = 16;
+	spec.flags |= SMALL;
+	if (spec.field_width == -1) {
+		spec.field_width = 2 * sizeof(ptr);
+		spec.flags |= ZEROPAD;
+	}
+
+	switch (kptr_restrict) {
+	case 0:
+		/* Always print %pK values */
+		break;
+	case 1: {
+		const struct cred *cred;
+
+		/*
+		 * kptr_restrict==1 cannot be used in IRQ context
+		 * because its test for CAP_SYSLOG would be meaningless.
+		 */
+		if (in_irq() || in_serving_softirq() || in_nmi())
+			return string(buf, end, "pK-error", spec);
+
+		/*
+		 * Only print the real pointer value if the current
+		 * process has CAP_SYSLOG and is running with the
+		 * same credentials it started with. This is because
+		 * access to files is checked at open() time, but %pK
+		 * checks permission at read() time. We don't want to
+		 * leak pointer values if a binary opens a file using
+		 * %pK and then elevates privileges before reading it.
+		 */
+		cred = current_cred();
+		if (!has_capability_noaudit(current, CAP_SYSLOG) ||
+		    !uid_eq(cred->euid, cred->uid) ||
+		    !gid_eq(cred->egid, cred->gid))
+			ptr = NULL;
+		break;
+	}
+	case 2:
+	default:
+		/* Always print 0's for %pK */
+		ptr = NULL;
+		break;
+	}
+
+	return number(buf, end, (unsigned long)ptr, spec);
+}
+
 static noinline_for_stack
 char *netdev_bits(char *buf, char *end, const void *addr, const char *fmt)
 {
@@ -1591,8 +1644,6 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
 	return widen_string(buf, buf - buf_start, end, spec);
 }
 
-int kptr_restrict __read_mostly;
-
 /*
  * Show a '%p' thing.  A kernel extension is that the '%p' is followed
  * by an extra set of alphanumeric characters that are extended format
@@ -1792,47 +1843,7 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 			return buf;
 		}
 	case 'K':
-		switch (kptr_restrict) {
-		case 0:
-			/* Always print %pK values */
-			break;
-		case 1: {
-			const struct cred *cred;
-
-			/*
-			 * kptr_restrict==1 cannot be used in IRQ context
-			 * because its test for CAP_SYSLOG would be meaningless.
-			 */
-			if (in_irq() || in_serving_softirq() || in_nmi()) {
-				if (spec.field_width == -1)
-					spec.field_width = default_width;
-				return string(buf, end, "pK-error", spec);
-			}
-
-			/*
-			 * Only print the real pointer value if the current
-			 * process has CAP_SYSLOG and is running with the
-			 * same credentials it started with. This is because
-			 * access to files is checked at open() time, but %pK
-			 * checks permission at read() time. We don't want to
-			 * leak pointer values if a binary opens a file using
-			 * %pK and then elevates privileges before reading it.
-			 */
-			cred = current_cred();
-			if (!has_capability_noaudit(current, CAP_SYSLOG) ||
-			    !uid_eq(cred->euid, cred->uid) ||
-			    !gid_eq(cred->egid, cred->gid))
-				ptr = NULL;
-			break;
-		}
-		case 2:
-		default:
-			/* Always print 0's for %pK */
-			ptr = NULL;
-			break;
-		}
-		break;
-
+		return restricted_pointer(buf, end, ptr, spec);
 	case 'N':
 		return netdev_bits(buf, end, ptr, fmt);
 	case 'a':
-- 
2.7.4
