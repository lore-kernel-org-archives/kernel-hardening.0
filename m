Reply-To: kernel-hardening@lists.openwall.com
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <1457470075-4586-2-git-send-email-sbauer@eng.utah.edu>
 <20160308210333.7ad77a29@lxorguk.ukuu.org.uk>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56DF4644.1060200@eng.utah.edu>
Date: Tue, 8 Mar 2016 14:38:12 -0700
MIME-Version: 1.0
In-Reply-To: <20160308210333.7ad77a29@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/3] x86: SROP mitigation: implement signal cookies
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, x86@kernel.org, wmealing@redhat.com, ak@linux.intel.com, luto@amacapital.net, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/2016 02:03 PM, One Thousand Gnomes wrote:
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
> 
> user_cookie is is __user, so shouldn't just be poking at it without
> get/put_user ? It might fault if someone has engineered a bad stack frame.
> 
> Alan
> 

I guess I got a little carried away with the __user annotations. I will remove the __user annotation from this function
since what we're dereferencing isn't actually a __user pointer, its some stack memory sitting in the caller's stack frame. 

see patch 2/3:


	void __user *user_cookie;
                                                      vv-- Passed in here
	if (ia32_restore_sigcontext(regs, &frame->sc, &user_cookie))
		goto badframe;
