Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTimm7KDEU7WD7jVV=5vAGt2GbjgwGg@mail.gmail.com>
	<20110630075716.GB3377@albatros>
	<BANLkTik0DF5jUhOsP=Pnm+vMbHzEx+3L-Q@mail.gmail.com>
	<BANLkTi=DiVRV9dkTtYgq+CY-kxVs5ecoWw@mail.gmail.com>
Date: Fri, 1 Jul 2011 08:32:07 +0530
Message-ID: <BANLkTimnP8L3kSoafdTtUhr9CXx9-WDVLQ@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [Security] [PATCH 2/2] taskstats: restrict access to user
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Shailabh Nagar <nagar@us.ibm.com>, linux-kernel@vger.kernel.org, security@kernel.org, Eric Paris <eparis@redhat.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbir@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 30, 2011 at 10:10 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jun 30, 2011 at 3:59 AM, Balbir Singh <bsingharora@gmail.com> wrote:
>> On Thu, Jun 30, 2011 at 1:27 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>>> On Wed, Jun 29, 2011 at 13:09 -0700, Linus Torvalds wrote:
>>>> Ok, having looked at this some more, I'm quite ready to just mark the
>>>> whole TASKSTATS config option as BROKEN. It does seem to be a horrible
>>>> security hazard, and very little seems to use it.
>>>>
>>
>> I am not sure how you define BROKEN, BROKEN as per security rules?
>> /proc/$pid/xxx also expose similar information.
>
> No it doesn't.
>
> /proc/$pid/xyz has always had proper security checks. Now, sometimes
> they've been a bit too lax (iow, we've had cases where we just allowed
> things we shouldn't - like this "io" file), but /proc/pid/ at least
> *conceptually* has always had the "do I have permission to read this
> or not". Do a "cat /proc/*/* > /dev/null" and you'll be getting a lot
> of "permission denied" etc.
>

I've tried that, but fundamentally the statistics we export in
taskstats is what a utility like top would need. Compare them against
cat /proc/$pid/sched and /proc/$pid/status

> TASKSTATS? Nothing. Nada. Completely open.
>
> That's just broken.
>

Except for the I/O part, which turned about to be a cause of concern,
look at struct taskstats and please see the comment above. We have
some additional delay statistics, but I don't see them as a core
broken issue

> TASKSTATS also isn't apparently used by any normal program, and so
> never got updated to namespaces. Again, /proc/xyz/ at least *tries*:
> I'm not guaranteeing that it doesn't have some gaping holes, but I can
> at least find the logic that saves and uses namespace information.
>

Or namespaces are not being used as much, I know a lot of users use
iotop(), I've frequently gotten and handled requests to enable the
feature across distros

> Again, TASKSTATS? Not so much.
>
>> I must admit, I did not pay much attention to pid namespace changes as
>> they were being made to taskstats. I'll look at the code later this
>> week.
>
> Some of the pid namespace issues could be fixed with the attached kind
> of starting point.
>
> But it's broken. See the comment I added. Why is it broken? Again -
> taskstats is fundamentally broken, and doesn't seem to actually clean
> up after itself. The "cleanup" depends on noticing at run-time that
> some pid is stale and no longer listening. Again, that's just
> fundamental brokenness in taskstats.
>

That is lazy cleanup to avoid trapping exit events of listeners and
then having to check against the list. But if the cleanup needs to be
more active, it should be easy to fix. What I am saying is that it is
not as BROKEN as you make it sound. The attached patch is definitely a
step in the right direction and should be applied.

> And it also only look sat pid namespaces. The network namespace issue
> is separate.
>
> So that's why I think it should be marked BROKEN. What applications
> actually depend on this? iotop and what else? Because if it's just
> iotop, I do suspect we might be better off telling people "ok,
> disabling this will break iotop, but quite frankly, you're better off
> without it".

I beg to differ, due to the reasons above. I'd rather find time and
fix the pending issues (network namespace), you've fixed the pid
namespace issue. I'd also look for exiting listeners

Balbir Singh
