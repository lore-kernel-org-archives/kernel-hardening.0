From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:31 +1100
Message-Id: <1510204175-10138-5-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 4/8] scripts/leaking_addresses: fix comment typo
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Fix typo in comment string.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 719ed0aaede7..3f8c6e230962 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -40,7 +40,7 @@ my @skip_parse_files_abs = ('/proc/kmsg',
 			    '/sys/kernel/debug/tracing/trace_pipe',
 			    '/sys/kernel/security/apparmor/revision');
 
-# Do not parse thes files under any subdirectory.
+# Do not parse these files under any subdirectory.
 my @skip_parse_files_any = ('0',
 			    '1',
 			    '2',
-- 
2.7.4
