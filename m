Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Tue, 28 Jun 2011 11:50:53 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110628075053.GA4009@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
 <20110627070300.GA4463@albatros>
 <4E08324D.9040605@jp.fujitsu.com>
 <20110627085242.GA6635@albatros>
 <BANLkTimFkb1TK_u+Xqp6LnRgzMAv21jFHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimFkb1TK_u+Xqp6LnRgzMAv21jFHg@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
To: Balbir Singh <bsingharora@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com, akpm@linux-foundation.org, viro@zeniv.linux.org.uk, rientjes@google.com, wilsons@start.ca, security@kernel.org, eparis@redhat.com, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 28, 2011 at 06:54 +0530, Balbir Singh wrote:
> > As to rounding - this is a workaround, not a fix.  What if some program
> > reads one byte from tty and then do some io activity exactly of 1kb-1?
> > Then you just measure kbs and get original tty activity.  (just a crazy
> > example to show that it is not a full solution.)
> >
> 
> That would happen with a probability of 1/1024

I'd not claim about probability here, but anyway rounding would be not
a fix, just a workaround.  Also note that the random value is program
dependent, it is not chosen at the program start time or anything
similar.  IOW, if the program is vulnerable, it is vulnerable with 100%
probability.


> >> > Also I'm worried about these statistics after dropping the privileges.
> >> > After setuid() and similar things not changing pid unprivileged user
> >> > gets some information about the previous io activity of this task being
> >> > privileged.  In some situations it doesn't reveal any sensitive
> >> > information, in some it might.  Clearing taskstats on credential
> >> > changing functions would totally break taskstats' interfaces; and should
> >> > be temporary changing fsuid/euid followed by reverting it considered
> >> > harmfull?  I don't know.
> >>
> >> Can you please explain more? I'm feeling "reset at credential change" is
> >> reasonable idea. How broken is there?
> >
> > In the code I see taskstats statistics is kept untouched, so it would
> > break userspace assumptions about the statistics.
> >
> 
> Could you please elaborate on this point?

It's better to consider my phrase as a question :)  Like this: don't
userspace programs rely on the fact that all statistic information
wouldn't be cleared after execve()/set*id()/prctl() ?  I'm not familiar
with taskstats at all, so I don't know whether this assumption makes
sense to userspace application.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
