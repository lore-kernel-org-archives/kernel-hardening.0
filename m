Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org> <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
Date: Tue, 30 Oct 2018 22:43:14 +0200
MIME-Version: 1.0
In-Reply-To: <20181030192021.GC10491@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>
Cc: Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 30/10/2018 21:20, Matthew Wilcox wrote:
> On Tue, Oct 30, 2018 at 12:28:41PM -0600, Tycho Andersen wrote:
>> On Tue, Oct 30, 2018 at 10:58:14AM -0700, Matthew Wilcox wrote:
>>> On Tue, Oct 30, 2018 at 10:06:51AM -0700, Andy Lutomirski wrote:
>>>>> On Oct 30, 2018, at 9:37 AM, Kees Cook <keescook@chromium.org> wrote:
>>>> I support the addition of a rare-write mechanism to the upstream kernel.
>>>> And I think that there is only one sane way to implement it: using an
>>>> mm_struct. That mm_struct, just like any sane mm_struct, should only
>>>> differ from init_mm in that it has extra mappings in the *user* region.
>>>
>>> I'd like to understand this approach a little better.  In a syscall path,
>>> we run with the user task's mm.  What you're proposing is that when we
>>> want to modify rare data, we switch to rare_mm which contains a
>>> writable mapping to all the kernel data which is rare-write.
>>>
>>> So the API might look something like this:
>>>
>>> 	void *p = rare_alloc(...);	/* writable pointer */
>>> 	p->a = x;
>>> 	q = rare_protect(p);		/* read-only pointer */

With pools and memory allocated from vmap_areas, I was able to say

protect(pool)

and that would do a swipe on all the pages currently in use.
In the SELinux policyDB, for example, one doesn't really want to 
individually protect each allocation.

The loading phase happens usually at boot, when the system can be 
assumed to be sane (one might even preload a bare-bone set of rules from 
initramfs and then replace it later on, with the full blown set).

There is no need to process each of these tens of thousands allocations 
and initialization as write-rare.

Would it be possible to do the same here?

>>>
>>> To subsequently modify q,
>>>
>>> 	p = rare_modify(q);
>>> 	q->a = y;
>>
>> Do you mean
>>
>>      p->a = y;
>>
>> here? I assume the intent is that q isn't writable ever, but that's
>> the one we have in the structure at rest.
> 
> Yes, that was my intent, thanks.
> 
> To handle the list case that Igor has pointed out, you might want to
> do something like this:
> 
> 	list_for_each_entry(x, &xs, entry) {
> 		struct foo *writable = rare_modify(entry);

Would this mapping be impossible to spoof by other cores?

I'm asking this because, from what I understand, local interrupts are 
enabled here, so an attack could freeze the core performing the 
write-rare operation, while another scrapes the memory.

But blocking interrupts for the entire body of the loop would make RT 
latency unpredictable.

> 		kref_get(&writable->ref);
> 		rare_protect(writable);
> 	}
> 
> but we'd probably wrap it in list_for_each_rare_entry(), just to be nicer.

This seems suspiciously close to the duplication of kernel interfaces 
that I was roasted for :-)

--
igor
