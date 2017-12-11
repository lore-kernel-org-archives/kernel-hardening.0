References: <1512516827-29797-1-git-send-email-alex.popov@linux.com>
 <1512516827-29797-4-git-send-email-alex.popov@linux.com>
 <20171206211251.GA23618@altlinux.org>
From: Alexander Popov <alex.popov@linux.com>
Message-ID: <3f793701-87c2-4125-19c5-4abcc485ff4e@linux.com>
Date: Tue, 12 Dec 2017 01:38:16 +0300
MIME-Version: 1.0
In-Reply-To: <20171206211251.GA23618@altlinux.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH RFC v6 3/6] x86/entry: Erase kernel
 stack in syscall_trace_enter()
To: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 07.12.2017 00:12, Dmitry V. Levin wrote:
> On Wed, Dec 06, 2017 at 02:33:44AM +0300, Alexander Popov wrote:
>> Make STACKLEAK erase kernel stack after ptrace/seccomp/auditing
>> not to leave any sensitive information on the stack for the syscall code.
>>
>> This code is modified from Brad Spengler/PaX Team's code in the last
>> public patch of grsecurity/PaX based on our understanding of the code.
>> Changes or omissions from the original code are ours and don't reflect
>> the original grsecurity/PaX code.
>>
>> Signed-off-by: Alexander Popov <alex.popov@linux.com>
>> ---
>>  arch/x86/entry/common.c | 19 ++++++++++++++++---
>>  1 file changed, 16 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
>> index d7d3cc2..d45b7cf 100644
>> --- a/arch/x86/entry/common.c
>> +++ b/arch/x86/entry/common.c
>> @@ -45,6 +45,12 @@ __visible inline void enter_from_user_mode(void)
>>  static inline void enter_from_user_mode(void) {}
>>  #endif
>>  
>> +#ifdef CONFIG_GCC_PLUGIN_STACKLEAK
>> +asmlinkage void erase_kstack(void);
>> +#else
>> +static void erase_kstack(void) {}
>> +#endif
>> +
>>  static void do_audit_syscall_entry(struct pt_regs *regs, u32 arch)
>>  {
>>  #ifdef CONFIG_X86_64
>> @@ -81,11 +87,15 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>  		emulated = true;
>>  
>>  	if ((emulated || (work & _TIF_SYSCALL_TRACE)) &&
>> -	    tracehook_report_syscall_entry(regs))
>> +	    tracehook_report_syscall_entry(regs)) {
>> +		erase_kstack();
>>  		return -1L;
>> +	}
>>  
>> -	if (emulated)
>> +	if (emulated) {
>> +		erase_kstack();
>>  		return -1L;
>> +	}
>>  
>>  #ifdef CONFIG_SECCOMP
>>  	/*
>> @@ -117,8 +127,10 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>  		}
>>  
>>  		ret = __secure_computing(&sd);
>> -		if (ret == -1)
>> +		if (ret == -1) {
>> +			erase_kstack();
>>  			return ret;
>> +		}
>>  	}
>>  #endif
>>  
>> @@ -127,6 +139,7 @@ static long syscall_trace_enter(struct pt_regs *regs)
>>  
>>  	do_audit_syscall_entry(regs, arch);
>>  
>> +	erase_kstack();
>>  	return ret ?: regs->orig_ax;
>>  }

Hello Dmitry,

Thanks for the review.

> wrt adding erase_kstack() calls to syscall_trace_enter(), I think the only
> case where this would be appropriate is that still has a chance of
> executing syscall code.  In all cases where syscall_trace_enter() returns
> -1 no syscall code is going to be executed and the stack will be erased on
> exiting syscall anyway.
> 
> In other words, only the last hunk of this patch seems to be useful,
> all others look redundant.

I agree with your point. I'll fix it in v7.

> P.S.  I've trimmed the Cc list to those who took part in earlier rounds
> of this discussion.

Excuse me, I've returned everybody back to CC list again :)

Best regards,
Alexander
