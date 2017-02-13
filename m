Date: Mon, 13 Feb 2017 16:35:24 +1100 (AEDT)
From: James Morris <jmorris@namei.org>
Message-ID: <alpine.LRH.2.20.1702131634430.8914@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] [RFC PATCH 4/4] selinux: constify nlmsg permission tables
To: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

Constify nlmsg permission tables, which are initialized once
and then do not change.

Signed-off-by: James Morris <james.l.morris@oracle.com>
---
 security/selinux/nlmsgtab.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 2ca9cde..57e2596 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -28,7 +28,7 @@ struct nlmsg_perm {
 	u32	perm;
 };
 
-static struct nlmsg_perm nlmsg_route_perms[] =
+static const struct nlmsg_perm nlmsg_route_perms[] =
 {
 	{ RTM_NEWLINK,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELLINK,		NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
@@ -80,7 +80,7 @@ struct nlmsg_perm {
 	{ RTM_GETSTATS,		NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
-static struct nlmsg_perm nlmsg_tcpdiag_perms[] =
+static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
 {
 	{ TCPDIAG_GETSOCK,	NETLINK_TCPDIAG_SOCKET__NLMSG_READ },
 	{ DCCPDIAG_GETSOCK,	NETLINK_TCPDIAG_SOCKET__NLMSG_READ },
@@ -88,7 +88,7 @@ struct nlmsg_perm {
 	{ SOCK_DESTROY,		NETLINK_TCPDIAG_SOCKET__NLMSG_WRITE },
 };
 
-static struct nlmsg_perm nlmsg_xfrm_perms[] =
+static const struct nlmsg_perm nlmsg_xfrm_perms[] =
 {
 	{ XFRM_MSG_NEWSA,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
 	{ XFRM_MSG_DELSA,	NETLINK_XFRM_SOCKET__NLMSG_WRITE },
@@ -115,7 +115,7 @@ struct nlmsg_perm {
 	{ XFRM_MSG_MAPPING,	NETLINK_XFRM_SOCKET__NLMSG_READ  },
 };
 
-static struct nlmsg_perm nlmsg_audit_perms[] =
+static const struct nlmsg_perm nlmsg_audit_perms[] =
 {
 	{ AUDIT_GET,		NETLINK_AUDIT_SOCKET__NLMSG_READ     },
 	{ AUDIT_SET,		NETLINK_AUDIT_SOCKET__NLMSG_WRITE    },
@@ -136,7 +136,7 @@ struct nlmsg_perm {
 };
 
 
-static int nlmsg_perm(u16 nlmsg_type, u32 *perm, struct nlmsg_perm *tab, size_t tabsize)
+static int nlmsg_perm(u16 nlmsg_type, u32 *perm, const struct nlmsg_perm *tab, size_t tabsize)
 {
 	int i, err = -EINVAL;
 
-- 
1.7.1
