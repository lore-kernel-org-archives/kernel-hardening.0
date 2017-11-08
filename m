From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:38 +1100
Message-Id: <1510112259-11572-7-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 6/7] scripts/leaking_addresses: fix comment typo
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Fix typo in comment string.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index e43105662306..0671aac894be 100644
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -46,7 +46,7 @@ my @skip_parse_files_abs = ('/proc/kmsg',
 			    '/sys/kernel/debug/tracing/trace_pipe',
 			    '/sys/kernel/security/apparmor/revision');
 
-# Do not parse thes files under any subdirectory.
+# Do not parse these files under any subdirectory.
 my @skip_parse_files_any = ('0',
 			    '1',
 			    '2',
-- 
2.7.4
