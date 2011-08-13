Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 13 Aug 2011 19:12:20 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110813151220.GA8388@albatros>
References: <20110810095200.GA2377@albatros>
 <20110810130333.GA31122@openwall.com>
 <20110810132715.GA8993@albatros>
 <20110810142609.GA31434@openwall.com>
 <20110810150257.GA12198@albatros>
 <20110810154059.GA31860@openwall.com>
 <20110810162101.GA2833@albatros>
 <20110810164225.GA32177@openwall.com>
 <20110812120747.GA14598@albatros>
 <20110812122343.GA7859@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812122343.GA7859@openwall.com>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

Re: slowdown - my assumptions are:

1) we don't want any slowdown for legitimate tasks - 64 bit tasks for 64
bit containers and 32 bit tasks for 32 bit containers.

2) slowdown of malicious (or broken) tasks is not important.


Looking into asm code:

ENTRY(ia32_sysenter_target)
    ...
	GET_THREAD_INFO(%r10)
    ...
	testl  $_TIF_WORK_SYSCALL_ENTRY,TI_flags(%r10)
	CFI_REMEMBER_STATE
	jnz  sysenter_tracesys
    ...

sysenter_tracesys:
#ifdef CONFIG_AUDITSYSCALL
	testl	$(_TIF_WORK_SYSCALL_ENTRY & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
	jz	sysenter_auditsys
#endif
    ...
	call	syscall_trace_enter
    ...

/* work to do in syscall_trace_enter() */
#define _TIF_WORK_SYSCALL_ENTRY	\
	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_EMU | _TIF_SYSCALL_AUDIT |	\
	 _TIF_SECCOMP | _TIF_SINGLESTEP | _TIF_SYSCALL_TRACEPOINT)


So, there is a mask, which is used to identify whether a syscall needs
additional pre/post processing.  If divide syscall_trace_enter() into 3
functions, we'll get what we want.  This will result in zero impact on
the legitimate code (relavite to current behaviour).

One drawback - *tracesys clobbers EAX/RAX, so I still have to patch asm.

Thanks,

-- 
Vasiliy
