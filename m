Date: Mon, 23 Oct 2017 10:08:30 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20171023090829.bmddmm7463yhnqaf@salmiak>
References: <1508631773-2502-1-git-send-email-alex.popov@linux.com>
 <20171022131157.GB3165@worktop.lehotels.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171022131157.GB3165@worktop.lehotels.local>
Subject: [kernel-hardening] Re: [PATCH RFC v5 0/5] Introduce the STACKLEAK feature and a test
 for it
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Popov <alex.popov@linux.com>, kernel-hardening@lists.openwall.com, keescook@chromium.org, pageexec@freemail.hu, spender@grsecurity.net, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, tycho@docker.com, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 22, 2017 at 03:11:57PM +0200, Peter Zijlstra wrote:
> On Sun, Oct 22, 2017 at 03:22:48AM +0300, Alexander Popov wrote:
> > Further work
> > =============
> > 
> >  - Rewrite erase_kstack() in C (if Ingo Molnar insists).
> 
> Aside from legacy, is there any sane reason that stuff is in ASM? That
> is, I too will insist it being in C unless you can provide good
> arguments on why it needs be asm. All it does is memzero() right? And I
> would think architectures already have fairly optimized implementations
> of that around.

One argument for this being in asm is that you can't control the stack
usage of a C implementation of erase_kstack(), which leaves a (small)
portion of the stack potentially not cleared depending on what exactly
the compiler does with the stack.

If it's just a call to memzero(), the asm should be very simple, and I'd
think it's better to err on the side of clearing as much of the stack as
possible.

Thanks,
Mark.
