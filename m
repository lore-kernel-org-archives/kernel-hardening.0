Reply-To: kernel-hardening@lists.openwall.com
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Jul 2016 13:54:02 -0700
Message-Id: <00535b14d078b4e581911a87672eaf9766539dbd.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
In-Reply-To: <cover.1468270393.git.luto@kernel.org>
References: <cover.1468270393.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH v5 29/32] kthread: to_live_kthread() needs try_get_task_stack()
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

From: Oleg Nesterov <oleg@redhat.com>

get_task_struct(tsk) no longer pins tsk->stack so all users of
to_live_kthread() should do try_get_task_stack/put_task_stack to protect
"struct kthread" which lives on kthread's stack.

TODO: Kill to_live_kthread(), perhaps we can even kill "struct kthread" too,
and rework kthread_stop(), it can use task_work_add() to sync with the exiting
kernel thread.

Message-Id: <20160629180357.GA7178@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/kthread.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 9ff173dca1ae..4ab4c3766a80 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -64,7 +64,7 @@ static inline struct kthread *to_kthread(struct task_struct *k)
 static struct kthread *to_live_kthread(struct task_struct *k)
 {
 	struct completion *vfork = ACCESS_ONCE(k->vfork_done);
-	if (likely(vfork))
+	if (likely(vfork) && try_get_task_stack(k))
 		return __to_kthread(vfork);
 	return NULL;
 }
@@ -425,8 +425,10 @@ void kthread_unpark(struct task_struct *k)
 {
 	struct kthread *kthread = to_live_kthread(k);
 
-	if (kthread)
+	if (kthread) {
 		__kthread_unpark(k, kthread);
+		put_task_stack(k);
+	}
 }
 EXPORT_SYMBOL_GPL(kthread_unpark);
 
@@ -455,6 +457,7 @@ int kthread_park(struct task_struct *k)
 				wait_for_completion(&kthread->parked);
 			}
 		}
+		put_task_stack(k);
 		ret = 0;
 	}
 	return ret;
@@ -490,6 +493,7 @@ int kthread_stop(struct task_struct *k)
 		__kthread_unpark(k, kthread);
 		wake_up_process(k);
 		wait_for_completion(&kthread->exited);
+		put_task_stack(k);
 	}
 	ret = k->exit_code;
 	put_task_struct(k);
-- 
2.7.4
