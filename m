Date: Wed, 15 Feb 2017 00:15:32 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
Message-ID: <alpine.LRH.2.20.1702150003580.29914@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] [RFC v2 PATCH 0/2] security: mark LSM hooks with __ro_after_init
To: linux-security-module@vger.kernel.org
Cc: selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Updated and simplified down to two patches.

Following feedback from the list, I've added a new config option to handle 
the case where SELinux still needs to disable its hooks at runtime (and 
thus the hooks must be writable in that case).

I've dropped the Netfilter hooks patch as I realized that the hook ops 
list structures could be modified after init by the core NF code.

The SELinux Netlink message patch has been merged, and Mimi is reviewing 
the IMA default policy patch (it's not affected by LSM hook requirements 
and can be merged separately).

---

James Morris (2):
  security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
  security: mark LSM hooks as __ro_after_init

 include/linux/lsm_hooks.h  |    7 +++++++
 security/Kconfig           |    5 +++++
 security/apparmor/lsm.c    |    2 +-
 security/commoncap.c       |    2 +-
 security/loadpin/loadpin.c |    2 +-
 security/security.c        |    2 +-
 security/selinux/Kconfig   |    6 ++++++
 security/selinux/hooks.c   |    2 +-
 security/smack/smack_lsm.c |    2 +-
 security/tomoyo/tomoyo.c   |    2 +-
 security/yama/yama_lsm.c   |    2 +-
 11 files changed, 26 insertions(+), 8 deletions(-)
