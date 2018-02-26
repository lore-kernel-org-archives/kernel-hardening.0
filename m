Subject: Re: [PATCH 7/7] Documentation for Pmalloc
References: <20180223144807.1180-1-igor.stoppa@huawei.com>
 <20180223144807.1180-8-igor.stoppa@huawei.com>
 <98b2fecf-c1b3-aa5e-ba70-2770940bb965@gmail.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <181b20bb-b0ae-c337-d4bd-03b6ddfed749@huawei.com>
Date: Mon, 26 Feb 2018 17:39:07 +0200
MIME-Version: 1.0
In-Reply-To: <98b2fecf-c1b3-aa5e-ba70-2770940bb965@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: J Freyensee <why2jjj.linux@gmail.com>, david@fromorbit.com, willy@infradead.org, keescook@chromium.org, mhocko@kernel.org
Cc: labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 24/02/18 02:26, J Freyensee wrote:
> 
> 
> On 2/23/18 6:48 AM, Igor Stoppa wrote:

[...]

>> +- Before destroying a pool, all the memory allocated from it must be
>> +  released.
> 
> Is that true?  pmalloc_destroy_pool() has:
> 
> .
> .
> +    pmalloc_pool_set_protection(pool, false);
> +    gen_pool_for_each_chunk(pool, pmalloc_chunk_free, NULL);
> +    gen_pool_destroy(pool);
> +    kfree(data);
> 
> which to me looks like is the opposite, the data (ie, "memory") is being 
> released first, then the pool is destroyed.

well, this is embarrassing ... yes I had this prototype code, because I
was wondering if it wouldn't make more sense to tear down the pool as
fast as possible. It slipped in, apparently.

I'm actually tempted to leave it in and fix the comment.

[...]

>> +
>> +- pmalloc does not provide locking support with respect to allocating vs
>> +  protecting an individual pool, for performance reasons.
> 
> What is the recommendation to using locks then, as the computing 
> real-world mainly operates in multi-threaded/process world? 

How common are multi-threaded allocations of write-once memory?
Here we are talking exclusively about the part of the memory life-cycle
where it is allocated (from pmalloc).

> Maybe show 
> an example of an issue that occur if locks aren't used and give a coding 
> example.

An example of how to use a mutex to access a shared resource? :-O

This part below, under your question, was supposed to be the answer :-(

>> +  It is recommended not to share the same pool between unrelated functions.
>> +  Should sharing be a necessity, the user of the shared pool is expected
>> +  to implement locking for that pool.

[...]

>> +- pmalloc uses genalloc to optimize the use of the space it allocates
>> +  through vmalloc. Some more TLB entries will be used, however less than
>> +  in the case of using vmalloc directly. The exact number depends on the
>> +  size of each allocation request and possible slack.
>> +
>> +- Considering that not much data is supposed to be dynamically allocated
>> +  and then marked as read-only, it shouldn't be an issue that the address
>> +  range for pmalloc is limited, on 32-bit systems.
> 
> Why is 32-bit systems mentioned and not 64-bit?

Because, as written, on 32 bit system the vmalloc range is relatively
small, so one might wonder if there are enough addresses.

>  Is there a problem with 64-bit here?

Quite the opposite.
I thought it was clear, but obviously it isn't, I'll reword this.

-igor
