Message-ID: <1513569287.8041.8.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Mon, 18 Dec 2017 09:24:47 +0530
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH] leaking_addresses: add generic 32-bit support
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

The script attempts to detect the architecture it's running upon; as of now,
we explicitly support x86_64, PPC64 and x86_32.
If it's one of them, we proceed "normally". If we fail to detect the arch,
we fallback to 64-bit scanning, unless the user has passed either of these
option switches: "--32-bit" and/or "--page-offset-32bit=<val>".

If so, we switch to scanning for leaked addresses based on the value of
PAGE_OFFSET (via an auto-detected or fallback mechanism).

As of now, we have code (or "rules") to detect special cases for x86_64 and ppc64
(in the get_address_re sub). Also, we now have also builtin "stubs", for lack of a better term,
where additional rules for other 64-bit arch's can be plugged in, in future,
as applicable.

Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
---

This is a patch based on Tobin's latest tree, 'leaks' branch. 
Applies on top of commit 6c3942594657 (leaking_addresses: add support for 5 page table levels (origin/leaks))

Thanks,
Kaiwan.

 scripts/leaking_addresses.pl | 213 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 184 insertions(+), 29 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index a29e13e577a7..a667f243c95b 100755
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
@@ -35,7 +35,7 @@ my $TIMEOUT = 10;
 # Script can only grep for kernel addresses on the following architectures. If
 # your architecture is not listed here and has a grep'able kernel address please
 # consider submitting a patch.
-my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
+my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'i[3456]86');
 
 # Command line options.
 my $help = 0;
@@ -48,7 +48,9 @@ my $suppress_dmesg = 0;               # Don't show dmesg in output.
 my $squash_by_path = 0;                # Summary report grouped by absolute path.
 my $squash_by_filename = 0;    # Summary report grouped by filename.
 
-my $kernel_config_file = "";   # Kernel configuration file.
+my $opt_32_bit = 0;            # Detect 32-bit kernel leaking addresses.
+my $page_offset_32bit = 0;     # 32-bit: value of CONFIG_PAGE_OFFSET.
+my $kernel_config_file = "";   # Kernel configuration file.
 
 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -97,17 +99,19 @@ Version: $V
 
 Options:
 
-       -o, --output-raw=<file>         Save results for future processing.
-       -i, --input-raw=<file>          Read results from file instead of scanning.
-             --raw                     Show raw results (default).
-             --suppress-dmesg          Do not show dmesg results.
-             --squash-by-path          Show one result per unique path.
-             --squash-by-filename      Show one result per unique filename.
-       --kernel-config-file=<file>     Kernel configuration file (e.g /boot/config)
-       -d, --debug                     Display debugging output.
-       -h, --help, --versionq          Display this help and exit.
+       -o, --output-raw=<file>         Save results for future processing.
+       -i, --input-raw=<file>          Read results from file instead of scanning.
+               --raw                       Show raw results (default).
+               --suppress-dmesg            Do not show dmesg results.
+               --squash-by-path            Show one result per unique path.
+               --squash-by-filename        Show one result per unique filename.
+       --32-bit                        Detect 32-bit kernel leaking addresses.
+       --page-offset-32bit=<hex>       PAGE_OFFSET value (for 32-bit kernels).
+       --kernel-config-file=<file>     Kernel configuration file (e.g /boot/config).
+       -d, --debug                     Display debugging output.
+       -h, --help, --version           Display this help and exit.
 
-Scans the running (64 bit) kernel for potential leaking addresses.
+Scans the running kernel for potential leaking addresses.
 
 EOM
        exit($exitcode);
@@ -123,7 +127,9 @@ GetOptions(
        'squash-by-path'        => \$squash_by_path,
        'squash-by-filename'    => \$squash_by_filename,
        'raw'                   => \$raw,
-       'kernel-config-file=s'  => \$kernel_config_file,
+       '32-bit'                => \$opt_32_bit,
+       'page-offset-32bit=o'   => \$page_offset_32bit,
+       'kernel-config-file=s'  => \$kernel_config_file,
 ) or help(1);
 
 help(0) if ($help);
@@ -139,11 +145,16 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
        exit(128);
 }
 
