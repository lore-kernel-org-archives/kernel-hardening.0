Message-ID: <1515068485.3034.5.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Thu, 04 Jan 2018 17:51:25 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5] leaking_addresses: add generic 32-bit support
To: me@tobin.cc
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The script now attempts to detect the architecture it's running upon; as of now,
we explicitly support x86_64, PPC64, ARM64, MIPS64 and x86_32.

If it's one of them, we proceed "normally". If we fail to detect the arch,
we fallback to 64-bit scanning, _unless_ the user has passed either of these
option switches: "--opt-32bit" and/or "--page-offset-32bit=<val>".

If so, we switch to scanning for leaked addresses based on the value of
PAGE_OFFSET (via an auto-detected or fallback mechanism).

Currently, code (or "rules") to detect special cases for x86_64, PPC64 and Aarch64
(in the get_address_re sub) is present. Also, we now have also builtin "stubs",
for lack of a better term, where additional rules for other 64-bit arch's can be
plugged into the code, in future, as applicable.

This patch adds support for ix86 and generic 32 bit architectures.
 - Add command line option for generic 32-bit checking.
 - Add command line option for page offset.
 - Add command line option for kernel configuration file.
 - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).
 - Use page offset when checking for kernel virtual addresses.

The script has been lightly tested on the following systems:
 x86_64
 x86_32 (on a i686 running Debian 7 to be precise)
 ARM32  (on a Yocto-based qemuarm32 ARM Versatile platform (ARM926EJ-S cpu))

In the first two cases, one just has to run the script - no parameters required.
In the ARM-32 case, it will, by design, fail to detect the architecture;
(re)running it with the '--32-bit' and/or the '--page-offset-32bit=<hexval>'
option switch(es) has the desired effect: it now detects 32-bit leaking kernel
addresses, if any.

Request more testing on the above and other platforms.


Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>

---
 scripts/leaking_addresses.pl | 190 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 156 insertions(+), 34 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index a29e13e577a7..b0807b3a3c7c 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -1,10 +1,10 @@
 #!/usr/bin/env perl
 #
 # (c) 2017 Tobin C. Harding <me@tobin.cc>
-
+# (c) 2017 Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
 # Licensed under the terms of the GNU GPL License version 2
 #
-# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
+# leaking_addresses.pl: Scan kernel for potential leaking addresses.
 #  - Scans dmesg output.
 #  - Walks directory tree and parses each file (for each directory in @DIRS).
 #
@@ -32,11 +32,6 @@ my @DIRS = ('/proc', '/sys');
 # Timer for parsing each file, in seconds.
 my $TIMEOUT = 10;
 
-# Script can only grep for kernel addresses on the following architectures. If
-# your architecture is not listed here and has a grep'able kernel address please
-# consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
-
 # Command line options.
 my $help = 0;
 my $debug = 0;
@@ -48,7 +43,9 @@ my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
 
-my $kernel_config_file = "";	# Kernel configuration file.
+my $opt_32_bit = 0;            # Detect (only) 32-bit kernel leaking addresses.
+my $page_offset_32bit = 0;     # 32-bit: value of CONFIG_PAGE_OFFSET.
+my $kernel_config_file = "";   # Kernel configuration file.
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -104,10 +101,12 @@ Options:
 	      --squash-by-path		Show one result per unique path.
 	      --squash-by-filename	Show one result per unique filename.
 	--kernel-config-file=<file>     Kernel configuration file (e.g /boot/config)
+	--opt-32bit			Detect (only) 32-bit kernel leaking addresses.
+	--page-offset-32bit=<hex>	PAGE_OFFSET value (for 32-bit kernels).
 	-d, --debug			Display debugging output.
-	-h, --help, --versionq		Display this help and exit.
+	-h, --help, --version		Display this help and exit.
 
-Scans the running (64 bit) kernel for potential leaking addresses.
+Scans the running kernel for potential leaking addresses.
 
 EOM
 	exit($exitcode);
@@ -123,7 +122,9 @@ GetOptions(
 	'squash-by-path'        => \$squash_by_path,
 	'squash-by-filename'    => \$squash_by_filename,
 	'raw'                   => \$raw,
-	'kernel-config-file=s'	=> \$kernel_config_file,
+	'opt-32bit'             => \$opt_32_bit,
+	'page-offset-32bit=o'   => \$page_offset_32bit,
+	'kernel-config-file=s'  => \$kernel_config_file,
 ) or help(1);
 
 help(0) if ($help);
@@ -139,16 +140,15 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
 	exit(128);
 }
 
-if (!is_supported_architecture()) {
-	printf "\nScript does not support your architecture, sorry.\n";
-	printf "\nCurrently we support: \n\n";
-	foreach(@SUPPORTED_ARCHITECTURES) {
-		printf "\t%s\n", $_;
-	}
+show_detected_architecture() if $debug;
 
-	my $archname = $Config{archname};
-	printf "\n\$ perl -MConfig -e \'print \"\$Config{archname}\\n\"\'\n";
-	printf "%s\n", $archname;
+if (!is_known_architecture()) {
+	printf STDERR "\nFATAL: Script does not recognize your architecture\n";
+
+	my $arch = `uname -m`;
+	chomp $arch;
+	printf "\n\$ uname -m\n";
+	printf "%s\n", $arch;
 
 	exit(129);
 }
@@ -168,21 +168,45 @@ sub dprint
 	printf(STDERR @_) if $debug;
 }
 
