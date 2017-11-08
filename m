From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:37 +1100
Message-Id: <1510112259-11572-6-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 5/7] scripts/leaking_addresses: add emailing results
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Developers may not have the time (or inclination) to investigate script
output. This information is, however, useful. If we add functionality to
the script to email results for further investigation.

Add --send-report flag to email scan results (to Tobin C. Harding).

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 mode change 100755 => 100644 scripts/leaking_addresses.pl

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
old mode 100755
new mode 100644
index 4c31e935319b..e43105662306
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -34,6 +34,7 @@ my $output = "scan.out";
 my $suppress_dmesg = 0;
 my $squash_by_path = 0;
 my $raw = 0;
+my $send_report = 0;
 my $help = 0;
 my $debug = 0;
 
@@ -90,6 +91,7 @@ Options:
 	    --suppress-dmesg	 Do not show dmesg results.
 	    --squash-by-path	 Show one result per unique path.
 	    --raw	 	 Show raw results.
+	    --send-report	 Submit raw results for someone else to worry about.
 	-d, --debug              Display debugging output.
 	-h, --help, --version    Display this help and exit.
 
@@ -103,6 +105,7 @@ GetOptions(
 	'suppress-dmesg'	=> \$suppress_dmesg,
 	'squash-by-path'	=> \$squash_by_path,
 	'raw'			=> \$raw,
+	'send-report'		=> \$send_report,
 	'd|debug'		=> \$debug,
 	'h|help'		=> \$help,
 	'version'		=> \$help
@@ -124,6 +127,12 @@ if ($command eq 'scan') {
 	scan();
 }
 
+if ($send_report) {
+	send_report();
+	print "Raw scan results sent, thank you.\n";
+	exit(0);
+}
+
 format_output();
 
 exit 0;
@@ -144,6 +153,39 @@ sub scan
 	select STDOUT;
 }
 
+sub send_report
+{
+	my $subject = 'LEAK REPORT';
+	my $email = 'leaks@tobin.cc';
+
+	my $message = sprintf("kptr_restrict: %s\n", get_kptr_restrict());
+
+	# Slurp raw results.
+	$message .= do {
+		local $/ = undef;
+		open my $fh, "<", $output
+		    or die "could not open $output: $!";
+		<$fh>;
+	};
+
+	open my $mailh, '|-', "mail -s '$subject' $email"
+	    or die( "Could not open pipe! $!" );
+
+	print $mailh $message;
+	close $mailh;
+}
+
+sub get_kptr_restrict
+{
+	my $filename = "/proc/sys/kernel/kptr_restrict";
+	my @array = do {
+		open my $fh, "<", $filename
+		    or die "could not open $filename: $!";
+		<$fh>;
+	};
+	return $array[0];
+}
+
 sub is_false_positive
 {
 	my ($match) = @_;
-- 
2.7.4
