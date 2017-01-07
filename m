Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 7 Jan 2017 08:46:58 +0100
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20170107074658.GC13565@gmail.com>
References: <20170104221630.831-1-thgarnie@google.com>
 <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com>
 <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CA+55aFzVnRZbGMKZ5ppOJRDTtpzFjEN3LDRZZjCcm2bKW731qg@mail.gmail.com>
 <CALCETrUTF5jCEouQuE5bdzSx13p7zuvBf7K1AUh_hn-=TWuAcA@mail.gmail.com>
 <CAJcbSZFJWr-39FjL2weLHpL2kpDVTqNkEvmJrO4qYcp1RS95RQ@mail.gmail.com>
 <CALCETrXe3mSu6NnOCA5K1W9DPmVcgQ85oEvHv+_Jyy39vyQdTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXe3mSu6NnOCA5K1W9DPmVcgQ85oEvHv+_Jyy39vyQdTw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Andy Lutomirski <luto@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@kernel.org> wrote:

> > When I looked at the fixmap, you had to define the space you need ahead of 
> > time and I am not sure there was enough space as you said.
> 
> Can you try it and see if anything goes wrong?  Even if something does go wrong, 
> I think we should fix *that* rather than making the memory layout more 
> complicated.

Absolutely! This should always be the driving principle when complicating the 
kernel's memory layout.

Thanks,

	Ingo
