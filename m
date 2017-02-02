From: Djalal Harouni <tixxdz@gmail.com>
Date: Thu,  2 Feb 2017 18:04:54 +0100
Message-Id: <1486055094-4532-4-git-send-email-djalal@gmail.com>
In-Reply-To: <1486055094-4532-1-git-send-email-djalal@gmail.com>
References: <1486055094-4532-1-git-send-email-djalal@gmail.com>
Subject: [kernel-hardening] [RFC/PATCH 3/3] doc: add Timgad LSM documentation
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Dongsu Park <dongsu@endocode.com>, Andy Lutomirski <luto@kernel.org>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Al Viro <viro@zeniv.linux.org.uk>, Daniel Mack <daniel@zonque.org>, Jann Horn <jann@thejh.net>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Djalal Harouni <tixxdz@gmail.com>

Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/security/Timgad.txt | 61 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)
 create mode 100644 Documentation/security/Timgad.txt

diff --git a/Documentation/security/Timgad.txt b/Documentation/security/Timgad.txt
new file mode 100644
index 0000000..1ae1e7c
--- /dev/null
+++ b/Documentation/security/Timgad.txt
@@ -0,0 +1,61 @@
+Timgad is a Linux Security Module that collects per process and
+system-wide security protections that are not handled by the core kernel
+itself.
+
+This is selectable at build-time with CONFIG_SECURITY_TIMGAD, and can be
+controlled at run-time through sysctls in /proc/sys/kernel/timgad:
+or prctl() interface.
+
+
+- module_restrict
+
+==============================================================
+
+Linux containers need robust settings to control if modules are allowed to
+be loaded or unloaded globally or per process/container policy.
+Automatic loading of kernel modules using the "auto-load" feature is also
+covered.
+
+This adds global sysctl settings to indicate if modules are allowed
+to be loaded or unloaded, at same time it also supports a
+per-process/container settings based on prctl(2) interface. The prctl(2)
+settings are inherited by children created by fork(2) and clone(2), and
+preserved across execve(2).
+
+
+*) The per-process prctl() settings are:
+   prctl(PR_TIMGAD_OPTS, PR_TIGMAD_SET_MOD_RESTRICT, value, 0, 0)
+
+   Where value means:
+
+0 - Classic module load and unload permissions, nothing changes.
+
+1 - The current process must have CAP_SYS_MODULE to be able to load and
+    unload modules. CAP_NET_ADMIN should allow the current process to
+    load and unload only netdev aliased modules.
+
+2 - Current process can not loaded nor unloaded modules.
+
+
+*) The sysctl settings (writable only with CAP_SYS_MODULE) are:
+   /proc/sys/kernel/timgad/module_restrict
+
+0 - Classic module load and unload permissions, nothing changes.
+
+1 - Only processes with CAP_SYS_MODULE should be able to load and
+    unload modules. Processes with CAP_NET_ADMIN should be able to
+    load and unload only netdev aliased modules.
+
+2 - Modules can not be loaded nor unloaded. Once set, this sysctl value
+    cannot be changed.
+
+
+Rules:
+First the prctl() settings are checked, if the access is not denied
+then the global sysctl settings are checked.
+
+
+The original idea and inspiration is from grsecurity
+'GRKERNSEC_MODHARDEN'
+
+==============================================================
-- 
2.5.5
