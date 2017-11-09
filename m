From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:32 +1100
Message-Id: <1510204175-10138-6-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 5/8] scripts/leaking_addresses: add to exclude files/paths
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There are a couple more files that cause the script to stall.

/sys/firmware/devicetree and its symlink /proc/device-tree, reported by
Michael Ellerman.

usbmon should be skipped were ever it appears. Reported by Kees Cook

Add files to be excluded from parsing.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 3f8c6e230962..0aac03a020a8 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -37,6 +37,8 @@ my @skip_parse_files_abs = ('/proc/kmsg',
 			    '/proc/kcore',
 			    '/proc/fs/ext4/sdb1/mb_groups',
 			    '/proc/1/fd/3',
+			    '/sys/firmware/devicetree',
+			    '/proc/device-tree',
 			    '/sys/kernel/debug/tracing/trace_pipe',
 			    '/sys/kernel/security/apparmor/revision');
 
@@ -61,6 +63,7 @@ my @skip_walk_dirs_any = ('self',
 			  'thread-self',
 			  'cwd',
 			  'fd',
+			  'usbmon',
 			  'stderr',
 			  'stdin',
 			  'stdout');
-- 
2.7.4
