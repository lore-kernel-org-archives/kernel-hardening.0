Date: Tue, 15 Aug 2017 17:39:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170815163955.GK6090@leverpostej>
References: <1502801449-29246-1-git-send-email-mark.rutland@arm.com>
 <1502801449-29246-3-git-send-email-mark.rutland@arm.com>
 <CALCETrWAYvKTcgaQgEDC-ihhSuFAw9Phq-xF6FK5AMM6ag6j4A@mail.gmail.com>
 <20170815163036.GJ6090@leverpostej>
 <CALCETrWP-cufvhLJU2Q7BPAYw+HmyzJHVWPvmmCS+bq84Up1zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWP-cufvhLJU2Q7BPAYw+HmyzJHVWPvmmCS+bq84Up1zQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCHv2 02/14] fork: allow arch-override of VMAP stack alignment
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Laura Abbott <labbott@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 15, 2017 at 09:33:18AM -0700, Andy Lutomirski wrote:
> On Tue, Aug 15, 2017 at 9:30 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > On Tue, Aug 15, 2017 at 09:09:36AM -0700, Andy Lutomirski wrote:

> >> This looks okay, but it might make sense to move that to a header file
> >> so THREAD_ALIGN is always available.
> >
> > I was a little worried about breaking things, since arches don't define
> > THREAD_SIZE in a consistent location.
> >
> > Looking again, it looks like those are all transitiviely included into
> > each arch's <asm/thread_info.h>, so I think I can move this into
> > <linux/thread_info.h>, which'll have to be added to kernel.fork.c's
> > includes.
> >
> > Are you happy with the below fixup?
> 
> LGTM.

Cool. I've folded that in and pushed the updated branch.

Thanks,
Mark.
