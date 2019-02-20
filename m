Date: Wed, 20 Feb 2019 17:14:12 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 15/20] vmalloc: New flags for safe vfree on special
 perms
Message-ID: <20190220161412.GE3447@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-16-rick.p.edgecombe@intel.com>
 <20190219124853.GB19514@zn.tnic>
 <b01f3fafb44c31842f897d3f62b5b9ccc1306ec5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b01f3fafb44c31842f897d3f62b5b9ccc1306ec5.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 07:42:53PM +0000, Edgecombe, Rick P wrote:
> So to capture both of those intentions, maybe I'll slightly tweak your
> suggestion to VM_FLUSH_RESET_PERMS?

Yeah, sure, better.

VM_HAS_SPECIAL_PERMS doesn't tell me what those special permissions are
while flush and reset permissions makes a lot more sense, thx.

> I had thought it was easier to read. If its not the case, I'll change it as you
> suggest.

My logic is, the less local vars, the easier to scan the code quickly.

> Ard had expressed interest in having the set_alias_() functions for Arm, and the
> names were chosen to be arch agnostic. He didn't explicitly commit but I was
> under the impression he might create an implementation for ARM and we could
> remove this block.

Yeah, Will has those on his radar too so we should be good here.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
