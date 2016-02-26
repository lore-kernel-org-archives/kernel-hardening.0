Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Thu, 25 Feb 2016 16:36:41 -0800
Message-Id: <1456447004-21392-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCHv2 0/3] LKDTM use after free test updates
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

This is v2 of the LKDTM test update. This is mostly taking the updates
Kees gave for the previous series and bringing it in.

Laura Abbott (3):
  lkdtm: Add READ_AFTER_FREE test
  lkdtm: Update WRITE_AFTER_FREE test
  lkdtm: Add read/write after free tests for buddy memory

 drivers/misc/lkdtm.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 95 insertions(+), 3 deletions(-)

-- 
2.5.0
