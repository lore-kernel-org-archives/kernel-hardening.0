Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 14 Aug 2011 15:55:50 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110814115549.GA3423@albatros>
References: <20110810162101.GA2833@albatros>
 <20110810164225.GA32177@openwall.com>
 <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
 <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
 <20110814101658.GA20509@albatros>
 <20110814112922.GA15012@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814112922.GA15012@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Aug 14, 2011 at 15:29 +0400, Solar Designer wrote:
> > I think a simple way to go is an addition of PR_BITNESS_LOCK prctl() option,
> > which calls __task_bitness_lock(current, current_bitness()).
> 
> I am fine with this.  I don't know which approach the LKML folks will
> like best.

Btw, it can be even simplier.  If we use only one flag - lock to the
current bitness - then the code is greatly simplified.  The same
behaviour as with 3 flags can be achieved with binary helpers:

1) vzctl wants to create CT 101 with specific bitness.  If it is 64, it
simply calls prctl(LOCK_BITNESS) and execve's init.  If it is 32, it
exec's small 32 bit helper binary that does the same job, but as 32
bits.  It is compiled from the same source files, so the helper creation
process is trivial.

2) vzctl wants to create CT 101 with the bitness its /sbin/init is.
Then it just looks at /sbin/init and does (1) steps.  There is a race
compared to 3-flags prctl(), but it is not important here.  If init
binary is changed during the startup, something already goes wrong.

3) vsftpd/sshd wants to lock bitness of current task.  It just uses
prctl(LOCK_BITNESS).


We loose a unlock behaviour if execve fails, but it is IMO a very minor
issue.

> > Also, I try to handle syscalls as if they are not setup, but there are
> > trivial ways to do something more than just 32 bit task of 32 bit kernel
> > or 64 bit task of 64 bit kernel with IA32_EMULATION=n.  The obvious way
> > is using CS segment of another bitness.  I bet procfs has something
> > similar.  64 bit locking is rather simple as grep CONFIG_IA32_EMULATION
> > shows only tens of lines (so, it can be fixed), but emulated 32 bit task
> > might significantly differ from usual 32 task on 32 bit kernel.
> 
> OK, you don't have to emulate the exact same behavior.  Maybe ENOSYS
> like you implemented initially would be fine.

Hmm, so you say such emulation is not needed?  Then I can remove 3 C
functions emulating interrupts handlers, 4 asm code chunks to call C
functions, and just patch ptrace_syscall_enter() with 2 line patch to
return -ENOSYS.  It will reduce the patch size by >50% ;)

The only thing is that some programs may do syscalls of other bitness
and get -ENOSYS when the syscall cannot fail and always present (e.g.
getpid()).  But IMO programs willing to do such syscalls are broken.


ENOSYS/kill() differ in kernel policy of handling tasks doing something
wrong.  If we assume syscalls of other bitness are denied and programs
doing it are broken, SIGKILL/SIGSEGV is just OK.  If we assume a task
may "probe" and fallback to something else (which is I'm VERY sceptic),
emulation of absent syscall can be applied (either full emulation or
sending a process'able signal).  If we are cruel and may not tolerate
exploitation attempts, we may kill a process and lock the user as
grsecurity does for similar things.   I think a simple SIGKILL is enough
- it's simple, unambiguous, and is consistent with existing seccomp
behaviour.

-- 
Vasiliy
