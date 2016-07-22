Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 22 Jul 2016 22:11:05 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160722201104.GA6613@gmail.com>
References: <cover.1468270393.git.luto@kernel.org>
 <fb3254e25e38790c538cca0f46c4a7a714c77ddf.1468270393.git.luto@kernel.org>
 <5741.1469162592@turing-police.cc.vt.edu>
 <4b028b92-81f3-362f-c5be-b7a35cedf5ee@kernel.org>
 <20160722102105.GA20771@gmail.com>
 <CALCETrVKzUh_RYBoogWsEjYMe89en-NeNQhnWomy4LD=DaKfWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVKzUh_RYBoogWsEjYMe89en-NeNQhnWomy4LD=DaKfWQ@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v5 03/32] x86/cpa: In populate_pgd,
 don't set the pgd entry until it's populated
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Valdis Kletnieks <Valdis.Kletnieks@vt.edu>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Andy Lutomirski <luto@amacapital.net> wrote:

> This garbage (as evidenced by my bug and my failed attempt to fix it)
> only works if you never have a low-level page table that isn't linked
> into a higher-level page table, and it mostly requires you to do
> everything exactly the way it was originally done so all the horrible
> inline helpers don't get confused.
> 
> And AFAICT all of this was done to manually unroll a loop, and I bet
> it never sped anything up measurably even on 386 or PPro.
> 
> Whenever some vendor releases a 5 level page table CPU, can we
> *please* clean this up first?  We should have a type that points to a
> table, a different type that points to an entry (or maybe not have
> pointers to entries at all), and the levels should be referred to by
> *number*.  When you need to traverse all the way down, you write a
> *loop* instead of four bloody helper functions, some of which are
> incomprehensibly no-ops on some kernels.  And if this means that, on
> Intel, we have a silly branch in the inner loop because the bottom
> level entry format is special, who cares?
> </rant>

I'd welcome (and help out!) any effort to clean it up gradually.

Thanks,

	Ingo
