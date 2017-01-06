Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAJcbSZFJWr-39FjL2weLHpL2kpDVTqNkEvmJrO4qYcp1RS95RQ@mail.gmail.com>
References: <20170104221630.831-1-thgarnie@google.com> <CALCETrWk8VdYiJKZ0AdYfvwAd3q=UfGx9ida4U+DWZjLSGGqiA@mail.gmail.com>
 <CAJcbSZEQkq13K8WA6GoFBUHnbRK+ba9QU0B-pXJ7Zt3fnWMAtw@mail.gmail.com>
 <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com> <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CA+55aFzVnRZbGMKZ5ppOJRDTtpzFjEN3LDRZZjCcm2bKW731qg@mail.gmail.com>
 <CALCETrUTF5jCEouQuE5bdzSx13p7zuvBf7K1AUh_hn-=TWuAcA@mail.gmail.com> <CAJcbSZFJWr-39FjL2weLHpL2kpDVTqNkEvmJrO4qYcp1RS95RQ@mail.gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 6 Jan 2017 13:53:00 -0800
Message-ID: <CALCETrXe3mSu6NnOCA5K1W9DPmVcgQ85oEvHv+_Jyy39vyQdTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Thomas Garnier <thgarnie@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 6, 2017 at 10:02 AM, Thomas Garnier <thgarnie@google.com> wrote=
:
> On Thu, Jan 5, 2017 at 6:34 PM, Andy Lutomirski <luto@amacapital.net> wro=
te:
>> On Thu, Jan 5, 2017 at 3:05 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> On Thu, Jan 5, 2017 at 12:18 PM, Andy Lutomirski <luto@kernel.org> wrot=
e:
>>>>
>>>> Hmm.  I bet that if we preset the accessed bits in all the segments
>>>> then we don't need it to be writable in general.
>>>
>>> I'm not sure that this is architecturally safe.
>>>
>>
>> Hmm.  Last time I looked, I couldn't find *anything* in the SDM
>> explaining what happened if a GDT access resulted in a page fault.  I
>> did discover that Xen intentionally (!) lazily populates and maps LDT
>> pages.  An attempt to access a not-present page results in #PF with
>> the error cod e indicating kernel access even if the access came from
>> user mode.
>>
>> SDM volume 3 7.2.2 says "Pages corresponding to the previous task=E2=80=
=99s
>> TSS, the current task=E2=80=99s TSS, and the descriptor table entries fo=
r
>> each all should be marked as read/write."  But I don't see how a CPU
>> implementation could possibly care what the page table for the TSS
>> descriptor table entries says after LTR is done because the CPU isn't
>> even supposed to *read* that memory.
>>
>> OTOH a valid implementation could easily require that the page table
>> says that the page is writable merely to load a segment, especially in
>> weird cases (IRET?).  That being said, this is all quite easy to test.
>>
>> Also, Thomas, why are you creating a new memory region?  I don't see
>> any benefit to randomizing the GDT address.  How about just putting it
>> in the fixmap?  This  would be NR_CPUS * 4 pages if do my limit=3D0xffff
>> idea.  I'm not sure if the fixmap code knows how to handle this much
>> space.
>
> When I looked at the fixmap, you had to define the space you need
> ahead of time and I am not sure there was enough space as you said.

Can you try it and see if anything goes wrong?  Even if something does
go wrong, I think we should fix *that* rather than making the memory
layout more complicated.
