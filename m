Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110707162311.GA3363@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
	<20110629201718.GA11071@albatros>
	<20110702073625.GA3318@albatros>
	<CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
	<20110704174540.GA3321@albatros>
	<20110707085551.GA4718@albatros>
	<CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
	<20110707162311.GA3363@albatros>
Date: Sat, 9 Jul 2011 21:06:05 +0530
Message-ID: <CAKTCnznbAJ02-fAP+hw2EEeB3G4ux=1JwHpOKiU3HxRdRnPeig@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 7, 2011 at 9:53 PM, Vasiliy Kulikov <segoon@openwall.com> wrote=
:
> On Thu, Jul 07, 2011 at 17:23 +0530, Balbir Singh wrote:
>> On Thu, Jul 7, 2011 at 2:25 PM, Vasiliy Kulikov <segoon@openwall.com> wr=
ote:
>> > 1) unblocking netlink socket on task exit is a rather useful help to w=
in
>> > different races. =A0E.g. if the vulnerable program has the code -
>> >
>> > =A0 =A0wait(NULL);
>> > =A0 =A0do_smth_racy();
>> >
>> > - then the attacker's task listening for the taskstats event will be
>> > effectively woken up just before the racy code. =A0It might greatly
>> > increase the chanses to win the race =3D> to exploit the bug.
>> > (The same defect exists in inotify.)
>> >
>>
>> I don't see why taskstats is singled out, please look at proc
>> notifiers as well.
>
> Do you mean proc connector? =A0AFAICS, it is available to root only. =A0A=
nd

Yes, good point, it reuses the netlink nl_groups mechanism

> no, taskstats is not singled out - I mentioned inotify as another
> example. =A0The kernel might be vulnerable to many side channel attacks,
> using different interfaces.
>
>
>> I don't buy this use case, what are we trying to
>> save here and why is taskstats responsible, because it notifies?
>
> Because it notifies _asynchronously_ in sense of the subject and
> synchronously in sense of the object's activity. =A0It gives a hint when
> some probable "chechpoint" occured.
>
> Please compare in the example I've posted above the cases of "poll"
> (like test -e /proc/$pid) and "wait" (taskstats). =A0In the poll case it'=
s
> very easy to loose the moment of the race because of rescheduling. =A0In
> the wait case the attacker task wakes up very closely to the race place.
>

I tried a simple experiment and dnotify and it is possible to get
events on exit. But that is not the point, you seem to suggest that an
exit is a significant event for getting information about a task that
can lead to security issues?

>
>> > 2) taskstats gives the task information at the precisely specific mome=
nt
>> > - task death. =A0So, the attacker shouldn't guess whether some event
>> > occured or not. =A0The formula of gotten information is _exactly_ task
>> > activity during the life. =A0On the contrary, getting the same informa=
tion
>> > from procfs files might result in some inaccuracy because of measuring
>> > time inaccuracy (scheduler's variability, different disks' load, etc.)=
.
>> >
>> > Of cource, (2) makes sense only if some sensible information is still
>> > available through taskstats.
>>
>> Again this makes no sense to me, at the end we send accumulated data
>> and that data can be read from /proc/$pid (mostly).
>
> Umm... =A0If both taskstats and procfs expose some sensible information,
> both should be fixed, no?
>

Yes, sure. I am all for auditing the fields of taskstats and
/proc/$pid/* and making the distinction as to what can be exposed. Do
you at this point find anything that only taskstats exports that is
harmful?

>
>> The race is that
>> while I go off to read the data the process might disappear taking all
>> of its data with it, which is what taskstats tries to solve among
>> other things.
>
> Or the last succeeded measurement didn't happen after some sensible
> event.
>
> Introducing this "race" neither fixes some bug or fully prevents some
> exploitation technique. =A0It might _reduce the chance_ of exploitation.
>
> In my ssh exploit an attacker using procfs would have to poll
> /proc/PID/io while 2 other processes would run - privileged sshd and
> unprivileged sshd. =A0The scheduler would try to run both sshds
> on different CPUs of 2 CPU system in parallel because sshds actively
> exchange the data via pipes. =A0So, the poller might not run on any CPU
> while the unpivileged sshd is dying. =A0By using taskstats I get the
> precise information from the first attempt.

How do you use this information? Basically your concern is

1. Information taskstats exposes (I agree, we need to audit and filter)
2. Exit events (I have a tough time digesting this one even with your
examples, could you please share some details, code to show the
exploit)

Balbir Singh
