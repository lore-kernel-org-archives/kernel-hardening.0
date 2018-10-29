Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
Date: Mon, 29 Oct 2018 23:04:01 +0200
MIME-Version: 1.0
In-Reply-To: <20181028183126.GB744@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


On 28/10/2018 18:31, Peter Zijlstra wrote:
> On Fri, Oct 26, 2018 at 11:46:28AM +0100, Kees Cook wrote:
>> On Fri, Oct 26, 2018 at 10:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>> I still don't really understand the whole write-rare thing; how does it
>>> really help? If we can write in kernel memory, we can write to
>>> page-tables too.
> 
>> One aspect of hardening the kernel against attack is reducing the
>> internal attack surface. Not all flaws are created equal, so there is
>> variation in what limitations an attacker may have when exploiting
>> flaws (not many flaws end up being a fully controlled "write anything,
>> anywhere, at any time"). By making the more sensitive data structures
>> of the kernel read-only, we reduce the risk of an attacker finding a
>> path to manipulating the kernel's behavior in a significant way.
>>
>> Examples of typical sensitive targets are function pointers, security
>> policy, and page tables. Having these "read only at rest" makes them
>> much harder to control by an attacker using memory integrity flaws.
> 
> Because 'write-anywhere' exploits are easier than (and the typical first
> step to) arbitrary code execution thingies?
> 
>> The "write rarely" name itself may not sufficiently describe what is
>> wanted either (I'll take the blame for the inaccurate name), so I'm
>> open to new ideas there. The implementation requirements for the
>> "sensitive data read-only at rest" feature are rather tricky:
>>
>> - allow writes only from specific places in the kernel
>> - keep those locations inline to avoid making them trivial ROP targets
>> - keep the writeability window open only to a single uninterruptable CPU
> 
> The current patch set does not achieve that because it uses a global
> address space for the alias mapping (vmap) which is equally accessible
> from all CPUs.

I never claimed to achieve 100% resilience to attacks.
While it's true that the address space is accessible to all the CPUs, it 
is also true that the access has a limited duration in time, and the 
location where the access can be performed is not fixed.

Iow, assuming that the CPUs not involved in the write-rare operations 
are compromised and that they are trying to perform a concurrent access 
to the data in the writable page, they have a limited window of opportunity.

Said this, this I have posted is just a tentative implementation.
My primary intent was to at least give an idea of what I'd like to do: 
alter some data in a way that is not easily exploitable.

>> - fast enough to deal with page table updates
> 
> The proposed implementation needs page-tables for the alias; I don't see
> how you could ever do R/O page-tables when you need page-tables to
> modify your page-tables.

It's not all-or-nothing.
I hope we agree at least on the reasoning that having only a limited 
amount of address space directly attackable, instead of the whole set of 
pages containing exploitable data, is  reducing the attack surface.

Furthermore, if we think about possible limitations that the attack 
might have (maximum reach), the level of protection might be even 
higher. I have to use "might" because I cannot foresee the vulnerability.

Furthermore, taking a different angle: your average attacker is not 
necessarily very social and inclined to share the vulnerability found.
It is safe to assume that in most cases each attacker has to identify 
the attack strategy autonomously.
Reducing the amount of individual who can perform an attack, by 
increasing the expertise required is also a way of doing damage control.

> And this is entirely irrespective of performance.

I have not completely given up on performance, but, being write-rare, I 
see improved performance as just a way of widening the range of possible 
recipients for the hardening.

>> The proposal I made a while back only covered .data things (and used
>> x86-specific features).
> 
> Oh, right, that CR0.WP stuff.
> 
>> Igor's proposal builds on this by including a
>> way to do this with dynamic allocation too, which greatly expands the
>> scope of structures that can be protected. Given that the x86-only
>> method of write-window creation was firmly rejected, this is a new
>> proposal for how to do it (vmap window). Using switch_mm() has also
>> been suggested, etc.
> 
> Right... /me goes find the patches we did for text_poke. Hmm, those
> never seem to have made it:
> 
>    https://lkml.kernel.org/r/20180902173224.30606-1-namit@vmware.com
> 
> like that. That approach will in fact work and not be a completely
> broken mess like this thing.

That approach is x86 specific.
I preferred to start with something that would work on a broader set of 
architectures, even if with less resilience.

It can be done so that individual architectures can implement their own 
specific way and obtain better results.

>> We need to find a good way to do the write-windowing that works well
>> for static and dynamic structures _and_ for the page tables... this
>> continues to be tricky.
>>
>> Making it resilient against ROP-style targets makes it difficult to
>> deal with certain data structures (like list manipulation). In my
>> earlier RFC, I tried to provide enough examples of where this could
>> get used to let people see some of the complexity[1]. Igor's series
>> expands this to even more examples using dynamic allocation.
> 
> Doing 2 CR3 writes for 'every' WR write doesn't seem like it would be
> fast enough for much of anything.

Part of the reason for the duplication is that, even if the wr_API I 
came up with, can be collapsed with the regular API, the implementation 
needs to be different, to be faster.

Ex:
* force the list_head structure to be aligned so that it will always be 
fully contained by a single page
* create alternate mapping for all the pages involved (max 1 page for 
each list_head)
* do the lsit operation on the remapped list_heads
* destroy all the mappings

I can try to introduce some wrapper similar to kmap_atomic(), as 
suggested by Dave Hansen, which can improve the coding, but it will not 
change the actual set of operations performed.


> And I don't suppose we can take the WP fault and then fix up from there,
> because if we're doing R/O page-tables, that'll incrase the fault depth
> and we'll double fault all the time, and tripple fault where we
> currently double fault. And we all know how _awesome_ tripple faults
> are.
> 
> But duplicating (and wrapping in gunk) whole APIs is just not going to
> work.

Would something like kmap_atomic() be acceptable?
Do you have some better proposal, now that (I hope) it should be more 
clear what I'm trying to do and why?

--
igor
