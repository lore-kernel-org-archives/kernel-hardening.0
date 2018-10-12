MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com>
 <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
 <CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com>
 <20181012152515.1d816906@alans-desktop> <77F59E25-5244-4CBC-A3CB-DCF863803CD2@amacapital.net>
 <20181012160219.7d16ef59@alans-desktop>
In-Reply-To: <20181012160219.7d16ef59@alans-desktop>
From: Jann Horn <jannh@google.com>
Date: Fri, 12 Oct 2018 17:41:49 +0200
Message-ID: <CAG48ez0r7UL675rxW-EypnfR+tF4LWT_GQkCevg7bTj9TkBM0Q@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, kristen@linux.intel.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 12, 2018 at 5:03 PM Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote=
:
>
> > My understanding is that the standard =E2=80=9Cbreadcrumb=E2=80=9D is t=
hat a cache line is fetched into L1D, and that the cacheline in question wi=
ll go into L1D even if it was previously not cached at all. So flushing L1D=
 will cause the timing from a probe to be different, but the breadcrumb is =
still there, and the attack will still work.
>
> Flush not write back. The L1D is empty (or full of other stuff the way
> the prototype I tested did it as x86 lacked a true L1 flushing primitive)

What about the TLB? Once KPTI is unnecessary, are you going to need an
extra TLB flush here to prevent PRIME+PROBE on the TLB?

Also: Are you assuming that the attacker would only be able to do
PRIME+PROBE, not FLUSH+RELOAD or other attacks that rely on shared
memory (like FLUSH+FLUSH, or the MESI-based stuff that detects when a
line stops being in modified state on another core)?

> > > At best you have a microscopic window to attack it on the SMT pair.
> >
> > So only the extra clever attackers will pull it off. This isn=E2=80=99t=
 all that reassuring.
>
> It's going to be very hard for them to do that. You don't really have the
> timing control in userspace to do that sort of thing easily.
>
> At the end of the day it's an additional hardenening not a fix. It's
> designed to provide extra protection for the cases we don't know about
> until we find them and lfence them. All of this (and all sidechannel of
> any kind) is merely about reducing the bandwidth an attacker can achieve.
>
> The idea is that it's cheap enough that it's worth doing.
>
> > Or I would get a fancy new CPU and use UMONITOR and, unless UMONITOR is=
 much cleverer than I suspect it is, the gig is up.  The time window for th=
e attack could be as small as you want, and UMONITOR will catch it.
>
> That would be an interesting line of attack. You would still have to
> navigate a fair bit of noise.
>
> Alan
