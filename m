Date: Mon, 4 Feb 2019 15:28:29 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 03/20] x86/mm: temporary mm struct
Message-ID: <20190204142829.GD29639@zn.tnic>
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
> Having a different struct can prevent the misuse of using mm_structs in
> unuse_temporary_mm() that were not “used” using use_temporary_mm. The
> typedef, I presume, can deter users from starting to play with the internal
> “private” fields.

Ok, makes sense.

> > That prev.prev below looks unnecessary, instead of just using prev.
> > 
> >> +	struct mm_struct *prev;
> > 
> > Why "prev”?
> 
> This is obviously the previous active mm. Feel free to suggest an
> alternative name.

Well, when I look at the typedef I'm wondering why is it called "prev"
but I guess this is to mean that it will be saving the previously used
mm, so ack.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
