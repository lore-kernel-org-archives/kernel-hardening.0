From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 4/4] leaking_addresses: add scan_once array
Date: Mon, 19 Feb 2018 13:50:49 +1100
Message-Id: <1519008649-15782-5-git-send-email-me@tobin.cc>
In-Reply-To: <1519008649-15782-1-git-send-email-me@tobin.cc>
References: <1519008649-15782-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

There are files under /proc that have the same format for each PID, e.g
'smaps'.  We need only scan these files a single time to verify that
they are not leaking addresses.  This reduces the work the script must
do.

Add once_only array.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index f52e91ef7d5c..ab4e70d9efde 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -69,6 +69,12 @@ my @skip_any = (
 	'fd',
 	'usbmon');
 
+# These files are the same format under each PID that they appear.
+# We need only pass them once.
+my @once_only = (
+	'smaps',
+	'mb_groups');
+
 sub help
 {
 	my ($exitcode) = @_;
@@ -401,6 +407,25 @@ sub parse_dmesg
 	close $cmd;
 }
 
+sub already_scanned
+{
+	my ($filename) = @_;
+	state %seen;
+
+	foreach (@once_only) {
+		if (/^$filename$/) {
+			if ($seen{$_} == 1) {
+				return 1;
+			}
+			$seen{$_} = 1;
+
+			return 0;
+		}
+	}
+
+	return 0;
+}
+
 # True if we should skip this path.
 sub skip
 {
@@ -415,6 +440,10 @@ sub skip
 		return 1 if (/^$filename$/);
 	}
 
+	if (already_scanned($filename)) {
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.7.4
