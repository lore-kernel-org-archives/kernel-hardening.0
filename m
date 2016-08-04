Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 17:37:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160804153742.GN6879@twins.programming.kicks-ass.net>
References: <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
 <20160803214437.GI6879@twins.programming.kicks-ass.net>
 <87fuqldz7m.fsf@x220.int.ebiederm.org>
 <20160804091118.GL6879@twins.programming.kicks-ass.net>
 <87y44c1s9y.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y44c1s9y.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Aug 04, 2016 at 10:13:29AM -0500, Eric W. Biederman wrote:

> The bits useful to the perf situation are:
> - user namespaces nest.
> - anyone can create a user namespace.
> - a sysctl can be bound to the userns that takes local privilege to
>   change so you can't override it arbitrarily.
> 
> Which is a long way of saying a user namespace is one way of marking
> processes that may or may not use perf.
> 
> It was given in this case as an example of something that has been
> looked at that appears to solve peoples concerns.

> What is attractive to me semantically about something like this is
> applications that have perf_event disabled can still be traced with perf.

> > So far I'm still liking the new capability bit better, assuming I
> > understood those right.
> 
> Your subsystem your call.  I have never had much luck with capability
> bits.  They are not particularly flexible, and are hard to get rid of
> permanently any suid root app gains them all.

Right, so I've no experience with any of this.

But from what I understood amluto recently made capabilities much more
useful with: 58319057b784 ("capabilities: ambient capabilities").

And the thing I like is having file capabilities, so even though the
user cannot in general create perf events, we could mark the
/usr/bin/perf executable as having CAP_PERF and allow it to create them,
because its a 'trusted' executable.

Can something like that be done with userns? Afaiu once you create a
userns with perf disabled, even a nested one cannot re-enable it,
otherwise you cannot create sandboxes.
