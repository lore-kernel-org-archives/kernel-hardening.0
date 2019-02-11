Date: Mon, 11 Feb 2019 20:01:08 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 10/20] x86: avoid W^X being broken during modules
 loading
Message-ID: <20190211190108.GP19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-11-rick.p.edgecombe@intel.com>
 <20190211182956.GN19618@zn.tnic>
 <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1533F2BB-2284-499B-9912-6D74D0B87BC1@gmail.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 10:45:26AM -0800, Nadav Amit wrote:
> Are you sure about that? This path is still used when modules are loaded.

Yes, I'm sure. Loading a module does a gazillion things so saving a
couple of insns - yes, boot_cpu_has() is usually a RIP-relative MOV and a
TEST - doesn't show even as a blip on any radar.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
