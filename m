Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 4 Jul 2011 00:01:06 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110703200106.GB9714@albatros>
References: <20110703103925.GA2283@albatros>
 <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwfr-oAa-2L9O_rd9iZDyVr0b+gFQS=_R5PUxmhh3JEsg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] proc: fix a race in do_io_accounting()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jul 03, 2011 at 12:24 -0700, Linus Torvalds wrote:
> On Sun, Jul 3, 2011 at 3:39 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> >
> > The order of locking is similar to the one inside of
> > ptrace_attach(): first goes cred_guard_mutex, then lock_task_sighand().
> 
> Hmm. mm_for_maps() uses mutex_lock_killable(), as does lock_trace.

Killable/interruptable here makes sense.


> And neither proc_pid_wchan() nor the fd following ones
> (proc_pid_follow_link etc) use anything at all.
> 
> So I'm not sure. And do we really even care about the theoretical
> race? Even if we do hit the race window and happen to get it just as a
> process turns setuid, it would seem to be totally harmless (we're not
> going to see any of the sensitive IO anyway).

I consider this as a theoretical race too unless there is a crazy bug in
scheduler/timer.  But IMO it's better to just fully remove the risk
(even purely theoretical) given the lock is simple and it doesn't cost
much.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
