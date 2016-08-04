Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 4 Aug 2016 11:11:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20160804091118.GL6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net>
 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
 <CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
 <20160803214437.GI6879@twins.programming.kicks-ass.net>
 <87fuqldz7m.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fuqldz7m.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 03, 2016 at 09:50:37PM -0500, Eric W. Biederman wrote:

> What this means in practice is user namespaces can be enabled by default
> on a system, and yet you can easily disable them in a sandbox that was
> built with a user namespace.
> 
> I named the new sysctls in my patch:
> /proc/sys/userns/max_user_namespaces
> /proc/sys/userns/max_pid_namespaces
> /proc/sys/userns/max_net_namespaces
> /proc/sys/userns/max_uts_namespaces
> /proc/sys/userns/max_ipc_namespaces
> /proc/sys/userns/max_cgroup_namespaces
> /proc/sys/userns/max_mnt_namespaces
> 
> What Kees was suggesting was to add a similar sysctl say:
> /proc/sys/userns/perf_event_enabled
> 
> And have the ability to disable perf events in each user namespaces.
> While still being able to leave usage perf events enabled by default.
> 
> I don't know if any of that is a good fit for perf events.
> 
> For purposes of this discussion I assume we are limiting ourselves to
> discussing userspace tracing, which semantically is 100% fine for
> access by userspace.

Right, so its basically a 'root' namespace. Not sure how this would
help, or cover the use-cases with perf through.

Do they really only care about the sandbox? I can imagine this being
sufficient for Android as that could do these userns thingies for each
app or whatnot. But does this cover the case Debian disabled perf for?
I'm not sure I've ever seen it described _why_ they did it.

So far I'm still liking the new capability bit better, assuming I
understood those right.
