Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 21 Sep 2016 11:28:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160921102827.GC18176@leverpostej>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
 <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
 <CALCETrWni0aZ71r-R6oYG98kZvZA8a184UR0YURk_=tXu8HXMw@mail.gmail.com>
 <20160916103101.GA21702@leverpostej>
 <CALCETrUDWiDmLbMqw9sQYEzvDuSVfmT_UscxQXfmf8YYyTOC=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUDWiDmLbMqw9sQYEzvDuSVfmT_UscxQXfmf8YYyTOC=Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC PATCH 2/8] thread_info: allow custom in-task thread_info
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com, Kees Cook <keescook@chromium.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, lorenzo.pieralisi@arm.com, Andrew Lutomirski <luto@kernel.org>, suzuki.poulose@arm.com, Takahiro Akashi <takahiro.akashi@linaro.org>, Will Deacon <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Andy,

On Fri, Sep 16, 2016 at 08:11:14AM -0700, Andy Lutomirski wrote:
> > On Thu, Sep 15, 2016 at 11:37:47AM -0700, Andy Lutomirski wrote:
> > Just to check, what do you mean to happen with the flags field? Should
> > that always be in the generic thread_info? e.g.
> >
> > struct thread_info {
> >         u32 flags;
> > #ifdef arch_thread_info
> >         struct arch_thread_info arch_ti;
> > #endif
> > };
> 
> Exactly.  Possibly with a comment that using thread_struct should be
> preferred and that arch_thread_info should be used only if some header
> file requires access via current_thread_info() or task_thread_info().

While fixing up these patches, I realised that I'm somewhat concerned by 
flags becoming a u32 (where it was previously an unsigned long for
arm64).

The generic {test,set,*}_ti_thread_flag() helpers use the usual bitops,
which perform accesses of sizeof(unsigned long) at a time, and for arm64
these need to be naturally-aligned.

We happen to get that alignment from subsequent fields in task_struct
and/or thread_info, and for arm64 we don't seem to have a problem with
tearing, but it feels somewhat fragile, and leaves me uneasy.

Looking at the git log, it seems that x86 also use unsigned long until
commit affa219b60a11b32 ("x86: change thread_info's flag field back to
32 bits"), where if I'm reading correctly, this was done to get rid of
unnecessary padding. With THREAD_INFO_IN_STACK, thread_info::flags is
immediately followed by a long on x86, so we save no padding.

Given all that, can we make the generic thread_info::flags an unsigned
long, matching what the thread flag helpers implicitly assume?

Thanks,
Mark.
