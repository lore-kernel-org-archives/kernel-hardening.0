Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Thu, 25 Apr 2019 07:42:42 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern
 CPUs
Message-ID: <20190425054242.GA7816@gmail.com>
References: <20190424203408.GA11386@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424203408.GA11386@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Jason Gunthorpe <jgg@mellanox.com>, Will Deacon <will.deacon@arm.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> The READ_IMPLIES_EXEC work-around was designed for old CPUs lacking NX
> (to have the visible permission flags on memory regions reflect reality:
> they are all executable), and for old toolchains that lacked the ELF
> PT_GNU_STACK marking (under the assumption that toolchains that couldn't
> even specify memory protection flags may have it wrong for all memory
> regions).
> 
> This logic is sensible, but was implemented in a way that equated having
> a PT_GNU_STACK marked executable as being as "broken" as lacking the
> PT_GNU_STACK marking entirely. This is not a reasonable assumption
> for CPUs that have had NX support from the start (or very close to
> the start). This confusion has led to situations where modern 64-bit
> programs with explicitly marked executable stack are forced into the
> READ_IMPLIES_EXEC state when no such thing is needed. (And leads to
> unexpected failures when mmap()ing regions of device driver memory that
> wish to disallow VM_EXEC[1].)
> 
> To fix this, elf_read_implies_exec() is adjusted on arm64 (where NX has
> always existed and toolchains have implemented PT_GNU_STACK for a while),
> and x86 is adjusted to handle this combination of possible outcomes:
> 
>               CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
>  ELF:              |           |                  |                  |
>  ------------------------------|------------------|------------------|
>  missing GNU_STACK | needs RIE | needs RIE        | no RIE           |
>  GNU_STACK == RWX  | needs RIE | no RIE: stack X  | no RIE: stack X  |
>  GNU_STACK == RW   | needs RIE | no RIE: stack NX | no RIE: stack NX |
> 
> This has the effect of making binfmt_elf's EXSTACK_DEFAULT actually take
> on the correct architecture default of being non-executable on arm64 and
> x86_64, and being executable on ia32.

Just to make clear, is the change from the old behavior, in essence:


               CPU: | lacks NX  | has NX, ia32     | has NX, x86_64   |
  ELF:              |           |                  |                  |
  ------------------------------|------------------|------------------|
  missing GNU_STACK | exec-all  | exec-all         | exec-none        |
- GNU_STACK == RWX  | exec-all  | exec-all         | exec-all         |
+ GNU_STACK == RWX  | exec-all  | exec-stack       | exec-stack       |
  GNU_STACK == RW   | exec-all  | exec-none        | exec-none        |

correct?

Also note that in addition to marking the changes clearly, I also edited 
the table to be less confusing and more assertive:

   'exec-all'  : all user mappings are executable
   'exec-none' : only PROT_EXEC user mappings are executable
   'exec-stack': only the stack and PROT_EXEC user mappings are executable

Is this correct? (Please double check the edited table.)

In particular, what is the policy for write-only and exec-only mappings, 
what does read-implies-exec do for them?

Also, it would be nice to define it precisely what 'stack' means in this 
context: it's only the ELF loader defined process stack - other stacks 
such as any thread stacks, signal stacks or alt-stacks depend on the C 
library - or does the kernel policy extend there too?

I.e. it would be nice to clarify all this, because it's still rather 
confusing and ambiguous right now.

Thanks,

	Ingo
