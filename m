From: Matt Brown <matt@nmatt.com>
Date: Wed,  7 Jun 2017 23:43:48 -0400
Message-Id: <20170608034349.31876-1-matt@nmatt.com>
Subject: [kernel-hardening] [PATCH v2 0/1]  Add Trusted Path Execution as a stackable LSM
To: james.l.morris@oracle.com, serge@hallyn.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Trusted Path Execution (TPE)

Patch Versions:

v1:
* initial patch introduction

v2:
* included copyright notice from Brad Spengler and Corey Henderson
* reversed the invert_gid logic. tpe.gid now defaults to being the
  trusted group rather than the untrusted group.
* fixed race condition by taking reference to the parent dentry
* added sysctl tpe.restrict_root that includes the root user in TPE checks
* added mprotect and mmap restrictions from Corey Henderson tpe-lkm
  project
* added documentation file

This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
feature. It also adds features and config options that were found in Corey
Henderson's tpe-lkm project.

Modifications from Brad Spengler's implementation of TPE were made to
turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
Also, a new denial logging function was used to simplify printing messages
to the kernel log. Additionally, mmap and mprotect restrictions were
taken from Corey Henderson's tpe-lkm project and implemented using the
LSM hooks mmap_file and file_mprotect.

Trusted Path Execution is not a new idea:

http://phrack.org/issues/52/6.html#article

| A trusted path is one that is inside a root owned directory that
| is not group or world writable.  /bin, /usr/bin, /usr/local/bin, are
| (under normal circumstances) considered trusted.  Any non-root
| users home directory is not trusted, nor is /tmp.

To be clear, Trusted Path Execution is no replacement for a MAC system
like SELinux, SMACK, or AppArmor. This LSM is designed to be good enough
without requiring a userland utility to configure policies. The fact
that TPE only requires the user to turn on a few sysctl options lowers
the barrier to implementing a security framework substantially.

Threat Models:

1. Attacker on system executing exploit on system vulnerability

*  If attacker uses a binary as a part of their system exploit, TPE can
   frustrate their efforts

*  This protection can be more effective when an attacker does not yet
   have an interactive shell on a system

*  Issues:
   *  Can be bypassed by interpreted languages such as python. You can run
      malicious code by doing: python -c 'evil code'

2. Attacker on system replaces binary used by a privileged user with a
   malicious one

*  This situation arises when the administrator of a system leaves a
   binary as world writable.

*  TPE is very effective against this threat model

Documentation/security/tpe.txt |  59 +++++++++++
 MAINTAINERS                    |   5 +
 include/linux/lsm_hooks.h      |   5 +
 security/Kconfig               |   1 +
 security/Makefile              |   2 +
 security/security.c            |   1 +
 security/tpe/Kconfig           |  64 ++++++++++++
 security/tpe/Makefile          |   3 +
 security/tpe/tpe_lsm.c         | 218 +++++++++++++++++++++++++++++++++++++++++
