Subject: Re: [PATCH 10/17] prmem: documentation
From: Igor Stoppa <igor.stoppa@gmail.com>
References: <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org> <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <20181030213557.GE10491@bombadil.infradead.org>
 <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
 <1d8e2d20-ba18-763e-03ff-d061e98d86ff@gmail.com>
Message-ID: <9f91adeb-0517-3955-6602-49bf6a892593@gmail.com>
Date: Wed, 31 Oct 2018 21:38:21 +0200
MIME-Version: 1.0
In-Reply-To: <1d8e2d20-ba18-763e-03ff-d061e98d86ff@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox <willy@infradead.org>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, selinux@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 31/10/2018 11:08, Igor Stoppa wrote:
> Adding SELinux folks and the SELinux ml
> 
> I think it's better if they participate in this discussion.
> 
> On 31/10/2018 06:41, Andy Lutomirski wrote:
>> On Tue, Oct 30, 2018 at 2:36 PM Matthew Wilcox <willy@infradead.org> 
>> wrote:
>>>
>>> On Tue, Oct 30, 2018 at 10:43:14PM +0200, Igor Stoppa wrote:
>>>> On 30/10/2018 21:20, Matthew Wilcox wrote:
>>>>>>> So the API might look something like this:
>>>>>>>
>>>>>>>          void *p = rare_alloc(...);      /* writable pointer */
>>>>>>>          p->a = x;
>>>>>>>          q = rare_protect(p);            /* read-only pointer */
>>>>
>>>> With pools and memory allocated from vmap_areas, I was able to say
>>>>
>>>> protect(pool)
>>>>
>>>> and that would do a swipe on all the pages currently in use.
>>>> In the SELinux policyDB, for example, one doesn't really want to
>>>> individually protect each allocation.
>>>>
>>>> The loading phase happens usually at boot, when the system can be 
>>>> assumed to
>>>> be sane (one might even preload a bare-bone set of rules from 
>>>> initramfs and
>>>> then replace it later on, with the full blown set).
>>>>
>>>> There is no need to process each of these tens of thousands 
>>>> allocations and
>>>> initialization as write-rare.
>>>>
>>>> Would it be possible to do the same here?
>>>
>>> What Andy is proposing effectively puts all rare allocations into
>>> one pool.  Although I suppose it could be generalised to multiple pools
>>> ... one mm_struct per pool.  Andy, what do you think to doing that?
>>
>> Hmm.  Let's see.
>>
>> To clarify some of this thread, I think that the fact that rare_write
>> uses an mm_struct and alias mappings under the hood should be
>> completely invisible to users of the API. 
> 
> I agree.
> 
>> No one should ever be
>> handed a writable pointer to rare_write memory (except perhaps during
>> bootup or when initializing a large complex data structure that will
>> be rare_write but isn't yet, e.g. the policy db).
> 
> The policy db doesn't need to be write rare.
> Actually, it really shouldn't be write rare.
> 
> Maybe it's just a matter of wording, but effectively the policyDB can be 
> trated with this sequence:
> 
> 1) allocate various data structures in writable form
> 
> 2) initialize them
> 
> 3) go back to 1 as needed
> 
> 4) lock down everything that has been allocated, as Read-Only
> The reason why I stress ReadOnly is that differentiating what is really 
> ReadOnly from what is WriteRare provides an extra edge against attacks, 
> because attempts to alter ReadOnly data through a WriteRare API could be 
> detected
> 
> 5) read any part of the policyDB during regular operations
> 
> 6) in case of update, create a temporary new version, using steps 1..3
> 
> 7) if update successful, use the new one and destroy the old one
> 
> 8) if the update failed, destroy the new one
> 
> The destruction at points 7 and 8 is not so much a write operation, as 
> it is a release of the memory.
> 
> So, we might have a bit different interpretation of what write-rare 
> means wrt destroying the memory and its content.
> 
> To clarify: I've been using write-rare to indicate primarily small 
> operations that one would otherwise achieve with "=", memcpy or memset 
> or more complex variants, like atomic ops, rcu pointer assignment, etc.
> 
> Tearing down an entire set of allocations like the policyDB doesn't fit 
> very well with that model.
> 
> The only part which _needs_ to be write rare, in the policyDB, is the 
> set of pointers which are used to access all the dynamically allocated 
> data set.
> 
> These pointers must be updated when a new policyDB is allocated.
> 
>> For example, there could easily be architectures where having a
>> writable alias is problematic.  On such architectures, an entirely
>> different mechanism might work better.  And, if a tool like KNOX ever
>> becomes a *part* of the Linux kernel (hint hint!)
> 
> Something related, albeit not identical is going on here [1]
> Eventually, it could be expanded to deal also with write rare.
> 
>> If you have multiple pools and one mm_struct per pool, you'll need a
>> way to find the mm_struct from a given allocation. 
> 
> Indeed. In my patchset, based on vmas, I do the following:
> * a private field from the page struct points to the vma using that page
> * inside the vma there is alist_head used only during deletion
>    - one pointer is used to chain vmas fro mthe same pool
>    - one pointer points to the pool struct
> * the pool struct has the property to use for all the associated 
> allocations: is it write-rare, read-only, does it auto protect, etc.
> 
>> Regardless of how
>> the mm_structs are set up, changing rare_write memory to normal memory
>> or vice versa will require a global TLB flush (all ASIDs and global
>> pages) on all CPUs, so having extra mm_structs doesn't seem to buy
>> much.
> 
> 1) it supports differnt levels of protection:
>    temporarily unprotected vs read-only vs write-rare
> 
> 2) the change of write permission should be possible only toward more 
> restrictive rules (writable -> write-rare -> read-only) and only to the 
> point that was specified while creating the pool, to avoid DOS attacks, 
> where a write-rare is flipped into read-only and further updates fail
> (ex: prevent IMA from registering modifications to a file, by not 
> letting it store new information - I'm not 100% sure this would work, 
> but it gives the idea, I think)
> 
> 3) being able to track all the allocations related to a pool would allow 
> to perform mass operations, like reducing the writabilty or destroying 
> all the allocations.
> 
>> (It's just possible that changing rare_write back to normal might be
>> able to avoid the flush if the spurious faults can be handled
>> reliably.)
> 
> I do not see the need for such a case of degrading the write permissions 
> of an allocation, unless it refers to the release of a pool of 
> allocations (see updating the SELinux policy DB)

