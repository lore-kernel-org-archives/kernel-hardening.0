Date: Wed, 31 Oct 2018 10:18:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181031091859.GI744@hirez.programming.kicks-ass.net>
References: <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <CAGXu5jKCs01jvtvpEFS7R8qCR-5iRqK11kJxLJY99NicGWc4aQ@mail.gmail.com>
 <20181028183126.GB744@hirez.programming.kicks-ass.net>
 <40cd77ce-f234-3213-f3cb-0c3137c5e201@gmail.com>
 <20181030152641.GE8177@hirez.programming.kicks-ass.net>
 <CAGXu5jJftJ+Hq+jrZGHX5CTDLWOog7kGsd_Ne=yMvrRs__skSg@mail.gmail.com>
 <0A7AFB50-9ADE-4E12-B541-EC7839223B65@amacapital.net>
 <20181030175814.GB10491@bombadil.infradead.org>
 <d5b57049-419b-3bbb-dc8d-97e4024965df@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5b57049-419b-3bbb-dc8d-97e4024965df@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>, Andy Lutomirski <luto@amacapital.net>, Kees Cook <keescook@chromium.org>, Igor Stoppa <igor.stoppa@gmail.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 30, 2018 at 11:03:51AM -0700, Dave Hansen wrote:
> On 10/30/18 10:58 AM, Matthew Wilcox wrote:
> > Does this satisfy Igor's requirements?  We wouldn't be able to
> > copy_to/from_user() while rare_mm was active.  I think that's a feature
> > though!  It certainly satisfies my interests (kernel code be able to
> > mark things as dynamically-allocated-and-read-only-after-initialisation)
> 
> It has to be more than copy_to/from_user(), though, I think.
> 
> rare_modify(q) either has to preempt_disable(), or we need to teach the
> context-switching code when and how to switch in/out of the rare_mm.
> preempt_disable() would also keep us from sleeping.

Yes, I think we want to have preempt disable at the very least. We could
indeed make the context switch code smart and teach is about this state,
but I think allowing preemption in such section is a bad idea. We want
to keep these sections short and simple (and bounded), such that they
can be analyzed for correctness.

Once you allow preemption, things tend to grow large and complex.

Ideally we'd even disabled interrupts over this, to further limit what
code runs in the rare_mm context. NMIs need special care anyway.
