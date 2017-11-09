From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:30 +1100
Message-Id: <1510204175-10138-4-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 3/8] scripts/leaking_addresses: remove command line options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script accepts files to skip. This was added to make running
the script faster (for repeat runs). We can remove this functionality in
preparation for adding sub commands (scan and format) to the script.

Remove command line options.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 58 --------------------------------------------
 1 file changed, 58 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 94b22d5b9237..719ed0aaede7 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -7,25 +7,6 @@
 #  - Scans dmesg output.
 #  - Walks directory tree and parses each file (for each directory in @DIRS).
 #
-# You can configure the behaviour of the script;
-#
-#  - By adding paths, for directories you do not want to walk;
-#     absolute paths: @skip_walk_dirs_abs
-#     directory names: @skip_walk_dirs_any
-#
-#  - By adding paths, for files you do not want to parse;
-#     absolute paths: @skip_parse_files_abs
-#     file names: @skip_parse_files_any
-#
-# The use of @skip_xxx_xxx_any causes files to be skipped where ever they occur.
-# For example adding 'fd' to @skip_walk_dirs_any causes the fd/ directory to be
-# skipped for all PID sub-directories of /proc
-#
-# The same thing can be achieved by passing command line options to --dont-walk
-# and --dont-parse. If absolute paths are supplied to these options they are
-# appended to the @skip_xxx_xxx_abs arrays. If file names are supplied to these
-# options, they are appended to the @skip_xxx_xxx_any arrays.
-#
 # Use --debug to output path before parsing, this is useful to find files that
 # cause the script to choke.
 #
@@ -50,8 +31,6 @@ my @DIRS = ('/proc', '/sys');
 # Command line options.
 my $help = 0;
 my $debug = 0;
-my @dont_walk = ();
-my @dont_parse = ();
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -96,20 +75,9 @@ Version: $V
 
 Options:
 
-	--dont-walk=<dir>      Don't walk tree starting at <dir>.
-	--dont-parse=<file>    Don't parse <file>.
 	-d, --debug                Display debugging output.
 	-h, --help, --version      Display this help and exit.
 
-If an absolute path is passed to --dont_XXX then this path is skipped. If a
-single filename is passed then this file/directory will be skipped when
-appearing under any subdirectory.
-
-Example:
-
-	# Just scan dmesg output.
-	scripts/leaking_addresses.pl --dont_walk_abs /proc --dont_walk_abs /sys
-
 Scans the running (64 bit) kernel for potential leaking addresses.
 
 EOM
@@ -117,8 +85,6 @@ EOM
 }
 
 GetOptions(
-	'dont-walk=s'		=> \@dont_walk,
-	'dont-parse=s'		=> \@dont_parse,
 	'd|debug'		=> \$debug,
 	'h|help'		=> \$help,
 	'version'		=> \$help
@@ -126,8 +92,6 @@ GetOptions(
 
 help(0) if ($help);
 
-push_to_global();
-
 parse_dmesg();
 walk(@DIRS);
 
@@ -138,28 +102,6 @@ sub dprint
 	printf(STDERR @_) if $debug;
 }
 
-sub push_in_abs_any
-{
-	my ($in, $abs, $any) = @_;
-
-	foreach my $path (@$in) {
-		if (File::Spec->file_name_is_absolute($path)) {
-			push @$abs, $path;
-		} elsif (index($path,'/') == -1) {
-			push @$any, $path;
-		} else {
-			print 'path error: ' . $path;
-		}
-	}
-}
-
-# Push command line options to global arrays.
-sub push_to_global
-{
-	push_in_abs_any(\@dont_walk, \@skip_walk_dirs_abs, \@skip_walk_dirs_any);
-	push_in_abs_any(\@dont_parse, \@skip_parse_files_abs, \@skip_parse_files_any);
-}
-
 sub is_false_positive
 {
 	my ($match) = @_;
-- 
2.7.4
