Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 29 Jun 2011 15:20:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110629112045.GA29011@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
 <20110627070300.GA4463@albatros>
 <4E08324D.9040605@jp.fujitsu.com>
 <20110627085242.GA6635@albatros>
 <BANLkTimFkb1TK_u+Xqp6LnRgzMAv21jFHg@mail.gmail.com>
 <20110628075053.GA4009@albatros>
 <BANLkTimBMz8onkYDsz6D_An7q0k0wZVyUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimBMz8onkYDsz6D_An7q0k0wZVyUw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: Balbir Singh <bsingharora@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 29, 2011 at 06:46 +0530, Balbir Singh wrote:
> On Tue, Jun 28, 2011 at 1:20 PM, Vasiliy Kulikov <segoon@openwall.com> wrote:
> > On Tue, Jun 28, 2011 at 06:54 +0530, Balbir Singh wrote:
> >> > As to rounding - this is a workaround, not a fix.  What if some program
> >> > reads one byte from tty and then do some io activity exactly of 1kb-1?
> >> > Then you just measure kbs and get original tty activity.  (just a crazy
> >> > example to show that it is not a full solution.)
> >> >
> >>
> >> That would happen with a probability of 1/1024
> >
> > I'd not claim about probability here, but anyway rounding would be not
> > a fix, just a workaround.  Also note that the random value is program
> > dependent, it is not chosen at the program start time or anything
> > similar.  IOW, if the program is vulnerable, it is vulnerable with 100%
> > probability.
> >
> 
> I was thinking along ASLR lines, ASLR reduces the probability of
> malware finding specific address in code, but does not eliminate it
> completely.

You confuse a bug fix with a prevention of an exploitation technique
here.  ASLR doesn't fix anything, it tries to break exploits that use
bugs like arbitrary writes/reads.  If there is arbitrary write bug,
almost always the game is over; that's why such probabilistic measure is
acceptable.  On the contrary, /proc/*/io leak is a bug, which is fairly
fixable by restricting an access (breaking programs, though).  So, from
the security point of view these cases are not comparable.


> In the worst case as you suggest may
> be the statistics would be available only to root, but that is the
> final drop down scenario.

Yes, it breaks iotop, but it is a full solution.


> No we don't clear taskstats info on credential changes.

If taskstats info is allowed to travel through credential changes, it
exposes the similar private information.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
