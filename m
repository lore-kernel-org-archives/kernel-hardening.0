Date: Thu, 25 Apr 2019 18:36:50 +0200
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v4 04/23] x86/mm: Save DRs when loading a temporary mm
Message-ID: <20190425163650.GB5199@zn.tnic>
References: <20190422185805.1169-1-rick.p.edgecombe@intel.com>
 <20190422185805.1169-5-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190422185805.1169-5-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>
List-ID: <kernel-hardening.lists.openwall.com>


> Subject: Re: [PATCH v4 04/23] x86/mm: Save DRs when loading a temporary mm

s/DRs/debug registers/

On Mon, Apr 22, 2019 at 11:57:46AM -0700, Rick Edgecombe wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> Prevent user watchpoints from mistakenly firing while the temporary mm
> is being used. As the addresses that of the temporary mm might overlap

s/that //

> those of the user-process, this is necessary to prevent wrong signals
> or worse things from happening.
> 
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Nadav Amit <namit@vmware.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/mmu_context.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
