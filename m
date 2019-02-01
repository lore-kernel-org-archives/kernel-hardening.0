Date: Fri, 1 Feb 2019 01:08:12 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 03/20] x86/mm: temporary mm struct
Message-ID: <20190201000812.GP6749@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-4-rick.p.edgecombe@intel.com>
 <20190131112948.GE6749@zn.tnic>
 <C481E605-E19A-4EA6-AB9A-6FF4229789E0@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C481E605-E19A-4EA6-AB9A-6FF4229789E0@vmware.com>
To: Nadav Amit <namit@vmware.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 31, 2019 at 10:19:54PM +0000, Nadav Amit wrote:
> Meta-question: could you please review the entire patch-set? This is
> actually v9 of this particular patch - it was part of a separate patch-set
> before. I don’t think that the patch has changed since (the real) v1.
> 
> These sporadic comments after each version really makes it hard to get this
> work completed.

Sorry but where I am the day has only 24 hours and this patchset is not
the only one in my overflowing mbox. If my sporadic comments are making
it hard to finish your work, I better not interfere then.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
