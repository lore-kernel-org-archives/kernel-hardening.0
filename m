Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 28 Jan 2016 06:38:25 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20160128143825.GA17383@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH v2] sysctl: allow CLONE_NEWUSER to be disabled
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Andy Lutomirski <luto@kernel.org>, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, Richard Weinberger <richard@nod.at>, Robert =?utf-8?B?xZp3acSZY2tp?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There continue to be unexpected security exposures when users have access
to CLONE_NEWUSER. For admins of systems that do not use user namespaces
and are running distro kernels with CONFIG_USER_NS enabled, there is
no way to disable CLONE_NEWUSER. This provides a way for sysadmins to
disable the feature to reduce their attack surface without needing to
rebuild their kernels.

This is inspired by a similar restriction in Grsecurity, but adds
a sysctl.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
This is the simplified version of the sysctl.
---
 Documentation/sysctl/kernel.txt | 14 ++++++++++++++
 kernel/sysctl.c                 | 14 ++++++++++++++
 kernel/user_namespace.c         |  6 ++++++
 3 files changed, 34 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index a93b414672a7..dcbd3f99efb3 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -85,6 +85,7 @@ show up in /proc/sys/kernel:
 - tainted
 - threads-max
 - unknown_nmi_panic
+- userns_restrict
 - watchdog
 - watchdog_thresh
 - version
@@ -930,6 +931,19 @@ example.  If a system hangs up, try pressing the NMI switch.
 
 ==============================================================
 
+userns_restrict:
+
+This toggle indicates whether CLONE_NEWUSER is available. As CLONE_NEWUSER
+has many unexpected side-effects and security exposures, this allows the
+sysadmin to disable the feature without needing to rebuild the kernel.
+
+When userns_restrict is set to (0), the default, there are no restrictions.
+
+When userns_restrict is set to (1), CLONE_NEWUSER is only available to
+processes that have CAP_SYS_ADMIN, CAP_SETUID, and CAP_SETGID.
+
+==============================================================
+
 watchdog:
 
 This parameter can be used to disable or enable the soft lockup detector
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 97715fd9e790..9f99c8d9e968 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -112,6 +112,9 @@ extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
 extern int sysctl_nr_trim_pages;
 #endif
+#ifdef CONFIG_USER_NS
+extern int sysctl_userns_restrict;
+#endif
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -817,6 +820,17 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &two,
 	},
 #endif
+#ifdef CONFIG_USER_NS
+	{
+		.procname	= "userns_restrict",
+		.data		= &sysctl_userns_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 9bafc211930c..3cace8637144 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -25,6 +25,7 @@
 
 static struct kmem_cache *user_ns_cachep __read_mostly;
 static DEFINE_MUTEX(userns_state_mutex);
+int sysctl_userns_restrict __read_mostly;
 
 static bool new_idmap_permitted(const struct file *file,
 				struct user_namespace *ns, int cap_setid,
@@ -84,6 +85,11 @@ int create_user_ns(struct cred *new)
 	    !kgid_has_mapping(parent_ns, group))
 		return -EPERM;
 
+	if (sysctl_userns_restrict && !(capable(CAP_SYS_ADMIN) &&
+					capable(CAP_SETUID) &&
+					capable(CAP_SETGID)))
+		return -EPERM;
+
 	ns = kmem_cache_zalloc(user_ns_cachep, GFP_KERNEL);
 	if (!ns)
 		return -ENOMEM;
-- 
2.6.3


-- 
Kees Cook
Chrome OS & Brillo Security
