Date: Thu, 7 Mar 2019 18:02:54 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86/cpufeature: Remove __pure attribute to
 _static_cpu_has()
Message-ID: <20190307170254.GF26566@zn.tnic>
References: <20190211182956.GN19618@zn.tnic>
 <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
 <20190211190108.GP19618@zn.tnic>
 <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com>
 <20190211191059.GR19618@zn.tnic>
 <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
 <20190211194251.GS19618@zn.tnic>
 <A55214F3-CDC0-44C4-AFB6-7E8E23CC6F85@gmail.com>
 <20190307151036.GD26566@zn.tnic>
 <D683E00D-845E-4970-80DE-AD1DED3AE609@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <D683E00D-845E-4970-80DE-AD1DED3AE609@zytor.com>
To: hpa@zytor.com
Cc: Nadav Amit <nadav.amit@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>, Michael Matz <matz@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

Lemme preface this by saying that I've talked to gcc guys before doing
this.

On Thu, Mar 07, 2019 at 08:43:50AM -0800, hpa@zytor.com wrote:
> Uhm... (a) it is correct, even if the compiler doesn't use it now, it
> allows the compiler to CSE it in the future;

Well, the compiler won't CSE asm blocks due to the difference in the
labels, for example, so the heuristic won't detect them as equivalent
blocks.

Also, compiler guys said that they might consider inlining pure
functions later, in the IPA stage but that's future stuff.

This is how I understood it, at least.

> (b) it is documentation;

That could be a comment instead. Otherwise we will wonder again why this
is marked pure.

> (c) there is an actual bug here: the "volatile" implies a side effect,
> which in reality is not present, inhibiting CSE.
>
> So the correct fix is to remove "volatile", not remove "__pure".

There's not really a volatile there:

/*
 * GCC 'asm goto' miscompiles certain code sequences:
 *
 *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
 *
 * Work it around via a compiler barrier quirk suggested by Jakub Jelinek.
 *
 * (asm goto is automatically volatile - the naming reflects this.)
 */
#define asm_volatile_goto(x...) do { asm goto(x); asm (""); } while (0)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
