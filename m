From: Eddie Kovsky <ewk@edkovsky.org>
Date: Wed,  5 Apr 2017 21:35:48 -0600
Message-Id: <20170406033550.32525-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [PATCH v5 0/2] provide check for ro_after_init memory sections
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Provide a mechanism for other functions to verify that their arguments
are read-only.

This implements the first half of a suggestion made by Kees Cook for
the Kernel Self Protection Project:

    - provide mechanism to check for ro_after_init memory areas, and
      reject structures not marked ro_after_init in vmbus_register()

      http://www.openwall.com/lists/kernel-hardening/2017/02/04/1

The idea is to prevent structures (including modules) that are not
read-only from being passed to functions. It builds upon the functions
in kernel/extable.c that test if an address is in the text section.

A build failure on the Blackfin architecture led to the discovery of
an incomplete definition of the RO_DATA macro used in this series. The
fixes are in linux-next:

	commit 906f2a51c941 ("mm: fix section name for .data..ro_after_init")

	commit 939897e2d736 ("vmlinux.lds: add missing VMLINUX_SYMBOL macros")

The latest version of this series uses new symbols provided in these
fixes. The series now cross compiles on Blackfin without errors. I have
also test compiled this series on next-20170405 for x86.

I have dropped the third patch that uses these features to check the
arguments to vmbus_register() because the maintainers have not been
receptive to using it. My goal right now is to get the API right.

Eddie Kovsky (2):
  module: verify address is read-only
  extable: verify address is read-only

 include/linux/kernel.h |  2 ++
 include/linux/module.h | 12 ++++++++++++
 kernel/extable.c       | 29 +++++++++++++++++++++++++++
 kernel/module.c        | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)

-- 
2.12.2
