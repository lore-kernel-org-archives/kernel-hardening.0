From: Djalal Harouni <tixxdz@gmail.com>
Date: Sun,  9 Apr 2017 12:42:10 +0200
Message-Id: <1491734530-25002-4-git-send-email-tixxdz@gmail.com>
In-Reply-To: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
Subject: [kernel-hardening] [PATCH RFC v2 3/3] Documentation: add ModAutoRestrict LSM documentation
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Cc: Andy Lutomirski <luto@kernel.org>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/security/00-INDEX            |  2 +
 Documentation/security/ModAutoRestrict.txt | 77 ++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)
 create mode 100644 Documentation/security/ModAutoRestrict.txt

diff --git a/Documentation/security/00-INDEX b/Documentation/security/00-INDEX
index 45c82fd..35dbdf0 100644
--- a/Documentation/security/00-INDEX
+++ b/Documentation/security/00-INDEX
@@ -24,3 +24,5 @@ tomoyo.txt
 	- documentation on the TOMOYO Linux Security Module.
 IMA-templates.txt
 	- documentation on the template management mechanism for IMA.
+ModAutoRestrict.txt
+        - documentation on the ModAutoRestrict Linux Security Module.
diff --git a/Documentation/security/ModAutoRestrict.txt b/Documentation/security/ModAutoRestrict.txt
new file mode 100644
index 0000000..47acae8
--- /dev/null
+++ b/Documentation/security/ModAutoRestrict.txt
@@ -0,0 +1,77 @@
+ModAutoRestrict is a Linux Security Module that applies restrictions on
+automatic module loading operations. This is selectable at build-time
+with CONFIG_SECURITY_MODAUTORESTRICT, and can be controlled at run-time
+through sysctls in /proc/sys/kernel/modautorestrict/autoload or as a
+per-process setting via a prctl() interface.
+
+===========================================
+
+A userspace request to use a kernel feature that is implemented by modules
+that are not loaded may trigger the module auto-load feature to load
+these modules in order to satisfy userspace. However as today's Linux use
+cases cover embedded systems to containers where applications are running
+in their own separate environments, reducing or preventing operations
+that may affect external environments is an important constraint.
+Therefore, we need a way to control if automatic module loading is
+allowed or which applications are allowed to trigger the module
+auto-load feature.
+
+The ModAutoRestrict LSM allows system administrators or sandbox
+mechanisms to control the module auto-load feature and prevent loading
+unneeded modules or abuse the interface.
+
+The settings can be applied globally using a sysctl interface which
+completes the core kernel interface "modules_disable".
+
+The feature is also available as a prctl() interface. This allows to
+apply restrictions when sandboxing processes. On embedded Linux systems,
+or containers where only some containers/processes should have the
+right privileges to load modules, this allows to restrict those
+processes from inserting modules. Only privileged processes can be
+allowed to perform so. A more restrictive access can be applied where
+the module autoload feature is completely disabled.
+In this schema the access rules are per-process and inherited by
+children created by fork(2) and clone(2), and preserved across execve(2).
+
+Interface:
+
+*) The per-process prctl() settings are:
+
+ prctl(PR_MOD_AUTO_RESTRICT_OPTS, PR_SET_MOD_AUTO_RESTRICT, value, 0, 0)
+
+ Where value means:
+
+ 0 - Classic module auto-load permissions, nothing changes.
+
+ 1 - The current process must have CAP_SYS_MODULE to be able to
+     auto-load modules. CAP_NET_ADMIN should allow to auto-load
+     modules with a 'netdev-%s' alias.
+
+ 2 - Current process can not auto-load modules. Once set, this prctl
+     value can not be changed.
+
+ The per-process value may only be increased, never decreased, thus ensuring
+ that once applied, processes can never relaxe their setting.
+
+*) The global sysctl setting can be set by writting an integer value to
+   '/proc/sys/kernel/modautorestrict/autoload'
+
+ The valid values are:
+
+ 0 - Classic module auto-load permissions, nothing changes.
+
+ 1 - Processes must have CAP_SYS_MODULE to be able to auto-load modules.
+     CAP_NET_ADMIN should allow to auto-load modules with a 'netdev-%s'
+     alias.
+
+ 2 - Processes can not auto-load modules. Once set, this sysctl value
+     can not be changed.
+
+*) Access rules:
+   First the prctl() settings are checked, if the access is not denied
+   then the global sysctl settings are checked.
+
+
+The original idea and inspiration is from grsecurity 'GRKERNSEC_MODHARDEN'.
+
+==========================================================================
-- 
2.10.2
