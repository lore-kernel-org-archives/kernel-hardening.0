From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 1/3] leaking_addresses: Fix calls to dprint
Date: Fri,  8 Feb 2019 09:50:24 +1100
Message-Id: <20190207225026.11723-2-tobin@kernel.org>
In-Reply-To: <20190207225026.11723-1-tobin@kernel.org>
References: <20190207225026.11723-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <tobin@kernel.org>, Tycho Andersen <tycho@tycho.ws>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently calls to function dprint() are non uniform and at times
incorrect.

Use uniform _correct_ call to function dprint().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 scripts/leaking_addresses.pl | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 6a897788f5a7..214c12be8c86 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -231,7 +231,7 @@ sub get_kernel_config_option
 		my $tmp_file = "/tmp/tmpkconf";
 
 		if (system("gunzip < /proc/config.gz > $tmp_file")) {
-			dprint "$0: system(gunzip < /proc/config.gz) failed\n";
+			dprint("system(gunzip < /proc/config.gz) failed\n");
 			return "";
 		} else {
 			@config_files = ($tmp_file);
@@ -243,7 +243,7 @@ sub get_kernel_config_option
 	}
 
 	foreach my $file (@config_files) {
-		dprint("parsing config file: %s\n", $file);
+		dprint("parsing config file: $file\n");
 		$value = option_from_file($option, $file);
 		if ($value ne "") {
 			last;
@@ -502,7 +502,7 @@ sub walk
 				next;
 			}
 
-			dprint "parsing: $path\n";
+			dprint("parsing: $path\n");
 			timed_parse_file($path);
 		}
 	}
-- 
2.20.1
