From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu, 20 Apr 2017 00:20:18 +0200
Message-Id: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH v3 0/2] modules:capabilities: automatic module loading restrictions
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, zendyani@gmail.com, Peter Zijlstra <peterz@infradead.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi List,

This is an update of the previous two RFCs that implemented module
auto-load restriction as a stackable LSM [1] [2].

The previous versions were presented as a stackable LSM, this new
version is implemented as a core kernel feature inside the capability
subsystem.

This new version is clean and smaller compared to previous versions.
Kees Cook suggested to implement this as a core kernel feature so it is
easy to enable and to be more consistent with "modules_disabled" sysctl
that restrict all module operations.

These patches are against next-20170419

==============

Currently, an explicit call to load or unload kernel modules require
CAP_SYS_MODULE capability. However unprivileged users have always been
able to load some modules using the implicit auto-load operation. An
automatic module loading happens when programs request a kernel feature
from a module that is not loaded. In order to satisfy userspace, the
kernel then automatically load all these required modules.

However, some programs may abuse the interface to load vulnerable or
buggy modules where system administrators still did not have a chance to
blacklist these modules. This affects the global state of the machine,
especially with containers where some applications may use it to exploit
the vulnerable parts and escape the container sandbox. Not to mention
that some devices which one may call IoT also started to use containers
semantics as a deployment workflow, but as an isolation tool too where the
base system image can be any generic distro or other root filesystem with
its own kernel. These setups may include unnecessary modules that the
final applications will not need. Untrusted access may abuse the module
auto-load feature to expose those vulnerabilities.

As every code contains bugs or vulnerabilties, the following
vulnerabilities that affected some features that are often compiled as
modules could have been completely blocked, by restricting autoloading
modules if the system does not need them.

Past months:
* DCCP use after free CVE-2017-6074
* n_hldc CVE-2017-2636
* XFRM framework CVE-2017-7184
* L2TPv3 CVE-2016-10200

Some of these bugs where advertised, websites claim that they have been
used against some distros in security contests. Other devices may also
be subject to such abuses, so lets protect our systems.


This patch introduces "modules_autoload" kernel sysctl flag. The flag
controls modules auto-load feature and complements "modules_disabled" which
apply to all modules operations. This new flag allows to control only
automatic module loading and if it is allowed or not. This allows to
align implicit module loading with the explicit one where both now are
covered by capabilities checks.

The "modules_autoload" sysctl was inspired from grsecurity
'GRKERNSEC_MODHARDEN'.

/proc/sys/kernel/modules_autoload takes three values:

*) When set to (0), the default, there are no restrictions.

*) When set to (1), processes must have CAP_SYS_MODULE to be able to
trigger a module auto-load operation, or CAP_NET_ADMIN for modules with
a 'netdev-%s' alias. Maybe in future more capabilities will allow to
load the specific related modules.

*) When set to (2), automatic module loading is disabled for all. Once
set, this value can not be changed.


The patches also support process trees, containers, and sandboxes by
providing an inherited per-task "modules_autoload" flag that cannot be
re-enabled once disabled. Any task can set its "modules_autoload" by
using:

        prctl(PR_SET_MODULES_AUTOLOAD, value, 0, 0, 0).

*) When value is (0), the default, automatic modules loading is allowed.

*) When value is (1), task must have CAP_SYS_MODULE to be able to
trigger a module auto-load operation, or CAP_NET_ADMIN for modules with
a 'netdev-%s' alias. The capabilities checks are in the initial user
namespace.

*) When value is (2), automatic modules loading is disabled for the
current task.

The per-task "modules_autoload" value may only be increased, never
decreased, thus ensuring that once applied, processes can never relax
their setting.

The prctl() interface allows to restrict automatic module loading for
untrusted users without affecting the functionality of the rest of the
system.

When a request to a kernel module is denied, the module name with the
corresponding process name and its pid are logged. Administrators can use
such information to explicitly load the appropriate modules.


# Testing:

The following tool can be used to test the feature:
https://gist.githubusercontent.com/tixxdz/ed1ed92b890cc7fd268b5bdcf578c460/raw/6fd42c2cda8aae94e1b8fbaf1ec217fe8e76a3b8/pr_modules_autoload.c


Before:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
$ lsmod | grep ipip -
ipip                   16384  0
tunnel4                16384  1 ipip
ip_tunnel              28672  1 ipip


After:
$ lsmod | grep ipip -
$ ./pr_modules_autoload
$ grep "Modules" /proc/self/status
ModulesAutoload:        2
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255 
add tunnel "tunl0" failed: No such device
$ lsmod | grep ipip
$ dmesg | tail -3
[   16.363903] virbr0: port 1(virbr0-nic) entered disabled state
[  823.565958] Automatic module loading of netdev-tunl0 by "ip"[1362] was denied
[  823.565967] Automatic module loading of tunl0 by "ip"[1362] was denied


Finally we already have a use case for the prctl() interface to enforce
some systemd services [3], and we plan to use it for our containers and
sandboxes.


# Changes since v2:
*) Implemented as a core kernel feature inside capabilities subsystem
*) Renamed sysctl to "modules_autoload" to align with "modules_disabled"
*) Improved documentation.
*) Removed unused code.


# Changes since v1:
*) Renamed module to ModAutoRestrict
*) Improved documentation to explicity refer to module autoloading.
*) Switched to use the new task_security_alloc() hook.
*) Switched from rhash tables to use task->security since it is in
   linux-security/next branch now.
*) Check all parameters passed to prctl() syscall.
*) Many other bug fixes and documentation improvements.


[1] http://www.openwall.com/lists/kernel-hardening/2017/02/02/21
[2] http://www.openwall.com/lists/kernel-hardening/2017/04/09/1
[3] https://github.com/systemd/systemd/pull/5736
