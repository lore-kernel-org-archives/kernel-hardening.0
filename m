Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Fri, 29 Jul 2016 10:34:35 +0300
Message-Id: <1469777680-3687-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFC] [PATCH 0/5] Hardchroot LSM + additional hooks
To: kernel-hardening@lists.openwall.com
Cc: linux-security-module@vger.kernel.org, keescook@chromium.org, spender@grsecurity.net, jmorris@namei.org, casey.schaufler@intel.com, michael.leibowitz@intel.com, william.c.roberts@intel.com, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This introduces a new Hardchroot LSM that is
based on GRKERNSEC_CHROOT feature, as well
as couple of new LSM hooks needed for its
operation.

The Hardchroot is implemented as LSM in
order to better fit the upstream kernel
design, as well as coexist with other
security subsystems. The Hardchroot LSM
is a minor LSM, and can easily be stacked
with other major and minor LSMs.

Chroot is still quite widely used in Linux
for jailing some system daemons (despite
its security limitations), and therefore
having an LSM that can be used to make
such jails more secure can bring value.
For more information about Harchroot and
its features, see commit message on
Patch 5.

In order to implement certain features of
Hardchroot, it was necessary to create
additional LSM hooks. If there is a way to
achieve the same functionality with
existing hooks, the implementation can be
easily adjusted.

Elena Reshetova (5):
  path_fchdir and path_fhandle LSM hooks
  task_unshare LSM hook
  sb_unsharefs LSM hook
  invoke path_chroot() LSM hook on mntns_install()
  Hardchroot LSM

 fs/fhandle.c                         |   5 +
 fs/fs_struct.c                       |   7 +-
 fs/namespace.c                       |  15 +-
 fs/open.c                            |   3 +
 include/linux/lsm_hooks.h            |  37 ++
 include/linux/security.h             |  19 +
 kernel/fork.c                        |   5 +
 security/Kconfig                     |   1 +
 security/Makefile                    |   2 +
 security/hardchroot/Kconfig          |  10 +
 security/hardchroot/Makefile         |   3 +
 security/hardchroot/hardchroot_lsm.c | 654 +++++++++++++++++++++++++++++++++++
 security/security.c                  |  30 ++
 13 files changed, 786 insertions(+), 5 deletions(-)
 create mode 100644 security/hardchroot/Kconfig
 create mode 100644 security/hardchroot/Makefile
 create mode 100644 security/hardchroot/hardchroot_lsm.c

-- 
1.9.1
