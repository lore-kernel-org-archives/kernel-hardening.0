From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:34 +1100
Message-Id: <1510112259-11572-3-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 2/7] scripts/leaking_addresses: remove dead code
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

debug_arrays is not called. Also, %seen hash is not used. We should
remove unused code.

Remove dead code.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index b64efcecbb5e..94b22d5b9237 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -133,14 +133,6 @@ walk(@DIRS);
 
 exit 0;
 
-sub debug_arrays
-{
-	print 'dirs_any: ' . join(", ", @skip_walk_dirs_any) . "\n";
-	print 'dirs_abs: ' . join(", ", @skip_walk_dirs_abs) . "\n";
-	print 'parse_any: ' . join(", ", @skip_parse_files_any) . "\n";
-	print 'parse_abs: ' . join(", ", @skip_parse_files_abs) . "\n";
-}
-
 sub dprint
 {
 	printf(STDERR @_) if $debug;
@@ -281,7 +273,6 @@ sub skip_walk
 sub walk
 {
 	my @dirs = @_;
-	my %seen;
 
 	while (my $pwd = shift @dirs) {
 		next if (skip_walk($pwd));
-- 
2.7.4
