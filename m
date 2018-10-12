MIME-Version: 1.0
References: <20181011185458.10186-1-kristen@linux.intel.com>
 <CALCETrVaZu2eq67ai0Oh=HWyZKg-OaoZx7yUT2AvStAhQ+rxyQ@mail.gmail.com>
 <CAGXu5jLWO1StCz2ejBPW-p4B5XHEKdCGvOi1JKrKxg5UFSa3Ag@mail.gmail.com>
 <CALCETrVG5=iqfohYxKSvAQx3DhzD95MhmDU3mU8+kCegps2cbw@mail.gmail.com>
 <20181012152515.1d816906@alans-desktop> <77F59E25-5244-4CBC-A3CB-DCF863803CD2@amacapital.net>
 <20181012160219.7d16ef59@alans-desktop>
In-Reply-To: <20181012160219.7d16ef59@alans-desktop>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 12 Oct 2018 09:07:39 -0700
Message-ID: <CALCETrWTHtqdQNQmk9taMRxOOEE8XanibEbP73AQNvNKJZjrEg@mail.gmail.com>
Subject: Re: [PATCH] x86: entry: flush the cache if syscall error
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Andrew Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Kristen Carlson Accardi <kristen@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 12, 2018 at 8:02 AM Alan Cox <gnomes@lxorguk.ukuu.org.uk> wrote=
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

I'm not sure I follow what you're saying.  If an attacker is learning
some information based on whether a given cacheline is in L1D, I'm
asking why the attacker can't learn exactly the same information based
on whether the cache line is in L2.  Or using any of the other
variants that Jann is talking about.

Adding ~1600 cycles plus the slowdown due to the fact that the cache
got flushed to a code path that we hope isn't hot to mitigate one
particular means of exploiting potential bugs seems a bit dubious to
me.
