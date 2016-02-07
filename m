Reply-To: kernel-hardening@lists.openwall.com
References: <1454801964-50385-1-git-send-email-sbauer@eng.utah.edu>
 <1454801964-50385-3-git-send-email-sbauer@eng.utah.edu>
 <56B6E5C6.4090209@nextfour.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56B6FBE0.9060202@eng.utah.edu>
Date: Sun, 7 Feb 2016 01:10:08 -0700
MIME-Version: 1.0
In-Reply-To: <56B6E5C6.4090209@nextfour.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCHv2 2/2] x86: SROP mitigation: implement signal cookies
To: =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>, linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, x86@kernel.org, ak@linux.intel.com, luto@amacapital.net, mingo@redhat.com, tglx@linutronix.de, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>



On 02/06/2016 11:35 PM, Mika Penttilä wrote:
> Hi,
> 
> 
> On 07.02.2016 01:39, Scott Bauer wrote:
>> This patch adds SROP mitigation logic to the x86 signal delivery
>> and sigreturn code. The cookie is placed in the unused alignment
>> space above the saved FP state, if it exists. If there is no FP
>> state to save then the cookie is placed in the alignment space above
>> the sigframe.
>>
>> Cc: Abhiram Balasubramanian <abhiram@cs.utah.edu>
>> Signed-off-by: Scott Bauer <sbauer@eng.utah.edu>
>> ---
>>  arch/x86/ia32/ia32_signal.c        | 63 +++++++++++++++++++++++++---
>>  arch/x86/include/asm/fpu/signal.h  |  1 +
>>  arch/x86/include/asm/sighandling.h |  5 ++-
>>  arch/x86/kernel/fpu/signal.c       | 10 +++++
>>  arch/x86/kernel/signal.c           | 86 +++++++++++++++++++++++++++++++++-----
>>  5 files changed, 146 insertions(+), 19 deletions(-)
>>
>> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
>> index 0552884..2751f47 100644
>> --- a/arch/x86/ia32/ia32_signal.c
>> +++ b/arch/x86/ia32/ia32_signal.c
>> @@ -68,7 +68,8 @@
>>  }
>>  
>>  static int ia32_restore_sigcontext(struct pt_regs *regs,
>> -				   struct sigcontext_32 __user *sc)
>> +				   struct sigcontext_32 __user *sc,
>> +				   void __user **user_cookie)
>>  {
>>  	unsigned int tmpflags, err = 0;
>>  	void __user *buf;
>> @@ -105,6 +106,16 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
>>  		buf = compat_ptr(tmp);
>>  	} get_user_catch(err);
>>  
>> +	/*
>> +	 * If there is fp state get cookie from the top of the fp state,
>> +	 * else get it from the top of the sig frame.
>> +	 */
>> +
>> +	if (tmp != 0)
>> +		*user_cookie = compat_ptr(tmp + fpu__getsize(1));
>> +	else
>> +		*user_cookie = NULL;
>> +
>>  	err |= fpu__restore_sig(buf, 1);
>>  
>>  	force_iret();
>> @@ -117,6 +128,7 @@ asmlinkage long sys32_sigreturn(void)
>>  	struct pt_regs *regs = current_pt_regs();
>>  	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
>>  	sigset_t set;
>> +	void __user *user_cookie;
>>  
>>  	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
>>  		goto badframe;
>> @@ -129,8 +141,15 @@ asmlinkage long sys32_sigreturn(void)
>>  
>>  	set_current_blocked(&set);
>>  
>> -	if (ia32_restore_sigcontext(regs, &frame->sc))
>> +	if (ia32_restore_sigcontext(regs, &frame->sc, &user_cookie))
>> +		goto badframe;
>> +
>> +	if (user_cookie == NULL)
>> +		user_cookie = compat_ptr((regs->sp - 8) + sizeof(*frame));
>> +
>> +	if (verify_clear_sigcookie(user_cookie))
>>  		goto badframe;
>> +
>>  	return regs->ax;
>>  
>>  badframe:
>> @@ -142,6 +161,7 @@ asmlinkage long sys32_rt_sigreturn(void)
>>  {
>>  	struct pt_regs *regs = current_pt_regs();
>>  	struct rt_sigframe_ia32 __user *frame;
>> +	void __user *user_cookie;
>>  	sigset_t set;
>>  
>>  	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
>> @@ -153,7 +173,13 @@ asmlinkage long sys32_rt_sigreturn(void)
>>  
>>  	set_current_blocked(&set);
>>  
>> -	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext))
>> +	if (ia32_restore_sigcontext(regs, &frame->uc.uc_mcontext, &user_cookie))
>> +		goto badframe;
>> +
>> +	if (user_cookie == NULL)
>> +		user_cookie = (void __user *)((regs->sp - 4) + sizeof(*frame));
> regs->sp is already restored so you should use frame instead.
> 
> --Mika
> 

Nice catch, thank you. I'm surprised I haven't hit this issue yet.
I've been running these patches for 3 weeks on 2 different machines and
haven't had an issue. I'll submit v3 with this fix a bit later, I want
to see if anyone else has stuff to fix.

Thanks again
