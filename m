Date: Thu, 25 Apr 2019 22:49:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v4 00/23] Merge text_poke fixes and executable lockdowns
Message-ID: <20190425204904.GE14281@hirez.programming.kicks-ass.net>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
 <20190425204820.GB12232@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425204820.GB12232@hirez.programming.kicks-ass.net>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 25, 2019 at 10:48:20PM +0200, Peter Zijlstra wrote:
> On Mon, Apr 22, 2019 at 11:57:42AM -0700, Rick Edgecombe wrote:
> > Andy Lutomirski (1):
> >   x86/mm: Introduce temporary mm structs
> > 
> > Nadav Amit (15):
> >   Fix "x86/alternatives: Lockdep-enforce text_mutex in text_poke*()"
> >   x86/jump_label: Use text_poke_early() during early init
> >   x86/mm: Save DRs when loading a temporary mm
> >   fork: Provide a function for copying init_mm
> >   x86/alternative: Initialize temporary mm for patching
> >   x86/alternative: Use temporary mm for text poking
> >   x86/kgdb: Avoid redundant comparison of patched code
> >   x86/ftrace: Set trampoline pages as executable
> >   x86/kprobes: Set instruction page as executable
> >   x86/module: Avoid breaking W^X while loading modules
> >   x86/jump-label: Remove support for custom poker
> >   x86/alternative: Remove the return value of text_poke_*()
> >   x86/alternative: Comment about module removal races
> >   tlb: provide default nmi_uaccess_okay()
> >   bpf: Fail bpf_probe_write_user() while mm is switched
> > 
> > Rick Edgecombe (7):
> >   x86/mm/cpa: Add set_direct_map_ functions
> >   mm: Make hibernate handle unmapped pages
> >   vmalloc: Add flag for free of special permsissions
> >   modules: Use vmalloc special flag
> >   bpf: Use vmalloc special flag
> >   x86/ftrace: Use vmalloc special flag
> >   x86/kprobes: Use vmalloc special flag
> 
> This all looks good to me, I'll queue them tomorrow when I'm awake
> again. I'll move the last two patches to early in the series, since it
> appears to me they're fixes and should be in place before we make the
> situation worse with the temporary mm swizzling for text_poke.
> 
> If you want to post a new version of patch 4 before then, that'd be
> awesome, otherwise I'll see if I can do those few edits myself.

Patch 3 that was, see, I can't even count straight atm :-)
