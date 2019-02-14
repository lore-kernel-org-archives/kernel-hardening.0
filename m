Date: Thu, 14 Feb 2019 17:15:52 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH v8 03/14] mm, x86: Add support for eXclusive Page
 Frame Ownership (XPFO)
Message-ID: <20190214161552.GF4423@zn.tnic>
References: <cover.1550088114.git.khalid.aziz@oracle.com>
 <8275de2a7e6b72d19b1cd2ec5d71a42c2c7dd6c5.1550088114.git.khalid.aziz@oracle.com>
 <20190214105631.GJ32494@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190214105631.GJ32494@hirez.programming.kicks-ass.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Khalid Aziz <khalid.aziz@oracle.com>, juergh@gmail.com, tycho@tycho.ws, jsteckli@amazon.de, ak@linux.intel.com, torvalds@linux-foundation.org, liran.alon@oracle.com, keescook@google.com, akpm@linux-foundation.org, mhocko@suse.com, catalin.marinas@arm.com, will.deacon@arm.com, jmorris@namei.org, konrad.wilk@oracle.com, Juerg Haefliger <juerg.haefliger@canonical.com>, deepa.srinivasan@oracle.com, chris.hyser@oracle.com, tyhicks@canonical.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com, jcm@redhat.com, boris.ostrovsky@oracle.com, kanth.ghatraju@oracle.com, oao.m.martins@oracle.com, jmattson@google.com, pradeep.vincent@oracle.com, john.haxby@oracle.com, tglx@linutronix.de, kirill.shutemov@linux.intel.com, hch@lst.de, steven.sistare@oracle.com, labbott@redhat.com, luto@kernel.org, dave.hansen@intel.com, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Tycho Andersen <tycho@docker.com>, Marco Benatto <marco.antonio.780@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 14, 2019 at 11:56:31AM +0100, Peter Zijlstra wrote:
> > +EXPORT_SYMBOL(xpfo_kunmap);
> 
> And these here things are most definitely not IRQ-safe.

Should also be EXPORT_SYMBOL_GPL.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
