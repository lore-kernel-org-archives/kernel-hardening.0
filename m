From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <59cec608-608e-6de6-21d9-bdec7b0ded3b@schaufler-ca.com>
Date: Thu, 8 Jun 2017 13:43:10 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH 0/6] LSM: Security module blob management
To: LSM <linux-security-module@vger.kernel.org>, James Morris <jmorris@namei.org>
Cc: John Johansen <john.johansen@canonical.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Kees Cook <keescook@chromium.org>, Casey Schaufler <casey@schaufler-ca.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKLM <linux-kernel@vger.kernel.org>Casey Schaufler <casey@schaufler-ca.com>
List-ID: <kernel-hardening.lists.openwall.com>

Subject: [PATCH 0/6] LSM: Security module blob management

This patch set moves management of security blobs out of
the Linux security modules and into the security module
infrastructure. This allows "major" security modules that
use blobs to be stacked, just as "minor" modules that
do not use blobs can be stacked today. It stops short of
providing a safe interface for the Netlabel and SO_PEERSEC.
As a result, any of the existing security modules may be
used in combination except for SELinux and Smack.

The result passes the SELinux testsuite for the significant
number of configurations tried, and fails none of them.
Smack tests went swimmingly as well. AppArmor was boot
tested with Ubuntu 17.04.

There is work in a separate project to make Smack a better
user of the Netlabel subsystem, which is needed to allow
for a rational Netlabel configuration when both SELinux
and Smack are active at the same time. That will be the
next phase of the stacking project, and is nearing
completion. I stopped short of including that work here
because it's not required by any of the new security
modules that I know are waiting for "major" stacking.

Patch 1/6: Creates a subdir for Smack in /proc/.../attr.
           This has been submitted as an enhancement for
           Smack, as it cleans up Smack userspace.
Patch 2/6: Introduces infrastructure management of the
           credential (cred->security) blob
Patch 3/6: Introduces infrastructure management of the
           file (file->f_security) blob
Patch 4/6: Introduces infrastructure management of the
           new task (task->security) blob
Patch 5/6: Introduces infrastructure management of the
           remaining security blobs, including the inode,
           socket, superblock and IPC object blobs.
Patch 6/6: Changes the Kconfig in the security subsystem
           to define a module stack instead of a choice
           of a single module. Adds /proc/.../attr
           subdirectories for AppArmor and SELinux. Adds
           a "context" attr file to provide a combined
           view of the process security attributes.

These patches can be found in git at:

	https://github.com/cschaufler/smack-next.git#stacking-4.12-rc2

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
---
 Documentation/security/LSM.txt      |  33 +-
 fs/proc/base.c                      |  96 +++++-
 fs/proc/internal.h                  |   1 +
 include/linux/lsm_hooks.h           |  26 +-
 include/linux/security.h            |  15 +-
 kernel/cred.c                       |  13 -
 security/Kconfig                    | 105 +++++++
 security/apparmor/context.c         |   2 -
 security/apparmor/include/context.h |  25 +-
 security/apparmor/lsm.c             | 111 ++++---
 security/security.c                 | 587 +++++++++++++++++++++++++++++++++++-
 security/selinux/hooks.c            | 513 +++++++++++--------------------
 security/selinux/include/objsec.h   |  87 +++++-
 security/selinux/netlabel.c         |  15 +-
 security/selinux/selinuxfs.c        |   5 +-
 security/selinux/ss/services.c      |   3 +-
 security/selinux/xfrm.c             |   4 +-
 security/smack/smack.h              |  90 +++++-
 security/smack/smack_access.c       |   2 +-
 security/smack/smack_lsm.c          | 526 +++++++++++---------------------
 security/smack/smack_netfilter.c    |   8 +-
 security/smack/smackfs.c            |  18 +-
 security/tomoyo/common.h            |  30 +-
 security/tomoyo/domain.c            |   4 +-
 security/tomoyo/securityfs_if.c     |  13 +-
 security/tomoyo/tomoyo.c            |  52 +++-
 26 files changed, 1540 insertions(+), 844 deletions(-)
