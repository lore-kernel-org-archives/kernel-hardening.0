Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 25 Apr 2019 22:07:25 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern
 CPUs
Message-ID: <20190425200725.GC58719@gmail.com>
References: <20190424203408.GA11386@beast>
 <20190425054242.GA7816@gmail.com>
 <CAGXu5jKWQtmt+tN9rwdCWP=7pL6GYU4DmDW4R7ViQV8r1m1J=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKWQtmt+tN9rwdCWP=7pL6GYU4DmDW4R7ViQV8r1m1J=g@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Jason Gunthorpe <jgg@mellanox.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Wed, Apr 24, 2019 at 10:42 PM Ingo Molnar <mingo@kernel.org> wrote:
> > Just to make clear, is the change from the old behavior, in essence:
> >
> >
> >                CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
> >   ELF:              |           |                  |                  |
> >   ------------------------------|------------------|------------------|
> >   missing GNU_STACK | exec-all  | exec-all         | exec-none        |
> > - GNU_STACK == RWX  | exec-all  | exec-all         | exec-all         |
> > + GNU_STACK == RWX  | exec-all  | exec-stack       | exec-stack       |
> >   GNU_STACK == RW   | exec-all  | exec-none        | exec-none        |
> > [...]
> >    'exec-all'  : all user mappings are executable
> 
> For extreme clarity, this should be:
> 
> 'exec-all' : all PROT_READ user mappings are executable, except when
> backed by files on a noexec-filesystem.
> 
> >    'exec-none' : only PROT_EXEC user mappings are executable
> >    'exec-stack': only the stack and PROT_EXEC user mappings are executable
> 
> Thanks for helping clarify this. I spent last evening trying to figure
> out a better way to explain/illustrate this series; my prior patch
> combines too many things into a single change. One thing I noticed is
> the "lacks NX" column is wrong: for "lack NX", our current state is
> "don't care". If we _add_ RIE for the "lacks NX" case unconditionally,
> we may cause unexpected problems[1]. More on this below...

So what does RIE in the !NX case do to regular RAM (with the exception of 
device memory, see below), does it actively reject or modify actual 
mmap() calls and introduces behavioral changes, or is it mostly just the 
/proc reporting of permission bits?

If it's just reporting, with no (intended) behavioral side effects, then 
is there really a true difference?

> But yes, your above diff for "has NX" is roughly correct. I'll walk
> through each piece I'm thinking about. Here is the current state:
> 
>                CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
>   ELF:              |            |                  |                |
>   -------------------------------|------------------|----------------|
>   missing GNU_STACK | exec-all   | exec-all         | exec-all       |
>   GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
>   GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
> 
> *this column has no architecture effect: NX markings are ignored by
> hardware, but may have behavioral effects when "wants X" collides with
> "cannot be X" constraints in memory permission flags, as in [1].

So [1] appears to be device driver mapping a BAR that isn't intended to 
be excutable:

   https://lore.kernel.org/netdev/20190418055759.GA3155@mellanox.com/

and the question is, do we reject this at the device driver mmap() level 
already, right?

I suspect the best behavior is to reject as early as possible, so I agree 
with your change here - even though !NX systems tend to become less and 
less relevant these days.

( User-space can still work it around in practice by not using PROT_EXEC 
  and sending CPU execution there - with undefined/undesirable outcomes, 
  but that's user-space getting what they are asking for. )

> I want to make three changes, listed in increasing risk levels.
> 
> First, I want to split "missing GNU_STACK" and "GNU_STACK == RWX",
> which is currently causing expected behavior for driver mmap
> regions[1], etc:
> 
>                CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
>   ELF:              |            |                  |                |
>   -------------------------------|------------------|----------------|
>   missing GNU_STACK | exec-all   | exec-all         | exec-all       |
> - GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
> + GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
>   GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
> 
> AFAICT, this has the least risk. I'm not aware of any situation where
> GNU_STACK==RWX is supposed to mean MORE than that. As Jann researched,
> even thread stacks will be treated correctly[2]. The risk would be
> discovering some use-case where a program was executing memory that it
> had not explicitly marked as executable. For ELFs marked with
> GNU_STACK, this seems unlikely (I hope).

Ack: and this actively increases security for GNU_STACK=RWX executables, 
as it modifies exec-all to exec-stack, which narrows executability in a 
real way, and enforced by NX CPUs both in 64-bit and 32-bit apps. While 
obviously the executable stack is a gaping hole in the typical case, not 
all attacks can utilize an executable stack and they might be able to 
utilize other W+X regions such as the heap or some data mmap() area, 
right?

BTW., do we have any compat variations with the table, i.e. tasks running 
on a 32-bit kernel versus running in 32-bit mode on a 64-bit kernel? I.e. 
should there be another column for compat, or is compat behavior always 
the same as 32-bit kernel behavior?

> Second, I want to split the behavior of "missing GNU_STACK" between
> ia32 and x86_64. The reasonable(?) default for x86_64 memory is for it
> to be NX. For the very rare x86_64 systems that do not have NX, this
> shouldn't change anything because they still fall into the "don't
> care" column. It would look like this:
> 
>                CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
>   ELF:              |            |                  |                |
>   -------------------------------|------------------|----------------|
> - missing GNU_STACK | exec-all   | exec-all         | exec-all       |
> + missing GNU_STACK | exec-all   | exec-all         | exec-none      |
>   GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
>   GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
> 
> This carries some risk that there are ancient x86_64 binaries that
> still behave like their even more ancient ia32 counterparts, and
> expect to be able to execute any memory. I would _hope_ this is rare,
> but I have no way to actually know if things like this exist in the
> real world.

Ack: this too actively restricts executability which is the right 
direction to go. (Absent reported regressions.)

> Third, I want to have the "lacks NX" column actually reflect reality.
> Right now on such a system, memory permissions will show "not
> executable" but there is actually no architectural checking for these
> permissions. I think the true nature of such a system should be
> reflected in the reported permissions. It would look like this:
> 
>                CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
>   ELF:              |            |                  |                |
>   -------------------------------|------------------|----------------|
>   missing GNU_STACK | exec-all   | exec-all         | exec-none      |
> - GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
> - GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
> + GNU_STACK == RWX  | exec-all   | exec-stack       | exec-stack     |
> + GNU_STACK == RW   | exec-all   | exec-none        | exec-none      |
> 
> This carries the largest risk because it effectively enables
> READ_IMPLIES_EXEC on all processes for such systems. I worry this
> might trip as-yet-unseen problems like in [1], for only cosmetic
> improvements.
> 
> My intention was to split up the series and likely not even bother
> with the third change, since it feels like too high a risk to me. What
> do you think?

So what's the benefit of this third phase, more transparency because 
reported permissions and API behavior will match reality?

Can we do something else perhaps and do phase 3 change for *RAM* backed 
vmas, but be more restrictive for device mappings, allowing [1] to be 
handled better?

I suspect there will be a complexity threshold where it's better to 
default to the simpler approach though, especially since !NX gets so 
little attention and testing these days. So I'd be fine with phase 3 too.

I'd definitely suggest making this 3 separate patches, so any regressions 
can be tracked back to the specific change that triggers it.

Thanks,

	Ingo
