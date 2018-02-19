From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 0/4] leaking_addresses: simplify and optimize
Date: Mon, 19 Feb 2018 13:50:45 +1100
Message-Id: <1519008649-15782-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

leaking_addresses.pl is currently woefully slow.  This series fixes
that.  Also, currently configuring which files/directories to skip is
overly complicated.  We can simplify the code configuration quite easily
by combining the configuration arrays.

This series does not apply on top of the mainline but is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git leaks-testing


thanks,
Tobin.

Tobin C. Harding (4):
  leaking_addresses: do not parse binary files
  leaking_addresses: simplify path skipping
  leaking_addresses: cache architecture name
  leaking_addresses: add scan_once array

 scripts/leaking_addresses.pl | 125 ++++++++++++++++++++++---------------------
 1 file changed, 64 insertions(+), 61 deletions(-)

-- 
2.7.4
