Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 2 Aug 2011 16:45:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110802124530.GA2543@albatros>
References: <20110801180151.GA26686@albatros>
 <20110801112021.25ec9041.akpm@linux-foundation.org>
 <20110801190341.GA6898@albatros>
 <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw2kHWY1N=ox1er7c-3WL4OA8x0M=Keu7hvAncKUZd1tQ@mail.gmail.com>
Subject: [kernel-hardening] [PATCH] shm: fix a race between shm_exit() and shm_init()
To: Linus Torvalds <torvalds@linux-foundation.org>, Manuel Lauss <manuel.lauss@googlemail.com>, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Marc Zyngier <maz@misterjones.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com, "Paul E. McKenney" <paul.mckenney@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Manuel, Richard, Marc - can you test this patch, please?


From: Vasiliy Kulikov <segoon@openwall.com>
Subject: [PATCH] shm: fix a race between shm_exit() and shm_init()

On thread exit shm_exit() is called, it uses shm_ids(ns).rw_mutex.
It is initialized in shm_init(), but it is not called yet at the moment
of kernel threads exit.  Some kernel threads are created in
do_pre_smp_initcalls(), and shm_init() is called in do_initcalls().

Static initialization of shm_ids(init_ipc_ns).rw_mutex fixes the race.

It fixes a kernel oops:

Unable to handle kernel NULL pointer dereference at virtual address 00000000
...
[<c0320090>] (__down_write_nested+0x88/0xe0) from [<c015da08>] (exit_shm+0x28/0x48)
[<c015da08>] (exit_shm+0x28/0x48) from [<c002e550>] (do_exit+0x59c/0x750)
[<c002e550>] (do_exit+0x59c/0x750) from [<c003eaac>] (____call_usermodehelper+0x13c/0x154)
[<c003eaac>] (____call_usermodehelper+0x13c/0x154) from [<c000f630>] (kernel_thread_exit+0x0/0x8)
Code: 1afffffa e597c00c e58d0000 e587d00c (e58cd000)

Reported-by: Manuel Lauss <manuel.lauss@googlemail.com>
Reported-by: Richard Weinberger <richard@nod.at>
Reported-by: Marc Zyngier <maz@misterjones.org>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 ipc/msgutil.c |    6 ++++++
 ipc/shm.c     |   11 ++++++++++-
 ipc/util.c    |   30 +++++++++++++++++-------------
 ipc/util.h    |    1 +
 4 files changed, 34 insertions(+), 14 deletions(-)

diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index 8b5ce5d..6da67b6 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -20,6 +20,9 @@
 
 DEFINE_SPINLOCK(mq_lock);
 
+#define INIT_IPC_SHM_IDS(name) \
+	{ .rw_mutex = __RWSEM_INITIALIZER(name.rw_mutex), }
+
 /*
  * The next 2 defines are here bc this is the only file
  * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
@@ -27,6 +30,9 @@ DEFINE_SPINLOCK(mq_lock);
  */
 struct ipc_namespace init_ipc_ns = {
 	.count		= ATOMIC_INIT(1),
+	.ids	= {
+		[IPC_SHM_IDS] = INIT_IPC_SHM_IDS(init_ipc_ns.ids[IPC_SHM_IDS]),
+	},
 #ifdef CONFIG_POSIX_MQUEUE
 	.mq_queues_max   = DFLT_QUEUESMAX,
 	.mq_msg_max      = DFLT_MSGMAX,
diff --git a/ipc/shm.c b/ipc/shm.c
index 9fb044f..7d084a0 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -76,7 +76,16 @@ void shm_init_ns(struct ipc_namespace *ns)
 	ns->shm_ctlmni = SHMMNI;
 	ns->shm_rmid_forced = 0;
 	ns->shm_tot = 0;
-	ipc_init_ids(&shm_ids(ns));
+
+	/*
+	 * For init_ipc_ns shm_ids().rw_mutex is statically initialized
+	 * as kernel threads should be able to use it in do_exit() before
+	 * shm_init(), which is called on do_initcall()
+	 */
+	if (ns == &init_ipc_ns)
+		__ipc_init_ids(&shm_ids(ns));
+	else
+		ipc_init_ids(&shm_ids(ns));
 }
 
 /*
diff --git a/ipc/util.c b/ipc/util.c
index 75261a3..673dde5 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -108,31 +108,35 @@ static int __init ipc_init(void)
 }
 __initcall(ipc_init);
 
-/**
- *	ipc_init_ids		-	initialise IPC identifiers
- *	@ids: Identifier set
- *
- *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
- */
- 
-void ipc_init_ids(struct ipc_ids *ids)
+void __ipc_init_ids(struct ipc_ids *ids)
 {
-	init_rwsem(&ids->rw_mutex);
-
 	ids->in_use = 0;
 	ids->seq = 0;
 	{
 		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
 		if (seq_limit > USHRT_MAX)
 			ids->seq_max = USHRT_MAX;
-		 else
-		 	ids->seq_max = seq_limit;
+		else
+			ids->seq_max = seq_limit;
 	}
 
 	idr_init(&ids->ipcs_idr);
 }
 
+/**
+ *	ipc_init_ids		-	initialise IPC identifiers
+ *	@ids: Identifier set
+ *
+ *	Set up the sequence range to use for the ipc identifier range (limited
+ *	below IPCMNI) then initialise the ids idr.
+ */
+
+void ipc_init_ids(struct ipc_ids *ids)
+{
+	init_rwsem(&ids->rw_mutex);
+	__ipc_init_ids(ids);
+}
+
 #ifdef CONFIG_PROC_FS
 static const struct file_operations sysvipc_proc_fops;
 /**
diff --git a/ipc/util.h b/ipc/util.h
index 6f5c20b..8bbcd9c 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -80,6 +80,7 @@ struct seq_file;
 struct ipc_ids;
 
 void ipc_init_ids(struct ipc_ids *);
+void __ipc_init_ids(struct ipc_ids *ids);
 #ifdef CONFIG_PROC_FS
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *));
-- 
1.7.0.4
