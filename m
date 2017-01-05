Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 5 Jan 2017 09:11:14 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170105081114.GD2098@gmail.com>
References: <20170104221630.831-1-thgarnie@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170104221630.831-1-thgarnie@google.com>
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Garnier <thgarnie@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, x86@kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Thomas Garnier <thgarnie@google.com> wrote:

> Each processor holds a GDT in its per-cpu structure. The sgdt
> instruction gives the base address of the current GDT. This address can
> be used to bypass KASLR memory randomization. With another bug, an
> attacker could target other per-cpu structures or deduce the base of the
> main memory section (PAGE_OFFSET).
> 
> In this change, a space is reserved at the end of the memory range
> available for KASLR memory randomization. The space is big enough to hold
> the maximum number of CPUs (as defined by setup_max_cpus). Each GDT is
> mapped at specific offset based on the target CPU. Note that if there is
> not enough space available, the GDTs are not remapped.
> 
> The document was changed to mention GDT remapping for KASLR. This patch
> also include dump page tables support.
> 
> This patch was tested on multiple hardware configurations and for
> hibernation support.

>  void kernel_randomize_memory(void);
> +void kernel_randomize_smp(void);
> +void* kaslr_get_gdt_remap(int cpu);

Yeah, no fundamental objections from me to the principle, but I get some bad vibes 
from the naming here: seeing that kernel_randomize_smp() actually makes things 
less random.

Also, don't we want to do this unconditionally and not allow remapping failures? 

The GDT is fairly small, plus making the SGDT instruction expose fewer kernel 
internals would be (marginally) useful on non-randomized kernels as well.

It also makes the code more common, more predictable, more debuggable and less 
complex overall - which is pretty valuable in terms of long term security as well.

Thanks,

	Ingo
