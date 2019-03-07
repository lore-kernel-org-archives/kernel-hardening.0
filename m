Date: Thu, 7 Mar 2019 13:25:22 +1100
From: "Tobin C. Harding" <tobin@kernel.org>
Subject: [GIT PULL] leaking_addresses: changes for v5.1-rc1
Message-ID: <20190307022522.GA3942@eros.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tycho Andersen <tycho@tycho.ws>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Linus,

Please consider pulling changes to scripts/leaking_addresses.pl

I've started using my kernel.org email address.  I believe its the key
you care about not the email address this email is sent from, the tag is
signed as usual.

thanks,
Tobin.


The following changes since commit 1c163f4c7b3f621efff9b28a47abb36f7378d783:

  Linux 5.0 (2019-03-03 15:21:29 -0800)

are available in the Git repository at:

  ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git tags/leaks-5.1-rc1

for you to fetch changes up to 9ac060a708e054233265f8febfcef009ac3da826:

  leaking_addresses: Completely remove --version flag (2019-03-07 08:53:18 +1100)

----------------------------------------------------------------
leaking_addresses patches for 5.1-rc1

Here are two super trivial patches to the leaking addresses script for
the 5.1-rc1 merge window.  One fixes the debugging output which is
currently broken in a bunch of places, the other removes the --version
command line option.

Both patches have been tested and sitting in linux-next tree for a month
or so.

Signed-off-by: Tobin C. Harding <tobin@kernel.org>

----------------------------------------------------------------
Tobin C. Harding (2):
      leaking_addresses: Fix calls to dprint
      leaking_addresses: Completely remove --version flag

 scripts/leaking_addresses.pl | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)
