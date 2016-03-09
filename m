Reply-To: kernel-hardening@lists.openwall.com
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <20160309083204.GA30365@gmail.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56E09E8B.1010909@eng.utah.edu>
Date: Wed, 9 Mar 2016 15:07:07 -0700
MIME-Version: 1.0
In-Reply-To: <20160309083204.GA30365@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code for
 signal cookies
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/09/2016 01:32 AM, Ingo Molnar wrote:
> 
> * Scott Bauer <sbauer@eng.utah.edu> wrote:
> 
>> This patch adds a per-process secret to the task struct which
>> will be used during signal delivery and during a sigreturn.
>> Also, logic is added in signal.c to generate, place, extract,
>> clear and verify the signal cookie.
> 
>>  	/*
>> +	 * Canary value for signal frames placed on user stack.
>> +	 * This helps mitigate "Signal Return oriented program"
>> +	 * exploits in userland.
>> +	 */
>> +	unsigned long sig_cookie;
> 
> Could you please add a high level description in Documentation
> that explains the attack and the way how this mitigation code
> prevents that kind of attack?
> 
> Also, the first changelogs should contain more high level
> description as well. For example, what does the 'verification'
> of the signal cookie mean, and how does it prevent an SROP
> attempt?
> 
> All of these patches seem to assume that people reading this code
> know what SROP is and how we defend against it - that is not so.
> 
> Thanks,
> 
> 	Ingo
> 


I'm going to submit v4 to fix some nits where I'll include the explanation
and a change log, I apologize for not doing that here. In the meantime if
you don't mind visiting a link I included a brief explanation on previous
versions of the patch set.


https://lkml.org/lkml/2016/2/6/166

Thanks
