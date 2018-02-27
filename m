From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 3/3] leaking_addresses: remove version number
Date: Tue, 27 Feb 2018 15:45:11 +1100
Message-Id: <1519706711-18580-4-git-send-email-me@tobin.cc>
In-Reply-To: <1519706711-18580-1-git-send-email-me@tobin.cc>
References: <1519706711-18580-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

We have git now, we don't need a version number.  This was originally
added because leaking_addresses.pl shamelessly (and mindlessly) copied
checkpatch.pl

Remove version number from script.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 scripts/leaking_addresses.pl | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index ac84a164a528..d5d31f3df97e 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -31,7 +31,6 @@ use bigint qw/hex/;
 use feature 'state';
 
 my $P = $0;
-my $V = '0.01';
 
 # Directories to scan.
 my @DIRS = ('/proc', '/sys');
@@ -85,7 +84,6 @@ sub help
 	print << "EOM";
 
 Usage: $P [OPTIONS]
-Version: $V
 
 Options:
 
-- 
2.7.4
