Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 22 May 2012 18:39:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Message-ID: <20120522173942.GJ11775@ZenIV.linux.org.uk>
References: <CACLa4puRJLUd6hAHO6zFYiqa5dFVum8eLmNMk_ef+=r8OGhjRg@mail.gmail.com>
 <CAB=4xho2b5fZV_jC15XW3mhOD9Z0QUMnV_UHy-P5EmQWfX59dA@mail.gmail.com>
 <5d6179f59222155b72d9aa9f171e883c.squirrel@webmail.greenhost.nl>
 <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hbzatHerMA1Nq57Qn8SKSZzZf=5t6aLumG9ZpAafgX=UQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Subject: [kernel-hardening] Re: seccomp and ptrace. what is the correct order?
To: Will Drewry <wad@chromium.org>
Cc: Indan Zupancic <indan@nul.nu>, Roland McGrath <mcgrathr@google.com>, Eric Paris <netdev@parisplace.org>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com, pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 22, 2012 at 11:23:06AM -0500, Will Drewry wrote:

> However(!), if we did move secure_computing() to after ptrace _and_
> added a check after SECCOMP_RET_TRACE's ptrace_event call, we could
> ensure the system call was not changed by the tracer.  This would give
> strong assurances that whatever system call is executed was explicitly
> allowed by seccomp policy is the one that was executed.

BTW, after grepping around a bit, I have to say that some callers of those
hooks make very little sense

Exhibit A: sh32 has in do_syscall_trace_enter(regs)
        secure_computing(regs->regs[0]);
Syscall number in r0, right?
	[usual PTRACE_SYSCALL bits]
        if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
                trace_sys_enter(regs, regs->regs[0]);
Ditto
        audit_syscall_entry(audit_arch(), regs->regs[3],
                            regs->regs[4], regs->regs[5],
                            regs->regs[6], regs->regs[7]);
Oops - that one says syscall number in r3, first 4 arguments in r4..r7
        return ret ?: regs->regs[0];

and the caller of that sucker is
syscall_trace_entry:
        !                       Yes it is traced.
        mov     r15, r4
        mov.l   7f, r11         ! Call do_syscall_trace_enter which notifies
        jsr     @r11            ! superior (will chomp R[0-7])
         nop
        mov.l   r0, @(OFF_R0,r15)       ! Save return value
        !                       Reload R0-R4 from kernel stack, where the
        !                       parent may have modified them using
        !                       ptrace(POKEUSR).  (Note that R0-R2 are
        !                       used by the system call handler directly
        !                       from the kernel stack anyway, so don't need
        !                       to be reloaded here.)  This allows the parent
        !                       to rewrite system calls and args on the fly.
        mov.l   @(OFF_R4,r15), r4   ! arg0
        mov.l   @(OFF_R5,r15), r5  
        mov.l   @(OFF_R6,r15), r6
        mov.l   @(OFF_R7,r15), r7   ! arg3
        mov.l   @(OFF_R3,r15), r3   ! syscall_nr
        !
        mov.l   2f, r10                 ! Number of syscalls
        cmp/hs  r10, r3
        bf      syscall_call
[...]
7:      .long   do_syscall_trace_enter

... and syscall_call very clearly picks an index in syscall table from r3.
Incidentally, r0 is the fifth syscall argument...  So what we have is
	* b0rken hookups for seccomp and tracepoint
	* b0rken cancelling of syscalls by ptrace (replacing syscall number
with -1 would've worked; doing that to the 5th argument - not really)

Exhibit B: sh64; makes even less sense, but there the assembler glue had
been too dense for me to get through.  At the very least, seccomp and
tracepoint are assuming that syscall number is in r9, while audit is
assuming that it's in r1.  I'm not too inclined to trust audit in this
case, though.  The _really_ interesting part is that by the look of
their pt_regs syscall number is stored separately - not in regs->regs[]
at all.  And the caller
	* shoves the return value of do_syscall_trace_enter() into regs->regs[2]
	* picks syscall number from regs->syscall_nr and uses that as index
in sys_call_table
	* seems to imply that arguments are in regs->regs[2..7]
	* code around the (presumable) path leading there seems to imply
that syscall number comes from the trap number and isn't in regs->regs[]
at all.  But I might be misreading that assembler.  Easily.

Exhibit C:
mips is consistent these days, but it has no tracepoint hookup *and* it does
open-code tracehook_report_syscall_entry(), except for its return value...
Used to pass the wrong register to seccomp, IIRC.

We really ought to look into merging those suckers.  It's a source of PITA
that keeps coming back; what we need is
	regs_syscall_number(struct pt_regs *)
	regs_syscall_arg1(struct pt_regs *)
	...
	regs_syscall_arg6(struct pt_regs *)
in addition to existing
	regs_return_value(struct pt_regs *)
added on all platforms and made mandatory for new ones.  With that we
could go a long way towards merging these implementations...
