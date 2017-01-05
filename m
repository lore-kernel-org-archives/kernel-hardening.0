Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com> <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CAJcbSZHAtxbRzhTcZtBSabW0t+Cj7a1z-xJk8d310a2h8pkG=g@mail.gmail.com> <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 5 Jan 2017 13:58:17 -0800
Message-ID: <CAJcbSZETh-A+zABOzsx+VW3p73AXO4xnc=O_TG7iXaVbD=Zz1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 5, 2017 at 1:19 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Jan 5, 2017 at 1:08 PM, Thomas Garnier <thgarnie@google.com> wrote:
>> On Thu, Jan 5, 2017 at 12:18 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>> On Thu, Jan 5, 2017 at 11:03 AM, Thomas Garnier <thgarnie@google.com> wrote:
>>>> On Thu, Jan 5, 2017 at 10:58 AM, Arjan van de Ven <arjan@linux.intel.com> wrote:
>>>>> On 1/5/2017 9:54 AM, Thomas Garnier wrote:
>>>>>
>>>>>>
>>>>>> That's my goal too. I started by doing a RO remap and got couple
>>>>>> problems with hibernation. I can try again for the next iteration or
>>>>>> delay it for another patch. I also need to look at KVM GDT usage, I am
>>>>>> not familiar with it yet.
>>>>>
>>>>>
>>>>> don't we write to the GDT as part of the TLS segment stuff for glibc ?
>>>>>
>>>>
>>>> Not sure which glibc feature it is.
>>>>
>>>> In this design, you can write to the GDT per-cpu variable that will
>>>> remain read-write. You just need to make the remapping writeable when
>>>> we load task registers (ltr) then the processor use the current GDT
>>>> address. At least that the case I know, I might find more through
>>>> testing.
>>>
>>> Hmm.  I bet that if we preset the accessed bits in all the segments
>>> then we don't need it to be writable in general.  But your point about
>>> set_thread_area (TLS) is well taken.  However, I strongly suspect that
>>> we could make set_thread_area unconditionally set the accessed bit and
>>> no one would ever notice.
>>
>> Not sure I fully understood and I don't want to miss an important
>> point. Do you mean making GDT (remapping and per-cpu) read-only and
>> switch the writeable flag only when we write to the per-cpu entry?
>>
>
> What I mean is: write to the GDT through normal percpu access (or
> whatever the normal mapping is) but load a read-only alias into the
> GDT register.  As long as nothing ever tries to write through the GDTR
> alias, no page faults will be generated.  So we just need to make sure
> that nothing ever writes to it through GDTR.  AFAIK the only reason
> the CPU ever writes to the address in GDTR is to set an accessed bit.
>

A write is made when we use load_TR_desc (ltr). I didn't see any other yet.

> --Andy



-- 
Thomas
