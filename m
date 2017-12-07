From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  7 Dec 2017 15:32:23 +1100
Message-Id: <1512621145-4783-4-git-send-email-me@tobin.cc>
In-Reply-To: <1512621145-4783-1-git-send-email-me@tobin.cc>
References: <1512621145-4783-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 3/5] leaking_addresses: add range check for vsyscall memory
To: me@tobin.cc, kaiwan.billimoria@gmail.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently script checks only first and last address in the vsyscall
memory range. We can do better than this.

When checking for false positives against $match, convert $match to
a hexadecimal value then check if it lies within the range of vsyscall
addresses.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 066c609b1adb..cb69ccd4153a 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -20,6 +20,7 @@ use Cwd 'abs_path';
 use Term::ANSIColor qw(:constants);
 use Getopt::Long qw(:config no_auto_abbrev);
 use Config;
+use bigint qw/hex/;
 
 my $P = $0;
 my $V = '0.01';
@@ -196,17 +197,24 @@ sub is_false_positive
 		return 1;
 	}
 
-	if (is_x86_64()) {
-		# vsyscall memory region, we should probably check against a range here.
-		if ($match =~ '\bf{10}600000\b' or
-		    $match =~ '\bf{10}601000\b') {
-			return 1;
-		}
+	if (is_x86_64() and is_in_vsyscall_memory_region($match)) {
+		return 1;
 	}
 
 	return 0;
 }
 
+sub is_in_vsyscall_memory_region
+{
+	my ($match) = @_;
+
+	my $hex = hex($match);
+	my $region_min = hex("0xffffffffff600000");
+	my $region_max = hex("0xffffffffff601000");
+
+	return ($hex >= $region_min and $hex <= $region_max);
+}
+
 # True if argument potentially contains a kernel address.
 sub may_leak_address
 {
-- 
2.7.4
