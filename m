Return-Path: <kernel-hardening-return-21922-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D04FAC02185
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Jan 2025 04:55:53 +0000 (UTC)
Received: (qmail 11330 invoked by uid 550); 20 Jan 2025 04:55:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11299 invoked from network); 20 Jan 2025 04:55:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ethancedwards.com;
	s=MBO0001; t=1737348931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=rrYKeGFLsHGSZ5GvrDU0SE64XtkrNNqCHmJUGmuWCiE=;
	b=xDELt6zF7IkU7u+ZSve+W0vyYBxgEDfTqTetM2AiAjuOZRaTt2Fu189yHzailrj4283yzH
	SKd6m1wlo9xx9pmjTe8cah6FVjRXJW+pu2sKVNlCm4nzymKFt6T4PQ1occblDUaOVbfP69
	vSImiz+gRo1sl7MaCwKjcQjjOy0VpHR7aRF7AI0kIlHgkNysLGknH5b4l64J4lm88GPt0J
	mG8nflJqlYxuFTLOhtmPJmity5dt0Js7i4+n+CnPejRDkqV4s+c2CTpsoe+Qh80Mwimvoo
	QTRA5+GvCAterjwwJPp5IW5dyqt/aM17H4nYSdLnPEtcMgdi2YDpAtBDj6Oh4w==
Date: Sun, 19 Jan 2025 23:55:27 -0500
From: Ethan Carter Edwards <ethan@ethancedwards.com>
To: Trond Myklebust <trondmy@kernel.org>
Cc: Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: [PATCH] NFSv4: harden nfs4_get_uniquifier() function
Message-ID: <k7n2k4zqqnf6yisotj6ofgne7lvmwgy3yghygvwixfmkyrcwgl@4z26pbujl3gq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 4YbyhM1Vtqz9sc8

If the incorrect buffer size were passed into nfs4_get_uniquifier
function then a memory access error could occur. This change prevents us
from accidentally passing an unrelated variable into the buffer copy
function.

Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
---
 fs/nfs/nfs4proc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 405f17e6e0b4..18311bf5338d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6408,7 +6408,7 @@ static void nfs4_init_boot_verifier(const struct nfs_client *clp,
 }
 
 static size_t
-nfs4_get_uniquifier(struct nfs_client *clp, char *buf, size_t buflen)
+nfs4_get_uniquifier(struct nfs_client *clp, char *buf)
 {
 	struct nfs_net *nn = net_generic(clp->cl_net, nfs_net_id);
 	struct nfs_netns_client *nn_clp = nn->nfs_client;
@@ -6420,12 +6420,12 @@ nfs4_get_uniquifier(struct nfs_client *clp, char *buf, size_t buflen)
 		rcu_read_lock();
 		id = rcu_dereference(nn_clp->identifier);
 		if (id)
-			strscpy(buf, id, buflen);
+			strscpy(buf, id, sizeof(buf));
 		rcu_read_unlock();
 	}
 
 	if (nfs4_client_id_uniquifier[0] != '\0' && buf[0] == '\0')
-		strscpy(buf, nfs4_client_id_uniquifier, buflen);
+		strscpy(buf, nfs4_client_id_uniquifier, sizeof(buf));
 
 	return strlen(buf);
 }
@@ -6449,7 +6449,7 @@ nfs4_init_nonuniform_client_string(struct nfs_client *clp)
 		1;
 	rcu_read_unlock();
 
-	buflen = nfs4_get_uniquifier(clp, buf, sizeof(buf));
+	buflen = nfs4_get_uniquifier(clp, buf);
 	if (buflen)
 		len += buflen + 1;
 
@@ -6496,7 +6496,7 @@ nfs4_init_uniform_client_string(struct nfs_client *clp)
 	len = 10 + 10 + 1 + 10 + 1 +
 		strlen(clp->cl_rpcclient->cl_nodename) + 1;
 
-	buflen = nfs4_get_uniquifier(clp, buf, sizeof(buf));
+	buflen = nfs4_get_uniquifier(clp, buf);
 	if (buflen)
 		len += buflen + 1;
 
-- 
2.48.0

