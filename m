Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2011 17:06:57 +1000
From: NeilBrown <neilb@suse.de>
Message-ID: <20110713170657.59dae548@notabene.brown>
In-Reply-To: <20110713063142.GA19976@openwall.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] move RLIMIT_NPROC check from set_user() to
 do_execve_common()
To: Solar Designer <solar@openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Vasiliy Kulikov <segoon@openwall.com>, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>, "David S.  Miller" <davem@davemloft.net>, kernel-hardening@lists.openwall.com, Jiri Slaby <jslaby@suse.cz>, James Morris <jmorris@namei.org>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 13 Jul 2011 10:31:42 +0400 Solar Designer <solar@openwall.com> wrote:

> Linus, Neil, Motohiro - thank you for your comments!
> 
> On Wed, Jul 13, 2011 at 09:14:08AM +1000, NeilBrown wrote:
> > The contrast is really "failing when trying to use reduced privileges is
> > safer than failing to reduce privileges - if the reduced privileges are not
> > available".
> 
> Right.
> 
> > Note that there is room for a race that could have unintended consequences.
> > 
> > Between the 'setuid(ordinary-user)' and a subsequent 'exit()' after execve()
> > has failed, any other process owned by the same user (and we know where are
> > quite a few) would fail an execve() where it really should not.
> 
> It is not obvious to me that this is unintended, and that dealing with
> it in some way makes much of a difference.  (Also, it's not exactly "any
> other process owned by the same user" - this only affects processes that
> also run with similar or lower RLIMIT_NPROC.  So, for example, if a web
> server is set to use RLIMIT_NPROC of 30, but interactive logins use 40,
> then the latter may succeed and allow for shell commands to succeed.
> This is actually a common combination of settings that we've been using
> on some systems for years.)

I don't think it can be intended to cause 'execve' to fail when a user is at
the NPROC limit - except in the specific case that the process has previously
called setuid.  So I feel justified in calling it an unintended consequence.
It my not be a very common consequence but but we all know that uncommon
things do happen.

I agree that having different limits for different cases could make this much
less of a problem, but it doesn't necessarily remove it.



> 
> > I think it would be safer to add a test for PF_SUPERPRIV and PF_FORKNOEXEC
> > in current->flags and only fail the execve if both are set.
> > i.e.
> >     (current->flags & (PF_SUPERPRIV|PF_FORKNOEXEC)) == (PF_SUPERPRIV|PF_FORKNOEXEC)
> > 
> > That should narrow it down to only failing in the particular case that we are
> > interested in.
> 
> That's a curious idea, and apparently this is what NetBSD does, but
> unfortunately it does not match a common use case that we are interested
> in - specifically, Apache with suEXEC (which is part of the Apache
> distribution).  Here's what happens:
> 
> httpd runs as non-root.  It forks, execs suexec (SUID root).  suexec
> calls setuid() to the target non-root user and execve() on the CGI
> program (script, interpreter, whatever).
> 
> Notice how the fork() and the setuid() are separated by execve() of
> suexec itself.  Thus, we need to apply the RLIMIT_NPROC check on
> execve() unconditionally (well, we may allow processes with
> CAP_SYS_RESOURCE to proceed despite of the failed check, like it's
> done in -ow patches), or at least not on the condition proposed above.
> 
> Alexander

Yes, the PF_FORKNOEXEC test causes problems in that case.

Using just the PF_SUPERPRIV test would still be a good idea I think, but would
not be quite as thorough a check.
Adding a new PF flag would be possible (there seem to be 3 unused) but is
probably not justified.


NeilBrown
