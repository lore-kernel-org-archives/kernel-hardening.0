MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrW5sNz-TO8w8e+7d1oD_CmnUX_txnBuKe2+wM7qFaK64A@mail.gmail.com>
 <CAEX_ruGcWOYuhF6Gtm0a9kh8JsUvZzRLxzi8Q982iiWA2ioYpg@mail.gmail.com> <CAG48ez0aTJMREb1JL6SaT5rNLs6oUZVevj+BGrUzVEprZNFKOw@mail.gmail.com>
In-Reply-To: <CAG48ez0aTJMREb1JL6SaT5rNLs6oUZVevj+BGrUzVEprZNFKOw@mail.gmail.com>
From: Samuel Neves <sneves@dei.uc.pt>
Date: Fri, 12 Oct 2018 15:28:01 +0100
Message-ID: <CAEX_ruHf5hDTvL+4BNyL8HsTjKKU+fvAB4uKrszVVfpPen25Mw@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
To: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, bp@alien8.de, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 12, 2018 at 2:26 PM Jann Horn <jannh@google.com> wrote:
>
> On Fri, Oct 12, 2018 at 11:41 AM Samuel Neves <sneves@dei.uc.pt> wrote:
> >
> > On Thu, Oct 11, 2018 at 8:25 PM Andy Lutomirski <luto@kernel.org> wrote:
> > > What exactly is this trying to protect against?  And how many cycles
> > > should we expect L1D_FLUSH to take?
> >
> > As far as I could measure, I got 1660 cycles per wrmsr 0x10b, 0x1 on a
> > Skylake chip, and 1220 cycles on a Skylake-SP.
>
> Is that with L1D mostly empty, with L1D mostly full with clean lines,
> or with L1D full of dirty lines that need to be written back?

Mostly empty, as this is flushing repeatedly without bothering to
refill L1d with anything.

On Skylake the (averaged) uops breakdown is something like

port 0: 255
port 1: 143
port 2: 176
port 3: 177
port 4: 524
port 5: 273
port 6: 616
port 7: 182

The number of port 4 dispatches is very close to the number of cache
lines, suggesting one write per line (with respective 176+177+182 port
{2, 3, 7} address generations).

Furthermore, I suspect it also clears L1i cache. For 2^20 wrmsr
executions, we have around 2^20 frontend_retired_l1i_miss events, but
a negligible amount of frontend_retired_l2_miss ones.
