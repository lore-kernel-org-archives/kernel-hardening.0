From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:31 -0700
Message-Id: <1491513513-84351-17-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 16/18] task_struct: Allow randomized layout
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

This marks most of the layout of task_struct as randomizable, but leaves
thread_info and scheduler state untouched at the start, and thread_struct
untouched at the end.

Additionally, this keeps the blocked and saved sigset_t fields
unrandomized relative to each other, as found in grsecurity. I tried
to find a rationale for this, but so far I haven't been able to find
instances, but it seems like a nasty enough corner case to have to debug
that I've left it in.

One question about formatting remains: should this patch indent all the
randomized fields, due to the added anonymous struct, which would make
this patch white-space huge, or should I leave the indentation level
alone, to avoid massive churn? I opted for making the patch more
readable, but can easily do the indentation...

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/sched.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 91f3ea399e0c..96903286b5dc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -490,6 +490,10 @@ struct task_struct {
 #endif
 	/* -1 unrunnable, 0 runnable, >0 stopped: */
 	volatile long			state;
+
+	/* This begins the randomizable portion of task_struct... */
+	struct {
+
 	void				*stack;
 	atomic_t			usage;
 	/* Per task flags (PF_*), defined further below: */
@@ -745,10 +749,13 @@ struct task_struct {
 	/* Signal handlers: */
 	struct signal_struct		*signal;
 	struct sighand_struct		*sighand;
-	sigset_t			blocked;
 	sigset_t			real_blocked;
-	/* Restored if set_restore_sigmask() was used: */
-	sigset_t			saved_sigmask;
+	/* These need to stay unrandomized, relative to each other. */
+	struct {
+		sigset_t			blocked;
+		/* Restored if set_restore_sigmask() was used: */
+		sigset_t			saved_sigmask;
+	};
 	struct sigpending		pending;
 	unsigned long			sas_ss_sp;
 	size_t				sas_ss_size;
@@ -1050,6 +1057,8 @@ struct task_struct {
 #ifdef CONFIG_LIVEPATCH
 	int patch_state;
 #endif
+	} __randomize_layout;
+
 	/* CPU-specific state of this task: */
 	struct thread_struct		thread;
 
-- 
2.7.4
