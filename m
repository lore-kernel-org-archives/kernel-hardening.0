Message-ID: <1511752336.31585.2.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Mon, 27 Nov 2017 08:42:16 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2] scripts: leaking_addresses: add support for 32-bit
 kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Currently, leaking_addresses.pl only supports scanning and displaying 'leaked'
64-bit kernel virtual addresses. We can scan for and display 'leaked' 32-bit
kernel virtual addresses as well.

Briefly, the way it works: once it detects we're running on an i'x'86 platform,
(where x=3|4|5|6), it takes this arch into account for checking. The essential
rationale:
 if 32-bit-virt-addr >= PAGE_OFFSET => it's a kernel virtual address.

This version programatically queries and sets PAGE_OFFSET based on it's value
in one of these files: /boot/config, /boot/config-$(uname -r) and
/proc/config.gz. If, for any reason, none of these files can be used, we
fallback to requesting the user to pass PAGE_OFFSET as an option switch.

Feedback welcome..


Kaiwan N Billimoria (1):
  scripts: leaking_addresses: add support for 32-bit kernel addresses

 scripts/leaking_addresses.pl | 150 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 132 insertions(+), 18 deletions(-)

Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
---
diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 2d5336b3e1ea..fccd0a5094f1 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -5,7 +5,7 @@
 
 # Licensed under the terms of the GNU GPL License version 2
 #
-# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
+# leaking_addresses.pl: Scan the kernel for potential leaking addresses.
 #  - Scans dmesg output.
 #  - Walks directory tree and parses each file (for each directory in @DIRS).
 #
@@ -14,7 +14,7 @@
 #
 # You may like to set kptr_restrict=2 before running script
 # (see Documentation/sysctl/kernel.txt).
-
+#
 use warnings;
 use strict;
 use POSIX;
@@ -37,7 +37,7 @@ my $TIMEOUT = 10;
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'i[3456]86');
 
 # Command line options.
 my $help = 0;
@@ -49,6 +49,9 @@ my $input_raw = "";	# Read raw results from file instead of scanning.
 my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
+my $page_offset_32bit = 0;      # 32-bit: value of CONFIG_PAGE_OFFSET
+
+my @kernel_config_files = ('/boot/config', '/boot/config-'.`uname -r`, '/proc/config.gz');
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -97,14 +100,15 @@ Version: $V
 
 Options:
 
-	-o, --output-raw=<file>  Save results for future processing.
-	-i, --input-raw=<file>   Read results from file instead of scanning.
-	    --raw                Show raw results (default).
-	    --suppress-dmesg     Do not show dmesg results.
-	    --squash-by-path     Show one result per unique path.
-	    --squash-by-filename Show one result per unique filename.
-	-d, --debug              Display debugging output.
-	-h, --help, --version    Display this help and exit.
+	-o, --output-raw=<file>    Save results for future processing.
+	-i, --input-raw=<file>     Read results from file instead of scanning.
+	      --raw                    Show raw results (default).
+	      --suppress-dmesg         Do not show dmesg results.
+	      --squash-by-path         Show one result per unique path.
+	      --squash-by-filename     Show one result per unique filename.
+	--page-offset-32bit=<hex>  PAGE_OFFSET value (for 32-bit kernels).
+	-d, --debug                Display debugging output.
+	-h, --help, --version      Display this help and exit.
 
 Examples:
 
@@ -117,7 +121,11 @@ Examples:
 	# View summary report.
 	$0 --input-raw scan.out --squash-by-filename
 
-Scans the running (64 bit) kernel for potential leaking addresses.
+	# (On a 32-bit system with a 2GB:2GB VMSPLIT), pass PAGE_OFFSET value
+	# as an option switch.
+	$0 --page-offset-32bit=0x80000000
+
+Scans the running kernel for potential leaking addresses.
 
 EOM
 	exit($exitcode);
@@ -133,10 +141,16 @@ GetOptions(
 	'squash-by-path'        => \$squash_by_path,
 	'squash-by-filename'    => \$squash_by_filename,
 	'raw'                   => \$raw,
+	'page-offset-32bit=o'   => \$page_offset_32bit,
 ) or help(1);
 
 help(0) if ($help);
 
