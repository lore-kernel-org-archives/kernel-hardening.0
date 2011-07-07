Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 7 Jul 2011 20:23:11 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110707162311.GA3363@albatros>
References: <1308917362-4795-1-git-send-email-segoon@openwall.com>
 <BANLkTi=dTHGK1QVs+g2tA6WocQ64SPPF3g@mail.gmail.com>
 <20110629201718.GA11071@albatros>
 <20110702073625.GA3318@albatros>
 <CAKTCnzmjaddz-ihxJ_qme28S==BAPGRmC2j3iE5fqm8TPi0knA@mail.gmail.com>
 <20110704174540.GA3321@albatros>
 <20110707085551.GA4718@albatros>
 <CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKTCnzn25jUOmefuTPsLwbGGoj5sgz8-CgiV6XO-dMbNuD8Mzg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 2/2] taskstats: restrict access to user
To: Balbir Singh <bsingharora@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, security@kernel.org, Eric Paris <eparis@redhat.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 07, 2011 at 17:23 +0530, Balbir Singh wrote:
> On Thu, Jul 7, 2011 at 2:25 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > 1) unblocking netlink socket on task exit is a rather useful help to win
> > different races.  E.g. if the vulnerable program has the code -
> >
> >    wait(NULL);
> >    do_smth_racy();
> >
> > - then the attacker's task listening for the taskstats event will be
> > effectively woken up just before the racy code.  It might greatly
> > increase the chanses to win the race => to exploit the bug.
> > (The same defect exists in inotify.)
> >
> 
> I don't see why taskstats is singled out, please look at proc
> notifiers as well.

Do you mean proc connector?  AFAICS, it is available to root only.  And
no, taskstats is not singled out - I mentioned inotify as another
example.  The kernel might be vulnerable to many side channel attacks,
using different interfaces.


> I don't buy this use case, what are we trying to
> save here and why is taskstats responsible, because it notifies?

Because it notifies _asynchronously_ in sense of the subject and
synchronously in sense of the object's activity.  It gives a hint when
some probable "chechpoint" occured.

Please compare in the example I've posted above the cases of "poll"
(like test -e /proc/$pid) and "wait" (taskstats).  In the poll case it's
very easy to loose the moment of the race because of rescheduling.  In
the wait case the attacker task wakes up very closely to the race place.


> > 2) taskstats gives the task information at the precisely specific moment
> > - task death.  So, the attacker shouldn't guess whether some event
> > occured or not.  The formula of gotten information is _exactly_ task
> > activity during the life.  On the contrary, getting the same information
> > from procfs files might result in some inaccuracy because of measuring
> > time inaccuracy (scheduler's variability, different disks' load, etc.).
> >
> > Of cource, (2) makes sense only if some sensible information is still
> > available through taskstats.
> 
> Again this makes no sense to me, at the end we send accumulated data
> and that data can be read from /proc/$pid (mostly).

Umm...  If both taskstats and procfs expose some sensible information,
both should be fixed, no?


> The race is that
> while I go off to read the data the process might disappear taking all
> of its data with it, which is what taskstats tries to solve among
> other things.

Or the last succeeded measurement didn't happen after some sensible
event.

Introducing this "race" neither fixes some bug or fully prevents some
exploitation technique.  It might _reduce the chance_ of exploitation.

In my ssh exploit an attacker using procfs would have to poll
/proc/PID/io while 2 other processes would run - privileged sshd and
unprivileged sshd.  The scheduler would try to run both sshds
on different CPUs of 2 CPU system in parallel because sshds actively
exchange the data via pipes.  So, the poller might not run on any CPU
while the unpivileged sshd is dying.  By using taskstats I get the
precise information from the first attempt.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
