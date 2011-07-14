Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jul 2011 19:06:02 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110714150602.GA30019@openwall.com>
References: <20110707075610.GA3411@albatros> <20110707081930.GA4393@albatros> <20110712132723.GA3193@albatros> <CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com> <20110713091408.0d456352@notabene.brown> <20110713063142.GA19976@openwall.com> <20110713170657.59dae548@notabene.brown> <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com> <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org> <20110714112751.1bfd998f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714112751.1bfd998f@notabene.brown>
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: NeilBrown <neilb@suse.de>
Cc: James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jul 14, 2011 at 11:27:51AM +1000, NeilBrown wrote:
> I'm still trying to understand the full consequences, but I agree that there
> is no rush - the code has been this way for quite a while and their is no
> obvious threat that would expedite things (as far as I know).

I don't insist on getting this in sooner than in the next merge window,
although I would have liked that.  Relevant userspace vulnerabilities
are being found quite often - I'll include some examples below.

> However I'm not convinced that testing will help all that much - if there are
> problems they will be is rare corner cases that testing is unlikely to find.

This makes sense.

> The only case where this change will improve safety is where:
>  1/ a process has RLIMIT_NPROC set
>  2/ the process is running with root privileges
>  3/ the process calls setuid() and doesn't handle errors.

Yes, and this is a pretty common case.

> I think the only times that a root process would have RLIMIT_NPROC set are:
>  1/ if it explicitly set up rlimits before calling setuid.  In this case
>       we should be able to expect that the process checks setuid .. maybe
>       this is naive(?)

RLIMIT_NPROC could be set by the parent process or by pam_limits.  The
machine I am typing this on has:

*       hard    nproc   200

(as well as other limits) in /etc/security/limits.conf, so if this
machine's kernel let setuid() fail on RLIMIT_NPROC, I would be taking
extra risk of a security compromise by reducing the risk of system
crashes from inadvertent excessive resource consumption by runaway
processes - a tradeoff I'd rather avoid.

>  2/ if the process was setuid-root and inherited rlimits from before, and
>       never re-set them.  In this case it is easy to imagine that a setuid()
>       would not be checked.

Right.  (In practice, all kinds of programs tend to forget to check
setuid() return value, though.)

Actually, for the problem to apply to setuid-root programs, they need to
switch their real uid first (more fully become root), then try to switch
to a user - but this is common.

Here are some examples for 2011-2010:

"... missing setuid() retval check in opielogin which leads to easy root
compromise":

http://www.openwall.com/lists/oss-security/2011/06/22/6

"The /usr/lib/libgnomesu/gnomesu-pam-backend suid binary which belongs
to the libgnomesu package is not checking setuid() return values.

As a result, two cooperating users, or users with access to guest,
cgi or web accounts can run arbitrary commands as root very easily."

http://www.openwall.com/lists/oss-security/2011/05/30/2

pam_xauth (exploitable if pam_limits is also used):

http://www.openwall.com/lists/oss-security/2010/08/16/2

A collection of examples from 2006:

http://lists.openwall.net/linux-kernel/2006/08/20/156

> So maybe an alternate 'fix' would be to reset all rlimits to match init_task
> when a setuid-root happens.  There are other corner cases where inappropriate
> rlimits can cause setuid programs to behave in ways they don't expect.
> Obviously such programs are buggy, but so are programs that don't check
> 'setuid'.  (There is a CVE about mount potentially corrupting mtab.)

Right, but to me possibly resetting rlimits is not an "alternative" to
moving the RLIMIT_NPROC check.  setuid-root exec is not the only case
where having setuid() fail on RLIMIT_NPROC is undesirable.  We also
don't want such failures with pam_limits, nor on daemon startup:

http://www.openwall.com/lists/oss-security/2009/07/14/2

As to resetting rlimits on SUID/SGID exec, I think this would make
sense for RLIMIT_FSIZE, which would mitigate the mount mtab issue
(thank you for bringing it up!)  But it's to be discussed separately.

Alexander
