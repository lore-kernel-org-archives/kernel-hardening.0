Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 12 Mar 2012 21:44:16 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120312204416.GG10787@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <m1pqchocok.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pqchocok.fsf@fess.ebiederm.org>
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 12, 2012 at 12:13:15PM -0700, Eric W. Biederman wrote:
> Djalal Harouni <tixxdz@opendz.org> writes:
> 
> > Procfs files and other important objects may contain sensitive information
> > which must not be seen, inherited or processed across execve.
> 
> So I am dense.  /proc/<pid>/mem was special in that it uses a different
> set of checks than other files, and to do those access checks
> /proc/<pid>/mem needed to look at exec_id.
If you are referring to the old protection, yes it was against an ID, but
not uniq IDs, so you can execve a suid do some tricks to have a match on IDs
and bypass the protection, how: by opening your /proc/self/mem and pass
the fd to the exec suid who at read/write time will process its own
/proc/self/mem

> For all of the access checks that are not written in that silly way.
> What is wrong with ptrace_may_access run at every read/write of a file?
As it was noted, these files change during runtime, so even if you do the
ptrace check at each syscall (which is of course a good thing), you must be
sure that you are doing the check on the right target and the processed
file belongs really to the appropriate process image of the target.

This is what Alan says: "bind objects to their process image".


So if ptrace_may_access is done when current == target then it will
succeed, and if we are processing /proc/self/* then every ptrace check
will pass, and if you pass the fd of /proc/self/* to a privileged process
then it will just operate on its own file.

So we need a way/solution to know that we are processing the _right_ files.


The proposed exec_id here will change on each execve(): uniq ids, so if we
execve an external privileged program or have an fd of one of its files,
the exec_id check will fail, but we must also perform the ptrace check.

> We redo all of the permission checks every time so that should avoid
> races.
races are against new execves.

IMHO even with that there will be races, here we are operating on
virtual files /proc/<pid>/* and the creds and privileges of the process
can change at any time even after the ptrace check. Some files use locks
see the /proc/<pid>/io commit 293eb1e7772b25a93647c798c7b89bf26c2da2e0


Hope that I'm not out of context.

> I really think you are trying to solve something that is not broken.
> Certainly I could not see your argument for why anything but
> /proc/<pid>/mem needs attention.
This patch series is to complete the protection for all the /proc/<pid>/*
sensitive files and to update the /proc/<pid>/mem protection.
For this last one, the checks were ok, but I thought that we can do better
without keeping dead bytes.


For all the thing and to keep track:

This is not news. Alan's historical links:
http://lkml.org/lkml/2012/1/29/35

The previous discussion on kernel-hardening:
(includes some variants described by Vasiliy and other problems which I'll
try to discuss here)
http://www.openwall.com/lists/kernel-hardening/2012/02/10/1

These are sensitive files, combined with some binaries properties, attackers
can achieve ASLR bypass ...

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
