Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 7 Jan 2017 08:45:37 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170107074537.GB13565@gmail.com>
References: <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CAJcbSZHAtxbRzhTcZtBSabW0t+Cj7a1z-xJk8d310a2h8pkG=g@mail.gmail.com>
 <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
 <CAJcbSZETh-A+zABOzsx+VW3p73AXO4xnc=O_TG7iXaVbD=Zz1A@mail.gmail.com>
 <20170106064900.GC28091@gmail.com>
 <CAJcbSZFcYuEknFsRxqXDku9k8wVODOWa-AX5LpFmLAU2R=GkJw@mail.gmail.com>
 <CALCETrXuTH83fH7HViQkXjLqHKNZAT-TLguAzdD6WA6LvsTrcw@mail.gmail.com>
 <CAJcbSZEDfL=AWmgxAnbzmnXFMnvF68_Tp_34Dt+X1o7WE9bffw@mail.gmail.com>
 <CALCETrXgabhubUXMiTP5AgSASMkkzG+bYFaSoPt52QBZLm-PVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXgabhubUXMiTP5AgSASMkkzG+bYFaSoPt52QBZLm-PVg@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> > I looked back at the fixmap, and I can see a way it could be done (using 
> > NR_CPUS) like the other fixmap ranges. It would limit the number of cpus to 
> > 512 (there is 2M memory left on fixmap on the default configuration). That's 
> > if we never add any other fixmap on x64. I don't know if it is an acceptable 
> > number and if the fixmap region could be increased. (128 if we do your kvm 
> > trick, of course).
> 
> IIRC we need 4096 CPUs.

On 64-bit the limit is 8192 CPUs, and the SGI guys are relying on that up to the 
tune of 6144 cores already, and I'd say the 64-bit CPU count is likely to go up 
further with 5-level paging.

On 32-bit the reasonable CPU limit is the number that the Intel 32-bit cluster 
computing nodes use. The latest public numbers are I think 36 'tiles' with each 
tile being a 2-CPU SMT core - i.e. a limit of 72 CPUs has to be maintained. 
(They'll obviously go to 64-bit as well so this problem will go away in a hardware 
generation or two.)

So I'd say 128 CPUs on 32-bit should be a reasonable practical limit going 
forward. Right now our 32-bit limit is 512 CPUs IIRC, but I don't think any real 
hardware in production is reaching that.

> P.S. Let's do the move to the fixmap, read/write as a separate patch. That will 
> make bisecting much easier.

Absolutely, but this has to be within the same series, as the interim fixmap-only 
step is less secure in some circumstances: we are moving the writable GDT from a 
previously randomized location to a fixed location.

Thanks,

	Ingo
