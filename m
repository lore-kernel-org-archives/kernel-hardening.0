Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20110721124830.GA1325@openwall.com>
References: <20110714112751.1bfd998f@notabene.brown> <20110714150602.GA30019@openwall.com>
 <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros>
 <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros>
 <1310738313.30257.27.camel@moss-pluto> <20110715152641.GA6286@albatros>
 <1310759683.30257.123.camel@moss-pluto> <20110721140936.632d2c8b@notabene.brown>
 <20110721124830.GA1325@openwall.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Jul 2011 11:21:07 -0700
Message-ID: <CA+55aFy4ybatb0McQr2f4A56ympZVLqK2sbp2=73idu58_4RxQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: Re: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from
 set_user() to do_execve_common()
To: Solar Designer <solar@openwall.com>
Cc: NeilBrown <neilb@suse.de>, Stephen Smalley <sds@tycho.nsa.gov>, Vasiliy Kulikov <segoon@openwall.com>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 21, 2011 at 5:48 AM, Solar Designer <solar@openwall.com> wrote:
>
> Maybe, and if so I think that one I proposed above falls in this
> category as well, but it closes more vulnerabilities (and/or does so
> more fully).

I think we could have a pretty simple approach that "works in
practice": retain the check at setuid() time, but make it a higher
limit.

IOW, the logic is that we have two competing pressures:

 (a) we should try to avoid failing on setuid(), because there is a
real risk that the setuid caller doesn't really check the failure case
and opens itself up for a security problem

and

 (b) never failing setuid at all is in itself a security problem,
since it can lead to DoS attacks in the form of excessive resource use
by one user.

But the sane (intelligent) solution to that is to say that we *PREFER*
to fail in execve(), but that at some point a failure in setuid() is
preferable to no failure at all. After all, we have no hard knowledge
that there is any actual setuid() issue. Neither generally does the
user (iow, look at this whole discussion where intelligent people
simply have different inputs depending on "what could happen").

So it really seems like the natural approach would be to simply fail
*earlier* on execve() and fork(). That will catch most cases, and has
no downsides. But if we notice that we are in a situation where some
privileged user can be tricked into forking a lot and doing setuid(),
then at that point the setuid() path becomes relevant.

IOW, I'd suggest simply making the rule be that "setuid() allows 10%
more users than the limit technically says". It's not a guarantee, but
it means that in order to hit the problem, you need to have *both* a
setuid application that allows unconstrained user forking *and*
doesn't check the setuid() return value.

Put another way: a user cannot force the "we're at the edge of the
setuid() limit" on its own by just forking - the user will be stopped
10% before the setuid() failure case can ever trigger.

Is this some "guarantee of nothing bad can ever happen"? No. If you
have bad setuid applications, you will have problems. But it's a "you
need to really work harder at it and you need to find more things to
go wrong", which is after all what real security is all about.

No?

                Linus