-if (!is_supported_architecture()) {
-       printf "\nScript does not support your architecture, sorry.\n";
-       printf "\nCurrently we support: \n\n";
-       foreach(@SUPPORTED_ARCHITECTURES) {
-               printf "\t%s\n", $_;
+show_detected_architecture() if $debug;
+
+if (!is_known_architecture()) {
+       printf STDERR "\n*** WARNING! Script does not recognize your architecture ***\n";
+       if ($opt_32_bit or $page_offset_32bit) {
+               printf STDERR "Scanning for 32-bit leaking kernel addresses\n\n";
+       } else {
+               printf STDERR "Scanning for 64-bit leaking kernel addresses\n";
+               printf STDERR "If you\'d rather scan for 32-bit addresses, use the ";
+               printf STDERR "--32-bit (and --page-offset-32bit=) option switch(es).\n\n";
        }
 
        my $archname = $Config{archname};
@@ -168,9 +179,14 @@ sub dprint
        printf(STDERR @_) if $debug;
 }
 
-sub is_supported_architecture
+sub is_known_architecture
+{
+       return (is_64bit() or is_ix86_32());
+}
+
+sub is_64bit
 {
-       return (is_x86_64() or is_ppc64());
+       return (is_x86_64() or is_ppc64() or is_arm64() or is_mips64());
 }
 
 sub is_x86_64
@@ -193,6 +209,50 @@ sub is_ppc64
        return 0;
 }
 
+sub is_arm64
+{
+       if (`uname -m` eq "aarch64") {
+               return 1;
+       }
+       return 0;
+}
+
+sub is_mips64
+{
+       if (`uname -m` eq "mips64") {
+               return 1;
+       }
+       return 0;
+}
+
+sub is_ix86_32
+{
+       my $archname = $Config{archname};
+
+       if ($archname =~ m/i[3456]86-linux/) {
+               return 1;
+       }
+       return 0;
+}
+
+sub show_detected_architecture
+{
+       printf "Detected architecture: ";
+       if (is_ix86_32()) {
+               printf "32 bit x86\n";
+       } elsif (is_x86_64()) {
+               printf "x86_64\n";
+       } elsif (is_ppc64()) {
+               printf "ppc64\n";
+       } elsif (is_arm64()) {
+               printf "ARM64\n";
+       } elsif (is_mips64()) {
+               printf "MIPS64\n";
+       } else {
+               printf "failed to detect architecture\n"
+       }
+}
+
 # gets config option value from kernel config file
 sub get_kernel_config_option
 {
@@ -220,7 +280,8 @@ sub get_kernel_config_option
        }
 
        foreach my $file (@config_files) {
-               dprint("parsing config file: %s\n", $file);
+               printf("file: %s\n", $file) if $debug;
+
                $value = option_from_file($option, $file);
                if ($value ne "") {
                        last;
@@ -258,6 +319,14 @@ sub is_false_positive
 {
        my ($match) = @_;
 
+       # 32 bit architectures, actual or forced
+
+       if (!is_64bit() and ($opt_32_bit or $page_offset_32bit)) {
+               return is_false_positive_32bit($match);
+       }
+
+       # 64 bit architectures
+
        if ($match =~ '\b(0x)?(f|F){16}\b' or
            $match =~ '\b(0x)?0{16}\b') {
                return 1;
@@ -281,6 +350,91 @@ sub is_in_vsyscall_memory_region
        return ($hex >= $region_min and $hex <= $region_max);
 }
 
+sub is_false_positive_32bit
+{
+       my ($match) = @_;
+       state $page_offset = get_page_offset(); # only gets called once
+
+       if ($match =~ '\b(0x)?(f|F){8}\b') {
+               return 1;
+       }
+
+       my $addr32 = eval hex($match);
+       if ($addr32 < $page_offset) {
+               return 1;
+       }
+
+       return 0;
+}
+
+sub get_page_offset
+{
+       my $page_offset;
+       my $default_offset = hex("0xc0000000");
+       my @config_files;
+
+       # Allow --page-offset-32bit to override.
+       if ($page_offset_32bit != 0) {
+               return $page_offset_32bit;
+       }
+
+       # Allow --kernel-config-file to override.
+       if ($kernel_config_file ne "") {
+               @config_files = ($kernel_config_file);
+       } else {
+               my $config_file = '/boot/config-' . `uname -r`;
+               @config_files = ($config_file, '/boot/config');
+       }
+
+       if (-R "/proc/config.gz") {
+               my $tmp_file = "/tmp/tmpkconf";
+               if (system("gunzip < /proc/config.gz > $tmp_file")) {
+                       dprint " parse_kernel_config: system(gunzip...) failed\n";
+                       system("rm -f $tmp_file 2>/dev/null");
+               } else {
+                       $page_offset = parse_kernel_config_file($tmp_file);
+                       system("rm -f $tmp_file");
+                       if ($page_offset ne "") {
+                               return hex($page_offset);
+                       }
+               }
+       }
+
+       foreach my $config_file (@config_files) {
+               chomp $config_file;
+               $page_offset = parse_kernel_config_file($config_file);
+               if ($page_offset ne "") {
+                       return hex($page_offset);
+               }
+       }
+
+       printf STDERR "\nFailed to parse kernel config files\n";
+       printf STDERR "*** NOTE ***\n";
+       printf STDERR "Falling back to PAGE_OFFSET = %#x\n\n", $default_offset;
+
+       return $default_offset;
+}
+
+sub parse_kernel_config_file
+{
+       my ($file) = @_;
+       my $config = 'CONFIG_PAGE_OFFSET';
+       my $str = "";
+       my $val = "";
+
+       open(my $fh, "<", $file) or return "";
+       while (my $line = <$fh> ) {
+               if ($line =~ /^$config/) {
+                       ($str, $val) = split /=/, $line;
+                       chomp($val);
+                       last;
+               }
+       }
+
+       close $fh;
+       return $val;
+}
+
 # True if argument potentially contains a kernel address.
 sub may_leak_address
 {
@@ -300,7 +454,7 @@ sub may_leak_address
        }
 
        $address_re = get_address_re();
-       dprint("Kernel address regular expression: %s\n", $address_re);
+#      dprint("Kernel address regular expression: %s\n", $address_re);
 
        while (/($address_re)/g) {
                if (!is_false_positive($1)) {
@@ -313,16 +467,17 @@ sub may_leak_address
 
 sub get_address_re
 {
-       my $re;
+       my $re = "";
 
        if (is_x86_64()) {
                $re = get_x86_64_re();
        } elsif (is_ppc64()) {
                $re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
-       }
-
-       if ($re eq "") {
-               print STDERR "$0: failed to build kernel address regular expression\n";
+       ###
+       # Any special cases for other arch's go below this line
+       ###
+       } else {  # nothing? then we assume it's a generic 32-bit
+               $re = '\b(0x)?[[:xdigit:]]{8}\b';
        }
 
        return $re;
-- 
2.14.3
