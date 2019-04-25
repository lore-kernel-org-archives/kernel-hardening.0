MIME-Version: 1.0
References: <20190424203408.GA11386@beast> <20190425054242.GA7816@gmail.com>
In-Reply-To: <20190425054242.GA7816@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 25 Apr 2019 09:51:54 -0700
Message-ID: <CAGXu5jKWQtmt+tN9rwdCWP=7pL6GYU4DmDW4R7ViQV8r1m1J=g@mail.gmail.com>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern CPUs
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Jason Gunthorpe <jgg@mellanox.com>, Will Deacon <will.deacon@arm.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 24, 2019 at 10:42 PM Ingo Molnar <mingo@kernel.org> wrote:
> Just to make clear, is the change from the old behavior, in essence:
>
>
>                CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
>   ELF:              |           |                  |                  |
>   ------------------------------|------------------|------------------|
>   missing GNU_STACK | exec-all  | exec-all         | exec-none        |
> - GNU_STACK == RWX  | exec-all  | exec-all         | exec-all         |
> + GNU_STACK == RWX  | exec-all  | exec-stack       | exec-stack       |
>   GNU_STACK == RW   | exec-all  | exec-none        | exec-none        |
> [...]
>    'exec-all'  : all user mappings are executable

For extreme clarity, this should be:

'exec-all' : all PROT_READ user mappings are executable, except when
backed by files on a noexec-filesystem.

>    'exec-none' : only PROT_EXEC user mappings are executable
>    'exec-stack': only the stack and PROT_EXEC user mappings are executable

Thanks for helping clarify this. I spent last evening trying to figure
out a better way to explain/illustrate this series; my prior patch
combines too many things into a single change. One thing I noticed is
the "lacks NX" column is wrong: for "lack NX", our current state is
"don't care". If we _add_ RIE for the "lacks NX" case unconditionally,
we may cause unexpected problems[1]. More on this below...

But yes, your above diff for "has NX" is roughly correct. I'll walk
through each piece I'm thinking about. Here is the current state:

               CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  ELF:              |            |                  |                |
  -------------------------------|------------------|----------------|
  missing GNU_STACK | exec-all   | exec-all         | exec-all       |
  GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
  GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |

*this column has no architecture effect: NX markings are ignored by
hardware, but may have behavioral effects when "wants X" collides with
"cannot be X" constraints in memory permission flags, as in [1].


I want to make three changes, listed in increasing risk levels.

First, I want to split "missing GNU_STACK" and "GNU_STACK == RWX",
which is currently causing expected behavior for driver mmap
regions[1], etc:

               CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  ELF:              |            |                  |                |
  -------------------------------|------------------|----------------|
  missing GNU_STACK | exec-all   | exec-all         | exec-all       |
- GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
+ GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |

AFAICT, this has the least risk. I'm not aware of any situation where
GNU_STACK==RWX is supposed to mean MORE than that. As Jann researched,
even thread stacks will be treated correctly[2]. The risk would be
discovering some use-case where a program was executing memory that it
had not explicitly marked as executable. For ELFs marked with
GNU_STACK, this seems unlikely (I hope).


Second, I want to split the behavior of "missing GNU_STACK" between
ia32 and x86_64. The reasonable(?) default for x86_64 memory is for it
to be NX. For the very rare x86_64 systems that do not have NX, this
shouldn't change anything because they still fall into the "don't
care" column. It would look like this:

               CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  ELF:              |            |                  |                |
  -------------------------------|------------------|----------------|
- missing GNU_STACK | exec-all   | exec-all         | exec-all       |
+ missing GNU_STACK | exec-all  | exec-all         | exec-none      |
  GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |

This carries some risk that there are ancient x86_64 binaries that
still behave like their even more ancient ia32 counterparts, and
expect to be able to execute any memory. I would _hope_ this is rare,
but I have no way to actually know if things like this exist in the
real world.


Third, I want to have the "lacks NX" column actually reflect reality.
Right now on such a system, memory permissions will show "not
executable" but there is actually no architectural checking for these
permissions. I think the true nature of such a system should be
reflected in the reported permissions. It would look like this:

               CPU: | lacks NX*  | has NX, ia32     | has NX, x86_64 |
  ELF:              |            |                  |                |
  -------------------------------|------------------|----------------|
  missing GNU_STACK | exec-all   | exec-all         | exec-none      |
- GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
- GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
+ GNU_STACK == RWX  | exec-all   | exec-stack       | exec-stack     |
+ GNU_STACK == RW   | exec-all   | exec-none        | exec-none      |

This carries the largest risk because it effectively enables
READ_IMPLIES_EXEC on all processes for such systems. I worry this
might trip as-yet-unseen problems like in [1], for only cosmetic
improvements.

My intention was to split up the series and likely not even bother
with the third change, since it feels like too high a risk to me. What
do you think?

> In particular, what is the policy for write-only and exec-only mappings,
> what does read-implies-exec do for them?

First it manifests here, which is used for stack and brk:

#define VM_DATA_DEFAULT_FLAGS \
        (((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0 ) | \
         VM_READ | VM_WRITE | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)

above is used in do_brk_flags(), and is picked up by
VM_STACK_DEFAULT_FLAGS, visible in VM_STACK_FLAGS for
setup_arg_pages()'s stack creation.

READ_IMPLIES_EXEC itself is checked directly in mmap, with noexec
checks that also clear VM_MAYEXEC:

        if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
                if (!(file && path_noexec(&file->f_path)))
                        prot |= PROT_EXEC;
...
                        if (path_noexec(&file->f_path)) {
                                if (vm_flags & VM_EXEC)
                                        return -EPERM;
                                vm_flags &= ~VM_MAYEXEC;

The above is where we discussed adding some kind of check for device
driver memory mapping in [1] (or getting distros to mount /dev noexec,
which seems to break other things...), but I'd rather just fix
READ_IMPLIES_EXEC.

Write-only would ignore READ_IMPLIES_EXEC, but mprotect() rechecks it
if PROT_READ gets added later:

        const bool rier = (current->personality & READ_IMPLIES_EXEC) &&
                                (prot & PROT_READ);
...
                /* Does the application expect PROT_READ to imply PROT_EXEC */
                if (rier && (vma->vm_flags & VM_MAYEXEC))
                        prot |= PROT_EXEC;

> Also, it would be nice to define it precisely what 'stack' means in this
> context: it's only the ELF loader defined process stack - other stacks
> such as any thread stacks, signal stacks or alt-stacks depend on the C
> library - or does the kernel policy extend there too?

Correct: this is only the ELF loader stack. Thread stacks are (and
always have been) on their own. But as Jann found in [2], they should
be unchanged by anything here.

> I.e. it would be nice to clarify all this, because it's still rather
> confusing and ambiguous right now.

Agreed. I've been trying to pick it apart too, hopefully this helps.

-Kees

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
[2] https://lore.kernel.org/patchwork/patch/464875/

-- 
Kees Cook