A few more thoughts about pools. Not sure if they are all correct.
Note: I stick to "pool", instead of mm_struct, because what I'll say is 
mostly independent from the implementation.

- As Peter Zijlstra wrote earlier, protecting a target moves the focus 
of the attack to something else. In this case, probably, the "something 
else" would be the metadata of the pool(s).

- The amount of pools needed should be known at compilation time, so the 
metadata used for pools could be statically allocated and any change to 
it could be treated as write-rare.

- only certain fields of a pool structure would be writable, even as 
write-rare, after the pool is initialized.
In case the pool is a mm_struct or a superset (containing also 
additional properties, like the type of writability: RO or WR), the field

struct vm_area_struct *mmap;

is an example of what could be protected. It should be alterable only 
when creating/destroying the pool and making the first initialization.

- to speed up and also improve the validation of the target of a 
write-rare operation, it would be really desirable if the target had 
some intrinsic property which clearly differentiates it from 
non-write-rare memory. Its address, for example. The amount of write 
rare data needed by a full kernel should not exceed a few tens of 
megabytes. On a 64 bit system it shouldn't be so bad to reserve an 
address range maybe one order of magnitude lager than that.
It could even become a parameter for the creation of a pool.
SELinux, for example, should fit within 10-20MB. Or it could be a 
command line parameter.

- even if an hypervisor was present, it would be preferable to use it 
exclusively as extra protection, which triggers an exception only when 
something abnormal happens. The hypervisor should not become aware of 
the actual meaning of kernel (meta)data. Ideally, it would be mostly 
used for trapping unexpected writes to pages which are not supposed to 
be modified.

- one more reason for using pools is that, if each pool was also acting 
as memory cache for its users, attacks relying on use-after-free would 
not have access to possible vulnerability, because the memory and 
addresses associated with a pool would stay with it.

--
igor
