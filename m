Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <28C8CD2A-BDC0-49A5-854E-1E18968528B8@amacapital.net>
 <20181030212551.GD10491@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <a62a1fed-252b-f4c8-8abb-0e4468f50fe8@gmail.com>
Date: Tue, 30 Oct 2018 23:55:46 +0200
MIME-Version: 1.0
In-Reply-To: <20181030212551.GD10491@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Matthew Wilcox <willy@infradead.org>, Andy Lutomirski <luto@amacapital.net>
Cc: nadav.amit@gmail.com, Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 30/10/2018 23:25, Matthew Wilcox wrote:
> On Tue, Oct 30, 2018 at 11:51:17AM -0700, Andy Lutomirski wrote:
>> Finally, one issue: rare_alloc() is going to utterly suck
>> performance-wise due to the global IPI when the region gets zapped out
>> of the direct map or otherwise made RO.  This is the same issue that
>> makes all existing XPO efforts so painful. We need to either optimize
>> the crap out of it somehow or we need to make sure it’s not called
>> except during rare events like device enumeration.
> 
> Batching operations is kind of the whole point of the VM ;-)  Either
> this rare memory gets used a lot, in which case we'll want to create slab
> caches for it, make it a MM zone and the whole nine yeards, or it's not
> used very much in which case it doesn't matter that performance sucks.
> 
> For now, I'd suggest allocating 2MB chunks as needed, and having a
> shrinker to hand back any unused pieces.

One of the prime candidates for this sort of protection is IMA.
In the IMA case, there are ever-growing lists which are populated when 
accessing files.
It's something that ends up on the critical path of any usual 
performance critical use case, when accessing files for the first time, 
like at boot/application startup.

Also the SELinux AVC is based on lists. It uses an object cache, but it 
is still something that grows and is on the critical path of evaluating 
the callbacks from the LSM hooks. A lot of them.

These are the main two reasons, so far, for me advocating an 
optimization of the write-rare version of the (h)list.

--
igor
