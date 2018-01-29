From: "Tobin C. Harding" <me@tobin.cc>
Date: Mon, 29 Jan 2018 15:51:17 +1100
Message-Id: <1517201477-12326-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH] leaking_addresses: add 32-bit support
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently script only supports x86_64 and ppc64.  It would be nice to be
able to scan 32-bit machines also.  We can add support for
32-bit architectures by modifying how we check for false positives,
taking advantage of the page offset used by the kernel, and using the
correct regular expression.

Support for 32-bit machines is enabled by the observation the kernel
addresses on 32-bit machines are larger than the page offset.  We can
use this to filter false positives when scanning the kernel for leaking
addresses.

Programmatic determination of the running architecture is not
immediately obvious.  We therefore provide a flag to enable scanning of
32-bit kernels.  Also we can check the kernel config file for the offset
and if not found default to 0xc0000000.  A command line option to parse
in the page offset is also provided.  We do automatically detect
architecture if running on ix86.

Add support for 32-bit kernels.  Add a command line option for page
offset.

Suggested-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

The basis for this patch has been in development for a while by Kaiwan
but didn't get finished before the merge window opened.  I'd like to
fast track this and get it to Linus this merge window (considering
Spectre/Meltdown).  I have finished this work off and added the
Suggested-by tag.  Kaiwan I hope you are not upset by this, extra
ordinary circumstances seemed to require this action.

thanks,
Tobin.

 scripts/leaking_addresses.pl | 84 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 78 insertions(+), 6 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 64a3cfa1175b..c13eb53d1c5a 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -34,7 +34,7 @@ my $TIMEOUT = 10;
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'x86');
 
 # Command line options.
 my $help = 0;
@@ -46,6 +46,8 @@ my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
 my $kernel_config_file = "";	# Kernel configuration file.
+my $opt_32bit = 0;		# Scan 32-bit kernel.
+my $page_offset_32bit = 0;	# Page offset for 32-bit kernel.
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -103,6 +105,8 @@ Options:
 	      --squash-by-path		Show one result per unique path.
 	      --squash-by-filename	Show one result per unique filename.
 	--kernel-config-file=<file>     Kernel configuration file (e.g /boot/config)
+	--32-bit			Scan 32-bit kernel.
+	--page-offset-32-bit=o		Page offset (for 32-bit kernel 0xABCD1234).
 	-d, --debug			Display debugging output.
 	-h, --help, --versionq		Display this help and exit.
 
@@ -123,6 +127,8 @@ GetOptions(
 	'squash-by-filename'    => \$squash_by_filename,
 	'raw'                   => \$raw,
 	'kernel-config-file=s'	=> \$kernel_config_file,
+	'32-bit'		=> \$opt_32bit,
+	'page-offset-32-bit=o'	=> \$page_offset_32bit,
 ) or help(1);
 
 help(0) if ($help);
@@ -138,7 +144,7 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
 	exit(128);
 }
 
-if (!is_supported_architecture()) {
+if (!(is_supported_architecture() or $opt_32bit or $page_offset_32bit)) {
 	printf "\nScript does not support your architecture, sorry.\n";
 	printf "\nCurrently we support: \n\n";
 	foreach(@SUPPORTED_ARCHITECTURES) {
@@ -146,6 +152,9 @@ if (!is_supported_architecture()) {
 	}
 	printf("\n");
 
+	printf("If you are running a 32-bit architecture you may use:\n");
+	printf("\n\t--32-bit or --page-offset-32-bit=<page offset>\n\n");
+
 	my $archname = `uname -m`;
 	printf("Machine hardware name (`uname -m`): %s\n", $archname);
 
@@ -169,7 +178,28 @@ sub dprint
 
 sub is_supported_architecture
 {
-	return (is_x86_64() or is_ppc64());
+	return (is_x86_64() or is_ppc64() or is_ix86_32());
+}
+
+sub is_32bit
+{
+	# Allow --32-bit or --page-offset-32-bit to override
+	if ($opt_32bit or $page_offset_32bit) {
+		return 1;
+	}
+
+	return is_ix86_32();
+}
+
+sub is_ix86_32
+{
+       my $arch = `uname -m`;
+
+       chomp $arch;
+       if ($arch =~ m/i[3456]86/) {
+               return 1;
+       }
+       return 0;
 }
 
 sub is_arch
@@ -261,6 +291,12 @@ sub is_false_positive
 {
 	my ($match) = @_;
 
+	if (is_32bit()) {
+		return is_false_positive_32bit($match);
+	}
+
+	# 64 bit false positives.
+
 	if ($match =~ '\b(0x)?(f|F){16}\b' or
 	    $match =~ '\b(0x)?0{16}\b') {
 		return 1;
@@ -273,6 +309,40 @@ sub is_false_positive
 	return 0;
 }
 
+sub is_false_positive_32bit
+{
+       my ($match) = @_;
+       state $page_offset = get_page_offset();
+
+       if ($match =~ '\b(0x)?(f|F){8}\b') {
+               return 1;
+       }
+
+       if (hex($match) < $page_offset) {
+               return 1;
+       }
+
+       return 0;
+}
+
+# returns integer value
+sub get_page_offset
+{
+       my $page_offset;
+       my $default_offset = 0xc0000000;
+
+       # Allow --page-offset-32bit to override.
+       if ($page_offset_32bit != 0) {
+               return $page_offset_32bit;
+       }
+
+       $page_offset = get_kernel_config_option('CONFIG_PAGE_OFFSET');
+       if (!$page_offset) {
+	       return $default_offset;
+       }
+       return $page_offset;
+}
+
 sub is_in_vsyscall_memory_region
 {
 	my ($match) = @_;
@@ -314,11 +384,13 @@ sub may_leak_address
 
 sub get_address_re
 {
-	if (is_x86_64()) {
-		return get_x86_64_re();
-	} elsif (is_ppc64()) {
+	if (is_ppc64()) {
 		return '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	} elsif (is_32bit()) {
+		return '\b(0x)?[[:xdigit:]]{8}\b';
 	}
+
+	return get_x86_64_re();
 }
 
 sub get_x86_64_re
-- 
2.7.4
