From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Fri,  9 Jun 2017 03:03:36 +0200
Message-Id: <20170609010336.28981-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH] random: default the warning to be on
To: tytso@mit.edu, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

This commit is meant to be rebase-fixup'd into the one entitled: "random: warn
when kernel uses unseeded randomness" if you so desire.

I originally had planned to do things this way -- have it default on for
all users, not just debug users. But when I saw all the log spam, I
decided maybe it should, much to my dismay, be a debug-only feature.
However, you very nicely solved the log spam issue by preventing
same-source consecutive warnings, which makes the situation much more
manageable. Thus, in order to tease out the weird obscure cases of
unseeded randomness on unlikely platforms, this commit turns it on
everywhere.

It's fairly non-invasive now, and it will help us get some visibility into
the issue that we otherwise wouldn't have.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 lib/Kconfig.debug | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c4159605bfbf..fd5e67bcd46c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1212,7 +1212,6 @@ config STACKTRACE
 config WARN_UNSEEDED_RANDOM
 	bool "Warn when kernel uses unseeded randomness"
 	default y
-	depends on DEBUG_KERNEL
 	help
 	  Some parts of the kernel contain bugs relating to their use of
 	  cryptographically secure random numbers before it's actually possible
-- 
2.13.1
