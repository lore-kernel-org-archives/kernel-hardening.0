Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com> <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 5 Jan 2017 12:18:34 -0800
Message-ID: <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Garnier <thgarnie@google.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 11:03 AM, Thomas Garnier <thgarnie@google.com> wrote:
> On Thu, Jan 5, 2017 at 10:58 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>> On 1/5/2017 9:54 AM, Thomas Garnier wrote:
>>
>>>
>>> That's my goal too. I started by doing a RO remap and got couple
>>> problems with hibernation. I can try again for the next iteration or
>>> delay it for another patch. I also need to look at KVM GDT usage, I am
>>> not familiar with it yet.
>>
>>
>> don't we write to the GDT as part of the TLS segment stuff for glibc ?
>>
>
> Not sure which glibc feature it is.
>
> In this design, you can write to the GDT per-cpu variable that will
> remain read-write. You just need to make the remapping writeable when
> we load task registers (ltr) then the processor use the current GDT
> address. At least that the case I know, I might find more through
> testing.

Hmm.  I bet that if we preset the accessed bits in all the segments
then we don't need it to be writable in general.  But your point about
set_thread_area (TLS) is well taken.  However, I strongly suspect that
we could make set_thread_area unconditionally set the accessed bit and
no one would ever notice.
