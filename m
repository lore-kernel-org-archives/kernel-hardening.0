From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 3/4] leaking_addresses: cache architecture name
Date: Mon, 19 Feb 2018 13:50:48 +1100
Message-Id: <1519008649-15782-4-git-send-email-me@tobin.cc>
In-Reply-To: <1519008649-15782-1-git-send-email-me@tobin.cc>
References: <1519008649-15782-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently we are repeatedly calling `uname -m`.  This is causing the
script to take a long time to run (more than 10 seconds to parse
/proc/kallsyms).  We can use Perl state variables to cache the result of
the first call to `uname -m`.  With this change in place the script
scans the whole kernel in under a minute.

Cache machine architecture in state variable.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index e7bf15a45a69..f52e91ef7d5c 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -175,7 +175,7 @@ sub is_32bit
 
 sub is_ix86_32
 {
-       my $arch = `uname -m`;
+       state $arch = `uname -m`;
 
        chomp $arch;
        if ($arch =~ m/i[3456]86/) {
@@ -198,12 +198,14 @@ sub is_arch
 
 sub is_x86_64
 {
-	return is_arch('x86_64');
+	state $is = is_arch('x86_64');
+	return $is;
 }
 
 sub is_ppc64
 {
-	return is_arch('ppc64');
+	state $is = is_arch('ppc64');
+	return $is;
 }
 
 # Gets config option value from kernel config file.
-- 
2.7.4
