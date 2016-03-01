Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 1 Mar 2016 14:31:17 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160301223117.GA11371@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PULL] lkdtm update (next)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@fedoraproject.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Please pull these lkdtm changes for next.

Thanks!

-Kees

The following changes since commit 7d46af2084eabe73ce4dbf06072fded34b58b0c7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2016-03-01 08:57:34 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/lkdtm-next

for you to fetch changes up to 7c0ae5be821c1b6a700c5506de9b62e95f60df3c:

  lkdtm: improve use-after-free tests (2016-03-01 14:29:16 -0800)

----------------------------------------------------------------
Become maintainer, add hardening tests for use-after-free and atomic wrapping.

----------------------------------------------------------------
David Windsor (1):
      lkdtm: add test for atomic_t underflow/overflow

Kees Cook (2):
      MAINTAINERS: add myself as lkdtm maintainer
      lkdtm: improve use-after-free tests

Laura Abbott (3):
      lkdtm: Add READ_AFTER_FREE test
      lkdtm: Update WRITE_AFTER_FREE test
      lkdtm: Add read/write after free tests for buddy memory

 MAINTAINERS          |   5 +++
 drivers/misc/lkdtm.c | 122 +++++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 124 insertions(+), 3 deletions(-)

-- 
Kees Cook
Chrome OS & Brillo Security
