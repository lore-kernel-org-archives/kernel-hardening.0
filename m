Date: Mon, 11 Feb 2019 20:42:51 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
Message-ID: <20190211194251.GS19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-11-rick.p.edgecombe@intel.com>
 <20190211182956.GN19618@zn.tnic>
 <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
 <20190211190108.GP19618@zn.tnic>
 <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com>
 <20190211191059.GR19618@zn.tnic>
 <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 11:27:03AM -0800, Nadav Amit wrote:
> Is there any comment over static_cpu_has()? ;-)

Almost:

/*
 * Static testing of CPU features.  Used the same as boot_cpu_has().
 * These will statically patch the target code for additional
 * performance.
 */
static __always_inline __pure bool _static_cpu_has(u16 bit)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
