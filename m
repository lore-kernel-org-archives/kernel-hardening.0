Date: Wed, 24 Apr 2019 21:51:17 +0100
From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2] binfmt_elf: Update READ_IMPLIES_EXEC logic for modern
 CPUs
Message-ID: <20190424205117.GA5291@brain-police>
References: <20190424203408.GA11386@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190424203408.GA11386@beast>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hector Marco-Gisbert <hecmargi@upv.es>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Jason Gunthorpe <jgg@mellanox.com>, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>, Linux ARM <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 24, 2019 at 01:34:08PM -0700, Kees Cook wrote:
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
> 
> [1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
> 
> Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2: adjust arm64 to avoid is_compat_task() (marc.w.gonzalez)
> ---
>  arch/arm64/include/asm/elf.h |  8 +++++++-
>  arch/x86/include/asm/elf.h   | 24 +++++++++++++++++++++---
>  2 files changed, 28 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
> index 6adc1a90e7e6..f1bb4b388b8f 100644
> --- a/arch/arm64/include/asm/elf.h
> +++ b/arch/arm64/include/asm/elf.h
> @@ -107,7 +107,13 @@
>   */
>  #define elf_check_arch(x)		((x)->e_machine == EM_AARCH64)
>  
> -#define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
> +/*
> + * 64-bit processes should not automatically gain READ_IMPLIES_EXEC. Only
> + * 32-bit processes without PT_GNU_STACK should trigger READ_IMPLIES_EXEC
> + * out of an abundance of caution against ancient toolchains not knowing
> + * how to mark memory protection flags correctly.
> + */
> +#define compat_elf_read_implies_exec(ex, stk)	(stk == EXSTACK_DEFAULT)

Don't you need to hack fs/compat_binfmt_elf.c to pick this up, or am I
missing some trick? Should just be something like below.

Will

--->8

diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 15f6e96b3bd9..694bc3ee77eb 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -116,6 +116,11 @@
 #define	arch_setup_additional_pages compat_arch_setup_additional_pages
 #endif
 
+#ifdef compat_elf_read_implies_exec
+#undef elf_read_implies_exec
+#define elf_read_implies_exec compat_elf_read_implies_exec
+#endif
+
 /*
  * Rename a few of the symbols that binfmt_elf.c will define.
  * These are all local so the names don't really matter, but it
