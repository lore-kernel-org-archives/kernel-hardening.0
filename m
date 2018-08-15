From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH RFC 0/5] LSM: Add and use a hook for side-channel safety checks
Date: Wed, 15 Aug 2018 16:53:50 -0700
Message-Id: <20180815235355.14908-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, SMACK-discuss@lists.01.org, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

This patchset provide a mechanism by which a security module
can advise the system about potential side-channel vulnerabilities.
If security_task_safe_sidechannel() returns 0 the security modules do
not know of any data that would be subject to a side-channel
attack. If the security module maintains data that it believes
may be susceptible to a side-channel attack it will return -EACCES.

Simple hooks are provided for SELinux and Smack. A new security
module is provided to make determinations regarding traditional
task attributes, including user IDs, capability sets and namespaces.

Signed-off-by: Casey Schaufler <casey.schaufler@intel.com>

---
 MAINTAINERS                        |   6 ++
 arch/x86/mm/tlb.c                  |  12 ++-
 include/linux/lsm_hooks.h          |  12 +++
 include/linux/security.h           |   1 +
 security/Kconfig                   |   1 +
 security/Makefile                  |   2 +
 security/security.c                |   6 ++
 security/selinux/hooks.c           |   9 +++
 security/sidechannel/Kconfig       |  60 ++++++++++++++
 security/sidechannel/Makefile      |   1 +
 security/sidechannel/sidechannel.c | 156 +++++++++++++++++++++++++++++++++++++
 security/smack/smack_lsm.c         |  18 +++++
 12 files changed, 280 insertions(+), 4 deletions(-)
