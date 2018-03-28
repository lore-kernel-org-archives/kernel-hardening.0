MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
References: <20180327213609.GA2964@beast> <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 27 Mar 2018 14:22:31 -1000
Message-ID: <CA+55aFzi0aUGuxDOwj1HkrP6r2Df2jk5F0HDTOQCG6_eeytbYw@mail.gmail.com>
Subject: Re: [PATCH] task_struct: Only use anon struct under randstruct plugin
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 1:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Why?  What caused this padding?  It happens in all configs?

I assume what happens is that the anonymous struct ends up containing
fields that are cacheline-aligned, and then the whole anonymous struct
is cacheline-aligned.

Which is all kinds of stupid, since the anonymous struct itself does
not exist outside of the outer struct. So it would be entirely
sufficient to just make the outer struct cacheline aligned (like it
used to be), but not align the inner anonymous one - just the fields
in it.

But there may be "reasons" why the inner anonymous  one needs to be
aligned. Maybe it's some standards requirement, or maybe it's just an
internal gcc implementation detail.

Regardless, it's a bit sad. It also means that when randomization is
on, that unnecessary padding will be there.

I wonder if there is some acceptable trick to avoid it. Maybe the
anonymous struct can be marked as not needing alignment, even if the
fields inside of it would still need to be aligned wrt the outer
struct.

>> Instead,
>> move the anonymous struct to being only used when struct layout
>> randomization is enabled.
>
> So the mysterious 40 byte bloat is still present in this case?

Almost certainly. And the struct randomization will possibly add much
*more* padding elsewhere, since at least some of  our structures are
laid out to try to avoid padding, and then the randomization might be
breaking that.

               Linus
