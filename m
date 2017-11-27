From: Djalal Harouni <tixxdz@gmail.com>
Date: Mon, 27 Nov 2017 18:18:36 +0100
Message-Id: <1511803118-2552-4-git-send-email-tixxdz@gmail.com>
In-Reply-To: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH v5 next 3/5] modules:capabilities: automatic module loading restriction
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Currently, an explicit call to load or unload kernel modules require
CAP_SYS_MODULE capability. However unprivileged users have always been
able to load some modules using the implicit auto-load operation. An
automatic module loading happens when programs request a kernel feature
from a module that is not loaded. In order to satisfy userspace, the
kernel then automatically load all these required modules.

Historically, the kernel was always able to automatically load modules
if they are not blacklisted. This is one of the most important and
transparent operations of Linux, it allows to provide numerous other
features as they are needed which is crucial for a better user experience.
However, as Linux is popular now and used for different appliances some
of these may need to control such operations. For such systems, recent
needs showed that in some cases allowing to control automatic module
loading is as important as the operation itself. Restricting unprivileged
programs or attackers that abuse this feature to load unused modules or
modules that contain bugs is a significant security measure.

This allows administrators or some special programs to have the
appropriate time to update and deny module autoloading in advance, then
blacklist the corresponding ones. Not doing so may affect the global state
of the machine, especially containers where some apps are moved from one
context to another and not having such mechanisms may allow to expose
and exploit the vulnerable parts to escape the container sandbox.

Embedded or IoT devices also started to ship as containers using generic
distros, some vendors do not have the appropriate time to make their own
OS, hence, using base images is getting popular. These setups may include
unnecessary modules that the final applications will not need. Untrusted
access may abuse the module auto-load feature to expose vulnerabilities.

As every code contains bugs or vulnerabilties, the following
vulnerabilities that affected some features that are often compiled as
modules could have been completely blocked, by restricting autoloading
modules if the system does not need them.

Past months:
* DCCP use after free CVE-2017-6074 [1] [2]
  Unprivileged to local root.

* XFRM framework CVE-2017-7184 [3]
  As advertised it seems it was used to break Ubuntu on a security
  contest.

* n_hldc CVE-2017-2636 [4] [5]
  Local privilege escalation.

* L2TPv3 CVE-2016-10200

The list is longer.

To improve the current status, this patch introduces "modules_autoload_mode"
kernel sysctl flag. The flag controls modules auto-load feature and
complements "modules_disabled" which apply to all modules operations.
This new flag allows to control only automatic module loading and if it is
allowed or not, aligning in the process the implicit operation with the
explicit one where both now are covered by capabilities checks.

The three modes that "modules_autoload_mode" support allow to provide
restrictions on automatic module loading without breaking user
experience.

The sysctl flag is available at "/proc/sys/kernel/modules_autoload_mode"

When modules_autoload_mode is set to (0), the default, there are no
restrictions.

When modules_autoload_mode is set to (1), processes must have
CAP_SYS_MODULE to be able to trigger a module auto-load operation,
or CAP_NET_ADMIN for modules with a 'netdev-%s' alias, or other
capabilities for specific aliased modules.

When modules_autoload_mode is set to (2), automatic module loading
is disabled for all.

Notes on relation between "modules_disabled=0" and
"modules_autoload_mode=2":
1) Once "modules_disabled=1" set, it needs a reboot to undo the
setting.

2) Restricting automatic module loading does not interfere with
explicit module load or unload operations.

3) New features provided by modules can be made available without
rebooting the system.

4) A bad version of a module can be unloaded and replaced with a
better one without rebooting the system.

The idea of module auto-load restriction was inspired from grsecurity
'GRKERNSEC_MODHARDEN' config option. Upstream Linux implementation is
more focused on the run-time behavior with a three mode switch.

Testing
-------

Example 1)

Before:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
$ lsmod | grep ipip -
ipip                   16384  0
tunnel4                16384  1 ipip
ip_tunnel              28672  1 ipip
$ cat /proc/sys/kernel/modules_autoload_mode
0

After:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
add tunnel "tunl0" failed: No such device
$ dmesg
...
[ 1876.378389] module: automatic module loading of netdev-tunl0 by "ip"[1453] was denied
[ 1876.380994] module: automatic module loading of tunl0 by "ip"[1453] was denied
...
$ lsmod | grep ipip -
$

Example 2)

DCCP use after free CVE-2017-6074:
The code path can be triggered by unprivileged, using the trigger.c
program for DCCP use after free [2] and that was fixed by
commit 5edabca9d4cff7f "dccp: fix freeing skb too early for IPV6_RECVPKTINFO".

Before:
$ lsmod | grep dccp
$ strace ./dccp_trigger
...
socket(AF_INET6, SOCK_DCCP, IPPROTO_IP) = 3
...
$ lsmod | grep dccp
dccp_ipv6              24576  5
dccp_ipv4              24576  5 dccp_ipv6
dccp                  102400  2 dccp_ipv6,dccp_ipv4

After:
Only privileged:
$ lsmod | grep dccp
$ strace ./dccp_trigger
...
socket(AF_INET6, SOCK_DCCP, IPPROTO_IP) = -1 ESOCKTNOSUPPORT (Socket type not supported)
...
$ lsmod | grep dccp
$ dmesg
...
[  175.945063] module: automatic module loading of net-pf-10-proto-0-type-6 by "dccp_trigger"[1390] was denied
[  175.947952] module: automatic module loading of net-pf-10-proto-0 by "dccp_trigger"[1390] was denied
[  175.956061] module: automatic module loading of net-pf-10-proto-0-type-6 by "dccp_trigger"[1390] was denied
[  175.959733] module: automatic module loading of net-pf-10-proto-0 by "dccp_trigger"[1390] was denied

$ sudo strace ./dccp_trigger
...
socket(AF_INET6, SOCK_DCCP, IPPROTO_IP) = 3
...
$ lsmod | grep dccp
dccp_ipv6              24576  6
dccp_ipv4              24576  5 dccp_ipv6
dccp                  102400  2 dccp_ipv6,dccp_ipv4

Disable automatic module loading:
$ lsmod | grep dccp
$ su - root
...
socket(AF_INET6, SOCK_DCCP, IPPROTO_IP) = -1 ESOCKTNOSUPPORT (Socket type not supported)
...
$ lsmod | grep dccp
$ dmesg
...
[  126.596545] module: automatic module loading of net-pf-10-proto-0-type-6 by "dccp_trigger"[1291] was denied
[  126.598800] module: automatic module loading of net-pf-10-proto-0 by "dccp_trigger"[1291] was denied
[  126.601264] module: automatic module loading of net-pf-10-proto-0-type-6 by "dccp_trigger"[1291] was denied
[  126.602839] module: automatic module loading of net-pf-10-proto-0 by "dccp_trigger"[1291] was denied

As an example, this blocks abuses, DCCP still can be explicilty loaded by
an administrator using modprobe, at same time automatic module loading is
disabled forever.

[1] http://www.openwall.com/lists/oss-security/2017/02/22/3
[2] https://github.com/xairy/kernel-exploits/tree/master/CVE-2017-6074
[3] http://www.openwall.com/lists/oss-security/2017/03/29/2
[4] http://www.openwall.com/lists/oss-security/2017/03/07/6
[5] https://a13xp0p0v.github.io/2017/03/24/CVE-2017-2636.html

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Cc: Solar Designer <solar@openwall.com>
Cc: Andy Lutomirski <luto@kernel.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/sysctl/kernel.txt | 54 +++++++++++++++++++++++++++
 include/linux/module.h          | 11 +++++-
 kernel/module.c                 | 81 ++++++++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c                 | 28 ++++++++++++++
 4 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 694968c..dc44075 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -43,6 +43,7 @@ show up in /proc/sys/kernel:
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
+- modules_autoload_mode
 - msg_next_id		      [ sysv ipc ]
 - msgmax
 - msgmnb
