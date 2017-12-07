From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  7 Dec 2017 15:32:25 +1100
Message-Id: <1512621145-4783-6-git-send-email-me@tobin.cc>
In-Reply-To: <1512621145-4783-1-git-send-email-me@tobin.cc>
References: <1512621145-4783-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 5/5] leaking_addresses: add support for 5 page table levels
To: me@tobin.cc, kaiwan.billimoria@gmail.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script only supports 4 page table levels because of the way
the kernel address regular expression is crafted. We can do better than
this. Using previously added support for kernel configuration options we
can get the number of page table levels defined by
CONFIG_PGTABLE_LEVELS. Using this value a correct regular expression can
be crafted. This only supports 5 page tables on x86_64.

Add support for 5 page table levels on x86_64.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 60 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 892bfe9e01fe..82be5f18ea5f 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -21,6 +21,7 @@ use Term::ANSIColor qw(:constants);
 use Getopt::Long qw(:config no_auto_abbrev);
 use Config;
 use bigint qw/hex/;
+use feature 'state';
 
 my $P = $0;
 my $V = '0.01';
@@ -39,12 +40,14 @@ my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
 # Command line options.
 my $help = 0;
 my $debug = 0;
+
 my $raw = 0;
 my $output_raw = "";	# Write raw results to file.
 my $input_raw = "";	# Read raw results from file instead of scanning.
 my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
+
 my $kernel_config_file = "";	# Kernel configuration file.
 
 # Do not parse these files (absolute path).
@@ -212,11 +215,13 @@ sub get_kernel_config_option
 
 	} else {
 		my $file = '/boot/config-' . `uname -r`;
+		chomp $file;
 		@config_files = ($file, '/boot/config');
 	}
 
 	foreach my $file (@config_files) {
-#		chomp $config_file;
+		printf("file: %s\n", $file);
+
 		$value = option_from_file($option, $file);
 		if ($value ne "") {
 			last;
@@ -295,12 +300,8 @@ sub may_leak_address
 		return 0;
 	}
 
-	# One of these is guaranteed to be true.
-	if (is_x86_64()) {
-		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
-	} elsif (is_ppc64()) {
-		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
-	}
+	$address_re = get_address_re();
+	dprint("Kernel address regular expression: %s\n", $address_re);
 
 	while (/($address_re)/g) {
 		if (!is_false_positive($1)) {
@@ -311,6 +312,51 @@ sub may_leak_address
 	return 0;
 }
 
+sub get_address_re
+{
+	my $re;
+
+	if (is_x86_64()) {
+		$re = get_x86_64_re();
+	} elsif (is_ppc64()) {
+		$re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	}
+
+	if ($re eq "") {
+		print STDERR "$0: failed to build kernel address regular expression\n";
+	}
+
+	return $re;
+}
+
+sub get_x86_64_re
+{
+	state $ptl = get_page_table_levels();
+	my $re;
+
+	if ($ptl == 5) {
+		$re = '\b(0x)?ff[[:xdigit:]]{14}\b';
+	} else {
+		$re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+	}
+
+	return $re;
+}
+
+sub get_page_table_levels
+{
+	my $ptl = "";
+	my $default_ptl = "4";
+
+	$ptl = get_kernel_config_option('CONFIG_PGTABLE_LEVELS');
+	if ($ptl eq "") {
+		$ptl = $default_ptl;
+		printf(STDERR "$0: defaulting to %s page table levels\n", $default_ptl);
+	}
+
+	return $ptl;
+}
+
 sub parse_dmesg
 {
 	open my $cmd, '-|', 'dmesg';
-- 
2.7.4
