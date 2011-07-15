Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 15 Jul 2011 17:04:09 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110715130409.GA2700@openwall.com>
References: <20110713063142.GA19976@openwall.com> <20110713170657.59dae548@notabene.brown> <CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com> <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org> <20110714112751.1bfd998f@notabene.brown> <20110714150602.GA30019@openwall.com> <20110715133013.4fa38d19@notabene.brown> <20110715063113.GA3166@albatros> <20110715170650.585f1dad@notabene.brown> <20110715073823.GA3821@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715073823.GA3821@albatros>
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: NeilBrown <neilb@suse.de>, kernel-hardening@lists.openwall.com, James Morris <jmorris@namei.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>, Willy Tarreau <w@1wt.eu>, Sebastian Krahmer <krahmer@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Neil, Vasiliy -

On Fri, Jul 15, 2011 at 11:38:23AM +0400, Vasiliy Kulikov wrote:
> On Fri, Jul 15, 2011 at 17:06 +1000, NeilBrown wrote:
> > How about this then?
> 
> AFAIU, with this patch:
> 
> 1) setuid() doesn't fail in NPROC exceed case.
> 2) NPROC is forced on execve() after setuid().
> 3) execve() fails only if NPROC was exceeded during setuid() execution.
> 4) Other processes of the same user doesn't suffer from "occasional"
> execve() failures.
> 
> If it is correct, then I like the patch :)

I'm not convinced this has any advantages over the patch Vasiliy had
posted (which simply moved the RLIMIT_NPROC check), but I don't mind,
with one important correction:

Although in the primary use cases we're considering, setuid() is very
soon followed by execve(), this doesn't always have to be the case.
There may be cases where the process would sleep between these two calls
(for a variety of reasons).  It would be surprising to see a process
fail on execve() because of RLIMIT_NPROC when that limit had been
reached, say, days ago and is no longer reached at the time of execve().

Thus, if we go with Neil's proposal (adding/checking an extra flag), we
should also re-check the process count against RLIMIT_NPROC on execve(),
and fail the exec only when both the flag is set and the current process
count is excessive (still or again).

Also, if we go with a patch like this, it brings up the question of
whether the flag should be preserved or reset on fork().  I think it
should be preserved.

> It does RLIMIT_NPROC
> enforcement without mixing other execve() calls like -ow patch did.

"Mixing other execve() calls" (4 on the list above) is not obviously
undesirable.  Thus, either Vasiliy's original patch or Neil's patch with
the addition mentioned above would be fine by me.

Thanks,

Alexander
