Subject: Re: [PATCH 03/12] __wr_after_init: generic functionality
References: <20181221181423.20455-1-igor.stoppa@huawei.com>
 <20181221181423.20455-4-igor.stoppa@huawei.com>
 <20181221184120.GG10600@bombadil.infradead.org>
 <14487401-dec3-6a7d-a0b1-e369e93aa9c4@gmail.com>
 <20181221194351.GH10600@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <0a154bdf-2d62-f752-82fa-70be6ea8cff5@gmail.com>
Date: Fri, 21 Dec 2018 23:54:13 +0200
MIME-Version: 1.0
In-Reply-To: <20181221194351.GH10600@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 21/12/2018 21:43, Matthew Wilcox wrote:
> On Fri, Dec 21, 2018 at 09:07:54PM +0200, Igor Stoppa wrote:
>> On 21/12/2018 20:41, Matthew Wilcox wrote:
>>> On Fri, Dec 21, 2018 at 08:14:14PM +0200, Igor Stoppa wrote:
>>>> +static inline int memtst(void *p, int c, __kernel_size_t len)
>>>
>>> I don't understand why you're verifying that writes actually happen
>>> in production code.  Sure, write lib/test_wrmem.c or something, but
>>> verifying every single rare write seems like a mistake to me.
>>
>> This is actually something I wrote more as a stop-gap.
>> I have the feeling there should be already something similar available.
>> And probably I could not find it. Unless it's so trivial that it doesn't
>> deserve to become a function?
>>
>> But if there is really no existing alternative, I can put it in a separate
>> file.
> 
> I'm not questioning the implementation, I'm questioning why it's ever
> called.  If I type 'p = q', I don't then verify that p actually is equal
> to q.  I just assume that the compiler did its job. 

Paranoia, probably.

My thinking is that, once the data is protected, it could still be 
attacked through the metadata. A pte, for example.
Preventing the setting of a flag, that for example enables a 
functionality, might be a nice way to thwart all this protection.

If I verify that the write was successful, through the read-only 
address, then I know that the action really completed successfully.

There are many more types of attack that one can come up with, but 
attacking the metadata is probably the most likely next level.

So what I'm trying to do is more akin to:

p = &d;
*p = q;
d == q;

But in our case there is an indefinite amount of time between the 
creation of
the alternate mapping and its use.

Another way could be to check that the mapping is correct before writing 
to it. Maybe safer? I went for confirming that the end result is correct.

Of course it adds overhead, but if the whole thing is already slow and 
happening not too often, how much does it matter?

An alternative approach would be that the code invoking the wr operation 
performs an explicit test.

Would it look better if I implemented this as a wr_assign_verify() 
inline function?

>>>> +#ifndef CONFIG_PRMEM
>>>
>>> So is this PRMEM or wr_mem?  It's not obvious that CONFIG_PRMEM controls
>>> wrmem.
>>
>> In my mind (maybe still clinging to the old implementation), PRMEM is the
>> master toggle, for protected memory.
>>
>> Then there are various types and the first one being now implemented is
>> write rare after init (because ro after init already exists).
>>
>> However, the same levels of protection should then follow for dynamically
>> allocated memory (ye old pmalloc).
>>
>> PRMEM would then become the moniker for the whole shebang.
> 
> To my mind, what we have in this patchset is support for statically
> allocated protected (or write-rare) memory.  Later, we'll add dynamically
> allocated protected memory.  So it's all protected memory, and we'll
> use the same accessors for both ... right?

The static one is only write rare because read only after init already 
exists.

The dynamic one must introduce the same write rare, yes, but it should 
also introduce read_only (I do not count the destruction of an entire 
pool as a write rare operation). Ex: SELinux policyDB.

write rare, regardless if dynamic or static, is a sub-case of protected 
memory, hence the differentiation between protected and write rare.

I'm not claiming to be particularly skilled at choosing names, so if 
something better sounding is available, it can be used.
This is the best I could come up with.

[...]

> I don't think there's anything to be done in that case.  Indeed,
> I think the only thing to do is panic and stop the whole machine if
> initialisation fails.  We'd be in a situation where nothing can update
> protected memory, and the machine just won't work.
> 
> I suppose we could "fail insecure" and never protect the memory, but I
> think that's asking for trouble.

ok, so init will BUG() if it fails, instead of the current WARN_ONCE() 
and return.

> Anyway, my concern was for a driver which can be built either as a
> module or built-in.  Its init code will be called before write-protection
> happens when it's built in, and after write-protection happens when it's
> a module.  It should be able to use wr_assign() in either circumstance.
> One might also have a utility function which is called from both init
> and non-init code and want to use wr_assign() whether initialisation
> has completed or not.

If the writable mapping is created early enough, the only penalty for 
using the write-rare function on a writable variable is that it would be 
slower. Probably there wouldn't be so much data to deal with.

If the driver is dealing with some HW, most likely that would make any 
write rare extra delay look negligible.

--
igor
