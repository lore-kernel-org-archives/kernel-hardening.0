Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 23:41:36 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120312224136.GH10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <m1pqchocok.fsf@fess.ebiederm.org>
 <20120312204416.GG10787@dztty>
 <m11uoxij9c.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11uoxij9c.fsf@fess.ebiederm.org>
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2012 at 02:47:43PM -0700, Eric W. Biederman wrote:
> Djalal Harouni <tixxdz@opendz.org> writes:
> 
> > On Mon, Mar 12, 2012 at 12:13:15PM -0700, Eric W. Biederman wrote:
> >> Djalal Harouni <tixxdz@opendz.org> writes:
> >> 
> >> > Procfs files and other important objects may contain sensitive information
> >> > which must not be seen, inherited or processed across execve.
> >> 
> >> So I am dense.  /proc/<pid>/mem was special in that it uses a different
> >> set of checks than other files, and to do those access checks
> >> /proc/<pid>/mem needed to look at exec_id.
> > If you are referring to the old protection, yes it was against an ID, but
> > not uniq IDs, so you can execve a suid do some tricks to have a match on IDs
> > and bypass the protection, how: by opening your /proc/self/mem and pass
> > the fd to the exec suid who at read/write time will process its own
> > /proc/self/mem
> 
> Yes that case is silly and I don't care.  I care that you seem to be
> stomping all over the non-silly cases using the excuse that there
> was one silly case.
I'm not sure I follow you here, these proc files suffer from the same
problems, can you please point what are these non-silly case ?


> >> For all of the access checks that are not written in that silly way.
> >> What is wrong with ptrace_may_access run at every read/write of a file?
> > As it was noted, these files change during runtime, so even if you do the
> > ptrace check at each syscall (which is of course a good thing), you must be
> > sure that you are doing the check on the right target and the processed
> > file belongs really to the appropriate process image of the target.
> 
> The right target is by definition the current value of the process in
> question.
> 
> /proc/<pid>/<attr> files are supposed to work after an exec.
Yes.

> Adding an exec_id to additional files simply breaks existing
> applications for no good reason.
Can you please point these applications that this patch will break ?
So we do not do it.

I've tested 'ps' but perhaps I've missed something ?

We just return 0 at read() which is a correct thing to do.


> What is needed is for safety is to guard against the race of exec
> happening during a read or a write, so that we don't get access
before and during. I say before since this is what we are tying to
emulate.

> to something we shouldn't have permissions to.
> 
> In general that means reference counting or locks.  All exec_id can
Locks ? counting yes this perhaps can work as Alan suggested, but a simple
check will catch all the things without any node list nor count inc/dec.

Linus's /proc/pid/mem patch do not even do that, he just keep the old mm
at open time.

> meaningfully be used for in the general case is a trigger to try again.
> 
> > This is not news. Alan's historical links:
> > http://lkml.org/lkml/2012/1/29/35
> 
> Alan's case refers to how to handle /proc/<pid>/maps the right way.
Alan's case refers to how to handle all the /proc/<pid>/* files and any
other object that should be attached to its process image.

> > The previous discussion on kernel-hardening:
> > (includes some variants described by Vasiliy and other problems which I'll
> > try to discuss here)
> > http://www.openwall.com/lists/kernel-hardening/2012/02/10/1
> 
> In your post on openwall I just see you arguing that the current
> and deliberate semantics of the permission checks on the proc files are
> wrong.  Because the permission checks happen at access time rather than
> at open time.
Yes if you are speaking about {maps,smaps...} then it should also be at
open time and at each syscall (it depends on files) and for the
/proc/pid/{maps,smaps,numa_maps} yes it is not safe to give non-privileged
processes an fd to an objects attached to a privileged process.

> Well I am sorry.  The permission checks have happened at access time for
> ages and that is deliberate.
Yes (perhaps even before I use Linux :) ), but IMHO they are not perfect,
if they were, then we'll not see all the /proc/<pid>/ problems.

The current patches protect /proc/pid/{maps,smaps,numa_maps} without breaking
things, there are no checks at open which is not safe, but I did not add
it since I was not sure and I don't want to break things (glibc
FORITFY_SOURCE ...).

My patches add the ptrace checks at open only for
/proc/<pid>/{environ,pagemap,mem} which is safe, I did not include
/proc/pid/{auxv,maps,smaps,...} so please if you have _real_ cases of
problems just post them.

> Furthermore one of your confused arguments seems to imply that there is
> a such a thing as a /proc/self file distinct from a /proc/<pid> file.
> There not.  /proc/self is just a symlink into /proc/<pid> and as such
> does not open new security holes.
No it's not confused, we just use the /proc/self as it is easy to explain.
Sorry if you feel that.

> If you expect /proc/ not to let you find out things about yourself
> if you are a suid executable that just seems silly.
Ah yes this one about suid/privileged, if you are still privileged then
there is no harm, but if you drop your privileges IMHO that means that you
do not want to do privileged operations, but that current == task in
ptrace which is before the creds check will just allow you to do so.

Well, this is another subject.

> So in short you seem to be arguing for changing the semantics of access
> of every file under /proc/<pid> because there is cognitive dissonance
> between your understanding of those files and what is implemented.  I
> see no acknowledgement that you are arguing for a semantic change or
> any arguments in favor of that change.  At best I see is an argument
> that says you the files don't work the way you expect which is most
> definitely not sufficient for a change.
I really don't understant what you are trying to say/prove here, this is
the same issue of the last /proc/<pid>/mem one that got fixed by Linus and
Olge patches. These are dynamic files.

For arguments I'll re-try.

> Eric
Thanks Eric.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
tixxdz
http://opendz.org
