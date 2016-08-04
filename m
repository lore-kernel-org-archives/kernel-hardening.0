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
Date: Wed, 03 Aug 2016 21:50:37 -0500
In-Reply-To: <20160803214437.GI6879@twins.programming.kicks-ass.net> (Peter
	Zijlstra's message of "Wed, 3 Aug 2016 23:44:37 +0200")
Message-ID: <87fuqldz7m.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

Peter Zijlstra <peterz@infradead.org> writes:

> On Wed, Aug 03, 2016 at 11:53:41AM -0700, Kees Cook wrote:
>> > Kees Cook <keescook@chromium.org> writes:
>> >
>> >> On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> Let me take this another way instead. What would be a better way to
>> >> provide a mechanism for system owners to disable perf without an LSM?
>> >> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
>> >> wide a coverage as possible.)
>> >
>> > I vote for sandboxes.  Perhaps seccomp.  Perhaps a per userns sysctl.
>> > Perhaps something else.
>> 
>> Peter, did you happen to see Eric's solution to this problem for
>> namespaces? Basically, a per-userns sysctl instead of a global sysctl.
>> Is that something that would be acceptable here?
>
> Someone would have to educate me on what a userns is and how that would
> help here.

userns is an abbreviation for user namespace.

How it might help is that it is an easy unescapable context for
processes.  Essentialy the idea is to limit the scope of the sysctl to a
container.

User namespaces run into flack because while tremendously simple in
themselves the code takes advantage of the fact that suid root
executables in a user namespace do not have privileges on anything
outside of the user namespace.  Which means that it is semantically safe
to allow operations like creating mount namespaces, mount filesystems,
creating network namespaces, manipulating the network stack etc.  All of
which allows unprivileged users (that can create network namespaces) to
exercise more kernel code and exercise those bugs.

Fundamentally user namespaces as objects you can create need limits on
the maximum number of user namespaces you can create to cawtch run away
processes.  Set the limit you can create to 0 and you get what Kees
wants.

In my pending patches that were not quite ready for the merge window, I
added a sysctl that described the maximum number of user namepaces that
could be created (default value threads-max), and implemented the sysctl
in a per user way.  Such that counts and limits were kept for every user
namespace.  In a nested user namespace (which are all of them except for
the initial user namspace) the count and limit would be checked in the
current user namepsace, then the count would be incremented in the parent
and verified the count was below the limit in the parent user namespace.

What this means in practice is user namespaces can be enabled by default
on a system, and yet you can easily disable them in a sandbox that was
built with a user namespace.

I named the new sysctls in my patch:
/proc/sys/userns/max_user_namespaces
/proc/sys/userns/max_pid_namespaces
/proc/sys/userns/max_net_namespaces
/proc/sys/userns/max_uts_namespaces
/proc/sys/userns/max_ipc_namespaces
/proc/sys/userns/max_cgroup_namespaces
/proc/sys/userns/max_mnt_namespaces

What Kees was suggesting was to add a similar sysctl say:
/proc/sys/userns/perf_event_enabled

And have the ability to disable perf events in each user namespaces.
While still being able to leave usage perf events enabled by default.

I don't know if any of that is a good fit for perf events.

For purposes of this discussion I assume we are limiting ourselves to
discussing userspace tracing, which semantically is 100% fine for
access by userspace.

Eric
