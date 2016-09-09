Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 9 Sep 2016 17:31:16 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160909163116.GA10792@leverpostej>
References: <1472828533-28197-1-git-send-email-catalin.marinas@arm.com>
 <CAGXu5j++0LgDEv=m1yQb4hB57MQ2MYVCpeex9TFTRmQpNYhNsQ@mail.gmail.com>
 <20160908125123.ypkye5nclsi5vx4f@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160908125123.ypkye5nclsi5vx4f@localhost>
Subject: [kernel-hardening] Re: [PATCH v2 0/7] arm64: Privileged Access Never using TTBR0_EL1
 switching
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Will Deacon <will.deacon@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Julien Grall <julien.grall@arm.com>, James Morse <james.morse@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 08, 2016 at 01:51:24PM +0100, Catalin Marinas wrote:
> On Wed, Sep 07, 2016 at 04:20:55PM -0700, Kees Cook wrote:
> > On Fri, Sep 2, 2016 at 8:02 AM, Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > This is the second version of the arm64 PAN emulation by disabling
> > > TTBR0_EL1 accesses. The major change from v1 is the use of a thread_info
> > > member to store the real TTBR0_EL1 value. The advantage is slightly
> > > simpler assembler macros for uaccess_enable with the downside that
> > > switch_mm() must always update the saved ttbr0 even if there is no mm
> > > switch.
> > 
> > Is arm64 thread_info attached to the kernel stack? (i.e. is this
> > introducing a valuable target for stack-based attacks?)
> 
> Currently yes, thread_info is on the kernel stack. At some point we'll
> decouple it in a similar way to what x86 are doing/planning.

FWIW, I'm currently working on this (atop of Andy's x86 patches). The
IRQ stack work largely removed out dependence on the stack pointer to
find thread_info, and I have a plan for the remaining places.

There's a fair amount of ground work to do first (e.g. reworking headers
to avoid circular dependencies), but hopefully I'll have something that
I can share soon.

Thanks,
Mark.
