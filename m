From: P J P <ppandit@redhat.com>
Subject: [PATCH 0/1] Zero initialise kernel stack variables
Date: Tue, 27 Feb 2018 16:45:31 +0530
Message-Id: <20180227111532.1144-1-ppandit@redhat.com>
To: kernel-hardening@lists.openwall.com
Cc: Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: P J P <pjp@fedoraproject.org>

Hello,

Please see:
  -> https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html

This experimental patch by Florian Weimer(CC'd) adds an option
'-finit-local-vars' to gcc(1) compiler. When a program(or kernel)
is built using this option, its automatic(local) variables are
initialised with zero(0). This could significantly reduce the kernel
information leakage issues.

A dnf(8) repository of the latest gcc-7.3.1 package built with the above
patch and kernel-4.15.5 package built using '-finit-local-vars' option
on Fedora-27 is available below

  -> https://pjp.fedorapeople.org/init-vars/

This same kernel is running on my F27 test machine as I write this.
There is no slowness or notice-able performance impact as such.

The patch here adds a kbuild menu option to enable/disable '-finit-local-vars'
compiler flag while building the Linux kernel.

I'd appreciate your review and/or inputs to test this option further.

Thank you.
--
Prasad J Pandit / Red Hat Product Security Team (1):
  Add an option to build kernel with -finit-local-vars

 Makefile          | 4 ++++
 lib/Kconfig.debug | 8 ++++++++
 2 files changed, 12 insertions(+)

-- 
2.14.3
