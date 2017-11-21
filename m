Message-ID: <1511251094.25970.18.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Tue, 21 Nov 2017 13:28:14 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v1] scripts: leaking_addresses.pl: add support for 32-bit
 kernel addresses
To: me@tobin.cc
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The current leaking_addresses.pl script only supports showing "leaked"
64-bit kernel virtual addresses. This patch adds support for showing
"leaked" 32-bit kernel virtual addresses.

The way it currently works- once it detects we're running on an i'x'86 platform
(where x=3|4|5|6), it takes this arch into account for checking: the essential
rationale:
 virt-addr >= PAGE_OFFSET => it's a kernel virtual address.

Note- 
1. It's a work in progress; some pending TODOs:
- support for ARM-32
- programatically query and set the PAGE_OFFSET based on arch (it's currently
hard-coded)

2. Minor edit: 
the '--raw', '--suppress-dmesg', '--squash-by-path' and
'--squash-by-filename' option switches are only meaningful
when the '----input-raw=' option is used. So, indent the 'Help' screen lines
to reflect the fact.


Feedback welcome..


Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
---
diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index bc5788000018..e139de445ad1 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -12,7 +12,10 @@
 #
 # You may like to set kptr_restrict=2 before running script
 # (see Documentation/sysctl/kernel.txt).
-
+#
+# 32-bit kernel address support : Kaiwan N Billimoria
+#                       <kaiwan.billimoria@gmail.com>
+#
 use warnings;
 use strict;
 use POSIX;
@@ -35,7 +38,7 @@ my $TIMEOUT = 10;
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'i[3456]86');
 
 # Command line options.
 my $help = 0;
@@ -48,6 +51,9 @@ my $suppress_dmesg = 0;		# Don't show dmesg in output.
 my $squash_by_path = 0;		# Summary report grouped by absolute path.
 my $squash_by_filename = 0;	# Summary report grouped by filename.
 
+my $bit_size = 64;   # Check 64-bit kernel addresses by default
+my $PAGE_OFFSET_32BIT = 0xc0000000;
+
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
 			    '/proc/kcore',
@@ -97,10 +103,10 @@ Options:
 
 	-o, --output-raw=<file>  Save results for future processing.
 	-i, --input-raw=<file>   Read results from file instead of scanning.
-	    --raw                Show raw results (default).
-	    --suppress-dmesg     Do not show dmesg results.
-	    --squash-by-path     Show one result per unique path.
-	    --squash-by-filename Show one result per unique filename.
+	      --raw                 Show raw results (default).
+	      --suppress-dmesg      Do not show dmesg results.
+	      --squash-by-path      Show one result per unique path.
+	      --squash-by-filename  Show one result per unique filename.
 	-d, --debug              Display debugging output.
 	-h, --help, --version    Display this help and exit.
 
@@ -177,7 +183,7 @@ sub dprint
 
 sub is_supported_architecture
 {
-	return (is_x86_64() or is_ppc64());
+	return (is_x86_64() or is_ppc64() or is_ix86_32());
 }
 
 sub is_x86_64
@@ -185,6 +191,7 @@ sub is_x86_64
 	my $archname = $Config{archname};
 
 	if ($archname =~ m/x86_64/) {
+		$bit_size=64;
 		return 1;
 	}
 	return 0;
@@ -195,6 +202,19 @@ sub is_ppc64
 	my $archname = $Config{archname};
 
 	if ($archname =~ m/powerpc/ and $archname =~ m/64/) {
+		$bit_size=64;
+		return 1;
+	}
+	return 0;
+}
+
+# 32-bit x86: is_i'x'86_32() ; where x is [3 or 4 or 5 or 6]
+sub is_ix86_32
+{
+	my $archname = $Config{archname};
+
+	if ($archname =~ m/i[3456]86-linux/) {
+		$bit_size=32;
 		return 1;
 	}
 	return 0;
@@ -215,6 +235,15 @@ sub is_false_positive
 		    $match =~ '\bf{10}601000\b') {
 			return 1;
 		}
+	} elsif ($bit_size == 32) {
+		my $addr32 = eval hex($match);
+		if ($addr32 < $PAGE_OFFSET_32BIT ) {
+			return 1;
+		}
+		if ($match =~ '\b(0x)?(f|F){8}\b') {
+			return 1;
+		}
 	}
 
 	return 0;
@@ -243,6 +272,8 @@ sub may_leak_address
 		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
 	} elsif (is_ppc64()) {
 		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
+	} elsif (is_ix86_32()) {
+		$address_re = '\b(0x)?[[:xdigit:]]{8}\b';
 	}
 
 	while (/($address_re)/g) {
