MIME-Version: 1.0
References: <20190426001143.4983-1-namit@vmware.com> <20190426001143.4983-15-namit@vmware.com>
In-Reply-To: <20190426001143.4983-15-namit@vmware.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Apr 2019 09:40:29 -0700
Message-ID: <CAADWXX8yZJ9Z4yfqG9wQcb2r+0O7VCk2uQLcOU1=-BOnYhjnow@mail.gmail.com>
Subject: Re: [PATCH v5 14/23] x86/mm/cpa: Add set_direct_map_ functions
Content-Type: text/plain; charset="UTF-8"
To: Nadav Amit <namit@vmware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, kristen@linux.intel.com, deneen.t.dock@intel.com, Rick Edgecombe <rick.p.edgecombe@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Nadav,

I get

       dmarc=fail (p=QUARANTINE sp=NONE dis=QUARANTINE) header.from=vmware.com

for these emails, because they lack the vmware DKIM signature.

It clearly did go through some vmware mail servers, but apparently not
the *right* external vmware SMTP gateway.

Please check with vmware MIS what the right SMTP setup for git-send-email is.

                 Linus

On Fri, Apr 26, 2019 at 12:32 AM Nadav Amit <namit@vmware.com> wrote:
>
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
>
> Add two new functions set_direct_map_default_noflush() and
> set_direct_map_invalid_noflush() for setting the direct map alias for the
> page to its default valid permissions and to an invalid state that cannot
> be cached in a TLB, respectively. These functions do not flush the TLB.
...
