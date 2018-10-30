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
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <2cfb3835-0c18-b3fb-1722-5d693ae0ecd2@gmail.com>
Date: Wed, 31 Oct 2018 00:15:46 +0200
MIME-Version: 1.0
In-Reply-To: <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 30/10/2018 23:02, Andy Lutomirski wrote:
> 
> 
>> On Oct 30, 2018, at 1:43 PM, Igor Stoppa <igor.stoppa@gmail.com> wrote:


>> There is no need to process each of these tens of thousands allocations and initialization as write-rare.
>>
>> Would it be possible to do the same here?
> 
> I don’t see why not, although getting the API right will be a tad complicated.

yes, I have some first-hand experience with this :-/

>>
>>>>>
>>>>> To subsequently modify q,
>>>>>
>>>>>     p = rare_modify(q);
>>>>>     q->a = y;
>>>>
>>>> Do you mean
>>>>
>>>>      p->a = y;
>>>>
>>>> here? I assume the intent is that q isn't writable ever, but that's
>>>> the one we have in the structure at rest.
>>> Yes, that was my intent, thanks.
>>> To handle the list case that Igor has pointed out, you might want to
>>> do something like this:
>>>     list_for_each_entry(x, &xs, entry) {
>>>         struct foo *writable = rare_modify(entry);
>>
>> Would this mapping be impossible to spoof by other cores?
>>
> 
> Indeed. Only the core with the special mm loaded could see it.
> 
> But I dislike allowing regular writes in the protected region. We really only need four write primitives:
> 
> 1. Just write one value.  Call at any time (except NMI).
> 
> 2. Just copy some bytes. Same as (1) but any number of bytes.
> 
> 3,4: Same as 1 and 2 but must be called inside a special rare write region. This is purely an optimization.

Atomic? RCU?

Yes, they are technically just memory writes, but shouldn't the "normal" 
operation be executed on the writable mapping?

It is possible to sandwich any call between a rare_modify/rare_protect, 
however isn't that pretty close to having a write-rare version of these 
plain function.

--
igor
