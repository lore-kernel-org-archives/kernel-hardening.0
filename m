From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 1/3] leaking_addresses: skip all /proc/PID except /proc/1
Date: Tue, 27 Feb 2018 15:45:09 +1100
Message-Id: <1519706711-18580-2-git-send-email-me@tobin.cc>
In-Reply-To: <1519706711-18580-1-git-send-email-me@tobin.cc>
References: <1519706711-18580-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

When the system is idle it is likely that most files under /proc/PID
will be identical for various processes.  Scanning _all_ the PIDs under
/proc is unnecessary and implies that we are thoroughly scanning /proc.
This is _not_ the case because there may be ways userspace can trigger
creation of /proc files that leak addresses but were not present during
a scan.  For these two reasons we should exclude all PID directories
under /proc except '1/'

Exclude all /proc/PID except /proc/1.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 6e5bc57caeaa..fb40e2828f43 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -10,6 +10,14 @@
 # Use --debug to output path before parsing, this is useful to find files that
 # cause the script to choke.
 
+#
+# When the system is idle it is likely that most files under /proc/PID will be
+# identical for various processes.  Scanning _all_ the PIDs under /proc is
+# unnecessary and implies that we are thoroughly scanning /proc.  This is _not_
+# the case because there may be ways userspace can trigger creation of /proc
+# files that leak addresses but were not present during a scan.  For these two
+# reasons we exclude all PID directories under /proc except '1/'
+
 use warnings;
 use strict;
 use POSIX;
@@ -472,6 +480,9 @@ sub walk
 			my $path = "$pwd/$file";
 			next if (-l $path);
 
+			# skip /proc/PID except /proc/1
+			next if ($path =~ /\/proc\/(?:[2-9][0-9]*|1[0-9]+)/);
+
 			next if (skip($path));
 
 			if (-d $path) {
-- 
2.7.4
