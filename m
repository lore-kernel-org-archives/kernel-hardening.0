Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 14:35:32 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120311103532.GA26980@openwall.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org> <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
Subject: [kernel-hardening] exec_id protection from bad child exit signals (was: Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:01:09PM -0800, Linus Torvalds wrote:
> I would in general suggest strongly against using exec_id for anything
> that involves files. It isn't designed for that, it's designed for the
> whole "check the parent exec_id" thing for ptrace, where that whole
> "pass things around to another process" approach doesn't work.

Actually, the original/historical purpose of the exec_id stuff was to
protect privileged parent processes (those having done a SUID/SGID exec)
from non-standard child exit signals, which could be set with clone().
I think we may want to audit the current implementation and see if it
still fully achieves the goal or maybe not (and fix it if not).

IIRC, 32 bits was considered enough because it was only the trusted
privileged parent process itself that could potentially cause a
wraparound.  (I did not verify this conclusion now.  It might be wrong.)

I include below pieces of the prototype implementation from
linux-2.2.12-ow6.tar.gz released in 1999.  One notable difference from
the code that went into mainline kernels was that I only incremented the
counter on privileged execve(), and I additionally handled counter
wraparound.  I am a bit concerned that a wraparound attack might be
possible on the code currently in mainline kernels, thereby allowing for
a bad exit signal to be sent to a privileged new parent program.  Does
anything prevent the wraparound attack currently?  (I did not check for
this yet, sorry.)

On exec:

+       bprm->priv_change = id_change || cap_raised;
+       if (bprm->priv_change) {
...
+               /*
+                * Increment the privileged execution counter, so that our
+                * old children know not to send bad exit_signal's to us.
+                * Also, wait on the lock if there's an exit_signal being
+                * sent to us now, to make sure it doesn't get sent to the
+                * new privileged program.
+                */
+               spin_lock_irqsave(&current->priv_lock, flags);
+               if (!++current->priv) {
+                       struct task_struct *p;
+
+                       /*
+                        * The counter can't really overflow with real-world
+                        * programs (and it has to be the privileged program
+                        * itself that causes the overflow), but we handle
+                        * this case anyway, just for correctness.
+                        */
+                       read_lock(&tasklist_lock);
+                       for_each_task(p) {
+                               if (p->p_pptr == current) {
+                                       p->ppriv = 0;
+                                       current->priv = 1;
+                               }
+                       }
+                       read_unlock(&tasklist_lock);
+               }
+               spin_unlock_irqrestore(&current->priv_lock, flags);

In task_struct:

+/* Privileged execution counters, for exit_signal permission checking */
+       spinlock_t priv_lock;
+       int priv, ppriv;

On fork() and clone():

+       spin_lock_init(&p->priv_lock);
+       p->priv = 0;
+       p->ppriv = current->priv;

Exit signal:

+       unsigned long flags = 0;
+       int locked = 0;
+
+       if (sig && sig != SIGCHLD) {
+               /*
+                * Make sure our parent hasn't executed a privileged program
+                * (such as, SUID) since we were born.
+                *
+                * We do some locking here to ensure that there's no race
+                * between the check and actually sending the signal.
+                * Currently, this is probably redundant as notify_parent()
+                * is only used either with the big lock obtained, or with
+                * the signal set to SIGCHLD.
+                */
+               locked = 1;
+               spin_lock_irqsave(&tsk->p_pptr->priv_lock, flags);
+               if (tsk->p_pptr->priv != tsk->ppriv) {
+                       spin_unlock_irqrestore(&tsk->p_pptr->priv_lock, flags);
+                       locked = 0;
+                       sig = 0;
+               }
+       }

...

+       if (locked) spin_unlock_irqrestore(&tsk->p_pptr->priv_lock, flags);

IIRC, an equivalent of the above went upstream (with simplifications
and a variables rename by Alan) in 2.2.13, so that may be another
"reference implementation" to check against.

Alexander
