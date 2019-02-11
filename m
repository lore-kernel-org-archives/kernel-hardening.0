Date: Mon, 11 Feb 2019 20:09:25 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 13/20] Add set_alias_ function and x86 implementation
Message-ID: <20190211190925.GQ19618@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-14-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-14-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 04:34:15PM -0800, Rick Edgecombe wrote:
> This adds two new functions set_alias_default_noflush and

s/This adds/Add/

> set_alias_nv_noflush for setting the alias mapping for the page to its

Please end function names with parentheses, below too.

> default valid permissions and to an invalid state that cannot be cached in
> a TLB, respectively. These functions to not flush the TLB.

s/to/do/

Also, pls put that description as comments over the functions in the
code. Otherwise that "nv" as part of the name doesn't really explain
what it does.

Actually, you could just as well call the function

set_alias_invalid_noflush()

All the other words are written in full, no need to have "nv" there.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
