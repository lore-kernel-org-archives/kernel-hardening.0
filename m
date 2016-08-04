Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	<20160802095243.GD6862@twins.programming.kicks-ass.net>
	<CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	<20160802203037.GC6879@twins.programming.kicks-ass.net>
	<CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	<87shulix2z.fsf@x220.int.ebiederm.org>
	<CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
	<20160803214437.GI6879@twins.programming.kicks-ass.net>
	<87fuqldz7m.fsf@x220.int.ebiederm.org>
	<20160804091118.GL6879@twins.programming.kicks-ass.net>
Date: Thu, 04 Aug 2016 10:13:29 -0500
In-Reply-To: <20160804091118.GL6879@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Thu, 4 Aug 2016 11:11:18 +0200")
Message-ID: <87y44c1s9y.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 03, 2016 at 09:50:37PM -0500, Eric W. Biederman wrote:
>
>> What this means in practice is user namespaces can be enabled by default
>> on a system, and yet you can easily disable them in a sandbox that was
>> built with a user namespace.
>> 
>> I named the new sysctls in my patch:
>> /proc/sys/userns/max_user_namespaces
>> /proc/sys/userns/max_pid_namespaces
>> /proc/sys/userns/max_net_namespaces
>> /proc/sys/userns/max_uts_namespaces
>> /proc/sys/userns/max_ipc_namespaces
>> /proc/sys/userns/max_cgroup_namespaces
>> /proc/sys/userns/max_mnt_namespaces
>> 
>> What Kees was suggesting was to add a similar sysctl say:
>> /proc/sys/userns/perf_event_enabled
>> 
>> And have the ability to disable perf events in each user namespaces.
>> While still being able to leave usage perf events enabled by default.
>> 
>> I don't know if any of that is a good fit for perf events.
>> 
>> For purposes of this discussion I assume we are limiting ourselves to
>> discussing userspace tracing, which semantically is 100% fine for
>> access by userspace.
>
> Right, so its basically a 'root' namespace. Not sure how this would
> help, or cover the use-cases with perf through.

The bits useful to the perf situation are:
- user namespaces nest.
- anyone can create a user namespace.
- a sysctl can be bound to the userns that takes local privilege to
  change so you can't override it arbitrarily.

Which is a long way of saying a user namespace is one way of marking
processes that may or may not use perf.

It was given in this case as an example of something that has been
looked at that appears to solve peoples concerns.

Another way to achieve a similar effect is to build something like an
rlimit.

What is attractive to me semantically about something like this is
applications that have perf_event disabled can still be traced with perf.

> Do they really only care about the sandbox? I can imagine this being
> sufficient for Android as that could do these userns thingies for each
> app or whatnot.

So the question is how do we want to apply policy in this case.
If the only concern is that there might be some bug somewhere
in the code that is undiscovered and people who don't use a feature
don't want to have to worry about it, disabling things at the
application level makes sense.

In my mind a sandbox is policy like this that I apply to my application,
in contrast a sandbox approach with a global disable or some other
specific poicy that the system administrator applies.

The really important property that I think needs to exist is a less than
system granularity.  So a solution that doesn't disable it for everyone
and doesn't disable something by default can be deployed while still
allowing the feature to be disabled where people don't want to take
the chance (such as in network facing daemons like apache).

> But does this cover the case Debian disabled perf for?
> I'm not sure I've ever seen it described _why_ they did it.

Good question.  I suspect someone should ask.  Especially since debian
defaults to 3.  perf event is disabled for everyone.

> So far I'm still liking the new capability bit better, assuming I
> understood those right.

Your subsystem your call.  I have never had much luck with capability
bits.  They are not particularly flexible, and are hard to get rid of
permanently any suid root app gains them all.

But it isn't a particularly easy problem and I don't think we have any
solutions that have lasted the test of time for this kind of thing other
than seccomp.

Eric
