MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com> <CAEX_ruGcWOYuhF6Gtm0a9kh8JsUvZzRLxzi8Q982iiWA2ioYpg@mail.gmail.com>
In-Reply-To: <CAEX_ruGcWOYuhF6Gtm0a9kh8JsUvZzRLxzi8Q982iiWA2ioYpg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 12 Oct 2018 15:25:46 +0200
Message-ID: <CAG48ez0aTJMREb1JL6SaT5rNLs6oUZVevj+BGrUzVEprZNFKOw@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: sneves@dei.uc.pt
Cc: Andy Lutomirski <luto@kernel.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 12, 2018 at 11:41 AM Samuel Neves <sneves@dei.uc.pt> wrote:
>
> On Thu, Oct 11, 2018 at 8:25 PM Andy Lutomirski <luto@kernel.org> wrote:
> > What exactly is this trying to protect against?  And how many cycles
> > should we expect L1D_FLUSH to take?
>
> As far as I could measure, I got 1660 cycles per wrmsr 0x10b, 0x1 on a
> Skylake chip, and 1220 cycles on a Skylake-SP.

Is that with L1D mostly empty, with L1D mostly full with clean lines,
or with L1D full of dirty lines that need to be written back?
