From: "Tobin C. Harding" <me@tobin.cc>
Date: Tue, 24 Oct 2017 11:33:10 +1100
Message-Id: <1508805190-18784-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [RFC V2] scripts: add leaking_addresses.pl
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <me@tobin.cc>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently we are leaking addresses from the kernel to user space. This
script as an attempt to find those leakages. Script parses `dmesg`
output and /proc and /sys files for suspicious entries.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

My usual disclaimer; I am a long way from being a Perl monger, any tips,
however trivial, most welcome.

Parses dmesg output first then;

Algorithm walks the directory tree of /proc and /sys, opens each file
for reading and parses file line by line. We therefore need to skip
certain files;

 - binary files.
 - really large files of fixed format that _definitely_ won't leak.

Includes debugging option to print files as they are parsed, this is
useful to see where the script chokes. This method was used to create
the list of files to _not_ parse. Obviously this means there are going
to be a bunch of other files not present on my system. Either more files
to skip or a suggestion of a better way to do this most appreciated.

Like I said, happy to take suggestions, abuse, tweaks etc

At this stage, the script seems like it may only be good for 64 bit
kernels. The reason being that 32 bit addresses do not include the
leading 1's like 64 bit addresses. There does not seem to be a way to
differentiate between kernel addresses and any 32 bit hex digit. False
positives may make the script unusable?

Final noob issues; I could not get emacs/cperl-mode to play nicely with
Perl code formatted like we do C code (following on from style used in
checkpatch.pl). I touched up the formatting by hand but the diff still
has unusual spaces in it. Any suggestions on how to do this very much
appreciated.

Also, I am hesitant to add an entry to MAINTAINERS for a Perl script
because it implies that I actually _know_ Perl. I'm happy to maintain it
but it would be nice to have a _real_ Perl programmer in there as well.

thanks,
Tobin.


