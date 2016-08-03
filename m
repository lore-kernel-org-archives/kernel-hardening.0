Reply-To: kernel-hardening@lists.openwall.com
From: ebiederm@xmission.com (Eric W. Biederman)
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	<20160802095243.GD6862@twins.programming.kicks-ass.net>
	<CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	<20160802203037.GC6879@twins.programming.kicks-ass.net>
	<CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
Date: Wed, 03 Aug 2016 12:25:24 -0500
In-Reply-To: <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	(Kees Cook's message of "Tue, 2 Aug 2016 13:51:47 -0700")
Message-ID: <87shulix2z.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further restriction of perf_event_open
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


Sigh.

Kees we have already had this conversation about user namespaces and
apparently you missed the point.

As I have said before the problem with a system wide off switch is what
happens when you have a single application that needs to use the
feature.  Without care your system wide protection disappears.
That is very brittle design.

What I see as much more palatable is a design that allows for
features to be turned off in sandboxes.

So please if you are going to worry about disabling large swaths of
the kernel to reduce the attack surface please come up with designs
that are not brittle in allowing users to use a feature nor are they
brittle in keeping the feature disabled where you want it disabled.


One of the strengths of linux is applications of features the authors of
the software had not imagined.  Your proposals seem to be trying to put
the world a tiny little box where if someone had not imagined and
preapproved a use of a feature it should not happen.   Let's please
avoid implementing totalitarianism to avoid malicious code exploiting
bugs in the kernel.  I am not interested in that future.

Especially when dealing with disabling code to reduce attack surface,
when then are no known attacks what we are actually dealing with
is a small percentage probability reduction that a malicious attacker
will be able to exploit the attack.

Remember security is as much about availability as it is about
integrity.  You keep imagining features that are great big denial of
service attacks on legitimate users.

Kees Cook <keescook@chromium.org> writes:

> On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> Let me take this another way instead. What would be a better way to
> provide a mechanism for system owners to disable perf without an LSM?
> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
> wide a coverage as possible.)

I vote for sandboxes.  Perhaps seccomp.  Perhaps a per userns sysctl.
Perhaps something else.

Eric
