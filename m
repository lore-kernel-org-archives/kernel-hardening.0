Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
From: Andy Lutomirski <luto@amacapital.net>
In-Reply-To: <20181012152515.1d816906@alans-desktop>
Date: Fri, 12 Oct 2018 07:43:09 -0700
Content-Transfer-Encoding: quoted-printable
Message-Id: <77F59E25-5244-4CBC-A3CB-DCF863803CD2@amacapital.net>
References: <20181011185458.10186-1-kristen@linux.intel.com> <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com> <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com> <CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com> <20181012152515.1d816906@alans-desktop>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



On Oct 12, 2018, at 7:25 AM, Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote:

>> But this really needs to be clarified.  Alan said that a bunch of the
>> "yet another Spectre variant" attacks would have been mitigated by
>> this patch.  An explanation of *how* would be in order.
>=20
> Today you have the situation where something creates a speculative
> disclosure gadget. So we run around and we try and guess where to fix
> them all with lfence. If you miss one then it leaves a trace in the L1D
> cache, which is what you measure.
>=20
> In almost every case we have looked at when you leave a footprint in the
> L1D you resolve to an error path so the syscall errors.
>=20
> In other words every time we fail to find a
>=20
>                if (foo < limit) {
>                        gadget(array[foo]);
>        } else
>            return -EINVAL;
>=20
> we turn that from being an easy to use gadget into something really
> tricky because by the time the code flow has gotten back to the caller
> the breadcrumbs have been eaten by the L1D flush.

My understanding is that the standard =E2=80=9Cbreadcrumb=E2=80=9D is that a=
 cache line is fetched into L1D, and that the cacheline in question will go i=
nto L1D even if it was previously not cached at all. So flushing L1D will ca=
use the timing from a probe to be different, but the breadcrumb is still the=
re, and the attack will still work.

Am I wrong?

>=20
>=20
> At best you have a microscopic window to attack it on the SMT pair.

So only the extra clever attackers will pull it off. This isn=E2=80=99t all t=
hat reassuring.

If I had the time to try to break this, I would set it up so that the cache l=
ines that get probed are cached remotely, and I=E2=80=99d spin, waiting unti=
l one of them gets stolen. The spin loop would be much faster this way.

Or I would get a fancy new CPU and use UMONITOR and, unless UMONITOR is much=
 cleverer than I suspect it is, the gig is up.  The time window for the atta=
ck could be as small as you want, and UMONITOR will catch it.

(Have I mentioned that I think that Intel needs to remove UMONITOR, PCOMMIT-=
style?  That instruction is simply the wrong solution to whatever problem it=
=E2=80=99s trying to solve.)

>=20
> Alan
