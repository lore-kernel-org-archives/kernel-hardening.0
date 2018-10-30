Subject: Re: [PATCH 10/17] prmem: documentation
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
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <1245ce5b-5c36-7b5e-6bd7-b7bfeb3848b5@gmail.com>
Date: Tue, 30 Oct 2018 23:49:12 +0200
MIME-Version: 1.0
In-Reply-To: <20181030213557.GE10491@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Tycho Andersen <tycho@tycho.ws>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On 30/10/2018 23:35, Matthew Wilcox wrote:
> On Tue, Oct 30, 2018 at 10:43:14PM +0200, Igor Stoppa wrote:


>> Would it be possible to do the same here?
> 
> What Andy is proposing effectively puts all rare allocations into
> one pool.  Although I suppose it could be generalised to multiple pools
> ... one mm_struct per pool.  Andy, what do you think to doing that?

The reason to have pools is that, continuing the SELinux example, it 
supports reloading the policyDB.

In this case it seems to me that it would be faster to drop the entire 
pool in one go, and create a new one when re-initializing the rules.

Or maybe the pool could be flushed, without destroying the metadata.
One more reason for having pools is to assign certain property to the 
pool and then rely on it to be applied to every subsequent allocation.

I've also been wondering if pools can be expected to have some well 
defined property.

One might be that they do not need to be created on the fly.
The number of pools should be known at compilation time.
At least the meta-data could be static, but I do not know how this would 
work with modules.

>>> but we'd probably wrap it in list_for_each_rare_entry(), just to be nicer.
>>
>> This seems suspiciously close to the duplication of kernel interfaces that I
>> was roasted for :-)
> 
> Can you not see the difference between adding one syntactic sugar function
> and duplicating the entire infrastructure?

And list_add()? or any of the other list related functions?
Don't they end up receiving a similar treatment?

I might have misunderstood your proposal, but it seems to me that they 
too will need the same type of pairs rare_modify/rare_protect. No?

And same for hlist, including the _rcu variants.

--
igor
