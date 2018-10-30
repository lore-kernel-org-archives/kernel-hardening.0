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
 <CAGXu5j+58PcvXmt6qp4aZdDz_pBFV-P_rmp3zg6vQnpMvoMdXA@mail.gmail.com>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <66a34590-a6d0-ff19-b765-cef8f76f7755@gmail.com>
Date: Tue, 30 Oct 2018 23:25:51 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+58PcvXmt6qp4aZdDz_pBFV-P_rmp3zg6vQnpMvoMdXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@infradead.org>, Tycho Andersen <tycho@tycho.ws>, Peter Zijlstra <peterz@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>



On 30/10/2018 23:07, Kees Cook wrote:

> We still have to deal with certain structures under the write-rare
> window. For example, see:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/commit/?h=kspp/write-rarely&id=60430b4d3b113aae4adab66f8339074986276474
> They are wrappers to non-inline functions that have the same sanity-checking.

Even if I also did something similar, it was not intended to be final.
Just a stop-gap solution till the write-rare mechanism is identified.

If the size of the whole list_head is used as alignment, then the whole 
list_head structure can be given an alternate mapping and the plain list 
function can be used on this alternate mapping.

It can halve the overhead or more.
The typical case is when not only one list_head is contained in one 
page, but also the other, like when allocating and queuing multiple 
items from the same pool.
One single temporary mapping would be enough.

But it becomes tricky to do it, without generating code that is
almost-but-not-quite-identical.

--
igor
