From: "Tobin C. Harding" <me@tobin.cc>
Date: Wed,  8 Nov 2017 14:37:36 +1100
Message-Id: <1510112259-11572-5-git-send-email-me@tobin.cc>
In-Reply-To: <1510112259-11572-1-git-send-email-me@tobin.cc>
References: <1510112259-11572-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 4/7] scripts/leaking_addresses: add reporting
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently script just dumps all results found. Potentially, this risks
loosing single results among multiple duplicate results. We need some
way of restricting duplicates to assist users of the script. It would
also be nice if we got a report instead of raw results.

Duplicates can be defined in various ways, instead of trying to find a
single perfect solution we can present the user with various options to
display the output. Doing so will typically lead to users wanting to
view the output multiple times. Currently we scan the kernel each time,
this is slow and unnecessary. We can expedite the process by writing the
results to file for subsequent viewing.

Add sub-commands `scan` and `format`. Display output as a report instead
of raw results. Add --raw flag to view raw results. Save results to
file. For subsequent calls to `format` parse output file instead of
re-scanning.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 201 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 187 insertions(+), 14 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 719ed0aaede7..4c31e935319b 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -21,14 +21,19 @@ use File::Spec;
 use Cwd 'abs_path';
 use Term::ANSIColor qw(:constants);
 use Getopt::Long qw(:config no_auto_abbrev);
+use File::Spec::Functions 'catfile';
 
 my $P = $0;
 my $V = '0.01';
 
-# Directories to scan.
+# Directories to scan (we scan `dmesg` also).
 my @DIRS = ('/proc', '/sys');
 
 # Command line options.
+my $output = "scan.out";
+my $suppress_dmesg = 0;
+my $squash_by_path = 0;
+my $raw = 0;
 my $help = 0;
 my $debug = 0;
 
@@ -70,21 +75,34 @@ sub help
 	my ($exitcode) = @_;
 
 	print << "EOM";
-Usage: $P [OPTIONS]
+
+Usage: $P COMMAND [OPTIONS]
 Version: $V
 
+Commands:
+
+	scan	Scan the kernel (savesg raw results to file and runs `format`).
+	format	Parse results file and format output.
+
 Options:
 
-	-d, --debug                Display debugging output.
-	-h, --help, --version      Display this help and exit.
+	-o, --output=<file>	 Raw results output file, used for later formatting.
+	    --suppress-dmesg	 Do not show dmesg results.
+	    --squash-by-path	 Show one result per unique path.
+	    --raw	 	 Show raw results.
+	-d, --debug              Display debugging output.
+	-h, --help, --version    Display this help and exit.
 
 Scans the running (64 bit) kernel for potential leaking addresses.
-
 EOM
 	exit($exitcode);
 }
 
 GetOptions(
+	'o|output=s'		=> \$output,
+	'suppress-dmesg'	=> \$suppress_dmesg,
+	'squash-by-path'	=> \$squash_by_path,
+	'raw'			=> \$raw,
 	'd|debug'		=> \$debug,
 	'h|help'		=> \$help,
 	'version'		=> \$help
@@ -92,8 +110,21 @@ GetOptions(
 
 help(0) if ($help);
 
-parse_dmesg();
-walk(@DIRS);
+my ($command) = @ARGV;
+if (not defined $command) {
+	help(128);
+}
+
+if ($command ne 'scan' and $command ne 'format') {
+	printf "\nUnknown command: %s\n\n", $command;
+	help(128);
+}
+
+if ($command eq 'scan') {
+	scan();
+}
+
+format_output();
 
 exit 0;
 
@@ -102,6 +133,17 @@ sub dprint
 	printf(STDERR @_) if $debug;
 }
 
+sub scan
+{
+	open (my $fh, '>', "$output") or die "$0: $output: $!\n";
+	select $fh;
+
+	parse_dmesg();
+	walk(@DIRS);
+
+	select STDOUT;
+}
+
 sub is_false_positive
 {
 	my ($match) = @_;
@@ -120,30 +162,39 @@ sub is_false_positive
 	return 0;
 }
 
-# True if argument potentially contains a kernel address.
 sub may_leak_address
 {
 	my ($line) = @_;
+
+	my @addresses = extract_addresses($line);
+	return @addresses > 0;
+}
+
+# Return _all_ non false positive addresses from $line.
+sub extract_addresses
+{
+	my ($line) = @_;
 	my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+	my (@addresses, @empty);
 
 	# Signal masks.
 	if ($line =~ '^SigBlk:' or
 	    $line =~ '^SigCgt:') {
-		return 0;
+		return @empty;
 	}
 
 	if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
 	    $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
-		return 0;
+		return @empty;
 	}
 
-	while (/($address)/g) {
+	while ($line =~ /($address)/g) {
 		if (!is_false_positive($1)) {
-			return 1;
+			push @addresses, $1;
 		}
 	}
 
-	return 0;
+	return @addresses;
 }
 
 sub parse_dmesg
@@ -203,7 +254,6 @@ sub parse_file
 	close $fh;
 }
 
