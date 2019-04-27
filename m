Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 27 Apr 2019 12:22:10 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v6 00/24] x86: text_poke() fixes and executable lockdowns
Message-ID: <20190427102210.GA130188@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
To: nadav.amit@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>


* nadav.amit@gmail.com <nadav.amit@gmail.com> wrote:

> From: Nadav Amit <namit@vmware.com>
> 
> *
> * This version fixes failed boots on 32-bit that were reported by 0day.
> * Patch 5 is added to initialize uprobes during fork initialization.
> * Patch 7 (which was 6 in the previous version) is updated - the code is
> * moved to common mm-init code with no further changes.
> *
> 
> This patchset improves several overlapping issues around stale TLB
> entries and W^X violations. It is combined from "x86/alternative:
> text_poke() enhancements v7" [1] and "Don't leave executable TLB entries
> to freed pages v2" [2] patchsets that were conflicting.

Which tree is this again? It doesn't apply to Linus's latest nor to -tip 
cleanly.

Thanks,

	Ingo
