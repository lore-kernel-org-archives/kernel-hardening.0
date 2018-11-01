Date: Thu, 1 Nov 2018 18:08:09 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 10/17] prmem: documentation
Message-ID: <20181101170809.GG3178@hirez.programming.kicks-ass.net>
References: <20181030175814.GB10491@bombadil.infradead.org>
 <20181030182841.GE7343@cisco>
 <20181030192021.GC10491@bombadil.infradead.org>
 <9edbdf8b-b5fb-5a82-43b4-b639f5ec8484@gmail.com>
 <20181030213557.GE10491@bombadil.infradead.org>
 <CALCETrW1FcT88u0QY9k_PMOeZj0G8H6KNb5Bnreo-12NvmmCEQ@mail.gmail.com>
 <20181031100237.GN744@hirez.programming.kicks-ass.net>
 <659CFC78-22BF-492B-B2E4-B8E89AA08446@amacapital.net>
 <20181031210032.GA3159@hirez.programming.kicks-ass.net>
 <2E29C35B-3F98-473D-A874-0D9B9B15B399@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2E29C35B-3F98-473D-A874-0D9B9B15B399@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Matthew Wilcox <willy@infradead.org>, Igor Stoppa <igor.stoppa@gmail.com>, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Igor Stoppa <igor.stoppa@huawei.com>, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 31, 2018 at 03:57:21PM -0700, Andy Lutomirski wrote:
> > On Oct 31, 2018, at 2:00 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> On Wed, Oct 31, 2018 at 01:36:48PM -0700, Andy Lutomirski wrote:

> >> This stuff is called *rare* write for a reason. Do we really want to
> >> allow atomics beyond just store-release?  Taking a big lock and then
> >> writing in the right order should cover everything, no?
> > 
> > Ah, so no. That naming is very misleading.
> > 
> > We modify page-tables a _lot_. The point is that only a few sanctioned
> > sites are allowed writing to it, not everybody.
> > 
> > I _think_ the use-case for atomics is updating the reference counts of
> > objects that are in this write-rare domain. But I'm not entirely clear
> > on that myself either. I just really want to avoid duplicating that
> > stuff.
> 
> Sounds nuts. Doing a rare-write is many hundreds of cycles at best.

Yes, which is why I'm somewhat sceptical of the whole endeavour.
