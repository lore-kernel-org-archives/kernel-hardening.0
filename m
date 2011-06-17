Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 17 Jun 2011 13:56:25 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110617095625.GA7627@albatros>
References: <20110617083651.GA5625@albatros>
 <1308302957.2355.5.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308302957.2355.5.camel@twins>
Subject: [kernel-hardening] Re: How to temporary change 'current' (task)
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, Ingo Molnar <mingo@elte.hu>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 17, 2011 at 11:29 +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-17 at 12:36 +0400, Vasiliy Kulikov wrote:
> > I wonder whether there is a simple way to temporary switch 'current' to
> > another task and then switch it back with minimum side effects? 
> 
> No.

After a moment's thought, it would also break some synchronization that
relies on some structures are accesses only from the current task.

> >  I need
> > it to call "reversed" ptrace_may_access() with swapped current and
> > target task.  Introducing ptrace_task_may_access_me() would produce too
> > much noise in LSM (it also needs reversed security_ptrace_access_check()),
> > which is too loud for my needs.
> > 
> > Specifically, I need it to filter taskstats and proc connector requests
> > for a restriction of getting other processes' information:
> > 
> > http://permalink.gmane.org/gmane.linux.kernel/1155354
> > 
> > As the check is handled in the context of the ptrace target process,
> > ptrace_may_access() doesn't fit my needs.
> 
> looking at __ptrace_may_access() it doesn't look too hard to make it
> take two task arguments and use __task_cred() twice instead of
> current_cred().
> 
> It of course needs extending security_ptrace_access_check() as well, but
> that comes with the territory.

Well, yes, but it implies pushing explicit ptrace actor into LSM
modules.  OK, it should be not as noisy as I initially thought - almost
all current LSMs already use "current" as an explicit argument in
theirs internal functions.

Thank you,

-- 
Vasiliy
