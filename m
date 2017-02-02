From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu,  2 Feb 2017 18:04:51 +0100
Message-Id: <1486055094-4532-1-git-send-email-djalal@gmail.com>
Subject: [kernel-hardening] [RFC/PATCH 0/3] introduce Timgad LSM
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Djalal Harouni <tixxdz@gmail.com>

Hi list,

This RFC introduces Timgad a Linux Security Module that adds restrictions
on module load and unload operations. The original idea and inspiration is
from grsecurity 'GRKERNSEC_MODHARDEN'. However this was adapted to fit
more as an LSM and also to fit today's Linux containers/embedded use cases.

Originally I had this code as part of Linux Yama module, however after
some discussions with Kees Cook mainainer of Yama, he proposed that I
should split the code on its own module and send it for discussion.

The module supports a system-wide security protection but also a per
processes/containers one using prctl() interface.

The module is selectable at build-time with CONFIG_SECURITY_TIMGAD, and can be
controlled at run-time through sysctls in /proc/sys/kernel/timgad/ or
prctl() interface. The prctl(2) settings are inherited by children created by
fork(2) and clone(2), and preserved across execve(2).


(The following is not fully implemented, and it still has bugs, as
 this is a preliminary RFC, the permission details, and sure other
 things have to be discussed before we proceed further, any positive
 feedback is welcome).


*) The per-process prctl() settings are:
    prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)

    Where value means:

0 - Classic module load and unload permissions, nothing changes.

1 - The current process must have CAP_SYS_MODULE to be able to load and
    unload modules. CAP_NET_ADMIN should allow the current process to
    load and unload only netdev aliased modules, not implemented

2 - Current process can not loaded nor unloaded modules.


*) The sysctl settings (writable only with CAP_SYS_MODULE) are:
        /proc/sys/kernel/timgad/module_restrict

0 - Classic module load and unload permissions, nothing changes.

1 - Only processes with CAP_SYS_MODULE should be able to load and
    unload modules. Processes with CAP_NET_ADMIN should be able to
    load and unload only netdev aliased modules, this is
    currently not implemented...

    (This should be improved)

2 - Modules can not be loaded nor unloaded. Once set, this sysctl value
    cannot be changed.

    
Rules:
First the prctl() settings are checked, if the access is not denied
then the global sysctl settings are checked.


Patches tested against 4.10-rc6 (next didn't boot for me).

The sample code here can be used to test the feature:
https://gist.github.com/tixxdz/f7d1eadd4728b6aec00b8c2438411b15
https://gist.githubusercontent.com/tixxdz/f7d1eadd4728b6aec00b8c2438411b15/raw/07452c73ea23b930d5a2ab9578ac53bf406a91a2/timgad_test.c


Patches:
  [1/3] security: add the security_task_copy() hook
  [2/3] security: Add the Timgad module
  [3/3] doc: add Timgad LSM documentation

TODO list:
*) Change the name of the module ?

*) Benchmark and improve rhash table.

*) Support unload and module_finit logic

*) Separate rhash tables by first task that sets the flags, childs go in.
   Then if we have multiple tables schedule next one on the global
   default one. This helps containers case and avoids stretches.

*) Make sure that task_struct are not re-used between put_ref() and
   the free work.

-- 
2.5.5
