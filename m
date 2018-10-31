Date: Wed, 31 Oct 2018 11:11:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181031101124.GO744@hirez.programming.kicks-ass.net>
References: <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <BAA65A07-F3AF-4209-9D18-7075CEF11EE8@amacapital.net>
 <2cfb3835-0c18-b3fb-1722-5d693ae0ecd2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cfb3835-0c18-b3fb-1722-5d693ae0ecd2@gmail.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 31, 2018 at 12:15:46AM +0200, Igor Stoppa wrote:
> On 30/10/2018 23:02, Andy Lutomirski wrote:

> > But I dislike allowing regular writes in the protected region. We
> > really only need four write primitives:
> > 
> > 1. Just write one value.  Call at any time (except NMI).
> > 
> > 2. Just copy some bytes. Same as (1) but any number of bytes.
> > 
> > 3,4: Same as 1 and 2 but must be called inside a special rare write
> > region. This is purely an optimization.
> 
> Atomic? RCU?

RCU can be done, that's not really a problem. Atomics otoh are a
problem. Having pointers makes them just work.

Andy; I understand your reason for not wanting them, but I really don't
want to duplicate everything. Is there something we can do with static
analysis to make you more comfortable with the pointer thing?
