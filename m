Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161028093547.GA9291@gmail.com>
References: <20161026204748.GA11177@amd> <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd> <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd> <20161028070701.GA11376@gmail.com>
 <20161028085039.GA15032@amd> <20161028090423.GY3102@twins.programming.kicks-ass.net>
 <CAOMGZ=HQxkFYhHuF0mDVcwO7m4z34e_PKb6jHGVC3Jwc-mhfXQ@mail.gmail.com> <20161028093547.GA9291@gmail.com>
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Fri, 28 Oct 2016 11:47:07 +0200
Message-ID: <CAOMGZ=E3yDsRCO0mc3mk8tDBdY_mwfi-Rm4Qu=AeFpcH7WjBQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: rowhammer protection [was Re: Getting interrupt every million
 cache misses]
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>, Kees Cook <keescook@chromium.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 28 October 2016 at 11:35, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>
>> Would it make sense to sample the counter on context switch, do some
>> accounting on a per-task cache miss counter, and slow down just the
>> single task(s) with a too high cache miss rate? That way there's no
>> global slowdown (which I assume would be the case here). The task's
>> slice of CPU would have to be taken into account because otherwise you
>> could have multiple cooperating tasks that each escape the limit but
>> taken together go above it.
>
> Attackers could work this around by splitting the rowhammer workload between
> multiple threads/processes.
>
> I.e. the problem is that the risk may come from any 'unprivileged user-space
> code', where the rowhammer workload might be spread over multiple threads,
> processes or even users.

That's why I emphasised the number of misses per CPU slice rather than
just the total number of misses. I assumed there must be at least one
task continuously hammering memory for a successful attack, in which
case it should be observable with as little as 1 slice of CPU (however
long that is), no?


Vegard
