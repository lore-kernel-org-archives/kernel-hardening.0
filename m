Date: Mon, 13 Feb 2017 16:31:40 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
Message-ID: <alpine.LRH.2.20.1702131625430.8914@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] [RFC PATCH 0/4] ro hardening for the security subsystem
To: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Folks,

Please review/test these patches which add some read-only hardening to the 
security subsystem.

In this series, the following are marked as __ro_after_init:

- LSM hooks
- Netfilter hooks used by security/
- the default IMA rules

I've also constified the SELinux Netlink permission tables, which will 
ensure they're located in an RO section.

---

James Morris (4):
  security: mark LSM hooks as __ro_after_init
  security: mark nf ops in SELinux and Smack as __ro_after_init
  integrity: mark default IMA rules as __ro_after_init
  selinux: constify nlmsg permission tables

 security/apparmor/lsm.c             |    2 +-
 security/commoncap.c                |    2 +-
 security/integrity/ima/ima_policy.c |    8 ++++----
 security/loadpin/loadpin.c          |    2 +-
 security/security.c                 |    2 +-
 security/selinux/hooks.c            |    4 ++--
 security/selinux/nlmsgtab.c         |   10 +++++-----
 security/smack/smack_lsm.c          |    2 +-
 security/smack/smack_netfilter.c    |    2 +-
 security/tomoyo/tomoyo.c            |    2 +-
 security/yama/yama_lsm.c            |    2 +-
 11 files changed, 19 insertions(+), 19 deletions(-)


-- 
James Morris
<jmorris@namei.org>
