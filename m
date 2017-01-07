Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170107073553.GA13565@gmail.com>
References: <bd1d6468-dfe1-8fbc-521b-4fd2e418a3ef@linux.intel.com>
 <CAJcbSZEdwhDkoLATb5kJn9W84KfaLr1BJBq+Zp1jpKW7yOSLsg@mail.gmail.com>
 <CALCETrXymLa1_u90XE6dinhOfiecEJjbUGYn8apXGkiRFuwrZQ@mail.gmail.com>
 <CAJcbSZHAtxbRzhTcZtBSabW0t+Cj7a1z-xJk8d310a2h8pkG=g@mail.gmail.com>
 <CALCETrUpC-Zp-mHCMVE6QdXTnzJDQLyckqaZhW0KJfZeX=oxXg@mail.gmail.com>
 <CAJcbSZETh-A+zABOzsx+VW3p73AXO4xnc=O_TG7iXaVbD=Zz1A@mail.gmail.com>
 <20170106064900.GC28091@gmail.com> <CAJcbSZFcYuEknFsRxqXDku9k8wVODOWa-AX5LpFmLAU2R=GkJw@mail.gmail.com>
 <CALCETrXuTH83fH7HViQkXjLqHKNZAT-TLguAzdD6WA6LvsTrcw@mail.gmail.com>
 <CAJcbSZEDfL=AWmgxAnbzmnXFMnvF68_Tp_34Dt+X1o7WE9bffw@mail.gmail.com> <20170107073553.GA13565@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 7 Jan 2017 08:02:21 -0800
Message-ID: <CALCETrVRTZibyhH3yc2xtTkpjiGtfoihHRV39TOb8gXee9tHRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC] x86/mm/KASLR: Remap GDTs at fixed location
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave@sr71.net>, Chen Yucong <slaoub@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Michael Ellerman <mpe@ellerman.id.au>, Juergen Gross <jgross@suse.com>, Richard Weinberger <richard@nod.at>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jan 6, 2017 at 11:35 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> > No, and I had the way this worked on 64-bit wrong.  LTR requires an
>> > available TSS and changes it to busy.  So here are my thoughts on how
>> > this should work:
>> >
>> > Let's get rid of any connection between this code and KASLR.  Every
>> > time KASLR makes something work differently, a kitten turns all
>> > Schr=C3=B6dinger on us.  This is moving the GDT to the fixmap, plain a=
nd
>> > simple.  For now, make it one page per CPU and don't worry about the
>> > GDT limit.
>>
>> I am all for this change but that's more significant.
>>
>> Ingo: What do you think about that?
>
> I agree with Andy: as I alluded to earlier as well this should be an unco=
nditional
> change (tested properly, etc.) that robustifies the GDT mapping for every=
one. That
> KASLR kernels improve too is a happy side effect!
>
>> > On 32-bit, we're going to have to make the fixmap GDT be read-write be=
cause
>> > making it read-only will break double-fault handling.
>> >
>> > On 64-bit, we can use your trick of temporarily mapping the GDT read-w=
rite
>> > every time we load TR, which should happen very rarely. Alternatively,=
 we can
>> > reload the *GDT* every time we reload TR, which should be comparably s=
low.
>> > This is going to regress performance in the extremely rare case where =
KVM
>> > exits to a process that uses ioperm() (I think), but I doubt anyone ca=
res.  Or
>> > maybe we could arrange to never reload TR when GDT points at the fixma=
p by
>> > having KVM set the host GDT to the direct version and letting KVM's co=
de to
>> > reload the GDT switch to the fixmap copy.
>
> Please check whether the LTR write generates a page fault to a RO PTE eve=
n if the
> busy bit is already set. LTR is pretty slow which suggests that it's micr=
ocode,
> and microcode is usually not sloppy about such things: i.e. LTR would onl=
y
> generate an unconditional write if there's a compatibility dependency on =
it. But I
> could easily be wrong ...

The SDM says:

IF segment descriptor is not for an available TSS
THEN #GP(segment selector); FI;

so I think it's #GP not #PF.

>
>> > If we need a quirk to keep the fixmap copy read-write, so be it.
>> >
>> > None of this should depend on KASLR.  IMO it should happen uncondition=
ally.
>>
>> I looked back at the fixmap, and I can see a way it could be done
>> (using NR_CPUS) like the other fixmap ranges. It would limit the
>> number of cpus to 512 (there is 2M memory left on fixmap on the
>> default configuration). That's if we never add any other fixmap on
>> x64. I don't know if it is an acceptable number and if the fixmap
>> region could be increased. (128 if we do your kvm trick, of course).
>>
>> Ingo: What do you think?
>
> I think we should scale the fixmap size flexibly with NR_CPUs on 64-bit, =
and we
> should limit CPUs on 32-bit to a reasonable value.

Unless the headers are even more tangled than usual, I think we could
just handle this exactly.  The top and bottom of the fixmap are known
exactly at compile time, so we should just be able to make the next mm
range adjust its start point accordingly.  The main issue right now
seems to be that MODULES_END is hard-coded.

For 32-bit, the task gate in #DF is going to be a show-stopper for an
RO fixmap, I think.  I'm still slightly in favor of enabling the code
but with an RW mapping on 32-bit, though.  And anyone running hundreds
to thousands of CPUs on 32-bit is nuts anyway.

--Andy
