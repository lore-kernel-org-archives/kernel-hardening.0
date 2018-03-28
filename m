Date: Wed, 28 Mar 2018 11:51:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] task_struct: Only use anon struct under randstruct plugin
Message-ID: <20180328095140.GP4043@hirez.programming.kicks-ass.net>
References: <20180327213609.GA2964@beast>
 <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
 <CA+55aFzi0aUGuxDOwj1HkrP6r2Df2jk5F0HDTOQCG6_eeytbYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzi0aUGuxDOwj1HkrP6r2Df2jk5F0HDTOQCG6_eeytbYw@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 02:22:31PM -1000, Linus Torvalds wrote:
> On Tue, Mar 27, 2018 at 1:03 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Why?  What caused this padding?  It happens in all configs?
> 
> I assume what happens is that the anonymous struct ends up containing
> fields that are cacheline-aligned, and then the whole anonymous struct
> is cacheline-aligned.

Yes, structures inherit the alignment requirements of their constituent
members.

> Which is all kinds of stupid, since the anonymous struct itself does
> not exist outside of the outer struct. So it would be entirely
> sufficient to just make the outer struct cacheline aligned (like it
> used to be), but not align the inner anonymous one - just the fields
> in it.
> 
> But there may be "reasons" why the inner anonymous  one needs to be
> aligned. Maybe it's some standards requirement, or maybe it's just an
> internal gcc implementation detail.

Last time I read the standard there wasn't a distinction between
anonymous and regular structures for this. So in that regards a strict
reading of the standard would mandate this behaviour.

> Regardless, it's a bit sad. It also means that when randomization is
> on, that unnecessary padding will be there.

The other complaint is that the anonymous structure makes the pahole
output (which is what I showed) unnecessarily ugly.
