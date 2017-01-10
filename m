Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170110102733.GA5638@gmail.com>
References: <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CAJcbSZHAtxbRzhTcZtBSabW0t+Cj7a1z-xJk8d310a2h8pkG=g@mail.gmail.com>
 <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
 <CAJcbSZETh-A+zABOzsx+VW3p73AXO4xnc=O_TG7iXaVbD=Zz1A@mail.gmail.com>
 <20170106064900.GC28091@gmail.com> <CAJcbSZFcYuEknFsRxqXDku9k8wVODOWa-AX5LpFmLAU2R=GkJw@mail.gmail.com>
 <CALCETrXuTH83fH7HViQkXjLqHKNZAT-TLguAzdD6WA6LvsTrcw@mail.gmail.com>
 <CAJcbSZEDfL=AWmgxAnbzmnXFMnvF68_Tp_34Dt+X1o7WE9bffw@mail.gmail.com>
 <20170107073553.GA13565@gmail.com> <CAJcbSZF4YC46A9Bf=R6yJjbhZEhyNkmRnK6uVU0FEDEUyTAhmg@mail.gmail.com>
 <20170110102733.GA5638@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 10 Jan 2017 09:13:46 -0800
Message-ID: <CAJcbSZGgVBRPs-HtSyTXejyzr91zV18AfknZdrPT+=CP105pBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 10, 2017 at 2:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> Coming back on that after a bit more testing. The LTR instruction
>> check if the busy bit is already set, if already set then it will just
>> issue a #GP given a bad selector:
>>
>> [    0.000000] general protection fault: 0040 [#1] SMP
>> ...
>> [    0.000000] RIP: 0010:native_load_tr_desc+0x9/0x10
>> ...
>> [    0.000000] Call Trace:
>> [    0.000000]  cpu_init+0x2d0/0x3c0
>> [    0.000000]  trap_init+0x2a2/0x312
>> [    0.000000]  start_kernel+0x1fb/0x43b
>> [    0.000000]  ? set_init_arg+0x55/0x55
>> [    0.000000]  ? early_idt_handler_array+0x120/0x120
>> [    0.000000]  x86_64_start_reservations+0x2a/0x2c
>> [    0.000000]  x86_64_start_kernel+0x13d/0x14c
>> [    0.000000]  start_cpu+0x14/0x14
>>
>> I assume that's in this part of the pseudo-code:
>>
>> if(!IsWithinDescriptorTableLimit(Source.Offset) || Source.Type !=
>> TypeGlobal) Exception(GP(SegmentSelector));
>> SegmentDescriptor = ReadSegmentDescriptor();
>> if(!IsForAnAvailableTSS(SegmentDescriptor))
>> Exception(GP(SegmentSelector)); <---- That's where I got the GP
>> TSSSegmentDescriptor.Busy = 1;
>> <------------------------------------------------------------------
>> That's the pagefault I get otherwise
>> //Locked read-modify-write operation on the entire descriptor when
>> setting busy flag
>> TaskRegister.SegmentSelector = Source;
>> TaskRegister.SegmentDescriptor.TSSSegmentDescriptor;
>>
>> I assume the best option would be to make the remap read-write for the
>> LTR instruction. What do you think?
>
> So if LTR does not modify the GDT if the busy bit is already set, why don't we set
> the busy bit in the descriptor (via the linear mapping rw alias).
>
> Then the remapped GDT can stay read-only all the time and LTR won't fault.
>
> Am I missing something here?
>

Sorry, I may not have explained myself well.

If you set the busy bit on the GDT TSS entry, you get a #GP on LTR.

When we use the LTR instruction, we need the GDT to be writeable.

I think I can handle it by switching to the remap GDT after
load_TR_desc. I will try this approach.

> Thanks,
>
>         Ingo



-- 
Thomas
