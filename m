Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87shulix2z.fsf@x220.int.ebiederm.org>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net> <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net> <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
 <87shulix2z.fsf@x220.int.ebiederm.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 3 Aug 2016 11:53:41 -0700
Message-ID: <CAGXu5j+wrXtp5oDAmyUWf7Gt9mWa4SfuqnnMBW+74UuC0YDD1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 3, 2016 at 10:25 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Sigh.
>
> Kees we have already had this conversation about user namespaces and
> apparently you missed the point.

Well, I didn't miss the point: that's why I CCed you. :) This is
nearly the same discussion (though in this case there is already a
sysctl, hence this thread).

> As I have said before the problem with a system wide off switch is what
> happens when you have a single application that needs to use the
> feature.  Without care your system wide protection disappears.
> That is very brittle design.

Yeah, the use-cases tend to be "never", "always", "this process", and
"this user". The way Android would like to be handling the permission,
though, gets back to another thing we talked about briefly when
discussing userns: revocation. Android wants to turn the entire
permission on and off across the entire system, so things like
capabilities or privileged fds or something don't quite fit that
either.

> What I see as much more palatable is a design that allows for
> features to be turned off in sandboxes.
>
> So please if you are going to worry about disabling large swaths of
> the kernel to reduce the attack surface please come up with designs
> that are not brittle in allowing users to use a feature nor are they
> brittle in keeping the feature disabled where you want it disabled.

Yup, Linus asked for this too. I haven't come up with anything
particularly great yet. :P

> One of the strengths of linux is applications of features the authors of
> the software had not imagined.  Your proposals seem to be trying to put
> the world a tiny little box where if someone had not imagined and
> preapproved a use of a feature it should not happen.   Let's please
> avoid implementing totalitarianism to avoid malicious code exploiting
> bugs in the kernel.  I am not interested in that future.

To be clear: I'm interested in giving system owners greater control
over what's exposed. That's not about limiting access everywhere. And
I'm interested in making sure that the upstream kernel actually
provides what end-users want. In the most extreme version of this is
when distros carry kernel patches to get it done (this was true with
userns and is true again here with perf). This IS a desired features,
and it exists in the world. I want to avoid the confusion that arises
from people running patched kernels: upstream developers don't realize
what state their features are in when they reach end users,
documentation doesn't match, etc etc.

However, I do accept that the existing mechanisms that have served
Linux over the years (sysctls, capabilities, etc) are woefully
insufficient in many of these cases.

> Especially when dealing with disabling code to reduce attack surface,
> when then are no known attacks what we are actually dealing with
> is a small percentage probability reduction that a malicious attacker
> will be able to exploit the attack.

But there are bugs. We just haven't found them. Based on the past
research by Jon Corbet (and again recently by me) we're sitting on at
least 1 new critical bug that we won't find for the next 5 years (and
we've got at least 1 more each that are on average 1, 2, 3, and 4
years old that we haven't found yet either).

> Remember security is as much about availability as it is about
> integrity.  You keep imagining features that are great big denial of
> service attacks on legitimate users.

That's not my goal: legitimate users should have access. That's up to
system owners. But I'd like to provide ways for system owners to keep
illegitimate users from having access. :)

> Kees Cook <keescook@chromium.org> writes:
>
>> On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> Let me take this another way instead. What would be a better way to
>> provide a mechanism for system owners to disable perf without an LSM?
>> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
>> wide a coverage as possible.)
>
> I vote for sandboxes.  Perhaps seccomp.  Perhaps a per userns sysctl.
> Perhaps something else.

Peter, did you happen to see Eric's solution to this problem for
namespaces? Basically, a per-userns sysctl instead of a global sysctl.
Is that something that would be acceptable here?

-Kees

-- 
Kees Cook
Brillo & Chrome OS Security
