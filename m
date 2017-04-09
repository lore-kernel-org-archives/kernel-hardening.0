From: Djalal Harouni <tixxdz@gmail.com>
Date: Sun,  9 Apr 2017 12:42:07 +0200
Message-Id: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH RFC v2 0/3] security: Add ModAutoRestrict LSM
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi List,

This is RFC v2 of the Module auto-loading restriction feature. The
module has been renamed ModAutoRestrict LSM.

This RFC is a work in progress update.

There are still minor things to fix which are listed in the TODO
section. Also I used Tetsuo approach of stacking task->security, since
now that the task_security_alloc() hook is in linux-security/next I took
advantage of it and switched to use that hook and applied Tetsuo
task->security per LSM blob on top of it. I can also switch to Casey
approach. However, since these are internal implementation details which
are not exposed, I do not think that this is a big issue. Thanks for the
work now it is clear that we are able to easily stack new LSMs.

Patches are against linux-security/next HEAD 622f6e3265707eb

==============

ModAutoRestrict is a Linux Security Module that applies restrictions on
automatic module loading operations. This is selectable at build-time
with CONFIG_SECURITY_MODAUTORESTRICT, and can be controlled at run-time
through sysctls in /proc/sys/kernel/modautorestrict/autoload or as a
per-process setting via a prctl() interface.

A userspace request to use a kernel feature that is implemented by modules
that are not loaded may trigger the module auto-load feature to load
these modules in order to satisfy userspace. However as today's Linux use
cases cover embedded systems to containers where applications are running
in their own separate environments, reducing or preventing operations
that may affect external environments is an important constraint.
Therefore, we need a way to control if automatic module loading is
allowed or which applications are allowed to trigger the module
auto-load feature.

The ModAutoRestrict LSM allows system administrators or sandbox
mechanisms to control the module auto-load feature and prevent loading
unneeded modules or abuse the interface.

The settings can be applied globally using a sysctl interface which
completes the core kernel interface "modules_disable".

The feature is also available as a prctl() interface. This allows to
apply restrictions when sandboxing processes. On embedded Linux systems,
or containers where only some containers/processes should have the
right privileges to load modules, this allows to restrict those
processes from inserting modules. Only privileged processes can be
allowed to perform so. A more restrictive access can be applied where
the module autoload feature is completely disabled.
In this schema the access rules are per-process and inherited by
children created by fork(2) and clone(2), and preserved across execve(2).

Interface:

*) The per-process prctl() settings are:

 prctl(PR_MOD_AUTO_RESTRICT_OPTS, PR_SET_MOD_AUTO_RESTRICT, value, 0, 0)

 Where value means:

 0 - Classic module auto-load permissions, nothing changes.

 1 - The current process must have CAP_SYS_MODULE to be able to
     auto-load modules. CAP_NET_ADMIN should allow to auto-load
     modules with a 'netdev-%s' alias.

 2 - Current process can not auto-load modules. Once set, this prctl
     value can not be changed.

 The per-process value may only be increased, never decreased, thus ensuring
 that once applied, processes can never relaxe their setting.

*) The global sysctl setting can be set by writting an integer value to
   '/proc/sys/kernel/modautorestrict/autoload'

 The valid values are:

 0 - Classic module auto-load permissions, nothing changes.

 1 - Processes must have CAP_SYS_MODULE to be able to auto-load modules.
     CAP_NET_ADMIN should allow to auto-load modules with a 'netdev-%s'
     alias.

 2 - Processes can not auto-load modules. Once set, this sysctl value
     can not be changed.

*) Access rules:
   First the prctl() settings are checked, if the access is not denied
   then the global sysctl settings are checked.

The original idea and inspiration is from grsecurity 'GRKERNSEC_MODHARDEN'.


The sample code here can be used to test the feature:
https://gist.githubusercontent.com/tixxdz/39a583358f04d40b4d3e5571f95c075b/raw/7fb416285412891e2637fba149da930fe0898356/modautorestrict_test.c

# TODO list:
*) Confirm the struct task_struct->security stacking mechanism. 
*) Add a logging mechanism.
*) Remove the use of security_kernel_read_file hook. Use only
   security_kernel_module_request and make sure that we cover all cases.
*) Convert documentation to .rst


# Changes since v1:
*) Renamed module to ModAutoRestrict
*) Improved documentation to explicity refer to module autoloading.
*) Switched to use the new task_security_alloc() hook.
*) Switched from rhash tables to use task->security since it is in
   linux-security/next branch now.
*) Check all parameters passed to prctl() syscall.
*) Many other bug fixes and documentation improvements.

All Kees Cook comments handled, except for the removing of
security_kernel_read_file which I will do in next iteration when
I make sure that I did not miss something. Thank you!


Tetsuo Handa (1):
        LSM: Allow per LSM module per "struct task_struct" blob

Djalal Harouni (2):
        security: add the ModAutoRestrict Linux Security Module
        Documentation: add ModAutoRestrict LSM documentation


 Documentation/security/00-INDEX            |   2 +
 Documentation/security/ModAutoRestrict.txt |  77 ++++++
 MAINTAINERS                                |   7 +
 include/linux/lsm_hooks.h                  |  41 +++-
 include/uapi/linux/prctl.h                 |   5 +
 security/Kconfig                           |   1 +
 security/Makefile                          |  16 +-
 security/modautorestrict/Kconfig           |  15 ++
 security/modautorestrict/Makefile          |   3 +
 security/modautorestrict/modauto_lsm.c     | 372 +++++++++++++++++++++++++++++
 security/security.c                        |  38 ++-
 11 files changed, 568 insertions(+), 9 deletions(-)
