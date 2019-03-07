Date: Thu, 7 Mar 2019 21:25:21 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
Message-ID: <20190307202521.GI26566@zn.tnic>
References: <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
 <20190211190108.GP19618@zn.tnic>
 <A671F14F-3E03-4A97-9F54-426533077E0C@gmail.com>
 <20190211191059.GR19618@zn.tnic>
 <3996E3F9-92D2-4561-84E9-68B43AC60F43@gmail.com>
 <20190211194251.GS19618@zn.tnic>
 <20190307072947.GA26566@zn.tnic>
 <EF5F87D9-EA7B-4F92-81C4-329A89EEADFA@zytor.com>
 <20190307170629.GG26566@zn.tnic>
 <CALCETrUY6L_Fwd9CZzo2eZL8HT2sBSHFiD-Bp-HCPPFBxkzcdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrUY6L_Fwd9CZzo2eZL8HT2sBSHFiD-Bp-HCPPFBxkzcdA@mail.gmail.com>
To: Andy Lutomirski <luto@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Nadav Amit <nadav.amit@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 07, 2019 at 12:02:13PM -0800, Andy Lutomirski wrote:
> Should we maybe rename these functions?  static_cpu_has() is at least
> reasonably obvious.  But cpu_feature_enabled() is different for
> reasons I've never understood, and boot_cpu_has() is IMO terribly
> named.  It's not about the boot cpu -- it's about doing the same thing
> but with less bloat and less performance.

Well, it does test bits in boot_cpu_data. I don't care about "boot" in
the name though so feel free to suggest something better.

> (And can we maybe collapse cpu_feature_enabled() and static_cpu_has()
> into the same function?)

I'm not sure it would be always ok to involve the DISABLED_MASK*
buildtime stuff in the checks. It probably is but it would need careful
auditing to be sure, first.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
