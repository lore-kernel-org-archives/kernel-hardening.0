Date: Sat, 27 Apr 2019 12:32:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 00/24] x86: text_poke() fixes and executable lockdowns
Message-ID: <20190427103224.GG2623@hirez.programming.kicks-ass.net>
References: <20190426232303.28381-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
To: nadav.amit@gmail.com
Cc: Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2019 at 04:22:39PM -0700, nadav.amit@gmail.com wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> *
> * This version fixes failed boots on 32-bit that were reported by 0day.
> * Patch 5 is added to initialize uprobes during fork initialization.
> * Patch 7 (which was 6 in the previous version) is updated - the code is
> * moved to common mm-init code with no further changes.
> *

I've added patch 5 and updated patch 7, I've left the rest of the
patches from the previous series (and kept my re-ordering of the
patches).

I pushed it all out to 0day again. Let's see if it's happy now.
