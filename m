Date: Wed, 20 Feb 2019 17:07:03 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 14/20] mm: Make hibernate handle unmapped pages
Message-ID: <20190220160703.GD3447@zn.tnic>
References: <20190129003422.9328-1-rick.p.edgecombe@intel.com>
 <20190129003422.9328-15-rick.p.edgecombe@intel.com>
 <20190219110400.GA19514@zn.tnic>
 <07ea2a4a9f1771f7bad82ad8fe5ee9483b79d115.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <07ea2a4a9f1771f7bad82ad8fe5ee9483b79d115.camel@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>, "Dock, Deneen T" <deneen.t.dock@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hpa@zytor.com" <hpa@zytor.com>, "kristen@linux.intel.com" <kristen@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "linux_dti@icloud.com" <linux_dti@icloud.com>, "luto@kernel.org" <luto@kernel.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 19, 2019 at 09:28:55PM +0000, Edgecombe, Rick P wrote:
> These are from logs hibernate generates. The concern was that hibernate could be
> slightly slower because of the checking of whether the pages are mapped. The
> bandwidth number can be used to compare, 819.02->813.32 MB/s. Some randomness
> must have resulted in different amounts of memory used between tests. I can just
> remove the log lines and include the bandwidth numbers.

Nah, I'm just trying to get an idea of the slowdown it would cause. I'm
thinking these pages are, as you call them "special" so they should not
be a huge chunk of all the system's pages, even if it is a machine with
a lot of memory so I guess it ain't that bad. We should keep an eye on
it though... :-)

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
