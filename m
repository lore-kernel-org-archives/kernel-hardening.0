From: Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH v2 06/20] x86/alternative: use temporary mm for text
 poking
Date: Tue, 5 Feb 2019 17:54:56 +0000
Message-ID: <6D321F51-6B19-46F6-91AC-74248A542BA0@vmware.com>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-7-rick.p.edgecombe@intel.com>
 <20190205095853.GJ21801@zn.tnic>
 <20190205113146.GP17528@hirez.programming.kicks-ass.net>
 <20190205123533.GN21801@zn.tnic>
In-Reply-To: <20190205123533.GN21801@zn.tnic>
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F6D00271B554CB47B00297C100C54604@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Damian Tometzki <linux_dti@icloud.com>, linux-integrity <linux-integrity@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@intel.com>, Masami Hiramatsu <mhiramat@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Feb 5, 2019, at 4:35 AM, Borislav Petkov <bp@alien8.de> wrote:
>=20
> On Tue, Feb 05, 2019 at 12:31:46PM +0100, Peter Zijlstra wrote:
>> ...
>>=20
>> So while in general I agree with BUG_ON() being undesirable, I think
>> liberal sprinking in text_poke() is fine; you really _REALLY_ want this
>> to work or fail loudly. Text corruption is just painful.
>=20
> Ok. It would be good to have the gist of this sentiment in a comment
> above it so that it is absolutely clear why we're doing it.

I added a short comment for v3 above each BUG_ON().

> And since text_poke() can't fail, then it doesn't need a retval too.
> AFAICT, nothing is actually using it.

As Peter said, this is addressed in a separate patch (one patch per logical
change).
