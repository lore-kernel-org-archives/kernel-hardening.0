From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 0/2] leaking_addresses: check path name for leaks
Date: Fri,  2 Mar 2018 09:03:18 +1100
Message-Id: <1519941800-27710-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

A couple more patches to the leaking_addresses.pl script.  First one is
refactor, does not change program logic.

Patch 2 adds a check on each path name as the scan traverses the
directory tree.  Suggested by Tycho.

thanks,
Tobin.

Tobin C. Harding (2):
  leaking_addresses: explicitly name variable used in regex
  leaking_addresses: check if file name contains address

 scripts/leaking_addresses.pl | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

-- 
2.7.4
