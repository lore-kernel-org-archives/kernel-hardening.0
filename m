From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 0/3] leaking_addresses: limit scan to PID==1
Date: Tue, 27 Feb 2018 15:45:08 +1100
Message-Id: <1519706711-18580-1-git-send-email-me@tobin.cc>
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

This set implements improvements discussed offline with Tycho as well as
from suggestions on LKML.

We no longer bother to scan /proc/PID for every PID on the system.
Instead we only scan /proc/1 (still scan other non-pid related
files/directoies).  The reasoning is given in the commit log of patch 1,
duplicated here for reference:

	When the system is idle it is likely that most files under
	/proc/PID will be identical for various processes.  Scanning
	_all_ the PIDs under /proc is unnecessary and implies that we
	are thoroughly scanning /proc. This is _not_ the case because
	there may be ways userspace can trigger creation of /proc files
	that leak addresses but were not present during a scan.  For
	these two reasons we should exclude all PID directories under
	/proc except '1/' 
    
Next, we skip parsing /proc/1/syscall as suggested because the pointers
listed are user pointers, and negative syscall args will show up like
kernel pointers.

Finally we remove version number from the script.

This set represents the tip of the branch 'leaks-testing' available at

	git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git


thanks,
Tobin.


Tobin C. Harding (3):
  leaking_addresses: skip all /proc/PID except /proc/1
  leaking_addresses: skip '/proc/1/syscall'
  leaking_addresses: remove version number

 scripts/leaking_addresses.pl | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

-- 
2.7.4
