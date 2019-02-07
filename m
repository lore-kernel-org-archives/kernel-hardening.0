From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 2/3] leaking_addresses: Completely remove --version flag
Date: Fri,  8 Feb 2019 09:50:25 +1100
Message-Id: <20190207225026.11723-3-tobin@kernel.org>
In-Reply-To: <20190207225026.11723-1-tobin@kernel.org>
References: <20190207225026.11723-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <tobin@kernel.org>, Tycho Andersen <tycho@tycho.ws>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Recently attempt to remove the '--version' flag was made, badly.  I
failed to remove mention of it from the help output.  And also I failed
to actually remove the flag from the options list.

_Completely_ remove --version flag.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 scripts/leaking_addresses.pl | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 214c12be8c86..ef9e5b2a1614 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -97,7 +97,7 @@ Options:
 	--32-bit			Scan 32-bit kernel.
 	--page-offset-32-bit=o		Page offset (for 32-bit kernel 0xABCD1234).
 	-d, --debug			Display debugging output.
-	-h, --help, --version		Display this help and exit.
+	-h, --help			Display this help and exit.
 
 Scans the running kernel for potential leaking addresses.
 
@@ -108,7 +108,6 @@ EOM
 GetOptions(
 	'd|debug'		=> \$debug,
 	'h|help'		=> \$help,
-	'version'		=> \$help,
 	'o|output-raw=s'        => \$output_raw,
 	'i|input-raw=s'         => \$input_raw,
 	'suppress-dmesg'        => \$suppress_dmesg,
-- 
2.20.1
