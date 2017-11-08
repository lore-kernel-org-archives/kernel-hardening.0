From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:33 +1100
Message-Id: <1510112259-11572-2-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 1/7] scripts/leaking_addresses: use tabs not spaces
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Current code uses spaces instead of tabs in places.

Use tabs instead of spaces.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 54 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 2977371b2956..b64efcecbb5e 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -170,46 +170,46 @@ sub push_to_global
 
 sub is_false_positive
 {
-        my ($match) = @_;
+	my ($match) = @_;
+
+	if ($match =~ '\b(0x)?(f|F){16}\b' or
+	    $match =~ '\b(0x)?0{16}\b') {
+		return 1;
+	}
 
-        if ($match =~ '\b(0x)?(f|F){16}\b' or
-            $match =~ '\b(0x)?0{16}\b') {
-                return 1;
-        }
 
-        # vsyscall memory region, we should probably check against a range here.
-        if ($match =~ '\bf{10}600000\b' or
-            $match =~ '\bf{10}601000\b') {
-                return 1;
-        }
+	if ($match =~ '\bf{10}600000\b' or# vsyscall memory region, we should probably check against a range here.
+	    $match =~ '\bf{10}601000\b') {
+		return 1;
+	}
 
-        return 0;
+	return 0;
 }
 
 # True if argument potentially contains a kernel address.
 sub may_leak_address
 {
-        my ($line) = @_;
-        my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+	my ($line) = @_;
+	my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
 
-        # Signal masks.
-        if ($line =~ '^SigBlk:' or
-            $line =~ '^SigCgt:') {
-                return 0;
-        }
+	# Signal masks.
+	if ($line =~ '^SigBlk:' or
+	    $line =~ '^SigCgt:') {
+		return 0;
+	}
 
-        if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
-            $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
+	if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
+	    $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
 		return 0;
-        }
+	}
 
-        while (/($address)/g) {
-                if (!is_false_positive($1)) {
-                        return 1;
-                }
-        }
+	while (/($address)/g) {
+		if (!is_false_positive($1)) {
+			return 1;
+		}
+	}
 
-        return 0;
+	return 0;
 }
 
 sub parse_dmesg
-- 
2.7.4
