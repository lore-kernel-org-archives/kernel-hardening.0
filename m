From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:39 +1100
Message-Id: <1510112259-11572-8-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 7/7] scripts/leaking_addresses: don't parse usbmon
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

file 'usbmon' causes script to hang.

Add usbmon to files to skip under any sub directory.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 0671aac894be..501a4759137f 100644
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -69,7 +69,8 @@ my @skip_walk_dirs_any = ('self',
 			  'fd',
 			  'stderr',
 			  'stdin',
-			  'stdout');
+			  'stdout',
+			  'usbmon');
 
 sub help
 {
-- 
2.7.4
