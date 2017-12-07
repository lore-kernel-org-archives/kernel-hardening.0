From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  7 Dec 2017 15:32:21 +1100
Message-Id: <1512621145-4783-2-git-send-email-me@tobin.cc>
In-Reply-To: <1512621145-4783-1-git-send-email-me@tobin.cc>
References: <1512621145-4783-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 1/5] leaking_addresses: remove command examples
To: me@tobin.cc, kaiwan.billimoria@gmail.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently help output includes command examples. These were cute when we
first started development of this script but are unnecessary.

Remove command examples.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 1c5637db82a5..2c5da2296e94 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -102,17 +102,6 @@ Options:
 	-d, --debug              Display debugging output.
 	-h, --help, --version    Display this help and exit.
 
-Examples:
-
-	# Scan kernel and dump raw results.
-	$0
-
-	# Scan kernel and save results to file.
-	$0 --output-raw scan.out
-
-	# View summary report.
-	$0 --input-raw scan.out --squash-by-filename
-
 Scans the running (64 bit) kernel for potential leaking addresses.
 
 EOM
-- 
2.7.4