-sub is_supported_architecture
+sub is_known_architecture
 {
-	return (is_x86_64() or is_ppc64());
+	return (is_64bit() or is_32bit());
 }
 
-sub is_x86_64
+sub is_32bit
 {
-	my $archname = $Config{archname};
+	# 32-bit actual case
+	if (is_ix86_32()) {
+		return 1;
+	}
 
-	if ($archname =~ m/x86_64/) {
+	# 32-bit "forced" case (for any arch other than IA-32)
+	if ($opt_32_bit or $page_offset_32bit) {
 		return 1;
 	}
 	return 0;
 }
 
+sub is_64bit
+{
+	return (is_x86_64() or is_ppc64() or is_arm64() or is_mips64());
+}
+
+sub is_x86_64
+{
+	is_arch("x86_64");
+}
+
+sub is_arm64
+{
+	is_arch("aarch64");
+}
+
+sub is_mips64
+{
+	is_arch("mips64");
+}
+
 sub is_ppc64
 {
 	my $archname = $Config{archname};
@@ -193,6 +217,47 @@ sub is_ppc64
 	return 0;
 }
 
+sub is_ix86_32
+{
+	my $arch = `uname -m`;
+
+	chomp $arch;
+	if ($arch =~ m/i[3456]86/) {
+		return 1;
+	}
+	return 0;
+}
+
+sub is_arch
+{
+	my ($desc) = @_;
+	my $arch = `uname -m`;
+
+	chomp $arch;
+	if ($arch eq $desc) {
+		return 1;
+	}
+	return 0;
+}
+
+sub show_detected_architecture
+{
+	printf "Detected architecture: ";
+	if (is_32bit()) {
+		printf "32 bit\n";
+	} elsif (is_x86_64()) {
+		printf "x86_64\n";
+	} elsif (is_ppc64()) {
+		printf "PPC64\n";
+	} elsif (is_arm64()) {
+		printf "ARM64\n";
+	} elsif (is_mips64()) {
+		printf "MIPS64\n";
+	} else {
+		printf "failed to detect architecture\n"
+	}
+}
+
 # gets config option value from kernel config file
 sub get_kernel_config_option
 {
@@ -212,7 +277,6 @@ sub get_kernel_config_option
 		} else {
 			@config_files = ($tmp_file);
 		}
-
 	} else {
 		my $file = '/boot/config-' . `uname -r`;
 		chomp $file;
@@ -220,7 +284,6 @@ sub get_kernel_config_option
 	}
 
 	foreach my $file (@config_files) {
-		dprint("parsing config file: %s\n", $file);
 		$value = option_from_file($option, $file);
 		if ($value ne "") {
 			last;
@@ -258,6 +321,14 @@ sub is_false_positive
 {
 	my ($match) = @_;
 
+	# 32 bit architectures, actual or forced
+
+	if (is_32bit()) {
+		return is_false_positive_32bit($match);
+	}
+
+	# 64 bit architectures
+
 	if ($match =~ '\b(0x)?(f|F){16}\b' or
 	    $match =~ '\b(0x)?0{16}\b') {
 		return 1;
@@ -281,6 +352,58 @@ sub is_in_vsyscall_memory_region
 	return ($hex >= $region_min and $hex <= $region_max);
 }
 
+sub is_false_positive_32bit
+{
+	my ($match) = @_;
+	state $page_offset = get_page_offset(); # only gets called once
+
+	if ($match =~ '\b(0x)?(f|F){8}\b') {
+		return 1;
+	}
+
+	my $addr32 = hex($match);
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
+	my $default_offset = hex("0xc0000000");
+	my @config_files;
+
+	# Allow --page-offset-32bit to override.
+	if ($page_offset_32bit != 0) {
+		return $page_offset_32bit;
+	}
+
+	$page_offset = get_kernel_config_option('CONFIG_PAGE_OFFSET');
+	return $default_offset;
+}
+
+sub parse_kernel_config_file
+{
+	my ($file) = @_;
+	my $config = 'CONFIG_PAGE_OFFSET';
+	my $str = "";
+	my $val = "";
+
+	open(my $fh, "<", $file) or return "";
+	while (my $line = <$fh> ) {
+		if ($line =~ /^$config/) {
+			($str, $val) = split /=/, $line;
+			chomp($val);
+			last;
+		}
+	}
+
+	close $fh;
+	return $val;
+}
+
 # True if argument potentially contains a kernel address.
 sub may_leak_address
 {
@@ -300,8 +423,6 @@ sub may_leak_address
 	}
 
 	$address_re = get_address_re();
-	dprint("Kernel address regular expression: %s\n", $address_re);
-
 	while (/($address_re)/g) {
 		if (!is_false_positive($1)) {
 			return 1;
@@ -313,16 +434,17 @@ sub may_leak_address
 
 sub get_address_re
 {
-	my $re;
+	my $re = "";
 
 	if (is_x86_64()) {
 		$re = get_x86_64_re();
 	} elsif (is_ppc64()) {
 		$re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
-	}
-
-	if ($re eq "") {
-		print STDERR "$0: failed to build kernel address regular expression\n";
+	###
+	# Any special cases for other arch's go below this line
+	###
+	} else {  # nothing? then we assume it's a generic 32-bit
+		$re = '\b(0x)?[[:xdigit:]]{8}\b';
 	}
 
 	return $re;
-- 
2.14.3
