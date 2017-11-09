From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:34 +1100
Message-Id: <1510204175-10138-8-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 7/8] scripts/leaking_addresses: add support for ppc64
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script is targeted at x86_64. We can support other
architectures by using the correct regular expressions for each
architecture.

Add the infrastructure to support multiple architectures. Add support
for ppc64.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 66 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 60 insertions(+), 6 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 4610ad3c80c2..1d6ab7f1b10c 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -21,6 +21,7 @@ use File::Spec;
 use Cwd 'abs_path';
 use Term::ANSIColor qw(:constants);
 use Getopt::Long qw(:config no_auto_abbrev);
+use Config;
 
 my $P = $0;
 my $V = '0.01';
@@ -28,6 +29,11 @@ my $V = '0.01';
 # Directories to scan.
 my @DIRS = ('/proc', '/sys');
 
+# Script can only grep for kernel addresses on the following architectures. If
+# your architecture is not listed here and has a grep'able kernel address please
+# consider submitting a patch.
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+
 # Command line options.
 my $help = 0;
 my $debug = 0;
@@ -137,6 +143,20 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
 	exit(128);
 }
 
+if (!is_supported_architecture()) {
+	printf "\nScript does not support your architecture, sorry.\n";
+	printf "\nCurrently we support: \n\n";
+	foreach(@SUPPORTED_ARCHITECTURES) {
+		printf "\t%s\n", $_;
+	}
+
+	my $archname = $Config{archname};
+	printf "\n\$ perl -MConfig -e \'print \"\$Config{archname}\\n\"\'\n";
+	printf "%s\n", $archname;
+
+	exit(129);
+}
+
 if ($output_raw) {
 	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
 	select $fh;
@@ -152,6 +172,31 @@ sub dprint
 	printf(STDERR @_) if $debug;
 }
 
+sub is_supported_architecture
+{
+	return (is_x86_64() or is_ppc64());
+}
+
+sub is_x86_64
+{
+	my $archname = $Config{archname};
+
+	if ($archname =~ m/x86_64/) {
+		return 1;
+	}
+	return 0;
+}
+
+sub is_ppc64
+{
+	my $archname = $Config{archname};
+
+	if ($archname =~ m/powerpc/ and $archname =~ m/64/) {
+		return 1;
+	}
+	return 0;
+}
+
 sub is_false_positive
 {
 	my ($match) = @_;
@@ -161,10 +206,12 @@ sub is_false_positive
 		return 1;
 	}
 
-
-	if ($match =~ '\bf{10}600000\b' or# vsyscall memory region, we should probably check against a range here.
-	    $match =~ '\bf{10}601000\b') {
-		return 1;
+	if (is_x86_64) {
+		# vsyscall memory region, we should probably check against a range here.
+		if ($match =~ '\bf{10}600000\b' or
+		    $match =~ '\bf{10}601000\b') {
+			return 1;
+		}
 	}
 
 	return 0;
@@ -174,7 +221,7 @@ sub is_false_positive
 sub may_leak_address
 {
 	my ($line) = @_;
-	my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+	my $address_re;
 
 	# Signal masks.
 	if ($line =~ '^SigBlk:' or
@@ -187,7 +234,14 @@ sub may_leak_address
 		return 0;
 	}
 
-	while (/($address)/g) {
+	# One of these is guaranteed to be true.
+	if (is_x86_64()) {
+		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+	} elsif (is_ppc64()) {
+		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	}
+
+	while (/($address_re)/g) {
 		if (!is_false_positive($1)) {
 			return 1;
 		}
-- 
2.7.4
