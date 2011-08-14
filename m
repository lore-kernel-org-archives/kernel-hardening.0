Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 14 Aug 2011 14:16:58 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110814101658.GA20509@albatros>
References: <20110810150257.GA12198@albatros>
 <20110810154059.GA31860@openwall.com>
 <20110810162101.GA2833@albatros>
 <20110810164225.GA32177@openwall.com>
 <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
 <20110813151220.GA8388@albatros>
 <20110813151947.GA12495@openwall.com>
 <20110813165502.GA9328@albatros>
 <20110814095010.GA14443@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110814095010.GA14443@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sun, Aug 14, 2011 at 13:50 +0400, Solar Designer wrote:
> On Sat, Aug 13, 2011 at 08:55:02PM +0400, Vasiliy Kulikov wrote:
> > Some thoughts about prctl() approach.
> 
> Here's a further thought:
> 
> The feature makes sense not only for pid namespaces, but also for some
> daemons, and especially for their privsep child processes - regardless
> of whether they make use of namespaces (vsftpd) or not (openssh).

My current non-posted-yet patch handles the current process rather than
a namespace.  It sets a task-related flag(s), which is checked/dropped on
execve().  On execve() an actual locking is handled.  A locked process
may not drop the lock.


long arch_prctl(int option, unsigned long arg2, unsigned long arg3,
		unsigned long arg4, unsigned long arg5)
{
	switch (option) {
		case PR_BITNESS_LOCK_ON_EXEC:
			if (!capable(CAP_SYS_ADMIN))
				return -EACCES;
			return bitness_set_lock_on_exec(arg3, !!arg2);
            ...

int bitness_set_lock_on_exec(int bits, int val)
{
	switch (bits) {
	case 32:
		current->bitness.lock_32 = val;
		break;
	case 64:
		current->bitness.lock_64 = val;
		break;
	default:
		return -EINVAL;
	}

	return 0;
}

void arch_post_exec_elf(int retval, int elf_class)
{
	if (retval == 0 && current.bitness.lock) {
		int bits = (elf_class == ELFCLASS32) ? 32 : 64;
		__task_bitness_lock(current, bits);
	}
}

The only thing the patch lacks is an ability to lock the task immediately.


> So maybe the restriction should apply to a process tree rather than to a
> namespace?

A process tree is a horrible term.  What if some elements of fork chain
died?


> 5 - lock current process to current bitness, but execve() to 32-bit ELF
> 6 - lock current process to current bitness, but execve() to 64-bit ELF
> 7 - lock current process to current bitness, but next execve() to its actual bitness
> 
> 5 to 7 are probably not very useful, but are defined for consistency.

These are confusing and IMO meaningless modes.

I think a simple way to go is an addition of PR_BITNESS_LOCK prctl() option,
which calls __task_bitness_lock(current, current_bitness()).


Also, I try to handle syscalls as if they are not setup, but there are
trivial ways to do something more than just 32 bit task of 32 bit kernel
or 64 bit task of 64 bit kernel with IA32_EMULATION=n.  The obvious way
is using CS segment of another bitness.  I bet procfs has something
similar.  64 bit locking is rather simple as grep CONFIG_IA32_EMULATION
shows only tens of lines (so, it can be fixed), but emulated 32 bit task
might significantly differ from usual 32 task on 32 bit kernel.


Thanks,

-- 
Vasiliy
