Date: Mon, 2 Jul 2018 10:59:32 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH] arm64: Clear the stack
Message-ID: <20180702095931.GB28665@arm.com>
References: <20180629190553.7282-1-labbott@redhat.com>
 <CAGXu5jL8kZHtg-MdScZ5m_6xH_Ho4TsdKGWH83zEL9Y5rutncw@mail.gmail.com>
 <706dc06b-0157-89cb-33a6-d0b9d811dcf0@redhat.com>
 <CAGXu5jLW5FJdRdRXcP=xPOEcQ=Tg+uSi=vj6vQ39iVp=QHSRAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLW5FJdRdRXcP=xPOEcQ=Tg+uSi=vj6vQ39iVp=QHSRAQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Alexander Popov <alex.popov@linux.com>, catalin.marinas@arm.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Fri, Jun 29, 2018 at 01:25:20PM -0700, Kees Cook wrote:
> On Fri, Jun 29, 2018 at 1:22 PM, Laura Abbott <labbott@redhat.com> wrote:
> > On 06/29/2018 01:19 PM, Kees Cook wrote:
> >>
> >> On Fri, Jun 29, 2018 at 12:05 PM, Laura Abbott <labbott@redhat.com> wrote:
> >>>
> >>> Implementation of stackleak based heavily on the x86 version
> >>>
> >>> Signed-off-by: Laura Abbott <labbott@redhat.com>
> >>> [...]
> >>> +#define current_top_of_stack() (task_stack_page(current) + THREAD_SIZE)
> >>> +#define on_thread_stack()      (on_task_stack(current,
> >>> current_stack_pointer))
> >>
> >>
> >> nit on types here. I get some warnings:
> >>
> >> kernel/stackleak.c:55:12: warning: assignment makes integer from
> >> pointer without a cast [-Wint-conversion]
> >>     boundary = current_top_of_stack();
> >>              ^
> >> kernel/stackleak.c:65:24: warning: assignment makes integer from
> >> pointer without a cast [-Wint-conversion]
> >>    current->lowest_stack = current_top_of_stack() - THREAD_SIZE / 64;
> >>                          ^
> >>
> >> So I think this needs to be:
> >>
> >> +#define current_top_of_stack() ((unsigned long)task_stack_page(current) +
> >> \
> >> +                                THREAD_SIZE)
> >>
> >
> > Argh, missed that in an amend, can fix for next version if there
> > are no other objections to this approach.
> 
> No worries! I've made the change locally and will push this out to
> -next unless there are objections?

I'm a bit wary of conflicts in entry.S, since it's likely that we're going
to have a lot going on in there for 4.19.

Could I take this via arm64 instead, please, or are there dependencies
on other parts of your tree?

Will
