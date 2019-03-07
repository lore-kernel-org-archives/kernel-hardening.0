Date: Thu, 7 Mar 2019 18:06:29 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
Message-ID: <20190307170629.GG26566@zn.tnic>
References: <20190129003422.9328-11-rick.p.edgecombe@intel.com>
 <20190211182956.GN19618@zn.tnic>
 <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
 <20190211190108.GP19618@zn.tnic>
 <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com>
 <20190211191059.GR19618@zn.tnic>
 <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
 <20190211194251.GS19618@zn.tnic>
 <20190307072947.GA26566@zn.tnic>
 <EF5F87D9-EA7B-4F92-81C4-329A89EEADFA@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <EF5F87D9-EA7B-4F92-81C4-329A89EEADFA@zytor.com>
To: hpa@zytor.com
Cc: Nadav Amit <nadav.amit@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 07, 2019 at 08:53:34AM -0800, hpa@zytor.com wrote:
> If we *do*, what is the issue here? Although boot_cpu_has() isn't
> slow (it should in general be possible to reduce to one testb
> instruction followed by a conditional jump) it seems that "avoiding an
> alternatives slot" *should* be a *very* weak reason, and seems to me
> to look like papering over some other problem.

Forget the current thread: this is simply trying to document when to use
static_cpu_has() and when to use boot_cpu_has(). I get asked about it at
least once a month.

And then it is replacing clear slow paths using static_cpu_has() with
boot_cpu_has() because there's purely no need to patch there. And having
a RIP-relative MOV and a JMP is good enough for slow paths.

Makes sense?

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
