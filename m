Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jul 2011 11:27:51 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110714112751.1bfd998f@notabene.brown>
In-Reply-To: <alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
References: <20110612130953.GA3709@albatros>
	<20110706173631.GA5431@albatros>
	<CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com>
	<20110706185932.GB3299@albatros>
	<20110707075610.GA3411@albatros>
	<20110707081930.GA4393@albatros>
	<20110712132723.GA3193@albatros>
	<CA+55aFysXOeBqEvmVbuqL3i0jRFDcE=vDuVhmYL38XQ0+x=deQ@mail.gmail.com>
	<20110713091408.0d456352@notabene.brown>
	<20110713063142.GA19976@openwall.com>
	<20110713170657.59dae548@notabene.brown>
	<CA+55aFwQKqvNvzTMYXVW_yKkFtNsyv8uuBiWiwYLof-nPqPu9w@mail.gmail.com>
	<alpine.LRH.2.00.1107141009510.17067@tundra.namei.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 14 Jul 2011 10:11:57 +1000 (EST) James Morris <jmorris@namei.org>
wrote:

> On Wed, 13 Jul 2011, Linus Torvalds wrote:
> 
> > It sounds like people are effectively Ack'ing the patch, but with this
> > kind of patch I don't want to add the "implicit Ack" that I often do
> > for regular stuff.
> > 
> > So could people who think that the patch is ok in its current form
> > just send me their acked-by or reviewed-by? I haven't heard any actual
> > objection to it, and I think it's valid for the current -rc.
> > 
> > Alternatively, feel free to send a comment like "I think it's the
> > right thing, but maybe it should wait for the next merge window"..
> 
> Count me in the latter.
> 
> It does look ok to me, but I'd be happier if it had more testing first (in 
> -mm perhaps).  I think some security folk may be on summer vacation, too.
> 
> 
> - James

I'm still trying to understand the full consequences, but I agree that there
is no rush - the code has been this way for quite a while and their is no
obvious threat that would expedite things (as far as I know).

However I'm not convinced that testing will help all that much - if there are
problems they will be is rare corner cases that testing is unlikely to find.

The only case where this change will improve safety is where:
 1/ a process has RLIMIT_NPROC set
 2/ the process is running with root privileges
 3/ the process calls setuid() and doesn't handle errors.


I think the only times that a root process would have RLIMIT_NPROC set are:
 1/ if it explicitly set up rlimits before calling setuid.  In this case
      we should be able to expect that the process checks setuid .. maybe
      this is naive(?)
 2/ if the process was setuid-root and inherited rlimits from before, and
      never re-set them.  In this case it is easy to imagine that a setuid()
      would not be checked.


So maybe an alternate 'fix' would be to reset all rlimits to match init_task
when a setuid-root happens.  There are other corner cases where inappropriate
rlimits can cause setuid programs to behave in ways they don't expect.
Obviously such programs are buggy, but so are programs that don't check
'setuid'.  (There is a CVE about mount potentially corrupting mtab.)

... maybe that would introduce other problems though.

In short: while I don't feel bold enough to 'nack' this patch, I don't really
feel comfortable enough to 'ack' it either.

NeilBrown
