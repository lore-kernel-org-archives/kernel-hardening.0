Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
From: Vasiliy Kulikov <segoon@openwall.com>
Date: Thu, 30 Jun 2011 17:04:05 +0400
Message-Id: <1309439045-12445-1-git-send-email-segoon@openwall.com>
Subject: [kernel-hardening] [PATCH] ipc: comments for shm_forced_rmid code
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, Daniel Lezcano <daniel.lezcano@free.fr>, Helge Deller <deller@gmx.de>, Hugh Dickins <hughd@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

shm_may_destroy() and ipc_namespace.shm_forced_rmid lack comments.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 include/linux/ipc_namespace.h |    3 +++
 ipc/shm.c                     |   10 ++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index bec508f..74173c5 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -44,6 +44,9 @@ struct ipc_namespace {
 	size_t		shm_ctlall;
 	int		shm_ctlmni;
 	int		shm_tot;
+
+	/* Defines whether IPC_RMID is forced for _all_ shm segments
+	 * regardless of shmctl() */
 	int		shm_forced_rmid;
 
 	struct notifier_block ipcns_nb;
diff --git a/ipc/shm.c b/ipc/shm.c
index c55623c..22006f1 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -187,6 +187,16 @@ static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 	ipc_rcu_putref(shp);
 }
 
+/*
+ * shm_may_destroy - identifies whether shm segment should be destroyed now
+ *
+ * Returns true if and only if there are no active users of the segment and
+ * one of the following is true:
+ *
+ * 1) shmctl(id, IPC_RMID, NULL) was called for this shp
+ *
+ * 2) sysctl kernel.shm_forced_rmid is set to 1.
+ */
 static bool shm_may_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp)
 {
 	return (shp->shm_nattch == 0) &&
-- 
1.7.0.4
