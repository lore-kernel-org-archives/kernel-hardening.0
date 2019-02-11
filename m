MIME-Version: 1.0
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-14-rick.p.edgecombe@intel.com> <20190211190925.GQ19618@zn.tnic>
In-Reply-To: <20190211190925.GQ19618@zn.tnic>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 11 Feb 2019 14:59:55 -0800
Message-ID: <CALCETrX2AOTTZOQafZgOFxiQsFgdYHVaLonXTqTa3RUs5MPVUQ@mail.gmail.com>
Subject: Re: [PATCH v2 13/20] Add set_alias_ function and x86 implementation
Content-Type: text/plain; charset="UTF-8"
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 11:09 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Mon, Jan 28, 2019 at 04:34:15PM -0800, Rick Edgecombe wrote:
> > This adds two new functions set_alias_default_noflush and
>
> s/This adds/Add/
>
> > set_alias_nv_noflush for setting the alias mapping for the page to its
>
> Please end function names with parentheses, below too.
>
> > default valid permissions and to an invalid state that cannot be cached in
> > a TLB, respectively. These functions to not flush the TLB.
>
> s/to/do/
>
> Also, pls put that description as comments over the functions in the
> code. Otherwise that "nv" as part of the name doesn't really explain
> what it does.
>
> Actually, you could just as well call the function
>
> set_alias_invalid_noflush()
>
> All the other words are written in full, no need to have "nv" there.

Why are you calling this an "alias"?  You're modifying the direct map.
Your patches are thinking of the direct map as an alias of the vmap
mapping, but that does seem a bit backwards.  How about
set_direct_map_invalid_noflush(), etc?

--Andy
