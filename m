Date: Fri, 12 Oct 2018 16:02:19 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Message-ID: <20181012160219.7d16ef59@alans-desktop>
In-Reply-To: <77F59E25-5244-4CBC-A3CB-DCF863803CD2@amacapital.net>
References: <20181011185458.10186-1-kristen@linux.intel.com>
	<CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com>
	<CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
	<CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com>
	<20181012152515.1d816906@alans-desktop>
	<77F59E25-5244-4CBC-A3CB-DCF863803CD2@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> My understanding is that the standard =E2=80=9Cbreadcrumb=E2=80=9D is tha=
t a cache line is fetched into L1D, and that the cacheline in question will=
 go into L1D even if it was previously not cached at all. So flushing L1D w=
ill cause the timing from a probe to be different, but the breadcrumb is st=
ill there, and the attack will still work.

Flush not write back. The L1D is empty (or full of other stuff the way
the prototype I tested did it as x86 lacked a true L1 flushing primitive)
=20
> > At best you have a microscopic window to attack it on the SMT pair. =20
>=20
> So only the extra clever attackers will pull it off. This isn=E2=80=99t a=
ll that reassuring.

It's going to be very hard for them to do that. You don't really have the
timing control in userspace to do that sort of thing easily.

At the end of the day it's an additional hardenening not a fix. It's
designed to provide extra protection for the cases we don't know about
until we find them and lfence them. All of this (and all sidechannel of
any kind) is merely about reducing the bandwidth an attacker can achieve.

The idea is that it's cheap enough that it's worth doing.

> Or I would get a fancy new CPU and use UMONITOR and, unless UMONITOR is m=
uch cleverer than I suspect it is, the gig is up.  The time window for the =
attack could be as small as you want, and UMONITOR will catch it.

That would be an interesting line of attack. You would still have to
navigate a fair bit of noise.

Alan
