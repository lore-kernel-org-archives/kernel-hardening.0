Date: Tue, 3 Jul 2018 16:03:49 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] arm64: Clear the stack
Message-ID: <20180703150349.fndcq7h5hl3mtain@armageddon.cambridge.arm.com>
References: <20180629190553.7282-1-labbott@redhat.com>
 <9733d929-3c6a-40e1-6110-8f79975323d3@linux.com>
 <1b97aa7d-2b6c-a5df-0caa-1cd16e18a816@redhat.com>
 <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703121440.v4olvwqb3ykgt5fm@lakrids.cambridge.arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Laura Abbott <labbott@redhat.com>, will.deacon@arm.com, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, james.morse@arm.com, linux-arm-kernel@lists.infradead.org, alex.popov@linux.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 03, 2018 at 01:14:41PM +0100, Mark Rutland wrote:
> On Mon, Jul 02, 2018 at 11:48:05AM -0700, Laura Abbott wrote:
> > On 07/02/2018 06:02 AM, Alexander Popov wrote:
> > > On 29.06.2018 22:05, Laura Abbott wrote:
> > > > Implementation of stackleak based heavily on the x86 version
> > > > 
> > > > Signed-off-by: Laura Abbott <labbott@redhat.com>
> > > > ---
> > > > Changes since last time:
> > > > - Minor name change in entry.S
> > > > - Converted to use the generic interfaces so there's minimal additions.
> > > > - Added the fast syscall path.
> > > > - Addition of on_thread_stack and current_top_of_stack
> > > > - Disable stackleak on hyp per suggestion
> > > > - Added a define for check_alloca. I'm still not sure about keeping it
> > > >    since the x86 version got reworked?
> > > > 
> > > > I've mostly kept this as one patch with a minimal commit text. I can
> > > > split it up and elaborate more before final merging.
> > > > ---
> 
> [...]
> 
> > > > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > > > index ec2ee720e33e..31c9da7d401e 100644
> > > > --- a/arch/arm64/kernel/entry.S
> > > > +++ b/arch/arm64/kernel/entry.S
> > > > @@ -401,6 +401,11 @@ tsk	.req	x28		// current thread_info
> > > >   	.text
> > > > +	.macro	stackleak_erase
> > > 
> > > Could you rename the macro to STACKLEAK_ERASE for similarity with x86?
> > > 
> > 
> > Mark Rutland had previously asked for this to be lowercase.
> > I really don't care one way or the other so I'll defer to
> > someone else to have the final word.
> 
> Will, Catalin, could you chime in either way?
> 
> I'd previously asked for lower-case for consistency with our other
> assembly macros.

I'd keep it lowercase as the other arm64 macros in this file.

-- 
Catalin
