Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170107074537.GB13565@gmail.com>
References: <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CAJcbSZHAtxbRzhTcZtBSabW0t+Cj7a1z-xJk8d310a2h8pkG=g@mail.gmail.com>
 <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
 <CAJcbSZETh-A+zABOzsx+VW3p73AXO4xnc=O_TG7iXaVbD=Zz1A@mail.gmail.com>
 <20170106064900.GC28091@gmail.com> <CAJcbSZFcYuEknFsRxqXDku9k8wVODOWa-AX5LpFmLAU2R=GkJw@mail.gmail.com>
 <CALCETrXuTH83fH7HViQkXjLqHKNZAT-TLguAzdD6WA6LvsTrcw@mail.gmail.com>
 <CAJcbSZEDfL=AWmgxAnbzmnXFMnvF68_Tp_34Dt+X1o7WE9bffw@mail.gmail.com>
 <CALCETrXgabhubUXMiTP5AgSASMkkzG+bYFaSoPt52QBZLm-PVg@mail.gmail.com> <20170107074537.GB13565@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 7 Jan 2017 07:58:38 -0800
Message-ID: <CALCETrV1sPCzn1001tinLai2kEXOhfos4Pok3aymK3N2m8pMXw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Garnier <thgarnie@google.com>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 6, 2017 at 11:45 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@kernel.org> wrote:

>> P.S. Let's do the move to the fixmap, read/write as a separate patch. That will
>> make bisecting much easier.
>
> Absolutely, but this has to be within the same series, as the interim fixmap-only
> step is less secure in some circumstances: we are moving the writable GDT from a
> previously randomized location to a fixed location.

True, but despite being randomized its location was never even
remotely secret.  (Except on Kaby Lake or Foobar Lake or whatever CPU
that is.)

--Andy
