From: Eddie Kovsky <ewk@edkovsky.org>
Date: Sun, 12 Feb 2017 16:31:38 -0700
Message-Id: <20170212233140.10606-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [RFC] [PATCH 0/2] provide check for ro_after_init memory sections
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, Eddie Kovsky <ewk@edkovsky.org>
List-ID: <kernel-hardening.lists.openwall.com>

Provide a mechansim for other functions to verify that their arguments
are read-only. This implements the first half of a suggestion made by
Kees Cook for the Kernel Self Protection Project:

   * provide mechanism to check for ro_after_init memory areas, and
     reject structures not marked ro_after_init in vmbus_register()

     http://www.openwall.com/lists/kernel-hardening/2017/02/04/1

I have succesfully compiled this series on next-20170206 for x86. I am
not sure how to go about testing these changes (perhpas with LKDTM?).

Eddie Kovsky (2):
  [RFC] [PATCH 1/2] module: verify address is read-only
  [RFC] [PATCH 2/2] extable: verify address is read-only

 include/linux/kernel.h |  2 ++
 include/linux/module.h |  2 ++
 kernel/extable.c       | 31 +++++++++++++++++++++++++++++++
 kernel/module.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+)

--
2.11.1