+sub dprint
+{
+	printf(STDERR @_) if $debug;
+}
+
 if ($input_raw) {
 	format_output($input_raw);
 	exit(0);
@@ -162,6 +176,20 @@ if (!is_supported_architecture()) {
 	exit(129);
 }
 
+if ($debug) {
+	printf "Detected arch : ";
+	if (is_ix86_32()) {
+		printf "32 bit x86\n";
+	} else {
+		printf "64 bit\n";
+	}
+}
+
+if (is_ix86_32()) {
+	$page_offset_32bit = get_page_offset();
+	dprint "PAGE_OFFSET = 0x%X\n", $page_offset_32bit;
+}
+
 if ($output_raw) {
 	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
 	select $fh;
@@ -172,14 +200,9 @@ walk(@DIRS);
 
 exit 0;
 
-sub dprint
-{
-	printf(STDERR @_) if $debug;
-}
-
 sub is_supported_architecture
 {
-	return (is_x86_64() or is_ppc64());
+	return (is_x86_64() or is_ppc64() or is_ix86_32());
 }
 
 sub is_x86_64
@@ -202,6 +225,17 @@ sub is_ppc64
 	return 0;
 }
 
+# 32-bit x86: is_i'x'86_32() ; where is [3 or 4 or 5 or 6]
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
 sub is_false_positive
 {
 	my ($match) = @_;
@@ -217,6 +251,14 @@ sub is_false_positive
 		    $match =~ '\bf{10}601000\b') {
 			return 1;
 		}
+	} elsif (is_ix86_32()) {
+		my $addr32 = eval hex($match);
+		if ($addr32 < $page_offset_32bit ) {
+			return 1;
+		}
+		if ($match =~ '\b(0x)?(f|F){8}\b') {
+			return 1;
+		}
 	}
 
 	return 0;
@@ -245,6 +287,8 @@ sub may_leak_address
 		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
 	} elsif (is_ppc64()) {
 		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	} elsif (is_ix86_32()) {
+		$address_re = '\b(0x)?[[:xdigit:]]{8}\b';
 	}
 
 	while (/($address_re)/g) {
@@ -501,3 +545,73 @@ sub add_to_cache
 	}
 	push @{$cache->{$key}}, $value;
 }
+
+sub parse_kernel_config
+{
+	my ($file, $config) = @_;
+	my $str;
+	my $val = NULL;
+	my $gzipfile = 0;
+
+	# Explicitly check for '/proc/config.gz'
+	if ($file eq "/proc/config.gz") {
+		$gzipfile = 1;
+		if (! -R $file) {
+			dprint "parse_kernel_config: /proc/config.gz does not exist\n";
+			return NULL;
+		}
+		if (system("gunzip < /proc/config.gz > /tmp/tmpkconf")) {
+			dprint " parse_kernel_config: system(gunzip...) failed\n";
+			return NULL;
+		}
+		$file = "/tmp/tmpkconf";
+		$file =~ s/\R*//g;
+	}
+
+	dprint "32-bit: attempting to parse file \"$file\" for config \"$config\" ...\n";
+	if (! -R $file) {
+		dprint " parse_kernel_config: file does not exist or not readable\n";
+		return NULL;
+	}
+
+	open my $fh, "<", $file or return;
+	while (my $line = <$fh> ) {
+		if ($line =~ /^$config/) {
+			($str,$val) = split /=/, $line;
+		}
+	}
+	close $fh;
+	if ($gzipfile == 1) {
+		system("rm -f /tmp/tmpkconf");
+	}
+
+	if ($val eq NULL) {
+		return NULL;
+	}
+	$val =~ s/\R*//g;
+	return $val;
+}
+
+sub get_page_offset
+{
+	my $page_offset = $page_offset_32bit;
+
+	# If option --page-offset-32bit has been passed, just use it, else
+	# parse PAGE_OFFSET by iterating over an array of kernel config files.
+	if ($page_offset == 0) {
+		foreach my $kconfig_file (@kernel_config_files) {
+			$kconfig_file =~ s/\R*//g;
+			$page_offset = eval parse_kernel_config($kconfig_file, "CONFIG_PAGE_OFFSET");
+			if ($page_offset != 0) {
+				last;
+			}
+		}
+		if ($page_offset == 0) {
+			printf STDERR "$P: Fatal Error :: couldn't parse CONFIG_PAGE_OFFSET, aborting...\n";
+			printf STDERR "You can pass it via the option switch --page-offset-32bit=<value>\n";
+			exit(1);
+		}
+	}
+	return $page_offset;
+}
+
-- 
2.14.3