-
 # True if we should skip walking this directory.
 sub skip_walk
 {
@@ -236,3 +286,126 @@ sub walk
 		}
 	}
 }
+
+sub format_output
+{
+	if ($raw) {
+		dump_raw_output();
+		return;
+	}
+
+	my ($total, $dmesg, $paths, $files) = parse_raw_file();
+
+	printf "\nTotal number of results from scan (incl dmesg): %d\n", $total;
+
+	if (!$suppress_dmesg) {
+		print_dmesg($dmesg);
+	}
+	squash_by($files, 'filename');
+
+	if ($squash_by_path) {
+		squash_by($paths, 'path');
+	}
+}
+
+sub dump_raw_output
+{
+	open (my $fh, '<', $output) or die "$0: $output: $!\n";
+	while (<$fh>) {
+		print $_;
+	}
+	close $fh;
+}
+
+sub print_dmesg
+{
+	my ($dmesg) = @_;
+
+	print "\ndmesg output:\n";
+
+	if (@$dmesg == 0) {
+		print "<no results>\n";
+		return;
+	}
+
+	foreach(@$dmesg) {
+		my $index = index($_, ': ');
+		$index += 2;    # skid ': '
+		print substr($_, $index);
+	}
+}
+
+sub squash_by
+{
+	my ($ref, $desc) = @_;
+
+	print "\nResults squashed by $desc (excl dmesg). ";
+	print "Displaying [<number of results> <$desc>], <example result>\n";
+
+	if (keys %$ref == 0) {
+		print "<no results>\n";
+		return;
+	}
+
+	foreach(keys %$ref) {
+		my $lines = $ref->{$_};
+		my $length = @$lines;
+		printf "[%d %s] %s", $length, $_, @$lines[0];
+	}
+}
+
+sub parse_raw_file
+{
+	my $total = 0;          # Total number of lines parsed.
+	my @dmesg;              # dmesg output.
+	my %files;              # Unique filenames containing leaks.
+	my %paths;              # Unique paths containing leaks.
+
+	open (my $fh, '<', $output) or die "$0: $output: $!\n";
+	while (my $line = <$fh>) {
+		$total++;
+
+		if ("dmesg:" eq substr($line, 0, 6)) {
+			push @dmesg, $line;
+			next;
+		}
+
+		cache_path(\%paths, $line);
+		cache_filename(\%files, $line);
+	}
+
+	return $total, \@dmesg, \%paths, \%files;
+}
+
+sub cache_path
+{
+	my ($paths, $line) = @_;
+
+	my $index = index($line, ': ');
+	my $path = substr($line, 0, $index);
+
+	$index += 2;            # skip ': '
+	add_to_cache($paths, $path, substr($line, $index));
+}
+
+sub cache_filename
+{
+	my ($files, $line) = @_;
+
+	my $index = index($line, ': ');
+	my $path = substr($line, 0, $index);
+	my $filename = basename($path);
+
+	$index += 2;            # skip ': '
+	add_to_cache($files, $filename, substr($line, $index));
+}
+
+sub add_to_cache
+{
+	my ($cache, $key, $value) = @_;
+
+	if (!$cache->{$key}) {
+		$cache->{$key} = ();
+	}
+	push @{$cache->{$key}}, $value;
+}
-- 
2.7.4
