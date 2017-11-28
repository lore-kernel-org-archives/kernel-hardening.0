From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 28 Nov 2017 17:32:04 +1100
Message-Id: <1511850724-2381-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: kaiwan.billimoria@gmail.com
Cc: "Tobin C. Harding" <me@tobin.cc>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently, leaking_addresses.pl only supports scanning 64 bit
architectures. This is due to how the regular expressions are formed. We
can do better than this. 32 architectures can be supported if we take
into consideration the kernel virtual address split.

Add support for ix86 32 bit architectures.
 - Add command line option for page offset.
 - Add command line option for kernel configuration file.
 - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).
 - Use page offset when checking for kernel virtual addresses.

Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

As discussed this is a patch based on Kaiwan's previous patch. This
patch represents co development by Kaiwan and Tobin.

Applies on top of commit 4fbd8d194f06 (Linux 4.15-rc1)

thanks,
Tobin.

 scripts/leaking_addresses.pl | 168 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 148 insertions(+), 20 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index bc5788000018..f03f2f140e0a 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -1,9 +1,11 @@
 #!/usr/bin/env perl
 #
 # (c) 2017 Tobin C. Harding <me@tobin.cc>
+# (c) 2017 Kaiwan N Billimoria <kaiwan.billimoria@gmail.com> (ix86 stuff)
+#
 # Licensed under the terms of the GNU GPL License version 2
 #
-# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
+# leaking_addresses.pl: Scan the kernel for potential leaking addresses.
 #  - Scans dmesg output.
 #  - Walks directory tree and parses each file (for each directory in @DIRS).
 #
@@ -22,6 +24,7 @@ use Cwd 'abs_path';
 use Term::ANSIColor qw(:constants);
 use Getopt::Long qw(:config no_auto_abbrev);
 use Config;
+use feature 'state';
 
 my $P = $0;
 my $V = '0.01';
@@ -35,18 +38,19 @@ my $TIMEOUT = 10;
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'i[3456]86');
 
 # Command line options.
 my $help = 0;
 my $debug = 0;
-my $raw = 0;
-my $output_raw = "";	# Write raw results to file.
-my $input_raw = "";	# Read raw results from file instead of scanning.
-
+my $raw = 0;			# Show raw output.
+my $output_raw = "";		# Write raw results to file.
+my $input_raw = "";		# Read raw results from file instead of scanning.
 my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
+my $page_offset_32bit = 0;	# 32-bit: value of CONFIG_PAGE_OFFSET
+my $kernel_config_file = "";	# Kernel configuration file.
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -95,14 +99,16 @@ Version: $V
 
 Options:
 
-	-o, --output-raw=<file>  Save results for future processing.
-	-i, --input-raw=<file>   Read results from file instead of scanning.
-	    --raw                Show raw results (default).
-	    --suppress-dmesg     Do not show dmesg results.
-	    --squash-by-path     Show one result per unique path.
-	    --squash-by-filename Show one result per unique filename.
-	-d, --debug              Display debugging output.
-	-h, --help, --version    Display this help and exit.
+	-o, --output-raw=<file>		Save results for future processing.
+	-i, --input-raw=<file>		Read results from file instead of scanning.
+	      --raw			  Show raw results (default).
+	      --suppress-dmesg            Do not show dmesg results.
+	      --squash-by-path            Show one result per unique path.
+	      --squash-by-filename        Show one result per unique filename.
+	    --page-offset-32bit=<hex>	PAGE_OFFSET value (for 32-bit kernels).
+	    --kernel-config-file=<file>	Kernel configuration file (e.g /boot/config)
+	-d, --debug			Display debugging output.
+	-h, --help, --version		Display this help and exit.
 
 Examples:
 
@@ -115,7 +121,10 @@ Examples:
 	# View summary report.
 	$0 --input-raw scan.out --squash-by-filename
 
-Scans the running (64 bit) kernel for potential leaking addresses.
+	# Scan kernel on a 32-bit system with a 2GB:2GB virtual address split.
+	$0 --page-offset-32bit=0x80000000
+
+Scans the running kernel for potential leaking addresses.
 
 EOM
 	exit($exitcode);
@@ -131,6 +140,8 @@ GetOptions(
 	'squash-by-path'        => \$squash_by_path,
 	'squash-by-filename'    => \$squash_by_filename,
 	'raw'                   => \$raw,
+	'page-offset-32bit=o'   => \$page_offset_32bit,
+	'kernel-config-file=s'  => \$kernel_config_file,
 ) or help(1);
 
 help(0) if ($help);
@@ -146,7 +157,9 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
 	exit(128);
 }
 