@@ -413,6 +414,59 @@ to false.  Generally used with the "kexec_load_disabled" toggle.
 
 ==============================================================
 
+modules_autoload_mode:
+
+A sysctl to control if modules auto-load feature is allowed or not.
+This sysctl complements "modules_disabled" which is for all module
+operations where this flag applies only to automatic module loading.
+Automatic module loading happens when programs request a kernel
+feature that is implemented by an unloaded module, the kernel
+automatically runs the program pointed by "modprobe" sysctl in order
+to load the corresponding module.
+
+Historically, the kernel was always able to automatically load modules
+if they are not blacklisted. This is one of the most important and
+transparent operations of Linux, it allows to provide numerous other
+features as they are needed which is crucial for a better user experience.
+However, as Linux is popular now and used for different appliances some
+of these may need to control such operations. For such systems, recent
+needs showed that in some cases allowing to control automatic module
+loading is as important as the operation itself. Restricting unprivileged
+programs or attackers that abuse this feature to load unused modules or
+modules that contain bugs is a significant security measure.
+
+The three modes that "modules_autoload_mode" support allow to provide
+restrictions on automatic module loading without breaking user
+experience.
+
+When modules_autoload_mode is set to (0), the default, there are no
+restrictions.
+
+When modules_autoload_mode is set to (1), processes must have
+CAP_SYS_MODULE to be able to trigger a module auto-load operation,
+CAP_NET_ADMIN for modules with a 'netdev-%s' alias, or other
+capabilities for specific aliased modules.
+
+When modules_autoload_mode is set to (2), automatic module loading
+is disabled for all.
+
+
+Notes on relation between "modules_disabled=0" and
+"modules_autoload_mode=2":
+1) Once "modules_disabled=1" set, it needs a reboot to undo the
+setting.
+2) Restricting automatic module loading does not interfere with
+explicit module load or unload operations.
+3) New features provided by modules can be made available without
+rebooting the system.
+4) A bad version of a module can still be unloaded and replaced with
+a better one without rebooting the system.
+
+The idea of module auto-load restriction was inspired from grsecurity
+'GRKERNSEC_MODHARDEN' config option.
+
+==============================================================
+
 msg_next_id, sem_next_id, and shm_next_id:
 
 These three toggles allows to specify desired id for next allocated IPC
diff --git a/include/linux/module.h b/include/linux/module.h
index 5cbb239..c36aed8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -261,7 +261,16 @@ struct notifier_block;
 
 #ifdef CONFIG_MODULES
 
-extern int modules_disabled; /* for sysctl */
+enum {
+	MODULES_AUTOLOAD_ALLOWED	= 0,
+	MODULES_AUTOLOAD_PRIVILEGED	= 1,
+	MODULES_AUTOLOAD_DISABLED	= 2,
+};
+
+extern int modules_disabled; /* sysctl for explicit module load/unload */
+extern int modules_autoload_mode; /* sysctl for automatic module loading */
+extern const int modules_autoload_max; /* max value for modules_autoload_mode */
+
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
diff --git a/kernel/module.c b/kernel/module.c
index 3380d39..a7205fb 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -290,6 +290,8 @@ EXPORT_SYMBOL(is_module_sig_enforced);
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
+int modules_autoload_mode = MODULES_AUTOLOAD_ALLOWED;
+const int modules_autoload_max = MODULES_AUTOLOAD_DISABLED;
 core_param(nomodule, modules_disabled, bint, 0);
 
 /* Waiting for a module to finish initializing? */
@@ -4355,12 +4357,89 @@ EXPORT_SYMBOL_GPL(__module_text_address);
  * modules, some of them are not updated often and may contain bugs and
  * vulnerabilities.
  *
