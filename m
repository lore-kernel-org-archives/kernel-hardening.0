Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 21 Jul 2011 23:39:39 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110721193939.GA3914@openwall.com>
References: <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros> <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros> <1310738313.30257.27.camel@moss-pluto> <20110715152641.GA6286@albatros> <1310759683.30257.123.camel@moss-pluto> <20110721140936.632d2c8b@notabene.brown> <20110721124830.GA1325@openwall.com> <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 21, 2011 at 11:21:07AM -0700, Linus Torvalds wrote:
> I think we could have a pretty simple approach that "works in
> practice": retain the check at setuid() time, but make it a higher
> limit.
> 
> IOW, the logic is that we have two competing pressures:
> 
>  (a) we should try to avoid failing on setuid(), because there is a
> real risk that the setuid caller doesn't really check the failure case
> and opens itself up for a security problem
> 
> and
> 
>  (b) never failing setuid at all is in itself a security problem,
> since it can lead to DoS attacks in the form of excessive resource use
> by one user.

I don't recall anyone stating (b) the way you did above (or sufficiently
similar).  I wouldn't consider setuid() never failing to be a security
problem.  BTW, some people consider setuid() failing on RLIMIT_NPROC
kernel "brokenness", which applications have to "work around":

http://www.openwall.com/lists/musl/2011/07/21/3

"I'm aware of course that some interfaces *can* fail for nonstandard
reasons under Linux (dup2 and set*uid come to mind), and I've tried to
work around these and shield applications from the brokenness..."

So opinions on setuid() failing vary, whereas (a) is clear - there have
been vulnerabilities caused by setuid() failing.

The DoS that you mention doesn't necessarily have to be dealt with by
setuid() failing on RLIMIT_NPROC (nor on a higher limit).  It could also
be dealt with by checking the limit on execve(), like we've been doing
on shared web hosting servers for years, and, if desired, by letting
applications like Android/Zygote check for the condition themselves via
a new prctl() (or they can simply pass an extra fork(), although that's
a bit costly).

> IOW, I'd suggest simply making the rule be that "setuid() allows 10%
> more users than the limit technically says". It's not a guarantee, but
> it means that in order to hit the problem, you need to have *both* a
> setuid application that allows unconstrained user forking *and*
> doesn't check the setuid() return value.
> 
> Put another way: a user cannot force the "we're at the edge of the
> setuid() limit" on its own by just forking - the user will be stopped
> 10% before the setuid() failure case can ever trigger.

For a malicious user, this merely adds the task of triggering a race
condition - have a sufficient number of processes accumulate in the
between setuid() and execve() state.  If the program in question can be
made to sleep, this may be trivial to do.  Otherwise, it may require
very rapid requests (automated) and high system load.

(BTW, 10% of 0 would be 0, which would allow for attacks that are as
simple as they're now, but that's an implementation detail.  Of course,
you'd actually add some constant as well.)

> Is this some "guarantee of nothing bad can ever happen"? No. If you
> have bad setuid applications, you will have problems. But it's a "you
> need to really work harder at it and you need to find more things to
> go wrong", which is after all what real security is all about.
> 
> No?

I generally support having multiple layers of security even if some are
non-perfect, but in this case we have a problem that we can _fully_ deal
with rather than merely make attacks harder.

So my proposal remains to go with Vasiliy's trivial patch and maybe add
a few things on top of it as I mentioned in my previous message.

Thanks,

Alexander
