Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 5 Jan 2017 09:54:33 -0800
Message-ID: <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Arjan van de Ven <arjan@linux.intel.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 9:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Jan 4, 2017 at 2:16 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> Each processor holds a GDT in its per-cpu structure. The sgdt
>> instruction gives the base address of the current GDT. This address can
>> be used to bypass KASLR memory randomization. With another bug, an
>> attacker could target other per-cpu structures or deduce the base of the
>> main memory section (PAGE_OFFSET).
>>
>> In this change, a space is reserved at the end of the memory range
>> available for KASLR memory randomization. The space is big enough to hold
>> the maximum number of CPUs (as defined by setup_max_cpus). Each GDT is
>> mapped at specific offset based on the target CPU. Note that if there is
>> not enough space available, the GDTs are not remapped.
>
> Can we remap it read-only?  I.e. use PAGE_KERNEL_RO instead of
> PAGE_KERNEL.  After all, the ability to modify the GDT is instant
> root.

That's my goal too. I started by doing a RO remap and got couple
problems with hibernation. I can try again for the next iteration or
delay it for another patch. I also need to look at KVM GDT usage, I am
not familiar with it yet.

-- 
Thomas
