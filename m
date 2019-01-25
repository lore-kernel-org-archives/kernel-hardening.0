Subject: Re: [PATCH v2 2/3] powerpc/lib: Refactor __patch_instruction() to use
 __put_user_asm()
References: <20181210070044.27503-1-ruscur@russell.cc>
 <20181210070044.27503-3-ruscur@russell.cc>
 <3b213170-9b93-cb71-b0c2-220ea31dbdea@c-s.fr>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <5ff8b24e-a748-19d3-8651-b626dd676ea4@c-s.fr>
Date: Fri, 25 Jan 2019 12:45:50 +0100
MIME-Version: 1.0
In-Reply-To: <3b213170-9b93-cb71-b0c2-220ea31dbdea@c-s.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: mikey@neuling.org, mpe@ellerman.id.au, benh@kernel.crashing.org, npiggin@gmail.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Russel,

Le 17/12/2018 à 08:09, Christophe Leroy a écrit :
> Hi Russel,
> 
> Le 10/12/2018 à 08:00, Russell Currey a écrit :
>> __patch_instruction() is called in early boot, and uses
>> __put_user_size(), which includes the locks and unlocks for KUAP,
>> which could either be called too early, or in the Radix case, forced to
>> use "early_" versions of functions just to safely handle this one case.
> 
> Looking at x86, I see that __put_user_size() doesn't includes the locks. 
> The lock/unlock is do by callers. I'll do the same.
> 
> 
>>
>> __put_user_asm() does not do this, and thus is safe to use both in early
>> boot, and later on since in this case it should only ever be touching
>> kernel memory.
>>
>> __patch_instruction() was previously refactored to use __put_user_size()
>> in order to be able to return -EFAULT, which would allow the kernel to
>> patch instructions in userspace, which should never happen.  This has
>> the functional change of causing faults on userspace addresses if KUAP
>> is turned on, which should never happen in practice.
>>
>> A future enhancement could be to double check the patch address is
>> definitely allowed to be tampered with by the kernel.
> 
> This makes me realise that we are calling lock_user_access() with kernel 
> addresses. That most likely breaks protection on kernel addresses for 
> book3s/32. I'll have to work around it.
> 
> Another thing I realised also is that get_user() at least is called in 
> some exceptions/trap handlers. Which means it can be called nested with 
> an ongoing user access. It means that get_paca()->user_access_allowed 
> might be modified during those exceptions/traps.

Any comment about that ? Isn't it a problem ?

Christophe

> 
> Christophe
> 
>>
>> Signed-off-by: Russell Currey <ruscur@russell.cc>
>> ---
>>   arch/powerpc/lib/code-patching.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/powerpc/lib/code-patching.c 
>> b/arch/powerpc/lib/code-patching.c
>> index 89502cbccb1b..15e8c6339960 100644
>> --- a/arch/powerpc/lib/code-patching.c
>> +++ b/arch/powerpc/lib/code-patching.c
>> @@ -26,9 +26,9 @@
>>   static int __patch_instruction(unsigned int *exec_addr, unsigned int 
>> instr,
>>                      unsigned int *patch_addr)
>>   {
>> -    int err;
>> +    int err = 0;
>> -    __put_user_size(instr, patch_addr, 4, err);
>> +    __put_user_asm(instr, patch_addr, err, "stw");
>>       if (err)
>>           return err;
>>
