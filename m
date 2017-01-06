Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 6 Jan 2017 18:44:21 +0100
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20170106174421.cujnv2bcl5hqresn@pd.tnic>
References: <20170104221630.831-1-thgarnie@google.com>
 <20170105081114.GD2098@gmail.com>
 <4dffd167-9cfd-dfcc-6556-05d7ca8f4595@linux.intel.com>
 <CAJcbSZFjurkb7dpN40XpVQLziQVxPWCt9iRfnzbRa+TWYTdq8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJcbSZFjurkb7dpN40XpVQLziQVxPWCt9iRfnzbRa+TWYTdq8w@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Garnier <thgarnie@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 05, 2017 at 08:40:29AM -0800, Thomas Garnier wrote:
> > kernel_unrandomize_smp() ...
> >
> 
> That seems like a better name.

Hardly... I'd call it something like kaslr_load_gdt() to actually say
what this function is doing.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
