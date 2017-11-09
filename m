From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  9 Nov 2017 16:09:33 +1100
Message-Id: <1510204175-10138-7-git-send-email-me@tobin.cc>
In-Reply-To: <1510204175-10138-1-git-send-email-me@tobin.cc>
References: <1510204175-10138-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH v2 6/8] scripts/leaking_addresses: add summary reporting
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script just dumps all results found. Potentially, this risks
losing single results among multiple duplicate results. We need some
way of restricting duplicates to assist users of the script. It would
also be nice if we got a report instead of raw results.

Duplicates can be defined in various ways, instead of trying to find a
single perfect solution we can present the user with various options to
display the output. Doing so will typically lead to users wanting to
view the output multiple times. Currently we scan the kernel each time,
this is slow and unnecessary. We can expedite the process by writing the
results to file for subsequent viewing.

Add command line options to enable summary reporting, including options
to write to and read from file.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 191 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 188 insertions(+), 3 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 0aac03a020a8..4610ad3c80c2 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -31,6 +31,13 @@ my @DIRS = ('/proc', '/sys');
 # Command line options.
 my $help = 0;
 my $debug = 0;
+my $raw = 0;
+my $output_raw = "";	# Write raw results to file.
+my $input_raw = "";	# Read raw results from file instead of scanning.
+
+my $suppress_dmesg = 0;		# Don't show dmesg in output.
+my $squash_by_path = 0;		# Summary report grouped by absolute path.
+my $squash_by_filename = 0;	# Summary report grouped by filename.
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -73,13 +80,31 @@ sub help
 	my ($exitcode) = @_;
 
 	print << "EOM";
+
 Usage: $P [OPTIONS]
 Version: $V
 
 Options:
 
-	-d, --debug                Display debugging output.
-	-h, --help, --version      Display this help and exit.
+	-o, --output-raw=<file>  Save results for future processing.
+	-i, --input-raw=<file>   Read results from file instead of scanning.
+	    --raw                Show raw results (default).
+	    --suppress-dmesg     Do not show dmesg results.
+	    --squash-by-path     Show one result per unique path.
+	    --squash-by-filename Show one result per unique filename.
+	-d, --debug              Display debugging output.
+	-h, --help, --version    Display this help and exit.
+
+Examples:
+
+	# Scan kernel and dump raw results.
+	$0
+
+	# Scan kernel and save results to file.
+	$0 --output-raw scan.out
+
+	# View summary report.
+	$0 --input-raw scan.out --squash-by-filename
 
 Scans the running (64 bit) kernel for potential leaking addresses.
 
@@ -90,11 +115,33 @@ EOM
 GetOptions(
 	'd|debug'		=> \$debug,
 	'h|help'		=> \$help,
-	'version'		=> \$help
+	'version'		=> \$help,
+	'o|output-raw=s'        => \$output_raw,
+	'i|input-raw=s'         => \$input_raw,
+	'suppress-dmesg'        => \$suppress_dmesg,
+	'squash-by-path'        => \$squash_by_path,
+	'squash-by-filename'    => \$squash_by_filename,
+	'raw'                   => \$raw,
 ) or help(1);
 
 help(0) if ($help);
 
+if ($input_raw) {
+	format_output($input_raw);
+	exit(0);
+}
+
+if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
+	printf "\nSummary reporting only available with --input-raw=<file>\n";
+	printf "(First run scan with --output-raw=<file>.)\n";
+	exit(128);
+}
+
+if ($output_raw) {
+	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
+	select $fh;
+}
+
 parse_dmesg();
 walk(@DIRS);
 
@@ -239,3 +286,141 @@ sub walk
 		}
 	}
 }
+
+sub format_output
+{
+	my ($file) = @_;
+
+	# Default is to show raw results.
+	if ($raw or (!$squash_by_path and !$squash_by_filename)) {
+		dump_raw_output($file);
+		return;
+	}
+
+	my ($total, $dmesg, $paths, $files) = parse_raw_file($file);
+
+	printf "\nTotal number of results from scan (incl dmesg): %d\n", $total;
+
+	if (!$suppress_dmesg) {
+		print_dmesg($dmesg);
+	}
+
+	if ($squash_by_filename) {
+		squash_by($files, 'filename');
+	}
+
+	if ($squash_by_path) {
+		squash_by($paths, 'path');
+	}
+}
+
+sub dump_raw_output
+{
+	my ($file) = @_;
+
+	open (my $fh, '<', $file) or die "$0: $file: $!\n";
+	while (<$fh>) {
+		if ($suppress_dmesg) {
+			if ("dmesg:" eq substr($_, 0, 6)) {
+				next;
+			}
+		}
+		print $_;
+	}
+	close $fh;
+}
+
+sub parse_raw_file
+{
+	my ($file) = @_;
+
+	my $total = 0;          # Total number of lines parsed.
+	my @dmesg;              # dmesg output.
+	my %files;              # Unique filenames containing leaks.
+	my %paths;              # Unique paths containing leaks.
+
+	open (my $fh, '<', $file) or die "$0: $file: $!\n";
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
