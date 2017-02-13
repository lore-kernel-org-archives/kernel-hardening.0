Date: Mon, 13 Feb 2017 16:33:13 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
Message-ID: <alpine.LRH.2.20.1702131632340.8914@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] [RFC PATCH 2/4] security: mark nf ops in SELinux and Smack as
 __ro_after_init
To: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Both SELinux and Smack register Netfilter operations during init,
which then don't change.  Mark these ops as __ro_after_init.

Signed-off-by: James Morris <james.l.morris@oracle.com>
---
 security/selinux/hooks.c         |    2 +-
 security/smack/smack_netfilter.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9599e97..37a7866 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6379,7 +6379,7 @@ void selinux_complete_init(void)
 
 #if defined(CONFIG_NETFILTER)
 
-static struct nf_hook_ops selinux_nf_ops[] = {
+static struct nf_hook_ops selinux_nf_ops[] __ro_after_init = {
 	{
 		.hook =		selinux_ipv4_postroute,
 		.pf =		NFPROTO_IPV4,
diff --git a/security/smack/smack_netfilter.c b/security/smack/smack_netfilter.c
index 205b785..b945f2c 100644
--- a/security/smack/smack_netfilter.c
+++ b/security/smack/smack_netfilter.c
@@ -57,7 +57,7 @@ static unsigned int smack_ipv4_output(void *priv,
 	return NF_ACCEPT;
 }
 
-static struct nf_hook_ops smack_nf_ops[] = {
+static struct nf_hook_ops smack_nf_ops[] __ro_after_init = {
 	{
 		.hook =		smack_ipv4_output,
 		.pf =		NFPROTO_IPV4,
-- 
1.7.1
