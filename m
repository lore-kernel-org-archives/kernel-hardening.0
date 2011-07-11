Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 11 Jul 2011 18:07:37 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110711140737.GB3712@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
 <20110702073625.GA3318@albatros>
 <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
 <20110704174540.GA3321@albatros>
 <20110707085551.GA4718@albatros>
 <CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
 <20110707162311.GA3363@albatros>
 <CAKTCnznbAJ02-fAP+hw2EEeB3G4ux=1JwHpOKiU3HxRdRnPeig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKTCnznbAJ02-fAP+hw2EEeB3G4ux=1JwHpOKiU3HxRdRnPeig@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jul 09, 2011 at 21:06 +0530, Balbir Singh wrote:
> On Thu, Jul 7, 2011 at 9:53 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > On Thu, Jul 07, 2011 at 17:23 +0530, Balbir Singh wrote:
> >> I don't buy this use case, what are we trying to
> >> save here and why is taskstats responsible, because it notifies?
> >
> > Because it notifies _asynchronously_ in sense of the subject and
> > synchronously in sense of the object's activity.  It gives a hint when
> > some probable "chechpoint" occured.
> >
> > Please compare in the example I've posted above the cases of "poll"
> > (like test -e /proc/$pid) and "wait" (taskstats).  In the poll case it's
> > very easy to loose the moment of the race because of rescheduling.  In
> > the wait case the attacker task wakes up very closely to the race place.
> >
> 
> I tried a simple experiment and dnotify and it is possible to get
> events on exit. But that is not the point, you seem to suggest that an
> exit is a significant event for getting information about a task that
> can lead to security issues?

If there is already some flaw in program, the knowledge of an exit event
(it's not the only such event, just a sample) might make things worse.


> Do
> you at this point find anything that only taskstats exports that is
> harmful?

No.


> >> The race is that
> >> while I go off to read the data the process might disappear taking all
> >> of its data with it, which is what taskstats tries to solve among
> >> other things.
> >
> > Or the last succeeded measurement didn't happen after some sensible
> > event.
> >
> > Introducing this "race" neither fixes some bug or fully prevents some
> > exploitation technique.  It might _reduce the chance_ of exploitation.
> >
> > In my ssh exploit an attacker using procfs would have to poll
> > /proc/PID/io while 2 other processes would run - privileged sshd and
> > unprivileged sshd.  The scheduler would try to run both sshds
> > on different CPUs of 2 CPU system in parallel because sshds actively
> > exchange the data via pipes.  So, the poller might not run on any CPU
> > while the unpivileged sshd is dying.  By using taskstats I get the
> > precise information from the first attempt.
> 
> How do you use this information? Basically your concern is
> 
> 1. Information taskstats exposes (I agree, we need to audit and filter)
> 2. Exit events (I have a tough time digesting this one even with your
> examples, could you please share some details, code to show the
> exploit)

The code is plain - register and wait for ssd exit.  Pass Length = chars
- CONST.  That's all.

If I use procfs, I have to poll /proc/PID/io.  I have to (1) catch the
right moment for the measurement and (2) identify whether I've actually
succeeded in the measurement time (that I've measured that I want to
measure).  With taskstats (1) and (2) are solved by definition.  But
it seems to me I'm starting to make circles :\


My sceptic position about the whole taskstats/procfs ability to gather
aliens' processes information:

"The core problem here is that by giving *some part* of information about
internal task activity the kernel violating the task privacy, strictly
speaking.  A program doing IO expects this activity to be kept private.
This revealed part may or may not reveal sensible information, depends
on the specific program."

http://www.openwall.com/lists/oss-security/2011/06/29/4

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
