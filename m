From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:35 +1100
Message-Id: <1510204175-10138-9-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 8/8] scripts/leaking_addresses: add timeout on file read
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script can stall if we read certain files (like
/proc/kmsg). While we have a mechanism to skip these files once they are
discovered it would be nice to not stall on as yet undiscovered files of
this kind.

Set a timer before each file is parsed, warn user if timer expires.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 1d6ab7f1b10c..6efd1fdb7d25 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -29,6 +29,9 @@ my $V = '0.01';
 # Directories to scan.
 my @DIRS = ('/proc', '/sys');
 
+# Timer for parsing each file, in seconds.
+my $TIMEOUT = 10;
+
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
@@ -284,6 +287,23 @@ sub skip_parse
 	return skip($path, \@skip_parse_files_abs, \@skip_parse_files_any);
 }
 
+sub timed_parse_file
+{
+	my ($file) = @_;
+
+	eval {
+		local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required.
+		alarm $TIMEOUT;
+		parse_file($file);
+		alarm 0;
+	};
+
+	if ($@) {
+		die unless $@ eq "alarm\n";	# Propagate unexpected errors.
+		printf STDERR "timed out parsing: %s\n", $file;
+	}
+}
+
 sub parse_file
 {
 	my ($file) = @_;
@@ -335,7 +355,7 @@ sub walk
 			if (-d $path) {
 				push @dirs, $path;
 			} else {
-				parse_file($path);
+				timed_parse_file($path);
 			}
 		}
 	}
-- 
2.7.4
