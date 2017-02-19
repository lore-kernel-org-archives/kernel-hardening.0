From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sun, 19 Feb 2017 19:04:07 +0900
Message-Id: <1487498660-16600-4-git-send-email-hoeun.ryu@gmail.com>
In-Reply-To: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFC 4/7] selinux: mark __ro_mostly_after_init for selinux_hooks/selinux_nf_ops
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, "Serge E. Hallyn" <serge@hallyn.com>, selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

 It would be good that selinux hooks objects are marked as
`__ro_mostly_after_init`. They can not be simply marked as `__ro_after_init'
because they should be writable during selinux_disable procedure.
`__ro_mostly_after_init` section is temporarily read-write during
selinux_disable procedure via set_ro_mostly_after_init_rw/ro pair. Now that
they can be read-only except during the procedure.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 security/selinux/hooks.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a8f12f..64fd799 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6106,7 +6106,7 @@ static int selinux_key_getsecurity(struct key *key, char **_buffer)
 
 #endif
 
-static struct security_hook_list selinux_hooks[] = {
+static struct security_hook_list selinux_hooks[] __ro_mostly_after_init = {
 	LSM_HOOK_INIT(binder_set_context_mgr, selinux_binder_set_context_mgr),
 	LSM_HOOK_INIT(binder_transaction, selinux_binder_transaction),
 	LSM_HOOK_INIT(binder_transfer_binder, selinux_binder_transfer_binder),
@@ -6381,7 +6381,7 @@ security_initcall(selinux_init);
 
 #if defined(CONFIG_NETFILTER)
 
-static struct nf_hook_ops selinux_nf_ops[] = {
+static struct nf_hook_ops selinux_nf_ops[] __ro_mostly_after_init = {
 	{
 		.hook =		selinux_ipv4_postroute,
 		.pf =		NFPROTO_IPV4,
@@ -6477,13 +6477,17 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
+	set_ro_mostly_after_init_rw();
 	security_delete_hooks(selinux_hooks, ARRAY_SIZE(selinux_hooks));
+	set_ro_mostly_after_init_ro();
 
 	/* Try to destroy the avc node cache */
 	avc_disable();
 
 	/* Unregister netfilter hooks. */
+	set_ro_mostly_after_init_ro();
 	selinux_nf_ip_exit();
+	set_ro_mostly_after_init_rw();
 
 	/* Unregister selinuxfs. */
 	exit_sel_fs();
-- 
2.7.4
