References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <20171027133301.GA612@tigerII.localdomain> <20171031233533.GD3585@eros>
 <20171102082344.GC655@jagdpanzerIV> <20171102101449.GG7499@eros>
 <20171102160409.GE7195@tigerII.localdomain>
From: =?UTF-8?Q?Petr_Nejedl=c3=bd?= <pnejedly@blackberry.com>
Message-ID: <8c9fdb9f-4b1d-a21d-8ed8-f5cf7656aafb@blackberry.com>
Date: Thu, 2 Nov 2017 11:11:10 -0700
MIME-Version: 1.0
In-Reply-To: <20171102160409.GE7195@tigerII.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses
 printed with %p
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/02/2017 09:04 AM, Sergey Senozhatsky wrote:
>>> hm... just a huge pile of if's
>>>
>>> 	if (is_vmalloc_addr(addr))
>>> 		do_hashing(addr);
>>> 	else if (__module_address(addr))
>>> 		do_hashing(addr);
>>> 	else if (is_kernel(addr) || is_kernel_inittext(addr))
>>> 	...
>>>
>>> but that's going to be really messy and "iffy".
>> This is the only suggestion we have so far.
>>
> well... one more: check if we can safely dereference it. if so
> it's a pointer, probably :)
>
> 	if (!probe_kernel_address(addr, p))
> 		do_hashing(addr);
None of that would fly - you'd open a side channel.
Just find a place where kernel prints userland provided value with %x
(quite easy I suppose) and check if it got hashed. A trivial and 
super-reliable
way to probe the kernel address space....

-- 
Petr
