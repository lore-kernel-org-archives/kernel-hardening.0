Reply-To: kernel-hardening@lists.openwall.com
From: Laura Abbott <labbott@fedoraproject.org>
Date: Mon, 22 Feb 2016 17:27:50 -0800
Message-Id: <1456190872-30828-1-git-send-email-labbott@fedoraproject.org>
Subject: [kernel-hardening] [PATCH 0/2] LKDTM test updates
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Per the suggestion of Kees, I added tests for read/write after free on
buddy memory as well as slab memory. I combined the two into one
series for ease of dependencies and review.

Laura Abbott (2):
  lkdtm: Add READ_AFTER_FREE test
  lkdtm: Add read/write after free tests for buddy memory

 drivers/misc/lkdtm.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

-- 
2.5.0
