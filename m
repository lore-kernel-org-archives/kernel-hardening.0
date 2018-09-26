From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v5 0/5] LSM: Support ptrace sidechannel access checks
Date: Wed, 26 Sep 2018 13:34:41 -0700
Message-Id: <20180926203446.2004-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

v5: Revamped to match Jiri Kosina <jkosina@suse.cz>
    Harden spectrev2 userspace-userspace protection v7
    Fixed locking issues in the LSM code.
    Dropped the new LSM hook and use a ptrace hook instead.
v4: select namespace checks if user namespaces are enabled
    and credential checks are request.
v3: get_task_cred wasn't a good choice due to refcounts.
    Use lower level protection instead
v2: SELinux access policy corrected.
    Use real_cred instead of cred.

This patchset provide a mechanism by which a security module
can advise the system about potential side-channel vulnerabilities.
The existing security modules have been updated to avoid locking
issues in the face of PTRACE_MODE_SCHED. A new security
module is provided to make determinations regarding task attributes
including namespaces.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>
---
 include/linux/lsm_hooks.h          |  5 +++
 kernel/ptrace.c                    |  2 -
 security/Kconfig                   |  1 +
 security/Makefile                  |  2 +
 security/apparmor/domain.c         |  2 +-
 security/apparmor/include/ipc.h    |  2 +-
 security/apparmor/ipc.c            |  8 ++--
 security/apparmor/lsm.c            |  5 ++-
 security/commoncap.c               |  2 +
 security/security.c                |  1 +
 security/selinux/hooks.c           |  2 +
 security/sidechannel/Kconfig       | 13 ++++++
 security/sidechannel/Makefile      |  1 +
 security/sidechannel/sidechannel.c | 88 ++++++++++++++++++++++++++++++++++++++
 security/smack/smack_lsm.c         |  3 +-
 15 files changed, 127 insertions(+), 10 deletions(-)
