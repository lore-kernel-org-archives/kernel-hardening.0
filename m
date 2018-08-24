From: Casey Schaufler <casey.schaufler@intel.com>
Subject: [PATCH v4 0/5] LSM: Add and use a hook for side-channel safety checks
Date: Fri, 24 Aug 2018 15:41:12 -0700
Message-Id: <20180824224117.3356-1-casey.schaufler@intel.com>
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, casey.schaufler@intel.com, dave.hansen@intel.com, deneen.t.dock@intel.com, kristen@linux.intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

v4: select namespace checks if user namespaces are enabled
    and credential checks are request.
v3: get_task_cred wasn't a good choice due to refcounts.
    Use lower level protection instead
v2: SELinux access policy corrected.
    Use real_cred instead of cred.

This patchset provide a mechanism by which a security module
can advise the system about potential side-channel vulnerabilities.
If security_safe_sidechannel() returns 0 the security modules do
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
 security/selinux/hooks.c           |   9 ++
 security/sidechannel/Kconfig       |  65 +++++++++++++
 security/sidechannel/Makefile      |   1 +
 security/sidechannel/sidechannel.c | 184 +++++++++++++++++++++++++++++++++++++
 security/smack/smack_lsm.c         |  18 ++++
 12 files changed, 313 insertions(+), 4 deletions(-)
