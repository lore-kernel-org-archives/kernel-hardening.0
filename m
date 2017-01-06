Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 6 Jan 2017 07:45:31 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170106064531.GB28091@gmail.com>
References: <20170104221630.831-1-thgarnie@google.com>
 <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com>
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Arjan van de Ven <arjan@linux.intel.com> wrote:

> On 1/5/2017 9:54 AM, Thomas Garnier wrote:
> 
> > That's my goal too. I started by doing a RO remap and got couple problems with 
> > hibernation. I can try again for the next iteration or delay it for another 
> > patch. I also need to look at KVM GDT usage, I am not familiar with it yet.
> 
> don't we write to the GDT as part of the TLS segment stuff for glibc ?

Yes - but the idea would be to have two virtual memory aliases:

 1) A world-readable RO mapping of the GDT put into the fixmap area (randomization
    is not really required as the SGDT instruction exposes it anyway).

    This read-only GDT mapping has two advantages:

     - Because the GDT address is read-only it cannot be used by exploits as an 
       easy trampoline for 100% safe, deterministic rooting of the system from a 
       local process.

     - Even on older CPUs the SGDT instruction won't expose the absolute address 
       of critical kernel data structures.

 2) A kernel-only RW mapping in the linear kernel memory map where the original
    page is - randomized (as a natural part of kernel physical and virtual memory
    randomization) and only known and accessible to the kernel, SGDT doesn't 
    expose it even on older CPUs.

This way we IMHO have the best of both worlds.

Assuming there are no strange CPU errata surfacing if we use a RO GDT - OTOH that 
should be fairly easy to test for, and worst-case we could quirk-off the feature 
on CPUs where this cannot be done safely.

Thanks,

	Ingo
