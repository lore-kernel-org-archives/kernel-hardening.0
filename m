Date: Wed, 31 Oct 2018 10:45:06 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181031094506.GM744@hirez.programming.kicks-ass.net>
References: <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Igor Stoppa <igor.stoppa@gmail.com>, Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 02:02:12PM -0700, Andy Lutomirski wrote:
> But I dislike allowing regular writes in the protected region. We
> really only need four write primitives:
> 
> 1. Just write one value.  Call at any time (except NMI).
> 
> 2. Just copy some bytes. Same as (1) but any number of bytes.

Given the !preempt/!IRQ contraints I'd certainly put an upper limit on
the number of bytes there.

> 3,4: Same as 1 and 2 but must be called inside a special rare write
> region. This is purely an optimization.
> 
> Actually getting a modifiable pointer should be disallowed for two
> reasons:
> 
> 1. Some architectures may want to use a special
> write-different-address-space operation.

You're thinking of s390 ? :-)

> Heck, x86 could, too: make
> the actual offset be a secret and shove the offset into FSBASE or
> similar. Then %fs-prefixed writes would do the rare writes.

> 2. Alternatively, x86 could set the U bit. Then the actual writes
> would use the uaccess helpers, giving extra protection via SMAP.

Cute, and yes, something like that would be nice.

> We don’t really want a situation where an unchecked pointer in the
> rare write region completely defeats the mechanism.

Agreed.
