Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jul 2016 16:08:03 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160711150802.GB7691@leverpostej>
References: <cover.1466974736.git.luto@kernel.org>
 <aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
 <20160711100808.GB31221@leverpostej>
 <CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v4 26/29] sched: Allow putting
 thread_info into task_struct
To: Andy Lutomirski <luto@amacapital.net>
Cc: Nadav Amit <nadav.amit@gmail.com>, linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brian Gerst <brgerst@gmail.com>, X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 11, 2016 at 07:55:17AM -0700, Andy Lutomirski wrote:
> On Jul 11, 2016 3:08 AM, "Mark Rutland" <mark.rutland@arm.com> wrote:
> >
> > Hi,
> >
> > On Sun, Jun 26, 2016 at 02:55:48PM -0700, Andy Lutomirski wrote:
> > > If an arch opts in by setting CONFIG_THREAD_INFO_IN_TASK_STRUCT,
> > > then thread_info is defined as a single 'u32 flags' and is the first
> > > entry of task_struct.  thread_info::task is removed (it serves no
> > > purpose if thread_info is embedded in task_struct), and
> > > thread_info::cpu gets its own slot in task_struct.
> > >
> > > This is heavily based on a patch written by Linus.
> >
> > I've been considering how we'd implement this for arm64, and I suspect
> > that we'll also need to fold our preempt_count into task_struct
> > (following from the style of asm-generic/preempt.h).
> >
> > As far as I can see, we can't make our preempt-count a percpu variable
> > as with x86, as our percpu ops themselves are based on disabling
> > preemption.
> 
> How do you intend to find 'current' to get to the preempt count
> without first disabling preemption?

Good point.

For some reason I had convinced myself that it only mattered for RMW
sequences, so evidently I hadn't considered things thoroughly enough. :(

> > To that end, would it be possible to keep the thread_info definition per
> > arch, even with CONFIG_THREAD_INFO_IN_TASK?
> 
> In principal, yes, but could you alternatively put it in
> thread_struct?  My goal here is to encourage people to clean up their
> use of thread_info vs thread_struct at the same time.  For x86, that
> cleanup was trivial -- most of the work was addressing relative to
> current instead of the stack pointer, and that had to happen
> regardless.

I'm more than happy to do that, modulo the above permitting.

Sorry for the noise!

Thanks,
Mark.
