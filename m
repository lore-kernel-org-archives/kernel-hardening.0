Date: Fri, 22 Feb 2019 17:14:19 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 00/20] Merge text_poke fixes and executable lockdowns
Message-ID: <20190222161419.GB30766@zn.tnic>
References: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190221234451.17632-1-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 03:44:31PM -0800, Rick Edgecombe wrote:
> Changes v2 to v3:
>  - Fix commit messages and comments [Boris]
>  - Rename VM_HAS_SPECIAL_PERMS [Boris]
>  - Remove unnecessary local variables [Boris]
>  - Rename set_alias_*() functions [Boris, Andy]
>  - Save/restore DR registers when using temporary mm
>  - Move line deletion from patch 10 to patch 17

In your previous submission there was a patch called

Subject: [PATCH v2 01/20] Fix "x86/alternatives: Lockdep-enforce text_mutex in text_poke*()"

What happened to it?

It did introduce a function text_poke_kgdb(), a.o., and I see this
function in the diff contexts in some of the patches in this submission
so it looks to me like you missed that first patch when submitting v3?

Or am *I* missing something?

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
