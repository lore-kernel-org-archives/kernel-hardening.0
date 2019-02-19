Date: Tue, 19 Feb 2019 12:04:00 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 14/20] mm: Make hibernate handle unmapped pages
Message-ID: <20190219110400.GA19514@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-15-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190129003422.9328-15-rick.p.edgecombe@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jan 28, 2019 at 04:34:16PM -0800, Rick Edgecombe wrote:
> For architectures with CONFIG_ARCH_HAS_SET_ALIAS, pages can be unmapped
> briefly on the directmap, even when CONFIG_DEBUG_PAGEALLOC is not
> configured. So this changes kernel_map_pages and kernel_page_present to be

s/this changes/change/

>From Documentation/process/submitting-patches.rst:

 "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
  instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
  to do frotz", as if you are giving orders to the codebase to change
  its behaviour."

Also, please end function names with parentheses.

> defined when CONFIG_ARCH_HAS_SET_ALIAS is defined as well. It also changes
> places (page_alloc.c) where those functions are assumed to only be
> implemented when CONFIG_DEBUG_PAGEALLOC is defined.

The commit message doesn't need to say "what" you're doing - that should
be obvious from the diff below. It should rather say "why" you're doing
it.

> So now when CONFIG_ARCH_HAS_SET_ALIAS=y, hibernate will handle not present
> page when saving. Previously this was already done when

pages

> CONFIG_DEBUG_PAGEALLOC was configured. It does not appear to have a big
> hibernating performance impact.

Comment over safe_copy_page() needs updating I guess.

> Before:
> [    4.670938] PM: Wrote 171996 kbytes in 0.21 seconds (819.02 MB/s)
> 
> After:
> [    4.504714] PM: Wrote 178932 kbytes in 0.22 seconds (813.32 MB/s)

IINM, that's like 1734 pages more. How am I to understand this number?

Code has called set_alias_nv_noflush() on them and safe_copy_page() now
maps them one by one to copy them to the hibernation image?

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
