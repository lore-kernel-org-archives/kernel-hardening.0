From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 1/4] leaking_addresses: do not parse binary files
Date: Mon, 19 Feb 2018 13:50:46 +1100
Message-Id: <1519008649-15782-2-git-send-email-me@tobin.cc>
In-Reply-To: <1519008649-15782-1-git-send-email-me@tobin.cc>
References: <1519008649-15782-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently script parses binary files.  Since we are scanning for
readable kernel addresses there is no need to parse binary files.  We
can use Perl to check if file is binary and skip parsing it if so.

Do not parse binary files.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 05906f6cf6b9..3d5c3096aac8 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -462,6 +462,10 @@ sub parse_file
 		return;
 	}
 
+	if (! -T $file) {
+		return;
+	}
+
 	if (skip_parse($file)) {
 		dprint "skipping file: $file\n";
 		return;
-- 
2.7.4
