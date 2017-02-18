From: Eddie Kovsky <ewk@edkovsky.org>
Date: Fri, 17 Feb 2017 22:58:41 -0700
Message-Id: <20170218055844.1457-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [PATCH v2 0/3] provide check for ro_after_init memory sections
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide a mechansim for other functions to verify that their arguments
are read-only. Use this mechansim in the vmbus register functions to
reject arguments that fail this test.

This implements a suggestion made by Kees Cook for the Kernel Self
Protection Project:

    * provide mechanism to check for ro_after_init memory areas, and
      reject structures not marked ro_after_init in vmbus_register()

      http://www.openwall.com/lists/kernel-hardening/2017/02/04/1

I have successfully compiled this series on next-20170215 for x86.

Eddie Kovsky (3):
  module: verify address is read-only
  extable: verify address is read-only
  Make vmbus register arguments read-only

 drivers/hv/vmbus_drv.c | 10 ++++++++++
 include/linux/kernel.h |  2 ++
 include/linux/module.h |  7 +++++++
 kernel/extable.c       | 29 +++++++++++++++++++++++++++++
 kernel/module.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 92 insertions(+)

--
2.11.1