V2:
 - Added command line option to exclude directories from being walked.
 - Added command line option to exclude files from being parsed.
 - Implemented suggestions by Steven Rostedt, Petr Mladek, and Phil Pearl. 


 scripts/leaking_addresses.pl | 232 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 232 insertions(+)
 create mode 100755 scripts/leaking_addresses.pl

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
new file mode 100755
index 000000000000..7397e094247b
--- /dev/null
+++ b/scripts/leaking_addresses.pl
@@ -0,0 +1,232 @@
+#!/usr/bin/env perl
+#
+# (c) 2017 Tobin C. Harding <me@tobin.cc>
+# Licensed under the terms of the GNU GPL License version 2
+#
+# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
+#  - Scans dmesg output.
+#  - Walks directory tree and parses each file (for each directory in @DIRS).
+
+use warnings;
+use strict;
+use POSIX;
+use File::Basename;
+use Cwd 'abs_path';
+use Term::ANSIColor qw(:constants);
+use Getopt::Long qw(:config no_auto_abbrev);
+
+my $P = $0;
+my $V = '0.01';
+
+# Directories to scan.
+my @DIRS = ('/proc', '/sys');
+
+# Command line options.
+my $help = 0;
+my $debug = 0;
+my @dont_walk = ();
+my @dont_parse = ();
+
+sub help {
+	my ($exitcode) = @_;
+
+	print << "EOM";
+Usage: $P [OPTIONS]
+Version: $V
+
+Options:
+
+      --dont_walk=<dir>      Don't walk <dir> (absolute path).
+      --dont_parse=<file>    Don't parse <file> (absolute path).
+  -d, --debug		     Display debugging output.
+  -h, --help, --version      Display this help and exit.
+
+Example:
+
+    # Just scan dmesg output.
+    scripts/leaking_addresses.pl --dont_walk /proc --dont_walk /sys
+
+Scans the running (64 bit) kernel for potential leaking addresses.
+
+EOM
+	exit($exitcode);
+}
+
+GetOptions(
+	'dont_walk=s'		=> \@dont_walk,
+	'dont_parse=s'		=> \@dont_parse,
+	'd|debug'		=> \$debug,
+	'h|help'		=> \$help,
+	'version'		=> \$help
+) or help(1);
+
+help(0) if ($help);
+
+parse_dmesg();
+walk(@DIRS);
+
+exit 0;
+
+
+sub dprint
+{
+	printf(STDERR @_) if $debug;
+}
+
+# True if argument potentially contains a kernel address.
+sub may_leak_address
+{
+	my ($line) = @_;
+
+        # Ignore false positives.
+        if ($line =~ '\b(0x)?(f|F){16}\b' or
+            $line =~ '\b(0x)?0{16}\b' or
+            $line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
+		return 0;
+        }
+
+        # Potential kernel address.
+        if ($line =~ '\b(0x)?ffff[[:xdigit:]]{12}\b') {
+		return 1;
+        }
+
+        return 0;
+}
+
+sub parse_dmesg
+{
+        open my $cmd, '-|', 'dmesg';
+        while (<$cmd>) {
+                if (may_leak_address($_)) {
+                        print 'dmesg: ' . $_;
+                }
+        }
+        close $cmd;
+}
+
+# We should skip parsing these files.
+sub skip_parse
+{
+	my ($path) = @_;
+
+	# Skip these absolute path names.
+        my @skip_paths = ('/proc/kmsg',
+                          '/proc/kcore',
+                          '/proc/kallsyms',
+                          '/proc/fs/ext4/sdb1/mb_groups',
+                          '/proc/1/fd/3',
+                          '/sys/kernel/debug/tracing/trace_pipe',
+                          '/sys/kernel/security/apparmor/revision');
+
+        # Exclude paths passed in via command line options.
+        push(@skip_paths, @dont_parse);
+
+        # Skip these files under any subdirectory.
+        my @skip_files = ('0',
+                          '1',
+                          '2',
+                          'pagemap',
+                          'events',
+                          'access',
+                          'registers',
+                          'snapshot_raw',
+                          'trace_pipe_raw',
+                          'ptmx',
+                          'trace_pipe');
+
+        foreach(@skip_paths) {
+                return 1 if (/^$path$/);
+        }
+
+        my($filename, $dirs, $suffix) = fileparse($path);
+        foreach(@skip_files) {
+		return 1 if (/^$filename$/);
+        }
+
+        return 0;
+}
+
+sub parse_file
+{
+	my ($file) = @_;
+
+        if (! -R $file) {
+                return;
+        }
+
+        if (skip_parse($file)) {
+		dprint "skipping file: $file\n";
+		return;
+        }
+        dprint "parsing: $file\n";
+
+        open my $fh, "<", $file or return;
+        while( <$fh> )  {
+                if (may_leak_address($_)) {
+                        print $file . ': ' . $_;
+                }
+        }
+        close $fh;
+}
+
+# We should skip walking these directories.
+sub skip_dir
+{
+	my ($path) = @_;
+
+	# skip these directories under any subdirectory.
+	my @skip_dirs = ('self',
+                         'thread-self',
+                         'cwd',
+                         'fd',
+                         'stderr',
+                         'stdin',
+                         'stdout');
+
+	my($filename, $dirs, $suffix) = fileparse($path);
+
+        foreach(@skip_dirs) {
+                return 1 if (/^$filename$/);
+        }
+
+        return 0;
+}
+
+# Allow command line options to exclude paths to walk.
+sub dont_walk
+{
+	my ($path) = @_;
+
+	foreach(@dont_walk) {
+		return 1 if (/^$path$/);
+	}
+}
+
+# Recursively walk directory tree.
+sub walk
+{
+        my @dirs = @_;
+        my %seen;
+
+        while (my $pwd = shift @dirs) {
+		next if (dont_walk($pwd));
+                next if (!opendir(DIR, $pwd));
+                my @files = readdir(DIR);
+                closedir(DIR);
+
+                foreach my $file (@files) {
+                        next if ($file eq '.' or $file eq '..');
+
+                        my $path = "$pwd/$file";
+                        next if (-l $path);
+
+                        if (-d $path) {
+				next if skip_dir($path);
+				push @dirs, $path;
+                        } else {
+				parse_file($path);
+                        }
+                }
+        }
+}
+
-- 
2.7.4