-if (!is_supported_architecture()) {
+if (is_supported_architecture()) {
+	show_detected_architecture() if $debug;
+} else {
 	printf "\nScript does not support your architecture, sorry.\n";
 	printf "\nCurrently we support: \n\n";
 	foreach(@SUPPORTED_ARCHITECTURES) {
@@ -177,7 +190,7 @@ sub dprint
 
 sub is_supported_architecture
 {
-	return (is_x86_64() or is_ppc64());
+	return (is_x86_64() or is_ppc64() or is_ix86_32());
 }
 
 sub is_x86_64
@@ -200,10 +213,40 @@ sub is_ppc64
 	return 0;
 }
 
+sub is_ix86_32
+{
+	my $archname = $Config{archname};
+
+	if ($archname =~ m/i[3456]86-linux/) {
+		return 1;
+	}
+	return 0;
+}
+
+sub show_detected_architecture
+{
+	printf "Detected architecture: ";
+	if (is_ix86_32()) {
+		printf "32 bit x86\n";
+	} elsif (is_x86_64()) {
+		printf "x86_64\n";
+	} elsif (is_ppc64()) {
+		printf "ppc64\n";
+	} else {
+		printf "failed to detect architecture\n"
+	}
+}
+
 sub is_false_positive
 {
 	my ($match) = @_;
 
+	if (is_ix86_32()) {
+		return is_false_positive_ix86_32($match);
+	}
+
+	# 64 bit architectures
+
 	if ($match =~ '\b(0x)?(f|F){16}\b' or
 	    $match =~ '\b(0x)?0{16}\b') {
 		return 1;
@@ -220,6 +263,87 @@ sub is_false_positive
 	return 0;
 }
 
+sub is_false_positive_ix86_32
+{
+	my ($match) = @_;
+	state $page_offset = get_page_offset(); # only gets called once
+
+	if ($match =~ '\b(0x)?(f|F){8}\b') {
+		return 1;
+	}
+
+	my $addr32 = eval hex($match);
+	if ($addr32 < $page_offset) {
+		return 1;
+	}
+
+	return 0;
+}
+
+sub get_page_offset
+{
+	my $page_offset;
+	my $default_offset = "0xc0000000";
+	my @config_files;
+
+	# Allow --page-offset-32bit to over ride.
+	if ($page_offset_32bit != 0) {
+		return $page_offset_32bit;
+	}
+
+	# Allow --kernel-config-file to over ride.
+	if ($kernel_config_file != "") {
+		@config_files = ($kernel_config_file);
+	} else {
+		my $config_file = '/boot/config-' . `uname -r`;
+		@config_files = ($config_file, '/boot/config');
+	}
+
+	if (-R "/proc/config.gz") {
+		my $tmp_file = "/tmp/tmpkconf";
+		if (system("gunzip < /proc/config.gz > $tmp_file")) {
+			dprint " parse_kernel_config: system(gunzip...) failed\n";
+		} else {
+			$page_offset = parse_kernel_config_file($tmp_file);
+			if ($page_offset ne "") {
+				return $page_offset;
+			}
+		}
+		system("rm -f $tmp_file");
+	}
+
+	foreach my $config_file (@config_files) {
+		$page_offset = parse_kernel_config($config_file);
+		if ($page_offset ne "") {
+			return $page_offset;
+		}
+	}
+
+	printf STDERR "Failed to parse kernel config files\n";
+	printf STDERR "Falling back to %s\n", $default_offset;
+	return $default_offset;
+}
+
+sub parse_kernel_config_file
+{
+	my ($file) = @_;
+	my $config = 'CONFIG_PAGE_OFFSET';
+	my $val = "";
+
+	open(my $fh, "<", $file) or return "";
+	while (my $line = <$fh> ) {
+		if ($line =~ /^$config/) {
+			my ($str, $val) = split /=/, $line;
+			chomp($val);
+			last;
+		}
+	}
+
+	close $fh;
+	return $val;
+}
+
+
 # True if argument potentially contains a kernel address.
 sub may_leak_address
 {
@@ -233,9 +357,11 @@ sub may_leak_address
 		return 0;
 	}
 
-	if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
-	    $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
-		return 0;
+	if (is_x86_64() or is_ppc64()) {
+		if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
+		    $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
+			return 0;
+		}
 	}
 
 	# One of these is guaranteed to be true.
@@ -243,6 +369,8 @@ sub may_leak_address
 		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
 	} elsif (is_ppc64()) {
 		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	} elsif (is_ix86_32()) {
+		$address_re = '\b(0x)?[[:xdigit:]]{8}\b';
 	}
 
 	while (/($address_re)/g) {
-- 
2.7.4
