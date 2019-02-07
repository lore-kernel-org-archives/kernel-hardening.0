From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [PATCH 3/3] leaking_addresses: Expand tilde in output file name
Date: Fri,  8 Feb 2019 09:50:26 +1100
Message-Id: <20190207225026.11723-4-tobin@kernel.org>
In-Reply-To: <20190207225026.11723-1-tobin@kernel.org>
References: <20190207225026.11723-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: "Tobin C. Harding" <tobin@kernel.org>, Tycho Andersen <tycho@tycho.ws>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Currently if user passes an output file to the script via
--output-raw we do not handle expansion of tilde.

Use perl function glob() to expand tilde in output file name.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 scripts/leaking_addresses.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index ef9e5b2a1614..ce545ca3fb70 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -150,7 +150,7 @@ if (!(is_supported_architecture() or $opt_32bit or $page_offset_32bit)) {
 }
 
 if ($output_raw) {
-	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
+	open my $fh, '>', glob($output_raw) or die "$0: $output_raw: $!\n";
 	select $fh;
 }
 
-- 
2.20.1
