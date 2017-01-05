Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFzVnRZbGMKZ5ppOJRDTtpzFjEN3LDRZZjCcm2bKW731qg@mail.gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com> <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com> <CA+55aFzVnRZbGMKZ5ppOJRDTtpzFjEN3LDRZZjCcm2bKW731qg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 5 Jan 2017 15:16:05 -0800
Message-ID: <CAJcbSZHjZ0O425AwKRt_Oh3fPuAC=cXTuP8E6PF7-+YJOM9c8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 3:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 5, 2017 at 12:18 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> Hmm.  I bet that if we preset the accessed bits in all the segments
>> then we don't need it to be writable in general.
>
> I'm not sure that this is architecturally safe.
>
> IIRC, we do mark the IDT read-only - but that one we started doing due
> to the f00f bug, so we knew it was ok. I'm not sure you can do the
> same with the GDT/LDT.
>

I started testing a variant that make the GDT remapping read-only by
default and writeable only for LTR. Everything works fine, even
hibernation. I need to do more testing though on different
architectures.

To be on the safe side, I could separate the read-only part in a
separate patch so we can easily remove it if extended testing show
something.

>                    Linus



-- 
Thomas
