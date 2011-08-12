Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4E45884B.8030303@zytor.com>
Date: Fri, 12 Aug 2011 15:08:43 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <20110812150304.GC16880@albatros>
In-Reply-To: <20110812150304.GC16880@albatros>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC] x86: restrict pid namespaces to 32 or 64 bit syscalls
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 08/12/2011 10:03 AM, Vasiliy Kulikov wrote:
> This patch allows x86-64 systems with 32 bit syscalls support to lock a
> pid namespace to 32 or 64 bitness syscalls/tasks.  By denying rarely
> used compatibility syscalls it reduces an attack surface for 32 bit
> containers.
> 
> The new sysctl is introduced, abi.bitness_locked.  If set to 1, it locks
> all tasks inside of current pid namespace to the bitness of init task
> (pid_ns->child_reaper).  After that:
> 
> 1) a task trying to do a syscall of other bitness would get a signal as
> if the corresponding syscall is not enabled (IDT entry/MSR is not
> initialized).
> 
> 2) loading ELF binaries of another bitness is prohibited (as if the
> corresponding CONFIG_BINFMT_*=N).
> 
> If there is any task which differs in bitness, the lockup fails.
> 
> In this patch version the lockup is handled by sysctl.  In the future I
> plan to do it via prctl() to handle situations of container root
> compromize.  For now, the lockup can be configured by init scripts,
> which parse /etc/sysctl.conf and set the sysctl variable.  But if
> /sbin/init is compromized, the malicious code would gain a possibility
> to do arbitrary syscalls.  So, it should be possible to lockup the
> container before the init execution.
> 
> ( The asm stubs for denied syscalls might be buggy, if so - please
> ignore them :) it is just a PoC. )
> 

NAK on this in its current form, as it breaks the upcoming x32 ABI.
Selection by ABI needs to be more specific.

However, I have to question the value of this... if this is enabled in
the system as a whole (as opposed to compiled out) it seems kind of
pointless... if there are bugs we need to deal with them anyway.

> Qestions/thoughts:
> 
> The patch adds a check in syscalls code.  Is it a significant
> slowdown for fast syscalls?  If so, probably it worth moving the check
> into scheduler code and enabling/disabling corresponding interrupt/MSRs
> on each task switch?
> 

*YOU* are the person who needs to answer that question by providing
measurements.  Quite frankly I suspect checks in the syscall code *or*
task switching MSRs are going to be unacceptable from a performance
point of view.

	-hpa
