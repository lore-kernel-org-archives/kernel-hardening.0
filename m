From: "Tobin C. Harding" <me@tobin.cc>
Date: Thu,  7 Dec 2017 15:32:22 +1100
Message-Id: <1512621145-4783-3-git-send-email-me@tobin.cc>
In-Reply-To: <1512621145-4783-1-git-send-email-me@tobin.cc>
References: <1512621145-4783-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] [PATCH 2/5] leaking_addresses: indent dependant options
To: me@tobin.cc, kaiwan.billimoria@gmail.com
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Alexander Kapshuk <alexander.kapshuk@gmail.com>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

A number of the command line options to script are dependant on the
option --input-raw being set. If we indent these options it makes
explicit this dependency.

Indent options dependant on --raw-input.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 2c5da2296e94..066c609b1adb 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -93,14 +93,14 @@ Version: $V
 
 Options:
 
-	-o, --output-raw=<file>  Save results for future processing.
-	-i, --input-raw=<file>   Read results from file instead of scanning.
-	    --raw                Show raw results (default).
-	    --suppress-dmesg     Do not show dmesg results.
-	    --squash-by-path     Show one result per unique path.
-	    --squash-by-filename Show one result per unique filename.
-	-d, --debug              Display debugging output.
-	-h, --help, --version    Display this help and exit.
+	-o, --output-raw=<file>		Save results for future processing.
+	-i, --input-raw=<file>		Read results from file instead of scanning.
+	      --raw			Show raw results (default).
+	      --suppress-dmesg		Do not show dmesg results.
+	      --squash-by-path		Show one result per unique path.
+	      --squash-by-filename	Show one result per unique filename.
+	-d, --debug			Display debugging output.
+	-h, --help, --versionq		Display this help and exit.
 
 Scans the running (64 bit) kernel for potential leaking addresses.
 
-- 
2.7.4
