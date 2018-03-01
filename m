From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 1/2] leaking_addresses: explicitly name variable used in regex
Date: Fri,  2 Mar 2018 09:03:19 +1100
Message-Id: <1519941800-27710-2-git-send-email-me@tobin.cc>
In-Reply-To: <1519941800-27710-1-git-send-email-me@tobin.cc>
References: <1519941800-27710-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Currently sub routine may_leak_address() is checking regex against Perl
special variable $_ which is _fortunately_ being set correctly in a loop
before this sub routine is called.  We already have declared a variable
to hold this value '$line' we should use it.

Use $line in regex match instead of implicit $_

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index d5d31f3df97e..65a65aa64d26 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -363,7 +363,7 @@ sub may_leak_address
 	}
 
 	$address_re = get_address_re();
-	while (/($address_re)/g) {
+	while ($line =~ /($address_re)/g) {
 		if (!is_false_positive($1)) {
 			return 1;
 		}
-- 
2.7.4
