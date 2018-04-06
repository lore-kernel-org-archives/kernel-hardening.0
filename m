Date: Sat, 7 Apr 2018 09:55:56 +1000
From: "Tobin C. Harding" <me@tobin.cc>
Subject: [GIT PULL] leaking_addresses: changes for 14.17-rc1
Message-ID: <20180406235556.GA8365@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

This is your favourite noob maintainer requesting that you pretty please
with sugar on top pull the leaking_addresses patch set.

I have hopefully lifted my game after the abysmal effort last merge
window.  The script now actually runs in an acceptable time, the tree is
on kernel.org and I have convinced another (more experienced) kernel
hacker to cast an eye over things.

All patches have been in linux-next since about half way through last
dev cycle and testing was done on x86_64, ARM (32 bit), and PowerPC.

thanks,
Tobin.


The following changes since commit 0adb32858b0bddf4ada5f364a84ed60b196dbcda:

  Linux 4.16 (2018-04-01 14:20:27 -0700)

are available in the git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git tags/leaks-4.17-rc1

for you to fetch changes up to e875d33d7f06d1107c057d12bb5aaba84738e418:

  MAINTAINERS: Update LEAKING_ADDRESSES (2018-04-07 09:35:37 +1000)

----------------------------------------------------------------
Leaking-addresses patches for 4.17-rc1

Here is the patch set for the 4.17-rc1 merge window.  This set
represents improvements to the scripts/leaking_addresses.pl script.  The
major improvement is that with this set applied the script actually runs
in a reasonable amount of time (less than a minute on a standard stock
Ubuntu user desktop).  Also, we have a second maintainer now and a tree
hosted on kernel.org

We do a few code clean ups.  We fix the command help output.  Handling
of the vsyscall address range is fixed to check the whole range instead
of just the start/end addresses.  We add support for 5 page table levels
(suggested on LKML).  We use a system command to get the machine
architecture instead of using Perl.  Calling this command for every
regex comparison is what previously choked the script, caching the
result of this call gave the major speed improvement.  We add support
for scanning 32-bit kernels using the user/kernel memory split.  Path
skipping code refactored and simplified (meaning easier script
configuration).  We remove version numbering.  We add a variable name to
improve readability of a regex and finally we check filenames for
leaking addresses.

Currently script scans /proc/PID for all PID.  With this set applied we
only scan for PID==1. It was observed that on an idle system files under
/proc/PID are predominantly the same for all processes.  Also it was
noted that the script does not scan _all_ the kernel since it only scans
active processes.  Scanning only for PID==1 makes explicit the inherent
flaw in the script that the scan is only partial and also speeds things up.

Signed-off-by: Tobin C. Harding <me@tobin.cc>

----------------------------------------------------------------
Tobin C. Harding (19):
      leaking_addresses: fix typo function not called
      leaking_addresses: remove mention of kptr_restrict
      leaking_addresses: remove command examples
      leaking_addresses: indent dependant options
      leaking_addresses: add range check for vsyscall memory
      leaking_addresses: add support for kernel config file
      leaking_addresses: add support for 5 page table levels
      leaking_addresses: use system command to get arch
      leaking_addresses: add is_arch() wrapper subroutine
      leaking_addresses: add 32-bit support
      leaking_addresses: do not parse binary files
      leaking_addresses: simplify path skipping
      leaking_addresses: cache architecture name
      leaking_addresses: skip all /proc/PID except /proc/1
      leaking_addresses: skip '/proc/1/syscall'
      leaking_addresses: remove version number
      leaking_addresses: explicitly name variable used in regex
      leaking_addresses: check if file name contains address
      MAINTAINERS: Update LEAKING_ADDRESSES

 MAINTAINERS                  |   3 +
 scripts/leaking_addresses.pl | 372 ++++++++++++++++++++++++++++++-------------
 2 files changed, 262 insertions(+), 113 deletions(-)
