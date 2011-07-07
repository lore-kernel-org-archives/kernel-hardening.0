Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110707085551.GA4718@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
	<BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
	<20110629201718.GA11071@albatros>
	<20110702073625.GA3318@albatros>
	<CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
	<20110704174540.GA3321@albatros>
	<20110707085551.GA4718@albatros>
Date: Thu, 7 Jul 2011 17:23:39 +0530
Message-ID: <CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
From: Balbir Singh <bsingharora@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 7, 2011 at 2:25 PM, Vasiliy Kulikov <segoon@openwall.com> wrote=
:
> On Mon, Jul 04, 2011 at 21:45 +0400, Vasiliy Kulikov wrote:
>> The already known danger is these io fields.
>
> Two more things:
>
> 1) unblocking netlink socket on task exit is a rather useful help to win
> different races. =A0E.g. if the vulnerable program has the code -
>
> =A0 =A0wait(NULL);
> =A0 =A0do_smth_racy();
>
> - then the attacker's task listening for the taskstats event will be
> effectively woken up just before the racy code. =A0It might greatly
> increase the chanses to win the race =3D> to exploit the bug.
> (The same defect exists in inotify.)
>

I don't see why taskstats is singled out, please look at proc
notifiers as well. I don't buy this use case, what are we trying to
save here and why is taskstats responsible, because it notifies?

>
> 2) taskstats gives the task information at the precisely specific moment
> - task death. =A0So, the attacker shouldn't guess whether some event
> occured or not. =A0The formula of gotten information is _exactly_ task
> activity during the life. =A0On the contrary, getting the same informatio=
n
> from procfs files might result in some inaccuracy because of measuring
> time inaccuracy (scheduler's variability, different disks' load, etc.).
>
> Of cource, (2) makes sense only if some sensible information is still
> available through taskstats.

Again this makes no sense to me, at the end we send accumulated data
and that data can be read from /proc/$pid (mostly). The race is that
while I go off to read the data the process might disappear taking all
of its data with it, which is what taskstats tries to solve among
other things. Your use case has a lot of hand waving, which I frankly
cannot put to a logical place in my mind.

Balbir Singh
