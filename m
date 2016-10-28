Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 28 Oct 2016 11:35:47 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20161028093547.GA9291@gmail.com>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028070701.GA11376@gmail.com>
 <20161028085039.GA15032@amd>
 <20161028090423.GY3102@twins.programming.kicks-ass.net>
 <CAOMGZ=HQxkFYhHuF0mDVcwO7m4z34e_PKb6jHGVC3Jwc-mhfXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMGZ=HQxkFYhHuF0mDVcwO7m4z34e_PKb6jHGVC3Jwc-mhfXQ@mail.gmail.com>
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Would it make sense to sample the counter on context switch, do some
> accounting on a per-task cache miss counter, and slow down just the
> single task(s) with a too high cache miss rate? That way there's no
> global slowdown (which I assume would be the case here). The task's
> slice of CPU would have to be taken into account because otherwise you
> could have multiple cooperating tasks that each escape the limit but
> taken together go above it.

Attackers could work this around by splitting the rowhammer workload between 
multiple threads/processes.

I.e. the problem is that the risk may come from any 'unprivileged user-space 
code', where the rowhammer workload might be spread over multiple threads, 
processes or even users.

Thanks,

	Ingo