+ * If "@required_cap" is positive and a valid capability then it is checked
+ * together with the "@kmod_prefix" to either allow or deny automatic module
+ * loading.
+ *
+ * However even if the caller has the required capability, the operation can
+ * still be denied due to the global "modules_autoload_mode" sysctl mode. Unless
+ * set by enduser, the operation is always allowed which is the default.
+ *
+ * The permission check is performed in this order:
+ * 1) If the global sysctl "modules_autoload_mode" is set to 'disabled', then
+ *    operation is denied.
+ *
+ * 2) If the global sysctl "modules_autoload_mode" is set to 'privileged', then:
+ *
+ *   2.1) If "@required_cap" is positive and "@kmod_prefix" is set, then
+ *   if the caller has the capability, the operation is allowed.
+ *
+ *   2.2) If "@required_cap" is positive and "@kmod_prefix" is NULL, then we
+ *   fallback to check if caller has CAP_SYS_MODULE, if so, operation is
+ *   allowed.
+ *
+ *   2.3) If caller passes "@required_cap" as a negative then we fallback to
+ *   check if caller has CAP_SYS_MODULE, if so, operation is allowed.
+ *
+ *   We require capabilities to autoload modules here, and CAP_SYS_MODULE here is
+ *   the default.
+ *
+ *   2.4) Otherwise operation is denied.
+ *
+ * 3) If the global sysctl "modules_autoload_mode" is set to 'allowed' which is
+ *    the default, then:
+ *
+ *   3.1) If "@required_cap" is positive and "@kmod_prefix" is set, we check if
+ *   caller has the capability, if so, operation is allowed.
+ *   In this case the calling subsystem requires the capability to be set before
+ *   allowing modules autoload operations and we have to honor that.
+ *
+ *   3.2) If "@required_cap" is positive and "@kmod_prefix" is NULL, then we
+ *   fallback to check if caller has CAP_SYS_MODULE, if so, operation is
+ *   allowed.
+ *
+ *   3.3) If caller passes "@required_cap" as a negative then operation is
+ *   allowed. This is the most common case as it is used now by
+ *   request_module() function.
+ *
+ *   3.4) Otherwise operation is denied.
+ *
  * Returns 0 if the module request is allowed or -EPERM if not.
  */
 int may_autoload_module(char *kmod_name, int required_cap,
 			const char *kmod_prefix)
 {
-	return 0;
+	int module_require_cap = CAP_SYS_MODULE;
+	unsigned int autoload = modules_autoload_mode;
+
+	/* Short-cut for most use cases where kmod auto-loading is allowed */
+	if (autoload == MODULES_AUTOLOAD_ALLOWED && required_cap < 0)
+		return 0;
+
+	/* If autoload is disabled then fail here */
+	if (autoload == MODULES_AUTOLOAD_DISABLED)
+		return -EPERM;
+
+	/* If caller requires privileges */
+	if (required_cap > 0) {
+		/*
+		 * If '@kmod_prefix' is set then use the '@required_cap'.
+		 * This allows to cover 'netdev-%s' alias modules and others
+		 * with their corresponding capability
+		 */
+		if (kmod_prefix != NULL && *kmod_prefix != '\0')
+			module_require_cap = required_cap;
+	}
+
+	/*
+	 * We require privileges if '@required_cap' was set or if the
+	 * 'modules_autoload_mode' is set to 'privileged' mode.
+	 */
+	if (capable(module_require_cap))
+		return 0;
+
+	/* Otherwise fail */
+	return -EPERM;
 }
 
 /* Don't grab lock, we're oopsing. */
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 2fb4e27..0b6f0c8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -207,6 +207,11 @@ static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_MODULES
+static int modules_autoload_dointvec_minmax(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_PRINTK
 static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -683,6 +688,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "modules_autoload_mode",
+		.data		= &modules_autoload_mode,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= modules_autoload_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= (void *)&modules_autoload_max,
+	},
 #endif
 #ifdef CONFIG_UEVENT_HELPER
 	{
@@ -2499,6 +2513,20 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 }
 #endif
 
+#ifdef CONFIG_MODULES
+static int modules_autoload_dointvec_minmax(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	/*
+	 * Only CAP_SYS_MODULE in init user namespace are allowed to change this
+	 */
+	if (write && !capable(CAP_SYS_MODULE))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+#endif
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
-- 
2.7.4
