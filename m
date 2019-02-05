Date: Tue, 5 Feb 2019 14:25:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 06/20] x86/alternative: use temporary mm for text
 poking
Message-ID: <20190205132507.GS17528@hirez.programming.kicks-ass.net>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-7-rick.p.edgecombe@intel.com>
 <20190205095853.GJ21801@zn.tnic>
 <20190205113146.GP17528@hirez.programming.kicks-ass.net>
 <20190205123533.GN21801@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190205123533.GN21801@zn.tnic>
To: Borislav Petkov <bp@alien8.de>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>, Nadav Amit <nadav.amit@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, linux_dti@icloud.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, akpm@linux-foundation.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, will.deacon@arm.com, ard.biesheuvel@linaro.org, kristen@linux.intel.com, deneen.t.dock@intel.com, Nadav Amit <namit@vmware.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 05, 2019 at 01:35:33PM +0100, Borislav Petkov wrote:
> On Tue, Feb 05, 2019 at 12:31:46PM +0100, Peter Zijlstra wrote:
> > ...
> >
> > So while in general I agree with BUG_ON() being undesirable, I think
> > liberal sprinking in text_poke() is fine; you really _REALLY_ want this
> > to work or fail loudly. Text corruption is just painful.
> 
> Ok. It would be good to have the gist of this sentiment in a comment
> above it so that it is absolutely clear why we're doing it.
> 
> And since text_poke() can't fail, then it doesn't need a retval too.
> AFAICT, nothing is actually using it.

See patch 12, that removes the return value (after fixing the few users
that currently 'rely' on it).
