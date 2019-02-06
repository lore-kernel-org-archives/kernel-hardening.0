Date: Wed, 6 Feb 2019 12:41:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/17] x86/ftrace: set trampoline pages as executable
Message-ID: <20190206124108.07eef568@gandalf.local.home>
In-Reply-To: <5DFA1E3C-A335-4C4B-A86F-904A6CF6D871@gmail.com>
References: <20190117003259.23141-1-rick.p.edgecombe@intel.com>
	<20190117003259.23141-9-rick.p.edgecombe@intel.com>
	<20190206112213.2ec9dd5c@gandalf.local.home>
	<5DFA1E3C-A335-4C4B-A86F-904A6CF6D871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 6 Feb 2019 09:33:35 -0800
Nadav Amit <nadav.amit@gmail.com> wrote:


> >> 	/* Copy ftrace_caller onto the trampoline memory */
> >> 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
> >> @@ -818,6 +820,13 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
> >> 	/* ALLOC_TRAMP flags lets us know we created it */
> >> 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
> >> 
> >> +	/*
> >> +	 * Module allocation needs to be completed by making the page
> >> +	 * executable. The page is still writable, which is a security hazard,
> >> +	 * but anyhow ftrace breaks W^X completely.
> >> +	 */  
> > 
> > Perhaps we should set the page to non writable after the page is
> > updated? And set it to writable only when we need to update it.  
> 
> You remember that I sent you a patch that changed all these writes into
> text_poke() and you said that I should defer it until this series is merged?
> 

And I notice that it is set to RO after this call anyway.

-- Steve
